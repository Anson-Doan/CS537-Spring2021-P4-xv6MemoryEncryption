#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}


// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    //if (!alloc)
      //cprintf("page directory is good\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}


// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & (PTE_P | PTE_E))
      panic("p4Debug, remapping page");

    if (perm & PTE_E)
      *pte = pa | perm | PTE_E;
    else
      *pte = pa | perm | PTE_P;


    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) // TODO: Add queue code to this
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & (PTE_P | PTE_E)) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & (PTE_P | PTE_E)){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("p4Debug: inside copyuvm, pte should exist");
    if(!(*pte & (PTE_P | PTE_E)))
      panic("p4Debug: inside copyuvm, page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  // p4Debug: Check for page's present and encrypted flags.
  if(((*pte & PTE_P) | (*pte & PTE_E)) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
    {
      //p4Debug : Cannot find page in kernel space.
      return -1;
    }
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//This function is just like uva2ka but sets the PTE_E bit and clears PTE_P
char* translate_and_set(pde_t *pgdir, char *uva) {
  cprintf("p4Debug: setting PTE_E for %p, VPN %d\n", uva, PPN(uva));
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);

  //p4Debug: If page is not present AND it is not encrypted.
  if((*pte & PTE_P) == 0 && (*pte & PTE_E) == 0)
    return 0;
  //p4Debug: If page is already encrypted, i.e. PTE_E is set, return NULL as error;
  if((*pte & PTE_E)) {
    return 0;
  }
  // p4Debug: Check if users are allowed to use this page
  if((*pte & PTE_U) == 0)
    return 0;
  //p4Debug: Set Page as encrypted and not present so that we can trap(see trap.c) to decrypt page
  cprintf("p4Debug: PTE was %x and its pointer %p\n", *pte, pte);
  *pte = *pte | PTE_E;
  *pte = *pte & ~PTE_P;
  *pte = *pte & ~PTE_A;
  cprintf("p4Debug: PTE is now %x\n", *pte);
  return (char*)P2V(PTE_ADDR(*pte));
}

//Enqueues things. Evicts them too!
void enqueue(char * virtual_addr, struct proc * p, pde_t* mypd) {


  // iterate the not-full queue and find an empty spot for the page
  int i;
  for (i = 0; i < CLOCKSIZE; i++) {

    //if queue has an empty spot, add it.
    if (!(p->clock_queue[i].is_full)) {
      p->clock_queue[i].va = virtual_addr; // Set the virtal address
      p->clock_queue[i].is_full = 1;
      p->clock_queue[i].pte = walkpgdir(mypd, virtual_addr, 0);

      cprintf("PTE_A: %x VA: %p\n", *p->clock_queue[i].pte & PTE_A, p->clock_queue[i].va);

      p->q_count++;
      i = -1;
      break; // empty spot was filled so break the loop
    }
  }
  

  // If the Queue is full, now need to iterate through the pages and check if the PTE_A bit = 0
  if (i != -1) {// For loop goes here
  
    i = 0;
    //int k = 0;
    for (;;p->q_head = p->q_head->next) {

      //cprintf("count: %d\n", p->q_count);
      //if (p->q_head >= p->q_count) { p->q_head = 0; } // The count here is always 8
      pte_t * curr_pte = walkpgdir(mypd, p->q_head->va, 0);
      if (*curr_pte & PTE_A) {
        *curr_pte = *curr_pte & ~PTE_A;
      } else {
        //Eviction code
        mencrypt(p->q_head->va, 1);
        // New node
        p->q_head->va = virtual_addr; // Set the virtal address
        p->q_head->pte = walkpgdir(mypd, virtual_addr, 0);
        cprintf("PTE_A: %x VA: %p\n", *p->q_head->pte & PTE_A, p->q_head->va);
        break;
      }
    }
    //cprintf("p->q_head index: %d\n", p->q_head);

      

  }

  // for (int i = 0; i < CLOCKSIZE; i++){
  //       pte_t *this_pte = p->clock_queue[i].pte;
  //       int a_bit = 0;

  //   if (*this_pte & PTE_A) {
  //     a_bit = 1;
  //   }
  //   cprintf("node x -- va: %p access: %d\n accessed: ", p->clock_queue[i].va, a_bit);
  // }
}


int mdecrypt(char *virtual_addr) {

  // After the page is decrypted, check which page needs to be evicted in queue, and add new page to it
  // AND the bit you’re looking for with the pte entry and do some logic checking - to check bits

  cprintf("p4Debug:  mdecrypt VPN %d, %p, pid %d\n", PPN(virtual_addr), virtual_addr, myproc()->pid);
  //p4Debug: virtual_addr is a virtual address in this PID's userspace.
  struct proc * p = myproc();
  pde_t* mypd = p->pgdir;
  //set the present bit to true and encrypt bit to false
  pte_t * pte = walkpgdir(mypd, virtual_addr, 0);
  if (!pte || *pte == 0) {
    cprintf("p4Debug: walkpgdir failed\n");
    return -1;
  }
  cprintf("p4Debug: pte was %x\n", *pte);
  *pte = *pte & ~PTE_E;
  *pte = *pte | PTE_P;
  *pte = *pte | PTE_A;
  cprintf("p4Debug: pte is %x\n", *pte);
  char * original = uva2ka(mypd, virtual_addr) + OFFSET(virtual_addr);
  cprintf("p4Debug: Original in decrypt was %p\n", original);
  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
  cprintf("p4Debug: mdecrypt: rounded down va is %p\n", virtual_addr);

  char * kvp = uva2ka(mypd, virtual_addr);
  if (!kvp || *kvp == 0) {
    return -1;
  }
  char * slider = virtual_addr;
  for (int offset = 0; offset < PGSIZE; offset++) {
    *slider = *slider ^ 0xFF;
    slider++;
  }

  enqueue(virtual_addr, p, mypd);


  // Print statement to see what is in the array.



  //else, iterate through and find a page with PTE_A = 0. Evict that page. Add new page in same spot
  // for (int i = 0; i < proc->clock_queue; i++) {

  //     //if queue has an empty spot, add it.
  //     if (proc->clock_queue[i].PTE_A == 0) {
  //         proc->clock_queue[i].vpn = 100; // Set the page address, check mmu.h
  //     }
  // }
  switchuvm(p);

  

  return 0;
}

int mencrypt(char *virtual_addr, int len) {

  cprintf("p4Debug: mencrypt: %p %d\n", virtual_addr, len);
  //the given pointer is a virtual address in this pid's userspace
  struct proc * p = myproc();
  pde_t* mypd = p->pgdir;

  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);

  //error checking first. all or nothing.
  char * slider = virtual_addr;
  for (int i = 0; i < len; i++) { 
    //check page table for each translation first
    char * kvp = uva2ka(mypd, slider);
    cprintf("p4Debug: slider %p, kvp for err check is %p\n",slider, kvp);
    if (!kvp) {
      cprintf("p4Debug: mencrypt: kvp = NULL\n");
      return -1;
    }
    slider = slider + PGSIZE;
  }

  //encrypt stage. Have to do this before setting flag 
  //or else we'll page fault
  slider = virtual_addr;
  for (int i = 0; i < len; i++) {
    cprintf("p4Debug: mencryptr: VPN %d, %p\n", PPN(slider), slider);
    //kvp = kernel virtual pointer
    //virtual address in kernel space that maps to the given pointer
    char * kvp = uva2ka(mypd, slider);
    cprintf("p4Debug: kvp for encrypt stage is %p\n", kvp);
    pte_t * mypte = walkpgdir(mypd, slider, 0);
    cprintf("p4Debug: pte is %x\n", *mypte);
    if (*mypte & PTE_E) {
      cprintf("p4Debug: already encrypted\n");
      slider += PGSIZE;
      continue;
    }
    for (int offset = 0; offset < PGSIZE; offset++) {
      *slider = *slider ^ 0xFF;
      slider++;
    }
    char * kvp_translated = translate_and_set(mypd, slider-PGSIZE);
    if (!kvp_translated) {
      cprintf("p4Debug: translate failed!");
      return -1;
    }
  }

  switchuvm(myproc());
  return 0;
}

int not_in_queue(pte_t * pte) {
  struct proc * p = myproc();

  for (int i = 0; i < CLOCKSIZE; i++) {
    if (pte == walkpgdir(p->pgdir, p->clock_queue[i].va, 0)) { return 0; }
  }
  return 1;
}

int getpgtable(struct pt_entry* pt_entries, int num, int wsetOnly) {
  cprintf("p4Debug: getpgtable: %p, %d\n", pt_entries, num);

  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  uint uva = 0;
  if (curproc->sz % PGSIZE == 0)
    uva = curproc->sz - PGSIZE;
  else 
    uva = PGROUNDDOWN(curproc->sz);

  int i = 0;
  for (;;uva -=PGSIZE)
  {
    
    pte_t *pte = walkpgdir(pgdir, (const void *)uva, 0);

    if (!(*pte & PTE_U) || !(*pte & (PTE_P | PTE_E)))
      continue;
    
    if (wsetOnly && not_in_queue(pte)) {
      continue;
    }

    pt_entries[i].pdx = PDX(uva);
    pt_entries[i].ptx = PTX(uva);
    pt_entries[i].ppage = *pte >> PTXSHIFT;
    pt_entries[i].present = *pte & PTE_P;
    pt_entries[i].writable = (*pte & PTE_W) > 0;
    pt_entries[i].encrypted = (*pte & PTE_E) > 0;
    pt_entries[i].ref = (*pte & PTE_A) > 0;
    //PT_A flag needs to be modified as per clock algo.
    i ++;
    if (uva == 0 || i == num) break;

  }

  return i;

}


int dump_rawphymem(char *physical_addr, char * buffer) {
  *buffer = *buffer;
  cprintf("p4Debug: dump_rawphymem: %p, %p\n", physical_addr, buffer);
  int retval = copyout(myproc()->pgdir, (uint) buffer, (void *) PGROUNDDOWN((int)P2V(physical_addr)), PGSIZE);
  if (retval)
    return -1;
  return 0;
}


//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.


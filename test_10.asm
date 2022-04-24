
_test_10:     file format elf32-i386


Disassembly of section .text:

00000000 <err>:
#include "ptentry.h"

#define PGSIZE 4096

static int 
err(char *msg, ...) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 08             	sub    $0x8,%esp
    printf(1, "XV6_TEST_OUTPUT %s\n", msg);
   a:	83 ec 04             	sub    $0x4,%esp
   d:	ff 75 08             	pushl  0x8(%ebp)
  10:	68 cc 0c 00 00       	push   $0xccc
  15:	6a 01                	push   $0x1
  17:	e8 e7 08 00 00       	call   903 <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 4b 07 00 00       	call   76f <exit>

00000024 <access_all_dummy_pages>:
}


void access_all_dummy_pages(char **dummy_pages, uint len) {
  24:	f3 0f 1e fb          	endbr32 
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
    for (int i = 0; i < len; i++) {
  2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  35:	eb 2b                	jmp    62 <access_all_dummy_pages+0x3e>
        dummy_pages[i][0] = dummy_pages[i][0];
  37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  41:	8b 45 08             	mov    0x8(%ebp),%eax
  44:	01 d0                	add    %edx,%eax
  46:	8b 10                	mov    (%eax),%edx
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  52:	8b 45 08             	mov    0x8(%ebp),%eax
  55:	01 c8                	add    %ecx,%eax
  57:	8b 00                	mov    (%eax),%eax
  59:	0f b6 12             	movzbl (%edx),%edx
  5c:	88 10                	mov    %dl,(%eax)
    for (int i = 0; i < len; i++) {
  5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  65:	39 45 0c             	cmp    %eax,0xc(%ebp)
  68:	77 cd                	ja     37 <access_all_dummy_pages+0x13>
    }
    printf(1, "\n");
  6a:	83 ec 08             	sub    $0x8,%esp
  6d:	68 e0 0c 00 00       	push   $0xce0
  72:	6a 01                	push   $0x1
  74:	e8 8a 08 00 00       	call   903 <printf>
  79:	83 c4 10             	add    $0x10,%esp
}
  7c:	90                   	nop
  7d:	c9                   	leave  
  7e:	c3                   	ret    

0000007f <main>:

int main(void) {
  7f:	f3 0f 1e fb          	endbr32 
  83:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  87:	83 e4 f0             	and    $0xfffffff0,%esp
  8a:	ff 71 fc             	pushl  -0x4(%ecx)
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	57                   	push   %edi
  91:	56                   	push   %esi
  92:	53                   	push   %ebx
  93:	51                   	push   %ecx
  94:	83 ec 68             	sub    $0x68,%esp
    const uint PAGES_NUM = 32;
  97:	c7 45 c4 20 00 00 00 	movl   $0x20,-0x3c(%ebp)
    const uint expected_dummy_pages_num = 4;
  9e:	c7 45 c0 04 00 00 00 	movl   $0x4,-0x40(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  a8:	83 e8 01             	sub    $0x1,%eax
  ab:	89 45 bc             	mov    %eax,-0x44(%ebp)
  ae:	8b 45 c0             	mov    -0x40(%ebp),%eax
  b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  b8:	b8 10 00 00 00       	mov    $0x10,%eax
  bd:	83 e8 01             	sub    $0x1,%eax
  c0:	01 d0                	add    %edx,%eax
  c2:	bf 10 00 00 00       	mov    $0x10,%edi
  c7:	ba 00 00 00 00       	mov    $0x0,%edx
  cc:	f7 f7                	div    %edi
  ce:	6b c0 10             	imul   $0x10,%eax,%eax
  d1:	89 c2                	mov    %eax,%edx
  d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  d9:	89 e7                	mov    %esp,%edi
  db:	29 d7                	sub    %edx,%edi
  dd:	89 fa                	mov    %edi,%edx
  df:	39 d4                	cmp    %edx,%esp
  e1:	74 10                	je     f3 <main+0x74>
  e3:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  e9:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  f0:	00 
  f1:	eb ec                	jmp    df <main+0x60>
  f3:	89 c2                	mov    %eax,%edx
  f5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  fb:	29 d4                	sub    %edx,%esp
  fd:	89 c2                	mov    %eax,%edx
  ff:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 105:	85 d2                	test   %edx,%edx
 107:	74 0d                	je     116 <main+0x97>
 109:	25 ff 0f 00 00       	and    $0xfff,%eax
 10e:	83 e8 04             	sub    $0x4,%eax
 111:	01 e0                	add    %esp,%eax
 113:	83 08 00             	orl    $0x0,(%eax)
 116:	89 e0                	mov    %esp,%eax
 118:	83 c0 03             	add    $0x3,%eax
 11b:	c1 e8 02             	shr    $0x2,%eax
 11e:	c1 e0 02             	shl    $0x2,%eax
 121:	89 45 b8             	mov    %eax,-0x48(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	68 00 10 00 00       	push   $0x1000
 12c:	e8 c6 06 00 00       	call   7f7 <sbrk>
 131:	83 c4 10             	add    $0x10,%esp
 134:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    char *sp = buffer - PGSIZE;
 137:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 13a:	2d 00 10 00 00       	sub    $0x1000,%eax
 13f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 142:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 145:	2d 00 20 00 00       	sub    $0x2000,%eax
 14a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 14d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 150:	83 e8 01             	sub    $0x1,%eax
 153:	89 45 a8             	mov    %eax,-0x58(%ebp)
 156:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 159:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 160:	b8 10 00 00 00       	mov    $0x10,%eax
 165:	83 e8 01             	sub    $0x1,%eax
 168:	01 d0                	add    %edx,%eax
 16a:	bf 10 00 00 00       	mov    $0x10,%edi
 16f:	ba 00 00 00 00       	mov    $0x0,%edx
 174:	f7 f7                	div    %edi
 176:	6b c0 10             	imul   $0x10,%eax,%eax
 179:	89 c2                	mov    %eax,%edx
 17b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 181:	89 e6                	mov    %esp,%esi
 183:	29 d6                	sub    %edx,%esi
 185:	89 f2                	mov    %esi,%edx
 187:	39 d4                	cmp    %edx,%esp
 189:	74 10                	je     19b <main+0x11c>
 18b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 191:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 198:	00 
 199:	eb ec                	jmp    187 <main+0x108>
 19b:	89 c2                	mov    %eax,%edx
 19d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 1a3:	29 d4                	sub    %edx,%esp
 1a5:	89 c2                	mov    %eax,%edx
 1a7:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 1ad:	85 d2                	test   %edx,%edx
 1af:	74 0d                	je     1be <main+0x13f>
 1b1:	25 ff 0f 00 00       	and    $0xfff,%eax
 1b6:	83 e8 04             	sub    $0x4,%eax
 1b9:	01 e0                	add    %esp,%eax
 1bb:	83 08 00             	orl    $0x0,(%eax)
 1be:	89 e0                	mov    %esp,%eax
 1c0:	83 c0 03             	add    $0x3,%eax
 1c3:	c1 e8 02             	shr    $0x2,%eax
 1c6:	c1 e0 02             	shl    $0x2,%eax
 1c9:	89 45 a4             	mov    %eax,-0x5c(%ebp)

    uint text_pages = (uint) boundary / PGSIZE;
 1cc:	8b 45 ac             	mov    -0x54(%ebp),%eax
 1cf:	c1 e8 0c             	shr    $0xc,%eax
 1d2:	89 45 a0             	mov    %eax,-0x60(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1d8:	83 e8 01             	sub    $0x1,%eax
 1db:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 1de:	76 10                	jbe    1f0 <main+0x171>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1e0:	83 ec 0c             	sub    $0xc,%esp
 1e3:	68 e4 0c 00 00       	push   $0xce4
 1e8:	e8 13 fe ff ff       	call   0 <err>
 1ed:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < text_pages; i++)
 1f0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 1f7:	eb 15                	jmp    20e <main+0x18f>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1fc:	c1 e0 0c             	shl    $0xc,%eax
 1ff:	89 c1                	mov    %eax,%ecx
 201:	8b 45 b8             	mov    -0x48(%ebp),%eax
 204:	8b 55 c8             	mov    -0x38(%ebp),%edx
 207:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 20a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 20e:	8b 45 c8             	mov    -0x38(%ebp),%eax
 211:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 214:	77 e3                	ja     1f9 <main+0x17a>
    dummy_pages[text_pages] = sp;
 216:	8b 45 b8             	mov    -0x48(%ebp),%eax
 219:	8b 55 a0             	mov    -0x60(%ebp),%edx
 21c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 21f:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 222:	8b 45 a0             	mov    -0x60(%ebp),%eax
 225:	83 c0 01             	add    $0x1,%eax
 228:	89 45 cc             	mov    %eax,-0x34(%ebp)
 22b:	eb 1d                	jmp    24a <main+0x1cb>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 22d:	83 ec 0c             	sub    $0xc,%esp
 230:	68 00 10 00 00       	push   $0x1000
 235:	e8 bd 05 00 00       	call   7f7 <sbrk>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	8b 55 b8             	mov    -0x48(%ebp),%edx
 240:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 243:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 246:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 24a:	8b 45 cc             	mov    -0x34(%ebp),%eax
 24d:	39 45 c0             	cmp    %eax,-0x40(%ebp)
 250:	77 db                	ja     22d <main+0x1ae>
    

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 252:	83 ec 08             	sub    $0x8,%esp
 255:	ff 75 c0             	pushl  -0x40(%ebp)
 258:	ff 75 b8             	pushl  -0x48(%ebp)
 25b:	e8 c4 fd ff ff       	call   24 <access_all_dummy_pages>
 260:	83 c4 10             	add    $0x10,%esp

    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 263:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 266:	0f b6 10             	movzbl (%eax),%edx
 269:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 26c:	88 10                	mov    %dl,(%eax)

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 26e:	b8 07 00 00 00       	mov    $0x7,%eax
 273:	2b 45 c0             	sub    -0x40(%ebp),%eax
 276:	89 45 9c             	mov    %eax,-0x64(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 279:	8b 45 9c             	mov    -0x64(%ebp),%eax
 27c:	c1 e0 0c             	shl    $0xc,%eax
 27f:	83 ec 0c             	sub    $0xc,%esp
 282:	50                   	push   %eax
 283:	e8 6f 05 00 00       	call   7f7 <sbrk>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 98             	mov    %eax,-0x68(%ebp)
    for (int i = 0; i < heap_pages_num; i++) {
 28e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 295:	eb 31                	jmp    2c8 <main+0x249>
      for (int j = 0; j < PGSIZE; j++) {
 297:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 29e:	eb 1b                	jmp    2bb <main+0x23c>
        ptr[i * PGSIZE + j] = 0x00;
 2a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2a3:	c1 e0 0c             	shl    $0xc,%eax
 2a6:	89 c2                	mov    %eax,%edx
 2a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2ab:	01 d0                	add    %edx,%eax
 2ad:	89 c2                	mov    %eax,%edx
 2af:	8b 45 98             	mov    -0x68(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	c6 00 00             	movb   $0x0,(%eax)
      for (int j = 0; j < PGSIZE; j++) {
 2b7:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 2bb:	81 7d d4 ff 0f 00 00 	cmpl   $0xfff,-0x2c(%ebp)
 2c2:	7e dc                	jle    2a0 <main+0x221>
    for (int i = 0; i < heap_pages_num; i++) {
 2c4:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 2c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2cb:	3b 45 9c             	cmp    -0x64(%ebp),%eax
 2ce:	7c c7                	jl     297 <main+0x218>
      }
    }
    
    // An extra page which will trigger the page eviction
    char* extra_pages = sbrk(PGSIZE * sizeof(char));
 2d0:	83 ec 0c             	sub    $0xc,%esp
 2d3:	68 00 10 00 00       	push   $0x1000
 2d8:	e8 1a 05 00 00       	call   7f7 <sbrk>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 94             	mov    %eax,-0x6c(%ebp)
    for (int j = 0; j < PGSIZE; j++) {
 2e3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 2ea:	eb 0f                	jmp    2fb <main+0x27c>
      extra_pages[j] = 0x00;
 2ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
 2ef:	8b 45 94             	mov    -0x6c(%ebp),%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	c6 00 00             	movb   $0x0,(%eax)
    for (int j = 0; j < PGSIZE; j++) {
 2f7:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 2fb:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
 302:	7e e8                	jle    2ec <main+0x26d>
    }

    // Deallocate the extra page
    sbrk(-1 * PGSIZE);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	68 00 f0 ff ff       	push   $0xfffff000
 30c:	e8 e6 04 00 00       	call   7f7 <sbrk>
 311:	83 c4 10             	add    $0x10,%esp

    // Bring all the dummy pages and buffer back to the 
    // clock queue and reset their ref to 1
    // No eviction should happen this time
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 314:	83 ec 08             	sub    $0x8,%esp
 317:	ff 75 c0             	pushl  -0x40(%ebp)
 31a:	ff 75 b8             	pushl  -0x48(%ebp)
 31d:	e8 02 fd ff ff       	call   24 <access_all_dummy_pages>
 322:	83 c4 10             	add    $0x10,%esp
    buffer[0] = buffer[0];
 325:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 328:	0f b6 10             	movzbl (%eax),%edx
 32b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 32e:	88 10                	mov    %dl,(%eax)
    sbrk(PGSIZE);
 330:	83 ec 0c             	sub    $0xc,%esp
 333:	68 00 10 00 00       	push   $0x1000
 338:	e8 ba 04 00 00       	call   7f7 <sbrk>
 33d:	83 c4 10             	add    $0x10,%esp

    int retval = getpgtable(pt_entries, heap_pages_num, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	6a 01                	push   $0x1
 345:	ff 75 9c             	pushl  -0x64(%ebp)
 348:	ff 75 a4             	pushl  -0x5c(%ebp)
 34b:	e8 c7 04 00 00       	call   817 <getpgtable>
 350:	83 c4 10             	add    $0x10,%esp
 353:	89 45 90             	mov    %eax,-0x70(%ebp)
    if (retval == heap_pages_num) {
 356:	8b 45 90             	mov    -0x70(%ebp),%eax
 359:	3b 45 9c             	cmp    -0x64(%ebp),%eax
 35c:	0f 85 78 01 00 00    	jne    4da <main+0x45b>
      for (int i = 0; i < retval; i++) {
 362:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 369:	e9 5e 01 00 00       	jmp    4cc <main+0x44d>
              i,
              pt_entries[i].pdx,
              pt_entries[i].ptx,
              pt_entries[i].writable,
              pt_entries[i].encrypted,
              pt_entries[i].ref
 36e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 371:	8b 55 dc             	mov    -0x24(%ebp),%edx
 374:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 379:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 37c:	0f b6 f0             	movzbl %al,%esi
              pt_entries[i].encrypted,
 37f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 382:	8b 55 dc             	mov    -0x24(%ebp),%edx
 385:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 38a:	c0 e8 07             	shr    $0x7,%al
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 38d:	0f b6 d8             	movzbl %al,%ebx
              pt_entries[i].writable,
 390:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 393:	8b 55 dc             	mov    -0x24(%ebp),%edx
 396:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 39b:	c0 e8 05             	shr    $0x5,%al
 39e:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3a1:	0f b6 c8             	movzbl %al,%ecx
              pt_entries[i].ptx,
 3a4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3aa:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 3ad:	c1 e8 0a             	shr    $0xa,%eax
 3b0:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3b4:	0f b7 d0             	movzwl %ax,%edx
              pt_entries[i].pdx,
 3b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3ba:	8b 7d dc             	mov    -0x24(%ebp),%edi
 3bd:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 3c1:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3c5:	0f b7 c0             	movzwl %ax,%eax
 3c8:	56                   	push   %esi
 3c9:	53                   	push   %ebx
 3ca:	51                   	push   %ecx
 3cb:	52                   	push   %edx
 3cc:	50                   	push   %eax
 3cd:	ff 75 dc             	pushl  -0x24(%ebp)
 3d0:	68 50 0d 00 00       	push   $0xd50
 3d5:	6a 01                	push   $0x1
 3d7:	e8 27 05 00 00       	call   903 <printf>
 3dc:	83 c4 20             	add    $0x20,%esp
          ); 
          
          uint expected = 0x00;
 3df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
          if (pt_entries[i].encrypted)
 3e6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3ec:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3f1:	c0 e8 07             	shr    $0x7,%al
 3f4:	84 c0                	test   %al,%al
 3f6:	74 07                	je     3ff <main+0x380>
            expected = ~0x00;
 3f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)

          if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 3ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 402:	8b 55 dc             	mov    -0x24(%ebp),%edx
 405:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 409:	25 ff ff 0f 00       	and    $0xfffff,%eax
 40e:	c1 e0 0c             	shl    $0xc,%eax
 411:	83 ec 08             	sub    $0x8,%esp
 414:	ff 75 b4             	pushl  -0x4c(%ebp)
 417:	50                   	push   %eax
 418:	e8 02 04 00 00       	call   81f <dump_rawphymem>
 41d:	83 c4 10             	add    $0x10,%esp
 420:	85 c0                	test   %eax,%eax
 422:	74 10                	je     434 <main+0x3b5>
              err("dump_rawphymem return non-zero value\n");
 424:	83 ec 0c             	sub    $0xc,%esp
 427:	68 ac 0d 00 00       	push   $0xdac
 42c:	e8 cf fb ff ff       	call   0 <err>
 431:	83 c4 10             	add    $0x10,%esp
          
          for (int j = 0; j < PGSIZE; j++) {
 434:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 43b:	eb 7e                	jmp    4bb <main+0x43c>
              if (buffer[j] != (char)expected) {
 43d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 440:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 443:	01 d0                	add    %edx,%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	8b 55 e0             	mov    -0x20(%ebp),%edx
 44b:	38 d0                	cmp    %dl,%al
 44d:	74 68                	je     4b7 <main+0x438>
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 44f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 452:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 455:	01 d0                	add    %edx,%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	0f be c0             	movsbl %al,%eax
 45d:	0f b6 d0             	movzbl %al,%edx
 460:	8b 45 e0             	mov    -0x20(%ebp),%eax
 463:	0f b6 c0             	movzbl %al,%eax
 466:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 469:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 46c:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 470:	66 81 e1 ff 03       	and    $0x3ff,%cx
 475:	0f b7 c9             	movzwl %cx,%ecx
 478:	89 ce                	mov    %ecx,%esi
 47a:	c1 e6 16             	shl    $0x16,%esi
 47d:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 480:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 483:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 486:	c1 e9 0a             	shr    $0xa,%ecx
 489:	66 81 e1 ff 03       	and    $0x3ff,%cx
 48e:	0f b7 c9             	movzwl %cx,%ecx
 491:	c1 e1 0c             	shl    $0xc,%ecx
 494:	89 f3                	mov    %esi,%ebx
 496:	09 cb                	or     %ecx,%ebx
 498:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 49b:	01 d9                	add    %ebx,%ecx
 49d:	83 ec 0c             	sub    $0xc,%esp
 4a0:	52                   	push   %edx
 4a1:	50                   	push   %eax
 4a2:	51                   	push   %ecx
 4a3:	68 d4 0d 00 00       	push   $0xdd4
 4a8:	6a 01                	push   $0x1
 4aa:	e8 54 04 00 00       	call   903 <printf>
 4af:	83 c4 20             	add    $0x20,%esp
                    exit();
 4b2:	e8 b8 02 00 00       	call   76f <exit>
          for (int j = 0; j < PGSIZE; j++) {
 4b7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4bb:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 4c2:	0f 8e 75 ff ff ff    	jle    43d <main+0x3be>
      for (int i = 0; i < retval; i++) {
 4c8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 4cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4cf:	3b 45 90             	cmp    -0x70(%ebp),%eax
 4d2:	0f 8c 96 fe ff ff    	jl     36e <main+0x2ef>
 4d8:	eb 15                	jmp    4ef <main+0x470>
              }
          }

      }
    } else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 4da:	ff 75 90             	pushl  -0x70(%ebp)
 4dd:	ff 75 9c             	pushl  -0x64(%ebp)
 4e0:	68 24 0e 00 00       	push   $0xe24
 4e5:	6a 01                	push   $0x1
 4e7:	e8 17 04 00 00       	call   903 <printf>
 4ec:	83 c4 10             	add    $0x10,%esp
    
    exit();
 4ef:	e8 7b 02 00 00       	call   76f <exit>

000004f4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 4f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4fc:	8b 55 10             	mov    0x10(%ebp),%edx
 4ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 502:	89 cb                	mov    %ecx,%ebx
 504:	89 df                	mov    %ebx,%edi
 506:	89 d1                	mov    %edx,%ecx
 508:	fc                   	cld    
 509:	f3 aa                	rep stos %al,%es:(%edi)
 50b:	89 ca                	mov    %ecx,%edx
 50d:	89 fb                	mov    %edi,%ebx
 50f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 512:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 515:	90                   	nop
 516:	5b                   	pop    %ebx
 517:	5f                   	pop    %edi
 518:	5d                   	pop    %ebp
 519:	c3                   	ret    

0000051a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 51a:	f3 0f 1e fb          	endbr32 
 51e:	55                   	push   %ebp
 51f:	89 e5                	mov    %esp,%ebp
 521:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 52a:	90                   	nop
 52b:	8b 55 0c             	mov    0xc(%ebp),%edx
 52e:	8d 42 01             	lea    0x1(%edx),%eax
 531:	89 45 0c             	mov    %eax,0xc(%ebp)
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	8d 48 01             	lea    0x1(%eax),%ecx
 53a:	89 4d 08             	mov    %ecx,0x8(%ebp)
 53d:	0f b6 12             	movzbl (%edx),%edx
 540:	88 10                	mov    %dl,(%eax)
 542:	0f b6 00             	movzbl (%eax),%eax
 545:	84 c0                	test   %al,%al
 547:	75 e2                	jne    52b <strcpy+0x11>
    ;
  return os;
 549:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 54c:	c9                   	leave  
 54d:	c3                   	ret    

0000054e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 54e:	f3 0f 1e fb          	endbr32 
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 555:	eb 08                	jmp    55f <strcmp+0x11>
    p++, q++;
 557:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 55b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	84 c0                	test   %al,%al
 567:	74 10                	je     579 <strcmp+0x2b>
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	0f b6 10             	movzbl (%eax),%edx
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	38 c2                	cmp    %al,%dl
 577:	74 de                	je     557 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	0f b6 00             	movzbl (%eax),%eax
 57f:	0f b6 d0             	movzbl %al,%edx
 582:	8b 45 0c             	mov    0xc(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	0f b6 c0             	movzbl %al,%eax
 58b:	29 c2                	sub    %eax,%edx
 58d:	89 d0                	mov    %edx,%eax
}
 58f:	5d                   	pop    %ebp
 590:	c3                   	ret    

00000591 <strlen>:

uint
strlen(const char *s)
{
 591:	f3 0f 1e fb          	endbr32 
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 59b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5a2:	eb 04                	jmp    5a8 <strlen+0x17>
 5a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	84 c0                	test   %al,%al
 5b5:	75 ed                	jne    5a4 <strlen+0x13>
    ;
  return n;
 5b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5ba:	c9                   	leave  
 5bb:	c3                   	ret    

000005bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 5bc:	f3 0f 1e fb          	endbr32 
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 5c3:	8b 45 10             	mov    0x10(%ebp),%eax
 5c6:	50                   	push   %eax
 5c7:	ff 75 0c             	pushl  0xc(%ebp)
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 22 ff ff ff       	call   4f4 <stosb>
 5d2:	83 c4 0c             	add    $0xc,%esp
  return dst;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    

000005da <strchr>:

char*
strchr(const char *s, char c)
{
 5da:	f3 0f 1e fb          	endbr32 
 5de:	55                   	push   %ebp
 5df:	89 e5                	mov    %esp,%ebp
 5e1:	83 ec 04             	sub    $0x4,%esp
 5e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5ea:	eb 14                	jmp    600 <strchr+0x26>
    if(*s == c)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	0f b6 00             	movzbl (%eax),%eax
 5f2:	38 45 fc             	cmp    %al,-0x4(%ebp)
 5f5:	75 05                	jne    5fc <strchr+0x22>
      return (char*)s;
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	eb 13                	jmp    60f <strchr+0x35>
  for(; *s; s++)
 5fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	0f b6 00             	movzbl (%eax),%eax
 606:	84 c0                	test   %al,%al
 608:	75 e2                	jne    5ec <strchr+0x12>
  return 0;
 60a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 60f:	c9                   	leave  
 610:	c3                   	ret    

00000611 <gets>:

char*
gets(char *buf, int max)
{
 611:	f3 0f 1e fb          	endbr32 
 615:	55                   	push   %ebp
 616:	89 e5                	mov    %esp,%ebp
 618:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 61b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 622:	eb 42                	jmp    666 <gets+0x55>
    cc = read(0, &c, 1);
 624:	83 ec 04             	sub    $0x4,%esp
 627:	6a 01                	push   $0x1
 629:	8d 45 ef             	lea    -0x11(%ebp),%eax
 62c:	50                   	push   %eax
 62d:	6a 00                	push   $0x0
 62f:	e8 53 01 00 00       	call   787 <read>
 634:	83 c4 10             	add    $0x10,%esp
 637:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 63a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63e:	7e 33                	jle    673 <gets+0x62>
      break;
    buf[i++] = c;
 640:	8b 45 f4             	mov    -0xc(%ebp),%eax
 643:	8d 50 01             	lea    0x1(%eax),%edx
 646:	89 55 f4             	mov    %edx,-0xc(%ebp)
 649:	89 c2                	mov    %eax,%edx
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	01 c2                	add    %eax,%edx
 650:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 654:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 656:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 65a:	3c 0a                	cmp    $0xa,%al
 65c:	74 16                	je     674 <gets+0x63>
 65e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 662:	3c 0d                	cmp    $0xd,%al
 664:	74 0e                	je     674 <gets+0x63>
  for(i=0; i+1 < max; ){
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	83 c0 01             	add    $0x1,%eax
 66c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 66f:	7f b3                	jg     624 <gets+0x13>
 671:	eb 01                	jmp    674 <gets+0x63>
      break;
 673:	90                   	nop
      break;
  }
  buf[i] = '\0';
 674:	8b 55 f4             	mov    -0xc(%ebp),%edx
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	01 d0                	add    %edx,%eax
 67c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 682:	c9                   	leave  
 683:	c3                   	ret    

00000684 <stat>:

int
stat(const char *n, struct stat *st)
{
 684:	f3 0f 1e fb          	endbr32 
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 68e:	83 ec 08             	sub    $0x8,%esp
 691:	6a 00                	push   $0x0
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 14 01 00 00       	call   7af <open>
 69b:	83 c4 10             	add    $0x10,%esp
 69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a5:	79 07                	jns    6ae <stat+0x2a>
    return -1;
 6a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6ac:	eb 25                	jmp    6d3 <stat+0x4f>
  r = fstat(fd, st);
 6ae:	83 ec 08             	sub    $0x8,%esp
 6b1:	ff 75 0c             	pushl  0xc(%ebp)
 6b4:	ff 75 f4             	pushl  -0xc(%ebp)
 6b7:	e8 0b 01 00 00       	call   7c7 <fstat>
 6bc:	83 c4 10             	add    $0x10,%esp
 6bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6c2:	83 ec 0c             	sub    $0xc,%esp
 6c5:	ff 75 f4             	pushl  -0xc(%ebp)
 6c8:	e8 ca 00 00 00       	call   797 <close>
 6cd:	83 c4 10             	add    $0x10,%esp
  return r;
 6d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <atoi>:

int
atoi(const char *s)
{
 6d5:	f3 0f 1e fb          	endbr32 
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6e6:	eb 25                	jmp    70d <atoi+0x38>
    n = n*10 + *s++ - '0';
 6e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6eb:	89 d0                	mov    %edx,%eax
 6ed:	c1 e0 02             	shl    $0x2,%eax
 6f0:	01 d0                	add    %edx,%eax
 6f2:	01 c0                	add    %eax,%eax
 6f4:	89 c1                	mov    %eax,%ecx
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	8d 50 01             	lea    0x1(%eax),%edx
 6fc:	89 55 08             	mov    %edx,0x8(%ebp)
 6ff:	0f b6 00             	movzbl (%eax),%eax
 702:	0f be c0             	movsbl %al,%eax
 705:	01 c8                	add    %ecx,%eax
 707:	83 e8 30             	sub    $0x30,%eax
 70a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	0f b6 00             	movzbl (%eax),%eax
 713:	3c 2f                	cmp    $0x2f,%al
 715:	7e 0a                	jle    721 <atoi+0x4c>
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	0f b6 00             	movzbl (%eax),%eax
 71d:	3c 39                	cmp    $0x39,%al
 71f:	7e c7                	jle    6e8 <atoi+0x13>
  return n;
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 724:	c9                   	leave  
 725:	c3                   	ret    

00000726 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 726:	f3 0f 1e fb          	endbr32 
 72a:	55                   	push   %ebp
 72b:	89 e5                	mov    %esp,%ebp
 72d:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 736:	8b 45 0c             	mov    0xc(%ebp),%eax
 739:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 73c:	eb 17                	jmp    755 <memmove+0x2f>
    *dst++ = *src++;
 73e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 741:	8d 42 01             	lea    0x1(%edx),%eax
 744:	89 45 f8             	mov    %eax,-0x8(%ebp)
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8d 48 01             	lea    0x1(%eax),%ecx
 74d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 750:	0f b6 12             	movzbl (%edx),%edx
 753:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 755:	8b 45 10             	mov    0x10(%ebp),%eax
 758:	8d 50 ff             	lea    -0x1(%eax),%edx
 75b:	89 55 10             	mov    %edx,0x10(%ebp)
 75e:	85 c0                	test   %eax,%eax
 760:	7f dc                	jg     73e <memmove+0x18>
  return vdst;
 762:	8b 45 08             	mov    0x8(%ebp),%eax
}
 765:	c9                   	leave  
 766:	c3                   	ret    

00000767 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 767:	b8 01 00 00 00       	mov    $0x1,%eax
 76c:	cd 40                	int    $0x40
 76e:	c3                   	ret    

0000076f <exit>:
SYSCALL(exit)
 76f:	b8 02 00 00 00       	mov    $0x2,%eax
 774:	cd 40                	int    $0x40
 776:	c3                   	ret    

00000777 <wait>:
SYSCALL(wait)
 777:	b8 03 00 00 00       	mov    $0x3,%eax
 77c:	cd 40                	int    $0x40
 77e:	c3                   	ret    

0000077f <pipe>:
SYSCALL(pipe)
 77f:	b8 04 00 00 00       	mov    $0x4,%eax
 784:	cd 40                	int    $0x40
 786:	c3                   	ret    

00000787 <read>:
SYSCALL(read)
 787:	b8 05 00 00 00       	mov    $0x5,%eax
 78c:	cd 40                	int    $0x40
 78e:	c3                   	ret    

0000078f <write>:
SYSCALL(write)
 78f:	b8 10 00 00 00       	mov    $0x10,%eax
 794:	cd 40                	int    $0x40
 796:	c3                   	ret    

00000797 <close>:
SYSCALL(close)
 797:	b8 15 00 00 00       	mov    $0x15,%eax
 79c:	cd 40                	int    $0x40
 79e:	c3                   	ret    

0000079f <kill>:
SYSCALL(kill)
 79f:	b8 06 00 00 00       	mov    $0x6,%eax
 7a4:	cd 40                	int    $0x40
 7a6:	c3                   	ret    

000007a7 <exec>:
SYSCALL(exec)
 7a7:	b8 07 00 00 00       	mov    $0x7,%eax
 7ac:	cd 40                	int    $0x40
 7ae:	c3                   	ret    

000007af <open>:
SYSCALL(open)
 7af:	b8 0f 00 00 00       	mov    $0xf,%eax
 7b4:	cd 40                	int    $0x40
 7b6:	c3                   	ret    

000007b7 <mknod>:
SYSCALL(mknod)
 7b7:	b8 11 00 00 00       	mov    $0x11,%eax
 7bc:	cd 40                	int    $0x40
 7be:	c3                   	ret    

000007bf <unlink>:
SYSCALL(unlink)
 7bf:	b8 12 00 00 00       	mov    $0x12,%eax
 7c4:	cd 40                	int    $0x40
 7c6:	c3                   	ret    

000007c7 <fstat>:
SYSCALL(fstat)
 7c7:	b8 08 00 00 00       	mov    $0x8,%eax
 7cc:	cd 40                	int    $0x40
 7ce:	c3                   	ret    

000007cf <link>:
SYSCALL(link)
 7cf:	b8 13 00 00 00       	mov    $0x13,%eax
 7d4:	cd 40                	int    $0x40
 7d6:	c3                   	ret    

000007d7 <mkdir>:
SYSCALL(mkdir)
 7d7:	b8 14 00 00 00       	mov    $0x14,%eax
 7dc:	cd 40                	int    $0x40
 7de:	c3                   	ret    

000007df <chdir>:
SYSCALL(chdir)
 7df:	b8 09 00 00 00       	mov    $0x9,%eax
 7e4:	cd 40                	int    $0x40
 7e6:	c3                   	ret    

000007e7 <dup>:
SYSCALL(dup)
 7e7:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ec:	cd 40                	int    $0x40
 7ee:	c3                   	ret    

000007ef <getpid>:
SYSCALL(getpid)
 7ef:	b8 0b 00 00 00       	mov    $0xb,%eax
 7f4:	cd 40                	int    $0x40
 7f6:	c3                   	ret    

000007f7 <sbrk>:
SYSCALL(sbrk)
 7f7:	b8 0c 00 00 00       	mov    $0xc,%eax
 7fc:	cd 40                	int    $0x40
 7fe:	c3                   	ret    

000007ff <sleep>:
SYSCALL(sleep)
 7ff:	b8 0d 00 00 00       	mov    $0xd,%eax
 804:	cd 40                	int    $0x40
 806:	c3                   	ret    

00000807 <uptime>:
SYSCALL(uptime)
 807:	b8 0e 00 00 00       	mov    $0xe,%eax
 80c:	cd 40                	int    $0x40
 80e:	c3                   	ret    

0000080f <mencrypt>:
SYSCALL(mencrypt)
 80f:	b8 16 00 00 00       	mov    $0x16,%eax
 814:	cd 40                	int    $0x40
 816:	c3                   	ret    

00000817 <getpgtable>:
SYSCALL(getpgtable)
 817:	b8 17 00 00 00       	mov    $0x17,%eax
 81c:	cd 40                	int    $0x40
 81e:	c3                   	ret    

0000081f <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 81f:	b8 18 00 00 00       	mov    $0x18,%eax
 824:	cd 40                	int    $0x40
 826:	c3                   	ret    

00000827 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 827:	f3 0f 1e fb          	endbr32 
 82b:	55                   	push   %ebp
 82c:	89 e5                	mov    %esp,%ebp
 82e:	83 ec 18             	sub    $0x18,%esp
 831:	8b 45 0c             	mov    0xc(%ebp),%eax
 834:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 837:	83 ec 04             	sub    $0x4,%esp
 83a:	6a 01                	push   $0x1
 83c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 83f:	50                   	push   %eax
 840:	ff 75 08             	pushl  0x8(%ebp)
 843:	e8 47 ff ff ff       	call   78f <write>
 848:	83 c4 10             	add    $0x10,%esp
}
 84b:	90                   	nop
 84c:	c9                   	leave  
 84d:	c3                   	ret    

0000084e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 84e:	f3 0f 1e fb          	endbr32 
 852:	55                   	push   %ebp
 853:	89 e5                	mov    %esp,%ebp
 855:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 858:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 85f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 863:	74 17                	je     87c <printint+0x2e>
 865:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 869:	79 11                	jns    87c <printint+0x2e>
    neg = 1;
 86b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 872:	8b 45 0c             	mov    0xc(%ebp),%eax
 875:	f7 d8                	neg    %eax
 877:	89 45 ec             	mov    %eax,-0x14(%ebp)
 87a:	eb 06                	jmp    882 <printint+0x34>
  } else {
    x = xx;
 87c:	8b 45 0c             	mov    0xc(%ebp),%eax
 87f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 882:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 889:	8b 4d 10             	mov    0x10(%ebp),%ecx
 88c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88f:	ba 00 00 00 00       	mov    $0x0,%edx
 894:	f7 f1                	div    %ecx
 896:	89 d1                	mov    %edx,%ecx
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8d 50 01             	lea    0x1(%eax),%edx
 89e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a1:	0f b6 91 04 11 00 00 	movzbl 0x1104(%ecx),%edx
 8a8:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 8ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b2:	ba 00 00 00 00       	mov    $0x0,%edx
 8b7:	f7 f1                	div    %ecx
 8b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8c0:	75 c7                	jne    889 <printint+0x3b>
  if(neg)
 8c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c6:	74 2d                	je     8f5 <printint+0xa7>
    buf[i++] = '-';
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8d 50 01             	lea    0x1(%eax),%edx
 8ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8d1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8d6:	eb 1d                	jmp    8f5 <printint+0xa7>
    putc(fd, buf[i]);
 8d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	01 d0                	add    %edx,%eax
 8e0:	0f b6 00             	movzbl (%eax),%eax
 8e3:	0f be c0             	movsbl %al,%eax
 8e6:	83 ec 08             	sub    $0x8,%esp
 8e9:	50                   	push   %eax
 8ea:	ff 75 08             	pushl  0x8(%ebp)
 8ed:	e8 35 ff ff ff       	call   827 <putc>
 8f2:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 8f5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 8f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fd:	79 d9                	jns    8d8 <printint+0x8a>
}
 8ff:	90                   	nop
 900:	90                   	nop
 901:	c9                   	leave  
 902:	c3                   	ret    

00000903 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 903:	f3 0f 1e fb          	endbr32 
 907:	55                   	push   %ebp
 908:	89 e5                	mov    %esp,%ebp
 90a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 90d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 914:	8d 45 0c             	lea    0xc(%ebp),%eax
 917:	83 c0 04             	add    $0x4,%eax
 91a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 91d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 924:	e9 59 01 00 00       	jmp    a82 <printf+0x17f>
    c = fmt[i] & 0xff;
 929:	8b 55 0c             	mov    0xc(%ebp),%edx
 92c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92f:	01 d0                	add    %edx,%eax
 931:	0f b6 00             	movzbl (%eax),%eax
 934:	0f be c0             	movsbl %al,%eax
 937:	25 ff 00 00 00       	and    $0xff,%eax
 93c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 93f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 943:	75 2c                	jne    971 <printf+0x6e>
      if(c == '%'){
 945:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 949:	75 0c                	jne    957 <printf+0x54>
        state = '%';
 94b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 952:	e9 27 01 00 00       	jmp    a7e <printf+0x17b>
      } else {
        putc(fd, c);
 957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 95a:	0f be c0             	movsbl %al,%eax
 95d:	83 ec 08             	sub    $0x8,%esp
 960:	50                   	push   %eax
 961:	ff 75 08             	pushl  0x8(%ebp)
 964:	e8 be fe ff ff       	call   827 <putc>
 969:	83 c4 10             	add    $0x10,%esp
 96c:	e9 0d 01 00 00       	jmp    a7e <printf+0x17b>
      }
    } else if(state == '%'){
 971:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 975:	0f 85 03 01 00 00    	jne    a7e <printf+0x17b>
      if(c == 'd'){
 97b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 97f:	75 1e                	jne    99f <printf+0x9c>
        printint(fd, *ap, 10, 1);
 981:	8b 45 e8             	mov    -0x18(%ebp),%eax
 984:	8b 00                	mov    (%eax),%eax
 986:	6a 01                	push   $0x1
 988:	6a 0a                	push   $0xa
 98a:	50                   	push   %eax
 98b:	ff 75 08             	pushl  0x8(%ebp)
 98e:	e8 bb fe ff ff       	call   84e <printint>
 993:	83 c4 10             	add    $0x10,%esp
        ap++;
 996:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 99a:	e9 d8 00 00 00       	jmp    a77 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 99f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9a3:	74 06                	je     9ab <printf+0xa8>
 9a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9a9:	75 1e                	jne    9c9 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 9ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9ae:	8b 00                	mov    (%eax),%eax
 9b0:	6a 00                	push   $0x0
 9b2:	6a 10                	push   $0x10
 9b4:	50                   	push   %eax
 9b5:	ff 75 08             	pushl  0x8(%ebp)
 9b8:	e8 91 fe ff ff       	call   84e <printint>
 9bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 9c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9c4:	e9 ae 00 00 00       	jmp    a77 <printf+0x174>
      } else if(c == 's'){
 9c9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9cd:	75 43                	jne    a12 <printf+0x10f>
        s = (char*)*ap;
 9cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9d2:	8b 00                	mov    (%eax),%eax
 9d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9df:	75 25                	jne    a06 <printf+0x103>
          s = "(null)";
 9e1:	c7 45 f4 6f 0e 00 00 	movl   $0xe6f,-0xc(%ebp)
        while(*s != 0){
 9e8:	eb 1c                	jmp    a06 <printf+0x103>
          putc(fd, *s);
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	0f b6 00             	movzbl (%eax),%eax
 9f0:	0f be c0             	movsbl %al,%eax
 9f3:	83 ec 08             	sub    $0x8,%esp
 9f6:	50                   	push   %eax
 9f7:	ff 75 08             	pushl  0x8(%ebp)
 9fa:	e8 28 fe ff ff       	call   827 <putc>
 9ff:	83 c4 10             	add    $0x10,%esp
          s++;
 a02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	0f b6 00             	movzbl (%eax),%eax
 a0c:	84 c0                	test   %al,%al
 a0e:	75 da                	jne    9ea <printf+0xe7>
 a10:	eb 65                	jmp    a77 <printf+0x174>
        }
      } else if(c == 'c'){
 a12:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a16:	75 1d                	jne    a35 <printf+0x132>
        putc(fd, *ap);
 a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1b:	8b 00                	mov    (%eax),%eax
 a1d:	0f be c0             	movsbl %al,%eax
 a20:	83 ec 08             	sub    $0x8,%esp
 a23:	50                   	push   %eax
 a24:	ff 75 08             	pushl  0x8(%ebp)
 a27:	e8 fb fd ff ff       	call   827 <putc>
 a2c:	83 c4 10             	add    $0x10,%esp
        ap++;
 a2f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a33:	eb 42                	jmp    a77 <printf+0x174>
      } else if(c == '%'){
 a35:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a39:	75 17                	jne    a52 <printf+0x14f>
        putc(fd, c);
 a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a3e:	0f be c0             	movsbl %al,%eax
 a41:	83 ec 08             	sub    $0x8,%esp
 a44:	50                   	push   %eax
 a45:	ff 75 08             	pushl  0x8(%ebp)
 a48:	e8 da fd ff ff       	call   827 <putc>
 a4d:	83 c4 10             	add    $0x10,%esp
 a50:	eb 25                	jmp    a77 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a52:	83 ec 08             	sub    $0x8,%esp
 a55:	6a 25                	push   $0x25
 a57:	ff 75 08             	pushl  0x8(%ebp)
 a5a:	e8 c8 fd ff ff       	call   827 <putc>
 a5f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a65:	0f be c0             	movsbl %al,%eax
 a68:	83 ec 08             	sub    $0x8,%esp
 a6b:	50                   	push   %eax
 a6c:	ff 75 08             	pushl  0x8(%ebp)
 a6f:	e8 b3 fd ff ff       	call   827 <putc>
 a74:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a77:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a7e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a82:	8b 55 0c             	mov    0xc(%ebp),%edx
 a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a88:	01 d0                	add    %edx,%eax
 a8a:	0f b6 00             	movzbl (%eax),%eax
 a8d:	84 c0                	test   %al,%al
 a8f:	0f 85 94 fe ff ff    	jne    929 <printf+0x26>
    }
  }
}
 a95:	90                   	nop
 a96:	90                   	nop
 a97:	c9                   	leave  
 a98:	c3                   	ret    

00000a99 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a99:	f3 0f 1e fb          	endbr32 
 a9d:	55                   	push   %ebp
 a9e:	89 e5                	mov    %esp,%ebp
 aa0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
 aa6:	83 e8 08             	sub    $0x8,%eax
 aa9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aac:	a1 20 11 00 00       	mov    0x1120,%eax
 ab1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ab4:	eb 24                	jmp    ada <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab9:	8b 00                	mov    (%eax),%eax
 abb:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 abe:	72 12                	jb     ad2 <free+0x39>
 ac0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ac6:	77 24                	ja     aec <free+0x53>
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	8b 00                	mov    (%eax),%eax
 acd:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ad0:	72 1a                	jb     aec <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad5:	8b 00                	mov    (%eax),%eax
 ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ada:	8b 45 f8             	mov    -0x8(%ebp),%eax
 add:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ae0:	76 d4                	jbe    ab6 <free+0x1d>
 ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae5:	8b 00                	mov    (%eax),%eax
 ae7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 aea:	73 ca                	jae    ab6 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 aec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aef:	8b 40 04             	mov    0x4(%eax),%eax
 af2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 afc:	01 c2                	add    %eax,%edx
 afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b01:	8b 00                	mov    (%eax),%eax
 b03:	39 c2                	cmp    %eax,%edx
 b05:	75 24                	jne    b2b <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0a:	8b 50 04             	mov    0x4(%eax),%edx
 b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b10:	8b 00                	mov    (%eax),%eax
 b12:	8b 40 04             	mov    0x4(%eax),%eax
 b15:	01 c2                	add    %eax,%edx
 b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b20:	8b 00                	mov    (%eax),%eax
 b22:	8b 10                	mov    (%eax),%edx
 b24:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b27:	89 10                	mov    %edx,(%eax)
 b29:	eb 0a                	jmp    b35 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2e:	8b 10                	mov    (%eax),%edx
 b30:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b33:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b38:	8b 40 04             	mov    0x4(%eax),%eax
 b3b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b45:	01 d0                	add    %edx,%eax
 b47:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b4a:	75 20                	jne    b6c <free+0xd3>
    p->s.size += bp->s.size;
 b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4f:	8b 50 04             	mov    0x4(%eax),%edx
 b52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b55:	8b 40 04             	mov    0x4(%eax),%eax
 b58:	01 c2                	add    %eax,%edx
 b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b60:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b63:	8b 10                	mov    (%eax),%edx
 b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b68:	89 10                	mov    %edx,(%eax)
 b6a:	eb 08                	jmp    b74 <free+0xdb>
  } else
    p->s.ptr = bp;
 b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b72:	89 10                	mov    %edx,(%eax)
  freep = p;
 b74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b77:	a3 20 11 00 00       	mov    %eax,0x1120
}
 b7c:	90                   	nop
 b7d:	c9                   	leave  
 b7e:	c3                   	ret    

00000b7f <morecore>:

static Header*
morecore(uint nu)
{
 b7f:	f3 0f 1e fb          	endbr32 
 b83:	55                   	push   %ebp
 b84:	89 e5                	mov    %esp,%ebp
 b86:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b89:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b90:	77 07                	ja     b99 <morecore+0x1a>
    nu = 4096;
 b92:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b99:	8b 45 08             	mov    0x8(%ebp),%eax
 b9c:	c1 e0 03             	shl    $0x3,%eax
 b9f:	83 ec 0c             	sub    $0xc,%esp
 ba2:	50                   	push   %eax
 ba3:	e8 4f fc ff ff       	call   7f7 <sbrk>
 ba8:	83 c4 10             	add    $0x10,%esp
 bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bb2:	75 07                	jne    bbb <morecore+0x3c>
    return 0;
 bb4:	b8 00 00 00 00       	mov    $0x0,%eax
 bb9:	eb 26                	jmp    be1 <morecore+0x62>
  hp = (Header*)p;
 bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc4:	8b 55 08             	mov    0x8(%ebp),%edx
 bc7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bcd:	83 c0 08             	add    $0x8,%eax
 bd0:	83 ec 0c             	sub    $0xc,%esp
 bd3:	50                   	push   %eax
 bd4:	e8 c0 fe ff ff       	call   a99 <free>
 bd9:	83 c4 10             	add    $0x10,%esp
  return freep;
 bdc:	a1 20 11 00 00       	mov    0x1120,%eax
}
 be1:	c9                   	leave  
 be2:	c3                   	ret    

00000be3 <malloc>:

void*
malloc(uint nbytes)
{
 be3:	f3 0f 1e fb          	endbr32 
 be7:	55                   	push   %ebp
 be8:	89 e5                	mov    %esp,%ebp
 bea:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bed:	8b 45 08             	mov    0x8(%ebp),%eax
 bf0:	83 c0 07             	add    $0x7,%eax
 bf3:	c1 e8 03             	shr    $0x3,%eax
 bf6:	83 c0 01             	add    $0x1,%eax
 bf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bfc:	a1 20 11 00 00       	mov    0x1120,%eax
 c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c08:	75 23                	jne    c2d <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 c0a:	c7 45 f0 18 11 00 00 	movl   $0x1118,-0x10(%ebp)
 c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c14:	a3 20 11 00 00       	mov    %eax,0x1120
 c19:	a1 20 11 00 00       	mov    0x1120,%eax
 c1e:	a3 18 11 00 00       	mov    %eax,0x1118
    base.s.size = 0;
 c23:	c7 05 1c 11 00 00 00 	movl   $0x0,0x111c
 c2a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c30:	8b 00                	mov    (%eax),%eax
 c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c38:	8b 40 04             	mov    0x4(%eax),%eax
 c3b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c3e:	77 4d                	ja     c8d <malloc+0xaa>
      if(p->s.size == nunits)
 c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c43:	8b 40 04             	mov    0x4(%eax),%eax
 c46:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c49:	75 0c                	jne    c57 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4e:	8b 10                	mov    (%eax),%edx
 c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c53:	89 10                	mov    %edx,(%eax)
 c55:	eb 26                	jmp    c7d <malloc+0x9a>
      else {
        p->s.size -= nunits;
 c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5a:	8b 40 04             	mov    0x4(%eax),%eax
 c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c60:	89 c2                	mov    %eax,%edx
 c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c65:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6b:	8b 40 04             	mov    0x4(%eax),%eax
 c6e:	c1 e0 03             	shl    $0x3,%eax
 c71:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c77:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c7a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c80:	a3 20 11 00 00       	mov    %eax,0x1120
      return (void*)(p + 1);
 c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c88:	83 c0 08             	add    $0x8,%eax
 c8b:	eb 3b                	jmp    cc8 <malloc+0xe5>
    }
    if(p == freep)
 c8d:	a1 20 11 00 00       	mov    0x1120,%eax
 c92:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c95:	75 1e                	jne    cb5 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 c97:	83 ec 0c             	sub    $0xc,%esp
 c9a:	ff 75 ec             	pushl  -0x14(%ebp)
 c9d:	e8 dd fe ff ff       	call   b7f <morecore>
 ca2:	83 c4 10             	add    $0x10,%esp
 ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cac:	75 07                	jne    cb5 <malloc+0xd2>
        return 0;
 cae:	b8 00 00 00 00       	mov    $0x0,%eax
 cb3:	eb 13                	jmp    cc8 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbe:	8b 00                	mov    (%eax),%eax
 cc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cc3:	e9 6d ff ff ff       	jmp    c35 <malloc+0x52>
  }
}
 cc8:	c9                   	leave  
 cc9:	c3                   	ret    

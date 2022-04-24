
_test_11:     file format elf32-i386


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
  10:	68 e4 0c 00 00       	push   $0xce4
  15:	6a 01                	push   $0x1
  17:	e8 00 09 00 00       	call   91c <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 64 07 00 00       	call   788 <exit>

00000024 <access_all_dummy_pages>:
}


void access_all_dummy_pages(char **dummy_pages, uint len) {
  24:	f3 0f 1e fb          	endbr32 
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
    for (int i = 0; i < len; i++) {
  2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  35:	eb 1b                	jmp    52 <access_all_dummy_pages+0x2e>
        char temp = dummy_pages[i][0];
  37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  41:	8b 45 08             	mov    0x8(%ebp),%eax
  44:	01 d0                	add    %edx,%eax
  46:	8b 00                	mov    (%eax),%eax
  48:	0f b6 00             	movzbl (%eax),%eax
  4b:	88 45 f3             	mov    %al,-0xd(%ebp)
    for (int i = 0; i < len; i++) {
  4e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  55:	39 45 0c             	cmp    %eax,0xc(%ebp)
  58:	77 dd                	ja     37 <access_all_dummy_pages+0x13>
        temp = temp;
        // printf(1, "0x%x ", dummy_pages[i]);
    }
    printf(1, "\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 f8 0c 00 00       	push   $0xcf8
  62:	6a 01                	push   $0x1
  64:	e8 b3 08 00 00       	call   91c <printf>
  69:	83 c4 10             	add    $0x10,%esp
}
  6c:	90                   	nop
  6d:	c9                   	leave  
  6e:	c3                   	ret    

0000006f <main>:

int main(void) {
  6f:	f3 0f 1e fb          	endbr32 
  73:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  77:	83 e4 f0             	and    $0xfffffff0,%esp
  7a:	ff 71 fc             	pushl  -0x4(%ecx)
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  80:	57                   	push   %edi
  81:	56                   	push   %esi
  82:	53                   	push   %ebx
  83:	51                   	push   %ecx
  84:	83 ec 68             	sub    $0x68,%esp
    const uint PAGES_NUM = 32;
  87:	c7 45 c4 20 00 00 00 	movl   $0x20,-0x3c(%ebp)
    const uint expected_dummy_pages_num = 4;
  8e:	c7 45 c0 04 00 00 00 	movl   $0x4,-0x40(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  98:	83 e8 01             	sub    $0x1,%eax
  9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  a8:	b8 10 00 00 00       	mov    $0x10,%eax
  ad:	83 e8 01             	sub    $0x1,%eax
  b0:	01 d0                	add    %edx,%eax
  b2:	bf 10 00 00 00       	mov    $0x10,%edi
  b7:	ba 00 00 00 00       	mov    $0x0,%edx
  bc:	f7 f7                	div    %edi
  be:	6b c0 10             	imul   $0x10,%eax,%eax
  c1:	89 c2                	mov    %eax,%edx
  c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  c9:	89 e7                	mov    %esp,%edi
  cb:	29 d7                	sub    %edx,%edi
  cd:	89 fa                	mov    %edi,%edx
  cf:	39 d4                	cmp    %edx,%esp
  d1:	74 10                	je     e3 <main+0x74>
  d3:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  d9:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  e0:	00 
  e1:	eb ec                	jmp    cf <main+0x60>
  e3:	89 c2                	mov    %eax,%edx
  e5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  eb:	29 d4                	sub    %edx,%esp
  ed:	89 c2                	mov    %eax,%edx
  ef:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  f5:	85 d2                	test   %edx,%edx
  f7:	74 0d                	je     106 <main+0x97>
  f9:	25 ff 0f 00 00       	and    $0xfff,%eax
  fe:	83 e8 04             	sub    $0x4,%eax
 101:	01 e0                	add    %esp,%eax
 103:	83 08 00             	orl    $0x0,(%eax)
 106:	89 e0                	mov    %esp,%eax
 108:	83 c0 03             	add    $0x3,%eax
 10b:	c1 e8 02             	shr    $0x2,%eax
 10e:	c1 e0 02             	shl    $0x2,%eax
 111:	89 45 b8             	mov    %eax,-0x48(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 114:	83 ec 0c             	sub    $0xc,%esp
 117:	68 00 10 00 00       	push   $0x1000
 11c:	e8 ef 06 00 00       	call   810 <sbrk>
 121:	83 c4 10             	add    $0x10,%esp
 124:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    char *sp = buffer - PGSIZE;
 127:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 12a:	2d 00 10 00 00       	sub    $0x1000,%eax
 12f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 132:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 135:	2d 00 20 00 00       	sub    $0x2000,%eax
 13a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 13d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 140:	83 e8 01             	sub    $0x1,%eax
 143:	89 45 a8             	mov    %eax,-0x58(%ebp)
 146:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 149:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 150:	b8 10 00 00 00       	mov    $0x10,%eax
 155:	83 e8 01             	sub    $0x1,%eax
 158:	01 d0                	add    %edx,%eax
 15a:	bf 10 00 00 00       	mov    $0x10,%edi
 15f:	ba 00 00 00 00       	mov    $0x0,%edx
 164:	f7 f7                	div    %edi
 166:	6b c0 10             	imul   $0x10,%eax,%eax
 169:	89 c2                	mov    %eax,%edx
 16b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 171:	89 e6                	mov    %esp,%esi
 173:	29 d6                	sub    %edx,%esi
 175:	89 f2                	mov    %esi,%edx
 177:	39 d4                	cmp    %edx,%esp
 179:	74 10                	je     18b <main+0x11c>
 17b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 181:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 188:	00 
 189:	eb ec                	jmp    177 <main+0x108>
 18b:	89 c2                	mov    %eax,%edx
 18d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 193:	29 d4                	sub    %edx,%esp
 195:	89 c2                	mov    %eax,%edx
 197:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 19d:	85 d2                	test   %edx,%edx
 19f:	74 0d                	je     1ae <main+0x13f>
 1a1:	25 ff 0f 00 00       	and    $0xfff,%eax
 1a6:	83 e8 04             	sub    $0x4,%eax
 1a9:	01 e0                	add    %esp,%eax
 1ab:	83 08 00             	orl    $0x0,(%eax)
 1ae:	89 e0                	mov    %esp,%eax
 1b0:	83 c0 03             	add    $0x3,%eax
 1b3:	c1 e8 02             	shr    $0x2,%eax
 1b6:	c1 e0 02             	shl    $0x2,%eax
 1b9:	89 45 a4             	mov    %eax,-0x5c(%ebp)

    uint text_pages = (uint) boundary / PGSIZE;
 1bc:	8b 45 ac             	mov    -0x54(%ebp),%eax
 1bf:	c1 e8 0c             	shr    $0xc,%eax
 1c2:	89 45 a0             	mov    %eax,-0x60(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1c8:	83 e8 01             	sub    $0x1,%eax
 1cb:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 1ce:	76 10                	jbe    1e0 <main+0x171>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1d0:	83 ec 0c             	sub    $0xc,%esp
 1d3:	68 fc 0c 00 00       	push   $0xcfc
 1d8:	e8 23 fe ff ff       	call   0 <err>
 1dd:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < text_pages; i++)
 1e0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 1e7:	eb 15                	jmp    1fe <main+0x18f>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
 1ec:	c1 e0 0c             	shl    $0xc,%eax
 1ef:	89 c1                	mov    %eax,%ecx
 1f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
 1f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
 1f7:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 1fa:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 1fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
 201:	39 45 a0             	cmp    %eax,-0x60(%ebp)
 204:	77 e3                	ja     1e9 <main+0x17a>
    dummy_pages[text_pages] = sp;
 206:	8b 45 b8             	mov    -0x48(%ebp),%eax
 209:	8b 55 a0             	mov    -0x60(%ebp),%edx
 20c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
 20f:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 212:	8b 45 a0             	mov    -0x60(%ebp),%eax
 215:	83 c0 01             	add    $0x1,%eax
 218:	89 45 cc             	mov    %eax,-0x34(%ebp)
 21b:	eb 1d                	jmp    23a <main+0x1cb>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 21d:	83 ec 0c             	sub    $0xc,%esp
 220:	68 00 10 00 00       	push   $0x1000
 225:	e8 e6 05 00 00       	call   810 <sbrk>
 22a:	83 c4 10             	add    $0x10,%esp
 22d:	8b 55 b8             	mov    -0x48(%ebp),%edx
 230:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 233:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 236:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 23a:	8b 45 cc             	mov    -0x34(%ebp),%eax
 23d:	39 45 c0             	cmp    %eax,-0x40(%ebp)
 240:	77 db                	ja     21d <main+0x1ae>
    

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 242:	83 ec 08             	sub    $0x8,%esp
 245:	ff 75 c0             	pushl  -0x40(%ebp)
 248:	ff 75 b8             	pushl  -0x48(%ebp)
 24b:	e8 d4 fd ff ff       	call   24 <access_all_dummy_pages>
 250:	83 c4 10             	add    $0x10,%esp

    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 253:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 256:	0f b6 10             	movzbl (%eax),%edx
 259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 25c:	88 10                	mov    %dl,(%eax)

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 25e:	b8 07 00 00 00       	mov    $0x7,%eax
 263:	2b 45 c0             	sub    -0x40(%ebp),%eax
 266:	89 45 9c             	mov    %eax,-0x64(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 269:	8b 45 9c             	mov    -0x64(%ebp),%eax
 26c:	c1 e0 0c             	shl    $0xc,%eax
 26f:	83 ec 0c             	sub    $0xc,%esp
 272:	50                   	push   %eax
 273:	e8 98 05 00 00       	call   810 <sbrk>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	89 45 98             	mov    %eax,-0x68(%ebp)
    ptr[heap_pages_num / 2 * PGSIZE] = 0xAA;
 27e:	8b 45 9c             	mov    -0x64(%ebp),%eax
 281:	89 c2                	mov    %eax,%edx
 283:	c1 ea 1f             	shr    $0x1f,%edx
 286:	01 d0                	add    %edx,%eax
 288:	d1 f8                	sar    %eax
 28a:	c1 e0 0c             	shl    $0xc,%eax
 28d:	89 c2                	mov    %eax,%edx
 28f:	8b 45 98             	mov    -0x68(%ebp),%eax
 292:	01 d0                	add    %edx,%eax
 294:	c6 00 aa             	movb   $0xaa,(%eax)
    for (int i = heap_pages_num - 1; i >= 0; i--) {
 297:	8b 45 9c             	mov    -0x64(%ebp),%eax
 29a:	83 e8 01             	sub    $0x1,%eax
 29d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2a0:	eb 31                	jmp    2d3 <main+0x264>
        for (int j = 0; j < PGSIZE; j++) {
 2a2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 2a9:	eb 1b                	jmp    2c6 <main+0x257>
            ptr[i * PGSIZE + j] = 0xAA;
 2ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2ae:	c1 e0 0c             	shl    $0xc,%eax
 2b1:	89 c2                	mov    %eax,%edx
 2b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2b6:	01 d0                	add    %edx,%eax
 2b8:	89 c2                	mov    %eax,%edx
 2ba:	8b 45 98             	mov    -0x68(%ebp),%eax
 2bd:	01 d0                	add    %edx,%eax
 2bf:	c6 00 aa             	movb   $0xaa,(%eax)
        for (int j = 0; j < PGSIZE; j++) {
 2c2:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 2c6:	81 7d d4 ff 0f 00 00 	cmpl   $0xfff,-0x2c(%ebp)
 2cd:	7e dc                	jle    2ab <main+0x23c>
    for (int i = heap_pages_num - 1; i >= 0; i--) {
 2cf:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 2d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2d7:	79 c9                	jns    2a2 <main+0x233>
        }
    }
    
    // An extra page which will trigger the page eviction
    char* extra_pages = sbrk(PGSIZE * sizeof(char));
 2d9:	83 ec 0c             	sub    $0xc,%esp
 2dc:	68 00 10 00 00       	push   $0x1000
 2e1:	e8 2a 05 00 00       	call   810 <sbrk>
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	89 45 94             	mov    %eax,-0x6c(%ebp)

    for (int j = 0; j < PGSIZE; j++) {
 2ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 2f3:	eb 0f                	jmp    304 <main+0x295>
        extra_pages[j] = 0xAA;
 2f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
 2f8:	8b 45 94             	mov    -0x6c(%ebp),%eax
 2fb:	01 d0                	add    %edx,%eax
 2fd:	c6 00 aa             	movb   $0xaa,(%eax)
    for (int j = 0; j < PGSIZE; j++) {
 300:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 304:	81 7d d8 ff 0f 00 00 	cmpl   $0xfff,-0x28(%ebp)
 30b:	7e e8                	jle    2f5 <main+0x286>
    }

    // Bring all the dummy pages and buffer back to the 
    // clock queue and reset their ref to 1
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 30d:	83 ec 08             	sub    $0x8,%esp
 310:	ff 75 c0             	pushl  -0x40(%ebp)
 313:	ff 75 b8             	pushl  -0x48(%ebp)
 316:	e8 09 fd ff ff       	call   24 <access_all_dummy_pages>
 31b:	83 c4 10             	add    $0x10,%esp
    buffer[0] = buffer[0];
 31e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 321:	0f b6 10             	movzbl (%eax),%edx
 324:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 327:	88 10                	mov    %dl,(%eax)


    if (fork() == 0) {
 329:	e8 52 04 00 00       	call   780 <fork>
 32e:	85 c0                	test   %eax,%eax
 330:	0f 85 cd 01 00 00    	jne    503 <main+0x494>
        printf(1, "XV6_TEST_OUTPUT Child process is calling getpgtable\n");
 336:	83 ec 08             	sub    $0x8,%esp
 339:	68 68 0d 00 00       	push   $0xd68
 33e:	6a 01                	push   $0x1
 340:	e8 d7 05 00 00       	call   91c <printf>
 345:	83 c4 10             	add    $0x10,%esp
        int retval = getpgtable(pt_entries, heap_pages_num + 1, 0);
 348:	8b 45 9c             	mov    -0x64(%ebp),%eax
 34b:	83 c0 01             	add    $0x1,%eax
 34e:	83 ec 04             	sub    $0x4,%esp
 351:	6a 00                	push   $0x0
 353:	50                   	push   %eax
 354:	ff 75 a4             	pushl  -0x5c(%ebp)
 357:	e8 d4 04 00 00       	call   830 <getpgtable>
 35c:	83 c4 10             	add    $0x10,%esp
 35f:	89 45 90             	mov    %eax,-0x70(%ebp)
        if (retval == heap_pages_num + 1) {
 362:	8b 45 9c             	mov    -0x64(%ebp),%eax
 365:	83 c0 01             	add    $0x1,%eax
 368:	39 45 90             	cmp    %eax,-0x70(%ebp)
 36b:	0f 85 78 01 00 00    	jne    4e9 <main+0x47a>
            for (int i = 0; i < retval; i++) {
 371:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 378:	e9 5e 01 00 00       	jmp    4db <main+0x46c>
                    i,
                    pt_entries[i].pdx,
                    pt_entries[i].ptx,
                    pt_entries[i].writable,
                    pt_entries[i].encrypted,
                    pt_entries[i].ref
 37d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 380:	8b 55 dc             	mov    -0x24(%ebp),%edx
 383:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 388:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 38b:	0f b6 f0             	movzbl %al,%esi
                    pt_entries[i].encrypted,
 38e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 391:	8b 55 dc             	mov    -0x24(%ebp),%edx
 394:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 399:	c0 e8 07             	shr    $0x7,%al
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 39c:	0f b6 d8             	movzbl %al,%ebx
                    pt_entries[i].writable,
 39f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3a5:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3aa:	c0 e8 05             	shr    $0x5,%al
 3ad:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3b0:	0f b6 c8             	movzbl %al,%ecx
                    pt_entries[i].ptx,
 3b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3b9:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 3bc:	c1 e8 0a             	shr    $0xa,%eax
 3bf:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3c3:	0f b7 d0             	movzwl %ax,%edx
                    pt_entries[i].pdx,
 3c6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3c9:	8b 7d dc             	mov    -0x24(%ebp),%edi
 3cc:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 3d0:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3d4:	0f b7 c0             	movzwl %ax,%eax
 3d7:	56                   	push   %esi
 3d8:	53                   	push   %ebx
 3d9:	51                   	push   %ecx
 3da:	52                   	push   %edx
 3db:	50                   	push   %eax
 3dc:	ff 75 dc             	pushl  -0x24(%ebp)
 3df:	68 a0 0d 00 00       	push   $0xda0
 3e4:	6a 01                	push   $0x1
 3e6:	e8 31 05 00 00       	call   91c <printf>
 3eb:	83 c4 20             	add    $0x20,%esp
                ); 
                
                uint expected = 0xAA;
 3ee:	c7 45 e0 aa 00 00 00 	movl   $0xaa,-0x20(%ebp)
                if (pt_entries[i].encrypted)
 3f5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 3f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
 3fb:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 400:	c0 e8 07             	shr    $0x7,%al
 403:	84 c0                	test   %al,%al
 405:	74 07                	je     40e <main+0x39f>
                    expected = ~0xAA;
 407:	c7 45 e0 55 ff ff ff 	movl   $0xffffff55,-0x20(%ebp)

                if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 40e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 411:	8b 55 dc             	mov    -0x24(%ebp),%edx
 414:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 418:	25 ff ff 0f 00       	and    $0xfffff,%eax
 41d:	c1 e0 0c             	shl    $0xc,%eax
 420:	83 ec 08             	sub    $0x8,%esp
 423:	ff 75 b4             	pushl  -0x4c(%ebp)
 426:	50                   	push   %eax
 427:	e8 0c 04 00 00       	call   838 <dump_rawphymem>
 42c:	83 c4 10             	add    $0x10,%esp
 42f:	85 c0                	test   %eax,%eax
 431:	74 10                	je     443 <main+0x3d4>
                    err("dump_rawphymem return non-zero value\n");
 433:	83 ec 0c             	sub    $0xc,%esp
 436:	68 fc 0d 00 00       	push   $0xdfc
 43b:	e8 c0 fb ff ff       	call   0 <err>
 440:	83 c4 10             	add    $0x10,%esp
                
                for (int j = 0; j < PGSIZE; j++) {
 443:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 44a:	eb 7e                	jmp    4ca <main+0x45b>
                    if (buffer[j] != (char)expected) {
 44c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 44f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	8b 55 e0             	mov    -0x20(%ebp),%edx
 45a:	38 d0                	cmp    %dl,%al
 45c:	74 68                	je     4c6 <main+0x457>
                        // err("physical memory is dumped incorrectly\n");
                            printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 45e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 461:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	0f b6 00             	movzbl (%eax),%eax
 469:	0f be c0             	movsbl %al,%eax
 46c:	0f b6 d0             	movzbl %al,%edx
 46f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 472:	0f b6 c0             	movzbl %al,%eax
 475:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 478:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 47b:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 47f:	66 81 e1 ff 03       	and    $0x3ff,%cx
 484:	0f b7 c9             	movzwl %cx,%ecx
 487:	89 ce                	mov    %ecx,%esi
 489:	c1 e6 16             	shl    $0x16,%esi
 48c:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 48f:	8b 5d dc             	mov    -0x24(%ebp),%ebx
 492:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 495:	c1 e9 0a             	shr    $0xa,%ecx
 498:	66 81 e1 ff 03       	and    $0x3ff,%cx
 49d:	0f b7 c9             	movzwl %cx,%ecx
 4a0:	c1 e1 0c             	shl    $0xc,%ecx
 4a3:	89 f3                	mov    %esi,%ebx
 4a5:	09 cb                	or     %ecx,%ebx
 4a7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 4aa:	01 d9                	add    %ebx,%ecx
 4ac:	83 ec 0c             	sub    $0xc,%esp
 4af:	52                   	push   %edx
 4b0:	50                   	push   %eax
 4b1:	51                   	push   %ecx
 4b2:	68 24 0e 00 00       	push   $0xe24
 4b7:	6a 01                	push   $0x1
 4b9:	e8 5e 04 00 00       	call   91c <printf>
 4be:	83 c4 20             	add    $0x20,%esp
                            exit();
 4c1:	e8 c2 02 00 00       	call   788 <exit>
                for (int j = 0; j < PGSIZE; j++) {
 4c6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4ca:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 4d1:	0f 8e 75 ff ff ff    	jle    44c <main+0x3dd>
            for (int i = 0; i < retval; i++) {
 4d7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 4db:	8b 45 dc             	mov    -0x24(%ebp),%eax
 4de:	3b 45 90             	cmp    -0x70(%ebp),%eax
 4e1:	0f 8c 96 fe ff ff    	jl     37d <main+0x30e>
 4e7:	eb 1f                	jmp    508 <main+0x499>
                    }
                }
            }

        } else {
            printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 4e9:	ff 75 90             	pushl  -0x70(%ebp)
 4ec:	ff 75 9c             	pushl  -0x64(%ebp)
 4ef:	68 74 0e 00 00       	push   $0xe74
 4f4:	6a 01                	push   $0x1
 4f6:	e8 21 04 00 00       	call   91c <printf>
 4fb:	83 c4 10             	add    $0x10,%esp
            exit();
 4fe:	e8 85 02 00 00       	call   788 <exit>
        }
    } else {
        wait();
 503:	e8 88 02 00 00       	call   790 <wait>
    }

    


    exit();
 508:	e8 7b 02 00 00       	call   788 <exit>

0000050d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	57                   	push   %edi
 511:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 512:	8b 4d 08             	mov    0x8(%ebp),%ecx
 515:	8b 55 10             	mov    0x10(%ebp),%edx
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	89 cb                	mov    %ecx,%ebx
 51d:	89 df                	mov    %ebx,%edi
 51f:	89 d1                	mov    %edx,%ecx
 521:	fc                   	cld    
 522:	f3 aa                	rep stos %al,%es:(%edi)
 524:	89 ca                	mov    %ecx,%edx
 526:	89 fb                	mov    %edi,%ebx
 528:	89 5d 08             	mov    %ebx,0x8(%ebp)
 52b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 52e:	90                   	nop
 52f:	5b                   	pop    %ebx
 530:	5f                   	pop    %edi
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    

00000533 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 533:	f3 0f 1e fb          	endbr32 
 537:	55                   	push   %ebp
 538:	89 e5                	mov    %esp,%ebp
 53a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 543:	90                   	nop
 544:	8b 55 0c             	mov    0xc(%ebp),%edx
 547:	8d 42 01             	lea    0x1(%edx),%eax
 54a:	89 45 0c             	mov    %eax,0xc(%ebp)
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	8d 48 01             	lea    0x1(%eax),%ecx
 553:	89 4d 08             	mov    %ecx,0x8(%ebp)
 556:	0f b6 12             	movzbl (%edx),%edx
 559:	88 10                	mov    %dl,(%eax)
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	84 c0                	test   %al,%al
 560:	75 e2                	jne    544 <strcpy+0x11>
    ;
  return os;
 562:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 565:	c9                   	leave  
 566:	c3                   	ret    

00000567 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 567:	f3 0f 1e fb          	endbr32 
 56b:	55                   	push   %ebp
 56c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 56e:	eb 08                	jmp    578 <strcmp+0x11>
    p++, q++;
 570:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 574:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	0f b6 00             	movzbl (%eax),%eax
 57e:	84 c0                	test   %al,%al
 580:	74 10                	je     592 <strcmp+0x2b>
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	0f b6 10             	movzbl (%eax),%edx
 588:	8b 45 0c             	mov    0xc(%ebp),%eax
 58b:	0f b6 00             	movzbl (%eax),%eax
 58e:	38 c2                	cmp    %al,%dl
 590:	74 de                	je     570 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	0f b6 d0             	movzbl %al,%edx
 59b:	8b 45 0c             	mov    0xc(%ebp),%eax
 59e:	0f b6 00             	movzbl (%eax),%eax
 5a1:	0f b6 c0             	movzbl %al,%eax
 5a4:	29 c2                	sub    %eax,%edx
 5a6:	89 d0                	mov    %edx,%eax
}
 5a8:	5d                   	pop    %ebp
 5a9:	c3                   	ret    

000005aa <strlen>:

uint
strlen(const char *s)
{
 5aa:	f3 0f 1e fb          	endbr32 
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 5b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5bb:	eb 04                	jmp    5c1 <strlen+0x17>
 5bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	01 d0                	add    %edx,%eax
 5c9:	0f b6 00             	movzbl (%eax),%eax
 5cc:	84 c0                	test   %al,%al
 5ce:	75 ed                	jne    5bd <strlen+0x13>
    ;
  return n;
 5d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5d3:	c9                   	leave  
 5d4:	c3                   	ret    

000005d5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d5:	f3 0f 1e fb          	endbr32 
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 5dc:	8b 45 10             	mov    0x10(%ebp),%eax
 5df:	50                   	push   %eax
 5e0:	ff 75 0c             	pushl  0xc(%ebp)
 5e3:	ff 75 08             	pushl  0x8(%ebp)
 5e6:	e8 22 ff ff ff       	call   50d <stosb>
 5eb:	83 c4 0c             	add    $0xc,%esp
  return dst;
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5f1:	c9                   	leave  
 5f2:	c3                   	ret    

000005f3 <strchr>:

char*
strchr(const char *s, char c)
{
 5f3:	f3 0f 1e fb          	endbr32 
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	83 ec 04             	sub    $0x4,%esp
 5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 600:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 603:	eb 14                	jmp    619 <strchr+0x26>
    if(*s == c)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	38 45 fc             	cmp    %al,-0x4(%ebp)
 60e:	75 05                	jne    615 <strchr+0x22>
      return (char*)s;
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	eb 13                	jmp    628 <strchr+0x35>
  for(; *s; s++)
 615:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 619:	8b 45 08             	mov    0x8(%ebp),%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	84 c0                	test   %al,%al
 621:	75 e2                	jne    605 <strchr+0x12>
  return 0;
 623:	b8 00 00 00 00       	mov    $0x0,%eax
}
 628:	c9                   	leave  
 629:	c3                   	ret    

0000062a <gets>:

char*
gets(char *buf, int max)
{
 62a:	f3 0f 1e fb          	endbr32 
 62e:	55                   	push   %ebp
 62f:	89 e5                	mov    %esp,%ebp
 631:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 63b:	eb 42                	jmp    67f <gets+0x55>
    cc = read(0, &c, 1);
 63d:	83 ec 04             	sub    $0x4,%esp
 640:	6a 01                	push   $0x1
 642:	8d 45 ef             	lea    -0x11(%ebp),%eax
 645:	50                   	push   %eax
 646:	6a 00                	push   $0x0
 648:	e8 53 01 00 00       	call   7a0 <read>
 64d:	83 c4 10             	add    $0x10,%esp
 650:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 653:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 657:	7e 33                	jle    68c <gets+0x62>
      break;
    buf[i++] = c;
 659:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65c:	8d 50 01             	lea    0x1(%eax),%edx
 65f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 662:	89 c2                	mov    %eax,%edx
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	01 c2                	add    %eax,%edx
 669:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 66d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 66f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 673:	3c 0a                	cmp    $0xa,%al
 675:	74 16                	je     68d <gets+0x63>
 677:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 67b:	3c 0d                	cmp    $0xd,%al
 67d:	74 0e                	je     68d <gets+0x63>
  for(i=0; i+1 < max; ){
 67f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 682:	83 c0 01             	add    $0x1,%eax
 685:	39 45 0c             	cmp    %eax,0xc(%ebp)
 688:	7f b3                	jg     63d <gets+0x13>
 68a:	eb 01                	jmp    68d <gets+0x63>
      break;
 68c:	90                   	nop
      break;
  }
  buf[i] = '\0';
 68d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	01 d0                	add    %edx,%eax
 695:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 698:	8b 45 08             	mov    0x8(%ebp),%eax
}
 69b:	c9                   	leave  
 69c:	c3                   	ret    

0000069d <stat>:

int
stat(const char *n, struct stat *st)
{
 69d:	f3 0f 1e fb          	endbr32 
 6a1:	55                   	push   %ebp
 6a2:	89 e5                	mov    %esp,%ebp
 6a4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6a7:	83 ec 08             	sub    $0x8,%esp
 6aa:	6a 00                	push   $0x0
 6ac:	ff 75 08             	pushl  0x8(%ebp)
 6af:	e8 14 01 00 00       	call   7c8 <open>
 6b4:	83 c4 10             	add    $0x10,%esp
 6b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6be:	79 07                	jns    6c7 <stat+0x2a>
    return -1;
 6c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6c5:	eb 25                	jmp    6ec <stat+0x4f>
  r = fstat(fd, st);
 6c7:	83 ec 08             	sub    $0x8,%esp
 6ca:	ff 75 0c             	pushl  0xc(%ebp)
 6cd:	ff 75 f4             	pushl  -0xc(%ebp)
 6d0:	e8 0b 01 00 00       	call   7e0 <fstat>
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	ff 75 f4             	pushl  -0xc(%ebp)
 6e1:	e8 ca 00 00 00       	call   7b0 <close>
 6e6:	83 c4 10             	add    $0x10,%esp
  return r;
 6e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6ec:	c9                   	leave  
 6ed:	c3                   	ret    

000006ee <atoi>:

int
atoi(const char *s)
{
 6ee:	f3 0f 1e fb          	endbr32 
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6ff:	eb 25                	jmp    726 <atoi+0x38>
    n = n*10 + *s++ - '0';
 701:	8b 55 fc             	mov    -0x4(%ebp),%edx
 704:	89 d0                	mov    %edx,%eax
 706:	c1 e0 02             	shl    $0x2,%eax
 709:	01 d0                	add    %edx,%eax
 70b:	01 c0                	add    %eax,%eax
 70d:	89 c1                	mov    %eax,%ecx
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	8d 50 01             	lea    0x1(%eax),%edx
 715:	89 55 08             	mov    %edx,0x8(%ebp)
 718:	0f b6 00             	movzbl (%eax),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	01 c8                	add    %ecx,%eax
 720:	83 e8 30             	sub    $0x30,%eax
 723:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	0f b6 00             	movzbl (%eax),%eax
 72c:	3c 2f                	cmp    $0x2f,%al
 72e:	7e 0a                	jle    73a <atoi+0x4c>
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	0f b6 00             	movzbl (%eax),%eax
 736:	3c 39                	cmp    $0x39,%al
 738:	7e c7                	jle    701 <atoi+0x13>
  return n;
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 73f:	f3 0f 1e fb          	endbr32 
 743:	55                   	push   %ebp
 744:	89 e5                	mov    %esp,%ebp
 746:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 74f:	8b 45 0c             	mov    0xc(%ebp),%eax
 752:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 755:	eb 17                	jmp    76e <memmove+0x2f>
    *dst++ = *src++;
 757:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75a:	8d 42 01             	lea    0x1(%edx),%eax
 75d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8d 48 01             	lea    0x1(%eax),%ecx
 766:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 769:	0f b6 12             	movzbl (%edx),%edx
 76c:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 76e:	8b 45 10             	mov    0x10(%ebp),%eax
 771:	8d 50 ff             	lea    -0x1(%eax),%edx
 774:	89 55 10             	mov    %edx,0x10(%ebp)
 777:	85 c0                	test   %eax,%eax
 779:	7f dc                	jg     757 <memmove+0x18>
  return vdst;
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 77e:	c9                   	leave  
 77f:	c3                   	ret    

00000780 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 780:	b8 01 00 00 00       	mov    $0x1,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <exit>:
SYSCALL(exit)
 788:	b8 02 00 00 00       	mov    $0x2,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <wait>:
SYSCALL(wait)
 790:	b8 03 00 00 00       	mov    $0x3,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <pipe>:
SYSCALL(pipe)
 798:	b8 04 00 00 00       	mov    $0x4,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <read>:
SYSCALL(read)
 7a0:	b8 05 00 00 00       	mov    $0x5,%eax
 7a5:	cd 40                	int    $0x40
 7a7:	c3                   	ret    

000007a8 <write>:
SYSCALL(write)
 7a8:	b8 10 00 00 00       	mov    $0x10,%eax
 7ad:	cd 40                	int    $0x40
 7af:	c3                   	ret    

000007b0 <close>:
SYSCALL(close)
 7b0:	b8 15 00 00 00       	mov    $0x15,%eax
 7b5:	cd 40                	int    $0x40
 7b7:	c3                   	ret    

000007b8 <kill>:
SYSCALL(kill)
 7b8:	b8 06 00 00 00       	mov    $0x6,%eax
 7bd:	cd 40                	int    $0x40
 7bf:	c3                   	ret    

000007c0 <exec>:
SYSCALL(exec)
 7c0:	b8 07 00 00 00       	mov    $0x7,%eax
 7c5:	cd 40                	int    $0x40
 7c7:	c3                   	ret    

000007c8 <open>:
SYSCALL(open)
 7c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 7cd:	cd 40                	int    $0x40
 7cf:	c3                   	ret    

000007d0 <mknod>:
SYSCALL(mknod)
 7d0:	b8 11 00 00 00       	mov    $0x11,%eax
 7d5:	cd 40                	int    $0x40
 7d7:	c3                   	ret    

000007d8 <unlink>:
SYSCALL(unlink)
 7d8:	b8 12 00 00 00       	mov    $0x12,%eax
 7dd:	cd 40                	int    $0x40
 7df:	c3                   	ret    

000007e0 <fstat>:
SYSCALL(fstat)
 7e0:	b8 08 00 00 00       	mov    $0x8,%eax
 7e5:	cd 40                	int    $0x40
 7e7:	c3                   	ret    

000007e8 <link>:
SYSCALL(link)
 7e8:	b8 13 00 00 00       	mov    $0x13,%eax
 7ed:	cd 40                	int    $0x40
 7ef:	c3                   	ret    

000007f0 <mkdir>:
SYSCALL(mkdir)
 7f0:	b8 14 00 00 00       	mov    $0x14,%eax
 7f5:	cd 40                	int    $0x40
 7f7:	c3                   	ret    

000007f8 <chdir>:
SYSCALL(chdir)
 7f8:	b8 09 00 00 00       	mov    $0x9,%eax
 7fd:	cd 40                	int    $0x40
 7ff:	c3                   	ret    

00000800 <dup>:
SYSCALL(dup)
 800:	b8 0a 00 00 00       	mov    $0xa,%eax
 805:	cd 40                	int    $0x40
 807:	c3                   	ret    

00000808 <getpid>:
SYSCALL(getpid)
 808:	b8 0b 00 00 00       	mov    $0xb,%eax
 80d:	cd 40                	int    $0x40
 80f:	c3                   	ret    

00000810 <sbrk>:
SYSCALL(sbrk)
 810:	b8 0c 00 00 00       	mov    $0xc,%eax
 815:	cd 40                	int    $0x40
 817:	c3                   	ret    

00000818 <sleep>:
SYSCALL(sleep)
 818:	b8 0d 00 00 00       	mov    $0xd,%eax
 81d:	cd 40                	int    $0x40
 81f:	c3                   	ret    

00000820 <uptime>:
SYSCALL(uptime)
 820:	b8 0e 00 00 00       	mov    $0xe,%eax
 825:	cd 40                	int    $0x40
 827:	c3                   	ret    

00000828 <mencrypt>:
SYSCALL(mencrypt)
 828:	b8 16 00 00 00       	mov    $0x16,%eax
 82d:	cd 40                	int    $0x40
 82f:	c3                   	ret    

00000830 <getpgtable>:
SYSCALL(getpgtable)
 830:	b8 17 00 00 00       	mov    $0x17,%eax
 835:	cd 40                	int    $0x40
 837:	c3                   	ret    

00000838 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 838:	b8 18 00 00 00       	mov    $0x18,%eax
 83d:	cd 40                	int    $0x40
 83f:	c3                   	ret    

00000840 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 840:	f3 0f 1e fb          	endbr32 
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 18             	sub    $0x18,%esp
 84a:	8b 45 0c             	mov    0xc(%ebp),%eax
 84d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 850:	83 ec 04             	sub    $0x4,%esp
 853:	6a 01                	push   $0x1
 855:	8d 45 f4             	lea    -0xc(%ebp),%eax
 858:	50                   	push   %eax
 859:	ff 75 08             	pushl  0x8(%ebp)
 85c:	e8 47 ff ff ff       	call   7a8 <write>
 861:	83 c4 10             	add    $0x10,%esp
}
 864:	90                   	nop
 865:	c9                   	leave  
 866:	c3                   	ret    

00000867 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 867:	f3 0f 1e fb          	endbr32 
 86b:	55                   	push   %ebp
 86c:	89 e5                	mov    %esp,%ebp
 86e:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 871:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 878:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 87c:	74 17                	je     895 <printint+0x2e>
 87e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 882:	79 11                	jns    895 <printint+0x2e>
    neg = 1;
 884:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 88b:	8b 45 0c             	mov    0xc(%ebp),%eax
 88e:	f7 d8                	neg    %eax
 890:	89 45 ec             	mov    %eax,-0x14(%ebp)
 893:	eb 06                	jmp    89b <printint+0x34>
  } else {
    x = xx;
 895:	8b 45 0c             	mov    0xc(%ebp),%eax
 898:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 89b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a8:	ba 00 00 00 00       	mov    $0x0,%edx
 8ad:	f7 f1                	div    %ecx
 8af:	89 d1                	mov    %edx,%ecx
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	8d 50 01             	lea    0x1(%eax),%edx
 8b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8ba:	0f b6 91 54 11 00 00 	movzbl 0x1154(%ecx),%edx
 8c1:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 8c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 8c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cb:	ba 00 00 00 00       	mov    $0x0,%edx
 8d0:	f7 f1                	div    %ecx
 8d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8d9:	75 c7                	jne    8a2 <printint+0x3b>
  if(neg)
 8db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8df:	74 2d                	je     90e <printint+0xa7>
    buf[i++] = '-';
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8d 50 01             	lea    0x1(%eax),%edx
 8e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8ea:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8ef:	eb 1d                	jmp    90e <printint+0xa7>
    putc(fd, buf[i]);
 8f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	01 d0                	add    %edx,%eax
 8f9:	0f b6 00             	movzbl (%eax),%eax
 8fc:	0f be c0             	movsbl %al,%eax
 8ff:	83 ec 08             	sub    $0x8,%esp
 902:	50                   	push   %eax
 903:	ff 75 08             	pushl  0x8(%ebp)
 906:	e8 35 ff ff ff       	call   840 <putc>
 90b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 90e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 916:	79 d9                	jns    8f1 <printint+0x8a>
}
 918:	90                   	nop
 919:	90                   	nop
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 91c:	f3 0f 1e fb          	endbr32 
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 926:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 92d:	8d 45 0c             	lea    0xc(%ebp),%eax
 930:	83 c0 04             	add    $0x4,%eax
 933:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 936:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 93d:	e9 59 01 00 00       	jmp    a9b <printf+0x17f>
    c = fmt[i] & 0xff;
 942:	8b 55 0c             	mov    0xc(%ebp),%edx
 945:	8b 45 f0             	mov    -0x10(%ebp),%eax
 948:	01 d0                	add    %edx,%eax
 94a:	0f b6 00             	movzbl (%eax),%eax
 94d:	0f be c0             	movsbl %al,%eax
 950:	25 ff 00 00 00       	and    $0xff,%eax
 955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 958:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 95c:	75 2c                	jne    98a <printf+0x6e>
      if(c == '%'){
 95e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 962:	75 0c                	jne    970 <printf+0x54>
        state = '%';
 964:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 96b:	e9 27 01 00 00       	jmp    a97 <printf+0x17b>
      } else {
        putc(fd, c);
 970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 973:	0f be c0             	movsbl %al,%eax
 976:	83 ec 08             	sub    $0x8,%esp
 979:	50                   	push   %eax
 97a:	ff 75 08             	pushl  0x8(%ebp)
 97d:	e8 be fe ff ff       	call   840 <putc>
 982:	83 c4 10             	add    $0x10,%esp
 985:	e9 0d 01 00 00       	jmp    a97 <printf+0x17b>
      }
    } else if(state == '%'){
 98a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 98e:	0f 85 03 01 00 00    	jne    a97 <printf+0x17b>
      if(c == 'd'){
 994:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 998:	75 1e                	jne    9b8 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 99a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	6a 01                	push   $0x1
 9a1:	6a 0a                	push   $0xa
 9a3:	50                   	push   %eax
 9a4:	ff 75 08             	pushl  0x8(%ebp)
 9a7:	e8 bb fe ff ff       	call   867 <printint>
 9ac:	83 c4 10             	add    $0x10,%esp
        ap++;
 9af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9b3:	e9 d8 00 00 00       	jmp    a90 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 9b8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9bc:	74 06                	je     9c4 <printf+0xa8>
 9be:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9c2:	75 1e                	jne    9e2 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 9c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c7:	8b 00                	mov    (%eax),%eax
 9c9:	6a 00                	push   $0x0
 9cb:	6a 10                	push   $0x10
 9cd:	50                   	push   %eax
 9ce:	ff 75 08             	pushl  0x8(%ebp)
 9d1:	e8 91 fe ff ff       	call   867 <printint>
 9d6:	83 c4 10             	add    $0x10,%esp
        ap++;
 9d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9dd:	e9 ae 00 00 00       	jmp    a90 <printf+0x174>
      } else if(c == 's'){
 9e2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9e6:	75 43                	jne    a2b <printf+0x10f>
        s = (char*)*ap;
 9e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9eb:	8b 00                	mov    (%eax),%eax
 9ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f8:	75 25                	jne    a1f <printf+0x103>
          s = "(null)";
 9fa:	c7 45 f4 bf 0e 00 00 	movl   $0xebf,-0xc(%ebp)
        while(*s != 0){
 a01:	eb 1c                	jmp    a1f <printf+0x103>
          putc(fd, *s);
 a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a06:	0f b6 00             	movzbl (%eax),%eax
 a09:	0f be c0             	movsbl %al,%eax
 a0c:	83 ec 08             	sub    $0x8,%esp
 a0f:	50                   	push   %eax
 a10:	ff 75 08             	pushl  0x8(%ebp)
 a13:	e8 28 fe ff ff       	call   840 <putc>
 a18:	83 c4 10             	add    $0x10,%esp
          s++;
 a1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	0f b6 00             	movzbl (%eax),%eax
 a25:	84 c0                	test   %al,%al
 a27:	75 da                	jne    a03 <printf+0xe7>
 a29:	eb 65                	jmp    a90 <printf+0x174>
        }
      } else if(c == 'c'){
 a2b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a2f:	75 1d                	jne    a4e <printf+0x132>
        putc(fd, *ap);
 a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a34:	8b 00                	mov    (%eax),%eax
 a36:	0f be c0             	movsbl %al,%eax
 a39:	83 ec 08             	sub    $0x8,%esp
 a3c:	50                   	push   %eax
 a3d:	ff 75 08             	pushl  0x8(%ebp)
 a40:	e8 fb fd ff ff       	call   840 <putc>
 a45:	83 c4 10             	add    $0x10,%esp
        ap++;
 a48:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a4c:	eb 42                	jmp    a90 <printf+0x174>
      } else if(c == '%'){
 a4e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a52:	75 17                	jne    a6b <printf+0x14f>
        putc(fd, c);
 a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a57:	0f be c0             	movsbl %al,%eax
 a5a:	83 ec 08             	sub    $0x8,%esp
 a5d:	50                   	push   %eax
 a5e:	ff 75 08             	pushl  0x8(%ebp)
 a61:	e8 da fd ff ff       	call   840 <putc>
 a66:	83 c4 10             	add    $0x10,%esp
 a69:	eb 25                	jmp    a90 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a6b:	83 ec 08             	sub    $0x8,%esp
 a6e:	6a 25                	push   $0x25
 a70:	ff 75 08             	pushl  0x8(%ebp)
 a73:	e8 c8 fd ff ff       	call   840 <putc>
 a78:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a7e:	0f be c0             	movsbl %al,%eax
 a81:	83 ec 08             	sub    $0x8,%esp
 a84:	50                   	push   %eax
 a85:	ff 75 08             	pushl  0x8(%ebp)
 a88:	e8 b3 fd ff ff       	call   840 <putc>
 a8d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a97:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
 a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa1:	01 d0                	add    %edx,%eax
 aa3:	0f b6 00             	movzbl (%eax),%eax
 aa6:	84 c0                	test   %al,%al
 aa8:	0f 85 94 fe ff ff    	jne    942 <printf+0x26>
    }
  }
}
 aae:	90                   	nop
 aaf:	90                   	nop
 ab0:	c9                   	leave  
 ab1:	c3                   	ret    

00000ab2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab2:	f3 0f 1e fb          	endbr32 
 ab6:	55                   	push   %ebp
 ab7:	89 e5                	mov    %esp,%ebp
 ab9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 abc:	8b 45 08             	mov    0x8(%ebp),%eax
 abf:	83 e8 08             	sub    $0x8,%eax
 ac2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac5:	a1 70 11 00 00       	mov    0x1170,%eax
 aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 acd:	eb 24                	jmp    af3 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad2:	8b 00                	mov    (%eax),%eax
 ad4:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 ad7:	72 12                	jb     aeb <free+0x39>
 ad9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 adf:	77 24                	ja     b05 <free+0x53>
 ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae4:	8b 00                	mov    (%eax),%eax
 ae6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ae9:	72 1a                	jb     b05 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aee:	8b 00                	mov    (%eax),%eax
 af0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 af3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 af9:	76 d4                	jbe    acf <free+0x1d>
 afb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afe:	8b 00                	mov    (%eax),%eax
 b00:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b03:	73 ca                	jae    acf <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b05:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b08:	8b 40 04             	mov    0x4(%eax),%eax
 b0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b15:	01 c2                	add    %eax,%edx
 b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1a:	8b 00                	mov    (%eax),%eax
 b1c:	39 c2                	cmp    %eax,%edx
 b1e:	75 24                	jne    b44 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 b20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b23:	8b 50 04             	mov    0x4(%eax),%edx
 b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b29:	8b 00                	mov    (%eax),%eax
 b2b:	8b 40 04             	mov    0x4(%eax),%eax
 b2e:	01 c2                	add    %eax,%edx
 b30:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b33:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b39:	8b 00                	mov    (%eax),%eax
 b3b:	8b 10                	mov    (%eax),%edx
 b3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b40:	89 10                	mov    %edx,(%eax)
 b42:	eb 0a                	jmp    b4e <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b47:	8b 10                	mov    (%eax),%edx
 b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b4c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b51:	8b 40 04             	mov    0x4(%eax),%eax
 b54:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5e:	01 d0                	add    %edx,%eax
 b60:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b63:	75 20                	jne    b85 <free+0xd3>
    p->s.size += bp->s.size;
 b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b68:	8b 50 04             	mov    0x4(%eax),%edx
 b6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b6e:	8b 40 04             	mov    0x4(%eax),%eax
 b71:	01 c2                	add    %eax,%edx
 b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b76:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b7c:	8b 10                	mov    (%eax),%edx
 b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b81:	89 10                	mov    %edx,(%eax)
 b83:	eb 08                	jmp    b8d <free+0xdb>
  } else
    p->s.ptr = bp;
 b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b88:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b8b:	89 10                	mov    %edx,(%eax)
  freep = p;
 b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b90:	a3 70 11 00 00       	mov    %eax,0x1170
}
 b95:	90                   	nop
 b96:	c9                   	leave  
 b97:	c3                   	ret    

00000b98 <morecore>:

static Header*
morecore(uint nu)
{
 b98:	f3 0f 1e fb          	endbr32 
 b9c:	55                   	push   %ebp
 b9d:	89 e5                	mov    %esp,%ebp
 b9f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ba2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ba9:	77 07                	ja     bb2 <morecore+0x1a>
    nu = 4096;
 bab:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 bb2:	8b 45 08             	mov    0x8(%ebp),%eax
 bb5:	c1 e0 03             	shl    $0x3,%eax
 bb8:	83 ec 0c             	sub    $0xc,%esp
 bbb:	50                   	push   %eax
 bbc:	e8 4f fc ff ff       	call   810 <sbrk>
 bc1:	83 c4 10             	add    $0x10,%esp
 bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bc7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bcb:	75 07                	jne    bd4 <morecore+0x3c>
    return 0;
 bcd:	b8 00 00 00 00       	mov    $0x0,%eax
 bd2:	eb 26                	jmp    bfa <morecore+0x62>
  hp = (Header*)p;
 bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdd:	8b 55 08             	mov    0x8(%ebp),%edx
 be0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be6:	83 c0 08             	add    $0x8,%eax
 be9:	83 ec 0c             	sub    $0xc,%esp
 bec:	50                   	push   %eax
 bed:	e8 c0 fe ff ff       	call   ab2 <free>
 bf2:	83 c4 10             	add    $0x10,%esp
  return freep;
 bf5:	a1 70 11 00 00       	mov    0x1170,%eax
}
 bfa:	c9                   	leave  
 bfb:	c3                   	ret    

00000bfc <malloc>:

void*
malloc(uint nbytes)
{
 bfc:	f3 0f 1e fb          	endbr32 
 c00:	55                   	push   %ebp
 c01:	89 e5                	mov    %esp,%ebp
 c03:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c06:	8b 45 08             	mov    0x8(%ebp),%eax
 c09:	83 c0 07             	add    $0x7,%eax
 c0c:	c1 e8 03             	shr    $0x3,%eax
 c0f:	83 c0 01             	add    $0x1,%eax
 c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c15:	a1 70 11 00 00       	mov    0x1170,%eax
 c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c21:	75 23                	jne    c46 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 c23:	c7 45 f0 68 11 00 00 	movl   $0x1168,-0x10(%ebp)
 c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2d:	a3 70 11 00 00       	mov    %eax,0x1170
 c32:	a1 70 11 00 00       	mov    0x1170,%eax
 c37:	a3 68 11 00 00       	mov    %eax,0x1168
    base.s.size = 0;
 c3c:	c7 05 6c 11 00 00 00 	movl   $0x0,0x116c
 c43:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c49:	8b 00                	mov    (%eax),%eax
 c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c51:	8b 40 04             	mov    0x4(%eax),%eax
 c54:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c57:	77 4d                	ja     ca6 <malloc+0xaa>
      if(p->s.size == nunits)
 c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5c:	8b 40 04             	mov    0x4(%eax),%eax
 c5f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 c62:	75 0c                	jne    c70 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c67:	8b 10                	mov    (%eax),%edx
 c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c6c:	89 10                	mov    %edx,(%eax)
 c6e:	eb 26                	jmp    c96 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c73:	8b 40 04             	mov    0x4(%eax),%eax
 c76:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c79:	89 c2                	mov    %eax,%edx
 c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c84:	8b 40 04             	mov    0x4(%eax),%eax
 c87:	c1 e0 03             	shl    $0x3,%eax
 c8a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c90:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c93:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c99:	a3 70 11 00 00       	mov    %eax,0x1170
      return (void*)(p + 1);
 c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca1:	83 c0 08             	add    $0x8,%eax
 ca4:	eb 3b                	jmp    ce1 <malloc+0xe5>
    }
    if(p == freep)
 ca6:	a1 70 11 00 00       	mov    0x1170,%eax
 cab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cae:	75 1e                	jne    cce <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 cb0:	83 ec 0c             	sub    $0xc,%esp
 cb3:	ff 75 ec             	pushl  -0x14(%ebp)
 cb6:	e8 dd fe ff ff       	call   b98 <morecore>
 cbb:	83 c4 10             	add    $0x10,%esp
 cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cc5:	75 07                	jne    cce <malloc+0xd2>
        return 0;
 cc7:	b8 00 00 00 00       	mov    $0x0,%eax
 ccc:	eb 13                	jmp    ce1 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd7:	8b 00                	mov    (%eax),%eax
 cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cdc:	e9 6d ff ff ff       	jmp    c4e <malloc+0x52>
  }
}
 ce1:	c9                   	leave  
 ce2:	c3                   	ret    

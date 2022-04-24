
_test_14:     file format elf32-i386


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
  10:	68 c0 0e 00 00       	push   $0xec0
  15:	6a 01                	push   $0x1
  17:	e8 dc 0a 00 00       	call   af8 <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 40 09 00 00       	call   964 <exit>

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
    }
    printf(1, "\n");
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	68 d4 0e 00 00       	push   $0xed4
  62:	6a 01                	push   $0x1
  64:	e8 8f 0a 00 00       	call   af8 <printf>
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
  84:	81 ec 88 00 00 00    	sub    $0x88,%esp
    const uint PAGES_NUM = 256;
  8a:	c7 45 a0 00 01 00 00 	movl   $0x100,-0x60(%ebp)
    const uint expected_dummy_pages_num = 12;
  91:	c7 45 9c 0c 00 00 00 	movl   $0xc,-0x64(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  98:	8b 45 9c             	mov    -0x64(%ebp),%eax
  9b:	83 e8 01             	sub    $0x1,%eax
  9e:	89 45 98             	mov    %eax,-0x68(%ebp)
  a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ab:	b8 10 00 00 00       	mov    $0x10,%eax
  b0:	83 e8 01             	sub    $0x1,%eax
  b3:	01 d0                	add    %edx,%eax
  b5:	bf 10 00 00 00       	mov    $0x10,%edi
  ba:	ba 00 00 00 00       	mov    $0x0,%edx
  bf:	f7 f7                	div    %edi
  c1:	6b c0 10             	imul   $0x10,%eax,%eax
  c4:	89 c2                	mov    %eax,%edx
  c6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  cc:	89 e7                	mov    %esp,%edi
  ce:	29 d7                	sub    %edx,%edi
  d0:	89 fa                	mov    %edi,%edx
  d2:	39 d4                	cmp    %edx,%esp
  d4:	74 10                	je     e6 <main+0x77>
  d6:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  dc:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  e3:	00 
  e4:	eb ec                	jmp    d2 <main+0x63>
  e6:	89 c2                	mov    %eax,%edx
  e8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  ee:	29 d4                	sub    %edx,%esp
  f0:	89 c2                	mov    %eax,%edx
  f2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  f8:	85 d2                	test   %edx,%edx
  fa:	74 0d                	je     109 <main+0x9a>
  fc:	25 ff 0f 00 00       	and    $0xfff,%eax
 101:	83 e8 04             	sub    $0x4,%eax
 104:	01 e0                	add    %esp,%eax
 106:	83 08 00             	orl    $0x0,(%eax)
 109:	89 e0                	mov    %esp,%eax
 10b:	83 c0 03             	add    $0x3,%eax
 10e:	c1 e8 02             	shr    $0x2,%eax
 111:	c1 e0 02             	shl    $0x2,%eax
 114:	89 45 94             	mov    %eax,-0x6c(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 117:	83 ec 0c             	sub    $0xc,%esp
 11a:	68 00 10 00 00       	push   $0x1000
 11f:	e8 c8 08 00 00       	call   9ec <sbrk>
 124:	83 c4 10             	add    $0x10,%esp
 127:	89 45 90             	mov    %eax,-0x70(%ebp)
    char *sp = buffer - PGSIZE;
 12a:	8b 45 90             	mov    -0x70(%ebp),%eax
 12d:	2d 00 10 00 00       	sub    $0x1000,%eax
 132:	89 45 8c             	mov    %eax,-0x74(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 135:	8b 45 90             	mov    -0x70(%ebp),%eax
 138:	2d 00 20 00 00       	sub    $0x2000,%eax
 13d:	89 45 88             	mov    %eax,-0x78(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 140:	8b 45 a0             	mov    -0x60(%ebp),%eax
 143:	83 e8 01             	sub    $0x1,%eax
 146:	89 45 84             	mov    %eax,-0x7c(%ebp)
 149:	8b 45 a0             	mov    -0x60(%ebp),%eax
 14c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 153:	b8 10 00 00 00       	mov    $0x10,%eax
 158:	83 e8 01             	sub    $0x1,%eax
 15b:	01 d0                	add    %edx,%eax
 15d:	bf 10 00 00 00       	mov    $0x10,%edi
 162:	ba 00 00 00 00       	mov    $0x0,%edx
 167:	f7 f7                	div    %edi
 169:	6b c0 10             	imul   $0x10,%eax,%eax
 16c:	89 c2                	mov    %eax,%edx
 16e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
 174:	89 e6                	mov    %esp,%esi
 176:	29 d6                	sub    %edx,%esi
 178:	89 f2                	mov    %esi,%edx
 17a:	39 d4                	cmp    %edx,%esp
 17c:	74 10                	je     18e <main+0x11f>
 17e:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 184:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 18b:	00 
 18c:	eb ec                	jmp    17a <main+0x10b>
 18e:	89 c2                	mov    %eax,%edx
 190:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 196:	29 d4                	sub    %edx,%esp
 198:	89 c2                	mov    %eax,%edx
 19a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 1a0:	85 d2                	test   %edx,%edx
 1a2:	74 0d                	je     1b1 <main+0x142>
 1a4:	25 ff 0f 00 00       	and    $0xfff,%eax
 1a9:	83 e8 04             	sub    $0x4,%eax
 1ac:	01 e0                	add    %esp,%eax
 1ae:	83 08 00             	orl    $0x0,(%eax)
 1b1:	89 e0                	mov    %esp,%eax
 1b3:	83 c0 03             	add    $0x3,%eax
 1b6:	c1 e8 02             	shr    $0x2,%eax
 1b9:	c1 e0 02             	shl    $0x2,%eax
 1bc:	89 45 80             	mov    %eax,-0x80(%ebp)

    uint text_pages = (uint) boundary / PGSIZE;
 1bf:	8b 45 88             	mov    -0x78(%ebp),%eax
 1c2:	c1 e8 0c             	shr    $0xc,%eax
 1c5:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1cb:	8b 45 9c             	mov    -0x64(%ebp),%eax
 1ce:	83 e8 01             	sub    $0x1,%eax
 1d1:	39 85 7c ff ff ff    	cmp    %eax,-0x84(%ebp)
 1d7:	76 10                	jbe    1e9 <main+0x17a>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1d9:	83 ec 0c             	sub    $0xc,%esp
 1dc:	68 d8 0e 00 00       	push   $0xed8
 1e1:	e8 1a fe ff ff       	call   0 <err>
 1e6:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < text_pages; i++)
 1e9:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 1f0:	eb 15                	jmp    207 <main+0x198>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1f5:	c1 e0 0c             	shl    $0xc,%eax
 1f8:	89 c1                	mov    %eax,%ecx
 1fa:	8b 45 94             	mov    -0x6c(%ebp),%eax
 1fd:	8b 55 c0             	mov    -0x40(%ebp),%edx
 200:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 203:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
 207:	8b 45 c0             	mov    -0x40(%ebp),%eax
 20a:	39 85 7c ff ff ff    	cmp    %eax,-0x84(%ebp)
 210:	77 e0                	ja     1f2 <main+0x183>
    dummy_pages[text_pages] = sp;
 212:	8b 45 94             	mov    -0x6c(%ebp),%eax
 215:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
 21b:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
 21e:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 221:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
 227:	83 c0 01             	add    $0x1,%eax
 22a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 22d:	eb 1d                	jmp    24c <main+0x1dd>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 22f:	83 ec 0c             	sub    $0xc,%esp
 232:	68 00 10 00 00       	push   $0x1000
 237:	e8 b0 07 00 00       	call   9ec <sbrk>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	8b 55 94             	mov    -0x6c(%ebp),%edx
 242:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 245:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 248:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
 24c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 24f:	39 45 9c             	cmp    %eax,-0x64(%ebp)
 252:	77 db                	ja     22f <main+0x1c0>
    

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 254:	83 ec 08             	sub    $0x8,%esp
 257:	ff 75 9c             	pushl  -0x64(%ebp)
 25a:	ff 75 94             	pushl  -0x6c(%ebp)
 25d:	e8 c2 fd ff ff       	call   24 <access_all_dummy_pages>
 262:	83 c4 10             	add    $0x10,%esp

    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 265:	8b 45 90             	mov    -0x70(%ebp),%eax
 268:	0f b6 10             	movzbl (%eax),%edx
 26b:	8b 45 90             	mov    -0x70(%ebp),%eax
 26e:	88 10                	mov    %dl,(%eax)

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 270:	b8 07 00 00 00       	mov    $0x7,%eax
 275:	2b 45 9c             	sub    -0x64(%ebp),%eax
 278:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 27e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 284:	c1 e0 0c             	shl    $0xc,%eax
 287:	83 ec 0c             	sub    $0xc,%esp
 28a:	50                   	push   %eax
 28b:	e8 5c 07 00 00       	call   9ec <sbrk>
 290:	83 c4 10             	add    $0x10,%esp
 293:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    for (int i = 0; i < heap_pages_num; i++) {
 299:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 2a0:	eb 60                	jmp    302 <main+0x293>
        if (i % 7 == 0) {
 2a2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 2a5:	ba 93 24 49 92       	mov    $0x92492493,%edx
 2aa:	89 c8                	mov    %ecx,%eax
 2ac:	f7 ea                	imul   %edx
 2ae:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 2b1:	c1 f8 02             	sar    $0x2,%eax
 2b4:	89 c2                	mov    %eax,%edx
 2b6:	89 c8                	mov    %ecx,%eax
 2b8:	c1 f8 1f             	sar    $0x1f,%eax
 2bb:	29 c2                	sub    %eax,%edx
 2bd:	89 d0                	mov    %edx,%eax
 2bf:	89 c2                	mov    %eax,%edx
 2c1:	c1 e2 03             	shl    $0x3,%edx
 2c4:	29 c2                	sub    %eax,%edx
 2c6:	89 c8                	mov    %ecx,%eax
 2c8:	29 d0                	sub    %edx,%eax
 2ca:	85 c0                	test   %eax,%eax
 2cc:	75 30                	jne    2fe <main+0x28f>
            for (int j = 0; j < PGSIZE; j++) {
 2ce:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
 2d5:	eb 1e                	jmp    2f5 <main+0x286>
                ptr[i * PGSIZE + j] = 0xAA;
 2d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2da:	c1 e0 0c             	shl    $0xc,%eax
 2dd:	89 c2                	mov    %eax,%edx
 2df:	8b 45 cc             	mov    -0x34(%ebp),%eax
 2e2:	01 d0                	add    %edx,%eax
 2e4:	89 c2                	mov    %eax,%edx
 2e6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	c6 00 aa             	movb   $0xaa,(%eax)
            for (int j = 0; j < PGSIZE; j++) {
 2f1:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 2f5:	81 7d cc ff 0f 00 00 	cmpl   $0xfff,-0x34(%ebp)
 2fc:	7e d9                	jle    2d7 <main+0x268>
    for (int i = 0; i < heap_pages_num; i++) {
 2fe:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 302:	8b 45 c8             	mov    -0x38(%ebp),%eax
 305:	3b 85 78 ff ff ff    	cmp    -0x88(%ebp),%eax
 30b:	7c 95                	jl     2a2 <main+0x233>
            }
        }
    }

    for (int i = heap_pages_num - 1; i >= 0; i--) {
 30d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 313:	83 e8 01             	sub    $0x1,%eax
 316:	89 45 d0             	mov    %eax,-0x30(%ebp)
 319:	eb 5d                	jmp    378 <main+0x309>
        if (i % 13 == 0) {
 31b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
 31e:	ba 4f ec c4 4e       	mov    $0x4ec4ec4f,%edx
 323:	89 c8                	mov    %ecx,%eax
 325:	f7 ea                	imul   %edx
 327:	c1 fa 02             	sar    $0x2,%edx
 32a:	89 c8                	mov    %ecx,%eax
 32c:	c1 f8 1f             	sar    $0x1f,%eax
 32f:	29 c2                	sub    %eax,%edx
 331:	89 d0                	mov    %edx,%eax
 333:	01 c0                	add    %eax,%eax
 335:	01 d0                	add    %edx,%eax
 337:	c1 e0 02             	shl    $0x2,%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	29 c1                	sub    %eax,%ecx
 33e:	89 ca                	mov    %ecx,%edx
 340:	85 d2                	test   %edx,%edx
 342:	75 30                	jne    374 <main+0x305>
            for (int j = 0; j < PGSIZE; j++) {
 344:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 34b:	eb 1e                	jmp    36b <main+0x2fc>
                ptr[i * PGSIZE + j] = 0xAA;
 34d:	8b 45 d0             	mov    -0x30(%ebp),%eax
 350:	c1 e0 0c             	shl    $0xc,%eax
 353:	89 c2                	mov    %eax,%edx
 355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 358:	01 d0                	add    %edx,%eax
 35a:	89 c2                	mov    %eax,%edx
 35c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
 362:	01 d0                	add    %edx,%eax
 364:	c6 00 aa             	movb   $0xaa,(%eax)
            for (int j = 0; j < PGSIZE; j++) {
 367:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 36b:	81 7d d4 ff 0f 00 00 	cmpl   $0xfff,-0x2c(%ebp)
 372:	7e d9                	jle    34d <main+0x2de>
    for (int i = heap_pages_num - 1; i >= 0; i--) {
 374:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 378:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 37c:	79 9d                	jns    31b <main+0x2ac>
            }
        }
    }

    for (int i = 0; i < heap_pages_num; i++) {
 37e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 385:	eb 3e                	jmp    3c5 <main+0x356>
        if (i % 2 == 0) {
 387:	8b 45 d8             	mov    -0x28(%ebp),%eax
 38a:	83 e0 01             	and    $0x1,%eax
 38d:	85 c0                	test   %eax,%eax
 38f:	75 30                	jne    3c1 <main+0x352>
            for (int j = 0; j < PGSIZE; j++) {
 391:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 398:	eb 1e                	jmp    3b8 <main+0x349>
                ptr[i * PGSIZE + j] = 0xAA;
 39a:	8b 45 d8             	mov    -0x28(%ebp),%eax
 39d:	c1 e0 0c             	shl    $0xc,%eax
 3a0:	89 c2                	mov    %eax,%edx
 3a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
 3a5:	01 d0                	add    %edx,%eax
 3a7:	89 c2                	mov    %eax,%edx
 3a9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
 3af:	01 d0                	add    %edx,%eax
 3b1:	c6 00 aa             	movb   $0xaa,(%eax)
            for (int j = 0; j < PGSIZE; j++) {
 3b4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 3b8:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%ebp)
 3bf:	7e d9                	jle    39a <main+0x32b>
    for (int i = 0; i < heap_pages_num; i++) {
 3c1:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 3c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
 3c8:	3b 85 78 ff ff ff    	cmp    -0x88(%ebp),%eax
 3ce:	7c b7                	jl     387 <main+0x318>
            }
        }
    }

    for (int i = heap_pages_num - 1; i >= 0; i--) {
 3d0:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
 3d6:	83 e8 01             	sub    $0x1,%eax
 3d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 3dc:	eb 34                	jmp    412 <main+0x3a3>
        for (int j = 0; j < PGSIZE; j++) {
 3de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3e5:	eb 1e                	jmp    405 <main+0x396>
            ptr[i * PGSIZE + j] = 0xAA;
 3e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3ea:	c1 e0 0c             	shl    $0xc,%eax
 3ed:	89 c2                	mov    %eax,%edx
 3ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3f2:	01 d0                	add    %edx,%eax
 3f4:	89 c2                	mov    %eax,%edx
 3f6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
 3fc:	01 d0                	add    %edx,%eax
 3fe:	c6 00 aa             	movb   $0xaa,(%eax)
        for (int j = 0; j < PGSIZE; j++) {
 401:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 405:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 40c:	7e d9                	jle    3e7 <main+0x378>
    for (int i = heap_pages_num - 1; i >= 0; i--) {
 40e:	83 6d e0 01          	subl   $0x1,-0x20(%ebp)
 412:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 416:	79 c6                	jns    3de <main+0x36f>



    
    // An extra page which will trigger the page eviction
    int extra_pages_num = 32;
 418:	c7 85 70 ff ff ff 20 	movl   $0x20,-0x90(%ebp)
 41f:	00 00 00 
    char* extra_pages = sbrk( extra_pages_num * PGSIZE * sizeof(char));
 422:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
 428:	c1 e0 0c             	shl    $0xc,%eax
 42b:	83 ec 0c             	sub    $0xc,%esp
 42e:	50                   	push   %eax
 42f:	e8 b8 05 00 00       	call   9ec <sbrk>
 434:	83 c4 10             	add    $0x10,%esp
 437:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
    for (int i = 0; i < extra_pages_num; i++) {
 43d:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 444:	eb 34                	jmp    47a <main+0x40b>
      for (int j = 0; j < PGSIZE; j++) {
 446:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
 44d:	eb 1e                	jmp    46d <main+0x3fe>
        extra_pages[i * PGSIZE + j] = 0xAA;
 44f:	8b 45 bc             	mov    -0x44(%ebp),%eax
 452:	c1 e0 0c             	shl    $0xc,%eax
 455:	89 c2                	mov    %eax,%edx
 457:	8b 45 b8             	mov    -0x48(%ebp),%eax
 45a:	01 d0                	add    %edx,%eax
 45c:	89 c2                	mov    %eax,%edx
 45e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	c6 00 aa             	movb   $0xaa,(%eax)
      for (int j = 0; j < PGSIZE; j++) {
 469:	83 45 b8 01          	addl   $0x1,-0x48(%ebp)
 46d:	81 7d b8 ff 0f 00 00 	cmpl   $0xfff,-0x48(%ebp)
 474:	7e d9                	jle    44f <main+0x3e0>
    for (int i = 0; i < extra_pages_num; i++) {
 476:	83 45 bc 01          	addl   $0x1,-0x44(%ebp)
 47a:	8b 45 bc             	mov    -0x44(%ebp),%eax
 47d:	3b 85 70 ff ff ff    	cmp    -0x90(%ebp),%eax
 483:	7c c1                	jl     446 <main+0x3d7>
      }
    }

    for (int i = 0; i < heap_pages_num; i++) {
 485:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
 48c:	eb 5a                	jmp    4e8 <main+0x479>
      if (i % 5 == 0) {
 48e:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 491:	ba 67 66 66 66       	mov    $0x66666667,%edx
 496:	89 c8                	mov    %ecx,%eax
 498:	f7 ea                	imul   %edx
 49a:	d1 fa                	sar    %edx
 49c:	89 c8                	mov    %ecx,%eax
 49e:	c1 f8 1f             	sar    $0x1f,%eax
 4a1:	29 c2                	sub    %eax,%edx
 4a3:	89 d0                	mov    %edx,%eax
 4a5:	89 c2                	mov    %eax,%edx
 4a7:	c1 e2 02             	shl    $0x2,%edx
 4aa:	01 c2                	add    %eax,%edx
 4ac:	89 c8                	mov    %ecx,%eax
 4ae:	29 d0                	sub    %edx,%eax
 4b0:	85 c0                	test   %eax,%eax
 4b2:	75 30                	jne    4e4 <main+0x475>
        for (int j = 0; j < PGSIZE; j++) {
 4b4:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
 4bb:	eb 1e                	jmp    4db <main+0x46c>
          ptr[i * PGSIZE + j] = 0xAA;
 4bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4c0:	c1 e0 0c             	shl    $0xc,%eax
 4c3:	89 c2                	mov    %eax,%edx
 4c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
 4c8:	01 d0                	add    %edx,%eax
 4ca:	89 c2                	mov    %eax,%edx
 4cc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
 4d2:	01 d0                	add    %edx,%eax
 4d4:	c6 00 aa             	movb   $0xaa,(%eax)
        for (int j = 0; j < PGSIZE; j++) {
 4d7:	83 45 b0 01          	addl   $0x1,-0x50(%ebp)
 4db:	81 7d b0 ff 0f 00 00 	cmpl   $0xfff,-0x50(%ebp)
 4e2:	7e d9                	jle    4bd <main+0x44e>
    for (int i = 0; i < heap_pages_num; i++) {
 4e4:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 4e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 4eb:	3b 85 78 ff ff ff    	cmp    -0x88(%ebp),%eax
 4f1:	7c 9b                	jl     48e <main+0x41f>
      }
    }

    // Bring all the dummy pages and buffer back to the 
    // clock queue and reset their ref to 1
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 4f3:	83 ec 08             	sub    $0x8,%esp
 4f6:	ff 75 9c             	pushl  -0x64(%ebp)
 4f9:	ff 75 94             	pushl  -0x6c(%ebp)
 4fc:	e8 23 fb ff ff       	call   24 <access_all_dummy_pages>
 501:	83 c4 10             	add    $0x10,%esp
    buffer[0] = buffer[0];
 504:	8b 45 90             	mov    -0x70(%ebp),%eax
 507:	0f b6 10             	movzbl (%eax),%edx
 50a:	8b 45 90             	mov    -0x70(%ebp),%eax
 50d:	88 10                	mov    %dl,(%eax)

    int retval = getpgtable(pt_entries, heap_pages_num + extra_pages_num, 0);
 50f:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
 515:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
 51b:	01 d0                	add    %edx,%eax
 51d:	83 ec 04             	sub    $0x4,%esp
 520:	6a 00                	push   $0x0
 522:	50                   	push   %eax
 523:	ff 75 80             	pushl  -0x80(%ebp)
 526:	e8 e1 04 00 00       	call   a0c <getpgtable>
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    if (retval == heap_pages_num + extra_pages_num) {
 534:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
 53a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
 540:	01 d0                	add    %edx,%eax
 542:	39 85 68 ff ff ff    	cmp    %eax,-0x98(%ebp)
 548:	0f 85 7b 01 00 00    	jne    6c9 <main+0x65a>
      for (int i = 0; i < retval; i++) {
 54e:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
 555:	e9 5e 01 00 00       	jmp    6b8 <main+0x649>
              i,
              pt_entries[i].pdx,
              pt_entries[i].ptx,
              pt_entries[i].writable,
              pt_entries[i].encrypted,
              pt_entries[i].ref
 55a:	8b 45 80             	mov    -0x80(%ebp),%eax
 55d:	8b 55 ac             	mov    -0x54(%ebp),%edx
 560:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 565:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 568:	0f b6 f0             	movzbl %al,%esi
              pt_entries[i].encrypted,
 56b:	8b 45 80             	mov    -0x80(%ebp),%eax
 56e:	8b 55 ac             	mov    -0x54(%ebp),%edx
 571:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 576:	c0 e8 07             	shr    $0x7,%al
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 579:	0f b6 d8             	movzbl %al,%ebx
              pt_entries[i].writable,
 57c:	8b 45 80             	mov    -0x80(%ebp),%eax
 57f:	8b 55 ac             	mov    -0x54(%ebp),%edx
 582:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 587:	c0 e8 05             	shr    $0x5,%al
 58a:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 58d:	0f b6 c8             	movzbl %al,%ecx
              pt_entries[i].ptx,
 590:	8b 45 80             	mov    -0x80(%ebp),%eax
 593:	8b 55 ac             	mov    -0x54(%ebp),%edx
 596:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 599:	c1 e8 0a             	shr    $0xa,%eax
 59c:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5a0:	0f b7 d0             	movzwl %ax,%edx
              pt_entries[i].pdx,
 5a3:	8b 45 80             	mov    -0x80(%ebp),%eax
 5a6:	8b 7d ac             	mov    -0x54(%ebp),%edi
 5a9:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 5ad:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5b1:	0f b7 c0             	movzwl %ax,%eax
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	51                   	push   %ecx
 5b7:	52                   	push   %edx
 5b8:	50                   	push   %eax
 5b9:	ff 75 ac             	pushl  -0x54(%ebp)
 5bc:	68 44 0f 00 00       	push   $0xf44
 5c1:	6a 01                	push   $0x1
 5c3:	e8 30 05 00 00       	call   af8 <printf>
 5c8:	83 c4 20             	add    $0x20,%esp
          ); 
          
          uint expected = 0xAA;
 5cb:	c7 45 a8 aa 00 00 00 	movl   $0xaa,-0x58(%ebp)
          if (pt_entries[i].encrypted)
 5d2:	8b 45 80             	mov    -0x80(%ebp),%eax
 5d5:	8b 55 ac             	mov    -0x54(%ebp),%edx
 5d8:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 5dd:	c0 e8 07             	shr    $0x7,%al
 5e0:	84 c0                	test   %al,%al
 5e2:	74 07                	je     5eb <main+0x57c>
            expected = ~0xAA;
 5e4:	c7 45 a8 55 ff ff ff 	movl   $0xffffff55,-0x58(%ebp)

          if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 5eb:	8b 45 80             	mov    -0x80(%ebp),%eax
 5ee:	8b 55 ac             	mov    -0x54(%ebp),%edx
 5f1:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 5f5:	25 ff ff 0f 00       	and    $0xfffff,%eax
 5fa:	c1 e0 0c             	shl    $0xc,%eax
 5fd:	83 ec 08             	sub    $0x8,%esp
 600:	ff 75 90             	pushl  -0x70(%ebp)
 603:	50                   	push   %eax
 604:	e8 0b 04 00 00       	call   a14 <dump_rawphymem>
 609:	83 c4 10             	add    $0x10,%esp
 60c:	85 c0                	test   %eax,%eax
 60e:	74 10                	je     620 <main+0x5b1>
              err("dump_rawphymem return non-zero value\n");
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	68 a0 0f 00 00       	push   $0xfa0
 618:	e8 e3 f9 ff ff       	call   0 <err>
 61d:	83 c4 10             	add    $0x10,%esp
          
          for (int j = 0; j < PGSIZE; j++) {
 620:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
 627:	eb 7e                	jmp    6a7 <main+0x638>
              if (buffer[j] != (char)expected) {
 629:	8b 55 a4             	mov    -0x5c(%ebp),%edx
 62c:	8b 45 90             	mov    -0x70(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	8b 55 a8             	mov    -0x58(%ebp),%edx
 637:	38 d0                	cmp    %dl,%al
 639:	74 68                	je     6a3 <main+0x634>
                  // err("physical memory is dumped incorrectly\n");
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 63b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
 63e:	8b 45 90             	mov    -0x70(%ebp),%eax
 641:	01 d0                	add    %edx,%eax
 643:	0f b6 00             	movzbl (%eax),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	0f b6 d0             	movzbl %al,%edx
 64c:	8b 45 a8             	mov    -0x58(%ebp),%eax
 64f:	0f b6 c0             	movzbl %al,%eax
 652:	8b 4d 80             	mov    -0x80(%ebp),%ecx
 655:	8b 5d ac             	mov    -0x54(%ebp),%ebx
 658:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 65c:	66 81 e1 ff 03       	and    $0x3ff,%cx
 661:	0f b7 c9             	movzwl %cx,%ecx
 664:	89 ce                	mov    %ecx,%esi
 666:	c1 e6 16             	shl    $0x16,%esi
 669:	8b 4d 80             	mov    -0x80(%ebp),%ecx
 66c:	8b 5d ac             	mov    -0x54(%ebp),%ebx
 66f:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 672:	c1 e9 0a             	shr    $0xa,%ecx
 675:	66 81 e1 ff 03       	and    $0x3ff,%cx
 67a:	0f b7 c9             	movzwl %cx,%ecx
 67d:	c1 e1 0c             	shl    $0xc,%ecx
 680:	89 f3                	mov    %esi,%ebx
 682:	09 cb                	or     %ecx,%ebx
 684:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 687:	01 d9                	add    %ebx,%ecx
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	52                   	push   %edx
 68d:	50                   	push   %eax
 68e:	51                   	push   %ecx
 68f:	68 c8 0f 00 00       	push   $0xfc8
 694:	6a 01                	push   $0x1
 696:	e8 5d 04 00 00       	call   af8 <printf>
 69b:	83 c4 20             	add    $0x20,%esp
                    exit();
 69e:	e8 c1 02 00 00       	call   964 <exit>
          for (int j = 0; j < PGSIZE; j++) {
 6a3:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
 6a7:	81 7d a4 ff 0f 00 00 	cmpl   $0xfff,-0x5c(%ebp)
 6ae:	0f 8e 75 ff ff ff    	jle    629 <main+0x5ba>
      for (int i = 0; i < retval; i++) {
 6b4:	83 45 ac 01          	addl   $0x1,-0x54(%ebp)
 6b8:	8b 45 ac             	mov    -0x54(%ebp),%eax
 6bb:	3b 85 68 ff ff ff    	cmp    -0x98(%ebp),%eax
 6c1:	0f 8c 93 fe ff ff    	jl     55a <main+0x4eb>
 6c7:	eb 1b                	jmp    6e4 <main+0x675>
              }
          }

      }
    } else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 6c9:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
 6cf:	ff b5 78 ff ff ff    	pushl  -0x88(%ebp)
 6d5:	68 18 10 00 00       	push   $0x1018
 6da:	6a 01                	push   $0x1
 6dc:	e8 17 04 00 00       	call   af8 <printf>
 6e1:	83 c4 10             	add    $0x10,%esp
    
    exit();
 6e4:	e8 7b 02 00 00       	call   964 <exit>

000006e9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	57                   	push   %edi
 6ed:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 6ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6f1:	8b 55 10             	mov    0x10(%ebp),%edx
 6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f7:	89 cb                	mov    %ecx,%ebx
 6f9:	89 df                	mov    %ebx,%edi
 6fb:	89 d1                	mov    %edx,%ecx
 6fd:	fc                   	cld    
 6fe:	f3 aa                	rep stos %al,%es:(%edi)
 700:	89 ca                	mov    %ecx,%edx
 702:	89 fb                	mov    %edi,%ebx
 704:	89 5d 08             	mov    %ebx,0x8(%ebp)
 707:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 70a:	90                   	nop
 70b:	5b                   	pop    %ebx
 70c:	5f                   	pop    %edi
 70d:	5d                   	pop    %ebp
 70e:	c3                   	ret    

0000070f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 70f:	f3 0f 1e fb          	endbr32 
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 71f:	90                   	nop
 720:	8b 55 0c             	mov    0xc(%ebp),%edx
 723:	8d 42 01             	lea    0x1(%edx),%eax
 726:	89 45 0c             	mov    %eax,0xc(%ebp)
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	8d 48 01             	lea    0x1(%eax),%ecx
 72f:	89 4d 08             	mov    %ecx,0x8(%ebp)
 732:	0f b6 12             	movzbl (%edx),%edx
 735:	88 10                	mov    %dl,(%eax)
 737:	0f b6 00             	movzbl (%eax),%eax
 73a:	84 c0                	test   %al,%al
 73c:	75 e2                	jne    720 <strcpy+0x11>
    ;
  return os;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 741:	c9                   	leave  
 742:	c3                   	ret    

00000743 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 743:	f3 0f 1e fb          	endbr32 
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 74a:	eb 08                	jmp    754 <strcmp+0x11>
    p++, q++;
 74c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 750:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	0f b6 00             	movzbl (%eax),%eax
 75a:	84 c0                	test   %al,%al
 75c:	74 10                	je     76e <strcmp+0x2b>
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	0f b6 10             	movzbl (%eax),%edx
 764:	8b 45 0c             	mov    0xc(%ebp),%eax
 767:	0f b6 00             	movzbl (%eax),%eax
 76a:	38 c2                	cmp    %al,%dl
 76c:	74 de                	je     74c <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 76e:	8b 45 08             	mov    0x8(%ebp),%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	0f b6 d0             	movzbl %al,%edx
 777:	8b 45 0c             	mov    0xc(%ebp),%eax
 77a:	0f b6 00             	movzbl (%eax),%eax
 77d:	0f b6 c0             	movzbl %al,%eax
 780:	29 c2                	sub    %eax,%edx
 782:	89 d0                	mov    %edx,%eax
}
 784:	5d                   	pop    %ebp
 785:	c3                   	ret    

00000786 <strlen>:

uint
strlen(const char *s)
{
 786:	f3 0f 1e fb          	endbr32 
 78a:	55                   	push   %ebp
 78b:	89 e5                	mov    %esp,%ebp
 78d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 790:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 797:	eb 04                	jmp    79d <strlen+0x17>
 799:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 79d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	01 d0                	add    %edx,%eax
 7a5:	0f b6 00             	movzbl (%eax),%eax
 7a8:	84 c0                	test   %al,%al
 7aa:	75 ed                	jne    799 <strlen+0x13>
    ;
  return n;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7af:	c9                   	leave  
 7b0:	c3                   	ret    

000007b1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7b1:	f3 0f 1e fb          	endbr32 
 7b5:	55                   	push   %ebp
 7b6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 7b8:	8b 45 10             	mov    0x10(%ebp),%eax
 7bb:	50                   	push   %eax
 7bc:	ff 75 0c             	pushl  0xc(%ebp)
 7bf:	ff 75 08             	pushl  0x8(%ebp)
 7c2:	e8 22 ff ff ff       	call   6e9 <stosb>
 7c7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7cd:	c9                   	leave  
 7ce:	c3                   	ret    

000007cf <strchr>:

char*
strchr(const char *s, char c)
{
 7cf:	f3 0f 1e fb          	endbr32 
 7d3:	55                   	push   %ebp
 7d4:	89 e5                	mov    %esp,%ebp
 7d6:	83 ec 04             	sub    $0x4,%esp
 7d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7dc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 7df:	eb 14                	jmp    7f5 <strchr+0x26>
    if(*s == c)
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	0f b6 00             	movzbl (%eax),%eax
 7e7:	38 45 fc             	cmp    %al,-0x4(%ebp)
 7ea:	75 05                	jne    7f1 <strchr+0x22>
      return (char*)s;
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	eb 13                	jmp    804 <strchr+0x35>
  for(; *s; s++)
 7f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 7f5:	8b 45 08             	mov    0x8(%ebp),%eax
 7f8:	0f b6 00             	movzbl (%eax),%eax
 7fb:	84 c0                	test   %al,%al
 7fd:	75 e2                	jne    7e1 <strchr+0x12>
  return 0;
 7ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
 804:	c9                   	leave  
 805:	c3                   	ret    

00000806 <gets>:

char*
gets(char *buf, int max)
{
 806:	f3 0f 1e fb          	endbr32 
 80a:	55                   	push   %ebp
 80b:	89 e5                	mov    %esp,%ebp
 80d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 817:	eb 42                	jmp    85b <gets+0x55>
    cc = read(0, &c, 1);
 819:	83 ec 04             	sub    $0x4,%esp
 81c:	6a 01                	push   $0x1
 81e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 821:	50                   	push   %eax
 822:	6a 00                	push   $0x0
 824:	e8 53 01 00 00       	call   97c <read>
 829:	83 c4 10             	add    $0x10,%esp
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 82f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 833:	7e 33                	jle    868 <gets+0x62>
      break;
    buf[i++] = c;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8d 50 01             	lea    0x1(%eax),%edx
 83b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 83e:	89 c2                	mov    %eax,%edx
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	01 c2                	add    %eax,%edx
 845:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 849:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 84b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 84f:	3c 0a                	cmp    $0xa,%al
 851:	74 16                	je     869 <gets+0x63>
 853:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 857:	3c 0d                	cmp    $0xd,%al
 859:	74 0e                	je     869 <gets+0x63>
  for(i=0; i+1 < max; ){
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	83 c0 01             	add    $0x1,%eax
 861:	39 45 0c             	cmp    %eax,0xc(%ebp)
 864:	7f b3                	jg     819 <gets+0x13>
 866:	eb 01                	jmp    869 <gets+0x63>
      break;
 868:	90                   	nop
      break;
  }
  buf[i] = '\0';
 869:	8b 55 f4             	mov    -0xc(%ebp),%edx
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	01 d0                	add    %edx,%eax
 871:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 874:	8b 45 08             	mov    0x8(%ebp),%eax
}
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <stat>:

int
stat(const char *n, struct stat *st)
{
 879:	f3 0f 1e fb          	endbr32 
 87d:	55                   	push   %ebp
 87e:	89 e5                	mov    %esp,%ebp
 880:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 883:	83 ec 08             	sub    $0x8,%esp
 886:	6a 00                	push   $0x0
 888:	ff 75 08             	pushl  0x8(%ebp)
 88b:	e8 14 01 00 00       	call   9a4 <open>
 890:	83 c4 10             	add    $0x10,%esp
 893:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89a:	79 07                	jns    8a3 <stat+0x2a>
    return -1;
 89c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8a1:	eb 25                	jmp    8c8 <stat+0x4f>
  r = fstat(fd, st);
 8a3:	83 ec 08             	sub    $0x8,%esp
 8a6:	ff 75 0c             	pushl  0xc(%ebp)
 8a9:	ff 75 f4             	pushl  -0xc(%ebp)
 8ac:	e8 0b 01 00 00       	call   9bc <fstat>
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8b7:	83 ec 0c             	sub    $0xc,%esp
 8ba:	ff 75 f4             	pushl  -0xc(%ebp)
 8bd:	e8 ca 00 00 00       	call   98c <close>
 8c2:	83 c4 10             	add    $0x10,%esp
  return r;
 8c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8c8:	c9                   	leave  
 8c9:	c3                   	ret    

000008ca <atoi>:

int
atoi(const char *s)
{
 8ca:	f3 0f 1e fb          	endbr32 
 8ce:	55                   	push   %ebp
 8cf:	89 e5                	mov    %esp,%ebp
 8d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 8db:	eb 25                	jmp    902 <atoi+0x38>
    n = n*10 + *s++ - '0';
 8dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8e0:	89 d0                	mov    %edx,%eax
 8e2:	c1 e0 02             	shl    $0x2,%eax
 8e5:	01 d0                	add    %edx,%eax
 8e7:	01 c0                	add    %eax,%eax
 8e9:	89 c1                	mov    %eax,%ecx
 8eb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ee:	8d 50 01             	lea    0x1(%eax),%edx
 8f1:	89 55 08             	mov    %edx,0x8(%ebp)
 8f4:	0f b6 00             	movzbl (%eax),%eax
 8f7:	0f be c0             	movsbl %al,%eax
 8fa:	01 c8                	add    %ecx,%eax
 8fc:	83 e8 30             	sub    $0x30,%eax
 8ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	0f b6 00             	movzbl (%eax),%eax
 908:	3c 2f                	cmp    $0x2f,%al
 90a:	7e 0a                	jle    916 <atoi+0x4c>
 90c:	8b 45 08             	mov    0x8(%ebp),%eax
 90f:	0f b6 00             	movzbl (%eax),%eax
 912:	3c 39                	cmp    $0x39,%al
 914:	7e c7                	jle    8dd <atoi+0x13>
  return n;
 916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 919:	c9                   	leave  
 91a:	c3                   	ret    

0000091b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 91b:	f3 0f 1e fb          	endbr32 
 91f:	55                   	push   %ebp
 920:	89 e5                	mov    %esp,%ebp
 922:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 925:	8b 45 08             	mov    0x8(%ebp),%eax
 928:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 92b:	8b 45 0c             	mov    0xc(%ebp),%eax
 92e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 931:	eb 17                	jmp    94a <memmove+0x2f>
    *dst++ = *src++;
 933:	8b 55 f8             	mov    -0x8(%ebp),%edx
 936:	8d 42 01             	lea    0x1(%edx),%eax
 939:	89 45 f8             	mov    %eax,-0x8(%ebp)
 93c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93f:	8d 48 01             	lea    0x1(%eax),%ecx
 942:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 945:	0f b6 12             	movzbl (%edx),%edx
 948:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 94a:	8b 45 10             	mov    0x10(%ebp),%eax
 94d:	8d 50 ff             	lea    -0x1(%eax),%edx
 950:	89 55 10             	mov    %edx,0x10(%ebp)
 953:	85 c0                	test   %eax,%eax
 955:	7f dc                	jg     933 <memmove+0x18>
  return vdst;
 957:	8b 45 08             	mov    0x8(%ebp),%eax
}
 95a:	c9                   	leave  
 95b:	c3                   	ret    

0000095c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 95c:	b8 01 00 00 00       	mov    $0x1,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <exit>:
SYSCALL(exit)
 964:	b8 02 00 00 00       	mov    $0x2,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <wait>:
SYSCALL(wait)
 96c:	b8 03 00 00 00       	mov    $0x3,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <pipe>:
SYSCALL(pipe)
 974:	b8 04 00 00 00       	mov    $0x4,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <read>:
SYSCALL(read)
 97c:	b8 05 00 00 00       	mov    $0x5,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <write>:
SYSCALL(write)
 984:	b8 10 00 00 00       	mov    $0x10,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <close>:
SYSCALL(close)
 98c:	b8 15 00 00 00       	mov    $0x15,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <kill>:
SYSCALL(kill)
 994:	b8 06 00 00 00       	mov    $0x6,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <exec>:
SYSCALL(exec)
 99c:	b8 07 00 00 00       	mov    $0x7,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <open>:
SYSCALL(open)
 9a4:	b8 0f 00 00 00       	mov    $0xf,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <mknod>:
SYSCALL(mknod)
 9ac:	b8 11 00 00 00       	mov    $0x11,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <unlink>:
SYSCALL(unlink)
 9b4:	b8 12 00 00 00       	mov    $0x12,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <fstat>:
SYSCALL(fstat)
 9bc:	b8 08 00 00 00       	mov    $0x8,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <link>:
SYSCALL(link)
 9c4:	b8 13 00 00 00       	mov    $0x13,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <mkdir>:
SYSCALL(mkdir)
 9cc:	b8 14 00 00 00       	mov    $0x14,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <chdir>:
SYSCALL(chdir)
 9d4:	b8 09 00 00 00       	mov    $0x9,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <dup>:
SYSCALL(dup)
 9dc:	b8 0a 00 00 00       	mov    $0xa,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <getpid>:
SYSCALL(getpid)
 9e4:	b8 0b 00 00 00       	mov    $0xb,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <sbrk>:
SYSCALL(sbrk)
 9ec:	b8 0c 00 00 00       	mov    $0xc,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <sleep>:
SYSCALL(sleep)
 9f4:	b8 0d 00 00 00       	mov    $0xd,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <uptime>:
SYSCALL(uptime)
 9fc:	b8 0e 00 00 00       	mov    $0xe,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <mencrypt>:
SYSCALL(mencrypt)
 a04:	b8 16 00 00 00       	mov    $0x16,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <getpgtable>:
SYSCALL(getpgtable)
 a0c:	b8 17 00 00 00       	mov    $0x17,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 a14:	b8 18 00 00 00       	mov    $0x18,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a1c:	f3 0f 1e fb          	endbr32 
 a20:	55                   	push   %ebp
 a21:	89 e5                	mov    %esp,%ebp
 a23:	83 ec 18             	sub    $0x18,%esp
 a26:	8b 45 0c             	mov    0xc(%ebp),%eax
 a29:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a2c:	83 ec 04             	sub    $0x4,%esp
 a2f:	6a 01                	push   $0x1
 a31:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a34:	50                   	push   %eax
 a35:	ff 75 08             	pushl  0x8(%ebp)
 a38:	e8 47 ff ff ff       	call   984 <write>
 a3d:	83 c4 10             	add    $0x10,%esp
}
 a40:	90                   	nop
 a41:	c9                   	leave  
 a42:	c3                   	ret    

00000a43 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a43:	f3 0f 1e fb          	endbr32 
 a47:	55                   	push   %ebp
 a48:	89 e5                	mov    %esp,%ebp
 a4a:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a54:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a58:	74 17                	je     a71 <printint+0x2e>
 a5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a5e:	79 11                	jns    a71 <printint+0x2e>
    neg = 1;
 a60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a67:	8b 45 0c             	mov    0xc(%ebp),%eax
 a6a:	f7 d8                	neg    %eax
 a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a6f:	eb 06                	jmp    a77 <printint+0x34>
  } else {
    x = xx;
 a71:	8b 45 0c             	mov    0xc(%ebp),%eax
 a74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a84:	ba 00 00 00 00       	mov    $0x0,%edx
 a89:	f7 f1                	div    %ecx
 a8b:	89 d1                	mov    %edx,%ecx
 a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a90:	8d 50 01             	lea    0x1(%eax),%edx
 a93:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a96:	0f b6 91 f8 12 00 00 	movzbl 0x12f8(%ecx),%edx
 a9d:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa7:	ba 00 00 00 00       	mov    $0x0,%edx
 aac:	f7 f1                	div    %ecx
 aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ab5:	75 c7                	jne    a7e <printint+0x3b>
  if(neg)
 ab7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 abb:	74 2d                	je     aea <printint+0xa7>
    buf[i++] = '-';
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8d 50 01             	lea    0x1(%eax),%edx
 ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ac6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 acb:	eb 1d                	jmp    aea <printint+0xa7>
    putc(fd, buf[i]);
 acd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	01 d0                	add    %edx,%eax
 ad5:	0f b6 00             	movzbl (%eax),%eax
 ad8:	0f be c0             	movsbl %al,%eax
 adb:	83 ec 08             	sub    $0x8,%esp
 ade:	50                   	push   %eax
 adf:	ff 75 08             	pushl  0x8(%ebp)
 ae2:	e8 35 ff ff ff       	call   a1c <putc>
 ae7:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 aea:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 af2:	79 d9                	jns    acd <printint+0x8a>
}
 af4:	90                   	nop
 af5:	90                   	nop
 af6:	c9                   	leave  
 af7:	c3                   	ret    

00000af8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 af8:	f3 0f 1e fb          	endbr32 
 afc:	55                   	push   %ebp
 afd:	89 e5                	mov    %esp,%ebp
 aff:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b02:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b09:	8d 45 0c             	lea    0xc(%ebp),%eax
 b0c:	83 c0 04             	add    $0x4,%eax
 b0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b19:	e9 59 01 00 00       	jmp    c77 <printf+0x17f>
    c = fmt[i] & 0xff;
 b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
 b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b24:	01 d0                	add    %edx,%eax
 b26:	0f b6 00             	movzbl (%eax),%eax
 b29:	0f be c0             	movsbl %al,%eax
 b2c:	25 ff 00 00 00       	and    $0xff,%eax
 b31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b38:	75 2c                	jne    b66 <printf+0x6e>
      if(c == '%'){
 b3a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b3e:	75 0c                	jne    b4c <printf+0x54>
        state = '%';
 b40:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b47:	e9 27 01 00 00       	jmp    c73 <printf+0x17b>
      } else {
        putc(fd, c);
 b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b4f:	0f be c0             	movsbl %al,%eax
 b52:	83 ec 08             	sub    $0x8,%esp
 b55:	50                   	push   %eax
 b56:	ff 75 08             	pushl  0x8(%ebp)
 b59:	e8 be fe ff ff       	call   a1c <putc>
 b5e:	83 c4 10             	add    $0x10,%esp
 b61:	e9 0d 01 00 00       	jmp    c73 <printf+0x17b>
      }
    } else if(state == '%'){
 b66:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b6a:	0f 85 03 01 00 00    	jne    c73 <printf+0x17b>
      if(c == 'd'){
 b70:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b74:	75 1e                	jne    b94 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b79:	8b 00                	mov    (%eax),%eax
 b7b:	6a 01                	push   $0x1
 b7d:	6a 0a                	push   $0xa
 b7f:	50                   	push   %eax
 b80:	ff 75 08             	pushl  0x8(%ebp)
 b83:	e8 bb fe ff ff       	call   a43 <printint>
 b88:	83 c4 10             	add    $0x10,%esp
        ap++;
 b8b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b8f:	e9 d8 00 00 00       	jmp    c6c <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 b94:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b98:	74 06                	je     ba0 <printf+0xa8>
 b9a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b9e:	75 1e                	jne    bbe <printf+0xc6>
        printint(fd, *ap, 16, 0);
 ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ba3:	8b 00                	mov    (%eax),%eax
 ba5:	6a 00                	push   $0x0
 ba7:	6a 10                	push   $0x10
 ba9:	50                   	push   %eax
 baa:	ff 75 08             	pushl  0x8(%ebp)
 bad:	e8 91 fe ff ff       	call   a43 <printint>
 bb2:	83 c4 10             	add    $0x10,%esp
        ap++;
 bb5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bb9:	e9 ae 00 00 00       	jmp    c6c <printf+0x174>
      } else if(c == 's'){
 bbe:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bc2:	75 43                	jne    c07 <printf+0x10f>
        s = (char*)*ap;
 bc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bc7:	8b 00                	mov    (%eax),%eax
 bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bcc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bd4:	75 25                	jne    bfb <printf+0x103>
          s = "(null)";
 bd6:	c7 45 f4 63 10 00 00 	movl   $0x1063,-0xc(%ebp)
        while(*s != 0){
 bdd:	eb 1c                	jmp    bfb <printf+0x103>
          putc(fd, *s);
 bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be2:	0f b6 00             	movzbl (%eax),%eax
 be5:	0f be c0             	movsbl %al,%eax
 be8:	83 ec 08             	sub    $0x8,%esp
 beb:	50                   	push   %eax
 bec:	ff 75 08             	pushl  0x8(%ebp)
 bef:	e8 28 fe ff ff       	call   a1c <putc>
 bf4:	83 c4 10             	add    $0x10,%esp
          s++;
 bf7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfe:	0f b6 00             	movzbl (%eax),%eax
 c01:	84 c0                	test   %al,%al
 c03:	75 da                	jne    bdf <printf+0xe7>
 c05:	eb 65                	jmp    c6c <printf+0x174>
        }
      } else if(c == 'c'){
 c07:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c0b:	75 1d                	jne    c2a <printf+0x132>
        putc(fd, *ap);
 c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c10:	8b 00                	mov    (%eax),%eax
 c12:	0f be c0             	movsbl %al,%eax
 c15:	83 ec 08             	sub    $0x8,%esp
 c18:	50                   	push   %eax
 c19:	ff 75 08             	pushl  0x8(%ebp)
 c1c:	e8 fb fd ff ff       	call   a1c <putc>
 c21:	83 c4 10             	add    $0x10,%esp
        ap++;
 c24:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c28:	eb 42                	jmp    c6c <printf+0x174>
      } else if(c == '%'){
 c2a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c2e:	75 17                	jne    c47 <printf+0x14f>
        putc(fd, c);
 c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c33:	0f be c0             	movsbl %al,%eax
 c36:	83 ec 08             	sub    $0x8,%esp
 c39:	50                   	push   %eax
 c3a:	ff 75 08             	pushl  0x8(%ebp)
 c3d:	e8 da fd ff ff       	call   a1c <putc>
 c42:	83 c4 10             	add    $0x10,%esp
 c45:	eb 25                	jmp    c6c <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c47:	83 ec 08             	sub    $0x8,%esp
 c4a:	6a 25                	push   $0x25
 c4c:	ff 75 08             	pushl  0x8(%ebp)
 c4f:	e8 c8 fd ff ff       	call   a1c <putc>
 c54:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c5a:	0f be c0             	movsbl %al,%eax
 c5d:	83 ec 08             	sub    $0x8,%esp
 c60:	50                   	push   %eax
 c61:	ff 75 08             	pushl  0x8(%ebp)
 c64:	e8 b3 fd ff ff       	call   a1c <putc>
 c69:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 c73:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c77:	8b 55 0c             	mov    0xc(%ebp),%edx
 c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7d:	01 d0                	add    %edx,%eax
 c7f:	0f b6 00             	movzbl (%eax),%eax
 c82:	84 c0                	test   %al,%al
 c84:	0f 85 94 fe ff ff    	jne    b1e <printf+0x26>
    }
  }
}
 c8a:	90                   	nop
 c8b:	90                   	nop
 c8c:	c9                   	leave  
 c8d:	c3                   	ret    

00000c8e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c8e:	f3 0f 1e fb          	endbr32 
 c92:	55                   	push   %ebp
 c93:	89 e5                	mov    %esp,%ebp
 c95:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c98:	8b 45 08             	mov    0x8(%ebp),%eax
 c9b:	83 e8 08             	sub    $0x8,%eax
 c9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ca1:	a1 14 13 00 00       	mov    0x1314,%eax
 ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ca9:	eb 24                	jmp    ccf <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cae:	8b 00                	mov    (%eax),%eax
 cb0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 cb3:	72 12                	jb     cc7 <free+0x39>
 cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cbb:	77 24                	ja     ce1 <free+0x53>
 cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc0:	8b 00                	mov    (%eax),%eax
 cc2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 cc5:	72 1a                	jb     ce1 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cca:	8b 00                	mov    (%eax),%eax
 ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cd5:	76 d4                	jbe    cab <free+0x1d>
 cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cda:	8b 00                	mov    (%eax),%eax
 cdc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 cdf:	73 ca                	jae    cab <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce4:	8b 40 04             	mov    0x4(%eax),%eax
 ce7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf1:	01 c2                	add    %eax,%edx
 cf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf6:	8b 00                	mov    (%eax),%eax
 cf8:	39 c2                	cmp    %eax,%edx
 cfa:	75 24                	jne    d20 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 cfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cff:	8b 50 04             	mov    0x4(%eax),%edx
 d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d05:	8b 00                	mov    (%eax),%eax
 d07:	8b 40 04             	mov    0x4(%eax),%eax
 d0a:	01 c2                	add    %eax,%edx
 d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d0f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d15:	8b 00                	mov    (%eax),%eax
 d17:	8b 10                	mov    (%eax),%edx
 d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d1c:	89 10                	mov    %edx,(%eax)
 d1e:	eb 0a                	jmp    d2a <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 d20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d23:	8b 10                	mov    (%eax),%edx
 d25:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d28:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d2d:	8b 40 04             	mov    0x4(%eax),%eax
 d30:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3a:	01 d0                	add    %edx,%eax
 d3c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 d3f:	75 20                	jne    d61 <free+0xd3>
    p->s.size += bp->s.size;
 d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d44:	8b 50 04             	mov    0x4(%eax),%edx
 d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d4a:	8b 40 04             	mov    0x4(%eax),%eax
 d4d:	01 c2                	add    %eax,%edx
 d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d52:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d58:	8b 10                	mov    (%eax),%edx
 d5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5d:	89 10                	mov    %edx,(%eax)
 d5f:	eb 08                	jmp    d69 <free+0xdb>
  } else
    p->s.ptr = bp;
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d67:	89 10                	mov    %edx,(%eax)
  freep = p;
 d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6c:	a3 14 13 00 00       	mov    %eax,0x1314
}
 d71:	90                   	nop
 d72:	c9                   	leave  
 d73:	c3                   	ret    

00000d74 <morecore>:

static Header*
morecore(uint nu)
{
 d74:	f3 0f 1e fb          	endbr32 
 d78:	55                   	push   %ebp
 d79:	89 e5                	mov    %esp,%ebp
 d7b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d7e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d85:	77 07                	ja     d8e <morecore+0x1a>
    nu = 4096;
 d87:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d8e:	8b 45 08             	mov    0x8(%ebp),%eax
 d91:	c1 e0 03             	shl    $0x3,%eax
 d94:	83 ec 0c             	sub    $0xc,%esp
 d97:	50                   	push   %eax
 d98:	e8 4f fc ff ff       	call   9ec <sbrk>
 d9d:	83 c4 10             	add    $0x10,%esp
 da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 da3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 da7:	75 07                	jne    db0 <morecore+0x3c>
    return 0;
 da9:	b8 00 00 00 00       	mov    $0x0,%eax
 dae:	eb 26                	jmp    dd6 <morecore+0x62>
  hp = (Header*)p;
 db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db9:	8b 55 08             	mov    0x8(%ebp),%edx
 dbc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc2:	83 c0 08             	add    $0x8,%eax
 dc5:	83 ec 0c             	sub    $0xc,%esp
 dc8:	50                   	push   %eax
 dc9:	e8 c0 fe ff ff       	call   c8e <free>
 dce:	83 c4 10             	add    $0x10,%esp
  return freep;
 dd1:	a1 14 13 00 00       	mov    0x1314,%eax
}
 dd6:	c9                   	leave  
 dd7:	c3                   	ret    

00000dd8 <malloc>:

void*
malloc(uint nbytes)
{
 dd8:	f3 0f 1e fb          	endbr32 
 ddc:	55                   	push   %ebp
 ddd:	89 e5                	mov    %esp,%ebp
 ddf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 de2:	8b 45 08             	mov    0x8(%ebp),%eax
 de5:	83 c0 07             	add    $0x7,%eax
 de8:	c1 e8 03             	shr    $0x3,%eax
 deb:	83 c0 01             	add    $0x1,%eax
 dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 df1:	a1 14 13 00 00       	mov    0x1314,%eax
 df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 df9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 dfd:	75 23                	jne    e22 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 dff:	c7 45 f0 0c 13 00 00 	movl   $0x130c,-0x10(%ebp)
 e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e09:	a3 14 13 00 00       	mov    %eax,0x1314
 e0e:	a1 14 13 00 00       	mov    0x1314,%eax
 e13:	a3 0c 13 00 00       	mov    %eax,0x130c
    base.s.size = 0;
 e18:	c7 05 10 13 00 00 00 	movl   $0x0,0x1310
 e1f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e25:	8b 00                	mov    (%eax),%eax
 e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e2d:	8b 40 04             	mov    0x4(%eax),%eax
 e30:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e33:	77 4d                	ja     e82 <malloc+0xaa>
      if(p->s.size == nunits)
 e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e38:	8b 40 04             	mov    0x4(%eax),%eax
 e3b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e3e:	75 0c                	jne    e4c <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e43:	8b 10                	mov    (%eax),%edx
 e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e48:	89 10                	mov    %edx,(%eax)
 e4a:	eb 26                	jmp    e72 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4f:	8b 40 04             	mov    0x4(%eax),%eax
 e52:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e55:	89 c2                	mov    %eax,%edx
 e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e5a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e60:	8b 40 04             	mov    0x4(%eax),%eax
 e63:	c1 e0 03             	shl    $0x3,%eax
 e66:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e6f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e75:	a3 14 13 00 00       	mov    %eax,0x1314
      return (void*)(p + 1);
 e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7d:	83 c0 08             	add    $0x8,%eax
 e80:	eb 3b                	jmp    ebd <malloc+0xe5>
    }
    if(p == freep)
 e82:	a1 14 13 00 00       	mov    0x1314,%eax
 e87:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e8a:	75 1e                	jne    eaa <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 e8c:	83 ec 0c             	sub    $0xc,%esp
 e8f:	ff 75 ec             	pushl  -0x14(%ebp)
 e92:	e8 dd fe ff ff       	call   d74 <morecore>
 e97:	83 c4 10             	add    $0x10,%esp
 e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ea1:	75 07                	jne    eaa <malloc+0xd2>
        return 0;
 ea3:	b8 00 00 00 00       	mov    $0x0,%eax
 ea8:	eb 13                	jmp    ebd <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
 eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb3:	8b 00                	mov    (%eax),%eax
 eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 eb8:	e9 6d ff ff ff       	jmp    e2a <malloc+0x52>
  }
}
 ebd:	c9                   	leave  
 ebe:	c3                   	ret    

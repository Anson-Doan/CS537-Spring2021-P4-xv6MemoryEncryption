
_test_12:     file format elf32-i386


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
  10:	68 e0 0e 00 00       	push   $0xee0
  15:	6a 01                	push   $0x1
  17:	e8 fc 0a 00 00       	call   b18 <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 60 09 00 00       	call   984 <exit>

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
  5d:	68 f4 0e 00 00       	push   $0xef4
  62:	6a 01                	push   $0x1
  64:	e8 af 0a 00 00       	call   b18 <printf>
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
  84:	83 ec 78             	sub    $0x78,%esp
    const uint PAGES_NUM = 32;
  87:	c7 45 b4 20 00 00 00 	movl   $0x20,-0x4c(%ebp)
    const uint expected_dummy_pages_num = 4;
  8e:	c7 45 b0 04 00 00 00 	movl   $0x4,-0x50(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  95:	8b 45 b0             	mov    -0x50(%ebp),%eax
  98:	83 e8 01             	sub    $0x1,%eax
  9b:	89 45 ac             	mov    %eax,-0x54(%ebp)
  9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
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
 111:	89 45 a8             	mov    %eax,-0x58(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 114:	83 ec 0c             	sub    $0xc,%esp
 117:	68 00 10 00 00       	push   $0x1000
 11c:	e8 eb 08 00 00       	call   a0c <sbrk>
 121:	83 c4 10             	add    $0x10,%esp
 124:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    char *sp = buffer - PGSIZE;
 127:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 12a:	2d 00 10 00 00       	sub    $0x1000,%eax
 12f:	89 45 a0             	mov    %eax,-0x60(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 132:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 135:	2d 00 20 00 00       	sub    $0x2000,%eax
 13a:	89 45 9c             	mov    %eax,-0x64(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 13d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 140:	83 e8 01             	sub    $0x1,%eax
 143:	89 45 98             	mov    %eax,-0x68(%ebp)
 146:	8b 45 b4             	mov    -0x4c(%ebp),%eax
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
 171:	89 e7                	mov    %esp,%edi
 173:	29 d7                	sub    %edx,%edi
 175:	89 fa                	mov    %edi,%edx
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
 1b9:	89 45 94             	mov    %eax,-0x6c(%ebp)

    uint text_pages = (uint) boundary / PGSIZE;
 1bc:	8b 45 9c             	mov    -0x64(%ebp),%eax
 1bf:	c1 e8 0c             	shr    $0xc,%eax
 1c2:	89 45 90             	mov    %eax,-0x70(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1c5:	8b 45 b0             	mov    -0x50(%ebp),%eax
 1c8:	83 e8 01             	sub    $0x1,%eax
 1cb:	39 45 90             	cmp    %eax,-0x70(%ebp)
 1ce:	76 10                	jbe    1e0 <main+0x171>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1d0:	83 ec 0c             	sub    $0xc,%esp
 1d3:	68 f8 0e 00 00       	push   $0xef8
 1d8:	e8 23 fe ff ff       	call   0 <err>
 1dd:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < text_pages; i++)
 1e0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 1e7:	eb 15                	jmp    1fe <main+0x18f>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1e9:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1ec:	c1 e0 0c             	shl    $0xc,%eax
 1ef:	89 c1                	mov    %eax,%ecx
 1f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
 1f4:	8b 55 c0             	mov    -0x40(%ebp),%edx
 1f7:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 1fa:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
 1fe:	8b 45 c0             	mov    -0x40(%ebp),%eax
 201:	39 45 90             	cmp    %eax,-0x70(%ebp)
 204:	77 e3                	ja     1e9 <main+0x17a>
    dummy_pages[text_pages] = sp;
 206:	8b 45 a8             	mov    -0x58(%ebp),%eax
 209:	8b 55 90             	mov    -0x70(%ebp),%edx
 20c:	8b 4d a0             	mov    -0x60(%ebp),%ecx
 20f:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 212:	8b 45 90             	mov    -0x70(%ebp),%eax
 215:	83 c0 01             	add    $0x1,%eax
 218:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 21b:	eb 1d                	jmp    23a <main+0x1cb>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 21d:	83 ec 0c             	sub    $0xc,%esp
 220:	68 00 10 00 00       	push   $0x1000
 225:	e8 e2 07 00 00       	call   a0c <sbrk>
 22a:	83 c4 10             	add    $0x10,%esp
 22d:	8b 55 a8             	mov    -0x58(%ebp),%edx
 230:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 233:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 236:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
 23a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 23d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
 240:	77 db                	ja     21d <main+0x1ae>
    

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 242:	83 ec 08             	sub    $0x8,%esp
 245:	ff 75 b0             	pushl  -0x50(%ebp)
 248:	ff 75 a8             	pushl  -0x58(%ebp)
 24b:	e8 d4 fd ff ff       	call   24 <access_all_dummy_pages>
 250:	83 c4 10             	add    $0x10,%esp
    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 253:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 256:	0f b6 10             	movzbl (%eax),%edx
 259:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 25c:	88 10                	mov    %dl,(%eax)

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 25e:	b8 07 00 00 00       	mov    $0x7,%eax
 263:	2b 45 b0             	sub    -0x50(%ebp),%eax
 266:	89 45 8c             	mov    %eax,-0x74(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 269:	8b 45 8c             	mov    -0x74(%ebp),%eax
 26c:	c1 e0 0c             	shl    $0xc,%eax
 26f:	83 ec 0c             	sub    $0xc,%esp
 272:	50                   	push   %eax
 273:	e8 94 07 00 00       	call   a0c <sbrk>
 278:	83 c4 10             	add    $0x10,%esp
 27b:	89 45 88             	mov    %eax,-0x78(%ebp)
    for (int i = 0; i < heap_pages_num; i++) {
 27e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 285:	eb 31                	jmp    2b8 <main+0x249>
      for (int j = 0; j < PGSIZE; j++) {
 287:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
 28e:	eb 1b                	jmp    2ab <main+0x23c>
        ptr[i * PGSIZE + j] = 0x0;
 290:	8b 45 c8             	mov    -0x38(%ebp),%eax
 293:	c1 e0 0c             	shl    $0xc,%eax
 296:	89 c2                	mov    %eax,%edx
 298:	8b 45 cc             	mov    -0x34(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	89 c2                	mov    %eax,%edx
 29f:	8b 45 88             	mov    -0x78(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	c6 00 00             	movb   $0x0,(%eax)
      for (int j = 0; j < PGSIZE; j++) {
 2a7:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 2ab:	81 7d cc ff 0f 00 00 	cmpl   $0xfff,-0x34(%ebp)
 2b2:	7e dc                	jle    290 <main+0x221>
    for (int i = 0; i < heap_pages_num; i++) {
 2b4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 2b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2bb:	3b 45 8c             	cmp    -0x74(%ebp),%eax
 2be:	7c c7                	jl     287 <main+0x218>
      }
    }

    char* extra_pages = sbrk(PGSIZE * sizeof(char));        
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	68 00 10 00 00       	push   $0x1000
 2c8:	e8 3f 07 00 00       	call   a0c <sbrk>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	89 45 84             	mov    %eax,-0x7c(%ebp)
    for (int j = 0; j < PGSIZE; j++) {
 2d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 2da:	eb 0f                	jmp    2eb <main+0x27c>
        extra_pages[j] = 0x0;
 2dc:	8b 55 d0             	mov    -0x30(%ebp),%edx
 2df:	8b 45 84             	mov    -0x7c(%ebp),%eax
 2e2:	01 d0                	add    %edx,%eax
 2e4:	c6 00 00             	movb   $0x0,(%eax)
    for (int j = 0; j < PGSIZE; j++) {
 2e7:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 2eb:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
 2f2:	7e e8                	jle    2dc <main+0x26d>
    }

    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 2f4:	83 ec 08             	sub    $0x8,%esp
 2f7:	ff 75 b0             	pushl  -0x50(%ebp)
 2fa:	ff 75 a8             	pushl  -0x58(%ebp)
 2fd:	e8 22 fd ff ff       	call   24 <access_all_dummy_pages>
 302:	83 c4 10             	add    $0x10,%esp
    buffer[0] = buffer[0];
 305:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 308:	0f b6 10             	movzbl (%eax),%edx
 30b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 30e:	88 10                	mov    %dl,(%eax)

    if (fork() == 0) {
 310:	e8 67 06 00 00       	call   97c <fork>
 315:	85 c0                	test   %eax,%eax
 317:	0f 85 d8 01 00 00    	jne    4f5 <main+0x486>
        printf(1, "XV6_TEST_OUTPUT Child process is calling getpgtable\n");
 31d:	83 ec 08             	sub    $0x8,%esp
 320:	68 64 0f 00 00       	push   $0xf64
 325:	6a 01                	push   $0x1
 327:	e8 ec 07 00 00       	call   b18 <printf>
 32c:	83 c4 10             	add    $0x10,%esp
        int retval = getpgtable(pt_entries, heap_pages_num + 1, 0);
 32f:	8b 45 8c             	mov    -0x74(%ebp),%eax
 332:	83 c0 01             	add    $0x1,%eax
 335:	83 ec 04             	sub    $0x4,%esp
 338:	6a 00                	push   $0x0
 33a:	50                   	push   %eax
 33b:	ff 75 94             	pushl  -0x6c(%ebp)
 33e:	e8 e9 06 00 00       	call   a2c <getpgtable>
 343:	83 c4 10             	add    $0x10,%esp
 346:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
        if (retval == heap_pages_num + 1) {
 34c:	8b 45 8c             	mov    -0x74(%ebp),%eax
 34f:	83 c0 01             	add    $0x1,%eax
 352:	39 85 7c ff ff ff    	cmp    %eax,-0x84(%ebp)
 358:	0f 85 7a 01 00 00    	jne    4d8 <main+0x469>
            for (int i = 0; i < retval; i++) {
 35e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 365:	e9 5a 01 00 00       	jmp    4c4 <main+0x455>
                    i,
                    pt_entries[i].pdx,
                    pt_entries[i].ptx,
                    pt_entries[i].writable,
                    pt_entries[i].encrypted,
                    pt_entries[i].ref
 36a:	8b 45 94             	mov    -0x6c(%ebp),%eax
 36d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 370:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 375:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 378:	0f b6 f0             	movzbl %al,%esi
                    pt_entries[i].encrypted,
 37b:	8b 45 94             	mov    -0x6c(%ebp),%eax
 37e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 381:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 386:	c0 e8 07             	shr    $0x7,%al
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 389:	0f b6 d8             	movzbl %al,%ebx
                    pt_entries[i].writable,
 38c:	8b 45 94             	mov    -0x6c(%ebp),%eax
 38f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 392:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 397:	c0 e8 05             	shr    $0x5,%al
 39a:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 39d:	0f b6 c8             	movzbl %al,%ecx
                    pt_entries[i].ptx,
 3a0:	8b 45 94             	mov    -0x6c(%ebp),%eax
 3a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3a6:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 3a9:	c1 e8 0a             	shr    $0xa,%eax
 3ac:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3b0:	0f b7 d0             	movzwl %ax,%edx
                    pt_entries[i].pdx,
 3b3:	8b 45 94             	mov    -0x6c(%ebp),%eax
 3b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3b9:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 3bd:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3c1:	0f b7 c0             	movzwl %ax,%eax
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	51                   	push   %ecx
 3c7:	52                   	push   %edx
 3c8:	50                   	push   %eax
 3c9:	ff 75 d4             	pushl  -0x2c(%ebp)
 3cc:	68 9c 0f 00 00       	push   $0xf9c
 3d1:	6a 01                	push   $0x1
 3d3:	e8 40 07 00 00       	call   b18 <printf>
 3d8:	83 c4 20             	add    $0x20,%esp
                ); 
                
                uint expected = 0x0;
 3db:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
                if (pt_entries[i].encrypted)
 3e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
 3e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3e8:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3ed:	c0 e8 07             	shr    $0x7,%al
 3f0:	84 c0                	test   %al,%al
 3f2:	74 03                	je     3f7 <main+0x388>
                    expected = ~expected;
 3f4:	f7 55 d8             	notl   -0x28(%ebp)

                if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 3f7:	8b 45 94             	mov    -0x6c(%ebp),%eax
 3fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3fd:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 401:	25 ff ff 0f 00       	and    $0xfffff,%eax
 406:	c1 e0 0c             	shl    $0xc,%eax
 409:	83 ec 08             	sub    $0x8,%esp
 40c:	ff 75 a4             	pushl  -0x5c(%ebp)
 40f:	50                   	push   %eax
 410:	e8 1f 06 00 00       	call   a34 <dump_rawphymem>
 415:	83 c4 10             	add    $0x10,%esp
 418:	85 c0                	test   %eax,%eax
 41a:	74 10                	je     42c <main+0x3bd>
                    err("dump_rawphymem return non-zero value\n");
 41c:	83 ec 0c             	sub    $0xc,%esp
 41f:	68 f8 0f 00 00       	push   $0xff8
 424:	e8 d7 fb ff ff       	call   0 <err>
 429:	83 c4 10             	add    $0x10,%esp
                
                for (int j = 0; j < PGSIZE; j++) {
 42c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 433:	eb 7e                	jmp    4b3 <main+0x444>
                    if (buffer[j] != (char)expected) {
 435:	8b 55 dc             	mov    -0x24(%ebp),%edx
 438:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 43b:	01 d0                	add    %edx,%eax
 43d:	0f b6 00             	movzbl (%eax),%eax
 440:	8b 55 d8             	mov    -0x28(%ebp),%edx
 443:	38 d0                	cmp    %dl,%al
 445:	74 68                	je     4af <main+0x440>
                        // err("physical memory is dumped incorrectly\n");
                            printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 447:	8b 55 dc             	mov    -0x24(%ebp),%edx
 44a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 44d:	01 d0                	add    %edx,%eax
 44f:	0f b6 00             	movzbl (%eax),%eax
 452:	0f be c0             	movsbl %al,%eax
 455:	0f b6 d0             	movzbl %al,%edx
 458:	8b 45 d8             	mov    -0x28(%ebp),%eax
 45b:	0f b6 c0             	movzbl %al,%eax
 45e:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
 461:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 464:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 468:	66 81 e1 ff 03       	and    $0x3ff,%cx
 46d:	0f b7 c9             	movzwl %cx,%ecx
 470:	89 ce                	mov    %ecx,%esi
 472:	c1 e6 16             	shl    $0x16,%esi
 475:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
 478:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 47b:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 47e:	c1 e9 0a             	shr    $0xa,%ecx
 481:	66 81 e1 ff 03       	and    $0x3ff,%cx
 486:	0f b7 c9             	movzwl %cx,%ecx
 489:	c1 e1 0c             	shl    $0xc,%ecx
 48c:	09 ce                	or     %ecx,%esi
 48e:	89 f3                	mov    %esi,%ebx
 490:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 493:	01 d9                	add    %ebx,%ecx
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	52                   	push   %edx
 499:	50                   	push   %eax
 49a:	51                   	push   %ecx
 49b:	68 20 10 00 00       	push   $0x1020
 4a0:	6a 01                	push   $0x1
 4a2:	e8 71 06 00 00       	call   b18 <printf>
 4a7:	83 c4 20             	add    $0x20,%esp
                            exit();
 4aa:	e8 d5 04 00 00       	call   984 <exit>
                for (int j = 0; j < PGSIZE; j++) {
 4af:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 4b3:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%ebp)
 4ba:	0f 8e 75 ff ff ff    	jle    435 <main+0x3c6>
            for (int i = 0; i < retval; i++) {
 4c0:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 4c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c7:	3b 85 7c ff ff ff    	cmp    -0x84(%ebp),%eax
 4cd:	0f 8c 97 fe ff ff    	jl     36a <main+0x2fb>
 4d3:	e9 2c 02 00 00       	jmp    704 <main+0x695>
                    }
                }
            }

        } else {
            printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 4d8:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
 4de:	ff 75 8c             	pushl  -0x74(%ebp)
 4e1:	68 70 10 00 00       	push   $0x1070
 4e6:	6a 01                	push   $0x1
 4e8:	e8 2b 06 00 00       	call   b18 <printf>
 4ed:	83 c4 10             	add    $0x10,%esp
            exit();
 4f0:	e8 8f 04 00 00       	call   984 <exit>
        }
    } else {
        wait();
 4f5:	e8 92 04 00 00       	call   98c <wait>
        for (int j = 0; j < PGSIZE; j++) {
 4fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 501:	eb 0f                	jmp    512 <main+0x4a3>
            ptr[j] = 0x0;
 503:	8b 55 e0             	mov    -0x20(%ebp),%edx
 506:	8b 45 88             	mov    -0x78(%ebp),%eax
 509:	01 d0                	add    %edx,%eax
 50b:	c6 00 00             	movb   $0x0,(%eax)
        for (int j = 0; j < PGSIZE; j++) {
 50e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 512:	81 7d e0 ff 0f 00 00 	cmpl   $0xfff,-0x20(%ebp)
 519:	7e e8                	jle    503 <main+0x494>
        }

        access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 51b:	83 ec 08             	sub    $0x8,%esp
 51e:	ff 75 b0             	pushl  -0x50(%ebp)
 521:	ff 75 a8             	pushl  -0x58(%ebp)
 524:	e8 fb fa ff ff       	call   24 <access_all_dummy_pages>
 529:	83 c4 10             	add    $0x10,%esp
        buffer[0] = buffer[0];
 52c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 52f:	0f b6 10             	movzbl (%eax),%edx
 532:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 535:	88 10                	mov    %dl,(%eax)

        printf(1, "XV6_TEST_OUTPUT Parent process is calling getpgtable\n");
 537:	83 ec 08             	sub    $0x8,%esp
 53a:	68 bc 10 00 00       	push   $0x10bc
 53f:	6a 01                	push   $0x1
 541:	e8 d2 05 00 00       	call   b18 <printf>
 546:	83 c4 10             	add    $0x10,%esp
        int retval = getpgtable(pt_entries, heap_pages_num + 1, 0);
 549:	8b 45 8c             	mov    -0x74(%ebp),%eax
 54c:	83 c0 01             	add    $0x1,%eax
 54f:	83 ec 04             	sub    $0x4,%esp
 552:	6a 00                	push   $0x0
 554:	50                   	push   %eax
 555:	ff 75 94             	pushl  -0x6c(%ebp)
 558:	e8 cf 04 00 00       	call   a2c <getpgtable>
 55d:	83 c4 10             	add    $0x10,%esp
 560:	89 45 80             	mov    %eax,-0x80(%ebp)
        if (retval == heap_pages_num + 1) {
 563:	8b 45 8c             	mov    -0x74(%ebp),%eax
 566:	83 c0 01             	add    $0x1,%eax
 569:	39 45 80             	cmp    %eax,-0x80(%ebp)
 56c:	0f 85 78 01 00 00    	jne    6ea <main+0x67b>
            for (int i = 0; i < retval; i++) {
 572:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 579:	e9 5e 01 00 00       	jmp    6dc <main+0x66d>
                    i,
                    pt_entries[i].pdx,
                    pt_entries[i].ptx,
                    pt_entries[i].writable,
                    pt_entries[i].encrypted,
                    pt_entries[i].ref
 57e:	8b 45 94             	mov    -0x6c(%ebp),%eax
 581:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 584:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 589:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 58c:	0f b6 f0             	movzbl %al,%esi
                    pt_entries[i].encrypted,
 58f:	8b 45 94             	mov    -0x6c(%ebp),%eax
 592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 595:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 59a:	c0 e8 07             	shr    $0x7,%al
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 59d:	0f b6 d8             	movzbl %al,%ebx
                    pt_entries[i].writable,
 5a0:	8b 45 94             	mov    -0x6c(%ebp),%eax
 5a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5a6:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 5ab:	c0 e8 05             	shr    $0x5,%al
 5ae:	83 e0 01             	and    $0x1,%eax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5b1:	0f b6 c8             	movzbl %al,%ecx
                    pt_entries[i].ptx,
 5b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
 5b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5ba:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 5bd:	c1 e8 0a             	shr    $0xa,%eax
 5c0:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5c4:	0f b7 d0             	movzwl %ax,%edx
                    pt_entries[i].pdx,
 5c7:	8b 45 94             	mov    -0x6c(%ebp),%eax
 5ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cd:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 5d1:	66 25 ff 03          	and    $0x3ff,%ax
                printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5d5:	0f b7 c0             	movzwl %ax,%eax
 5d8:	56                   	push   %esi
 5d9:	53                   	push   %ebx
 5da:	51                   	push   %ecx
 5db:	52                   	push   %edx
 5dc:	50                   	push   %eax
 5dd:	ff 75 e4             	pushl  -0x1c(%ebp)
 5e0:	68 9c 0f 00 00       	push   $0xf9c
 5e5:	6a 01                	push   $0x1
 5e7:	e8 2c 05 00 00       	call   b18 <printf>
 5ec:	83 c4 20             	add    $0x20,%esp
                ); 
                
                uint expected = 0x0;
 5ef:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
                if (pt_entries[i].encrypted)
 5f6:	8b 45 94             	mov    -0x6c(%ebp),%eax
 5f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5fc:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 601:	c0 e8 07             	shr    $0x7,%al
 604:	84 c0                	test   %al,%al
 606:	74 07                	je     60f <main+0x5a0>
                    expected = ~0x0;
 608:	c7 45 bc ff ff ff ff 	movl   $0xffffffff,-0x44(%ebp)

                if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 60f:	8b 45 94             	mov    -0x6c(%ebp),%eax
 612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 615:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 619:	25 ff ff 0f 00       	and    $0xfffff,%eax
 61e:	c1 e0 0c             	shl    $0xc,%eax
 621:	83 ec 08             	sub    $0x8,%esp
 624:	ff 75 a4             	pushl  -0x5c(%ebp)
 627:	50                   	push   %eax
 628:	e8 07 04 00 00       	call   a34 <dump_rawphymem>
 62d:	83 c4 10             	add    $0x10,%esp
 630:	85 c0                	test   %eax,%eax
 632:	74 10                	je     644 <main+0x5d5>
                    err("dump_rawphymem return non-zero value\n");
 634:	83 ec 0c             	sub    $0xc,%esp
 637:	68 f8 0f 00 00       	push   $0xff8
 63c:	e8 bf f9 ff ff       	call   0 <err>
 641:	83 c4 10             	add    $0x10,%esp
                
                for (int j = 0; j < PGSIZE; j++) {
 644:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
 64b:	eb 7e                	jmp    6cb <main+0x65c>
                    if (buffer[j] != (char)expected) {
 64d:	8b 55 b8             	mov    -0x48(%ebp),%edx
 650:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 653:	01 d0                	add    %edx,%eax
 655:	0f b6 00             	movzbl (%eax),%eax
 658:	8b 55 bc             	mov    -0x44(%ebp),%edx
 65b:	38 d0                	cmp    %dl,%al
 65d:	74 68                	je     6c7 <main+0x658>
                        // err("physical memory is dumped incorrectly\n");
                            printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 65f:	8b 55 b8             	mov    -0x48(%ebp),%edx
 662:	8b 45 a4             	mov    -0x5c(%ebp),%eax
 665:	01 d0                	add    %edx,%eax
 667:	0f b6 00             	movzbl (%eax),%eax
 66a:	0f be c0             	movsbl %al,%eax
 66d:	0f b6 d0             	movzbl %al,%edx
 670:	8b 45 bc             	mov    -0x44(%ebp),%eax
 673:	0f b6 c0             	movzbl %al,%eax
 676:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
 679:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
 67c:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 680:	66 81 e1 ff 03       	and    $0x3ff,%cx
 685:	0f b7 c9             	movzwl %cx,%ecx
 688:	89 ce                	mov    %ecx,%esi
 68a:	c1 e6 16             	shl    $0x16,%esi
 68d:	8b 4d 94             	mov    -0x6c(%ebp),%ecx
 690:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
 693:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 696:	c1 e9 0a             	shr    $0xa,%ecx
 699:	66 81 e1 ff 03       	and    $0x3ff,%cx
 69e:	0f b7 c9             	movzwl %cx,%ecx
 6a1:	c1 e1 0c             	shl    $0xc,%ecx
 6a4:	89 f3                	mov    %esi,%ebx
 6a6:	09 cb                	or     %ecx,%ebx
 6a8:	8b 4d b8             	mov    -0x48(%ebp),%ecx
 6ab:	01 d9                	add    %ebx,%ecx
 6ad:	83 ec 0c             	sub    $0xc,%esp
 6b0:	52                   	push   %edx
 6b1:	50                   	push   %eax
 6b2:	51                   	push   %ecx
 6b3:	68 20 10 00 00       	push   $0x1020
 6b8:	6a 01                	push   $0x1
 6ba:	e8 59 04 00 00       	call   b18 <printf>
 6bf:	83 c4 20             	add    $0x20,%esp
                            exit();
 6c2:	e8 bd 02 00 00       	call   984 <exit>
                for (int j = 0; j < PGSIZE; j++) {
 6c7:	83 45 b8 01          	addl   $0x1,-0x48(%ebp)
 6cb:	81 7d b8 ff 0f 00 00 	cmpl   $0xfff,-0x48(%ebp)
 6d2:	0f 8e 75 ff ff ff    	jle    64d <main+0x5de>
            for (int i = 0; i < retval; i++) {
 6d8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	3b 45 80             	cmp    -0x80(%ebp),%eax
 6e2:	0f 8c 96 fe ff ff    	jl     57e <main+0x50f>
 6e8:	eb 1a                	jmp    704 <main+0x695>
                    }
                }
            }

        } else {
            printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 6ea:	ff 75 80             	pushl  -0x80(%ebp)
 6ed:	ff 75 8c             	pushl  -0x74(%ebp)
 6f0:	68 70 10 00 00       	push   $0x1070
 6f5:	6a 01                	push   $0x1
 6f7:	e8 1c 04 00 00       	call   b18 <printf>
 6fc:	83 c4 10             	add    $0x10,%esp
            exit();
 6ff:	e8 80 02 00 00       	call   984 <exit>
        }
    }

    exit();
 704:	e8 7b 02 00 00       	call   984 <exit>

00000709 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	57                   	push   %edi
 70d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 70e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 711:	8b 55 10             	mov    0x10(%ebp),%edx
 714:	8b 45 0c             	mov    0xc(%ebp),%eax
 717:	89 cb                	mov    %ecx,%ebx
 719:	89 df                	mov    %ebx,%edi
 71b:	89 d1                	mov    %edx,%ecx
 71d:	fc                   	cld    
 71e:	f3 aa                	rep stos %al,%es:(%edi)
 720:	89 ca                	mov    %ecx,%edx
 722:	89 fb                	mov    %edi,%ebx
 724:	89 5d 08             	mov    %ebx,0x8(%ebp)
 727:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 72a:	90                   	nop
 72b:	5b                   	pop    %ebx
 72c:	5f                   	pop    %edi
 72d:	5d                   	pop    %ebp
 72e:	c3                   	ret    

0000072f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 72f:	f3 0f 1e fb          	endbr32 
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 73f:	90                   	nop
 740:	8b 55 0c             	mov    0xc(%ebp),%edx
 743:	8d 42 01             	lea    0x1(%edx),%eax
 746:	89 45 0c             	mov    %eax,0xc(%ebp)
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	8d 48 01             	lea    0x1(%eax),%ecx
 74f:	89 4d 08             	mov    %ecx,0x8(%ebp)
 752:	0f b6 12             	movzbl (%edx),%edx
 755:	88 10                	mov    %dl,(%eax)
 757:	0f b6 00             	movzbl (%eax),%eax
 75a:	84 c0                	test   %al,%al
 75c:	75 e2                	jne    740 <strcpy+0x11>
    ;
  return os;
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 761:	c9                   	leave  
 762:	c3                   	ret    

00000763 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 763:	f3 0f 1e fb          	endbr32 
 767:	55                   	push   %ebp
 768:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 76a:	eb 08                	jmp    774 <strcmp+0x11>
    p++, q++;
 76c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 770:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	0f b6 00             	movzbl (%eax),%eax
 77a:	84 c0                	test   %al,%al
 77c:	74 10                	je     78e <strcmp+0x2b>
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	0f b6 10             	movzbl (%eax),%edx
 784:	8b 45 0c             	mov    0xc(%ebp),%eax
 787:	0f b6 00             	movzbl (%eax),%eax
 78a:	38 c2                	cmp    %al,%dl
 78c:	74 de                	je     76c <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	0f b6 d0             	movzbl %al,%edx
 797:	8b 45 0c             	mov    0xc(%ebp),%eax
 79a:	0f b6 00             	movzbl (%eax),%eax
 79d:	0f b6 c0             	movzbl %al,%eax
 7a0:	29 c2                	sub    %eax,%edx
 7a2:	89 d0                	mov    %edx,%eax
}
 7a4:	5d                   	pop    %ebp
 7a5:	c3                   	ret    

000007a6 <strlen>:

uint
strlen(const char *s)
{
 7a6:	f3 0f 1e fb          	endbr32 
 7aa:	55                   	push   %ebp
 7ab:	89 e5                	mov    %esp,%ebp
 7ad:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 7b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 7b7:	eb 04                	jmp    7bd <strlen+0x17>
 7b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 7bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7c0:	8b 45 08             	mov    0x8(%ebp),%eax
 7c3:	01 d0                	add    %edx,%eax
 7c5:	0f b6 00             	movzbl (%eax),%eax
 7c8:	84 c0                	test   %al,%al
 7ca:	75 ed                	jne    7b9 <strlen+0x13>
    ;
  return n;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7cf:	c9                   	leave  
 7d0:	c3                   	ret    

000007d1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7d1:	f3 0f 1e fb          	endbr32 
 7d5:	55                   	push   %ebp
 7d6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 7d8:	8b 45 10             	mov    0x10(%ebp),%eax
 7db:	50                   	push   %eax
 7dc:	ff 75 0c             	pushl  0xc(%ebp)
 7df:	ff 75 08             	pushl  0x8(%ebp)
 7e2:	e8 22 ff ff ff       	call   709 <stosb>
 7e7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <strchr>:

char*
strchr(const char *s, char c)
{
 7ef:	f3 0f 1e fb          	endbr32 
 7f3:	55                   	push   %ebp
 7f4:	89 e5                	mov    %esp,%ebp
 7f6:	83 ec 04             	sub    $0x4,%esp
 7f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 7ff:	eb 14                	jmp    815 <strchr+0x26>
    if(*s == c)
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	0f b6 00             	movzbl (%eax),%eax
 807:	38 45 fc             	cmp    %al,-0x4(%ebp)
 80a:	75 05                	jne    811 <strchr+0x22>
      return (char*)s;
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
 80f:	eb 13                	jmp    824 <strchr+0x35>
  for(; *s; s++)
 811:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	0f b6 00             	movzbl (%eax),%eax
 81b:	84 c0                	test   %al,%al
 81d:	75 e2                	jne    801 <strchr+0x12>
  return 0;
 81f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 824:	c9                   	leave  
 825:	c3                   	ret    

00000826 <gets>:

char*
gets(char *buf, int max)
{
 826:	f3 0f 1e fb          	endbr32 
 82a:	55                   	push   %ebp
 82b:	89 e5                	mov    %esp,%ebp
 82d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 830:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 837:	eb 42                	jmp    87b <gets+0x55>
    cc = read(0, &c, 1);
 839:	83 ec 04             	sub    $0x4,%esp
 83c:	6a 01                	push   $0x1
 83e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 841:	50                   	push   %eax
 842:	6a 00                	push   $0x0
 844:	e8 53 01 00 00       	call   99c <read>
 849:	83 c4 10             	add    $0x10,%esp
 84c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 84f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 853:	7e 33                	jle    888 <gets+0x62>
      break;
    buf[i++] = c;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8d 50 01             	lea    0x1(%eax),%edx
 85b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 85e:	89 c2                	mov    %eax,%edx
 860:	8b 45 08             	mov    0x8(%ebp),%eax
 863:	01 c2                	add    %eax,%edx
 865:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 869:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 86b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 86f:	3c 0a                	cmp    $0xa,%al
 871:	74 16                	je     889 <gets+0x63>
 873:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 877:	3c 0d                	cmp    $0xd,%al
 879:	74 0e                	je     889 <gets+0x63>
  for(i=0; i+1 < max; ){
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	83 c0 01             	add    $0x1,%eax
 881:	39 45 0c             	cmp    %eax,0xc(%ebp)
 884:	7f b3                	jg     839 <gets+0x13>
 886:	eb 01                	jmp    889 <gets+0x63>
      break;
 888:	90                   	nop
      break;
  }
  buf[i] = '\0';
 889:	8b 55 f4             	mov    -0xc(%ebp),%edx
 88c:	8b 45 08             	mov    0x8(%ebp),%eax
 88f:	01 d0                	add    %edx,%eax
 891:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 894:	8b 45 08             	mov    0x8(%ebp),%eax
}
 897:	c9                   	leave  
 898:	c3                   	ret    

00000899 <stat>:

int
stat(const char *n, struct stat *st)
{
 899:	f3 0f 1e fb          	endbr32 
 89d:	55                   	push   %ebp
 89e:	89 e5                	mov    %esp,%ebp
 8a0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8a3:	83 ec 08             	sub    $0x8,%esp
 8a6:	6a 00                	push   $0x0
 8a8:	ff 75 08             	pushl  0x8(%ebp)
 8ab:	e8 14 01 00 00       	call   9c4 <open>
 8b0:	83 c4 10             	add    $0x10,%esp
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 8b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ba:	79 07                	jns    8c3 <stat+0x2a>
    return -1;
 8bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8c1:	eb 25                	jmp    8e8 <stat+0x4f>
  r = fstat(fd, st);
 8c3:	83 ec 08             	sub    $0x8,%esp
 8c6:	ff 75 0c             	pushl  0xc(%ebp)
 8c9:	ff 75 f4             	pushl  -0xc(%ebp)
 8cc:	e8 0b 01 00 00       	call   9dc <fstat>
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8d7:	83 ec 0c             	sub    $0xc,%esp
 8da:	ff 75 f4             	pushl  -0xc(%ebp)
 8dd:	e8 ca 00 00 00       	call   9ac <close>
 8e2:	83 c4 10             	add    $0x10,%esp
  return r;
 8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8e8:	c9                   	leave  
 8e9:	c3                   	ret    

000008ea <atoi>:

int
atoi(const char *s)
{
 8ea:	f3 0f 1e fb          	endbr32 
 8ee:	55                   	push   %ebp
 8ef:	89 e5                	mov    %esp,%ebp
 8f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 8fb:	eb 25                	jmp    922 <atoi+0x38>
    n = n*10 + *s++ - '0';
 8fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 900:	89 d0                	mov    %edx,%eax
 902:	c1 e0 02             	shl    $0x2,%eax
 905:	01 d0                	add    %edx,%eax
 907:	01 c0                	add    %eax,%eax
 909:	89 c1                	mov    %eax,%ecx
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	8d 50 01             	lea    0x1(%eax),%edx
 911:	89 55 08             	mov    %edx,0x8(%ebp)
 914:	0f b6 00             	movzbl (%eax),%eax
 917:	0f be c0             	movsbl %al,%eax
 91a:	01 c8                	add    %ecx,%eax
 91c:	83 e8 30             	sub    $0x30,%eax
 91f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 922:	8b 45 08             	mov    0x8(%ebp),%eax
 925:	0f b6 00             	movzbl (%eax),%eax
 928:	3c 2f                	cmp    $0x2f,%al
 92a:	7e 0a                	jle    936 <atoi+0x4c>
 92c:	8b 45 08             	mov    0x8(%ebp),%eax
 92f:	0f b6 00             	movzbl (%eax),%eax
 932:	3c 39                	cmp    $0x39,%al
 934:	7e c7                	jle    8fd <atoi+0x13>
  return n;
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 939:	c9                   	leave  
 93a:	c3                   	ret    

0000093b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 93b:	f3 0f 1e fb          	endbr32 
 93f:	55                   	push   %ebp
 940:	89 e5                	mov    %esp,%ebp
 942:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 945:	8b 45 08             	mov    0x8(%ebp),%eax
 948:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 94b:	8b 45 0c             	mov    0xc(%ebp),%eax
 94e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 951:	eb 17                	jmp    96a <memmove+0x2f>
    *dst++ = *src++;
 953:	8b 55 f8             	mov    -0x8(%ebp),%edx
 956:	8d 42 01             	lea    0x1(%edx),%eax
 959:	89 45 f8             	mov    %eax,-0x8(%ebp)
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8d 48 01             	lea    0x1(%eax),%ecx
 962:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 965:	0f b6 12             	movzbl (%edx),%edx
 968:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 96a:	8b 45 10             	mov    0x10(%ebp),%eax
 96d:	8d 50 ff             	lea    -0x1(%eax),%edx
 970:	89 55 10             	mov    %edx,0x10(%ebp)
 973:	85 c0                	test   %eax,%eax
 975:	7f dc                	jg     953 <memmove+0x18>
  return vdst;
 977:	8b 45 08             	mov    0x8(%ebp),%eax
}
 97a:	c9                   	leave  
 97b:	c3                   	ret    

0000097c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 97c:	b8 01 00 00 00       	mov    $0x1,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <exit>:
SYSCALL(exit)
 984:	b8 02 00 00 00       	mov    $0x2,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <wait>:
SYSCALL(wait)
 98c:	b8 03 00 00 00       	mov    $0x3,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <pipe>:
SYSCALL(pipe)
 994:	b8 04 00 00 00       	mov    $0x4,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <read>:
SYSCALL(read)
 99c:	b8 05 00 00 00       	mov    $0x5,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <write>:
SYSCALL(write)
 9a4:	b8 10 00 00 00       	mov    $0x10,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <close>:
SYSCALL(close)
 9ac:	b8 15 00 00 00       	mov    $0x15,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <kill>:
SYSCALL(kill)
 9b4:	b8 06 00 00 00       	mov    $0x6,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <exec>:
SYSCALL(exec)
 9bc:	b8 07 00 00 00       	mov    $0x7,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <open>:
SYSCALL(open)
 9c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <mknod>:
SYSCALL(mknod)
 9cc:	b8 11 00 00 00       	mov    $0x11,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <unlink>:
SYSCALL(unlink)
 9d4:	b8 12 00 00 00       	mov    $0x12,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <fstat>:
SYSCALL(fstat)
 9dc:	b8 08 00 00 00       	mov    $0x8,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <link>:
SYSCALL(link)
 9e4:	b8 13 00 00 00       	mov    $0x13,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <mkdir>:
SYSCALL(mkdir)
 9ec:	b8 14 00 00 00       	mov    $0x14,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <chdir>:
SYSCALL(chdir)
 9f4:	b8 09 00 00 00       	mov    $0x9,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <dup>:
SYSCALL(dup)
 9fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <getpid>:
SYSCALL(getpid)
 a04:	b8 0b 00 00 00       	mov    $0xb,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <sbrk>:
SYSCALL(sbrk)
 a0c:	b8 0c 00 00 00       	mov    $0xc,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <sleep>:
SYSCALL(sleep)
 a14:	b8 0d 00 00 00       	mov    $0xd,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <uptime>:
SYSCALL(uptime)
 a1c:	b8 0e 00 00 00       	mov    $0xe,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <mencrypt>:
SYSCALL(mencrypt)
 a24:	b8 16 00 00 00       	mov    $0x16,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <getpgtable>:
SYSCALL(getpgtable)
 a2c:	b8 17 00 00 00       	mov    $0x17,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 a34:	b8 18 00 00 00       	mov    $0x18,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a3c:	f3 0f 1e fb          	endbr32 
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	83 ec 18             	sub    $0x18,%esp
 a46:	8b 45 0c             	mov    0xc(%ebp),%eax
 a49:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a4c:	83 ec 04             	sub    $0x4,%esp
 a4f:	6a 01                	push   $0x1
 a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a54:	50                   	push   %eax
 a55:	ff 75 08             	pushl  0x8(%ebp)
 a58:	e8 47 ff ff ff       	call   9a4 <write>
 a5d:	83 c4 10             	add    $0x10,%esp
}
 a60:	90                   	nop
 a61:	c9                   	leave  
 a62:	c3                   	ret    

00000a63 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a63:	f3 0f 1e fb          	endbr32 
 a67:	55                   	push   %ebp
 a68:	89 e5                	mov    %esp,%ebp
 a6a:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a74:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a78:	74 17                	je     a91 <printint+0x2e>
 a7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a7e:	79 11                	jns    a91 <printint+0x2e>
    neg = 1;
 a80:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a87:	8b 45 0c             	mov    0xc(%ebp),%eax
 a8a:	f7 d8                	neg    %eax
 a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a8f:	eb 06                	jmp    a97 <printint+0x34>
  } else {
    x = xx;
 a91:	8b 45 0c             	mov    0xc(%ebp),%eax
 a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa4:	ba 00 00 00 00       	mov    $0x0,%edx
 aa9:	f7 f1                	div    %ecx
 aab:	89 d1                	mov    %edx,%ecx
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	8d 50 01             	lea    0x1(%eax),%edx
 ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ab6:	0f b6 91 88 13 00 00 	movzbl 0x1388(%ecx),%edx
 abd:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 ac1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac7:	ba 00 00 00 00       	mov    $0x0,%edx
 acc:	f7 f1                	div    %ecx
 ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ad1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad5:	75 c7                	jne    a9e <printint+0x3b>
  if(neg)
 ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 adb:	74 2d                	je     b0a <printint+0xa7>
    buf[i++] = '-';
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8d 50 01             	lea    0x1(%eax),%edx
 ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ae6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 aeb:	eb 1d                	jmp    b0a <printint+0xa7>
    putc(fd, buf[i]);
 aed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	01 d0                	add    %edx,%eax
 af5:	0f b6 00             	movzbl (%eax),%eax
 af8:	0f be c0             	movsbl %al,%eax
 afb:	83 ec 08             	sub    $0x8,%esp
 afe:	50                   	push   %eax
 aff:	ff 75 08             	pushl  0x8(%ebp)
 b02:	e8 35 ff ff ff       	call   a3c <putc>
 b07:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 b0a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b12:	79 d9                	jns    aed <printint+0x8a>
}
 b14:	90                   	nop
 b15:	90                   	nop
 b16:	c9                   	leave  
 b17:	c3                   	ret    

00000b18 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 b18:	f3 0f 1e fb          	endbr32 
 b1c:	55                   	push   %ebp
 b1d:	89 e5                	mov    %esp,%ebp
 b1f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b29:	8d 45 0c             	lea    0xc(%ebp),%eax
 b2c:	83 c0 04             	add    $0x4,%eax
 b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b39:	e9 59 01 00 00       	jmp    c97 <printf+0x17f>
    c = fmt[i] & 0xff;
 b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
 b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b44:	01 d0                	add    %edx,%eax
 b46:	0f b6 00             	movzbl (%eax),%eax
 b49:	0f be c0             	movsbl %al,%eax
 b4c:	25 ff 00 00 00       	and    $0xff,%eax
 b51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b58:	75 2c                	jne    b86 <printf+0x6e>
      if(c == '%'){
 b5a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b5e:	75 0c                	jne    b6c <printf+0x54>
        state = '%';
 b60:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b67:	e9 27 01 00 00       	jmp    c93 <printf+0x17b>
      } else {
        putc(fd, c);
 b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b6f:	0f be c0             	movsbl %al,%eax
 b72:	83 ec 08             	sub    $0x8,%esp
 b75:	50                   	push   %eax
 b76:	ff 75 08             	pushl  0x8(%ebp)
 b79:	e8 be fe ff ff       	call   a3c <putc>
 b7e:	83 c4 10             	add    $0x10,%esp
 b81:	e9 0d 01 00 00       	jmp    c93 <printf+0x17b>
      }
    } else if(state == '%'){
 b86:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b8a:	0f 85 03 01 00 00    	jne    c93 <printf+0x17b>
      if(c == 'd'){
 b90:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b94:	75 1e                	jne    bb4 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b99:	8b 00                	mov    (%eax),%eax
 b9b:	6a 01                	push   $0x1
 b9d:	6a 0a                	push   $0xa
 b9f:	50                   	push   %eax
 ba0:	ff 75 08             	pushl  0x8(%ebp)
 ba3:	e8 bb fe ff ff       	call   a63 <printint>
 ba8:	83 c4 10             	add    $0x10,%esp
        ap++;
 bab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 baf:	e9 d8 00 00 00       	jmp    c8c <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 bb4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 bb8:	74 06                	je     bc0 <printf+0xa8>
 bba:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bbe:	75 1e                	jne    bde <printf+0xc6>
        printint(fd, *ap, 16, 0);
 bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bc3:	8b 00                	mov    (%eax),%eax
 bc5:	6a 00                	push   $0x0
 bc7:	6a 10                	push   $0x10
 bc9:	50                   	push   %eax
 bca:	ff 75 08             	pushl  0x8(%ebp)
 bcd:	e8 91 fe ff ff       	call   a63 <printint>
 bd2:	83 c4 10             	add    $0x10,%esp
        ap++;
 bd5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bd9:	e9 ae 00 00 00       	jmp    c8c <printf+0x174>
      } else if(c == 's'){
 bde:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 be2:	75 43                	jne    c27 <printf+0x10f>
        s = (char*)*ap;
 be4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 be7:	8b 00                	mov    (%eax),%eax
 be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bf4:	75 25                	jne    c1b <printf+0x103>
          s = "(null)";
 bf6:	c7 45 f4 f2 10 00 00 	movl   $0x10f2,-0xc(%ebp)
        while(*s != 0){
 bfd:	eb 1c                	jmp    c1b <printf+0x103>
          putc(fd, *s);
 bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c02:	0f b6 00             	movzbl (%eax),%eax
 c05:	0f be c0             	movsbl %al,%eax
 c08:	83 ec 08             	sub    $0x8,%esp
 c0b:	50                   	push   %eax
 c0c:	ff 75 08             	pushl  0x8(%ebp)
 c0f:	e8 28 fe ff ff       	call   a3c <putc>
 c14:	83 c4 10             	add    $0x10,%esp
          s++;
 c17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1e:	0f b6 00             	movzbl (%eax),%eax
 c21:	84 c0                	test   %al,%al
 c23:	75 da                	jne    bff <printf+0xe7>
 c25:	eb 65                	jmp    c8c <printf+0x174>
        }
      } else if(c == 'c'){
 c27:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c2b:	75 1d                	jne    c4a <printf+0x132>
        putc(fd, *ap);
 c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c30:	8b 00                	mov    (%eax),%eax
 c32:	0f be c0             	movsbl %al,%eax
 c35:	83 ec 08             	sub    $0x8,%esp
 c38:	50                   	push   %eax
 c39:	ff 75 08             	pushl  0x8(%ebp)
 c3c:	e8 fb fd ff ff       	call   a3c <putc>
 c41:	83 c4 10             	add    $0x10,%esp
        ap++;
 c44:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c48:	eb 42                	jmp    c8c <printf+0x174>
      } else if(c == '%'){
 c4a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c4e:	75 17                	jne    c67 <printf+0x14f>
        putc(fd, c);
 c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c53:	0f be c0             	movsbl %al,%eax
 c56:	83 ec 08             	sub    $0x8,%esp
 c59:	50                   	push   %eax
 c5a:	ff 75 08             	pushl  0x8(%ebp)
 c5d:	e8 da fd ff ff       	call   a3c <putc>
 c62:	83 c4 10             	add    $0x10,%esp
 c65:	eb 25                	jmp    c8c <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c67:	83 ec 08             	sub    $0x8,%esp
 c6a:	6a 25                	push   $0x25
 c6c:	ff 75 08             	pushl  0x8(%ebp)
 c6f:	e8 c8 fd ff ff       	call   a3c <putc>
 c74:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c7a:	0f be c0             	movsbl %al,%eax
 c7d:	83 ec 08             	sub    $0x8,%esp
 c80:	50                   	push   %eax
 c81:	ff 75 08             	pushl  0x8(%ebp)
 c84:	e8 b3 fd ff ff       	call   a3c <putc>
 c89:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 c93:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c97:	8b 55 0c             	mov    0xc(%ebp),%edx
 c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c9d:	01 d0                	add    %edx,%eax
 c9f:	0f b6 00             	movzbl (%eax),%eax
 ca2:	84 c0                	test   %al,%al
 ca4:	0f 85 94 fe ff ff    	jne    b3e <printf+0x26>
    }
  }
}
 caa:	90                   	nop
 cab:	90                   	nop
 cac:	c9                   	leave  
 cad:	c3                   	ret    

00000cae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cae:	f3 0f 1e fb          	endbr32 
 cb2:	55                   	push   %ebp
 cb3:	89 e5                	mov    %esp,%ebp
 cb5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cb8:	8b 45 08             	mov    0x8(%ebp),%eax
 cbb:	83 e8 08             	sub    $0x8,%eax
 cbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc1:	a1 a4 13 00 00       	mov    0x13a4,%eax
 cc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cc9:	eb 24                	jmp    cef <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cce:	8b 00                	mov    (%eax),%eax
 cd0:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 cd3:	72 12                	jb     ce7 <free+0x39>
 cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cdb:	77 24                	ja     d01 <free+0x53>
 cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce0:	8b 00                	mov    (%eax),%eax
 ce2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ce5:	72 1a                	jb     d01 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cea:	8b 00                	mov    (%eax),%eax
 cec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cf5:	76 d4                	jbe    ccb <free+0x1d>
 cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfa:	8b 00                	mov    (%eax),%eax
 cfc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 cff:	73 ca                	jae    ccb <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d04:	8b 40 04             	mov    0x4(%eax),%eax
 d07:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d11:	01 c2                	add    %eax,%edx
 d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d16:	8b 00                	mov    (%eax),%eax
 d18:	39 c2                	cmp    %eax,%edx
 d1a:	75 24                	jne    d40 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 d1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d1f:	8b 50 04             	mov    0x4(%eax),%edx
 d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d25:	8b 00                	mov    (%eax),%eax
 d27:	8b 40 04             	mov    0x4(%eax),%eax
 d2a:	01 c2                	add    %eax,%edx
 d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d2f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d35:	8b 00                	mov    (%eax),%eax
 d37:	8b 10                	mov    (%eax),%edx
 d39:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d3c:	89 10                	mov    %edx,(%eax)
 d3e:	eb 0a                	jmp    d4a <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d43:	8b 10                	mov    (%eax),%edx
 d45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d48:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4d:	8b 40 04             	mov    0x4(%eax),%eax
 d50:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5a:	01 d0                	add    %edx,%eax
 d5c:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 d5f:	75 20                	jne    d81 <free+0xd3>
    p->s.size += bp->s.size;
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	8b 50 04             	mov    0x4(%eax),%edx
 d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d6a:	8b 40 04             	mov    0x4(%eax),%eax
 d6d:	01 c2                	add    %eax,%edx
 d6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d72:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d78:	8b 10                	mov    (%eax),%edx
 d7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d7d:	89 10                	mov    %edx,(%eax)
 d7f:	eb 08                	jmp    d89 <free+0xdb>
  } else
    p->s.ptr = bp;
 d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d84:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d87:	89 10                	mov    %edx,(%eax)
  freep = p;
 d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d8c:	a3 a4 13 00 00       	mov    %eax,0x13a4
}
 d91:	90                   	nop
 d92:	c9                   	leave  
 d93:	c3                   	ret    

00000d94 <morecore>:

static Header*
morecore(uint nu)
{
 d94:	f3 0f 1e fb          	endbr32 
 d98:	55                   	push   %ebp
 d99:	89 e5                	mov    %esp,%ebp
 d9b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d9e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 da5:	77 07                	ja     dae <morecore+0x1a>
    nu = 4096;
 da7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 dae:	8b 45 08             	mov    0x8(%ebp),%eax
 db1:	c1 e0 03             	shl    $0x3,%eax
 db4:	83 ec 0c             	sub    $0xc,%esp
 db7:	50                   	push   %eax
 db8:	e8 4f fc ff ff       	call   a0c <sbrk>
 dbd:	83 c4 10             	add    $0x10,%esp
 dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 dc3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 dc7:	75 07                	jne    dd0 <morecore+0x3c>
    return 0;
 dc9:	b8 00 00 00 00       	mov    $0x0,%eax
 dce:	eb 26                	jmp    df6 <morecore+0x62>
  hp = (Header*)p;
 dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd9:	8b 55 08             	mov    0x8(%ebp),%edx
 ddc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de2:	83 c0 08             	add    $0x8,%eax
 de5:	83 ec 0c             	sub    $0xc,%esp
 de8:	50                   	push   %eax
 de9:	e8 c0 fe ff ff       	call   cae <free>
 dee:	83 c4 10             	add    $0x10,%esp
  return freep;
 df1:	a1 a4 13 00 00       	mov    0x13a4,%eax
}
 df6:	c9                   	leave  
 df7:	c3                   	ret    

00000df8 <malloc>:

void*
malloc(uint nbytes)
{
 df8:	f3 0f 1e fb          	endbr32 
 dfc:	55                   	push   %ebp
 dfd:	89 e5                	mov    %esp,%ebp
 dff:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e02:	8b 45 08             	mov    0x8(%ebp),%eax
 e05:	83 c0 07             	add    $0x7,%eax
 e08:	c1 e8 03             	shr    $0x3,%eax
 e0b:	83 c0 01             	add    $0x1,%eax
 e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e11:	a1 a4 13 00 00       	mov    0x13a4,%eax
 e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e1d:	75 23                	jne    e42 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 e1f:	c7 45 f0 9c 13 00 00 	movl   $0x139c,-0x10(%ebp)
 e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e29:	a3 a4 13 00 00       	mov    %eax,0x13a4
 e2e:	a1 a4 13 00 00       	mov    0x13a4,%eax
 e33:	a3 9c 13 00 00       	mov    %eax,0x139c
    base.s.size = 0;
 e38:	c7 05 a0 13 00 00 00 	movl   $0x0,0x13a0
 e3f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e45:	8b 00                	mov    (%eax),%eax
 e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4d:	8b 40 04             	mov    0x4(%eax),%eax
 e50:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e53:	77 4d                	ja     ea2 <malloc+0xaa>
      if(p->s.size == nunits)
 e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e58:	8b 40 04             	mov    0x4(%eax),%eax
 e5b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e5e:	75 0c                	jne    e6c <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e63:	8b 10                	mov    (%eax),%edx
 e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e68:	89 10                	mov    %edx,(%eax)
 e6a:	eb 26                	jmp    e92 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6f:	8b 40 04             	mov    0x4(%eax),%eax
 e72:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e75:	89 c2                	mov    %eax,%edx
 e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e80:	8b 40 04             	mov    0x4(%eax),%eax
 e83:	c1 e0 03             	shl    $0x3,%eax
 e86:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e8f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e95:	a3 a4 13 00 00       	mov    %eax,0x13a4
      return (void*)(p + 1);
 e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e9d:	83 c0 08             	add    $0x8,%eax
 ea0:	eb 3b                	jmp    edd <malloc+0xe5>
    }
    if(p == freep)
 ea2:	a1 a4 13 00 00       	mov    0x13a4,%eax
 ea7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 eaa:	75 1e                	jne    eca <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 eac:	83 ec 0c             	sub    $0xc,%esp
 eaf:	ff 75 ec             	pushl  -0x14(%ebp)
 eb2:	e8 dd fe ff ff       	call   d94 <morecore>
 eb7:	83 c4 10             	add    $0x10,%esp
 eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ebd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ec1:	75 07                	jne    eca <malloc+0xd2>
        return 0;
 ec3:	b8 00 00 00 00       	mov    $0x0,%eax
 ec8:	eb 13                	jmp    edd <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed3:	8b 00                	mov    (%eax),%eax
 ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ed8:	e9 6d ff ff ff       	jmp    e4a <malloc+0x52>
  }
}
 edd:	c9                   	leave  
 ede:	c3                   	ret    

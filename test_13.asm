
_test_13:     file format elf32-i386


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
  10:	68 d4 0e 00 00       	push   $0xed4
  15:	6a 01                	push   $0x1
  17:	e8 ee 0a 00 00       	call   b0a <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 52 09 00 00       	call   976 <exit>

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
  6d:	68 e8 0e 00 00       	push   $0xee8
  72:	6a 01                	push   $0x1
  74:	e8 91 0a 00 00       	call   b0a <printf>
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
  94:	83 ec 78             	sub    $0x78,%esp
    const uint PAGES_NUM = 32;
  97:	c7 45 b8 20 00 00 00 	movl   $0x20,-0x48(%ebp)
    const uint expected_dummy_pages_num = 4;
  9e:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%ebp)
    // These pages are used to make sure the test result is consistent for different text pages number
    char *dummy_pages[expected_dummy_pages_num];
  a5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  a8:	83 e8 01             	sub    $0x1,%eax
  ab:	89 45 b0             	mov    %eax,-0x50(%ebp)
  ae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
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
 121:	89 45 ac             	mov    %eax,-0x54(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	68 00 10 00 00       	push   $0x1000
 12c:	e8 cd 08 00 00       	call   9fe <sbrk>
 131:	83 c4 10             	add    $0x10,%esp
 134:	89 45 a8             	mov    %eax,-0x58(%ebp)
    char *sp = buffer - PGSIZE;
 137:	8b 45 a8             	mov    -0x58(%ebp),%eax
 13a:	2d 00 10 00 00       	sub    $0x1000,%eax
 13f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    char *boundary = buffer - 2 * PGSIZE;
 142:	8b 45 a8             	mov    -0x58(%ebp),%eax
 145:	2d 00 20 00 00       	sub    $0x2000,%eax
 14a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
 14d:	8b 45 b8             	mov    -0x48(%ebp),%eax
 150:	83 e8 01             	sub    $0x1,%eax
 153:	89 45 9c             	mov    %eax,-0x64(%ebp)
 156:	8b 45 b8             	mov    -0x48(%ebp),%eax
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
 181:	89 e7                	mov    %esp,%edi
 183:	29 d7                	sub    %edx,%edi
 185:	89 fa                	mov    %edi,%edx
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
 1c9:	89 45 98             	mov    %eax,-0x68(%ebp)

    uint text_pages = (uint) boundary / PGSIZE;
 1cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
 1cf:	c1 e8 0c             	shr    $0xc,%eax
 1d2:	89 45 94             	mov    %eax,-0x6c(%ebp)
    if (text_pages > expected_dummy_pages_num - 1)
 1d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 1d8:	83 e8 01             	sub    $0x1,%eax
 1db:	39 45 94             	cmp    %eax,-0x6c(%ebp)
 1de:	76 10                	jbe    1f0 <main+0x171>
        err("XV6_TEST_OUTPUT: program size exceeds the maximum allowed size. Please let us know if this case happens\n");
 1e0:	83 ec 0c             	sub    $0xc,%esp
 1e3:	68 ec 0e 00 00       	push   $0xeec
 1e8:	e8 13 fe ff ff       	call   0 <err>
 1ed:	83 c4 10             	add    $0x10,%esp
    
    for (int i = 0; i < text_pages; i++)
 1f0:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 1f7:	eb 15                	jmp    20e <main+0x18f>
        dummy_pages[i] = (char *)(i * PGSIZE);
 1f9:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1fc:	c1 e0 0c             	shl    $0xc,%eax
 1ff:	89 c1                	mov    %eax,%ecx
 201:	8b 45 ac             	mov    -0x54(%ebp),%eax
 204:	8b 55 c0             	mov    -0x40(%ebp),%edx
 207:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (int i = 0; i < text_pages; i++)
 20a:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
 20e:	8b 45 c0             	mov    -0x40(%ebp),%eax
 211:	39 45 94             	cmp    %eax,-0x6c(%ebp)
 214:	77 e3                	ja     1f9 <main+0x17a>
    dummy_pages[text_pages] = sp;
 216:	8b 45 ac             	mov    -0x54(%ebp),%eax
 219:	8b 55 94             	mov    -0x6c(%ebp),%edx
 21c:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
 21f:	89 0c 90             	mov    %ecx,(%eax,%edx,4)

    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 222:	8b 45 94             	mov    -0x6c(%ebp),%eax
 225:	83 c0 01             	add    $0x1,%eax
 228:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 22b:	eb 1d                	jmp    24a <main+0x1cb>
        dummy_pages[i] = sbrk(PGSIZE * sizeof(char));
 22d:	83 ec 0c             	sub    $0xc,%esp
 230:	68 00 10 00 00       	push   $0x1000
 235:	e8 c4 07 00 00       	call   9fe <sbrk>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	8b 55 ac             	mov    -0x54(%ebp),%edx
 240:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 243:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    for (int i = text_pages + 1; i < expected_dummy_pages_num; i++)
 246:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
 24a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 24d:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
 250:	77 db                	ja     22d <main+0x1ae>
    

    // After this call, all the dummy pages including text pages and stack pages
    // should be resident in the clock queue.
    access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 252:	83 ec 08             	sub    $0x8,%esp
 255:	ff 75 b4             	pushl  -0x4c(%ebp)
 258:	ff 75 ac             	pushl  -0x54(%ebp)
 25b:	e8 c4 fd ff ff       	call   24 <access_all_dummy_pages>
 260:	83 c4 10             	add    $0x10,%esp

    // Bring the buffer page into the clock queue
    buffer[0] = buffer[0];
 263:	8b 45 a8             	mov    -0x58(%ebp),%eax
 266:	0f b6 10             	movzbl (%eax),%edx
 269:	8b 45 a8             	mov    -0x58(%ebp),%eax
 26c:	88 10                	mov    %dl,(%eax)

    // Now we should have expected_dummy_pages_num + 1 (buffer) pages in the clock queue
    // Fill up the remainig slot with heap-allocated page
    // and bring all of them into the clock queue
    int heap_pages_num = CLOCKSIZE - expected_dummy_pages_num - 1;
 26e:	b8 07 00 00 00       	mov    $0x7,%eax
 273:	2b 45 b4             	sub    -0x4c(%ebp),%eax
 276:	89 45 90             	mov    %eax,-0x70(%ebp)
    char *ptr = sbrk(heap_pages_num * PGSIZE * sizeof(char));
 279:	8b 45 90             	mov    -0x70(%ebp),%eax
 27c:	c1 e0 0c             	shl    $0xc,%eax
 27f:	83 ec 0c             	sub    $0xc,%esp
 282:	50                   	push   %eax
 283:	e8 76 07 00 00       	call   9fe <sbrk>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    for (int i = 0; i < heap_pages_num; i++) {
 28e:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
 295:	eb 31                	jmp    2c8 <main+0x249>
      for (int j = 0; j < PGSIZE; j++) {
 297:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
 29e:	eb 1b                	jmp    2bb <main+0x23c>
        ptr[i * PGSIZE + j] = 0x00;
 2a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2a3:	c1 e0 0c             	shl    $0xc,%eax
 2a6:	89 c2                	mov    %eax,%edx
 2a8:	8b 45 cc             	mov    -0x34(%ebp),%eax
 2ab:	01 d0                	add    %edx,%eax
 2ad:	89 c2                	mov    %eax,%edx
 2af:	8b 45 8c             	mov    -0x74(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	c6 00 00             	movb   $0x0,(%eax)
      for (int j = 0; j < PGSIZE; j++) {
 2b7:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
 2bb:	81 7d cc ff 0f 00 00 	cmpl   $0xfff,-0x34(%ebp)
 2c2:	7e dc                	jle    2a0 <main+0x221>
    for (int i = 0; i < heap_pages_num; i++) {
 2c4:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
 2c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2cb:	3b 45 90             	cmp    -0x70(%ebp),%eax
 2ce:	7c c7                	jl     297 <main+0x218>
      }
    }
    
    char* extra_pages = sbrk(PGSIZE * sizeof(char));
 2d0:	83 ec 0c             	sub    $0xc,%esp
 2d3:	68 00 10 00 00       	push   $0x1000
 2d8:	e8 21 07 00 00       	call   9fe <sbrk>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 88             	mov    %eax,-0x78(%ebp)
    for (int j = 0; j < PGSIZE; j++) {
 2e3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 2ea:	eb 0f                	jmp    2fb <main+0x27c>
      extra_pages[j] = 0x00;
 2ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
 2ef:	8b 45 88             	mov    -0x78(%ebp),%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	c6 00 00             	movb   $0x0,(%eax)
    for (int j = 0; j < PGSIZE; j++) {
 2f7:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
 2fb:	81 7d d0 ff 0f 00 00 	cmpl   $0xfff,-0x30(%ebp)
 302:	7e e8                	jle    2ec <main+0x26d>
    }

    if (fork() == 0) {
 304:	e8 65 06 00 00       	call   96e <fork>
 309:	85 c0                	test   %eax,%eax
 30b:	0f 85 13 02 00 00    	jne    524 <main+0x4a5>
      // Bring all the dummy pages and buffer back to the 
      // clock queue and reset their ref to 1
      access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 311:	83 ec 08             	sub    $0x8,%esp
 314:	ff 75 b4             	pushl  -0x4c(%ebp)
 317:	ff 75 ac             	pushl  -0x54(%ebp)
 31a:	e8 05 fd ff ff       	call   24 <access_all_dummy_pages>
 31f:	83 c4 10             	add    $0x10,%esp
      buffer[0] = buffer[0];
 322:	8b 45 a8             	mov    -0x58(%ebp),%eax
 325:	0f b6 10             	movzbl (%eax),%edx
 328:	8b 45 a8             	mov    -0x58(%ebp),%eax
 32b:	88 10                	mov    %dl,(%eax)
      sbrk(-1 * heap_pages_num * PGSIZE);
 32d:	8b 55 90             	mov    -0x70(%ebp),%edx
 330:	b8 00 00 00 00       	mov    $0x0,%eax
 335:	29 d0                	sub    %edx,%eax
 337:	c1 e0 0c             	shl    $0xc,%eax
 33a:	83 ec 0c             	sub    $0xc,%esp
 33d:	50                   	push   %eax
 33e:	e8 bb 06 00 00       	call   9fe <sbrk>
 343:	83 c4 10             	add    $0x10,%esp
      sbrk(heap_pages_num * PGSIZE);
 346:	8b 45 90             	mov    -0x70(%ebp),%eax
 349:	c1 e0 0c             	shl    $0xc,%eax
 34c:	83 ec 0c             	sub    $0xc,%esp
 34f:	50                   	push   %eax
 350:	e8 a9 06 00 00       	call   9fe <sbrk>
 355:	83 c4 10             	add    $0x10,%esp
      ptr[0] = 0x0;
 358:	8b 45 8c             	mov    -0x74(%ebp),%eax
 35b:	c6 00 00             	movb   $0x0,(%eax)

      printf(1, "XV6_TEST_OUTPUT Child process is calling getpgtable\n");
 35e:	83 ec 08             	sub    $0x8,%esp
 361:	68 58 0f 00 00       	push   $0xf58
 366:	6a 01                	push   $0x1
 368:	e8 9d 07 00 00       	call   b0a <printf>
 36d:	83 c4 10             	add    $0x10,%esp
      int retval = getpgtable(pt_entries, 1, 1);
 370:	83 ec 04             	sub    $0x4,%esp
 373:	6a 01                	push   $0x1
 375:	6a 01                	push   $0x1
 377:	ff 75 98             	pushl  -0x68(%ebp)
 37a:	e8 9f 06 00 00       	call   a1e <getpgtable>
 37f:	83 c4 10             	add    $0x10,%esp
 382:	89 45 80             	mov    %eax,-0x80(%ebp)
      if (retval == 1) {
 385:	83 7d 80 01          	cmpl   $0x1,-0x80(%ebp)
 389:	0f 85 7b 01 00 00    	jne    50a <main+0x48b>
        for (int i = 0; i < retval; i++) {
 38f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 396:	e9 5e 01 00 00       	jmp    4f9 <main+0x47a>
                i,
                pt_entries[i].pdx,
                pt_entries[i].ptx,
                pt_entries[i].writable,
                pt_entries[i].encrypted,
                pt_entries[i].ref
 39b:	8b 45 98             	mov    -0x68(%ebp),%eax
 39e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3a1:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 3a6:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3a9:	0f b6 f0             	movzbl %al,%esi
                pt_entries[i].encrypted,
 3ac:	8b 45 98             	mov    -0x68(%ebp),%eax
 3af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3b2:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3b7:	c0 e8 07             	shr    $0x7,%al
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3ba:	0f b6 d8             	movzbl %al,%ebx
                pt_entries[i].writable,
 3bd:	8b 45 98             	mov    -0x68(%ebp),%eax
 3c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3c3:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 3c8:	c0 e8 05             	shr    $0x5,%al
 3cb:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3ce:	0f b6 c8             	movzbl %al,%ecx
                pt_entries[i].ptx,
 3d1:	8b 45 98             	mov    -0x68(%ebp),%eax
 3d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 3d7:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 3da:	c1 e8 0a             	shr    $0xa,%eax
 3dd:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3e1:	0f b7 d0             	movzwl %ax,%edx
                pt_entries[i].pdx,
 3e4:	8b 45 98             	mov    -0x68(%ebp),%eax
 3e7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3ea:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 3ee:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 3f2:	0f b7 c0             	movzwl %ax,%eax
 3f5:	56                   	push   %esi
 3f6:	53                   	push   %ebx
 3f7:	51                   	push   %ecx
 3f8:	52                   	push   %edx
 3f9:	50                   	push   %eax
 3fa:	ff 75 d4             	pushl  -0x2c(%ebp)
 3fd:	68 90 0f 00 00       	push   $0xf90
 402:	6a 01                	push   $0x1
 404:	e8 01 07 00 00       	call   b0a <printf>
 409:	83 c4 20             	add    $0x20,%esp
            ); 
            
            uint expected = 0x00;
 40c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            if (pt_entries[i].encrypted)
 413:	8b 45 98             	mov    -0x68(%ebp),%eax
 416:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 419:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 41e:	c0 e8 07             	shr    $0x7,%al
 421:	84 c0                	test   %al,%al
 423:	74 07                	je     42c <main+0x3ad>
              expected = ~0x00;
 425:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)

            if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 42c:	8b 45 98             	mov    -0x68(%ebp),%eax
 42f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 432:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 436:	25 ff ff 0f 00       	and    $0xfffff,%eax
 43b:	c1 e0 0c             	shl    $0xc,%eax
 43e:	83 ec 08             	sub    $0x8,%esp
 441:	ff 75 a8             	pushl  -0x58(%ebp)
 444:	50                   	push   %eax
 445:	e8 dc 05 00 00       	call   a26 <dump_rawphymem>
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	85 c0                	test   %eax,%eax
 44f:	74 10                	je     461 <main+0x3e2>
                err("dump_rawphymem return non-zero value\n");
 451:	83 ec 0c             	sub    $0xc,%esp
 454:	68 ec 0f 00 00       	push   $0xfec
 459:	e8 a2 fb ff ff       	call   0 <err>
 45e:	83 c4 10             	add    $0x10,%esp
            
            for (int j = 0; j < PGSIZE; j++) {
 461:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 468:	eb 7e                	jmp    4e8 <main+0x469>
                if (buffer[j] != (char)expected) {
 46a:	8b 55 dc             	mov    -0x24(%ebp),%edx
 46d:	8b 45 a8             	mov    -0x58(%ebp),%eax
 470:	01 d0                	add    %edx,%eax
 472:	0f b6 00             	movzbl (%eax),%eax
 475:	8b 55 d8             	mov    -0x28(%ebp),%edx
 478:	38 d0                	cmp    %dl,%al
 47a:	74 68                	je     4e4 <main+0x465>
                      // err("physical memory is dumped incorrectly\n");
                      printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 47c:	8b 55 dc             	mov    -0x24(%ebp),%edx
 47f:	8b 45 a8             	mov    -0x58(%ebp),%eax
 482:	01 d0                	add    %edx,%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	0f b6 d0             	movzbl %al,%edx
 48d:	8b 45 d8             	mov    -0x28(%ebp),%eax
 490:	0f b6 c0             	movzbl %al,%eax
 493:	8b 4d 98             	mov    -0x68(%ebp),%ecx
 496:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 499:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 49d:	66 81 e1 ff 03       	and    $0x3ff,%cx
 4a2:	0f b7 c9             	movzwl %cx,%ecx
 4a5:	89 ce                	mov    %ecx,%esi
 4a7:	c1 e6 16             	shl    $0x16,%esi
 4aa:	8b 4d 98             	mov    -0x68(%ebp),%ecx
 4ad:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 4b0:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 4b3:	c1 e9 0a             	shr    $0xa,%ecx
 4b6:	66 81 e1 ff 03       	and    $0x3ff,%cx
 4bb:	0f b7 c9             	movzwl %cx,%ecx
 4be:	c1 e1 0c             	shl    $0xc,%ecx
 4c1:	09 ce                	or     %ecx,%esi
 4c3:	89 f3                	mov    %esi,%ebx
 4c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 4c8:	01 d9                	add    %ebx,%ecx
 4ca:	83 ec 0c             	sub    $0xc,%esp
 4cd:	52                   	push   %edx
 4ce:	50                   	push   %eax
 4cf:	51                   	push   %ecx
 4d0:	68 14 10 00 00       	push   $0x1014
 4d5:	6a 01                	push   $0x1
 4d7:	e8 2e 06 00 00       	call   b0a <printf>
 4dc:	83 c4 20             	add    $0x20,%esp
                      exit();
 4df:	e8 92 04 00 00       	call   976 <exit>
            for (int j = 0; j < PGSIZE; j++) {
 4e4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 4e8:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%ebp)
 4ef:	0f 8e 75 ff ff ff    	jle    46a <main+0x3eb>
        for (int i = 0; i < retval; i++) {
 4f5:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 4f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4fc:	3b 45 80             	cmp    -0x80(%ebp),%eax
 4ff:	0f 8c 96 fe ff ff    	jl     39b <main+0x31c>
 505:	e9 ec 01 00 00       	jmp    6f6 <main+0x677>
                }
            }

        }
      } else
          printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", heap_pages_num, retval);
 50a:	ff 75 80             	pushl  -0x80(%ebp)
 50d:	ff 75 90             	pushl  -0x70(%ebp)
 510:	68 64 10 00 00       	push   $0x1064
 515:	6a 01                	push   $0x1
 517:	e8 ee 05 00 00       	call   b0a <printf>
 51c:	83 c4 10             	add    $0x10,%esp
 51f:	e9 d2 01 00 00       	jmp    6f6 <main+0x677>
    } else {
      wait();
 524:	e8 55 04 00 00       	call   97e <wait>
      access_all_dummy_pages(dummy_pages, expected_dummy_pages_num);
 529:	83 ec 08             	sub    $0x8,%esp
 52c:	ff 75 b4             	pushl  -0x4c(%ebp)
 52f:	ff 75 ac             	pushl  -0x54(%ebp)
 532:	e8 ed fa ff ff       	call   24 <access_all_dummy_pages>
 537:	83 c4 10             	add    $0x10,%esp
      buffer[0] = buffer[0];
 53a:	8b 45 a8             	mov    -0x58(%ebp),%eax
 53d:	0f b6 10             	movzbl (%eax),%edx
 540:	8b 45 a8             	mov    -0x58(%ebp),%eax
 543:	88 10                	mov    %dl,(%eax)

      printf(1, "XV6_TEST_OUTPUT Parent process is calling getpgtable\n");
 545:	83 ec 08             	sub    $0x8,%esp
 548:	68 b0 10 00 00       	push   $0x10b0
 54d:	6a 01                	push   $0x1
 54f:	e8 b6 05 00 00       	call   b0a <printf>
 554:	83 c4 10             	add    $0x10,%esp
      int retval = getpgtable(pt_entries, heap_pages_num  + 1, 0);
 557:	8b 45 90             	mov    -0x70(%ebp),%eax
 55a:	83 c0 01             	add    $0x1,%eax
 55d:	83 ec 04             	sub    $0x4,%esp
 560:	6a 00                	push   $0x0
 562:	50                   	push   %eax
 563:	ff 75 98             	pushl  -0x68(%ebp)
 566:	e8 b3 04 00 00       	call   a1e <getpgtable>
 56b:	83 c4 10             	add    $0x10,%esp
 56e:	89 45 84             	mov    %eax,-0x7c(%ebp)
      if (retval == heap_pages_num + 1) {
 571:	8b 45 90             	mov    -0x70(%ebp),%eax
 574:	83 c0 01             	add    $0x1,%eax
 577:	39 45 84             	cmp    %eax,-0x7c(%ebp)
 57a:	0f 85 76 01 00 00    	jne    6f6 <main+0x677>
        for (int i = 0; i < retval; i++) {
 580:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 587:	e9 5e 01 00 00       	jmp    6ea <main+0x66b>
              i,
              pt_entries[i].pdx,
              pt_entries[i].ptx,
              pt_entries[i].writable,
              pt_entries[i].encrypted,
              pt_entries[i].ref
 58c:	8b 45 98             	mov    -0x68(%ebp),%eax
 58f:	8b 55 e0             	mov    -0x20(%ebp),%edx
 592:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 597:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 59a:	0f b6 f0             	movzbl %al,%esi
              pt_entries[i].encrypted,
 59d:	8b 45 98             	mov    -0x68(%ebp),%eax
 5a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
 5a3:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 5a8:	c0 e8 07             	shr    $0x7,%al
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5ab:	0f b6 d8             	movzbl %al,%ebx
              pt_entries[i].writable,
 5ae:	8b 45 98             	mov    -0x68(%ebp),%eax
 5b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
 5b4:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 5b9:	c0 e8 05             	shr    $0x5,%al
 5bc:	83 e0 01             	and    $0x1,%eax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5bf:	0f b6 c8             	movzbl %al,%ecx
              pt_entries[i].ptx,
 5c2:	8b 45 98             	mov    -0x68(%ebp),%eax
 5c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
 5c8:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 5cb:	c1 e8 0a             	shr    $0xa,%eax
 5ce:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5d2:	0f b7 d0             	movzwl %ax,%edx
              pt_entries[i].pdx,
 5d5:	8b 45 98             	mov    -0x68(%ebp),%eax
 5d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
 5db:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 5df:	66 25 ff 03          	and    $0x3ff,%ax
          printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 5e3:	0f b7 c0             	movzwl %ax,%eax
 5e6:	56                   	push   %esi
 5e7:	53                   	push   %ebx
 5e8:	51                   	push   %ecx
 5e9:	52                   	push   %edx
 5ea:	50                   	push   %eax
 5eb:	ff 75 e0             	pushl  -0x20(%ebp)
 5ee:	68 90 0f 00 00       	push   $0xf90
 5f3:	6a 01                	push   $0x1
 5f5:	e8 10 05 00 00       	call   b0a <printf>
 5fa:	83 c4 20             	add    $0x20,%esp
          ); 
          
          uint expected = 0x0;
 5fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
          if (pt_entries[i].encrypted)
 604:	8b 45 98             	mov    -0x68(%ebp),%eax
 607:	8b 55 e0             	mov    -0x20(%ebp),%edx
 60a:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 60f:	c0 e8 07             	shr    $0x7,%al
 612:	84 c0                	test   %al,%al
 614:	74 07                	je     61d <main+0x59e>
            expected = ~0x0;
 616:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

          if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 61d:	8b 45 98             	mov    -0x68(%ebp),%eax
 620:	8b 55 e0             	mov    -0x20(%ebp),%edx
 623:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 627:	25 ff ff 0f 00       	and    $0xfffff,%eax
 62c:	c1 e0 0c             	shl    $0xc,%eax
 62f:	83 ec 08             	sub    $0x8,%esp
 632:	ff 75 a8             	pushl  -0x58(%ebp)
 635:	50                   	push   %eax
 636:	e8 eb 03 00 00       	call   a26 <dump_rawphymem>
 63b:	83 c4 10             	add    $0x10,%esp
 63e:	85 c0                	test   %eax,%eax
 640:	74 10                	je     652 <main+0x5d3>
              err("dump_rawphymem return non-zero value\n");
 642:	83 ec 0c             	sub    $0xc,%esp
 645:	68 ec 0f 00 00       	push   $0xfec
 64a:	e8 b1 f9 ff ff       	call   0 <err>
 64f:	83 c4 10             	add    $0x10,%esp
          
          for (int j = 0; j < PGSIZE; j++) {
 652:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 659:	eb 7e                	jmp    6d9 <main+0x65a>
              if (buffer[j] != (char)expected) {
 65b:	8b 55 bc             	mov    -0x44(%ebp),%edx
 65e:	8b 45 a8             	mov    -0x58(%ebp),%eax
 661:	01 d0                	add    %edx,%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 669:	38 d0                	cmp    %dl,%al
 66b:	74 68                	je     6d5 <main+0x656>
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j ,expected & 0xFF, buffer[j] & 0xFF);
 66d:	8b 55 bc             	mov    -0x44(%ebp),%edx
 670:	8b 45 a8             	mov    -0x58(%ebp),%eax
 673:	01 d0                	add    %edx,%eax
 675:	0f b6 00             	movzbl (%eax),%eax
 678:	0f be c0             	movsbl %al,%eax
 67b:	0f b6 d0             	movzbl %al,%edx
 67e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 681:	0f b6 c0             	movzbl %al,%eax
 684:	8b 4d 98             	mov    -0x68(%ebp),%ecx
 687:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 68a:	0f b7 0c d9          	movzwl (%ecx,%ebx,8),%ecx
 68e:	66 81 e1 ff 03       	and    $0x3ff,%cx
 693:	0f b7 c9             	movzwl %cx,%ecx
 696:	89 ce                	mov    %ecx,%esi
 698:	c1 e6 16             	shl    $0x16,%esi
 69b:	8b 4d 98             	mov    -0x68(%ebp),%ecx
 69e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 6a1:	8b 0c d9             	mov    (%ecx,%ebx,8),%ecx
 6a4:	c1 e9 0a             	shr    $0xa,%ecx
 6a7:	66 81 e1 ff 03       	and    $0x3ff,%cx
 6ac:	0f b7 c9             	movzwl %cx,%ecx
 6af:	c1 e1 0c             	shl    $0xc,%ecx
 6b2:	89 f3                	mov    %esi,%ebx
 6b4:	09 cb                	or     %ecx,%ebx
 6b6:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6b9:	01 d9                	add    %ebx,%ecx
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	52                   	push   %edx
 6bf:	50                   	push   %eax
 6c0:	51                   	push   %ecx
 6c1:	68 14 10 00 00       	push   $0x1014
 6c6:	6a 01                	push   $0x1
 6c8:	e8 3d 04 00 00       	call   b0a <printf>
 6cd:	83 c4 20             	add    $0x20,%esp
                    exit();
 6d0:	e8 a1 02 00 00       	call   976 <exit>
          for (int j = 0; j < PGSIZE; j++) {
 6d5:	83 45 bc 01          	addl   $0x1,-0x44(%ebp)
 6d9:	81 7d bc ff 0f 00 00 	cmpl   $0xfff,-0x44(%ebp)
 6e0:	0f 8e 75 ff ff ff    	jle    65b <main+0x5dc>
        for (int i = 0; i < retval; i++) {
 6e6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 6ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
 6ed:	3b 45 84             	cmp    -0x7c(%ebp),%eax
 6f0:	0f 8c 96 fe ff ff    	jl     58c <main+0x50d>
          }
        }
      }
    }
    
    exit();
 6f6:	e8 7b 02 00 00       	call   976 <exit>

000006fb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	57                   	push   %edi
 6ff:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 700:	8b 4d 08             	mov    0x8(%ebp),%ecx
 703:	8b 55 10             	mov    0x10(%ebp),%edx
 706:	8b 45 0c             	mov    0xc(%ebp),%eax
 709:	89 cb                	mov    %ecx,%ebx
 70b:	89 df                	mov    %ebx,%edi
 70d:	89 d1                	mov    %edx,%ecx
 70f:	fc                   	cld    
 710:	f3 aa                	rep stos %al,%es:(%edi)
 712:	89 ca                	mov    %ecx,%edx
 714:	89 fb                	mov    %edi,%ebx
 716:	89 5d 08             	mov    %ebx,0x8(%ebp)
 719:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 71c:	90                   	nop
 71d:	5b                   	pop    %ebx
 71e:	5f                   	pop    %edi
 71f:	5d                   	pop    %ebp
 720:	c3                   	ret    

00000721 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 721:	f3 0f 1e fb          	endbr32 
 725:	55                   	push   %ebp
 726:	89 e5                	mov    %esp,%ebp
 728:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 731:	90                   	nop
 732:	8b 55 0c             	mov    0xc(%ebp),%edx
 735:	8d 42 01             	lea    0x1(%edx),%eax
 738:	89 45 0c             	mov    %eax,0xc(%ebp)
 73b:	8b 45 08             	mov    0x8(%ebp),%eax
 73e:	8d 48 01             	lea    0x1(%eax),%ecx
 741:	89 4d 08             	mov    %ecx,0x8(%ebp)
 744:	0f b6 12             	movzbl (%edx),%edx
 747:	88 10                	mov    %dl,(%eax)
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	84 c0                	test   %al,%al
 74e:	75 e2                	jne    732 <strcpy+0x11>
    ;
  return os;
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 755:	f3 0f 1e fb          	endbr32 
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 75c:	eb 08                	jmp    766 <strcmp+0x11>
    p++, q++;
 75e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 762:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	0f b6 00             	movzbl (%eax),%eax
 76c:	84 c0                	test   %al,%al
 76e:	74 10                	je     780 <strcmp+0x2b>
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	0f b6 10             	movzbl (%eax),%edx
 776:	8b 45 0c             	mov    0xc(%ebp),%eax
 779:	0f b6 00             	movzbl (%eax),%eax
 77c:	38 c2                	cmp    %al,%dl
 77e:	74 de                	je     75e <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	0f b6 00             	movzbl (%eax),%eax
 786:	0f b6 d0             	movzbl %al,%edx
 789:	8b 45 0c             	mov    0xc(%ebp),%eax
 78c:	0f b6 00             	movzbl (%eax),%eax
 78f:	0f b6 c0             	movzbl %al,%eax
 792:	29 c2                	sub    %eax,%edx
 794:	89 d0                	mov    %edx,%eax
}
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    

00000798 <strlen>:

uint
strlen(const char *s)
{
 798:	f3 0f 1e fb          	endbr32 
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 7a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 7a9:	eb 04                	jmp    7af <strlen+0x17>
 7ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 7af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7b2:	8b 45 08             	mov    0x8(%ebp),%eax
 7b5:	01 d0                	add    %edx,%eax
 7b7:	0f b6 00             	movzbl (%eax),%eax
 7ba:	84 c0                	test   %al,%al
 7bc:	75 ed                	jne    7ab <strlen+0x13>
    ;
  return n;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 7c3:	f3 0f 1e fb          	endbr32 
 7c7:	55                   	push   %ebp
 7c8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 7ca:	8b 45 10             	mov    0x10(%ebp),%eax
 7cd:	50                   	push   %eax
 7ce:	ff 75 0c             	pushl  0xc(%ebp)
 7d1:	ff 75 08             	pushl  0x8(%ebp)
 7d4:	e8 22 ff ff ff       	call   6fb <stosb>
 7d9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7df:	c9                   	leave  
 7e0:	c3                   	ret    

000007e1 <strchr>:

char*
strchr(const char *s, char c)
{
 7e1:	f3 0f 1e fb          	endbr32 
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 04             	sub    $0x4,%esp
 7eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 7f1:	eb 14                	jmp    807 <strchr+0x26>
    if(*s == c)
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	0f b6 00             	movzbl (%eax),%eax
 7f9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 7fc:	75 05                	jne    803 <strchr+0x22>
      return (char*)s;
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	eb 13                	jmp    816 <strchr+0x35>
  for(; *s; s++)
 803:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	0f b6 00             	movzbl (%eax),%eax
 80d:	84 c0                	test   %al,%al
 80f:	75 e2                	jne    7f3 <strchr+0x12>
  return 0;
 811:	b8 00 00 00 00       	mov    $0x0,%eax
}
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <gets>:

char*
gets(char *buf, int max)
{
 818:	f3 0f 1e fb          	endbr32 
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 829:	eb 42                	jmp    86d <gets+0x55>
    cc = read(0, &c, 1);
 82b:	83 ec 04             	sub    $0x4,%esp
 82e:	6a 01                	push   $0x1
 830:	8d 45 ef             	lea    -0x11(%ebp),%eax
 833:	50                   	push   %eax
 834:	6a 00                	push   $0x0
 836:	e8 53 01 00 00       	call   98e <read>
 83b:	83 c4 10             	add    $0x10,%esp
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 841:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 845:	7e 33                	jle    87a <gets+0x62>
      break;
    buf[i++] = c;
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8d 50 01             	lea    0x1(%eax),%edx
 84d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 850:	89 c2                	mov    %eax,%edx
 852:	8b 45 08             	mov    0x8(%ebp),%eax
 855:	01 c2                	add    %eax,%edx
 857:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 85b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 85d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 861:	3c 0a                	cmp    $0xa,%al
 863:	74 16                	je     87b <gets+0x63>
 865:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 869:	3c 0d                	cmp    $0xd,%al
 86b:	74 0e                	je     87b <gets+0x63>
  for(i=0; i+1 < max; ){
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	83 c0 01             	add    $0x1,%eax
 873:	39 45 0c             	cmp    %eax,0xc(%ebp)
 876:	7f b3                	jg     82b <gets+0x13>
 878:	eb 01                	jmp    87b <gets+0x63>
      break;
 87a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 87b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	01 d0                	add    %edx,%eax
 883:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 886:	8b 45 08             	mov    0x8(%ebp),%eax
}
 889:	c9                   	leave  
 88a:	c3                   	ret    

0000088b <stat>:

int
stat(const char *n, struct stat *st)
{
 88b:	f3 0f 1e fb          	endbr32 
 88f:	55                   	push   %ebp
 890:	89 e5                	mov    %esp,%ebp
 892:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 895:	83 ec 08             	sub    $0x8,%esp
 898:	6a 00                	push   $0x0
 89a:	ff 75 08             	pushl  0x8(%ebp)
 89d:	e8 14 01 00 00       	call   9b6 <open>
 8a2:	83 c4 10             	add    $0x10,%esp
 8a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 8a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ac:	79 07                	jns    8b5 <stat+0x2a>
    return -1;
 8ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8b3:	eb 25                	jmp    8da <stat+0x4f>
  r = fstat(fd, st);
 8b5:	83 ec 08             	sub    $0x8,%esp
 8b8:	ff 75 0c             	pushl  0xc(%ebp)
 8bb:	ff 75 f4             	pushl  -0xc(%ebp)
 8be:	e8 0b 01 00 00       	call   9ce <fstat>
 8c3:	83 c4 10             	add    $0x10,%esp
 8c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8c9:	83 ec 0c             	sub    $0xc,%esp
 8cc:	ff 75 f4             	pushl  -0xc(%ebp)
 8cf:	e8 ca 00 00 00       	call   99e <close>
 8d4:	83 c4 10             	add    $0x10,%esp
  return r;
 8d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8da:	c9                   	leave  
 8db:	c3                   	ret    

000008dc <atoi>:

int
atoi(const char *s)
{
 8dc:	f3 0f 1e fb          	endbr32 
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 8ed:	eb 25                	jmp    914 <atoi+0x38>
    n = n*10 + *s++ - '0';
 8ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8f2:	89 d0                	mov    %edx,%eax
 8f4:	c1 e0 02             	shl    $0x2,%eax
 8f7:	01 d0                	add    %edx,%eax
 8f9:	01 c0                	add    %eax,%eax
 8fb:	89 c1                	mov    %eax,%ecx
 8fd:	8b 45 08             	mov    0x8(%ebp),%eax
 900:	8d 50 01             	lea    0x1(%eax),%edx
 903:	89 55 08             	mov    %edx,0x8(%ebp)
 906:	0f b6 00             	movzbl (%eax),%eax
 909:	0f be c0             	movsbl %al,%eax
 90c:	01 c8                	add    %ecx,%eax
 90e:	83 e8 30             	sub    $0x30,%eax
 911:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 914:	8b 45 08             	mov    0x8(%ebp),%eax
 917:	0f b6 00             	movzbl (%eax),%eax
 91a:	3c 2f                	cmp    $0x2f,%al
 91c:	7e 0a                	jle    928 <atoi+0x4c>
 91e:	8b 45 08             	mov    0x8(%ebp),%eax
 921:	0f b6 00             	movzbl (%eax),%eax
 924:	3c 39                	cmp    $0x39,%al
 926:	7e c7                	jle    8ef <atoi+0x13>
  return n;
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 92b:	c9                   	leave  
 92c:	c3                   	ret    

0000092d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 92d:	f3 0f 1e fb          	endbr32 
 931:	55                   	push   %ebp
 932:	89 e5                	mov    %esp,%ebp
 934:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 937:	8b 45 08             	mov    0x8(%ebp),%eax
 93a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 93d:	8b 45 0c             	mov    0xc(%ebp),%eax
 940:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 943:	eb 17                	jmp    95c <memmove+0x2f>
    *dst++ = *src++;
 945:	8b 55 f8             	mov    -0x8(%ebp),%edx
 948:	8d 42 01             	lea    0x1(%edx),%eax
 94b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8d 48 01             	lea    0x1(%eax),%ecx
 954:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 957:	0f b6 12             	movzbl (%edx),%edx
 95a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 95c:	8b 45 10             	mov    0x10(%ebp),%eax
 95f:	8d 50 ff             	lea    -0x1(%eax),%edx
 962:	89 55 10             	mov    %edx,0x10(%ebp)
 965:	85 c0                	test   %eax,%eax
 967:	7f dc                	jg     945 <memmove+0x18>
  return vdst;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
}
 96c:	c9                   	leave  
 96d:	c3                   	ret    

0000096e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 96e:	b8 01 00 00 00       	mov    $0x1,%eax
 973:	cd 40                	int    $0x40
 975:	c3                   	ret    

00000976 <exit>:
SYSCALL(exit)
 976:	b8 02 00 00 00       	mov    $0x2,%eax
 97b:	cd 40                	int    $0x40
 97d:	c3                   	ret    

0000097e <wait>:
SYSCALL(wait)
 97e:	b8 03 00 00 00       	mov    $0x3,%eax
 983:	cd 40                	int    $0x40
 985:	c3                   	ret    

00000986 <pipe>:
SYSCALL(pipe)
 986:	b8 04 00 00 00       	mov    $0x4,%eax
 98b:	cd 40                	int    $0x40
 98d:	c3                   	ret    

0000098e <read>:
SYSCALL(read)
 98e:	b8 05 00 00 00       	mov    $0x5,%eax
 993:	cd 40                	int    $0x40
 995:	c3                   	ret    

00000996 <write>:
SYSCALL(write)
 996:	b8 10 00 00 00       	mov    $0x10,%eax
 99b:	cd 40                	int    $0x40
 99d:	c3                   	ret    

0000099e <close>:
SYSCALL(close)
 99e:	b8 15 00 00 00       	mov    $0x15,%eax
 9a3:	cd 40                	int    $0x40
 9a5:	c3                   	ret    

000009a6 <kill>:
SYSCALL(kill)
 9a6:	b8 06 00 00 00       	mov    $0x6,%eax
 9ab:	cd 40                	int    $0x40
 9ad:	c3                   	ret    

000009ae <exec>:
SYSCALL(exec)
 9ae:	b8 07 00 00 00       	mov    $0x7,%eax
 9b3:	cd 40                	int    $0x40
 9b5:	c3                   	ret    

000009b6 <open>:
SYSCALL(open)
 9b6:	b8 0f 00 00 00       	mov    $0xf,%eax
 9bb:	cd 40                	int    $0x40
 9bd:	c3                   	ret    

000009be <mknod>:
SYSCALL(mknod)
 9be:	b8 11 00 00 00       	mov    $0x11,%eax
 9c3:	cd 40                	int    $0x40
 9c5:	c3                   	ret    

000009c6 <unlink>:
SYSCALL(unlink)
 9c6:	b8 12 00 00 00       	mov    $0x12,%eax
 9cb:	cd 40                	int    $0x40
 9cd:	c3                   	ret    

000009ce <fstat>:
SYSCALL(fstat)
 9ce:	b8 08 00 00 00       	mov    $0x8,%eax
 9d3:	cd 40                	int    $0x40
 9d5:	c3                   	ret    

000009d6 <link>:
SYSCALL(link)
 9d6:	b8 13 00 00 00       	mov    $0x13,%eax
 9db:	cd 40                	int    $0x40
 9dd:	c3                   	ret    

000009de <mkdir>:
SYSCALL(mkdir)
 9de:	b8 14 00 00 00       	mov    $0x14,%eax
 9e3:	cd 40                	int    $0x40
 9e5:	c3                   	ret    

000009e6 <chdir>:
SYSCALL(chdir)
 9e6:	b8 09 00 00 00       	mov    $0x9,%eax
 9eb:	cd 40                	int    $0x40
 9ed:	c3                   	ret    

000009ee <dup>:
SYSCALL(dup)
 9ee:	b8 0a 00 00 00       	mov    $0xa,%eax
 9f3:	cd 40                	int    $0x40
 9f5:	c3                   	ret    

000009f6 <getpid>:
SYSCALL(getpid)
 9f6:	b8 0b 00 00 00       	mov    $0xb,%eax
 9fb:	cd 40                	int    $0x40
 9fd:	c3                   	ret    

000009fe <sbrk>:
SYSCALL(sbrk)
 9fe:	b8 0c 00 00 00       	mov    $0xc,%eax
 a03:	cd 40                	int    $0x40
 a05:	c3                   	ret    

00000a06 <sleep>:
SYSCALL(sleep)
 a06:	b8 0d 00 00 00       	mov    $0xd,%eax
 a0b:	cd 40                	int    $0x40
 a0d:	c3                   	ret    

00000a0e <uptime>:
SYSCALL(uptime)
 a0e:	b8 0e 00 00 00       	mov    $0xe,%eax
 a13:	cd 40                	int    $0x40
 a15:	c3                   	ret    

00000a16 <mencrypt>:
SYSCALL(mencrypt)
 a16:	b8 16 00 00 00       	mov    $0x16,%eax
 a1b:	cd 40                	int    $0x40
 a1d:	c3                   	ret    

00000a1e <getpgtable>:
SYSCALL(getpgtable)
 a1e:	b8 17 00 00 00       	mov    $0x17,%eax
 a23:	cd 40                	int    $0x40
 a25:	c3                   	ret    

00000a26 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 a26:	b8 18 00 00 00       	mov    $0x18,%eax
 a2b:	cd 40                	int    $0x40
 a2d:	c3                   	ret    

00000a2e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a2e:	f3 0f 1e fb          	endbr32 
 a32:	55                   	push   %ebp
 a33:	89 e5                	mov    %esp,%ebp
 a35:	83 ec 18             	sub    $0x18,%esp
 a38:	8b 45 0c             	mov    0xc(%ebp),%eax
 a3b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a3e:	83 ec 04             	sub    $0x4,%esp
 a41:	6a 01                	push   $0x1
 a43:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a46:	50                   	push   %eax
 a47:	ff 75 08             	pushl  0x8(%ebp)
 a4a:	e8 47 ff ff ff       	call   996 <write>
 a4f:	83 c4 10             	add    $0x10,%esp
}
 a52:	90                   	nop
 a53:	c9                   	leave  
 a54:	c3                   	ret    

00000a55 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a55:	f3 0f 1e fb          	endbr32 
 a59:	55                   	push   %ebp
 a5a:	89 e5                	mov    %esp,%ebp
 a5c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a66:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a6a:	74 17                	je     a83 <printint+0x2e>
 a6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a70:	79 11                	jns    a83 <printint+0x2e>
    neg = 1;
 a72:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a79:	8b 45 0c             	mov    0xc(%ebp),%eax
 a7c:	f7 d8                	neg    %eax
 a7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a81:	eb 06                	jmp    a89 <printint+0x34>
  } else {
    x = xx;
 a83:	8b 45 0c             	mov    0xc(%ebp),%eax
 a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a96:	ba 00 00 00 00       	mov    $0x0,%edx
 a9b:	f7 f1                	div    %ecx
 a9d:	89 d1                	mov    %edx,%ecx
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	8d 50 01             	lea    0x1(%eax),%edx
 aa5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 aa8:	0f b6 91 7c 13 00 00 	movzbl 0x137c(%ecx),%edx
 aaf:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab9:	ba 00 00 00 00       	mov    $0x0,%edx
 abe:	f7 f1                	div    %ecx
 ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ac3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ac7:	75 c7                	jne    a90 <printint+0x3b>
  if(neg)
 ac9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 acd:	74 2d                	je     afc <printint+0xa7>
    buf[i++] = '-';
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8d 50 01             	lea    0x1(%eax),%edx
 ad5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ad8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 add:	eb 1d                	jmp    afc <printint+0xa7>
    putc(fd, buf[i]);
 adf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	01 d0                	add    %edx,%eax
 ae7:	0f b6 00             	movzbl (%eax),%eax
 aea:	0f be c0             	movsbl %al,%eax
 aed:	83 ec 08             	sub    $0x8,%esp
 af0:	50                   	push   %eax
 af1:	ff 75 08             	pushl  0x8(%ebp)
 af4:	e8 35 ff ff ff       	call   a2e <putc>
 af9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 afc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b04:	79 d9                	jns    adf <printint+0x8a>
}
 b06:	90                   	nop
 b07:	90                   	nop
 b08:	c9                   	leave  
 b09:	c3                   	ret    

00000b0a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 b0a:	f3 0f 1e fb          	endbr32 
 b0e:	55                   	push   %ebp
 b0f:	89 e5                	mov    %esp,%ebp
 b11:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b1b:	8d 45 0c             	lea    0xc(%ebp),%eax
 b1e:	83 c0 04             	add    $0x4,%eax
 b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b2b:	e9 59 01 00 00       	jmp    c89 <printf+0x17f>
    c = fmt[i] & 0xff;
 b30:	8b 55 0c             	mov    0xc(%ebp),%edx
 b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b36:	01 d0                	add    %edx,%eax
 b38:	0f b6 00             	movzbl (%eax),%eax
 b3b:	0f be c0             	movsbl %al,%eax
 b3e:	25 ff 00 00 00       	and    $0xff,%eax
 b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b4a:	75 2c                	jne    b78 <printf+0x6e>
      if(c == '%'){
 b4c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b50:	75 0c                	jne    b5e <printf+0x54>
        state = '%';
 b52:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b59:	e9 27 01 00 00       	jmp    c85 <printf+0x17b>
      } else {
        putc(fd, c);
 b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b61:	0f be c0             	movsbl %al,%eax
 b64:	83 ec 08             	sub    $0x8,%esp
 b67:	50                   	push   %eax
 b68:	ff 75 08             	pushl  0x8(%ebp)
 b6b:	e8 be fe ff ff       	call   a2e <putc>
 b70:	83 c4 10             	add    $0x10,%esp
 b73:	e9 0d 01 00 00       	jmp    c85 <printf+0x17b>
      }
    } else if(state == '%'){
 b78:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b7c:	0f 85 03 01 00 00    	jne    c85 <printf+0x17b>
      if(c == 'd'){
 b82:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b86:	75 1e                	jne    ba6 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b8b:	8b 00                	mov    (%eax),%eax
 b8d:	6a 01                	push   $0x1
 b8f:	6a 0a                	push   $0xa
 b91:	50                   	push   %eax
 b92:	ff 75 08             	pushl  0x8(%ebp)
 b95:	e8 bb fe ff ff       	call   a55 <printint>
 b9a:	83 c4 10             	add    $0x10,%esp
        ap++;
 b9d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ba1:	e9 d8 00 00 00       	jmp    c7e <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 ba6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 baa:	74 06                	je     bb2 <printf+0xa8>
 bac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bb0:	75 1e                	jne    bd0 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bb5:	8b 00                	mov    (%eax),%eax
 bb7:	6a 00                	push   $0x0
 bb9:	6a 10                	push   $0x10
 bbb:	50                   	push   %eax
 bbc:	ff 75 08             	pushl  0x8(%ebp)
 bbf:	e8 91 fe ff ff       	call   a55 <printint>
 bc4:	83 c4 10             	add    $0x10,%esp
        ap++;
 bc7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bcb:	e9 ae 00 00 00       	jmp    c7e <printf+0x174>
      } else if(c == 's'){
 bd0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bd4:	75 43                	jne    c19 <printf+0x10f>
        s = (char*)*ap;
 bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bd9:	8b 00                	mov    (%eax),%eax
 bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bde:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 be6:	75 25                	jne    c0d <printf+0x103>
          s = "(null)";
 be8:	c7 45 f4 e6 10 00 00 	movl   $0x10e6,-0xc(%ebp)
        while(*s != 0){
 bef:	eb 1c                	jmp    c0d <printf+0x103>
          putc(fd, *s);
 bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf4:	0f b6 00             	movzbl (%eax),%eax
 bf7:	0f be c0             	movsbl %al,%eax
 bfa:	83 ec 08             	sub    $0x8,%esp
 bfd:	50                   	push   %eax
 bfe:	ff 75 08             	pushl  0x8(%ebp)
 c01:	e8 28 fe ff ff       	call   a2e <putc>
 c06:	83 c4 10             	add    $0x10,%esp
          s++;
 c09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c10:	0f b6 00             	movzbl (%eax),%eax
 c13:	84 c0                	test   %al,%al
 c15:	75 da                	jne    bf1 <printf+0xe7>
 c17:	eb 65                	jmp    c7e <printf+0x174>
        }
      } else if(c == 'c'){
 c19:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c1d:	75 1d                	jne    c3c <printf+0x132>
        putc(fd, *ap);
 c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c22:	8b 00                	mov    (%eax),%eax
 c24:	0f be c0             	movsbl %al,%eax
 c27:	83 ec 08             	sub    $0x8,%esp
 c2a:	50                   	push   %eax
 c2b:	ff 75 08             	pushl  0x8(%ebp)
 c2e:	e8 fb fd ff ff       	call   a2e <putc>
 c33:	83 c4 10             	add    $0x10,%esp
        ap++;
 c36:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c3a:	eb 42                	jmp    c7e <printf+0x174>
      } else if(c == '%'){
 c3c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c40:	75 17                	jne    c59 <printf+0x14f>
        putc(fd, c);
 c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c45:	0f be c0             	movsbl %al,%eax
 c48:	83 ec 08             	sub    $0x8,%esp
 c4b:	50                   	push   %eax
 c4c:	ff 75 08             	pushl  0x8(%ebp)
 c4f:	e8 da fd ff ff       	call   a2e <putc>
 c54:	83 c4 10             	add    $0x10,%esp
 c57:	eb 25                	jmp    c7e <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c59:	83 ec 08             	sub    $0x8,%esp
 c5c:	6a 25                	push   $0x25
 c5e:	ff 75 08             	pushl  0x8(%ebp)
 c61:	e8 c8 fd ff ff       	call   a2e <putc>
 c66:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c6c:	0f be c0             	movsbl %al,%eax
 c6f:	83 ec 08             	sub    $0x8,%esp
 c72:	50                   	push   %eax
 c73:	ff 75 08             	pushl  0x8(%ebp)
 c76:	e8 b3 fd ff ff       	call   a2e <putc>
 c7b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 c85:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c89:	8b 55 0c             	mov    0xc(%ebp),%edx
 c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c8f:	01 d0                	add    %edx,%eax
 c91:	0f b6 00             	movzbl (%eax),%eax
 c94:	84 c0                	test   %al,%al
 c96:	0f 85 94 fe ff ff    	jne    b30 <printf+0x26>
    }
  }
}
 c9c:	90                   	nop
 c9d:	90                   	nop
 c9e:	c9                   	leave  
 c9f:	c3                   	ret    

00000ca0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ca0:	f3 0f 1e fb          	endbr32 
 ca4:	55                   	push   %ebp
 ca5:	89 e5                	mov    %esp,%ebp
 ca7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 caa:	8b 45 08             	mov    0x8(%ebp),%eax
 cad:	83 e8 08             	sub    $0x8,%eax
 cb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb3:	a1 98 13 00 00       	mov    0x1398,%eax
 cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cbb:	eb 24                	jmp    ce1 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc0:	8b 00                	mov    (%eax),%eax
 cc2:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 cc5:	72 12                	jb     cd9 <free+0x39>
 cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ccd:	77 24                	ja     cf3 <free+0x53>
 ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd2:	8b 00                	mov    (%eax),%eax
 cd4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 cd7:	72 1a                	jb     cf3 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cdc:	8b 00                	mov    (%eax),%eax
 cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ce7:	76 d4                	jbe    cbd <free+0x1d>
 ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cec:	8b 00                	mov    (%eax),%eax
 cee:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 cf1:	73 ca                	jae    cbd <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf6:	8b 40 04             	mov    0x4(%eax),%eax
 cf9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d03:	01 c2                	add    %eax,%edx
 d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d08:	8b 00                	mov    (%eax),%eax
 d0a:	39 c2                	cmp    %eax,%edx
 d0c:	75 24                	jne    d32 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d11:	8b 50 04             	mov    0x4(%eax),%edx
 d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d17:	8b 00                	mov    (%eax),%eax
 d19:	8b 40 04             	mov    0x4(%eax),%eax
 d1c:	01 c2                	add    %eax,%edx
 d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d21:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d27:	8b 00                	mov    (%eax),%eax
 d29:	8b 10                	mov    (%eax),%edx
 d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d2e:	89 10                	mov    %edx,(%eax)
 d30:	eb 0a                	jmp    d3c <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d35:	8b 10                	mov    (%eax),%edx
 d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d3a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3f:	8b 40 04             	mov    0x4(%eax),%eax
 d42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4c:	01 d0                	add    %edx,%eax
 d4e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 d51:	75 20                	jne    d73 <free+0xd3>
    p->s.size += bp->s.size;
 d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d56:	8b 50 04             	mov    0x4(%eax),%edx
 d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5c:	8b 40 04             	mov    0x4(%eax),%eax
 d5f:	01 c2                	add    %eax,%edx
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d6a:	8b 10                	mov    (%eax),%edx
 d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6f:	89 10                	mov    %edx,(%eax)
 d71:	eb 08                	jmp    d7b <free+0xdb>
  } else
    p->s.ptr = bp;
 d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d76:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d79:	89 10                	mov    %edx,(%eax)
  freep = p;
 d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d7e:	a3 98 13 00 00       	mov    %eax,0x1398
}
 d83:	90                   	nop
 d84:	c9                   	leave  
 d85:	c3                   	ret    

00000d86 <morecore>:

static Header*
morecore(uint nu)
{
 d86:	f3 0f 1e fb          	endbr32 
 d8a:	55                   	push   %ebp
 d8b:	89 e5                	mov    %esp,%ebp
 d8d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d90:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d97:	77 07                	ja     da0 <morecore+0x1a>
    nu = 4096;
 d99:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 da0:	8b 45 08             	mov    0x8(%ebp),%eax
 da3:	c1 e0 03             	shl    $0x3,%eax
 da6:	83 ec 0c             	sub    $0xc,%esp
 da9:	50                   	push   %eax
 daa:	e8 4f fc ff ff       	call   9fe <sbrk>
 daf:	83 c4 10             	add    $0x10,%esp
 db2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 db5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 db9:	75 07                	jne    dc2 <morecore+0x3c>
    return 0;
 dbb:	b8 00 00 00 00       	mov    $0x0,%eax
 dc0:	eb 26                	jmp    de8 <morecore+0x62>
  hp = (Header*)p;
 dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dcb:	8b 55 08             	mov    0x8(%ebp),%edx
 dce:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd4:	83 c0 08             	add    $0x8,%eax
 dd7:	83 ec 0c             	sub    $0xc,%esp
 dda:	50                   	push   %eax
 ddb:	e8 c0 fe ff ff       	call   ca0 <free>
 de0:	83 c4 10             	add    $0x10,%esp
  return freep;
 de3:	a1 98 13 00 00       	mov    0x1398,%eax
}
 de8:	c9                   	leave  
 de9:	c3                   	ret    

00000dea <malloc>:

void*
malloc(uint nbytes)
{
 dea:	f3 0f 1e fb          	endbr32 
 dee:	55                   	push   %ebp
 def:	89 e5                	mov    %esp,%ebp
 df1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 df4:	8b 45 08             	mov    0x8(%ebp),%eax
 df7:	83 c0 07             	add    $0x7,%eax
 dfa:	c1 e8 03             	shr    $0x3,%eax
 dfd:	83 c0 01             	add    $0x1,%eax
 e00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e03:	a1 98 13 00 00       	mov    0x1398,%eax
 e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e0f:	75 23                	jne    e34 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 e11:	c7 45 f0 90 13 00 00 	movl   $0x1390,-0x10(%ebp)
 e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e1b:	a3 98 13 00 00       	mov    %eax,0x1398
 e20:	a1 98 13 00 00       	mov    0x1398,%eax
 e25:	a3 90 13 00 00       	mov    %eax,0x1390
    base.s.size = 0;
 e2a:	c7 05 94 13 00 00 00 	movl   $0x0,0x1394
 e31:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e37:	8b 00                	mov    (%eax),%eax
 e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3f:	8b 40 04             	mov    0x4(%eax),%eax
 e42:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e45:	77 4d                	ja     e94 <malloc+0xaa>
      if(p->s.size == nunits)
 e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4a:	8b 40 04             	mov    0x4(%eax),%eax
 e4d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e50:	75 0c                	jne    e5e <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e55:	8b 10                	mov    (%eax),%edx
 e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e5a:	89 10                	mov    %edx,(%eax)
 e5c:	eb 26                	jmp    e84 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e61:	8b 40 04             	mov    0x4(%eax),%eax
 e64:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e67:	89 c2                	mov    %eax,%edx
 e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e72:	8b 40 04             	mov    0x4(%eax),%eax
 e75:	c1 e0 03             	shl    $0x3,%eax
 e78:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e81:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e87:	a3 98 13 00 00       	mov    %eax,0x1398
      return (void*)(p + 1);
 e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e8f:	83 c0 08             	add    $0x8,%eax
 e92:	eb 3b                	jmp    ecf <malloc+0xe5>
    }
    if(p == freep)
 e94:	a1 98 13 00 00       	mov    0x1398,%eax
 e99:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e9c:	75 1e                	jne    ebc <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 e9e:	83 ec 0c             	sub    $0xc,%esp
 ea1:	ff 75 ec             	pushl  -0x14(%ebp)
 ea4:	e8 dd fe ff ff       	call   d86 <morecore>
 ea9:	83 c4 10             	add    $0x10,%esp
 eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 eb3:	75 07                	jne    ebc <malloc+0xd2>
        return 0;
 eb5:	b8 00 00 00 00       	mov    $0x0,%eax
 eba:	eb 13                	jmp    ecf <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec5:	8b 00                	mov    (%eax),%eax
 ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 eca:	e9 6d ff ff ff       	jmp    e3c <malloc+0x52>
  }
}
 ecf:	c9                   	leave  
 ed0:	c3                   	ret    

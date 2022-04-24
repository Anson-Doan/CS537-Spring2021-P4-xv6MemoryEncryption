
_test_5:     file format elf32-i386


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
  10:	68 f8 0b 00 00       	push   $0xbf8
  15:	6a 01                	push   $0x1
  17:	e8 15 08 00 00       	call   831 <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 79 06 00 00       	call   69d <exit>

00000024 <main>:
}

int main(void) {
  24:	f3 0f 1e fb          	endbr32 
  28:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  2c:	83 e4 f0             	and    $0xfffffff0,%esp
  2f:	ff 71 fc             	pushl  -0x4(%ecx)
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	57                   	push   %edi
  36:	56                   	push   %esi
  37:	53                   	push   %ebx
  38:	51                   	push   %ecx
  39:	83 ec 38             	sub    $0x38,%esp
    const uint PAGES_NUM = 1;
  3c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
  43:	83 ec 0c             	sub    $0xc,%esp
  46:	68 00 10 00 00       	push   $0x1000
  4b:	e8 d5 06 00 00       	call   725 <sbrk>
  50:	83 c4 10             	add    $0x10,%esp
  53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while ((uint)buffer != 0x6000)
  56:	eb 13                	jmp    6b <main+0x47>
        buffer = sbrk(PGSIZE * sizeof(char));
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	68 00 10 00 00       	push   $0x1000
  60:	e8 c0 06 00 00       	call   725 <sbrk>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while ((uint)buffer != 0x6000)
  6b:	81 7d d4 00 60 00 00 	cmpl   $0x6000,-0x2c(%ebp)
  72:	75 e4                	jne    58 <main+0x34>
    // Allocate one pages of space
    
    char *ptr = sbrk(PAGES_NUM * PGSIZE);
  74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  77:	c1 e0 0c             	shl    $0xc,%eax
  7a:	83 ec 0c             	sub    $0xc,%esp
  7d:	50                   	push   %eax
  7e:	e8 a2 06 00 00       	call   725 <sbrk>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 cc             	mov    %eax,-0x34(%ebp)
    struct pt_entry pt_entries[PAGES_NUM];
  89:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8c:	83 e8 01             	sub    $0x1,%eax
  8f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  95:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  9c:	b8 10 00 00 00       	mov    $0x10,%eax
  a1:	83 e8 01             	sub    $0x1,%eax
  a4:	01 d0                	add    %edx,%eax
  a6:	bf 10 00 00 00       	mov    $0x10,%edi
  ab:	ba 00 00 00 00       	mov    $0x0,%edx
  b0:	f7 f7                	div    %edi
  b2:	6b c0 10             	imul   $0x10,%eax,%eax
  b5:	89 c2                	mov    %eax,%edx
  b7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  bd:	89 e6                	mov    %esp,%esi
  bf:	29 d6                	sub    %edx,%esi
  c1:	89 f2                	mov    %esi,%edx
  c3:	39 d4                	cmp    %edx,%esp
  c5:	74 10                	je     d7 <main+0xb3>
  c7:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  cd:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  d4:	00 
  d5:	eb ec                	jmp    c3 <main+0x9f>
  d7:	89 c2                	mov    %eax,%edx
  d9:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  df:	29 d4                	sub    %edx,%esp
  e1:	89 c2                	mov    %eax,%edx
  e3:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  e9:	85 d2                	test   %edx,%edx
  eb:	74 0d                	je     fa <main+0xd6>
  ed:	25 ff 0f 00 00       	and    $0xfff,%eax
  f2:	83 e8 04             	sub    $0x4,%eax
  f5:	01 e0                	add    %esp,%eax
  f7:	83 08 00             	orl    $0x0,(%eax)
  fa:	89 e0                	mov    %esp,%eax
  fc:	83 c0 03             	add    $0x3,%eax
  ff:	c1 e8 02             	shr    $0x2,%eax
 102:	c1 e0 02             	shl    $0x2,%eax
 105:	89 45 c4             	mov    %eax,-0x3c(%ebp)

    int retval = getpgtable(pt_entries, PAGES_NUM, 0);
 108:	8b 45 d0             	mov    -0x30(%ebp),%eax
 10b:	83 ec 04             	sub    $0x4,%esp
 10e:	6a 00                	push   $0x0
 110:	50                   	push   %eax
 111:	ff 75 c4             	pushl  -0x3c(%ebp)
 114:	e8 2c 06 00 00       	call   745 <getpgtable>
 119:	83 c4 10             	add    $0x10,%esp
 11c:	89 45 c0             	mov    %eax,-0x40(%ebp)
    if (retval == PAGES_NUM) {
 11f:	8b 45 d0             	mov    -0x30(%ebp),%eax
 122:	39 45 c0             	cmp    %eax,-0x40(%ebp)
 125:	0f 85 53 01 00 00    	jne    27e <main+0x25a>
        for (int i = 0; i < retval; i++) {
 12b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 132:	e9 39 01 00 00       	jmp    270 <main+0x24c>
                i,
                pt_entries[i].pdx,
                pt_entries[i].ptx,
                pt_entries[i].writable,
                pt_entries[i].encrypted,
                pt_entries[i].ref
 137:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 13a:	8b 55 d8             	mov    -0x28(%ebp),%edx
 13d:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 142:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 145:	0f b6 f0             	movzbl %al,%esi
                pt_entries[i].encrypted,
 148:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 14b:	8b 55 d8             	mov    -0x28(%ebp),%edx
 14e:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 153:	c0 e8 07             	shr    $0x7,%al
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 156:	0f b6 d8             	movzbl %al,%ebx
                pt_entries[i].writable,
 159:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 15c:	8b 55 d8             	mov    -0x28(%ebp),%edx
 15f:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 164:	c0 e8 05             	shr    $0x5,%al
 167:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 16a:	0f b6 c8             	movzbl %al,%ecx
                pt_entries[i].ptx,
 16d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 170:	8b 55 d8             	mov    -0x28(%ebp),%edx
 173:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 176:	c1 e8 0a             	shr    $0xa,%eax
 179:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 17d:	0f b7 d0             	movzwl %ax,%edx
                pt_entries[i].pdx,
 180:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 183:	8b 7d d8             	mov    -0x28(%ebp),%edi
 186:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 18a:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 18e:	0f b7 c0             	movzwl %ax,%eax
 191:	56                   	push   %esi
 192:	53                   	push   %ebx
 193:	51                   	push   %ecx
 194:	52                   	push   %edx
 195:	50                   	push   %eax
 196:	ff 75 d8             	pushl  -0x28(%ebp)
 199:	68 0c 0c 00 00       	push   $0xc0c
 19e:	6a 01                	push   $0x1
 1a0:	e8 8c 06 00 00       	call   831 <printf>
 1a5:	83 c4 20             	add    $0x20,%esp
            );

            if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 1a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 1ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
 1ae:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 1b2:	25 ff ff 0f 00       	and    $0xfffff,%eax
 1b7:	c1 e0 0c             	shl    $0xc,%eax
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	ff 75 d4             	pushl  -0x2c(%ebp)
 1c0:	50                   	push   %eax
 1c1:	e8 87 05 00 00       	call   74d <dump_rawphymem>
 1c6:	83 c4 10             	add    $0x10,%esp
 1c9:	85 c0                	test   %eax,%eax
 1cb:	74 10                	je     1dd <main+0x1b9>
                err("dump_rawphymem return non-zero value\n");
 1cd:	83 ec 0c             	sub    $0xc,%esp
 1d0:	68 68 0c 00 00       	push   $0xc68
 1d5:	e8 26 fe ff ff       	call   0 <err>
 1da:	83 c4 10             	add    $0x10,%esp
            
            for (int j = 0; j < PGSIZE; j++) {
 1dd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1e4:	eb 79                	jmp    25f <main+0x23b>
                if (buffer[j] != (char)0xFF) {
 1e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
 1e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1ec:	01 d0                	add    %edx,%eax
 1ee:	0f b6 00             	movzbl (%eax),%eax
 1f1:	3c ff                	cmp    $0xff,%al
 1f3:	74 66                	je     25b <main+0x237>
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j , 0xFF, buffer[j] & 0xFF);
 1f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
 1f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1fb:	01 d0                	add    %edx,%eax
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	0f be c0             	movsbl %al,%eax
 203:	0f b6 c0             	movzbl %al,%eax
 206:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 209:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 20c:	0f b7 14 ca          	movzwl (%edx,%ecx,8),%edx
 210:	66 81 e2 ff 03       	and    $0x3ff,%dx
 215:	0f b7 d2             	movzwl %dx,%edx
 218:	89 d3                	mov    %edx,%ebx
 21a:	c1 e3 16             	shl    $0x16,%ebx
 21d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 220:	8b 4d d8             	mov    -0x28(%ebp),%ecx
 223:	8b 14 ca             	mov    (%edx,%ecx,8),%edx
 226:	c1 ea 0a             	shr    $0xa,%edx
 229:	66 81 e2 ff 03       	and    $0x3ff,%dx
 22e:	0f b7 d2             	movzwl %dx,%edx
 231:	c1 e2 0c             	shl    $0xc,%edx
 234:	09 d3                	or     %edx,%ebx
 236:	89 d9                	mov    %ebx,%ecx
 238:	8b 55 dc             	mov    -0x24(%ebp),%edx
 23b:	01 ca                	add    %ecx,%edx
 23d:	83 ec 0c             	sub    $0xc,%esp
 240:	50                   	push   %eax
 241:	68 ff 00 00 00       	push   $0xff
 246:	52                   	push   %edx
 247:	68 90 0c 00 00       	push   $0xc90
 24c:	6a 01                	push   $0x1
 24e:	e8 de 05 00 00       	call   831 <printf>
 253:	83 c4 20             	add    $0x20,%esp
                    exit();
 256:	e8 42 04 00 00       	call   69d <exit>
            for (int j = 0; j < PGSIZE; j++) {
 25b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 25f:	81 7d dc ff 0f 00 00 	cmpl   $0xfff,-0x24(%ebp)
 266:	0f 8e 7a ff ff ff    	jle    1e6 <main+0x1c2>
        for (int i = 0; i < retval; i++) {
 26c:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
 270:	8b 45 d8             	mov    -0x28(%ebp),%eax
 273:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 276:	0f 8c bb fe ff ff    	jl     137 <main+0x113>
 27c:	eb 15                	jmp    293 <main+0x26f>
                }
                    
            }
        }
    } else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", PAGES_NUM, retval);
 27e:	ff 75 c0             	pushl  -0x40(%ebp)
 281:	ff 75 d0             	pushl  -0x30(%ebp)
 284:	68 e0 0c 00 00       	push   $0xce0
 289:	6a 01                	push   $0x1
 28b:	e8 a1 05 00 00       	call   831 <printf>
 290:	83 c4 10             	add    $0x10,%esp
    
    // This page should be decrypted now
    ptr[0] = 0x0;
 293:	8b 45 cc             	mov    -0x34(%ebp),%eax
 296:	c6 00 00             	movb   $0x0,(%eax)

    retval = getpgtable(pt_entries, PAGES_NUM, 0);
 299:	8b 45 d0             	mov    -0x30(%ebp),%eax
 29c:	83 ec 04             	sub    $0x4,%esp
 29f:	6a 00                	push   $0x0
 2a1:	50                   	push   %eax
 2a2:	ff 75 c4             	pushl  -0x3c(%ebp)
 2a5:	e8 9b 04 00 00       	call   745 <getpgtable>
 2aa:	83 c4 10             	add    $0x10,%esp
 2ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
    if (retval == PAGES_NUM) {
 2b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 2b3:	39 45 c0             	cmp    %eax,-0x40(%ebp)
 2b6:	0f 85 4c 01 00 00    	jne    408 <main+0x3e4>
        for (int i = 0; i < retval; i++) {
 2bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 2c3:	e9 32 01 00 00       	jmp    3fa <main+0x3d6>
                i,
                pt_entries[i].pdx,
                pt_entries[i].ptx,
                pt_entries[i].writable,
                pt_entries[i].encrypted,
                pt_entries[i].ref
 2c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
 2ce:	0f b6 44 d0 07       	movzbl 0x7(%eax,%edx,8),%eax
 2d3:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 2d6:	0f b6 f0             	movzbl %al,%esi
                pt_entries[i].encrypted,
 2d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
 2df:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 2e4:	c0 e8 07             	shr    $0x7,%al
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 2e7:	0f b6 d8             	movzbl %al,%ebx
                pt_entries[i].writable,
 2ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 2ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
 2f0:	0f b6 44 d0 06       	movzbl 0x6(%eax,%edx,8),%eax
 2f5:	c0 e8 05             	shr    $0x5,%al
 2f8:	83 e0 01             	and    $0x1,%eax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 2fb:	0f b6 c8             	movzbl %al,%ecx
                pt_entries[i].ptx,
 2fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 301:	8b 55 e0             	mov    -0x20(%ebp),%edx
 304:	8b 04 d0             	mov    (%eax,%edx,8),%eax
 307:	c1 e8 0a             	shr    $0xa,%eax
 30a:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 30e:	0f b7 d0             	movzwl %ax,%edx
                pt_entries[i].pdx,
 311:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 314:	8b 7d e0             	mov    -0x20(%ebp),%edi
 317:	0f b7 04 f8          	movzwl (%eax,%edi,8),%eax
 31b:	66 25 ff 03          	and    $0x3ff,%ax
            printf(1, "XV6_TEST_OUTPUT Index %d: pdx: 0x%x, ptx: 0x%x, writable bit: %d, encrypted: %d, ref: %d\n", 
 31f:	0f b7 c0             	movzwl %ax,%eax
 322:	56                   	push   %esi
 323:	53                   	push   %ebx
 324:	51                   	push   %ecx
 325:	52                   	push   %edx
 326:	50                   	push   %eax
 327:	ff 75 e0             	pushl  -0x20(%ebp)
 32a:	68 0c 0c 00 00       	push   $0xc0c
 32f:	6a 01                	push   $0x1
 331:	e8 fb 04 00 00       	call   831 <printf>
 336:	83 c4 20             	add    $0x20,%esp
            );

            if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 339:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 33c:	8b 55 e0             	mov    -0x20(%ebp),%edx
 33f:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 343:	25 ff ff 0f 00       	and    $0xfffff,%eax
 348:	c1 e0 0c             	shl    $0xc,%eax
 34b:	83 ec 08             	sub    $0x8,%esp
 34e:	ff 75 d4             	pushl  -0x2c(%ebp)
 351:	50                   	push   %eax
 352:	e8 f6 03 00 00       	call   74d <dump_rawphymem>
 357:	83 c4 10             	add    $0x10,%esp
 35a:	85 c0                	test   %eax,%eax
 35c:	74 10                	je     36e <main+0x34a>
                err("dump_rawphymem return non-zero value\n");
 35e:	83 ec 0c             	sub    $0xc,%esp
 361:	68 68 0c 00 00       	push   $0xc68
 366:	e8 95 fc ff ff       	call   0 <err>
 36b:	83 c4 10             	add    $0x10,%esp
            
            for (int j = 0; j < PGSIZE; j++) {
 36e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 375:	eb 76                	jmp    3ed <main+0x3c9>
                if (buffer[j] != (char)0x0) {
 377:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 37a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 37d:	01 d0                	add    %edx,%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	84 c0                	test   %al,%al
 384:	74 63                	je     3e9 <main+0x3c5>
                    printf(1, "XV6_TEST_OUTPUT: content is incorrect at address 0x%x: expected 0x%x, got 0x%x\n", ((uint)(pt_entries[i].pdx) << 22 | (pt_entries[i].ptx) << 12) + j , 0x0, buffer[j] & 0xFF);
 386:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 389:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 38c:	01 d0                	add    %edx,%eax
 38e:	0f b6 00             	movzbl (%eax),%eax
 391:	0f be c0             	movsbl %al,%eax
 394:	0f b6 c0             	movzbl %al,%eax
 397:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 39a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 39d:	0f b7 14 ca          	movzwl (%edx,%ecx,8),%edx
 3a1:	66 81 e2 ff 03       	and    $0x3ff,%dx
 3a6:	0f b7 d2             	movzwl %dx,%edx
 3a9:	89 d3                	mov    %edx,%ebx
 3ab:	c1 e3 16             	shl    $0x16,%ebx
 3ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 3b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 3b4:	8b 14 ca             	mov    (%edx,%ecx,8),%edx
 3b7:	c1 ea 0a             	shr    $0xa,%edx
 3ba:	66 81 e2 ff 03       	and    $0x3ff,%dx
 3bf:	0f b7 d2             	movzwl %dx,%edx
 3c2:	c1 e2 0c             	shl    $0xc,%edx
 3c5:	89 d9                	mov    %ebx,%ecx
 3c7:	09 d1                	or     %edx,%ecx
 3c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3cc:	01 ca                	add    %ecx,%edx
 3ce:	83 ec 0c             	sub    $0xc,%esp
 3d1:	50                   	push   %eax
 3d2:	6a 00                	push   $0x0
 3d4:	52                   	push   %edx
 3d5:	68 90 0c 00 00       	push   $0xc90
 3da:	6a 01                	push   $0x1
 3dc:	e8 50 04 00 00       	call   831 <printf>
 3e1:	83 c4 20             	add    $0x20,%esp
                    exit();
 3e4:	e8 b4 02 00 00       	call   69d <exit>
            for (int j = 0; j < PGSIZE; j++) {
 3e9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 3ed:	81 7d e4 ff 0f 00 00 	cmpl   $0xfff,-0x1c(%ebp)
 3f4:	7e 81                	jle    377 <main+0x353>
        for (int i = 0; i < retval; i++) {
 3f6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 3fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
 3fd:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 400:	0f 8c c2 fe ff ff    	jl     2c8 <main+0x2a4>
 406:	eb 15                	jmp    41d <main+0x3f9>
                }
                    
            }
        }
    } else
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", PAGES_NUM, retval);
 408:	ff 75 c0             	pushl  -0x40(%ebp)
 40b:	ff 75 d0             	pushl  -0x30(%ebp)
 40e:	68 e0 0c 00 00       	push   $0xce0
 413:	6a 01                	push   $0x1
 415:	e8 17 04 00 00       	call   831 <printf>
 41a:	83 c4 10             	add    $0x10,%esp

    exit();
 41d:	e8 7b 02 00 00       	call   69d <exit>

00000422 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	57                   	push   %edi
 426:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 427:	8b 4d 08             	mov    0x8(%ebp),%ecx
 42a:	8b 55 10             	mov    0x10(%ebp),%edx
 42d:	8b 45 0c             	mov    0xc(%ebp),%eax
 430:	89 cb                	mov    %ecx,%ebx
 432:	89 df                	mov    %ebx,%edi
 434:	89 d1                	mov    %edx,%ecx
 436:	fc                   	cld    
 437:	f3 aa                	rep stos %al,%es:(%edi)
 439:	89 ca                	mov    %ecx,%edx
 43b:	89 fb                	mov    %edi,%ebx
 43d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 440:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 443:	90                   	nop
 444:	5b                   	pop    %ebx
 445:	5f                   	pop    %edi
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    

00000448 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 448:	f3 0f 1e fb          	endbr32 
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 458:	90                   	nop
 459:	8b 55 0c             	mov    0xc(%ebp),%edx
 45c:	8d 42 01             	lea    0x1(%edx),%eax
 45f:	89 45 0c             	mov    %eax,0xc(%ebp)
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	8d 48 01             	lea    0x1(%eax),%ecx
 468:	89 4d 08             	mov    %ecx,0x8(%ebp)
 46b:	0f b6 12             	movzbl (%edx),%edx
 46e:	88 10                	mov    %dl,(%eax)
 470:	0f b6 00             	movzbl (%eax),%eax
 473:	84 c0                	test   %al,%al
 475:	75 e2                	jne    459 <strcpy+0x11>
    ;
  return os;
 477:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 47a:	c9                   	leave  
 47b:	c3                   	ret    

0000047c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 47c:	f3 0f 1e fb          	endbr32 
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 483:	eb 08                	jmp    48d <strcmp+0x11>
    p++, q++;
 485:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 489:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	0f b6 00             	movzbl (%eax),%eax
 493:	84 c0                	test   %al,%al
 495:	74 10                	je     4a7 <strcmp+0x2b>
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	0f b6 10             	movzbl (%eax),%edx
 49d:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a0:	0f b6 00             	movzbl (%eax),%eax
 4a3:	38 c2                	cmp    %al,%dl
 4a5:	74 de                	je     485 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	0f b6 00             	movzbl (%eax),%eax
 4ad:	0f b6 d0             	movzbl %al,%edx
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	0f b6 00             	movzbl (%eax),%eax
 4b6:	0f b6 c0             	movzbl %al,%eax
 4b9:	29 c2                	sub    %eax,%edx
 4bb:	89 d0                	mov    %edx,%eax
}
 4bd:	5d                   	pop    %ebp
 4be:	c3                   	ret    

000004bf <strlen>:

uint
strlen(const char *s)
{
 4bf:	f3 0f 1e fb          	endbr32 
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4d0:	eb 04                	jmp    4d6 <strlen+0x17>
 4d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 4d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	01 d0                	add    %edx,%eax
 4de:	0f b6 00             	movzbl (%eax),%eax
 4e1:	84 c0                	test   %al,%al
 4e3:	75 ed                	jne    4d2 <strlen+0x13>
    ;
  return n;
 4e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4e8:	c9                   	leave  
 4e9:	c3                   	ret    

000004ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 4ea:	f3 0f 1e fb          	endbr32 
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 4f1:	8b 45 10             	mov    0x10(%ebp),%eax
 4f4:	50                   	push   %eax
 4f5:	ff 75 0c             	pushl  0xc(%ebp)
 4f8:	ff 75 08             	pushl  0x8(%ebp)
 4fb:	e8 22 ff ff ff       	call   422 <stosb>
 500:	83 c4 0c             	add    $0xc,%esp
  return dst;
 503:	8b 45 08             	mov    0x8(%ebp),%eax
}
 506:	c9                   	leave  
 507:	c3                   	ret    

00000508 <strchr>:

char*
strchr(const char *s, char c)
{
 508:	f3 0f 1e fb          	endbr32 
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	83 ec 04             	sub    $0x4,%esp
 512:	8b 45 0c             	mov    0xc(%ebp),%eax
 515:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 518:	eb 14                	jmp    52e <strchr+0x26>
    if(*s == c)
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	0f b6 00             	movzbl (%eax),%eax
 520:	38 45 fc             	cmp    %al,-0x4(%ebp)
 523:	75 05                	jne    52a <strchr+0x22>
      return (char*)s;
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	eb 13                	jmp    53d <strchr+0x35>
  for(; *s; s++)
 52a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	84 c0                	test   %al,%al
 536:	75 e2                	jne    51a <strchr+0x12>
  return 0;
 538:	b8 00 00 00 00       	mov    $0x0,%eax
}
 53d:	c9                   	leave  
 53e:	c3                   	ret    

0000053f <gets>:

char*
gets(char *buf, int max)
{
 53f:	f3 0f 1e fb          	endbr32 
 543:	55                   	push   %ebp
 544:	89 e5                	mov    %esp,%ebp
 546:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 550:	eb 42                	jmp    594 <gets+0x55>
    cc = read(0, &c, 1);
 552:	83 ec 04             	sub    $0x4,%esp
 555:	6a 01                	push   $0x1
 557:	8d 45 ef             	lea    -0x11(%ebp),%eax
 55a:	50                   	push   %eax
 55b:	6a 00                	push   $0x0
 55d:	e8 53 01 00 00       	call   6b5 <read>
 562:	83 c4 10             	add    $0x10,%esp
 565:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 568:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56c:	7e 33                	jle    5a1 <gets+0x62>
      break;
    buf[i++] = c;
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	8d 50 01             	lea    0x1(%eax),%edx
 574:	89 55 f4             	mov    %edx,-0xc(%ebp)
 577:	89 c2                	mov    %eax,%edx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	01 c2                	add    %eax,%edx
 57e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 582:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 584:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 588:	3c 0a                	cmp    $0xa,%al
 58a:	74 16                	je     5a2 <gets+0x63>
 58c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 590:	3c 0d                	cmp    $0xd,%al
 592:	74 0e                	je     5a2 <gets+0x63>
  for(i=0; i+1 < max; ){
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	83 c0 01             	add    $0x1,%eax
 59a:	39 45 0c             	cmp    %eax,0xc(%ebp)
 59d:	7f b3                	jg     552 <gets+0x13>
 59f:	eb 01                	jmp    5a2 <gets+0x63>
      break;
 5a1:	90                   	nop
      break;
  }
  buf[i] = '\0';
 5a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	01 d0                	add    %edx,%eax
 5aa:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 5b2:	f3 0f 1e fb          	endbr32 
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5bc:	83 ec 08             	sub    $0x8,%esp
 5bf:	6a 00                	push   $0x0
 5c1:	ff 75 08             	pushl  0x8(%ebp)
 5c4:	e8 14 01 00 00       	call   6dd <open>
 5c9:	83 c4 10             	add    $0x10,%esp
 5cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d3:	79 07                	jns    5dc <stat+0x2a>
    return -1;
 5d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5da:	eb 25                	jmp    601 <stat+0x4f>
  r = fstat(fd, st);
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	ff 75 0c             	pushl  0xc(%ebp)
 5e2:	ff 75 f4             	pushl  -0xc(%ebp)
 5e5:	e8 0b 01 00 00       	call   6f5 <fstat>
 5ea:	83 c4 10             	add    $0x10,%esp
 5ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	ff 75 f4             	pushl  -0xc(%ebp)
 5f6:	e8 ca 00 00 00       	call   6c5 <close>
 5fb:	83 c4 10             	add    $0x10,%esp
  return r;
 5fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 601:	c9                   	leave  
 602:	c3                   	ret    

00000603 <atoi>:

int
atoi(const char *s)
{
 603:	f3 0f 1e fb          	endbr32 
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 60d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 614:	eb 25                	jmp    63b <atoi+0x38>
    n = n*10 + *s++ - '0';
 616:	8b 55 fc             	mov    -0x4(%ebp),%edx
 619:	89 d0                	mov    %edx,%eax
 61b:	c1 e0 02             	shl    $0x2,%eax
 61e:	01 d0                	add    %edx,%eax
 620:	01 c0                	add    %eax,%eax
 622:	89 c1                	mov    %eax,%ecx
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	8d 50 01             	lea    0x1(%eax),%edx
 62a:	89 55 08             	mov    %edx,0x8(%ebp)
 62d:	0f b6 00             	movzbl (%eax),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	01 c8                	add    %ecx,%eax
 635:	83 e8 30             	sub    $0x30,%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 63b:	8b 45 08             	mov    0x8(%ebp),%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	3c 2f                	cmp    $0x2f,%al
 643:	7e 0a                	jle    64f <atoi+0x4c>
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	0f b6 00             	movzbl (%eax),%eax
 64b:	3c 39                	cmp    $0x39,%al
 64d:	7e c7                	jle    616 <atoi+0x13>
  return n;
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 652:	c9                   	leave  
 653:	c3                   	ret    

00000654 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 654:	f3 0f 1e fb          	endbr32 
 658:	55                   	push   %ebp
 659:	89 e5                	mov    %esp,%ebp
 65b:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 65e:	8b 45 08             	mov    0x8(%ebp),%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 664:	8b 45 0c             	mov    0xc(%ebp),%eax
 667:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 66a:	eb 17                	jmp    683 <memmove+0x2f>
    *dst++ = *src++;
 66c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 66f:	8d 42 01             	lea    0x1(%edx),%eax
 672:	89 45 f8             	mov    %eax,-0x8(%ebp)
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8d 48 01             	lea    0x1(%eax),%ecx
 67b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 67e:	0f b6 12             	movzbl (%edx),%edx
 681:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 683:	8b 45 10             	mov    0x10(%ebp),%eax
 686:	8d 50 ff             	lea    -0x1(%eax),%edx
 689:	89 55 10             	mov    %edx,0x10(%ebp)
 68c:	85 c0                	test   %eax,%eax
 68e:	7f dc                	jg     66c <memmove+0x18>
  return vdst;
 690:	8b 45 08             	mov    0x8(%ebp),%eax
}
 693:	c9                   	leave  
 694:	c3                   	ret    

00000695 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 695:	b8 01 00 00 00       	mov    $0x1,%eax
 69a:	cd 40                	int    $0x40
 69c:	c3                   	ret    

0000069d <exit>:
SYSCALL(exit)
 69d:	b8 02 00 00 00       	mov    $0x2,%eax
 6a2:	cd 40                	int    $0x40
 6a4:	c3                   	ret    

000006a5 <wait>:
SYSCALL(wait)
 6a5:	b8 03 00 00 00       	mov    $0x3,%eax
 6aa:	cd 40                	int    $0x40
 6ac:	c3                   	ret    

000006ad <pipe>:
SYSCALL(pipe)
 6ad:	b8 04 00 00 00       	mov    $0x4,%eax
 6b2:	cd 40                	int    $0x40
 6b4:	c3                   	ret    

000006b5 <read>:
SYSCALL(read)
 6b5:	b8 05 00 00 00       	mov    $0x5,%eax
 6ba:	cd 40                	int    $0x40
 6bc:	c3                   	ret    

000006bd <write>:
SYSCALL(write)
 6bd:	b8 10 00 00 00       	mov    $0x10,%eax
 6c2:	cd 40                	int    $0x40
 6c4:	c3                   	ret    

000006c5 <close>:
SYSCALL(close)
 6c5:	b8 15 00 00 00       	mov    $0x15,%eax
 6ca:	cd 40                	int    $0x40
 6cc:	c3                   	ret    

000006cd <kill>:
SYSCALL(kill)
 6cd:	b8 06 00 00 00       	mov    $0x6,%eax
 6d2:	cd 40                	int    $0x40
 6d4:	c3                   	ret    

000006d5 <exec>:
SYSCALL(exec)
 6d5:	b8 07 00 00 00       	mov    $0x7,%eax
 6da:	cd 40                	int    $0x40
 6dc:	c3                   	ret    

000006dd <open>:
SYSCALL(open)
 6dd:	b8 0f 00 00 00       	mov    $0xf,%eax
 6e2:	cd 40                	int    $0x40
 6e4:	c3                   	ret    

000006e5 <mknod>:
SYSCALL(mknod)
 6e5:	b8 11 00 00 00       	mov    $0x11,%eax
 6ea:	cd 40                	int    $0x40
 6ec:	c3                   	ret    

000006ed <unlink>:
SYSCALL(unlink)
 6ed:	b8 12 00 00 00       	mov    $0x12,%eax
 6f2:	cd 40                	int    $0x40
 6f4:	c3                   	ret    

000006f5 <fstat>:
SYSCALL(fstat)
 6f5:	b8 08 00 00 00       	mov    $0x8,%eax
 6fa:	cd 40                	int    $0x40
 6fc:	c3                   	ret    

000006fd <link>:
SYSCALL(link)
 6fd:	b8 13 00 00 00       	mov    $0x13,%eax
 702:	cd 40                	int    $0x40
 704:	c3                   	ret    

00000705 <mkdir>:
SYSCALL(mkdir)
 705:	b8 14 00 00 00       	mov    $0x14,%eax
 70a:	cd 40                	int    $0x40
 70c:	c3                   	ret    

0000070d <chdir>:
SYSCALL(chdir)
 70d:	b8 09 00 00 00       	mov    $0x9,%eax
 712:	cd 40                	int    $0x40
 714:	c3                   	ret    

00000715 <dup>:
SYSCALL(dup)
 715:	b8 0a 00 00 00       	mov    $0xa,%eax
 71a:	cd 40                	int    $0x40
 71c:	c3                   	ret    

0000071d <getpid>:
SYSCALL(getpid)
 71d:	b8 0b 00 00 00       	mov    $0xb,%eax
 722:	cd 40                	int    $0x40
 724:	c3                   	ret    

00000725 <sbrk>:
SYSCALL(sbrk)
 725:	b8 0c 00 00 00       	mov    $0xc,%eax
 72a:	cd 40                	int    $0x40
 72c:	c3                   	ret    

0000072d <sleep>:
SYSCALL(sleep)
 72d:	b8 0d 00 00 00       	mov    $0xd,%eax
 732:	cd 40                	int    $0x40
 734:	c3                   	ret    

00000735 <uptime>:
SYSCALL(uptime)
 735:	b8 0e 00 00 00       	mov    $0xe,%eax
 73a:	cd 40                	int    $0x40
 73c:	c3                   	ret    

0000073d <mencrypt>:
SYSCALL(mencrypt)
 73d:	b8 16 00 00 00       	mov    $0x16,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret    

00000745 <getpgtable>:
SYSCALL(getpgtable)
 745:	b8 17 00 00 00       	mov    $0x17,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret    

0000074d <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 74d:	b8 18 00 00 00       	mov    $0x18,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret    

00000755 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 755:	f3 0f 1e fb          	endbr32 
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 18             	sub    $0x18,%esp
 75f:	8b 45 0c             	mov    0xc(%ebp),%eax
 762:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 765:	83 ec 04             	sub    $0x4,%esp
 768:	6a 01                	push   $0x1
 76a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 76d:	50                   	push   %eax
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 47 ff ff ff       	call   6bd <write>
 776:	83 c4 10             	add    $0x10,%esp
}
 779:	90                   	nop
 77a:	c9                   	leave  
 77b:	c3                   	ret    

0000077c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 77c:	f3 0f 1e fb          	endbr32 
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 78d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 791:	74 17                	je     7aa <printint+0x2e>
 793:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 797:	79 11                	jns    7aa <printint+0x2e>
    neg = 1;
 799:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a3:	f7 d8                	neg    %eax
 7a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a8:	eb 06                	jmp    7b0 <printint+0x34>
  } else {
    x = xx;
 7aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7bd:	ba 00 00 00 00       	mov    $0x0,%edx
 7c2:	f7 f1                	div    %ecx
 7c4:	89 d1                	mov    %edx,%ecx
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8d 50 01             	lea    0x1(%eax),%edx
 7cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7cf:	0f b6 91 a0 0f 00 00 	movzbl 0xfa0(%ecx),%edx
 7d6:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 7da:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e0:	ba 00 00 00 00       	mov    $0x0,%edx
 7e5:	f7 f1                	div    %ecx
 7e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ee:	75 c7                	jne    7b7 <printint+0x3b>
  if(neg)
 7f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f4:	74 2d                	je     823 <printint+0xa7>
    buf[i++] = '-';
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8d 50 01             	lea    0x1(%eax),%edx
 7fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7ff:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 804:	eb 1d                	jmp    823 <printint+0xa7>
    putc(fd, buf[i]);
 806:	8d 55 dc             	lea    -0x24(%ebp),%edx
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	01 d0                	add    %edx,%eax
 80e:	0f b6 00             	movzbl (%eax),%eax
 811:	0f be c0             	movsbl %al,%eax
 814:	83 ec 08             	sub    $0x8,%esp
 817:	50                   	push   %eax
 818:	ff 75 08             	pushl  0x8(%ebp)
 81b:	e8 35 ff ff ff       	call   755 <putc>
 820:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 823:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82b:	79 d9                	jns    806 <printint+0x8a>
}
 82d:	90                   	nop
 82e:	90                   	nop
 82f:	c9                   	leave  
 830:	c3                   	ret    

00000831 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 831:	f3 0f 1e fb          	endbr32 
 835:	55                   	push   %ebp
 836:	89 e5                	mov    %esp,%ebp
 838:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 83b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 842:	8d 45 0c             	lea    0xc(%ebp),%eax
 845:	83 c0 04             	add    $0x4,%eax
 848:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 84b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 852:	e9 59 01 00 00       	jmp    9b0 <printf+0x17f>
    c = fmt[i] & 0xff;
 857:	8b 55 0c             	mov    0xc(%ebp),%edx
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	01 d0                	add    %edx,%eax
 85f:	0f b6 00             	movzbl (%eax),%eax
 862:	0f be c0             	movsbl %al,%eax
 865:	25 ff 00 00 00       	and    $0xff,%eax
 86a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 86d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 871:	75 2c                	jne    89f <printf+0x6e>
      if(c == '%'){
 873:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 877:	75 0c                	jne    885 <printf+0x54>
        state = '%';
 879:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 880:	e9 27 01 00 00       	jmp    9ac <printf+0x17b>
      } else {
        putc(fd, c);
 885:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 888:	0f be c0             	movsbl %al,%eax
 88b:	83 ec 08             	sub    $0x8,%esp
 88e:	50                   	push   %eax
 88f:	ff 75 08             	pushl  0x8(%ebp)
 892:	e8 be fe ff ff       	call   755 <putc>
 897:	83 c4 10             	add    $0x10,%esp
 89a:	e9 0d 01 00 00       	jmp    9ac <printf+0x17b>
      }
    } else if(state == '%'){
 89f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8a3:	0f 85 03 01 00 00    	jne    9ac <printf+0x17b>
      if(c == 'd'){
 8a9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8ad:	75 1e                	jne    8cd <printf+0x9c>
        printint(fd, *ap, 10, 1);
 8af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b2:	8b 00                	mov    (%eax),%eax
 8b4:	6a 01                	push   $0x1
 8b6:	6a 0a                	push   $0xa
 8b8:	50                   	push   %eax
 8b9:	ff 75 08             	pushl  0x8(%ebp)
 8bc:	e8 bb fe ff ff       	call   77c <printint>
 8c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 8c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c8:	e9 d8 00 00 00       	jmp    9a5 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 8cd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8d1:	74 06                	je     8d9 <printf+0xa8>
 8d3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8d7:	75 1e                	jne    8f7 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 8d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	6a 00                	push   $0x0
 8e0:	6a 10                	push   $0x10
 8e2:	50                   	push   %eax
 8e3:	ff 75 08             	pushl  0x8(%ebp)
 8e6:	e8 91 fe ff ff       	call   77c <printint>
 8eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f2:	e9 ae 00 00 00       	jmp    9a5 <printf+0x174>
      } else if(c == 's'){
 8f7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8fb:	75 43                	jne    940 <printf+0x10f>
        s = (char*)*ap;
 8fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 905:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90d:	75 25                	jne    934 <printf+0x103>
          s = "(null)";
 90f:	c7 45 f4 2b 0d 00 00 	movl   $0xd2b,-0xc(%ebp)
        while(*s != 0){
 916:	eb 1c                	jmp    934 <printf+0x103>
          putc(fd, *s);
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	0f b6 00             	movzbl (%eax),%eax
 91e:	0f be c0             	movsbl %al,%eax
 921:	83 ec 08             	sub    $0x8,%esp
 924:	50                   	push   %eax
 925:	ff 75 08             	pushl  0x8(%ebp)
 928:	e8 28 fe ff ff       	call   755 <putc>
 92d:	83 c4 10             	add    $0x10,%esp
          s++;
 930:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	0f b6 00             	movzbl (%eax),%eax
 93a:	84 c0                	test   %al,%al
 93c:	75 da                	jne    918 <printf+0xe7>
 93e:	eb 65                	jmp    9a5 <printf+0x174>
        }
      } else if(c == 'c'){
 940:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 944:	75 1d                	jne    963 <printf+0x132>
        putc(fd, *ap);
 946:	8b 45 e8             	mov    -0x18(%ebp),%eax
 949:	8b 00                	mov    (%eax),%eax
 94b:	0f be c0             	movsbl %al,%eax
 94e:	83 ec 08             	sub    $0x8,%esp
 951:	50                   	push   %eax
 952:	ff 75 08             	pushl  0x8(%ebp)
 955:	e8 fb fd ff ff       	call   755 <putc>
 95a:	83 c4 10             	add    $0x10,%esp
        ap++;
 95d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 961:	eb 42                	jmp    9a5 <printf+0x174>
      } else if(c == '%'){
 963:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 967:	75 17                	jne    980 <printf+0x14f>
        putc(fd, c);
 969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96c:	0f be c0             	movsbl %al,%eax
 96f:	83 ec 08             	sub    $0x8,%esp
 972:	50                   	push   %eax
 973:	ff 75 08             	pushl  0x8(%ebp)
 976:	e8 da fd ff ff       	call   755 <putc>
 97b:	83 c4 10             	add    $0x10,%esp
 97e:	eb 25                	jmp    9a5 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 980:	83 ec 08             	sub    $0x8,%esp
 983:	6a 25                	push   $0x25
 985:	ff 75 08             	pushl  0x8(%ebp)
 988:	e8 c8 fd ff ff       	call   755 <putc>
 98d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 993:	0f be c0             	movsbl %al,%eax
 996:	83 ec 08             	sub    $0x8,%esp
 999:	50                   	push   %eax
 99a:	ff 75 08             	pushl  0x8(%ebp)
 99d:	e8 b3 fd ff ff       	call   755 <putc>
 9a2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 9ac:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 9b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b6:	01 d0                	add    %edx,%eax
 9b8:	0f b6 00             	movzbl (%eax),%eax
 9bb:	84 c0                	test   %al,%al
 9bd:	0f 85 94 fe ff ff    	jne    857 <printf+0x26>
    }
  }
}
 9c3:	90                   	nop
 9c4:	90                   	nop
 9c5:	c9                   	leave  
 9c6:	c3                   	ret    

000009c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c7:	f3 0f 1e fb          	endbr32 
 9cb:	55                   	push   %ebp
 9cc:	89 e5                	mov    %esp,%ebp
 9ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9d1:	8b 45 08             	mov    0x8(%ebp),%eax
 9d4:	83 e8 08             	sub    $0x8,%eax
 9d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9da:	a1 bc 0f 00 00       	mov    0xfbc,%eax
 9df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9e2:	eb 24                	jmp    a08 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	8b 00                	mov    (%eax),%eax
 9e9:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 9ec:	72 12                	jb     a00 <free+0x39>
 9ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9f4:	77 24                	ja     a1a <free+0x53>
 9f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f9:	8b 00                	mov    (%eax),%eax
 9fb:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9fe:	72 1a                	jb     a1a <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a03:	8b 00                	mov    (%eax),%eax
 a05:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a0e:	76 d4                	jbe    9e4 <free+0x1d>
 a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a13:	8b 00                	mov    (%eax),%eax
 a15:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 a18:	73 ca                	jae    9e4 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1d:	8b 40 04             	mov    0x4(%eax),%eax
 a20:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a27:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2a:	01 c2                	add    %eax,%edx
 a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2f:	8b 00                	mov    (%eax),%eax
 a31:	39 c2                	cmp    %eax,%edx
 a33:	75 24                	jne    a59 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a38:	8b 50 04             	mov    0x4(%eax),%edx
 a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3e:	8b 00                	mov    (%eax),%eax
 a40:	8b 40 04             	mov    0x4(%eax),%eax
 a43:	01 c2                	add    %eax,%edx
 a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a48:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4e:	8b 00                	mov    (%eax),%eax
 a50:	8b 10                	mov    (%eax),%edx
 a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a55:	89 10                	mov    %edx,(%eax)
 a57:	eb 0a                	jmp    a63 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5c:	8b 10                	mov    (%eax),%edx
 a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a61:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a63:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a66:	8b 40 04             	mov    0x4(%eax),%eax
 a69:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a73:	01 d0                	add    %edx,%eax
 a75:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 a78:	75 20                	jne    a9a <free+0xd3>
    p->s.size += bp->s.size;
 a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7d:	8b 50 04             	mov    0x4(%eax),%edx
 a80:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a83:	8b 40 04             	mov    0x4(%eax),%eax
 a86:	01 c2                	add    %eax,%edx
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a91:	8b 10                	mov    (%eax),%edx
 a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a96:	89 10                	mov    %edx,(%eax)
 a98:	eb 08                	jmp    aa2 <free+0xdb>
  } else
    p->s.ptr = bp;
 a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 aa0:	89 10                	mov    %edx,(%eax)
  freep = p;
 aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa5:	a3 bc 0f 00 00       	mov    %eax,0xfbc
}
 aaa:	90                   	nop
 aab:	c9                   	leave  
 aac:	c3                   	ret    

00000aad <morecore>:

static Header*
morecore(uint nu)
{
 aad:	f3 0f 1e fb          	endbr32 
 ab1:	55                   	push   %ebp
 ab2:	89 e5                	mov    %esp,%ebp
 ab4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ab7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 abe:	77 07                	ja     ac7 <morecore+0x1a>
    nu = 4096;
 ac0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ac7:	8b 45 08             	mov    0x8(%ebp),%eax
 aca:	c1 e0 03             	shl    $0x3,%eax
 acd:	83 ec 0c             	sub    $0xc,%esp
 ad0:	50                   	push   %eax
 ad1:	e8 4f fc ff ff       	call   725 <sbrk>
 ad6:	83 c4 10             	add    $0x10,%esp
 ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 adc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ae0:	75 07                	jne    ae9 <morecore+0x3c>
    return 0;
 ae2:	b8 00 00 00 00       	mov    $0x0,%eax
 ae7:	eb 26                	jmp    b0f <morecore+0x62>
  hp = (Header*)p;
 ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af2:	8b 55 08             	mov    0x8(%ebp),%edx
 af5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afb:	83 c0 08             	add    $0x8,%eax
 afe:	83 ec 0c             	sub    $0xc,%esp
 b01:	50                   	push   %eax
 b02:	e8 c0 fe ff ff       	call   9c7 <free>
 b07:	83 c4 10             	add    $0x10,%esp
  return freep;
 b0a:	a1 bc 0f 00 00       	mov    0xfbc,%eax
}
 b0f:	c9                   	leave  
 b10:	c3                   	ret    

00000b11 <malloc>:

void*
malloc(uint nbytes)
{
 b11:	f3 0f 1e fb          	endbr32 
 b15:	55                   	push   %ebp
 b16:	89 e5                	mov    %esp,%ebp
 b18:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b1b:	8b 45 08             	mov    0x8(%ebp),%eax
 b1e:	83 c0 07             	add    $0x7,%eax
 b21:	c1 e8 03             	shr    $0x3,%eax
 b24:	83 c0 01             	add    $0x1,%eax
 b27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b2a:	a1 bc 0f 00 00       	mov    0xfbc,%eax
 b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b36:	75 23                	jne    b5b <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 b38:	c7 45 f0 b4 0f 00 00 	movl   $0xfb4,-0x10(%ebp)
 b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b42:	a3 bc 0f 00 00       	mov    %eax,0xfbc
 b47:	a1 bc 0f 00 00       	mov    0xfbc,%eax
 b4c:	a3 b4 0f 00 00       	mov    %eax,0xfb4
    base.s.size = 0;
 b51:	c7 05 b8 0f 00 00 00 	movl   $0x0,0xfb8
 b58:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5e:	8b 00                	mov    (%eax),%eax
 b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	8b 40 04             	mov    0x4(%eax),%eax
 b69:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 b6c:	77 4d                	ja     bbb <malloc+0xaa>
      if(p->s.size == nunits)
 b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b71:	8b 40 04             	mov    0x4(%eax),%eax
 b74:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 b77:	75 0c                	jne    b85 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7c:	8b 10                	mov    (%eax),%edx
 b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b81:	89 10                	mov    %edx,(%eax)
 b83:	eb 26                	jmp    bab <malloc+0x9a>
      else {
        p->s.size -= nunits;
 b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b88:	8b 40 04             	mov    0x4(%eax),%eax
 b8b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b8e:	89 c2                	mov    %eax,%edx
 b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b93:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b99:	8b 40 04             	mov    0x4(%eax),%eax
 b9c:	c1 e0 03             	shl    $0x3,%eax
 b9f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ba8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bae:	a3 bc 0f 00 00       	mov    %eax,0xfbc
      return (void*)(p + 1);
 bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb6:	83 c0 08             	add    $0x8,%eax
 bb9:	eb 3b                	jmp    bf6 <malloc+0xe5>
    }
    if(p == freep)
 bbb:	a1 bc 0f 00 00       	mov    0xfbc,%eax
 bc0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bc3:	75 1e                	jne    be3 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 bc5:	83 ec 0c             	sub    $0xc,%esp
 bc8:	ff 75 ec             	pushl  -0x14(%ebp)
 bcb:	e8 dd fe ff ff       	call   aad <morecore>
 bd0:	83 c4 10             	add    $0x10,%esp
 bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bda:	75 07                	jne    be3 <malloc+0xd2>
        return 0;
 bdc:	b8 00 00 00 00       	mov    $0x0,%eax
 be1:	eb 13                	jmp    bf6 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bf1:	e9 6d ff ff ff       	jmp    b63 <malloc+0x52>
  }
}
 bf6:	c9                   	leave  
 bf7:	c3                   	ret    

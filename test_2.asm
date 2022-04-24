
_test_2:     file format elf32-i386


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
  10:	68 74 09 00 00       	push   $0x974
  15:	6a 01                	push   $0x1
  17:	e8 91 05 00 00       	call   5ad <printf>
  1c:	83 c4 10             	add    $0x10,%esp
    exit();
  1f:	e8 f5 03 00 00       	call   419 <exit>

00000024 <main>:
}

int main(void) {
  24:	f3 0f 1e fb          	endbr32 
  28:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  2c:	83 e4 f0             	and    $0xfffffff0,%esp
  2f:	ff 71 fc             	pushl  -0x4(%ecx)
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	51                   	push   %ecx
  36:	83 ec 24             	sub    $0x24,%esp
    const uint PAGES_NUM = 64;
  39:	c7 45 ec 40 00 00 00 	movl   $0x40,-0x14(%ebp)
    char *buffer = sbrk(PGSIZE * sizeof(char));
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 00 10 00 00       	push   $0x1000
  48:	e8 54 04 00 00       	call   4a1 <sbrk>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((uint)buffer != 0x6000)
  53:	eb 13                	jmp    68 <main+0x44>
        buffer = sbrk(PGSIZE * sizeof(char));
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	68 00 10 00 00       	push   $0x1000
  5d:	e8 3f 04 00 00       	call   4a1 <sbrk>
  62:	83 c4 10             	add    $0x10,%esp
  65:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((uint)buffer != 0x6000)
  68:	81 7d f0 00 60 00 00 	cmpl   $0x6000,-0x10(%ebp)
  6f:	75 e4                	jne    55 <main+0x31>
    
    sbrk(PAGES_NUM * PGSIZE);
  71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  74:	c1 e0 0c             	shl    $0xc,%eax
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	50                   	push   %eax
  7b:	e8 21 04 00 00       	call   4a1 <sbrk>
  80:	83 c4 10             	add    $0x10,%esp
    struct pt_entry pt_entries[PAGES_NUM];
  83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  86:	83 e8 01             	sub    $0x1,%eax
  89:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  96:	b8 10 00 00 00       	mov    $0x10,%eax
  9b:	83 e8 01             	sub    $0x1,%eax
  9e:	01 d0                	add    %edx,%eax
  a0:	b9 10 00 00 00       	mov    $0x10,%ecx
  a5:	ba 00 00 00 00       	mov    $0x0,%edx
  aa:	f7 f1                	div    %ecx
  ac:	6b c0 10             	imul   $0x10,%eax,%eax
  af:	89 c2                	mov    %eax,%edx
  b1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  b7:	89 e1                	mov    %esp,%ecx
  b9:	29 d1                	sub    %edx,%ecx
  bb:	89 ca                	mov    %ecx,%edx
  bd:	39 d4                	cmp    %edx,%esp
  bf:	74 10                	je     d1 <main+0xad>
  c1:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  c7:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  ce:	00 
  cf:	eb ec                	jmp    bd <main+0x99>
  d1:	89 c2                	mov    %eax,%edx
  d3:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  d9:	29 d4                	sub    %edx,%esp
  db:	89 c2                	mov    %eax,%edx
  dd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  e3:	85 d2                	test   %edx,%edx
  e5:	74 0d                	je     f4 <main+0xd0>
  e7:	25 ff 0f 00 00       	and    $0xfff,%eax
  ec:	83 e8 04             	sub    $0x4,%eax
  ef:	01 e0                	add    %esp,%eax
  f1:	83 08 00             	orl    $0x0,(%eax)
  f4:	89 e0                	mov    %esp,%eax
  f6:	83 c0 03             	add    $0x3,%eax
  f9:	c1 e8 02             	shr    $0x2,%eax
  fc:	c1 e0 02             	shl    $0x2,%eax
  ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    int retval = getpgtable(pt_entries, PAGES_NUM, 0);
 102:	8b 45 ec             	mov    -0x14(%ebp),%eax
 105:	83 ec 04             	sub    $0x4,%esp
 108:	6a 00                	push   $0x0
 10a:	50                   	push   %eax
 10b:	ff 75 e4             	pushl  -0x1c(%ebp)
 10e:	e8 ae 03 00 00       	call   4c1 <getpgtable>
 113:	83 c4 10             	add    $0x10,%esp
 116:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (retval == PAGES_NUM) {
 119:	8b 45 ec             	mov    -0x14(%ebp),%eax
 11c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
 11f:	75 4c                	jne    16d <main+0x149>
        for (int i = 0; i < retval; i++) {
 121:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 128:	eb 39                	jmp    163 <main+0x13f>
            if (dump_rawphymem(pt_entries[i].ppage * PGSIZE, buffer) != 0)
 12a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 130:	8b 44 d0 04          	mov    0x4(%eax,%edx,8),%eax
 134:	25 ff ff 0f 00       	and    $0xfffff,%eax
 139:	c1 e0 0c             	shl    $0xc,%eax
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	ff 75 f0             	pushl  -0x10(%ebp)
 142:	50                   	push   %eax
 143:	e8 81 03 00 00       	call   4c9 <dump_rawphymem>
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	74 10                	je     15f <main+0x13b>
                err("dump_rawphymem return non-zero value\n");
 14f:	83 ec 0c             	sub    $0xc,%esp
 152:	68 88 09 00 00       	push   $0x988
 157:	e8 a4 fe ff ff       	call   0 <err>
 15c:	83 c4 10             	add    $0x10,%esp
        for (int i = 0; i < retval; i++) {
 15f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 163:	8b 45 f4             	mov    -0xc(%ebp),%eax
 166:	3b 45 e0             	cmp    -0x20(%ebp),%eax
 169:	7c bf                	jl     12a <main+0x106>
 16b:	eb 1a                	jmp    187 <main+0x163>
        }
    } else {
        printf(1, "XV6_TEST_OUTPUT: getpgtable returned incorrect value: expected %d, got %d\n", PAGES_NUM, retval);
 16d:	ff 75 e0             	pushl  -0x20(%ebp)
 170:	ff 75 ec             	pushl  -0x14(%ebp)
 173:	68 b0 09 00 00       	push   $0x9b0
 178:	6a 01                	push   $0x1
 17a:	e8 2e 04 00 00       	call   5ad <printf>
 17f:	83 c4 10             	add    $0x10,%esp
        exit();
 182:	e8 92 02 00 00       	call   419 <exit>
    }
    
    printf(1, "XV6_TEST_OUTPUT PASS!\n");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 fb 09 00 00       	push   $0x9fb
 18f:	6a 01                	push   $0x1
 191:	e8 17 04 00 00       	call   5ad <printf>
 196:	83 c4 10             	add    $0x10,%esp
    exit();
 199:	e8 7b 02 00 00       	call   419 <exit>

0000019e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	57                   	push   %edi
 1a2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a6:	8b 55 10             	mov    0x10(%ebp),%edx
 1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ac:	89 cb                	mov    %ecx,%ebx
 1ae:	89 df                	mov    %ebx,%edi
 1b0:	89 d1                	mov    %edx,%ecx
 1b2:	fc                   	cld    
 1b3:	f3 aa                	rep stos %al,%es:(%edi)
 1b5:	89 ca                	mov    %ecx,%edx
 1b7:	89 fb                	mov    %edi,%ebx
 1b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1bc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1bf:	90                   	nop
 1c0:	5b                   	pop    %ebx
 1c1:	5f                   	pop    %edi
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    

000001c4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1c4:	f3 0f 1e fb          	endbr32 
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1d4:	90                   	nop
 1d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 1d8:	8d 42 01             	lea    0x1(%edx),%eax
 1db:	89 45 0c             	mov    %eax,0xc(%ebp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	8d 48 01             	lea    0x1(%eax),%ecx
 1e4:	89 4d 08             	mov    %ecx,0x8(%ebp)
 1e7:	0f b6 12             	movzbl (%edx),%edx
 1ea:	88 10                	mov    %dl,(%eax)
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	84 c0                	test   %al,%al
 1f1:	75 e2                	jne    1d5 <strcpy+0x11>
    ;
  return os;
 1f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f6:	c9                   	leave  
 1f7:	c3                   	ret    

000001f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f8:	f3 0f 1e fb          	endbr32 
 1fc:	55                   	push   %ebp
 1fd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ff:	eb 08                	jmp    209 <strcmp+0x11>
    p++, q++;
 201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 205:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	84 c0                	test   %al,%al
 211:	74 10                	je     223 <strcmp+0x2b>
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	0f b6 10             	movzbl (%eax),%edx
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	38 c2                	cmp    %al,%dl
 221:	74 de                	je     201 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	0f b6 d0             	movzbl %al,%edx
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	0f b6 00             	movzbl (%eax),%eax
 232:	0f b6 c0             	movzbl %al,%eax
 235:	29 c2                	sub    %eax,%edx
 237:	89 d0                	mov    %edx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strlen>:

uint
strlen(const char *s)
{
 23b:	f3 0f 1e fb          	endbr32 
 23f:	55                   	push   %ebp
 240:	89 e5                	mov    %esp,%ebp
 242:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 24c:	eb 04                	jmp    252 <strlen+0x17>
 24e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 252:	8b 55 fc             	mov    -0x4(%ebp),%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	01 d0                	add    %edx,%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	84 c0                	test   %al,%al
 25f:	75 ed                	jne    24e <strlen+0x13>
    ;
  return n;
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <memset>:

void*
memset(void *dst, int c, uint n)
{
 266:	f3 0f 1e fb          	endbr32 
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 26d:	8b 45 10             	mov    0x10(%ebp),%eax
 270:	50                   	push   %eax
 271:	ff 75 0c             	pushl  0xc(%ebp)
 274:	ff 75 08             	pushl  0x8(%ebp)
 277:	e8 22 ff ff ff       	call   19e <stosb>
 27c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	f3 0f 1e fb          	endbr32 
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	83 ec 04             	sub    $0x4,%esp
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 294:	eb 14                	jmp    2aa <strchr+0x26>
    if(*s == c)
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 29f:	75 05                	jne    2a6 <strchr+0x22>
      return (char*)s;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	eb 13                	jmp    2b9 <strchr+0x35>
  for(; *s; s++)
 2a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	0f b6 00             	movzbl (%eax),%eax
 2b0:	84 c0                	test   %al,%al
 2b2:	75 e2                	jne    296 <strchr+0x12>
  return 0;
 2b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b9:	c9                   	leave  
 2ba:	c3                   	ret    

000002bb <gets>:

char*
gets(char *buf, int max)
{
 2bb:	f3 0f 1e fb          	endbr32 
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2cc:	eb 42                	jmp    310 <gets+0x55>
    cc = read(0, &c, 1);
 2ce:	83 ec 04             	sub    $0x4,%esp
 2d1:	6a 01                	push   $0x1
 2d3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2d6:	50                   	push   %eax
 2d7:	6a 00                	push   $0x0
 2d9:	e8 53 01 00 00       	call   431 <read>
 2de:	83 c4 10             	add    $0x10,%esp
 2e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2e8:	7e 33                	jle    31d <gets+0x62>
      break;
    buf[i++] = c;
 2ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ed:	8d 50 01             	lea    0x1(%eax),%edx
 2f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2f3:	89 c2                	mov    %eax,%edx
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	01 c2                	add    %eax,%edx
 2fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2fe:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 300:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 304:	3c 0a                	cmp    $0xa,%al
 306:	74 16                	je     31e <gets+0x63>
 308:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30c:	3c 0d                	cmp    $0xd,%al
 30e:	74 0e                	je     31e <gets+0x63>
  for(i=0; i+1 < max; ){
 310:	8b 45 f4             	mov    -0xc(%ebp),%eax
 313:	83 c0 01             	add    $0x1,%eax
 316:	39 45 0c             	cmp    %eax,0xc(%ebp)
 319:	7f b3                	jg     2ce <gets+0x13>
 31b:	eb 01                	jmp    31e <gets+0x63>
      break;
 31d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 31e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	01 d0                	add    %edx,%eax
 326:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 329:	8b 45 08             	mov    0x8(%ebp),%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <stat>:

int
stat(const char *n, struct stat *st)
{
 32e:	f3 0f 1e fb          	endbr32 
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	6a 00                	push   $0x0
 33d:	ff 75 08             	pushl  0x8(%ebp)
 340:	e8 14 01 00 00       	call   459 <open>
 345:	83 c4 10             	add    $0x10,%esp
 348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 34f:	79 07                	jns    358 <stat+0x2a>
    return -1;
 351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 356:	eb 25                	jmp    37d <stat+0x4f>
  r = fstat(fd, st);
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	ff 75 0c             	pushl  0xc(%ebp)
 35e:	ff 75 f4             	pushl  -0xc(%ebp)
 361:	e8 0b 01 00 00       	call   471 <fstat>
 366:	83 c4 10             	add    $0x10,%esp
 369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36c:	83 ec 0c             	sub    $0xc,%esp
 36f:	ff 75 f4             	pushl  -0xc(%ebp)
 372:	e8 ca 00 00 00       	call   441 <close>
 377:	83 c4 10             	add    $0x10,%esp
  return r;
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 37d:	c9                   	leave  
 37e:	c3                   	ret    

0000037f <atoi>:

int
atoi(const char *s)
{
 37f:	f3 0f 1e fb          	endbr32 
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 390:	eb 25                	jmp    3b7 <atoi+0x38>
    n = n*10 + *s++ - '0';
 392:	8b 55 fc             	mov    -0x4(%ebp),%edx
 395:	89 d0                	mov    %edx,%eax
 397:	c1 e0 02             	shl    $0x2,%eax
 39a:	01 d0                	add    %edx,%eax
 39c:	01 c0                	add    %eax,%eax
 39e:	89 c1                	mov    %eax,%ecx
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	8d 50 01             	lea    0x1(%eax),%edx
 3a6:	89 55 08             	mov    %edx,0x8(%ebp)
 3a9:	0f b6 00             	movzbl (%eax),%eax
 3ac:	0f be c0             	movsbl %al,%eax
 3af:	01 c8                	add    %ecx,%eax
 3b1:	83 e8 30             	sub    $0x30,%eax
 3b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	3c 2f                	cmp    $0x2f,%al
 3bf:	7e 0a                	jle    3cb <atoi+0x4c>
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	0f b6 00             	movzbl (%eax),%eax
 3c7:	3c 39                	cmp    $0x39,%al
 3c9:	7e c7                	jle    392 <atoi+0x13>
  return n;
 3cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ce:	c9                   	leave  
 3cf:	c3                   	ret    

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e6:	eb 17                	jmp    3ff <memmove+0x2f>
    *dst++ = *src++;
 3e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3eb:	8d 42 01             	lea    0x1(%edx),%eax
 3ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f4:	8d 48 01             	lea    0x1(%eax),%ecx
 3f7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3fa:	0f b6 12             	movzbl (%edx),%edx
 3fd:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3ff:	8b 45 10             	mov    0x10(%ebp),%eax
 402:	8d 50 ff             	lea    -0x1(%eax),%edx
 405:	89 55 10             	mov    %edx,0x10(%ebp)
 408:	85 c0                	test   %eax,%eax
 40a:	7f dc                	jg     3e8 <memmove+0x18>
  return vdst;
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40f:	c9                   	leave  
 410:	c3                   	ret    

00000411 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 411:	b8 01 00 00 00       	mov    $0x1,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <exit>:
SYSCALL(exit)
 419:	b8 02 00 00 00       	mov    $0x2,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <wait>:
SYSCALL(wait)
 421:	b8 03 00 00 00       	mov    $0x3,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <pipe>:
SYSCALL(pipe)
 429:	b8 04 00 00 00       	mov    $0x4,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <read>:
SYSCALL(read)
 431:	b8 05 00 00 00       	mov    $0x5,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <write>:
SYSCALL(write)
 439:	b8 10 00 00 00       	mov    $0x10,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <close>:
SYSCALL(close)
 441:	b8 15 00 00 00       	mov    $0x15,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <kill>:
SYSCALL(kill)
 449:	b8 06 00 00 00       	mov    $0x6,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <exec>:
SYSCALL(exec)
 451:	b8 07 00 00 00       	mov    $0x7,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <open>:
SYSCALL(open)
 459:	b8 0f 00 00 00       	mov    $0xf,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <mknod>:
SYSCALL(mknod)
 461:	b8 11 00 00 00       	mov    $0x11,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <unlink>:
SYSCALL(unlink)
 469:	b8 12 00 00 00       	mov    $0x12,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <fstat>:
SYSCALL(fstat)
 471:	b8 08 00 00 00       	mov    $0x8,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <link>:
SYSCALL(link)
 479:	b8 13 00 00 00       	mov    $0x13,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <mkdir>:
SYSCALL(mkdir)
 481:	b8 14 00 00 00       	mov    $0x14,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <chdir>:
SYSCALL(chdir)
 489:	b8 09 00 00 00       	mov    $0x9,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <dup>:
SYSCALL(dup)
 491:	b8 0a 00 00 00       	mov    $0xa,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <getpid>:
SYSCALL(getpid)
 499:	b8 0b 00 00 00       	mov    $0xb,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <sbrk>:
SYSCALL(sbrk)
 4a1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <sleep>:
SYSCALL(sleep)
 4a9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <uptime>:
SYSCALL(uptime)
 4b1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <mencrypt>:
SYSCALL(mencrypt)
 4b9:	b8 16 00 00 00       	mov    $0x16,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <getpgtable>:
SYSCALL(getpgtable)
 4c1:	b8 17 00 00 00       	mov    $0x17,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 4c9:	b8 18 00 00 00       	mov    $0x18,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d1:	f3 0f 1e fb          	endbr32 
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 18             	sub    $0x18,%esp
 4db:	8b 45 0c             	mov    0xc(%ebp),%eax
 4de:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e1:	83 ec 04             	sub    $0x4,%esp
 4e4:	6a 01                	push   $0x1
 4e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 47 ff ff ff       	call   439 <write>
 4f2:	83 c4 10             	add    $0x10,%esp
}
 4f5:	90                   	nop
 4f6:	c9                   	leave  
 4f7:	c3                   	ret    

000004f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f8:	f3 0f 1e fb          	endbr32 
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 509:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 50d:	74 17                	je     526 <printint+0x2e>
 50f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 513:	79 11                	jns    526 <printint+0x2e>
    neg = 1;
 515:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	f7 d8                	neg    %eax
 521:	89 45 ec             	mov    %eax,-0x14(%ebp)
 524:	eb 06                	jmp    52c <printint+0x34>
  } else {
    x = xx;
 526:	8b 45 0c             	mov    0xc(%ebp),%eax
 529:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 52c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 533:	8b 4d 10             	mov    0x10(%ebp),%ecx
 536:	8b 45 ec             	mov    -0x14(%ebp),%eax
 539:	ba 00 00 00 00       	mov    $0x0,%edx
 53e:	f7 f1                	div    %ecx
 540:	89 d1                	mov    %edx,%ecx
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	8d 50 01             	lea    0x1(%eax),%edx
 548:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54b:	0f b6 91 7c 0c 00 00 	movzbl 0xc7c(%ecx),%edx
 552:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 556:	8b 4d 10             	mov    0x10(%ebp),%ecx
 559:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55c:	ba 00 00 00 00       	mov    $0x0,%edx
 561:	f7 f1                	div    %ecx
 563:	89 45 ec             	mov    %eax,-0x14(%ebp)
 566:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56a:	75 c7                	jne    533 <printint+0x3b>
  if(neg)
 56c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 570:	74 2d                	je     59f <printint+0xa7>
    buf[i++] = '-';
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	8d 50 01             	lea    0x1(%eax),%edx
 578:	89 55 f4             	mov    %edx,-0xc(%ebp)
 57b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 580:	eb 1d                	jmp    59f <printint+0xa7>
    putc(fd, buf[i]);
 582:	8d 55 dc             	lea    -0x24(%ebp),%edx
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	01 d0                	add    %edx,%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 35 ff ff ff       	call   4d1 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 59f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a7:	79 d9                	jns    582 <printint+0x8a>
}
 5a9:	90                   	nop
 5aa:	90                   	nop
 5ab:	c9                   	leave  
 5ac:	c3                   	ret    

000005ad <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5ad:	f3 0f 1e fb          	endbr32 
 5b1:	55                   	push   %ebp
 5b2:	89 e5                	mov    %esp,%ebp
 5b4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5be:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c1:	83 c0 04             	add    $0x4,%eax
 5c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ce:	e9 59 01 00 00       	jmp    72c <printf+0x17f>
    c = fmt[i] & 0xff;
 5d3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d9:	01 d0                	add    %edx,%eax
 5db:	0f b6 00             	movzbl (%eax),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	25 ff 00 00 00       	and    $0xff,%eax
 5e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ed:	75 2c                	jne    61b <printf+0x6e>
      if(c == '%'){
 5ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f3:	75 0c                	jne    601 <printf+0x54>
        state = '%';
 5f5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5fc:	e9 27 01 00 00       	jmp    728 <printf+0x17b>
      } else {
        putc(fd, c);
 601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 604:	0f be c0             	movsbl %al,%eax
 607:	83 ec 08             	sub    $0x8,%esp
 60a:	50                   	push   %eax
 60b:	ff 75 08             	pushl  0x8(%ebp)
 60e:	e8 be fe ff ff       	call   4d1 <putc>
 613:	83 c4 10             	add    $0x10,%esp
 616:	e9 0d 01 00 00       	jmp    728 <printf+0x17b>
      }
    } else if(state == '%'){
 61b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 61f:	0f 85 03 01 00 00    	jne    728 <printf+0x17b>
      if(c == 'd'){
 625:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 629:	75 1e                	jne    649 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	6a 01                	push   $0x1
 632:	6a 0a                	push   $0xa
 634:	50                   	push   %eax
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 bb fe ff ff       	call   4f8 <printint>
 63d:	83 c4 10             	add    $0x10,%esp
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 644:	e9 d8 00 00 00       	jmp    721 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 649:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64d:	74 06                	je     655 <printf+0xa8>
 64f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 653:	75 1e                	jne    673 <printf+0xc6>
        printint(fd, *ap, 16, 0);
 655:	8b 45 e8             	mov    -0x18(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	6a 00                	push   $0x0
 65c:	6a 10                	push   $0x10
 65e:	50                   	push   %eax
 65f:	ff 75 08             	pushl  0x8(%ebp)
 662:	e8 91 fe ff ff       	call   4f8 <printint>
 667:	83 c4 10             	add    $0x10,%esp
        ap++;
 66a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66e:	e9 ae 00 00 00       	jmp    721 <printf+0x174>
      } else if(c == 's'){
 673:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 677:	75 43                	jne    6bc <printf+0x10f>
        s = (char*)*ap;
 679:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67c:	8b 00                	mov    (%eax),%eax
 67e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 681:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 689:	75 25                	jne    6b0 <printf+0x103>
          s = "(null)";
 68b:	c7 45 f4 12 0a 00 00 	movl   $0xa12,-0xc(%ebp)
        while(*s != 0){
 692:	eb 1c                	jmp    6b0 <printf+0x103>
          putc(fd, *s);
 694:	8b 45 f4             	mov    -0xc(%ebp),%eax
 697:	0f b6 00             	movzbl (%eax),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 ec 08             	sub    $0x8,%esp
 6a0:	50                   	push   %eax
 6a1:	ff 75 08             	pushl  0x8(%ebp)
 6a4:	e8 28 fe ff ff       	call   4d1 <putc>
 6a9:	83 c4 10             	add    $0x10,%esp
          s++;
 6ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b3:	0f b6 00             	movzbl (%eax),%eax
 6b6:	84 c0                	test   %al,%al
 6b8:	75 da                	jne    694 <printf+0xe7>
 6ba:	eb 65                	jmp    721 <printf+0x174>
        }
      } else if(c == 'c'){
 6bc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c0:	75 1d                	jne    6df <printf+0x132>
        putc(fd, *ap);
 6c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	0f be c0             	movsbl %al,%eax
 6ca:	83 ec 08             	sub    $0x8,%esp
 6cd:	50                   	push   %eax
 6ce:	ff 75 08             	pushl  0x8(%ebp)
 6d1:	e8 fb fd ff ff       	call   4d1 <putc>
 6d6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6dd:	eb 42                	jmp    721 <printf+0x174>
      } else if(c == '%'){
 6df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e3:	75 17                	jne    6fc <printf+0x14f>
        putc(fd, c);
 6e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e8:	0f be c0             	movsbl %al,%eax
 6eb:	83 ec 08             	sub    $0x8,%esp
 6ee:	50                   	push   %eax
 6ef:	ff 75 08             	pushl  0x8(%ebp)
 6f2:	e8 da fd ff ff       	call   4d1 <putc>
 6f7:	83 c4 10             	add    $0x10,%esp
 6fa:	eb 25                	jmp    721 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6fc:	83 ec 08             	sub    $0x8,%esp
 6ff:	6a 25                	push   $0x25
 701:	ff 75 08             	pushl  0x8(%ebp)
 704:	e8 c8 fd ff ff       	call   4d1 <putc>
 709:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 70c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70f:	0f be c0             	movsbl %al,%eax
 712:	83 ec 08             	sub    $0x8,%esp
 715:	50                   	push   %eax
 716:	ff 75 08             	pushl  0x8(%ebp)
 719:	e8 b3 fd ff ff       	call   4d1 <putc>
 71e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 721:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 728:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 72c:	8b 55 0c             	mov    0xc(%ebp),%edx
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	01 d0                	add    %edx,%eax
 734:	0f b6 00             	movzbl (%eax),%eax
 737:	84 c0                	test   %al,%al
 739:	0f 85 94 fe ff ff    	jne    5d3 <printf+0x26>
    }
  }
}
 73f:	90                   	nop
 740:	90                   	nop
 741:	c9                   	leave  
 742:	c3                   	ret    

00000743 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 743:	f3 0f 1e fb          	endbr32 
 747:	55                   	push   %ebp
 748:	89 e5                	mov    %esp,%ebp
 74a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74d:	8b 45 08             	mov    0x8(%ebp),%eax
 750:	83 e8 08             	sub    $0x8,%eax
 753:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 756:	a1 98 0c 00 00       	mov    0xc98,%eax
 75b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75e:	eb 24                	jmp    784 <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 768:	72 12                	jb     77c <free+0x39>
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 770:	77 24                	ja     796 <free+0x53>
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 77a:	72 1a                	jb     796 <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	89 45 fc             	mov    %eax,-0x4(%ebp)
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78a:	76 d4                	jbe    760 <free+0x1d>
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 794:	73 ca                	jae    760 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	01 c2                	add    %eax,%edx
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	39 c2                	cmp    %eax,%edx
 7af:	75 24                	jne    7d5 <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 50 04             	mov    0x4(%eax),%edx
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	01 c2                	add    %eax,%edx
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	8b 10                	mov    (%eax),%edx
 7ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d1:	89 10                	mov    %edx,(%eax)
 7d3:	eb 0a                	jmp    7df <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ef:	01 d0                	add    %edx,%eax
 7f1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7f4:	75 20                	jne    816 <free+0xd3>
    p->s.size += bp->s.size;
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	8b 50 04             	mov    0x4(%eax),%edx
 7fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	01 c2                	add    %eax,%edx
 804:	8b 45 fc             	mov    -0x4(%ebp),%eax
 807:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	8b 10                	mov    (%eax),%edx
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	89 10                	mov    %edx,(%eax)
 814:	eb 08                	jmp    81e <free+0xdb>
  } else
    p->s.ptr = bp;
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 55 f8             	mov    -0x8(%ebp),%edx
 81c:	89 10                	mov    %edx,(%eax)
  freep = p;
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	a3 98 0c 00 00       	mov    %eax,0xc98
}
 826:	90                   	nop
 827:	c9                   	leave  
 828:	c3                   	ret    

00000829 <morecore>:

static Header*
morecore(uint nu)
{
 829:	f3 0f 1e fb          	endbr32 
 82d:	55                   	push   %ebp
 82e:	89 e5                	mov    %esp,%ebp
 830:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 833:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83a:	77 07                	ja     843 <morecore+0x1a>
    nu = 4096;
 83c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	c1 e0 03             	shl    $0x3,%eax
 849:	83 ec 0c             	sub    $0xc,%esp
 84c:	50                   	push   %eax
 84d:	e8 4f fc ff ff       	call   4a1 <sbrk>
 852:	83 c4 10             	add    $0x10,%esp
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85c:	75 07                	jne    865 <morecore+0x3c>
    return 0;
 85e:	b8 00 00 00 00       	mov    $0x0,%eax
 863:	eb 26                	jmp    88b <morecore+0x62>
  hp = (Header*)p;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86e:	8b 55 08             	mov    0x8(%ebp),%edx
 871:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 874:	8b 45 f0             	mov    -0x10(%ebp),%eax
 877:	83 c0 08             	add    $0x8,%eax
 87a:	83 ec 0c             	sub    $0xc,%esp
 87d:	50                   	push   %eax
 87e:	e8 c0 fe ff ff       	call   743 <free>
 883:	83 c4 10             	add    $0x10,%esp
  return freep;
 886:	a1 98 0c 00 00       	mov    0xc98,%eax
}
 88b:	c9                   	leave  
 88c:	c3                   	ret    

0000088d <malloc>:

void*
malloc(uint nbytes)
{
 88d:	f3 0f 1e fb          	endbr32 
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	83 c0 07             	add    $0x7,%eax
 89d:	c1 e8 03             	shr    $0x3,%eax
 8a0:	83 c0 01             	add    $0x1,%eax
 8a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a6:	a1 98 0c 00 00       	mov    0xc98,%eax
 8ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b2:	75 23                	jne    8d7 <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 8b4:	c7 45 f0 90 0c 00 00 	movl   $0xc90,-0x10(%ebp)
 8bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8be:	a3 98 0c 00 00       	mov    %eax,0xc98
 8c3:	a1 98 0c 00 00       	mov    0xc98,%eax
 8c8:	a3 90 0c 00 00       	mov    %eax,0xc90
    base.s.size = 0;
 8cd:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 8d4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8e8:	77 4d                	ja     937 <malloc+0xaa>
      if(p->s.size == nunits)
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	8b 40 04             	mov    0x4(%eax),%eax
 8f0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8f3:	75 0c                	jne    901 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 10                	mov    (%eax),%edx
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	89 10                	mov    %edx,(%eax)
 8ff:	eb 26                	jmp    927 <malloc+0x9a>
      else {
        p->s.size -= nunits;
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 40 04             	mov    0x4(%eax),%eax
 907:	2b 45 ec             	sub    -0x14(%ebp),%eax
 90a:	89 c2                	mov    %eax,%edx
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	8b 40 04             	mov    0x4(%eax),%eax
 918:	c1 e0 03             	shl    $0x3,%eax
 91b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	8b 55 ec             	mov    -0x14(%ebp),%edx
 924:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	a3 98 0c 00 00       	mov    %eax,0xc98
      return (void*)(p + 1);
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	83 c0 08             	add    $0x8,%eax
 935:	eb 3b                	jmp    972 <malloc+0xe5>
    }
    if(p == freep)
 937:	a1 98 0c 00 00       	mov    0xc98,%eax
 93c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93f:	75 1e                	jne    95f <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 941:	83 ec 0c             	sub    $0xc,%esp
 944:	ff 75 ec             	pushl  -0x14(%ebp)
 947:	e8 dd fe ff ff       	call   829 <morecore>
 94c:	83 c4 10             	add    $0x10,%esp
 94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 956:	75 07                	jne    95f <malloc+0xd2>
        return 0;
 958:	b8 00 00 00 00       	mov    $0x0,%eax
 95d:	eb 13                	jmp    972 <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 962:	89 45 f0             	mov    %eax,-0x10(%ebp)
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 96d:	e9 6d ff ff ff       	jmp    8df <malloc+0x52>
  }
}
 972:	c9                   	leave  
 973:	c3                   	ret    

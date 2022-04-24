
_test_6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"

#define PGSIZE 4096

int 
main(void){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 14             	sub    $0x14,%esp
    const uint PAGES_NUM = 5;
  15:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
    // Allocate one pages of space
    char *ptr = sbrk(PGSIZE * sizeof(char));
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	68 00 10 00 00       	push   $0x1000
  24:	e8 80 03 00 00       	call   3a9 <sbrk>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ptr = sbrk(PAGES_NUM * PGSIZE);
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	c1 e0 0c             	shl    $0xc,%eax
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	50                   	push   %eax
  39:	e8 6b 03 00 00       	call   3a9 <sbrk>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int ppid = getpid();
  44:	e8 58 03 00 00       	call   3a1 <getpid>
  49:	89 45 ec             	mov    %eax,-0x14(%ebp)

    if (fork() == 0) {
  4c:	e8 c8 02 00 00       	call   319 <fork>
  51:	85 c0                	test   %eax,%eax
  53:	75 35                	jne    8a <main+0x8a>
        // Should page fault as normally here
        ptr[PAGES_NUM * PGSIZE] = 0xAA;
  55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  58:	c1 e0 0c             	shl    $0xc,%eax
  5b:	89 c2                	mov    %eax,%edx
  5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  60:	01 d0                	add    %edx,%eax
  62:	c6 00 aa             	movb   $0xaa,(%eax)
        printf(1, "XV6_TEST_OUTPUT Seg fault failed to trigger\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 7c 08 00 00       	push   $0x87c
  6d:	6a 01                	push   $0x1
  6f:	e8 41 04 00 00       	call   4b5 <printf>
  74:	83 c4 10             	add    $0x10,%esp
        // Shouldn't reach here
        kill(ppid);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	ff 75 ec             	pushl  -0x14(%ebp)
  7d:	e8 cf 02 00 00       	call   351 <kill>
  82:	83 c4 10             	add    $0x10,%esp
        exit();
  85:	e8 97 02 00 00       	call   321 <exit>
    } else {
        wait();
  8a:	e8 9a 02 00 00       	call   329 <wait>
    }

    printf(1, "XV6_TEST_OUTPUT TEST PASS\n");
  8f:	83 ec 08             	sub    $0x8,%esp
  92:	68 a9 08 00 00       	push   $0x8a9
  97:	6a 01                	push   $0x1
  99:	e8 17 04 00 00       	call   4b5 <printf>
  9e:	83 c4 10             	add    $0x10,%esp

    exit();
  a1:	e8 7b 02 00 00       	call   321 <exit>

000000a6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	57                   	push   %edi
  aa:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ae:	8b 55 10             	mov    0x10(%ebp),%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	89 cb                	mov    %ecx,%ebx
  b6:	89 df                	mov    %ebx,%edi
  b8:	89 d1                	mov    %edx,%ecx
  ba:	fc                   	cld    
  bb:	f3 aa                	rep stos %al,%es:(%edi)
  bd:	89 ca                	mov    %ecx,%edx
  bf:	89 fb                	mov    %edi,%ebx
  c1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c7:	90                   	nop
  c8:	5b                   	pop    %ebx
  c9:	5f                   	pop    %edi
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  cc:	f3 0f 1e fb          	endbr32 
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  dc:	90                   	nop
  dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  e0:	8d 42 01             	lea    0x1(%edx),%eax
  e3:	89 45 0c             	mov    %eax,0xc(%ebp)
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	8d 48 01             	lea    0x1(%eax),%ecx
  ec:	89 4d 08             	mov    %ecx,0x8(%ebp)
  ef:	0f b6 12             	movzbl (%edx),%edx
  f2:	88 10                	mov    %dl,(%eax)
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	75 e2                	jne    dd <strcpy+0x11>
    ;
  return os;
  fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fe:	c9                   	leave  
  ff:	c3                   	ret    

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 107:	eb 08                	jmp    111 <strcmp+0x11>
    p++, q++;
 109:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	74 10                	je     12b <strcmp+0x2b>
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	0f b6 10             	movzbl (%eax),%edx
 121:	8b 45 0c             	mov    0xc(%ebp),%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	38 c2                	cmp    %al,%dl
 129:	74 de                	je     109 <strcmp+0x9>
  return (uchar)*p - (uchar)*q;
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	0f b6 d0             	movzbl %al,%edx
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	0f b6 c0             	movzbl %al,%eax
 13d:	29 c2                	sub    %eax,%edx
 13f:	89 d0                	mov    %edx,%eax
}
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <strlen>:

uint
strlen(const char *s)
{
 143:	f3 0f 1e fb          	endbr32 
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 154:	eb 04                	jmp    15a <strlen+0x17>
 156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	01 d0                	add    %edx,%eax
 162:	0f b6 00             	movzbl (%eax),%eax
 165:	84 c0                	test   %al,%al
 167:	75 ed                	jne    156 <strlen+0x13>
    ;
  return n;
 169:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <memset>:

void*
memset(void *dst, int c, uint n)
{
 16e:	f3 0f 1e fb          	endbr32 
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 175:	8b 45 10             	mov    0x10(%ebp),%eax
 178:	50                   	push   %eax
 179:	ff 75 0c             	pushl  0xc(%ebp)
 17c:	ff 75 08             	pushl  0x8(%ebp)
 17f:	e8 22 ff ff ff       	call   a6 <stosb>
 184:	83 c4 0c             	add    $0xc,%esp
  return dst;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18a:	c9                   	leave  
 18b:	c3                   	ret    

0000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	f3 0f 1e fb          	endbr32 
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 04             	sub    $0x4,%esp
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19c:	eb 14                	jmp    1b2 <strchr+0x26>
    if(*s == c)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1a7:	75 05                	jne    1ae <strchr+0x22>
      return (char*)s;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	eb 13                	jmp    1c1 <strchr+0x35>
  for(; *s; s++)
 1ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	84 c0                	test   %al,%al
 1ba:	75 e2                	jne    19e <strchr+0x12>
  return 0;
 1bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <gets>:

char*
gets(char *buf, int max)
{
 1c3:	f3 0f 1e fb          	endbr32 
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d4:	eb 42                	jmp    218 <gets+0x55>
    cc = read(0, &c, 1);
 1d6:	83 ec 04             	sub    $0x4,%esp
 1d9:	6a 01                	push   $0x1
 1db:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1de:	50                   	push   %eax
 1df:	6a 00                	push   $0x0
 1e1:	e8 53 01 00 00       	call   339 <read>
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f0:	7e 33                	jle    225 <gets+0x62>
      break;
    buf[i++] = c;
 1f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f5:	8d 50 01             	lea    0x1(%eax),%edx
 1f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1fb:	89 c2                	mov    %eax,%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 c2                	add    %eax,%edx
 202:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 206:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 208:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20c:	3c 0a                	cmp    $0xa,%al
 20e:	74 16                	je     226 <gets+0x63>
 210:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 214:	3c 0d                	cmp    $0xd,%al
 216:	74 0e                	je     226 <gets+0x63>
  for(i=0; i+1 < max; ){
 218:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21b:	83 c0 01             	add    $0x1,%eax
 21e:	39 45 0c             	cmp    %eax,0xc(%ebp)
 221:	7f b3                	jg     1d6 <gets+0x13>
 223:	eb 01                	jmp    226 <gets+0x63>
      break;
 225:	90                   	nop
      break;
  }
  buf[i] = '\0';
 226:	8b 55 f4             	mov    -0xc(%ebp),%edx
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	01 d0                	add    %edx,%eax
 22e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <stat>:

int
stat(const char *n, struct stat *st)
{
 236:	f3 0f 1e fb          	endbr32 
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 240:	83 ec 08             	sub    $0x8,%esp
 243:	6a 00                	push   $0x0
 245:	ff 75 08             	pushl  0x8(%ebp)
 248:	e8 14 01 00 00       	call   361 <open>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 257:	79 07                	jns    260 <stat+0x2a>
    return -1;
 259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25e:	eb 25                	jmp    285 <stat+0x4f>
  r = fstat(fd, st);
 260:	83 ec 08             	sub    $0x8,%esp
 263:	ff 75 0c             	pushl  0xc(%ebp)
 266:	ff 75 f4             	pushl  -0xc(%ebp)
 269:	e8 0b 01 00 00       	call   379 <fstat>
 26e:	83 c4 10             	add    $0x10,%esp
 271:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 274:	83 ec 0c             	sub    $0xc,%esp
 277:	ff 75 f4             	pushl  -0xc(%ebp)
 27a:	e8 ca 00 00 00       	call   349 <close>
 27f:	83 c4 10             	add    $0x10,%esp
  return r;
 282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <atoi>:

int
atoi(const char *s)
{
 287:	f3 0f 1e fb          	endbr32 
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 291:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 298:	eb 25                	jmp    2bf <atoi+0x38>
    n = n*10 + *s++ - '0';
 29a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29d:	89 d0                	mov    %edx,%eax
 29f:	c1 e0 02             	shl    $0x2,%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	01 c0                	add    %eax,%eax
 2a6:	89 c1                	mov    %eax,%ecx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8d 50 01             	lea    0x1(%eax),%edx
 2ae:	89 55 08             	mov    %edx,0x8(%ebp)
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	0f be c0             	movsbl %al,%eax
 2b7:	01 c8                	add    %ecx,%eax
 2b9:	83 e8 30             	sub    $0x30,%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2f                	cmp    $0x2f,%al
 2c7:	7e 0a                	jle    2d3 <atoi+0x4c>
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 39                	cmp    $0x39,%al
 2d1:	7e c7                	jle    29a <atoi+0x13>
  return n;
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d8:	f3 0f 1e fb          	endbr32 
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ee:	eb 17                	jmp    307 <memmove+0x2f>
    *dst++ = *src++;
 2f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f3:	8d 42 01             	lea    0x1(%edx),%eax
 2f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fc:	8d 48 01             	lea    0x1(%eax),%ecx
 2ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 302:	0f b6 12             	movzbl (%edx),%edx
 305:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 307:	8b 45 10             	mov    0x10(%ebp),%eax
 30a:	8d 50 ff             	lea    -0x1(%eax),%edx
 30d:	89 55 10             	mov    %edx,0x10(%ebp)
 310:	85 c0                	test   %eax,%eax
 312:	7f dc                	jg     2f0 <memmove+0x18>
  return vdst;
 314:	8b 45 08             	mov    0x8(%ebp),%eax
}
 317:	c9                   	leave  
 318:	c3                   	ret    

00000319 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 319:	b8 01 00 00 00       	mov    $0x1,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <exit>:
SYSCALL(exit)
 321:	b8 02 00 00 00       	mov    $0x2,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <wait>:
SYSCALL(wait)
 329:	b8 03 00 00 00       	mov    $0x3,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <pipe>:
SYSCALL(pipe)
 331:	b8 04 00 00 00       	mov    $0x4,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <read>:
SYSCALL(read)
 339:	b8 05 00 00 00       	mov    $0x5,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <write>:
SYSCALL(write)
 341:	b8 10 00 00 00       	mov    $0x10,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <close>:
SYSCALL(close)
 349:	b8 15 00 00 00       	mov    $0x15,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <kill>:
SYSCALL(kill)
 351:	b8 06 00 00 00       	mov    $0x6,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <exec>:
SYSCALL(exec)
 359:	b8 07 00 00 00       	mov    $0x7,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <open>:
SYSCALL(open)
 361:	b8 0f 00 00 00       	mov    $0xf,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mknod>:
SYSCALL(mknod)
 369:	b8 11 00 00 00       	mov    $0x11,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <unlink>:
SYSCALL(unlink)
 371:	b8 12 00 00 00       	mov    $0x12,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <fstat>:
SYSCALL(fstat)
 379:	b8 08 00 00 00       	mov    $0x8,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <link>:
SYSCALL(link)
 381:	b8 13 00 00 00       	mov    $0x13,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <mkdir>:
SYSCALL(mkdir)
 389:	b8 14 00 00 00       	mov    $0x14,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <chdir>:
SYSCALL(chdir)
 391:	b8 09 00 00 00       	mov    $0x9,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <dup>:
SYSCALL(dup)
 399:	b8 0a 00 00 00       	mov    $0xa,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <getpid>:
SYSCALL(getpid)
 3a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <sbrk>:
SYSCALL(sbrk)
 3a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <sleep>:
SYSCALL(sleep)
 3b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <uptime>:
SYSCALL(uptime)
 3b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <mencrypt>:
SYSCALL(mencrypt)
 3c1:	b8 16 00 00 00       	mov    $0x16,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <getpgtable>:
SYSCALL(getpgtable)
 3c9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <dump_rawphymem>:
SYSCALL(dump_rawphymem)
 3d1:	b8 18 00 00 00       	mov    $0x18,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d9:	f3 0f 1e fb          	endbr32 
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 18             	sub    $0x18,%esp
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e9:	83 ec 04             	sub    $0x4,%esp
 3ec:	6a 01                	push   $0x1
 3ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3f1:	50                   	push   %eax
 3f2:	ff 75 08             	pushl  0x8(%ebp)
 3f5:	e8 47 ff ff ff       	call   341 <write>
 3fa:	83 c4 10             	add    $0x10,%esp
}
 3fd:	90                   	nop
 3fe:	c9                   	leave  
 3ff:	c3                   	ret    

00000400 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 40a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 411:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 415:	74 17                	je     42e <printint+0x2e>
 417:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 41b:	79 11                	jns    42e <printint+0x2e>
    neg = 1;
 41d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 424:	8b 45 0c             	mov    0xc(%ebp),%eax
 427:	f7 d8                	neg    %eax
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42c:	eb 06                	jmp    434 <printint+0x34>
  } else {
    x = xx;
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 434:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 43b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 f1                	div    %ecx
 448:	89 d1                	mov    %edx,%ecx
 44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44d:	8d 50 01             	lea    0x1(%eax),%edx
 450:	89 55 f4             	mov    %edx,-0xc(%ebp)
 453:	0f b6 91 10 0b 00 00 	movzbl 0xb10(%ecx),%edx
 45a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 45e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 461:	8b 45 ec             	mov    -0x14(%ebp),%eax
 464:	ba 00 00 00 00       	mov    $0x0,%edx
 469:	f7 f1                	div    %ecx
 46b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 472:	75 c7                	jne    43b <printint+0x3b>
  if(neg)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	74 2d                	je     4a7 <printint+0xa7>
    buf[i++] = '-';
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 488:	eb 1d                	jmp    4a7 <printint+0xa7>
    putc(fd, buf[i]);
 48a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 490:	01 d0                	add    %edx,%eax
 492:	0f b6 00             	movzbl (%eax),%eax
 495:	0f be c0             	movsbl %al,%eax
 498:	83 ec 08             	sub    $0x8,%esp
 49b:	50                   	push   %eax
 49c:	ff 75 08             	pushl  0x8(%ebp)
 49f:	e8 35 ff ff ff       	call   3d9 <putc>
 4a4:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4a7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4af:	79 d9                	jns    48a <printint+0x8a>
}
 4b1:	90                   	nop
 4b2:	90                   	nop
 4b3:	c9                   	leave  
 4b4:	c3                   	ret    

000004b5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b5:	f3 0f 1e fb          	endbr32 
 4b9:	55                   	push   %ebp
 4ba:	89 e5                	mov    %esp,%ebp
 4bc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c9:	83 c0 04             	add    $0x4,%eax
 4cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d6:	e9 59 01 00 00       	jmp    634 <printf+0x17f>
    c = fmt[i] & 0xff;
 4db:	8b 55 0c             	mov    0xc(%ebp),%edx
 4de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e1:	01 d0                	add    %edx,%eax
 4e3:	0f b6 00             	movzbl (%eax),%eax
 4e6:	0f be c0             	movsbl %al,%eax
 4e9:	25 ff 00 00 00       	and    $0xff,%eax
 4ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f5:	75 2c                	jne    523 <printf+0x6e>
      if(c == '%'){
 4f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fb:	75 0c                	jne    509 <printf+0x54>
        state = '%';
 4fd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 504:	e9 27 01 00 00       	jmp    630 <printf+0x17b>
      } else {
        putc(fd, c);
 509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	50                   	push   %eax
 513:	ff 75 08             	pushl  0x8(%ebp)
 516:	e8 be fe ff ff       	call   3d9 <putc>
 51b:	83 c4 10             	add    $0x10,%esp
 51e:	e9 0d 01 00 00       	jmp    630 <printf+0x17b>
      }
    } else if(state == '%'){
 523:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 527:	0f 85 03 01 00 00    	jne    630 <printf+0x17b>
      if(c == 'd'){
 52d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 531:	75 1e                	jne    551 <printf+0x9c>
        printint(fd, *ap, 10, 1);
 533:	8b 45 e8             	mov    -0x18(%ebp),%eax
 536:	8b 00                	mov    (%eax),%eax
 538:	6a 01                	push   $0x1
 53a:	6a 0a                	push   $0xa
 53c:	50                   	push   %eax
 53d:	ff 75 08             	pushl  0x8(%ebp)
 540:	e8 bb fe ff ff       	call   400 <printint>
 545:	83 c4 10             	add    $0x10,%esp
        ap++;
 548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54c:	e9 d8 00 00 00       	jmp    629 <printf+0x174>
      } else if(c == 'x' || c == 'p'){
 551:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 555:	74 06                	je     55d <printf+0xa8>
 557:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55b:	75 1e                	jne    57b <printf+0xc6>
        printint(fd, *ap, 16, 0);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	6a 00                	push   $0x0
 564:	6a 10                	push   $0x10
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 91 fe ff ff       	call   400 <printint>
 56f:	83 c4 10             	add    $0x10,%esp
        ap++;
 572:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 576:	e9 ae 00 00 00       	jmp    629 <printf+0x174>
      } else if(c == 's'){
 57b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57f:	75 43                	jne    5c4 <printf+0x10f>
        s = (char*)*ap;
 581:	8b 45 e8             	mov    -0x18(%ebp),%eax
 584:	8b 00                	mov    (%eax),%eax
 586:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 591:	75 25                	jne    5b8 <printf+0x103>
          s = "(null)";
 593:	c7 45 f4 c4 08 00 00 	movl   $0x8c4,-0xc(%ebp)
        while(*s != 0){
 59a:	eb 1c                	jmp    5b8 <printf+0x103>
          putc(fd, *s);
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	0f b6 00             	movzbl (%eax),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	50                   	push   %eax
 5a9:	ff 75 08             	pushl  0x8(%ebp)
 5ac:	e8 28 fe ff ff       	call   3d9 <putc>
 5b1:	83 c4 10             	add    $0x10,%esp
          s++;
 5b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	84 c0                	test   %al,%al
 5c0:	75 da                	jne    59c <printf+0xe7>
 5c2:	eb 65                	jmp    629 <printf+0x174>
        }
      } else if(c == 'c'){
 5c4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c8:	75 1d                	jne    5e7 <printf+0x132>
        putc(fd, *ap);
 5ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	83 ec 08             	sub    $0x8,%esp
 5d5:	50                   	push   %eax
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 fb fd ff ff       	call   3d9 <putc>
 5de:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e5:	eb 42                	jmp    629 <printf+0x174>
      } else if(c == '%'){
 5e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5eb:	75 17                	jne    604 <printf+0x14f>
        putc(fd, c);
 5ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 da fd ff ff       	call   3d9 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
 602:	eb 25                	jmp    629 <printf+0x174>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 604:	83 ec 08             	sub    $0x8,%esp
 607:	6a 25                	push   $0x25
 609:	ff 75 08             	pushl  0x8(%ebp)
 60c:	e8 c8 fd ff ff       	call   3d9 <putc>
 611:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 b3 fd ff ff       	call   3d9 <putc>
 626:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 629:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 630:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 634:	8b 55 0c             	mov    0xc(%ebp),%edx
 637:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63a:	01 d0                	add    %edx,%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	84 c0                	test   %al,%al
 641:	0f 85 94 fe ff ff    	jne    4db <printf+0x26>
    }
  }
}
 647:	90                   	nop
 648:	90                   	nop
 649:	c9                   	leave  
 64a:	c3                   	ret    

0000064b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64b:	f3 0f 1e fb          	endbr32 
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	83 e8 08             	sub    $0x8,%eax
 65b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65e:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 663:	89 45 fc             	mov    %eax,-0x4(%ebp)
 666:	eb 24                	jmp    68c <free+0x41>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 670:	72 12                	jb     684 <free+0x39>
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 678:	77 24                	ja     69e <free+0x53>
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 682:	72 1a                	jb     69e <free+0x53>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 692:	76 d4                	jbe    668 <free+0x1d>
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 00                	mov    (%eax),%eax
 699:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69c:	73 ca                	jae    668 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	01 c2                	add    %eax,%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	39 c2                	cmp    %eax,%edx
 6b7:	75 24                	jne    6dd <free+0x92>
    bp->s.size += p->s.ptr->s.size;
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 50 04             	mov    0x4(%eax),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	8b 40 04             	mov    0x4(%eax),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	8b 10                	mov    (%eax),%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	89 10                	mov    %edx,(%eax)
 6db:	eb 0a                	jmp    6e7 <free+0x9c>
  } else
    bp->s.ptr = p->s.ptr;
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 10                	mov    (%eax),%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 40 04             	mov    0x4(%eax),%eax
 6ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6fc:	75 20                	jne    71e <free+0xd3>
    p->s.size += bp->s.size;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 50 04             	mov    0x4(%eax),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	01 c2                	add    %eax,%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
 71c:	eb 08                	jmp    726 <free+0xdb>
  } else
    p->s.ptr = bp;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 55 f8             	mov    -0x8(%ebp),%edx
 724:	89 10                	mov    %edx,(%eax)
  freep = p;
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	a3 2c 0b 00 00       	mov    %eax,0xb2c
}
 72e:	90                   	nop
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <morecore>:

static Header*
morecore(uint nu)
{
 731:	f3 0f 1e fb          	endbr32 
 735:	55                   	push   %ebp
 736:	89 e5                	mov    %esp,%ebp
 738:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 742:	77 07                	ja     74b <morecore+0x1a>
    nu = 4096;
 744:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	c1 e0 03             	shl    $0x3,%eax
 751:	83 ec 0c             	sub    $0xc,%esp
 754:	50                   	push   %eax
 755:	e8 4f fc ff ff       	call   3a9 <sbrk>
 75a:	83 c4 10             	add    $0x10,%esp
 75d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 760:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 764:	75 07                	jne    76d <morecore+0x3c>
    return 0;
 766:	b8 00 00 00 00       	mov    $0x0,%eax
 76b:	eb 26                	jmp    793 <morecore+0x62>
  hp = (Header*)p;
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 773:	8b 45 f0             	mov    -0x10(%ebp),%eax
 776:	8b 55 08             	mov    0x8(%ebp),%edx
 779:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77f:	83 c0 08             	add    $0x8,%eax
 782:	83 ec 0c             	sub    $0xc,%esp
 785:	50                   	push   %eax
 786:	e8 c0 fe ff ff       	call   64b <free>
 78b:	83 c4 10             	add    $0x10,%esp
  return freep;
 78e:	a1 2c 0b 00 00       	mov    0xb2c,%eax
}
 793:	c9                   	leave  
 794:	c3                   	ret    

00000795 <malloc>:

void*
malloc(uint nbytes)
{
 795:	f3 0f 1e fb          	endbr32 
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	83 c0 07             	add    $0x7,%eax
 7a5:	c1 e8 03             	shr    $0x3,%eax
 7a8:	83 c0 01             	add    $0x1,%eax
 7ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ae:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ba:	75 23                	jne    7df <malloc+0x4a>
    base.s.ptr = freep = prevp = &base;
 7bc:	c7 45 f0 24 0b 00 00 	movl   $0xb24,-0x10(%ebp)
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	a3 2c 0b 00 00       	mov    %eax,0xb2c
 7cb:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 7d0:	a3 24 0b 00 00       	mov    %eax,0xb24
    base.s.size = 0;
 7d5:	c7 05 28 0b 00 00 00 	movl   $0x0,0xb28
 7dc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f0:	77 4d                	ja     83f <malloc+0xaa>
      if(p->s.size == nunits)
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7fb:	75 0c                	jne    809 <malloc+0x74>
        prevp->s.ptr = p->s.ptr;
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 10                	mov    (%eax),%edx
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	89 10                	mov    %edx,(%eax)
 807:	eb 26                	jmp    82f <malloc+0x9a>
      else {
        p->s.size -= nunits;
 809:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 812:	89 c2                	mov    %eax,%edx
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 40 04             	mov    0x4(%eax),%eax
 820:	c1 e0 03             	shl    $0x3,%eax
 823:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 2c 0b 00 00       	mov    %eax,0xb2c
      return (void*)(p + 1);
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	83 c0 08             	add    $0x8,%eax
 83d:	eb 3b                	jmp    87a <malloc+0xe5>
    }
    if(p == freep)
 83f:	a1 2c 0b 00 00       	mov    0xb2c,%eax
 844:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 847:	75 1e                	jne    867 <malloc+0xd2>
      if((p = morecore(nunits)) == 0)
 849:	83 ec 0c             	sub    $0xc,%esp
 84c:	ff 75 ec             	pushl  -0x14(%ebp)
 84f:	e8 dd fe ff ff       	call   731 <morecore>
 854:	83 c4 10             	add    $0x10,%esp
 857:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85e:	75 07                	jne    867 <malloc+0xd2>
        return 0;
 860:	b8 00 00 00 00       	mov    $0x0,%eax
 865:	eb 13                	jmp    87a <malloc+0xe5>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 875:	e9 6d ff ff ff       	jmp    7e7 <malloc+0x52>
  }
}
 87a:	c9                   	leave  
 87b:	c3                   	ret    

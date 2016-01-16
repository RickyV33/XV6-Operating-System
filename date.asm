
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "date.h"

int
main(int argc, char * argv[]) 
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 40             	sub    $0x40,%esp
    struct rtcdate r;

    if (date(&r)) {
   c:	8d 44 24 28          	lea    0x28(%esp),%eax
  10:	89 04 24             	mov    %eax,(%esp)
  13:	e8 6e 03 00 00       	call   386 <date>
  18:	85 c0                	test   %eax,%eax
  1a:	74 19                	je     35 <main+0x35>
        printf(2, "date_failed");
  1c:	c7 44 24 04 3a 08 00 	movl   $0x83a,0x4(%esp)
  23:	00 
  24:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  2b:	e8 3e 04 00 00       	call   46e <printf>
        exit();
  30:	e8 b1 02 00 00       	call   2e6 <exit>
    }

    ///DO THINGS HERE
    printf(1, "%d/%d/%d %d:%d:%d\n", r.month, r.day, r.month,
  35:	8b 7c 24 28          	mov    0x28(%esp),%edi
  39:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  3d:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  41:	8b 4c 24 38          	mov    0x38(%esp),%ecx
  45:	8b 54 24 34          	mov    0x34(%esp),%edx
  49:	8b 44 24 38          	mov    0x38(%esp),%eax
  4d:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
  51:	89 74 24 18          	mov    %esi,0x18(%esp)
  55:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  59:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  61:	89 44 24 08          	mov    %eax,0x8(%esp)
  65:	c7 44 24 04 46 08 00 	movl   $0x846,0x4(%esp)
  6c:	00 
  6d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  74:	e8 f5 03 00 00       	call   46e <printf>
            r.hour, r.minute, r.second);

    exit();
  79:	e8 68 02 00 00       	call   2e6 <exit>

0000007e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	57                   	push   %edi
  82:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  86:	8b 55 10             	mov    0x10(%ebp),%edx
  89:	8b 45 0c             	mov    0xc(%ebp),%eax
  8c:	89 cb                	mov    %ecx,%ebx
  8e:	89 df                	mov    %ebx,%edi
  90:	89 d1                	mov    %edx,%ecx
  92:	fc                   	cld    
  93:	f3 aa                	rep stos %al,%es:(%edi)
  95:	89 ca                	mov    %ecx,%edx
  97:	89 fb                	mov    %edi,%ebx
  99:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9f:	5b                   	pop    %ebx
  a0:	5f                   	pop    %edi
  a1:	5d                   	pop    %ebp
  a2:	c3                   	ret    

000000a3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  af:	90                   	nop
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 50 01             	lea    0x1(%eax),%edx
  b6:	89 55 08             	mov    %edx,0x8(%ebp)
  b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c2:	0f b6 12             	movzbl (%edx),%edx
  c5:	88 10                	mov    %dl,(%eax)
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	84 c0                	test   %al,%al
  cc:	75 e2                	jne    b0 <strcpy+0xd>
    ;
  return os;
  ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d1:	c9                   	leave  
  d2:	c3                   	ret    

000000d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d6:	eb 08                	jmp    e0 <strcmp+0xd>
    p++, q++;
  d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	74 10                	je     fa <strcmp+0x27>
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 10             	movzbl (%eax),%edx
  f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	38 c2                	cmp    %al,%dl
  f8:	74 de                	je     d8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 d0             	movzbl %al,%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	0f b6 c0             	movzbl %al,%eax
 10c:	29 c2                	sub    %eax,%edx
 10e:	89 d0                	mov    %edx,%eax
}
 110:	5d                   	pop    %ebp
 111:	c3                   	ret    

00000112 <strlen>:

uint
strlen(char *s)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11f:	eb 04                	jmp    125 <strlen+0x13>
 121:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 125:	8b 55 fc             	mov    -0x4(%ebp),%edx
 128:	8b 45 08             	mov    0x8(%ebp),%eax
 12b:	01 d0                	add    %edx,%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	75 ed                	jne    121 <strlen+0xf>
    ;
  return n;
 134:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 137:	c9                   	leave  
 138:	c3                   	ret    

00000139 <memset>:

void*
memset(void *dst, int c, uint n)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 13f:	8b 45 10             	mov    0x10(%ebp),%eax
 142:	89 44 24 08          	mov    %eax,0x8(%esp)
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 44 24 04          	mov    %eax,0x4(%esp)
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	89 04 24             	mov    %eax,(%esp)
 153:	e8 26 ff ff ff       	call   7e <stosb>
  return dst;
 158:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <strchr>:

char*
strchr(const char *s, char c)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 04             	sub    $0x4,%esp
 163:	8b 45 0c             	mov    0xc(%ebp),%eax
 166:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 169:	eb 14                	jmp    17f <strchr+0x22>
    if(*s == c)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	3a 45 fc             	cmp    -0x4(%ebp),%al
 174:	75 05                	jne    17b <strchr+0x1e>
      return (char*)s;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	eb 13                	jmp    18e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	84 c0                	test   %al,%al
 187:	75 e2                	jne    16b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 189:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19d:	eb 4c                	jmp    1eb <gets+0x5b>
    cc = read(0, &c, 1);
 19f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a6:	00 
 1a7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b5:	e8 44 01 00 00       	call   2fe <read>
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7f 02                	jg     1c5 <gets+0x35>
      break;
 1c3:	eb 31                	jmp    1f6 <gets+0x66>
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	8d 50 01             	lea    0x1(%eax),%edx
 1cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 13                	je     1f6 <gets+0x66>
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0b                	je     1f6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f4:	7c a9                	jl     19f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 213:	00 
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	89 04 24             	mov    %eax,(%esp)
 21a:	e8 07 01 00 00       	call   326 <open>
 21f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 226:	79 07                	jns    22f <stat+0x29>
    return -1;
 228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22d:	eb 23                	jmp    252 <stat+0x4c>
  r = fstat(fd, st);
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	89 44 24 04          	mov    %eax,0x4(%esp)
 236:	8b 45 f4             	mov    -0xc(%ebp),%eax
 239:	89 04 24             	mov    %eax,(%esp)
 23c:	e8 fd 00 00 00       	call   33e <fstat>
 241:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 244:	8b 45 f4             	mov    -0xc(%ebp),%eax
 247:	89 04 24             	mov    %eax,(%esp)
 24a:	e8 bf 00 00 00       	call   30e <close>
  return r;
 24f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <atoi>:

int
atoi(const char *s)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 261:	eb 25                	jmp    288 <atoi+0x34>
    n = n*10 + *s++ - '0';
 263:	8b 55 fc             	mov    -0x4(%ebp),%edx
 266:	89 d0                	mov    %edx,%eax
 268:	c1 e0 02             	shl    $0x2,%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	01 c0                	add    %eax,%eax
 26f:	89 c1                	mov    %eax,%ecx
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	8d 50 01             	lea    0x1(%eax),%edx
 277:	89 55 08             	mov    %edx,0x8(%ebp)
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	0f be c0             	movsbl %al,%eax
 280:	01 c8                	add    %ecx,%eax
 282:	83 e8 30             	sub    $0x30,%eax
 285:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	3c 2f                	cmp    $0x2f,%al
 290:	7e 0a                	jle    29c <atoi+0x48>
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	3c 39                	cmp    $0x39,%al
 29a:	7e c7                	jle    263 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b3:	eb 17                	jmp    2cc <memmove+0x2b>
    *dst++ = *src++;
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b8:	8d 50 01             	lea    0x1(%eax),%edx
 2bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c1:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c7:	0f b6 12             	movzbl (%edx),%edx
 2ca:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cc:	8b 45 10             	mov    0x10(%ebp),%eax
 2cf:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d2:	89 55 10             	mov    %edx,0x10(%ebp)
 2d5:	85 c0                	test   %eax,%eax
 2d7:	7f dc                	jg     2b5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2de:	b8 01 00 00 00       	mov    $0x1,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <exit>:
SYSCALL(exit)
 2e6:	b8 02 00 00 00       	mov    $0x2,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <wait>:
SYSCALL(wait)
 2ee:	b8 03 00 00 00       	mov    $0x3,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <pipe>:
SYSCALL(pipe)
 2f6:	b8 04 00 00 00       	mov    $0x4,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <read>:
SYSCALL(read)
 2fe:	b8 05 00 00 00       	mov    $0x5,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <write>:
SYSCALL(write)
 306:	b8 10 00 00 00       	mov    $0x10,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <close>:
SYSCALL(close)
 30e:	b8 15 00 00 00       	mov    $0x15,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <kill>:
SYSCALL(kill)
 316:	b8 06 00 00 00       	mov    $0x6,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <exec>:
SYSCALL(exec)
 31e:	b8 07 00 00 00       	mov    $0x7,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <open>:
SYSCALL(open)
 326:	b8 0f 00 00 00       	mov    $0xf,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <mknod>:
SYSCALL(mknod)
 32e:	b8 11 00 00 00       	mov    $0x11,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <unlink>:
SYSCALL(unlink)
 336:	b8 12 00 00 00       	mov    $0x12,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <fstat>:
SYSCALL(fstat)
 33e:	b8 08 00 00 00       	mov    $0x8,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <link>:
SYSCALL(link)
 346:	b8 13 00 00 00       	mov    $0x13,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <mkdir>:
SYSCALL(mkdir)
 34e:	b8 14 00 00 00       	mov    $0x14,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <chdir>:
SYSCALL(chdir)
 356:	b8 09 00 00 00       	mov    $0x9,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <dup>:
SYSCALL(dup)
 35e:	b8 0a 00 00 00       	mov    $0xa,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <getpid>:
SYSCALL(getpid)
 366:	b8 0b 00 00 00       	mov    $0xb,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <sbrk>:
SYSCALL(sbrk)
 36e:	b8 0c 00 00 00       	mov    $0xc,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <sleep>:
SYSCALL(sleep)
 376:	b8 0d 00 00 00       	mov    $0xd,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <uptime>:
SYSCALL(uptime)
 37e:	b8 0e 00 00 00       	mov    $0xe,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <date>:
SYSCALL(date)
 386:	b8 16 00 00 00       	mov    $0x16,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 18             	sub    $0x18,%esp
 394:	8b 45 0c             	mov    0xc(%ebp),%eax
 397:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 39a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a1:	00 
 3a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	89 04 24             	mov    %eax,(%esp)
 3af:	e8 52 ff ff ff       	call   306 <write>
}
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	56                   	push   %esi
 3ba:	53                   	push   %ebx
 3bb:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c9:	74 17                	je     3e2 <printint+0x2c>
 3cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3cf:	79 11                	jns    3e2 <printint+0x2c>
    neg = 1;
 3d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	f7 d8                	neg    %eax
 3dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e0:	eb 06                	jmp    3e8 <printint+0x32>
  } else {
    x = xx;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f2:	8d 41 01             	lea    0x1(%ecx),%eax
 3f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fe:	ba 00 00 00 00       	mov    $0x0,%edx
 403:	f7 f3                	div    %ebx
 405:	89 d0                	mov    %edx,%eax
 407:	0f b6 80 a8 0a 00 00 	movzbl 0xaa8(%eax),%eax
 40e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 412:	8b 75 10             	mov    0x10(%ebp),%esi
 415:	8b 45 ec             	mov    -0x14(%ebp),%eax
 418:	ba 00 00 00 00       	mov    $0x0,%edx
 41d:	f7 f6                	div    %esi
 41f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 422:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 426:	75 c7                	jne    3ef <printint+0x39>
  if(neg)
 428:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42c:	74 10                	je     43e <printint+0x88>
    buf[i++] = '-';
 42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 431:	8d 50 01             	lea    0x1(%eax),%edx
 434:	89 55 f4             	mov    %edx,-0xc(%ebp)
 437:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 43c:	eb 1f                	jmp    45d <printint+0xa7>
 43e:	eb 1d                	jmp    45d <printint+0xa7>
    putc(fd, buf[i]);
 440:	8d 55 dc             	lea    -0x24(%ebp),%edx
 443:	8b 45 f4             	mov    -0xc(%ebp),%eax
 446:	01 d0                	add    %edx,%eax
 448:	0f b6 00             	movzbl (%eax),%eax
 44b:	0f be c0             	movsbl %al,%eax
 44e:	89 44 24 04          	mov    %eax,0x4(%esp)
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	89 04 24             	mov    %eax,(%esp)
 458:	e8 31 ff ff ff       	call   38e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 465:	79 d9                	jns    440 <printint+0x8a>
    putc(fd, buf[i]);
}
 467:	83 c4 30             	add    $0x30,%esp
 46a:	5b                   	pop    %ebx
 46b:	5e                   	pop    %esi
 46c:	5d                   	pop    %ebp
 46d:	c3                   	ret    

0000046e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47b:	8d 45 0c             	lea    0xc(%ebp),%eax
 47e:	83 c0 04             	add    $0x4,%eax
 481:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48b:	e9 7c 01 00 00       	jmp    60c <printf+0x19e>
    c = fmt[i] & 0xff;
 490:	8b 55 0c             	mov    0xc(%ebp),%edx
 493:	8b 45 f0             	mov    -0x10(%ebp),%eax
 496:	01 d0                	add    %edx,%eax
 498:	0f b6 00             	movzbl (%eax),%eax
 49b:	0f be c0             	movsbl %al,%eax
 49e:	25 ff 00 00 00       	and    $0xff,%eax
 4a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4aa:	75 2c                	jne    4d8 <printf+0x6a>
      if(c == '%'){
 4ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b0:	75 0c                	jne    4be <printf+0x50>
        state = '%';
 4b2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b9:	e9 4a 01 00 00       	jmp    608 <printf+0x19a>
      } else {
        putc(fd, c);
 4be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c1:	0f be c0             	movsbl %al,%eax
 4c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	89 04 24             	mov    %eax,(%esp)
 4ce:	e8 bb fe ff ff       	call   38e <putc>
 4d3:	e9 30 01 00 00       	jmp    608 <printf+0x19a>
      }
    } else if(state == '%'){
 4d8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4dc:	0f 85 26 01 00 00    	jne    608 <printf+0x19a>
      if(c == 'd'){
 4e2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e6:	75 2d                	jne    515 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f4:	00 
 4f5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fc:	00 
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 aa fe ff ff       	call   3b6 <printint>
        ap++;
 50c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 510:	e9 ec 00 00 00       	jmp    601 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 515:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 519:	74 06                	je     521 <printf+0xb3>
 51b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51f:	75 2d                	jne    54e <printf+0xe0>
        printint(fd, *ap, 16, 0);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52d:	00 
 52e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 535:	00 
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 71 fe ff ff       	call   3b6 <printint>
        ap++;
 545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 549:	e9 b3 00 00 00       	jmp    601 <printf+0x193>
      } else if(c == 's'){
 54e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 552:	75 45                	jne    599 <printf+0x12b>
        s = (char*)*ap;
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 564:	75 09                	jne    56f <printf+0x101>
          s = "(null)";
 566:	c7 45 f4 59 08 00 00 	movl   $0x859,-0xc(%ebp)
        while(*s != 0){
 56d:	eb 1e                	jmp    58d <printf+0x11f>
 56f:	eb 1c                	jmp    58d <printf+0x11f>
          putc(fd, *s);
 571:	8b 45 f4             	mov    -0xc(%ebp),%eax
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	0f be c0             	movsbl %al,%eax
 57a:	89 44 24 04          	mov    %eax,0x4(%esp)
 57e:	8b 45 08             	mov    0x8(%ebp),%eax
 581:	89 04 24             	mov    %eax,(%esp)
 584:	e8 05 fe ff ff       	call   38e <putc>
          s++;
 589:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 590:	0f b6 00             	movzbl (%eax),%eax
 593:	84 c0                	test   %al,%al
 595:	75 da                	jne    571 <printf+0x103>
 597:	eb 68                	jmp    601 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 599:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59d:	75 1d                	jne    5bc <printf+0x14e>
        putc(fd, *ap);
 59f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 d8 fd ff ff       	call   38e <putc>
        ap++;
 5b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ba:	eb 45                	jmp    601 <printf+0x193>
      } else if(c == '%'){
 5bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c0:	75 17                	jne    5d9 <printf+0x16b>
        putc(fd, c);
 5c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 b7 fd ff ff       	call   38e <putc>
 5d7:	eb 28                	jmp    601 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e0:	00 
 5e1:	8b 45 08             	mov    0x8(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 a2 fd ff ff       	call   38e <putc>
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 8d fd ff ff       	call   38e <putc>
      }
      state = 0;
 601:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 608:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60c:	8b 55 0c             	mov    0xc(%ebp),%edx
 60f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 612:	01 d0                	add    %edx,%eax
 614:	0f b6 00             	movzbl (%eax),%eax
 617:	84 c0                	test   %al,%al
 619:	0f 85 71 fe ff ff    	jne    490 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61f:	c9                   	leave  
 620:	c3                   	ret    

00000621 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 621:	55                   	push   %ebp
 622:	89 e5                	mov    %esp,%ebp
 624:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	83 e8 08             	sub    $0x8,%eax
 62d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	a1 c4 0a 00 00       	mov    0xac4,%eax
 635:	89 45 fc             	mov    %eax,-0x4(%ebp)
 638:	eb 24                	jmp    65e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 12                	ja     656 <free+0x35>
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64a:	77 24                	ja     670 <free+0x4f>
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 654:	77 1a                	ja     670 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 664:	76 d4                	jbe    63a <free+0x19>
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66e:	76 ca                	jbe    63a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	01 c2                	add    %eax,%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	39 c2                	cmp    %eax,%edx
 689:	75 24                	jne    6af <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	8b 40 04             	mov    0x4(%eax),%eax
 699:	01 c2                	add    %eax,%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 0a                	jmp    6b9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	01 d0                	add    %edx,%eax
 6cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ce:	75 20                	jne    6f0 <free+0xcf>
    p->s.size += bp->s.size;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 10                	mov    (%eax),%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 10                	mov    %edx,(%eax)
 6ee:	eb 08                	jmp    6f8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	a3 c4 0a 00 00       	mov    %eax,0xac4
}
 700:	c9                   	leave  
 701:	c3                   	ret    

00000702 <morecore>:

static Header*
morecore(uint nu)
{
 702:	55                   	push   %ebp
 703:	89 e5                	mov    %esp,%ebp
 705:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 708:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70f:	77 07                	ja     718 <morecore+0x16>
    nu = 4096;
 711:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	c1 e0 03             	shl    $0x3,%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 48 fc ff ff       	call   36e <sbrk>
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 729:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72d:	75 07                	jne    736 <morecore+0x34>
    return 0;
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	eb 22                	jmp    758 <morecore+0x56>
  hp = (Header*)p;
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	8b 55 08             	mov    0x8(%ebp),%edx
 742:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	83 c0 08             	add    $0x8,%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 ce fe ff ff       	call   621 <free>
  return freep;
 753:	a1 c4 0a 00 00       	mov    0xac4,%eax
}
 758:	c9                   	leave  
 759:	c3                   	ret    

0000075a <malloc>:

void*
malloc(uint nbytes)
{
 75a:	55                   	push   %ebp
 75b:	89 e5                	mov    %esp,%ebp
 75d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 760:	8b 45 08             	mov    0x8(%ebp),%eax
 763:	83 c0 07             	add    $0x7,%eax
 766:	c1 e8 03             	shr    $0x3,%eax
 769:	83 c0 01             	add    $0x1,%eax
 76c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76f:	a1 c4 0a 00 00       	mov    0xac4,%eax
 774:	89 45 f0             	mov    %eax,-0x10(%ebp)
 777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77b:	75 23                	jne    7a0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77d:	c7 45 f0 bc 0a 00 00 	movl   $0xabc,-0x10(%ebp)
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	a3 c4 0a 00 00       	mov    %eax,0xac4
 78c:	a1 c4 0a 00 00       	mov    0xac4,%eax
 791:	a3 bc 0a 00 00       	mov    %eax,0xabc
    base.s.size = 0;
 796:	c7 05 c0 0a 00 00 00 	movl   $0x0,0xac0
 79d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b1:	72 4d                	jb     800 <malloc+0xa6>
      if(p->s.size == nunits)
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bc:	75 0c                	jne    7ca <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	89 10                	mov    %edx,(%eax)
 7c8:	eb 26                	jmp    7f0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d3:	89 c2                	mov    %eax,%edx
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	c1 e0 03             	shl    $0x3,%eax
 7e4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	a3 c4 0a 00 00       	mov    %eax,0xac4
      return (void*)(p + 1);
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	83 c0 08             	add    $0x8,%eax
 7fe:	eb 38                	jmp    838 <malloc+0xde>
    }
    if(p == freep)
 800:	a1 c4 0a 00 00       	mov    0xac4,%eax
 805:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 808:	75 1b                	jne    825 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 80a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80d:	89 04 24             	mov    %eax,(%esp)
 810:	e8 ed fe ff ff       	call   702 <morecore>
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
 818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81c:	75 07                	jne    825 <malloc+0xcb>
        return 0;
 81e:	b8 00 00 00 00       	mov    $0x0,%eax
 823:	eb 13                	jmp    838 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 833:	e9 70 ff ff ff       	jmp    7a8 <malloc+0x4e>
}
 838:	c9                   	leave  
 839:	c3                   	ret    

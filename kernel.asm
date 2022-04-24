
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 e6 10 80       	mov    $0x8010e650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 3f 3b 10 80       	mov    $0x80103b3f,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	f3 0f 1e fb          	endbr32 
80100038:	55                   	push   %ebp
80100039:	89 e5                	mov    %esp,%ebp
8010003b:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003e:	83 ec 08             	sub    $0x8,%esp
80100041:	68 58 95 10 80       	push   $0x80109558
80100046:	68 60 e6 10 80       	push   $0x8010e660
8010004b:	e8 f3 54 00 00       	call   80105543 <initlock>
80100050:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100053:	c7 05 ac 2d 11 80 5c 	movl   $0x80112d5c,0x80112dac
8010005a:	2d 11 80 
  bcache.head.next = &bcache.head;
8010005d:	c7 05 b0 2d 11 80 5c 	movl   $0x80112d5c,0x80112db0
80100064:	2d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100067:	c7 45 f4 94 e6 10 80 	movl   $0x8010e694,-0xc(%ebp)
8010006e:	eb 47                	jmp    801000b7 <binit+0x83>
    b->next = bcache.head.next;
80100070:	8b 15 b0 2d 11 80    	mov    0x80112db0,%edx
80100076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100079:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
8010007c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007f:	c7 40 50 5c 2d 11 80 	movl   $0x80112d5c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100089:	83 c0 0c             	add    $0xc,%eax
8010008c:	83 ec 08             	sub    $0x8,%esp
8010008f:	68 5f 95 10 80       	push   $0x8010955f
80100094:	50                   	push   %eax
80100095:	e8 16 53 00 00       	call   801053b0 <initsleeplock>
8010009a:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
8010009d:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
801000a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801000a5:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ab:	a3 b0 2d 11 80       	mov    %eax,0x80112db0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b0:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b7:	b8 5c 2d 11 80       	mov    $0x80112d5c,%eax
801000bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000bf:	72 af                	jb     80100070 <binit+0x3c>
  }
}
801000c1:	90                   	nop
801000c2:	90                   	nop
801000c3:	c9                   	leave  
801000c4:	c3                   	ret    

801000c5 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000c5:	f3 0f 1e fb          	endbr32 
801000c9:	55                   	push   %ebp
801000ca:	89 e5                	mov    %esp,%ebp
801000cc:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000cf:	83 ec 0c             	sub    $0xc,%esp
801000d2:	68 60 e6 10 80       	push   $0x8010e660
801000d7:	e8 8d 54 00 00       	call   80105569 <acquire>
801000dc:	83 c4 10             	add    $0x10,%esp

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000df:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
801000e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000e7:	eb 58                	jmp    80100141 <bget+0x7c>
    if(b->dev == dev && b->blockno == blockno){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 40 04             	mov    0x4(%eax),%eax
801000ef:	39 45 08             	cmp    %eax,0x8(%ebp)
801000f2:	75 44                	jne    80100138 <bget+0x73>
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 40 08             	mov    0x8(%eax),%eax
801000fa:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000fd:	75 39                	jne    80100138 <bget+0x73>
      b->refcnt++;
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	8b 40 4c             	mov    0x4c(%eax),%eax
80100105:	8d 50 01             	lea    0x1(%eax),%edx
80100108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010b:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
8010010e:	83 ec 0c             	sub    $0xc,%esp
80100111:	68 60 e6 10 80       	push   $0x8010e660
80100116:	e8 c0 54 00 00       	call   801055db <release>
8010011b:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010011e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100121:	83 c0 0c             	add    $0xc,%eax
80100124:	83 ec 0c             	sub    $0xc,%esp
80100127:	50                   	push   %eax
80100128:	e8 c3 52 00 00       	call   801053f0 <acquiresleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      return b;
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	e9 9d 00 00 00       	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013b:	8b 40 54             	mov    0x54(%eax),%eax
8010013e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100141:	81 7d f4 5c 2d 11 80 	cmpl   $0x80112d5c,-0xc(%ebp)
80100148:	75 9f                	jne    801000e9 <bget+0x24>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010014a:	a1 ac 2d 11 80       	mov    0x80112dac,%eax
8010014f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100152:	eb 6b                	jmp    801001bf <bget+0xfa>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100157:	8b 40 4c             	mov    0x4c(%eax),%eax
8010015a:	85 c0                	test   %eax,%eax
8010015c:	75 58                	jne    801001b6 <bget+0xf1>
8010015e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100161:	8b 00                	mov    (%eax),%eax
80100163:	83 e0 04             	and    $0x4,%eax
80100166:	85 c0                	test   %eax,%eax
80100168:	75 4c                	jne    801001b6 <bget+0xf1>
      b->dev = dev;
8010016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016d:	8b 55 08             	mov    0x8(%ebp),%edx
80100170:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
80100173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100176:	8b 55 0c             	mov    0xc(%ebp),%edx
80100179:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
8010017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
80100185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100188:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
8010018f:	83 ec 0c             	sub    $0xc,%esp
80100192:	68 60 e6 10 80       	push   $0x8010e660
80100197:	e8 3f 54 00 00       	call   801055db <release>
8010019c:	83 c4 10             	add    $0x10,%esp
      acquiresleep(&b->lock);
8010019f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001a2:	83 c0 0c             	add    $0xc,%eax
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	50                   	push   %eax
801001a9:	e8 42 52 00 00       	call   801053f0 <acquiresleep>
801001ae:	83 c4 10             	add    $0x10,%esp
      return b;
801001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b4:	eb 1f                	jmp    801001d5 <bget+0x110>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801001b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001b9:	8b 40 50             	mov    0x50(%eax),%eax
801001bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801001bf:	81 7d f4 5c 2d 11 80 	cmpl   $0x80112d5c,-0xc(%ebp)
801001c6:	75 8c                	jne    80100154 <bget+0x8f>
    }
  }
  panic("bget: no buffers");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 66 95 10 80       	push   $0x80109566
801001d0:	e8 33 04 00 00       	call   80100608 <panic>
}
801001d5:	c9                   	leave  
801001d6:	c3                   	ret    

801001d7 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001d7:	f3 0f 1e fb          	endbr32 
801001db:	55                   	push   %ebp
801001dc:	89 e5                	mov    %esp,%ebp
801001de:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001e1:	83 ec 08             	sub    $0x8,%esp
801001e4:	ff 75 0c             	pushl  0xc(%ebp)
801001e7:	ff 75 08             	pushl  0x8(%ebp)
801001ea:	e8 d6 fe ff ff       	call   801000c5 <bget>
801001ef:	83 c4 10             	add    $0x10,%esp
801001f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 02             	and    $0x2,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0e                	jne    8010020f <bread+0x38>
    iderw(b);
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	ff 75 f4             	pushl  -0xc(%ebp)
80100207:	e8 92 29 00 00       	call   80102b9e <iderw>
8010020c:	83 c4 10             	add    $0x10,%esp
  }
  return b;
8010020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80100212:	c9                   	leave  
80100213:	c3                   	ret    

80100214 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100214:	f3 0f 1e fb          	endbr32 
80100218:	55                   	push   %ebp
80100219:	89 e5                	mov    %esp,%ebp
8010021b:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010021e:	8b 45 08             	mov    0x8(%ebp),%eax
80100221:	83 c0 0c             	add    $0xc,%eax
80100224:	83 ec 0c             	sub    $0xc,%esp
80100227:	50                   	push   %eax
80100228:	e8 7d 52 00 00       	call   801054aa <holdingsleep>
8010022d:	83 c4 10             	add    $0x10,%esp
80100230:	85 c0                	test   %eax,%eax
80100232:	75 0d                	jne    80100241 <bwrite+0x2d>
    panic("bwrite");
80100234:	83 ec 0c             	sub    $0xc,%esp
80100237:	68 77 95 10 80       	push   $0x80109577
8010023c:	e8 c7 03 00 00       	call   80100608 <panic>
  b->flags |= B_DIRTY;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 00                	mov    (%eax),%eax
80100246:	83 c8 04             	or     $0x4,%eax
80100249:	89 c2                	mov    %eax,%edx
8010024b:	8b 45 08             	mov    0x8(%ebp),%eax
8010024e:	89 10                	mov    %edx,(%eax)
  iderw(b);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	ff 75 08             	pushl  0x8(%ebp)
80100256:	e8 43 29 00 00       	call   80102b9e <iderw>
8010025b:	83 c4 10             	add    $0x10,%esp
}
8010025e:	90                   	nop
8010025f:	c9                   	leave  
80100260:	c3                   	ret    

80100261 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100261:	f3 0f 1e fb          	endbr32 
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	83 ec 08             	sub    $0x8,%esp
  if(!holdingsleep(&b->lock))
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	83 c0 0c             	add    $0xc,%eax
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	50                   	push   %eax
80100275:	e8 30 52 00 00       	call   801054aa <holdingsleep>
8010027a:	83 c4 10             	add    $0x10,%esp
8010027d:	85 c0                	test   %eax,%eax
8010027f:	75 0d                	jne    8010028e <brelse+0x2d>
    panic("brelse");
80100281:	83 ec 0c             	sub    $0xc,%esp
80100284:	68 7e 95 10 80       	push   $0x8010957e
80100289:	e8 7a 03 00 00       	call   80100608 <panic>

  releasesleep(&b->lock);
8010028e:	8b 45 08             	mov    0x8(%ebp),%eax
80100291:	83 c0 0c             	add    $0xc,%eax
80100294:	83 ec 0c             	sub    $0xc,%esp
80100297:	50                   	push   %eax
80100298:	e8 bb 51 00 00       	call   80105458 <releasesleep>
8010029d:	83 c4 10             	add    $0x10,%esp

  acquire(&bcache.lock);
801002a0:	83 ec 0c             	sub    $0xc,%esp
801002a3:	68 60 e6 10 80       	push   $0x8010e660
801002a8:	e8 bc 52 00 00       	call   80105569 <acquire>
801002ad:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801002b0:	8b 45 08             	mov    0x8(%ebp),%eax
801002b3:	8b 40 4c             	mov    0x4c(%eax),%eax
801002b6:	8d 50 ff             	lea    -0x1(%eax),%edx
801002b9:	8b 45 08             	mov    0x8(%ebp),%eax
801002bc:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
801002bf:	8b 45 08             	mov    0x8(%ebp),%eax
801002c2:	8b 40 4c             	mov    0x4c(%eax),%eax
801002c5:	85 c0                	test   %eax,%eax
801002c7:	75 47                	jne    80100310 <brelse+0xaf>
    // no one is waiting for it.
    b->next->prev = b->prev;
801002c9:	8b 45 08             	mov    0x8(%ebp),%eax
801002cc:	8b 40 54             	mov    0x54(%eax),%eax
801002cf:	8b 55 08             	mov    0x8(%ebp),%edx
801002d2:	8b 52 50             	mov    0x50(%edx),%edx
801002d5:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801002d8:	8b 45 08             	mov    0x8(%ebp),%eax
801002db:	8b 40 50             	mov    0x50(%eax),%eax
801002de:	8b 55 08             	mov    0x8(%ebp),%edx
801002e1:	8b 52 54             	mov    0x54(%edx),%edx
801002e4:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002e7:	8b 15 b0 2d 11 80    	mov    0x80112db0,%edx
801002ed:	8b 45 08             	mov    0x8(%ebp),%eax
801002f0:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002f3:	8b 45 08             	mov    0x8(%ebp),%eax
801002f6:	c7 40 50 5c 2d 11 80 	movl   $0x80112d5c,0x50(%eax)
    bcache.head.next->prev = b;
801002fd:	a1 b0 2d 11 80       	mov    0x80112db0,%eax
80100302:	8b 55 08             	mov    0x8(%ebp),%edx
80100305:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
80100308:	8b 45 08             	mov    0x8(%ebp),%eax
8010030b:	a3 b0 2d 11 80       	mov    %eax,0x80112db0
  }
  
  release(&bcache.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 60 e6 10 80       	push   $0x8010e660
80100318:	e8 be 52 00 00       	call   801055db <release>
8010031d:	83 c4 10             	add    $0x10,%esp
}
80100320:	90                   	nop
80100321:	c9                   	leave  
80100322:	c3                   	ret    

80100323 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80100323:	55                   	push   %ebp
80100324:	89 e5                	mov    %esp,%ebp
80100326:	83 ec 14             	sub    $0x14,%esp
80100329:	8b 45 08             	mov    0x8(%ebp),%eax
8010032c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100330:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80100334:	89 c2                	mov    %eax,%edx
80100336:	ec                   	in     (%dx),%al
80100337:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010033a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010033e:	c9                   	leave  
8010033f:	c3                   	ret    

80100340 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80100340:	55                   	push   %ebp
80100341:	89 e5                	mov    %esp,%ebp
80100343:	83 ec 08             	sub    $0x8,%esp
80100346:	8b 45 08             	mov    0x8(%ebp),%eax
80100349:	8b 55 0c             	mov    0xc(%ebp),%edx
8010034c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100350:	89 d0                	mov    %edx,%eax
80100352:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100355:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100359:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010035d:	ee                   	out    %al,(%dx)
}
8010035e:	90                   	nop
8010035f:	c9                   	leave  
80100360:	c3                   	ret    

80100361 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100361:	55                   	push   %ebp
80100362:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100364:	fa                   	cli    
}
80100365:	90                   	nop
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    

80100368 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100368:	f3 0f 1e fb          	endbr32 
8010036c:	55                   	push   %ebp
8010036d:	89 e5                	mov    %esp,%ebp
8010036f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100372:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100376:	74 1c                	je     80100394 <printint+0x2c>
80100378:	8b 45 08             	mov    0x8(%ebp),%eax
8010037b:	c1 e8 1f             	shr    $0x1f,%eax
8010037e:	0f b6 c0             	movzbl %al,%eax
80100381:	89 45 10             	mov    %eax,0x10(%ebp)
80100384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100388:	74 0a                	je     80100394 <printint+0x2c>
    x = -xx;
8010038a:	8b 45 08             	mov    0x8(%ebp),%eax
8010038d:	f7 d8                	neg    %eax
8010038f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100392:	eb 06                	jmp    8010039a <printint+0x32>
  else
    x = xx;
80100394:	8b 45 08             	mov    0x8(%ebp),%eax
80100397:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
8010039a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
801003a1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003a7:	ba 00 00 00 00       	mov    $0x0,%edx
801003ac:	f7 f1                	div    %ecx
801003ae:	89 d1                	mov    %edx,%ecx
801003b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003b3:	8d 50 01             	lea    0x1(%eax),%edx
801003b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003b9:	0f b6 91 04 b0 10 80 	movzbl -0x7fef4ffc(%ecx),%edx
801003c0:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
801003c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801003c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801003ca:	ba 00 00 00 00       	mov    $0x0,%edx
801003cf:	f7 f1                	div    %ecx
801003d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801003d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801003d8:	75 c7                	jne    801003a1 <printint+0x39>

  if(sign)
801003da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801003de:	74 2a                	je     8010040a <printint+0xa2>
    buf[i++] = '-';
801003e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003e3:	8d 50 01             	lea    0x1(%eax),%edx
801003e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
801003e9:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
801003ee:	eb 1a                	jmp    8010040a <printint+0xa2>
    consputc(buf[i]);
801003f0:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003f6:	01 d0                	add    %edx,%eax
801003f8:	0f b6 00             	movzbl (%eax),%eax
801003fb:	0f be c0             	movsbl %al,%eax
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	50                   	push   %eax
80100402:	e8 36 04 00 00       	call   8010083d <consputc>
80100407:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
8010040a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010040e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100412:	79 dc                	jns    801003f0 <printint+0x88>
}
80100414:	90                   	nop
80100415:	90                   	nop
80100416:	c9                   	leave  
80100417:	c3                   	ret    

80100418 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100418:	f3 0f 1e fb          	endbr32 
8010041c:	55                   	push   %ebp
8010041d:	89 e5                	mov    %esp,%ebp
8010041f:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100422:	a1 f4 d5 10 80       	mov    0x8010d5f4,%eax
80100427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //changed: added holding check
  if(locking && !holding(&cons.lock))
8010042a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010042e:	74 24                	je     80100454 <cprintf+0x3c>
80100430:	83 ec 0c             	sub    $0xc,%esp
80100433:	68 c0 d5 10 80       	push   $0x8010d5c0
80100438:	e8 73 52 00 00       	call   801056b0 <holding>
8010043d:	83 c4 10             	add    $0x10,%esp
80100440:	85 c0                	test   %eax,%eax
80100442:	75 10                	jne    80100454 <cprintf+0x3c>
    acquire(&cons.lock);
80100444:	83 ec 0c             	sub    $0xc,%esp
80100447:	68 c0 d5 10 80       	push   $0x8010d5c0
8010044c:	e8 18 51 00 00       	call   80105569 <acquire>
80100451:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
80100454:	8b 45 08             	mov    0x8(%ebp),%eax
80100457:	85 c0                	test   %eax,%eax
80100459:	75 0d                	jne    80100468 <cprintf+0x50>
    panic("null fmt");
8010045b:	83 ec 0c             	sub    $0xc,%esp
8010045e:	68 88 95 10 80       	push   $0x80109588
80100463:	e8 a0 01 00 00       	call   80100608 <panic>

  argp = (uint*)(void*)(&fmt + 1);
80100468:	8d 45 0c             	lea    0xc(%ebp),%eax
8010046b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010046e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100475:	e9 52 01 00 00       	jmp    801005cc <cprintf+0x1b4>
    if(c != '%'){
8010047a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010047e:	74 13                	je     80100493 <cprintf+0x7b>
      consputc(c);
80100480:	83 ec 0c             	sub    $0xc,%esp
80100483:	ff 75 e4             	pushl  -0x1c(%ebp)
80100486:	e8 b2 03 00 00       	call   8010083d <consputc>
8010048b:	83 c4 10             	add    $0x10,%esp
      continue;
8010048e:	e9 35 01 00 00       	jmp    801005c8 <cprintf+0x1b0>
    }
    c = fmt[++i] & 0xff;
80100493:	8b 55 08             	mov    0x8(%ebp),%edx
80100496:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010049a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010049d:	01 d0                	add    %edx,%eax
8010049f:	0f b6 00             	movzbl (%eax),%eax
801004a2:	0f be c0             	movsbl %al,%eax
801004a5:	25 ff 00 00 00       	and    $0xff,%eax
801004aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
801004ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801004b1:	0f 84 37 01 00 00    	je     801005ee <cprintf+0x1d6>
      break;
    switch(c){
801004b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004bb:	0f 84 dc 00 00 00    	je     8010059d <cprintf+0x185>
801004c1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801004c5:	0f 8c e1 00 00 00    	jl     801005ac <cprintf+0x194>
801004cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
801004cf:	0f 8f d7 00 00 00    	jg     801005ac <cprintf+0x194>
801004d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
801004d9:	0f 8c cd 00 00 00    	jl     801005ac <cprintf+0x194>
801004df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004e2:	83 e8 63             	sub    $0x63,%eax
801004e5:	83 f8 15             	cmp    $0x15,%eax
801004e8:	0f 87 be 00 00 00    	ja     801005ac <cprintf+0x194>
801004ee:	8b 04 85 98 95 10 80 	mov    -0x7fef6a68(,%eax,4),%eax
801004f5:	3e ff e0             	notrack jmp *%eax
    case 'd':
      printint(*argp++, 10, 1);
801004f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004fb:	8d 50 04             	lea    0x4(%eax),%edx
801004fe:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100501:	8b 00                	mov    (%eax),%eax
80100503:	83 ec 04             	sub    $0x4,%esp
80100506:	6a 01                	push   $0x1
80100508:	6a 0a                	push   $0xa
8010050a:	50                   	push   %eax
8010050b:	e8 58 fe ff ff       	call   80100368 <printint>
80100510:	83 c4 10             	add    $0x10,%esp
      break;
80100513:	e9 b0 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100518:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010051b:	8d 50 04             	lea    0x4(%eax),%edx
8010051e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100521:	8b 00                	mov    (%eax),%eax
80100523:	83 ec 04             	sub    $0x4,%esp
80100526:	6a 00                	push   $0x0
80100528:	6a 10                	push   $0x10
8010052a:	50                   	push   %eax
8010052b:	e8 38 fe ff ff       	call   80100368 <printint>
80100530:	83 c4 10             	add    $0x10,%esp
      break;
80100533:	e9 90 00 00 00       	jmp    801005c8 <cprintf+0x1b0>
    case 's':
      if((s = (char*)*argp++) == 0)
80100538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010053b:	8d 50 04             	lea    0x4(%eax),%edx
8010053e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100541:	8b 00                	mov    (%eax),%eax
80100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010054a:	75 22                	jne    8010056e <cprintf+0x156>
        s = "(null)";
8010054c:	c7 45 ec 91 95 10 80 	movl   $0x80109591,-0x14(%ebp)
      for(; *s; s++)
80100553:	eb 19                	jmp    8010056e <cprintf+0x156>
        consputc(*s);
80100555:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f be c0             	movsbl %al,%eax
8010055e:	83 ec 0c             	sub    $0xc,%esp
80100561:	50                   	push   %eax
80100562:	e8 d6 02 00 00       	call   8010083d <consputc>
80100567:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
8010056a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010056e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100571:	0f b6 00             	movzbl (%eax),%eax
80100574:	84 c0                	test   %al,%al
80100576:	75 dd                	jne    80100555 <cprintf+0x13d>
      break;
80100578:	eb 4e                	jmp    801005c8 <cprintf+0x1b0>
    case 'c':
      s = (char*)argp++;
8010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010057d:	8d 50 04             	lea    0x4(%eax),%edx
80100580:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100583:	89 45 ec             	mov    %eax,-0x14(%ebp)
      consputc(*(s));
80100586:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100589:	0f b6 00             	movzbl (%eax),%eax
8010058c:	0f be c0             	movsbl %al,%eax
8010058f:	83 ec 0c             	sub    $0xc,%esp
80100592:	50                   	push   %eax
80100593:	e8 a5 02 00 00       	call   8010083d <consputc>
80100598:	83 c4 10             	add    $0x10,%esp
      break;
8010059b:	eb 2b                	jmp    801005c8 <cprintf+0x1b0>
    case '%':
      consputc('%');
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	6a 25                	push   $0x25
801005a2:	e8 96 02 00 00       	call   8010083d <consputc>
801005a7:	83 c4 10             	add    $0x10,%esp
      break;
801005aa:	eb 1c                	jmp    801005c8 <cprintf+0x1b0>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801005ac:	83 ec 0c             	sub    $0xc,%esp
801005af:	6a 25                	push   $0x25
801005b1:	e8 87 02 00 00       	call   8010083d <consputc>
801005b6:	83 c4 10             	add    $0x10,%esp
      consputc(c);
801005b9:	83 ec 0c             	sub    $0xc,%esp
801005bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801005bf:	e8 79 02 00 00       	call   8010083d <consputc>
801005c4:	83 c4 10             	add    $0x10,%esp
      break;
801005c7:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005cc:	8b 55 08             	mov    0x8(%ebp),%edx
801005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d2:	01 d0                	add    %edx,%eax
801005d4:	0f b6 00             	movzbl (%eax),%eax
801005d7:	0f be c0             	movsbl %al,%eax
801005da:	25 ff 00 00 00       	and    $0xff,%eax
801005df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801005e6:	0f 85 8e fe ff ff    	jne    8010047a <cprintf+0x62>
801005ec:	eb 01                	jmp    801005ef <cprintf+0x1d7>
      break;
801005ee:	90                   	nop
    }
  }

  if(locking)
801005ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801005f3:	74 10                	je     80100605 <cprintf+0x1ed>
    release(&cons.lock);
801005f5:	83 ec 0c             	sub    $0xc,%esp
801005f8:	68 c0 d5 10 80       	push   $0x8010d5c0
801005fd:	e8 d9 4f 00 00       	call   801055db <release>
80100602:	83 c4 10             	add    $0x10,%esp
}
80100605:	90                   	nop
80100606:	c9                   	leave  
80100607:	c3                   	ret    

80100608 <panic>:

void
panic(char *s)
{
80100608:	f3 0f 1e fb          	endbr32 
8010060c:	55                   	push   %ebp
8010060d:	89 e5                	mov    %esp,%ebp
8010060f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
80100612:	e8 4a fd ff ff       	call   80100361 <cli>
  cons.locking = 0;
80100617:	c7 05 f4 d5 10 80 00 	movl   $0x0,0x8010d5f4
8010061e:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100621:	e8 6a 2c 00 00       	call   80103290 <lapicid>
80100626:	83 ec 08             	sub    $0x8,%esp
80100629:	50                   	push   %eax
8010062a:	68 f0 95 10 80       	push   $0x801095f0
8010062f:	e8 e4 fd ff ff       	call   80100418 <cprintf>
80100634:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100637:	8b 45 08             	mov    0x8(%ebp),%eax
8010063a:	83 ec 0c             	sub    $0xc,%esp
8010063d:	50                   	push   %eax
8010063e:	e8 d5 fd ff ff       	call   80100418 <cprintf>
80100643:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
80100646:	83 ec 0c             	sub    $0xc,%esp
80100649:	68 04 96 10 80       	push   $0x80109604
8010064e:	e8 c5 fd ff ff       	call   80100418 <cprintf>
80100653:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
80100656:	83 ec 08             	sub    $0x8,%esp
80100659:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010065c:	50                   	push   %eax
8010065d:	8d 45 08             	lea    0x8(%ebp),%eax
80100660:	50                   	push   %eax
80100661:	e8 cb 4f 00 00       	call   80105631 <getcallerpcs>
80100666:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100669:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100670:	eb 1c                	jmp    8010068e <panic+0x86>
    cprintf(" %p", pcs[i]);
80100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100675:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
80100679:	83 ec 08             	sub    $0x8,%esp
8010067c:	50                   	push   %eax
8010067d:	68 06 96 10 80       	push   $0x80109606
80100682:	e8 91 fd ff ff       	call   80100418 <cprintf>
80100687:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
8010068a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010068e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100692:	7e de                	jle    80100672 <panic+0x6a>
  panicked = 1; // freeze other CPU
80100694:	c7 05 a0 d5 10 80 01 	movl   $0x1,0x8010d5a0
8010069b:	00 00 00 
  for(;;)
8010069e:	eb fe                	jmp    8010069e <panic+0x96>

801006a0 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801006a0:	f3 0f 1e fb          	endbr32 
801006a4:	55                   	push   %ebp
801006a5:	89 e5                	mov    %esp,%ebp
801006a7:	53                   	push   %ebx
801006a8:	83 ec 14             	sub    $0x14,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801006ab:	6a 0e                	push   $0xe
801006ad:	68 d4 03 00 00       	push   $0x3d4
801006b2:	e8 89 fc ff ff       	call   80100340 <outb>
801006b7:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
801006ba:	68 d5 03 00 00       	push   $0x3d5
801006bf:	e8 5f fc ff ff       	call   80100323 <inb>
801006c4:	83 c4 04             	add    $0x4,%esp
801006c7:	0f b6 c0             	movzbl %al,%eax
801006ca:	c1 e0 08             	shl    $0x8,%eax
801006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801006d0:	6a 0f                	push   $0xf
801006d2:	68 d4 03 00 00       	push   $0x3d4
801006d7:	e8 64 fc ff ff       	call   80100340 <outb>
801006dc:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
801006df:	68 d5 03 00 00       	push   $0x3d5
801006e4:	e8 3a fc ff ff       	call   80100323 <inb>
801006e9:	83 c4 04             	add    $0x4,%esp
801006ec:	0f b6 c0             	movzbl %al,%eax
801006ef:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
801006f2:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
801006f6:	75 30                	jne    80100728 <cgaputc+0x88>
    pos += 80 - pos%80;
801006f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006fb:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100700:	89 c8                	mov    %ecx,%eax
80100702:	f7 ea                	imul   %edx
80100704:	c1 fa 05             	sar    $0x5,%edx
80100707:	89 c8                	mov    %ecx,%eax
80100709:	c1 f8 1f             	sar    $0x1f,%eax
8010070c:	29 c2                	sub    %eax,%edx
8010070e:	89 d0                	mov    %edx,%eax
80100710:	c1 e0 02             	shl    $0x2,%eax
80100713:	01 d0                	add    %edx,%eax
80100715:	c1 e0 04             	shl    $0x4,%eax
80100718:	29 c1                	sub    %eax,%ecx
8010071a:	89 ca                	mov    %ecx,%edx
8010071c:	b8 50 00 00 00       	mov    $0x50,%eax
80100721:	29 d0                	sub    %edx,%eax
80100723:	01 45 f4             	add    %eax,-0xc(%ebp)
80100726:	eb 38                	jmp    80100760 <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100728:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010072f:	75 0c                	jne    8010073d <cgaputc+0x9d>
    if(pos > 0) --pos;
80100731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100735:	7e 29                	jle    80100760 <cgaputc+0xc0>
80100737:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010073b:	eb 23                	jmp    80100760 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010073d:	8b 45 08             	mov    0x8(%ebp),%eax
80100740:	0f b6 c0             	movzbl %al,%eax
80100743:	80 cc 07             	or     $0x7,%ah
80100746:	89 c3                	mov    %eax,%ebx
80100748:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100751:	8d 50 01             	lea    0x1(%eax),%edx
80100754:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100757:	01 c0                	add    %eax,%eax
80100759:	01 c8                	add    %ecx,%eax
8010075b:	89 da                	mov    %ebx,%edx
8010075d:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
80100760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100764:	78 09                	js     8010076f <cgaputc+0xcf>
80100766:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
8010076d:	7e 0d                	jle    8010077c <cgaputc+0xdc>
    panic("pos under/overflow");
8010076f:	83 ec 0c             	sub    $0xc,%esp
80100772:	68 0a 96 10 80       	push   $0x8010960a
80100777:	e8 8c fe ff ff       	call   80100608 <panic>

  if((pos/80) >= 24){  // Scroll up.
8010077c:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100783:	7e 4c                	jle    801007d1 <cgaputc+0x131>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100785:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010078a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100790:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100795:	83 ec 04             	sub    $0x4,%esp
80100798:	68 60 0e 00 00       	push   $0xe60
8010079d:	52                   	push   %edx
8010079e:	50                   	push   %eax
8010079f:	e8 2b 51 00 00       	call   801058cf <memmove>
801007a4:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801007a7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801007ab:	b8 80 07 00 00       	mov    $0x780,%eax
801007b0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801007b3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801007b6:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801007bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801007be:	01 c9                	add    %ecx,%ecx
801007c0:	01 c8                	add    %ecx,%eax
801007c2:	83 ec 04             	sub    $0x4,%esp
801007c5:	52                   	push   %edx
801007c6:	6a 00                	push   $0x0
801007c8:	50                   	push   %eax
801007c9:	e8 3a 50 00 00       	call   80105808 <memset>
801007ce:	83 c4 10             	add    $0x10,%esp
  }

  outb(CRTPORT, 14);
801007d1:	83 ec 08             	sub    $0x8,%esp
801007d4:	6a 0e                	push   $0xe
801007d6:	68 d4 03 00 00       	push   $0x3d4
801007db:	e8 60 fb ff ff       	call   80100340 <outb>
801007e0:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
801007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007e6:	c1 f8 08             	sar    $0x8,%eax
801007e9:	0f b6 c0             	movzbl %al,%eax
801007ec:	83 ec 08             	sub    $0x8,%esp
801007ef:	50                   	push   %eax
801007f0:	68 d5 03 00 00       	push   $0x3d5
801007f5:	e8 46 fb ff ff       	call   80100340 <outb>
801007fa:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
801007fd:	83 ec 08             	sub    $0x8,%esp
80100800:	6a 0f                	push   $0xf
80100802:	68 d4 03 00 00       	push   $0x3d4
80100807:	e8 34 fb ff ff       	call   80100340 <outb>
8010080c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100812:	0f b6 c0             	movzbl %al,%eax
80100815:	83 ec 08             	sub    $0x8,%esp
80100818:	50                   	push   %eax
80100819:	68 d5 03 00 00       	push   $0x3d5
8010081e:	e8 1d fb ff ff       	call   80100340 <outb>
80100823:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100826:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010082b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010082e:	01 d2                	add    %edx,%edx
80100830:	01 d0                	add    %edx,%eax
80100832:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100837:	90                   	nop
80100838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010083b:	c9                   	leave  
8010083c:	c3                   	ret    

8010083d <consputc>:

void
consputc(int c)
{
8010083d:	f3 0f 1e fb          	endbr32 
80100841:	55                   	push   %ebp
80100842:	89 e5                	mov    %esp,%ebp
80100844:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100847:	a1 a0 d5 10 80       	mov    0x8010d5a0,%eax
8010084c:	85 c0                	test   %eax,%eax
8010084e:	74 07                	je     80100857 <consputc+0x1a>
    cli();
80100850:	e8 0c fb ff ff       	call   80100361 <cli>
    for(;;)
80100855:	eb fe                	jmp    80100855 <consputc+0x18>
      ;
  }

  if(c == BACKSPACE){
80100857:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010085e:	75 29                	jne    80100889 <consputc+0x4c>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	6a 08                	push   $0x8
80100865:	e8 bd 6a 00 00       	call   80107327 <uartputc>
8010086a:	83 c4 10             	add    $0x10,%esp
8010086d:	83 ec 0c             	sub    $0xc,%esp
80100870:	6a 20                	push   $0x20
80100872:	e8 b0 6a 00 00       	call   80107327 <uartputc>
80100877:	83 c4 10             	add    $0x10,%esp
8010087a:	83 ec 0c             	sub    $0xc,%esp
8010087d:	6a 08                	push   $0x8
8010087f:	e8 a3 6a 00 00       	call   80107327 <uartputc>
80100884:	83 c4 10             	add    $0x10,%esp
80100887:	eb 0e                	jmp    80100897 <consputc+0x5a>
  } else
    uartputc(c);
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	ff 75 08             	pushl  0x8(%ebp)
8010088f:	e8 93 6a 00 00       	call   80107327 <uartputc>
80100894:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100897:	83 ec 0c             	sub    $0xc,%esp
8010089a:	ff 75 08             	pushl  0x8(%ebp)
8010089d:	e8 fe fd ff ff       	call   801006a0 <cgaputc>
801008a2:	83 c4 10             	add    $0x10,%esp
}
801008a5:	90                   	nop
801008a6:	c9                   	leave  
801008a7:	c3                   	ret    

801008a8 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801008a8:	f3 0f 1e fb          	endbr32 
801008ac:	55                   	push   %ebp
801008ad:	89 e5                	mov    %esp,%ebp
801008af:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 c0 d5 10 80       	push   $0x8010d5c0
801008c1:	e8 a3 4c 00 00       	call   80105569 <acquire>
801008c6:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801008c9:	e9 52 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    switch(c){
801008ce:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008d2:	0f 84 81 00 00 00    	je     80100959 <consoleintr+0xb1>
801008d8:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
801008dc:	0f 8f ac 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008e2:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008e6:	74 43                	je     8010092b <consoleintr+0x83>
801008e8:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
801008ec:	0f 8f 9c 00 00 00    	jg     8010098e <consoleintr+0xe6>
801008f2:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
801008f6:	74 61                	je     80100959 <consoleintr+0xb1>
801008f8:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
801008fc:	0f 85 8c 00 00 00    	jne    8010098e <consoleintr+0xe6>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100902:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100909:	e9 12 01 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010090e:	a1 48 30 11 80       	mov    0x80113048,%eax
80100913:	83 e8 01             	sub    $0x1,%eax
80100916:	a3 48 30 11 80       	mov    %eax,0x80113048
        consputc(BACKSPACE);
8010091b:	83 ec 0c             	sub    $0xc,%esp
8010091e:	68 00 01 00 00       	push   $0x100
80100923:	e8 15 ff ff ff       	call   8010083d <consputc>
80100928:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
8010092b:	8b 15 48 30 11 80    	mov    0x80113048,%edx
80100931:	a1 44 30 11 80       	mov    0x80113044,%eax
80100936:	39 c2                	cmp    %eax,%edx
80100938:	0f 84 e2 00 00 00    	je     80100a20 <consoleintr+0x178>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010093e:	a1 48 30 11 80       	mov    0x80113048,%eax
80100943:	83 e8 01             	sub    $0x1,%eax
80100946:	83 e0 7f             	and    $0x7f,%eax
80100949:	0f b6 80 c0 2f 11 80 	movzbl -0x7feed040(%eax),%eax
      while(input.e != input.w &&
80100950:	3c 0a                	cmp    $0xa,%al
80100952:	75 ba                	jne    8010090e <consoleintr+0x66>
      }
      break;
80100954:	e9 c7 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100959:	8b 15 48 30 11 80    	mov    0x80113048,%edx
8010095f:	a1 44 30 11 80       	mov    0x80113044,%eax
80100964:	39 c2                	cmp    %eax,%edx
80100966:	0f 84 b4 00 00 00    	je     80100a20 <consoleintr+0x178>
        input.e--;
8010096c:	a1 48 30 11 80       	mov    0x80113048,%eax
80100971:	83 e8 01             	sub    $0x1,%eax
80100974:	a3 48 30 11 80       	mov    %eax,0x80113048
        consputc(BACKSPACE);
80100979:	83 ec 0c             	sub    $0xc,%esp
8010097c:	68 00 01 00 00       	push   $0x100
80100981:	e8 b7 fe ff ff       	call   8010083d <consputc>
80100986:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100989:	e9 92 00 00 00       	jmp    80100a20 <consoleintr+0x178>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010098e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100992:	0f 84 87 00 00 00    	je     80100a1f <consoleintr+0x177>
80100998:	8b 15 48 30 11 80    	mov    0x80113048,%edx
8010099e:	a1 40 30 11 80       	mov    0x80113040,%eax
801009a3:	29 c2                	sub    %eax,%edx
801009a5:	89 d0                	mov    %edx,%eax
801009a7:	83 f8 7f             	cmp    $0x7f,%eax
801009aa:	77 73                	ja     80100a1f <consoleintr+0x177>
        c = (c == '\r') ? '\n' : c;
801009ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801009b0:	74 05                	je     801009b7 <consoleintr+0x10f>
801009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b5:	eb 05                	jmp    801009bc <consoleintr+0x114>
801009b7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801009bf:	a1 48 30 11 80       	mov    0x80113048,%eax
801009c4:	8d 50 01             	lea    0x1(%eax),%edx
801009c7:	89 15 48 30 11 80    	mov    %edx,0x80113048
801009cd:	83 e0 7f             	and    $0x7f,%eax
801009d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009d3:	88 90 c0 2f 11 80    	mov    %dl,-0x7feed040(%eax)
        consputc(c);
801009d9:	83 ec 0c             	sub    $0xc,%esp
801009dc:	ff 75 f0             	pushl  -0x10(%ebp)
801009df:	e8 59 fe ff ff       	call   8010083d <consputc>
801009e4:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009e7:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009eb:	74 18                	je     80100a05 <consoleintr+0x15d>
801009ed:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f1:	74 12                	je     80100a05 <consoleintr+0x15d>
801009f3:	a1 48 30 11 80       	mov    0x80113048,%eax
801009f8:	8b 15 40 30 11 80    	mov    0x80113040,%edx
801009fe:	83 ea 80             	sub    $0xffffff80,%edx
80100a01:	39 d0                	cmp    %edx,%eax
80100a03:	75 1a                	jne    80100a1f <consoleintr+0x177>
          input.w = input.e;
80100a05:	a1 48 30 11 80       	mov    0x80113048,%eax
80100a0a:	a3 44 30 11 80       	mov    %eax,0x80113044
          wakeup(&input.r);
80100a0f:	83 ec 0c             	sub    $0xc,%esp
80100a12:	68 40 30 11 80       	push   $0x80113040
80100a17:	e8 cd 47 00 00       	call   801051e9 <wakeup>
80100a1c:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100a1f:	90                   	nop
  while((c = getc()) >= 0){
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	ff d0                	call   *%eax
80100a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a2c:	0f 89 9c fe ff ff    	jns    801008ce <consoleintr+0x26>
    }
  }
  release(&cons.lock);
80100a32:	83 ec 0c             	sub    $0xc,%esp
80100a35:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a3a:	e8 9c 4b 00 00       	call   801055db <release>
80100a3f:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a46:	74 05                	je     80100a4d <consoleintr+0x1a5>
    procdump();  // now call procdump() wo. cons.lock held
80100a48:	e8 62 48 00 00       	call   801052af <procdump>
  }
}
80100a4d:	90                   	nop
80100a4e:	c9                   	leave  
80100a4f:	c3                   	ret    

80100a50 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a50:	f3 0f 1e fb          	endbr32 
80100a54:	55                   	push   %ebp
80100a55:	89 e5                	mov    %esp,%ebp
80100a57:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	ff 75 08             	pushl  0x8(%ebp)
80100a60:	e8 bf 12 00 00       	call   80101d24 <iunlock>
80100a65:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a68:	8b 45 10             	mov    0x10(%ebp),%eax
80100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a6e:	83 ec 0c             	sub    $0xc,%esp
80100a71:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a76:	e8 ee 4a 00 00       	call   80105569 <acquire>
80100a7b:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a7e:	e9 ab 00 00 00       	jmp    80100b2e <consoleread+0xde>
    while(input.r == input.w){
      if(myproc()->killed){
80100a83:	e8 39 3b 00 00       	call   801045c1 <myproc>
80100a88:	8b 40 24             	mov    0x24(%eax),%eax
80100a8b:	85 c0                	test   %eax,%eax
80100a8d:	74 28                	je     80100ab7 <consoleread+0x67>
        release(&cons.lock);
80100a8f:	83 ec 0c             	sub    $0xc,%esp
80100a92:	68 c0 d5 10 80       	push   $0x8010d5c0
80100a97:	e8 3f 4b 00 00       	call   801055db <release>
80100a9c:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	pushl  0x8(%ebp)
80100aa5:	e8 63 11 00 00       	call   80101c0d <ilock>
80100aaa:	83 c4 10             	add    $0x10,%esp
        return -1;
80100aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ab2:	e9 ab 00 00 00       	jmp    80100b62 <consoleread+0x112>
      }
      sleep(&input.r, &cons.lock);
80100ab7:	83 ec 08             	sub    $0x8,%esp
80100aba:	68 c0 d5 10 80       	push   $0x8010d5c0
80100abf:	68 40 30 11 80       	push   $0x80113040
80100ac4:	e8 2e 46 00 00       	call   801050f7 <sleep>
80100ac9:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100acc:	8b 15 40 30 11 80    	mov    0x80113040,%edx
80100ad2:	a1 44 30 11 80       	mov    0x80113044,%eax
80100ad7:	39 c2                	cmp    %eax,%edx
80100ad9:	74 a8                	je     80100a83 <consoleread+0x33>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100adb:	a1 40 30 11 80       	mov    0x80113040,%eax
80100ae0:	8d 50 01             	lea    0x1(%eax),%edx
80100ae3:	89 15 40 30 11 80    	mov    %edx,0x80113040
80100ae9:	83 e0 7f             	and    $0x7f,%eax
80100aec:	0f b6 80 c0 2f 11 80 	movzbl -0x7feed040(%eax),%eax
80100af3:	0f be c0             	movsbl %al,%eax
80100af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100af9:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100afd:	75 17                	jne    80100b16 <consoleread+0xc6>
      if(n < target){
80100aff:	8b 45 10             	mov    0x10(%ebp),%eax
80100b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100b05:	76 2f                	jbe    80100b36 <consoleread+0xe6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100b07:	a1 40 30 11 80       	mov    0x80113040,%eax
80100b0c:	83 e8 01             	sub    $0x1,%eax
80100b0f:	a3 40 30 11 80       	mov    %eax,0x80113040
      }
      break;
80100b14:	eb 20                	jmp    80100b36 <consoleread+0xe6>
    }
    *dst++ = c;
80100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b19:	8d 50 01             	lea    0x1(%eax),%edx
80100b1c:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b22:	88 10                	mov    %dl,(%eax)
    --n;
80100b24:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b28:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b2c:	74 0b                	je     80100b39 <consoleread+0xe9>
  while(n > 0){
80100b2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b32:	7f 98                	jg     80100acc <consoleread+0x7c>
80100b34:	eb 04                	jmp    80100b3a <consoleread+0xea>
      break;
80100b36:	90                   	nop
80100b37:	eb 01                	jmp    80100b3a <consoleread+0xea>
      break;
80100b39:	90                   	nop
  }
  release(&cons.lock);
80100b3a:	83 ec 0c             	sub    $0xc,%esp
80100b3d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b42:	e8 94 4a 00 00       	call   801055db <release>
80100b47:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b4a:	83 ec 0c             	sub    $0xc,%esp
80100b4d:	ff 75 08             	pushl  0x8(%ebp)
80100b50:	e8 b8 10 00 00       	call   80101c0d <ilock>
80100b55:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b58:	8b 45 10             	mov    0x10(%ebp),%eax
80100b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b5e:	29 c2                	sub    %eax,%edx
80100b60:	89 d0                	mov    %edx,%eax
}
80100b62:	c9                   	leave  
80100b63:	c3                   	ret    

80100b64 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b64:	f3 0f 1e fb          	endbr32 
80100b68:	55                   	push   %ebp
80100b69:	89 e5                	mov    %esp,%ebp
80100b6b:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b6e:	83 ec 0c             	sub    $0xc,%esp
80100b71:	ff 75 08             	pushl  0x8(%ebp)
80100b74:	e8 ab 11 00 00       	call   80101d24 <iunlock>
80100b79:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	68 c0 d5 10 80       	push   $0x8010d5c0
80100b84:	e8 e0 49 00 00       	call   80105569 <acquire>
80100b89:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b93:	eb 21                	jmp    80100bb6 <consolewrite+0x52>
    consputc(buf[i] & 0xff);
80100b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b98:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b9b:	01 d0                	add    %edx,%eax
80100b9d:	0f b6 00             	movzbl (%eax),%eax
80100ba0:	0f be c0             	movsbl %al,%eax
80100ba3:	0f b6 c0             	movzbl %al,%eax
80100ba6:	83 ec 0c             	sub    $0xc,%esp
80100ba9:	50                   	push   %eax
80100baa:	e8 8e fc ff ff       	call   8010083d <consputc>
80100baf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100bb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100bb9:	3b 45 10             	cmp    0x10(%ebp),%eax
80100bbc:	7c d7                	jl     80100b95 <consolewrite+0x31>
  release(&cons.lock);
80100bbe:	83 ec 0c             	sub    $0xc,%esp
80100bc1:	68 c0 d5 10 80       	push   $0x8010d5c0
80100bc6:	e8 10 4a 00 00       	call   801055db <release>
80100bcb:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bce:	83 ec 0c             	sub    $0xc,%esp
80100bd1:	ff 75 08             	pushl  0x8(%ebp)
80100bd4:	e8 34 10 00 00       	call   80101c0d <ilock>
80100bd9:	83 c4 10             	add    $0x10,%esp

  return n;
80100bdc:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bdf:	c9                   	leave  
80100be0:	c3                   	ret    

80100be1 <consoleinit>:

void
consoleinit(void)
{
80100be1:	f3 0f 1e fb          	endbr32 
80100be5:	55                   	push   %ebp
80100be6:	89 e5                	mov    %esp,%ebp
80100be8:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100beb:	83 ec 08             	sub    $0x8,%esp
80100bee:	68 1d 96 10 80       	push   $0x8010961d
80100bf3:	68 c0 d5 10 80       	push   $0x8010d5c0
80100bf8:	e8 46 49 00 00       	call   80105543 <initlock>
80100bfd:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100c00:	c7 05 0c 3a 11 80 64 	movl   $0x80100b64,0x80113a0c
80100c07:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100c0a:	c7 05 08 3a 11 80 50 	movl   $0x80100a50,0x80113a08
80100c11:	0a 10 80 
  cons.locking = 1;
80100c14:	c7 05 f4 d5 10 80 01 	movl   $0x1,0x8010d5f4
80100c1b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100c1e:	83 ec 08             	sub    $0x8,%esp
80100c21:	6a 00                	push   $0x0
80100c23:	6a 01                	push   $0x1
80100c25:	e8 4d 21 00 00       	call   80102d77 <ioapicenable>
80100c2a:	83 c4 10             	add    $0x10,%esp
}
80100c2d:	90                   	nop
80100c2e:	c9                   	leave  
80100c2f:	c3                   	ret    

80100c30 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)  // Create queue and clear it out right here.
{
80100c30:	f3 0f 1e fb          	endbr32 
80100c34:	55                   	push   %ebp
80100c35:	89 e5                	mov    %esp,%ebp
80100c37:	81 ec 28 01 00 00    	sub    $0x128,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c3d:	e8 7f 39 00 00       	call   801045c1 <myproc>
80100c42:	89 45 c8             	mov    %eax,-0x38(%ebp)

  curproc->q_head = &curproc->clock_queue[0];
80100c45:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c48:	8d 50 7c             	lea    0x7c(%eax),%edx
80100c4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c4e:	89 90 fc 00 00 00    	mov    %edx,0xfc(%eax)
  //curproc->q_tail = 0;
  curproc->q_count = 0;
80100c54:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c57:	c7 80 00 01 00 00 00 	movl   $0x0,0x100(%eax)
80100c5e:	00 00 00 

  // Initialize all fields of clock_queue to 0 (clear)
  int j;
  for (j = 0; j < CLOCKSIZE - 1; j++ ){
80100c61:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
80100c68:	eb 72                	jmp    80100cdc <exec+0xac>
    curproc->clock_queue[j].next = &curproc->clock_queue[j+1];
80100c6a:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100c6d:	83 c0 01             	add    $0x1,%eax
80100c70:	83 c0 07             	add    $0x7,%eax
80100c73:	c1 e0 04             	shl    $0x4,%eax
80100c76:	89 c2                	mov    %eax,%edx
80100c78:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c7b:	01 d0                	add    %edx,%eax
80100c7d:	8d 50 0c             	lea    0xc(%eax),%edx
80100c80:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c83:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80100c86:	83 c1 07             	add    $0x7,%ecx
80100c89:	c1 e1 04             	shl    $0x4,%ecx
80100c8c:	01 c8                	add    %ecx,%eax
80100c8e:	83 c0 10             	add    $0x10,%eax
80100c91:	89 10                	mov    %edx,(%eax)
    curproc->clock_queue[j].is_full = 0;
80100c93:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100c96:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100c99:	83 c2 07             	add    $0x7,%edx
80100c9c:	c1 e2 04             	shl    $0x4,%edx
80100c9f:	01 d0                	add    %edx,%eax
80100ca1:	83 c0 0c             	add    $0xc,%eax
80100ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    curproc->clock_queue[j].va = 0;
80100caa:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100cad:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100cb0:	83 c2 07             	add    $0x7,%edx
80100cb3:	c1 e2 04             	shl    $0x4,%edx
80100cb6:	01 d0                	add    %edx,%eax
80100cb8:	83 c0 14             	add    $0x14,%eax
80100cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    curproc->clock_queue[j].pte = 0;
80100cc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100cc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100cc7:	83 c2 07             	add    $0x7,%edx
80100cca:	c1 e2 04             	shl    $0x4,%edx
80100ccd:	01 d0                	add    %edx,%eax
80100ccf:	83 c0 18             	add    $0x18,%eax
80100cd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (j = 0; j < CLOCKSIZE - 1; j++ ){
80100cd8:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
80100cdc:	83 7d d0 06          	cmpl   $0x6,-0x30(%ebp)
80100ce0:	7e 88                	jle    80100c6a <exec+0x3a>
  }
  j = CLOCKSIZE - 1;
80100ce2:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
  curproc->clock_queue[j].next = &curproc->clock_queue[0];
80100ce9:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100cec:	8d 50 7c             	lea    0x7c(%eax),%edx
80100cef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100cf2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80100cf5:	83 c1 07             	add    $0x7,%ecx
80100cf8:	c1 e1 04             	shl    $0x4,%ecx
80100cfb:	01 c8                	add    %ecx,%eax
80100cfd:	83 c0 10             	add    $0x10,%eax
80100d00:	89 10                	mov    %edx,(%eax)
  curproc->clock_queue[j].is_full = 0;
80100d02:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100d05:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100d08:	83 c2 07             	add    $0x7,%edx
80100d0b:	c1 e2 04             	shl    $0x4,%edx
80100d0e:	01 d0                	add    %edx,%eax
80100d10:	83 c0 0c             	add    $0xc,%eax
80100d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  curproc->clock_queue[j].va = 0;
80100d19:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100d1c:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100d1f:	83 c2 07             	add    $0x7,%edx
80100d22:	c1 e2 04             	shl    $0x4,%edx
80100d25:	01 d0                	add    %edx,%eax
80100d27:	83 c0 14             	add    $0x14,%eax
80100d2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  curproc->clock_queue[j].pte = 0;
80100d30:	8b 45 c8             	mov    -0x38(%ebp),%eax
80100d33:	8b 55 d0             	mov    -0x30(%ebp),%edx
80100d36:	83 c2 07             	add    $0x7,%edx
80100d39:	c1 e2 04             	shl    $0x4,%edx
80100d3c:	01 d0                	add    %edx,%eax
80100d3e:	83 c0 18             	add    $0x18,%eax
80100d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)


  begin_op();
80100d47:	e8 b6 2a 00 00       	call   80103802 <begin_op>

  if((ip = namei(path)) == 0){
80100d4c:	83 ec 0c             	sub    $0xc,%esp
80100d4f:	ff 75 08             	pushl  0x8(%ebp)
80100d52:	e8 21 1a 00 00       	call   80102778 <namei>
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100d5d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100d61:	75 1f                	jne    80100d82 <exec+0x152>
    end_op();
80100d63:	e8 2a 2b 00 00       	call   80103892 <end_op>
    cprintf("exec: fail\n");
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	68 25 96 10 80       	push   $0x80109625
80100d70:	e8 a3 f6 ff ff       	call   80100418 <cprintf>
80100d75:	83 c4 10             	add    $0x10,%esp
    return -1;
80100d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d7d:	e9 21 04 00 00       	jmp    801011a3 <exec+0x573>
  }
  ilock(ip);
80100d82:	83 ec 0c             	sub    $0xc,%esp
80100d85:	ff 75 d8             	pushl  -0x28(%ebp)
80100d88:	e8 80 0e 00 00       	call   80101c0d <ilock>
80100d8d:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100d90:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d97:	6a 34                	push   $0x34
80100d99:	6a 00                	push   $0x0
80100d9b:	8d 85 00 ff ff ff    	lea    -0x100(%ebp),%eax
80100da1:	50                   	push   %eax
80100da2:	ff 75 d8             	pushl  -0x28(%ebp)
80100da5:	e8 6b 13 00 00       	call   80102115 <readi>
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	83 f8 34             	cmp    $0x34,%eax
80100db0:	0f 85 96 03 00 00    	jne    8010114c <exec+0x51c>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100db6:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100dbc:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100dc1:	0f 85 88 03 00 00    	jne    8010114f <exec+0x51f>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100dc7:	e8 92 75 00 00       	call   8010835e <setupkvm>
80100dcc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100dcf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100dd3:	0f 84 79 03 00 00    	je     80101152 <exec+0x522>
    goto bad;

  // Load program into memory.
  sz = 0;
80100dd9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100de7:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
80100ded:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100df0:	e9 de 00 00 00       	jmp    80100ed3 <exec+0x2a3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100df8:	6a 20                	push   $0x20
80100dfa:	50                   	push   %eax
80100dfb:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
80100e01:	50                   	push   %eax
80100e02:	ff 75 d8             	pushl  -0x28(%ebp)
80100e05:	e8 0b 13 00 00       	call   80102115 <readi>
80100e0a:	83 c4 10             	add    $0x10,%esp
80100e0d:	83 f8 20             	cmp    $0x20,%eax
80100e10:	0f 85 3f 03 00 00    	jne    80101155 <exec+0x525>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100e16:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
80100e1c:	83 f8 01             	cmp    $0x1,%eax
80100e1f:	0f 85 a0 00 00 00    	jne    80100ec5 <exec+0x295>
      continue;
    if(ph.memsz < ph.filesz)
80100e25:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100e2b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100e31:	39 c2                	cmp    %eax,%edx
80100e33:	0f 82 1f 03 00 00    	jb     80101158 <exec+0x528>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100e39:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100e3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e45:	01 c2                	add    %eax,%edx
80100e47:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100e4d:	39 c2                	cmp    %eax,%edx
80100e4f:	0f 82 06 03 00 00    	jb     8010115b <exec+0x52b>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e55:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100e5b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e61:	01 d0                	add    %edx,%eax
80100e63:	83 ec 04             	sub    $0x4,%esp
80100e66:	50                   	push   %eax
80100e67:	ff 75 e0             	pushl  -0x20(%ebp)
80100e6a:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e6d:	e8 aa 78 00 00       	call   8010871c <allocuvm>
80100e72:	83 c4 10             	add    $0x10,%esp
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e78:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e7c:	0f 84 dc 02 00 00    	je     8010115e <exec+0x52e>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100e82:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100e88:	25 ff 0f 00 00       	and    $0xfff,%eax
80100e8d:	85 c0                	test   %eax,%eax
80100e8f:	0f 85 cc 02 00 00    	jne    80101161 <exec+0x531>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e95:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100e9b:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100ea1:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100ea7:	83 ec 0c             	sub    $0xc,%esp
80100eaa:	52                   	push   %edx
80100eab:	50                   	push   %eax
80100eac:	ff 75 d8             	pushl  -0x28(%ebp)
80100eaf:	51                   	push   %ecx
80100eb0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eb3:	e8 93 77 00 00       	call   8010864b <loaduvm>
80100eb8:	83 c4 20             	add    $0x20,%esp
80100ebb:	85 c0                	test   %eax,%eax
80100ebd:	0f 88 a1 02 00 00    	js     80101164 <exec+0x534>
80100ec3:	eb 01                	jmp    80100ec6 <exec+0x296>
      continue;
80100ec5:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ec6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ecd:	83 c0 20             	add    $0x20,%eax
80100ed0:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ed3:	0f b7 85 2c ff ff ff 	movzwl -0xd4(%ebp),%eax
80100eda:	0f b7 c0             	movzwl %ax,%eax
80100edd:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100ee0:	0f 8c 0f ff ff ff    	jl     80100df5 <exec+0x1c5>
      goto bad;
  }
  iunlockput(ip);
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	ff 75 d8             	pushl  -0x28(%ebp)
80100eec:	e8 59 0f 00 00       	call   80101e4a <iunlockput>
80100ef1:	83 c4 10             	add    $0x10,%esp
  end_op();
80100ef4:	e8 99 29 00 00       	call   80103892 <end_op>
  ip = 0;
80100ef9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  sz = PGROUNDUP(sz); // This points to the top of the data and text part of memory
80100f00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f03:	05 ff 0f 00 00       	add    $0xfff,%eax
80100f08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)


  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f13:	05 00 20 00 00       	add    $0x2000,%eax
80100f18:	83 ec 04             	sub    $0x4,%esp
80100f1b:	50                   	push   %eax
80100f1c:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f22:	e8 f5 77 00 00       	call   8010871c <allocuvm>
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100f2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100f31:	0f 84 30 02 00 00    	je     80101167 <exec+0x537>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f3a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100f3f:	83 ec 08             	sub    $0x8,%esp
80100f42:	50                   	push   %eax
80100f43:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f46:	e8 43 7a 00 00       	call   8010898e <clearpteu>
80100f4b:	83 c4 10             	add    $0x10,%esp
  sp = sz; 
80100f4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f51:	89 45 dc             	mov    %eax,-0x24(%ebp)


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100f5b:	e9 96 00 00 00       	jmp    80100ff6 <exec+0x3c6>
    if(argc >= MAXARG)
80100f60:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100f64:	0f 87 00 02 00 00    	ja     8010116a <exec+0x53a>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f77:	01 d0                	add    %edx,%eax
80100f79:	8b 00                	mov    (%eax),%eax
80100f7b:	83 ec 0c             	sub    $0xc,%esp
80100f7e:	50                   	push   %eax
80100f7f:	e8 ed 4a 00 00       	call   80105a71 <strlen>
80100f84:	83 c4 10             	add    $0x10,%esp
80100f87:	89 c2                	mov    %eax,%edx
80100f89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f8c:	29 d0                	sub    %edx,%eax
80100f8e:	83 e8 01             	sub    $0x1,%eax
80100f91:	83 e0 fc             	and    $0xfffffffc,%eax
80100f94:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fa4:	01 d0                	add    %edx,%eax
80100fa6:	8b 00                	mov    (%eax),%eax
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	50                   	push   %eax
80100fac:	e8 c0 4a 00 00       	call   80105a71 <strlen>
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 c0 01             	add    $0x1,%eax
80100fb7:	89 c1                	mov    %eax,%ecx
80100fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fbc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fc6:	01 d0                	add    %edx,%eax
80100fc8:	8b 00                	mov    (%eax),%eax
80100fca:	51                   	push   %ecx
80100fcb:	50                   	push   %eax
80100fcc:	ff 75 dc             	pushl  -0x24(%ebp)
80100fcf:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fd2:	e8 73 7b 00 00       	call   80108b4a <copyout>
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	0f 88 8b 01 00 00    	js     8010116d <exec+0x53d>
      goto bad;
    ustack[3+argc] = sp;
80100fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe5:	8d 50 03             	lea    0x3(%eax),%edx
80100fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100feb:	89 84 95 34 ff ff ff 	mov    %eax,-0xcc(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100ff2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101000:	8b 45 0c             	mov    0xc(%ebp),%eax
80101003:	01 d0                	add    %edx,%eax
80101005:	8b 00                	mov    (%eax),%eax
80101007:	85 c0                	test   %eax,%eax
80101009:	0f 85 51 ff ff ff    	jne    80100f60 <exec+0x330>
  }
  ustack[3+argc] = 0;
8010100f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101012:	83 c0 03             	add    $0x3,%eax
80101015:	c7 84 85 34 ff ff ff 	movl   $0x0,-0xcc(%ebp,%eax,4)
8010101c:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80101020:	c7 85 34 ff ff ff ff 	movl   $0xffffffff,-0xcc(%ebp)
80101027:	ff ff ff 
  ustack[1] = argc;
8010102a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010102d:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101036:	83 c0 01             	add    $0x1,%eax
80101039:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101040:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101043:	29 d0                	sub    %edx,%eax
80101045:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

  sp -= (3+argc+1) * 4;
8010104b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010104e:	83 c0 04             	add    $0x4,%eax
80101051:	c1 e0 02             	shl    $0x2,%eax
80101054:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101057:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010105a:	83 c0 04             	add    $0x4,%eax
8010105d:	c1 e0 02             	shl    $0x2,%eax
80101060:	50                   	push   %eax
80101061:	8d 85 34 ff ff ff    	lea    -0xcc(%ebp),%eax
80101067:	50                   	push   %eax
80101068:	ff 75 dc             	pushl  -0x24(%ebp)
8010106b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010106e:	e8 d7 7a 00 00       	call   80108b4a <copyout>
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	85 c0                	test   %eax,%eax
80101078:	0f 88 f2 00 00 00    	js     80101170 <exec+0x540>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010107e:	8b 45 08             	mov    0x8(%ebp),%eax
80101081:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101087:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010108a:	eb 17                	jmp    801010a3 <exec+0x473>
    if(*s == '/')
8010108c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010108f:	0f b6 00             	movzbl (%eax),%eax
80101092:	3c 2f                	cmp    $0x2f,%al
80101094:	75 09                	jne    8010109f <exec+0x46f>
      last = s+1;
80101096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101099:	83 c0 01             	add    $0x1,%eax
8010109c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
8010109f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801010a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801010a6:	0f b6 00             	movzbl (%eax),%eax
801010a9:	84 c0                	test   %al,%al
801010ab:	75 df                	jne    8010108c <exec+0x45c>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010b0:	83 c0 6c             	add    $0x6c,%eax
801010b3:	83 ec 04             	sub    $0x4,%esp
801010b6:	6a 10                	push   $0x10
801010b8:	ff 75 f0             	pushl  -0x10(%ebp)
801010bb:	50                   	push   %eax
801010bc:	e8 62 49 00 00       	call   80105a23 <safestrcpy>
801010c1:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010c7:	8b 40 04             	mov    0x4(%eax),%eax
801010ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  curproc->pgdir = pgdir;
801010cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801010d3:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
801010d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801010dc:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
801010de:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010e1:	8b 40 18             	mov    0x18(%eax),%eax
801010e4:	8b 95 18 ff ff ff    	mov    -0xe8(%ebp),%edx
801010ea:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801010ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801010f0:	8b 40 18             	mov    0x18(%eax),%eax
801010f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801010f6:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
801010f9:	83 ec 0c             	sub    $0xc,%esp
801010fc:	ff 75 c8             	pushl  -0x38(%ebp)
801010ff:	e8 30 73 00 00       	call   80108434 <switchuvm>
80101104:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 75 c4             	pushl  -0x3c(%ebp)
8010110d:	e8 dd 77 00 00       	call   801088ef <freevm>
80101112:	83 c4 10             	add    $0x10,%esp


  // Encrypt the memory!
  for (int i = 0; i < sz/PGSIZE; i++) {
80101115:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
8010111c:	eb 18                	jmp    80101136 <exec+0x506>
    mencrypt((char*) 0 + i*PGSIZE, 1);
8010111e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101121:	c1 e0 0c             	shl    $0xc,%eax
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	6a 01                	push   $0x1
80101129:	50                   	push   %eax
8010112a:	e8 3e 7f 00 00       	call   8010906d <mencrypt>
8010112f:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < sz/PGSIZE; i++) {
80101132:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80101136:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101139:	c1 e8 0c             	shr    $0xc,%eax
8010113c:	89 c2                	mov    %eax,%edx
8010113e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101141:	39 c2                	cmp    %eax,%edx
80101143:	77 d9                	ja     8010111e <exec+0x4ee>
  }

  return 0;
80101145:	b8 00 00 00 00       	mov    $0x0,%eax
8010114a:	eb 57                	jmp    801011a3 <exec+0x573>
    goto bad;
8010114c:	90                   	nop
8010114d:	eb 22                	jmp    80101171 <exec+0x541>
    goto bad;
8010114f:	90                   	nop
80101150:	eb 1f                	jmp    80101171 <exec+0x541>
    goto bad;
80101152:	90                   	nop
80101153:	eb 1c                	jmp    80101171 <exec+0x541>
      goto bad;
80101155:	90                   	nop
80101156:	eb 19                	jmp    80101171 <exec+0x541>
      goto bad;
80101158:	90                   	nop
80101159:	eb 16                	jmp    80101171 <exec+0x541>
      goto bad;
8010115b:	90                   	nop
8010115c:	eb 13                	jmp    80101171 <exec+0x541>
      goto bad;
8010115e:	90                   	nop
8010115f:	eb 10                	jmp    80101171 <exec+0x541>
      goto bad;
80101161:	90                   	nop
80101162:	eb 0d                	jmp    80101171 <exec+0x541>
      goto bad;
80101164:	90                   	nop
80101165:	eb 0a                	jmp    80101171 <exec+0x541>
    goto bad;
80101167:	90                   	nop
80101168:	eb 07                	jmp    80101171 <exec+0x541>
      goto bad;
8010116a:	90                   	nop
8010116b:	eb 04                	jmp    80101171 <exec+0x541>
      goto bad;
8010116d:	90                   	nop
8010116e:	eb 01                	jmp    80101171 <exec+0x541>
    goto bad;
80101170:	90                   	nop

 bad:
  if(pgdir)
80101171:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101175:	74 0e                	je     80101185 <exec+0x555>
    freevm(pgdir);
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010117d:	e8 6d 77 00 00       	call   801088ef <freevm>
80101182:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101185:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101189:	74 13                	je     8010119e <exec+0x56e>
    iunlockput(ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	ff 75 d8             	pushl  -0x28(%ebp)
80101191:	e8 b4 0c 00 00       	call   80101e4a <iunlockput>
80101196:	83 c4 10             	add    $0x10,%esp
    end_op();
80101199:	e8 f4 26 00 00       	call   80103892 <end_op>
  }

  return -1;
8010119e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011a3:	c9                   	leave  
801011a4:	c3                   	ret    

801011a5 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011a5:	f3 0f 1e fb          	endbr32 
801011a9:	55                   	push   %ebp
801011aa:	89 e5                	mov    %esp,%ebp
801011ac:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801011af:	83 ec 08             	sub    $0x8,%esp
801011b2:	68 31 96 10 80       	push   $0x80109631
801011b7:	68 60 30 11 80       	push   $0x80113060
801011bc:	e8 82 43 00 00       	call   80105543 <initlock>
801011c1:	83 c4 10             	add    $0x10,%esp
}
801011c4:	90                   	nop
801011c5:	c9                   	leave  
801011c6:	c3                   	ret    

801011c7 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011c7:	f3 0f 1e fb          	endbr32 
801011cb:	55                   	push   %ebp
801011cc:	89 e5                	mov    %esp,%ebp
801011ce:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801011d1:	83 ec 0c             	sub    $0xc,%esp
801011d4:	68 60 30 11 80       	push   $0x80113060
801011d9:	e8 8b 43 00 00       	call   80105569 <acquire>
801011de:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e1:	c7 45 f4 94 30 11 80 	movl   $0x80113094,-0xc(%ebp)
801011e8:	eb 2d                	jmp    80101217 <filealloc+0x50>
    if(f->ref == 0){
801011ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011ed:	8b 40 04             	mov    0x4(%eax),%eax
801011f0:	85 c0                	test   %eax,%eax
801011f2:	75 1f                	jne    80101213 <filealloc+0x4c>
      f->ref = 1;
801011f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011f7:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 60 30 11 80       	push   $0x80113060
80101206:	e8 d0 43 00 00       	call   801055db <release>
8010120b:	83 c4 10             	add    $0x10,%esp
      return f;
8010120e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101211:	eb 23                	jmp    80101236 <filealloc+0x6f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101213:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101217:	b8 f4 39 11 80       	mov    $0x801139f4,%eax
8010121c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010121f:	72 c9                	jb     801011ea <filealloc+0x23>
    }
  }
  release(&ftable.lock);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 60 30 11 80       	push   $0x80113060
80101229:	e8 ad 43 00 00       	call   801055db <release>
8010122e:	83 c4 10             	add    $0x10,%esp
  return 0;
80101231:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101236:	c9                   	leave  
80101237:	c3                   	ret    

80101238 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101238:	f3 0f 1e fb          	endbr32 
8010123c:	55                   	push   %ebp
8010123d:	89 e5                	mov    %esp,%ebp
8010123f:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp
80101245:	68 60 30 11 80       	push   $0x80113060
8010124a:	e8 1a 43 00 00       	call   80105569 <acquire>
8010124f:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 40 04             	mov    0x4(%eax),%eax
80101258:	85 c0                	test   %eax,%eax
8010125a:	7f 0d                	jg     80101269 <filedup+0x31>
    panic("filedup");
8010125c:	83 ec 0c             	sub    $0xc,%esp
8010125f:	68 38 96 10 80       	push   $0x80109638
80101264:	e8 9f f3 ff ff       	call   80100608 <panic>
  f->ref++;
80101269:	8b 45 08             	mov    0x8(%ebp),%eax
8010126c:	8b 40 04             	mov    0x4(%eax),%eax
8010126f:	8d 50 01             	lea    0x1(%eax),%edx
80101272:	8b 45 08             	mov    0x8(%ebp),%eax
80101275:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101278:	83 ec 0c             	sub    $0xc,%esp
8010127b:	68 60 30 11 80       	push   $0x80113060
80101280:	e8 56 43 00 00       	call   801055db <release>
80101285:	83 c4 10             	add    $0x10,%esp
  return f;
80101288:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010128b:	c9                   	leave  
8010128c:	c3                   	ret    

8010128d <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010128d:	f3 0f 1e fb          	endbr32 
80101291:	55                   	push   %ebp
80101292:	89 e5                	mov    %esp,%ebp
80101294:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101297:	83 ec 0c             	sub    $0xc,%esp
8010129a:	68 60 30 11 80       	push   $0x80113060
8010129f:	e8 c5 42 00 00       	call   80105569 <acquire>
801012a4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801012a7:	8b 45 08             	mov    0x8(%ebp),%eax
801012aa:	8b 40 04             	mov    0x4(%eax),%eax
801012ad:	85 c0                	test   %eax,%eax
801012af:	7f 0d                	jg     801012be <fileclose+0x31>
    panic("fileclose");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 40 96 10 80       	push   $0x80109640
801012b9:	e8 4a f3 ff ff       	call   80100608 <panic>
  if(--f->ref > 0){
801012be:	8b 45 08             	mov    0x8(%ebp),%eax
801012c1:	8b 40 04             	mov    0x4(%eax),%eax
801012c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801012c7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ca:	89 50 04             	mov    %edx,0x4(%eax)
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 40 04             	mov    0x4(%eax),%eax
801012d3:	85 c0                	test   %eax,%eax
801012d5:	7e 15                	jle    801012ec <fileclose+0x5f>
    release(&ftable.lock);
801012d7:	83 ec 0c             	sub    $0xc,%esp
801012da:	68 60 30 11 80       	push   $0x80113060
801012df:	e8 f7 42 00 00       	call   801055db <release>
801012e4:	83 c4 10             	add    $0x10,%esp
801012e7:	e9 8b 00 00 00       	jmp    80101377 <fileclose+0xea>
    return;
  }
  ff = *f;
801012ec:	8b 45 08             	mov    0x8(%ebp),%eax
801012ef:	8b 10                	mov    (%eax),%edx
801012f1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801012f4:	8b 50 04             	mov    0x4(%eax),%edx
801012f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012fa:	8b 50 08             	mov    0x8(%eax),%edx
801012fd:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101300:	8b 50 0c             	mov    0xc(%eax),%edx
80101303:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101306:	8b 50 10             	mov    0x10(%eax),%edx
80101309:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010130c:	8b 40 14             	mov    0x14(%eax),%eax
8010130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101312:	8b 45 08             	mov    0x8(%ebp),%eax
80101315:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101325:	83 ec 0c             	sub    $0xc,%esp
80101328:	68 60 30 11 80       	push   $0x80113060
8010132d:	e8 a9 42 00 00       	call   801055db <release>
80101332:	83 c4 10             	add    $0x10,%esp

  if(ff.type == FD_PIPE)
80101335:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101338:	83 f8 01             	cmp    $0x1,%eax
8010133b:	75 19                	jne    80101356 <fileclose+0xc9>
    pipeclose(ff.pipe, ff.writable);
8010133d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101341:	0f be d0             	movsbl %al,%edx
80101344:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101347:	83 ec 08             	sub    $0x8,%esp
8010134a:	52                   	push   %edx
8010134b:	50                   	push   %eax
8010134c:	e8 e7 2e 00 00       	call   80104238 <pipeclose>
80101351:	83 c4 10             	add    $0x10,%esp
80101354:	eb 21                	jmp    80101377 <fileclose+0xea>
  else if(ff.type == FD_INODE){
80101356:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101359:	83 f8 02             	cmp    $0x2,%eax
8010135c:	75 19                	jne    80101377 <fileclose+0xea>
    begin_op();
8010135e:	e8 9f 24 00 00       	call   80103802 <begin_op>
    iput(ff.ip);
80101363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	50                   	push   %eax
8010136a:	e8 07 0a 00 00       	call   80101d76 <iput>
8010136f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101372:	e8 1b 25 00 00       	call   80103892 <end_op>
  }
}
80101377:	c9                   	leave  
80101378:	c3                   	ret    

80101379 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101379:	f3 0f 1e fb          	endbr32 
8010137d:	55                   	push   %ebp
8010137e:	89 e5                	mov    %esp,%ebp
80101380:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101383:	8b 45 08             	mov    0x8(%ebp),%eax
80101386:	8b 00                	mov    (%eax),%eax
80101388:	83 f8 02             	cmp    $0x2,%eax
8010138b:	75 40                	jne    801013cd <filestat+0x54>
    ilock(f->ip);
8010138d:	8b 45 08             	mov    0x8(%ebp),%eax
80101390:	8b 40 10             	mov    0x10(%eax),%eax
80101393:	83 ec 0c             	sub    $0xc,%esp
80101396:	50                   	push   %eax
80101397:	e8 71 08 00 00       	call   80101c0d <ilock>
8010139c:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	8b 40 10             	mov    0x10(%eax),%eax
801013a5:	83 ec 08             	sub    $0x8,%esp
801013a8:	ff 75 0c             	pushl  0xc(%ebp)
801013ab:	50                   	push   %eax
801013ac:	e8 1a 0d 00 00       	call   801020cb <stati>
801013b1:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	8b 40 10             	mov    0x10(%eax),%eax
801013ba:	83 ec 0c             	sub    $0xc,%esp
801013bd:	50                   	push   %eax
801013be:	e8 61 09 00 00       	call   80101d24 <iunlock>
801013c3:	83 c4 10             	add    $0x10,%esp
    return 0;
801013c6:	b8 00 00 00 00       	mov    $0x0,%eax
801013cb:	eb 05                	jmp    801013d2 <filestat+0x59>
  }
  return -1;
801013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013d2:	c9                   	leave  
801013d3:	c3                   	ret    

801013d4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801013d4:	f3 0f 1e fb          	endbr32 
801013d8:	55                   	push   %ebp
801013d9:	89 e5                	mov    %esp,%ebp
801013db:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801013de:	8b 45 08             	mov    0x8(%ebp),%eax
801013e1:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801013e5:	84 c0                	test   %al,%al
801013e7:	75 0a                	jne    801013f3 <fileread+0x1f>
    return -1;
801013e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ee:	e9 9b 00 00 00       	jmp    8010148e <fileread+0xba>
  if(f->type == FD_PIPE)
801013f3:	8b 45 08             	mov    0x8(%ebp),%eax
801013f6:	8b 00                	mov    (%eax),%eax
801013f8:	83 f8 01             	cmp    $0x1,%eax
801013fb:	75 1a                	jne    80101417 <fileread+0x43>
    return piperead(f->pipe, addr, n);
801013fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101400:	8b 40 0c             	mov    0xc(%eax),%eax
80101403:	83 ec 04             	sub    $0x4,%esp
80101406:	ff 75 10             	pushl  0x10(%ebp)
80101409:	ff 75 0c             	pushl  0xc(%ebp)
8010140c:	50                   	push   %eax
8010140d:	e8 db 2f 00 00       	call   801043ed <piperead>
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	eb 77                	jmp    8010148e <fileread+0xba>
  if(f->type == FD_INODE){
80101417:	8b 45 08             	mov    0x8(%ebp),%eax
8010141a:	8b 00                	mov    (%eax),%eax
8010141c:	83 f8 02             	cmp    $0x2,%eax
8010141f:	75 60                	jne    80101481 <fileread+0xad>
    ilock(f->ip);
80101421:	8b 45 08             	mov    0x8(%ebp),%eax
80101424:	8b 40 10             	mov    0x10(%eax),%eax
80101427:	83 ec 0c             	sub    $0xc,%esp
8010142a:	50                   	push   %eax
8010142b:	e8 dd 07 00 00       	call   80101c0d <ilock>
80101430:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101433:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101436:	8b 45 08             	mov    0x8(%ebp),%eax
80101439:	8b 50 14             	mov    0x14(%eax),%edx
8010143c:	8b 45 08             	mov    0x8(%ebp),%eax
8010143f:	8b 40 10             	mov    0x10(%eax),%eax
80101442:	51                   	push   %ecx
80101443:	52                   	push   %edx
80101444:	ff 75 0c             	pushl  0xc(%ebp)
80101447:	50                   	push   %eax
80101448:	e8 c8 0c 00 00       	call   80102115 <readi>
8010144d:	83 c4 10             	add    $0x10,%esp
80101450:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101457:	7e 11                	jle    8010146a <fileread+0x96>
      f->off += r;
80101459:	8b 45 08             	mov    0x8(%ebp),%eax
8010145c:	8b 50 14             	mov    0x14(%eax),%edx
8010145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101462:	01 c2                	add    %eax,%edx
80101464:	8b 45 08             	mov    0x8(%ebp),%eax
80101467:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010146a:	8b 45 08             	mov    0x8(%ebp),%eax
8010146d:	8b 40 10             	mov    0x10(%eax),%eax
80101470:	83 ec 0c             	sub    $0xc,%esp
80101473:	50                   	push   %eax
80101474:	e8 ab 08 00 00       	call   80101d24 <iunlock>
80101479:	83 c4 10             	add    $0x10,%esp
    return r;
8010147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010147f:	eb 0d                	jmp    8010148e <fileread+0xba>
  }
  panic("fileread");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 4a 96 10 80       	push   $0x8010964a
80101489:	e8 7a f1 ff ff       	call   80100608 <panic>
}
8010148e:	c9                   	leave  
8010148f:	c3                   	ret    

80101490 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101490:	f3 0f 1e fb          	endbr32 
80101494:	55                   	push   %ebp
80101495:	89 e5                	mov    %esp,%ebp
80101497:	53                   	push   %ebx
80101498:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010149b:	8b 45 08             	mov    0x8(%ebp),%eax
8010149e:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801014a2:	84 c0                	test   %al,%al
801014a4:	75 0a                	jne    801014b0 <filewrite+0x20>
    return -1;
801014a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014ab:	e9 1b 01 00 00       	jmp    801015cb <filewrite+0x13b>
  if(f->type == FD_PIPE)
801014b0:	8b 45 08             	mov    0x8(%ebp),%eax
801014b3:	8b 00                	mov    (%eax),%eax
801014b5:	83 f8 01             	cmp    $0x1,%eax
801014b8:	75 1d                	jne    801014d7 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801014ba:	8b 45 08             	mov    0x8(%ebp),%eax
801014bd:	8b 40 0c             	mov    0xc(%eax),%eax
801014c0:	83 ec 04             	sub    $0x4,%esp
801014c3:	ff 75 10             	pushl  0x10(%ebp)
801014c6:	ff 75 0c             	pushl  0xc(%ebp)
801014c9:	50                   	push   %eax
801014ca:	e8 18 2e 00 00       	call   801042e7 <pipewrite>
801014cf:	83 c4 10             	add    $0x10,%esp
801014d2:	e9 f4 00 00 00       	jmp    801015cb <filewrite+0x13b>
  if(f->type == FD_INODE){
801014d7:	8b 45 08             	mov    0x8(%ebp),%eax
801014da:	8b 00                	mov    (%eax),%eax
801014dc:	83 f8 02             	cmp    $0x2,%eax
801014df:	0f 85 d9 00 00 00    	jne    801015be <filewrite+0x12e>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
801014e5:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801014ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801014f3:	e9 a3 00 00 00       	jmp    8010159b <filewrite+0x10b>
      int n1 = n - i;
801014f8:	8b 45 10             	mov    0x10(%ebp),%eax
801014fb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801014fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101501:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101504:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101507:	7e 06                	jle    8010150f <filewrite+0x7f>
        n1 = max;
80101509:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010150c:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010150f:	e8 ee 22 00 00       	call   80103802 <begin_op>
      ilock(f->ip);
80101514:	8b 45 08             	mov    0x8(%ebp),%eax
80101517:	8b 40 10             	mov    0x10(%eax),%eax
8010151a:	83 ec 0c             	sub    $0xc,%esp
8010151d:	50                   	push   %eax
8010151e:	e8 ea 06 00 00       	call   80101c0d <ilock>
80101523:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101526:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101529:	8b 45 08             	mov    0x8(%ebp),%eax
8010152c:	8b 50 14             	mov    0x14(%eax),%edx
8010152f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101532:	8b 45 0c             	mov    0xc(%ebp),%eax
80101535:	01 c3                	add    %eax,%ebx
80101537:	8b 45 08             	mov    0x8(%ebp),%eax
8010153a:	8b 40 10             	mov    0x10(%eax),%eax
8010153d:	51                   	push   %ecx
8010153e:	52                   	push   %edx
8010153f:	53                   	push   %ebx
80101540:	50                   	push   %eax
80101541:	e8 28 0d 00 00       	call   8010226e <writei>
80101546:	83 c4 10             	add    $0x10,%esp
80101549:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010154c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101550:	7e 11                	jle    80101563 <filewrite+0xd3>
        f->off += r;
80101552:	8b 45 08             	mov    0x8(%ebp),%eax
80101555:	8b 50 14             	mov    0x14(%eax),%edx
80101558:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010155b:	01 c2                	add    %eax,%edx
8010155d:	8b 45 08             	mov    0x8(%ebp),%eax
80101560:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101563:	8b 45 08             	mov    0x8(%ebp),%eax
80101566:	8b 40 10             	mov    0x10(%eax),%eax
80101569:	83 ec 0c             	sub    $0xc,%esp
8010156c:	50                   	push   %eax
8010156d:	e8 b2 07 00 00       	call   80101d24 <iunlock>
80101572:	83 c4 10             	add    $0x10,%esp
      end_op();
80101575:	e8 18 23 00 00       	call   80103892 <end_op>

      if(r < 0)
8010157a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010157e:	78 29                	js     801015a9 <filewrite+0x119>
        break;
      if(r != n1)
80101580:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101583:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101586:	74 0d                	je     80101595 <filewrite+0x105>
        panic("short filewrite");
80101588:	83 ec 0c             	sub    $0xc,%esp
8010158b:	68 53 96 10 80       	push   $0x80109653
80101590:	e8 73 f0 ff ff       	call   80100608 <panic>
      i += r;
80101595:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101598:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159e:	3b 45 10             	cmp    0x10(%ebp),%eax
801015a1:	0f 8c 51 ff ff ff    	jl     801014f8 <filewrite+0x68>
801015a7:	eb 01                	jmp    801015aa <filewrite+0x11a>
        break;
801015a9:	90                   	nop
    }
    return i == n ? n : -1;
801015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ad:	3b 45 10             	cmp    0x10(%ebp),%eax
801015b0:	75 05                	jne    801015b7 <filewrite+0x127>
801015b2:	8b 45 10             	mov    0x10(%ebp),%eax
801015b5:	eb 14                	jmp    801015cb <filewrite+0x13b>
801015b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015bc:	eb 0d                	jmp    801015cb <filewrite+0x13b>
  }
  panic("filewrite");
801015be:	83 ec 0c             	sub    $0xc,%esp
801015c1:	68 63 96 10 80       	push   $0x80109663
801015c6:	e8 3d f0 ff ff       	call   80100608 <panic>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	c9                   	leave  
801015cf:	c3                   	ret    

801015d0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801015d0:	f3 0f 1e fb          	endbr32 
801015d4:	55                   	push   %ebp
801015d5:	89 e5                	mov    %esp,%ebp
801015d7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801015da:	8b 45 08             	mov    0x8(%ebp),%eax
801015dd:	83 ec 08             	sub    $0x8,%esp
801015e0:	6a 01                	push   $0x1
801015e2:	50                   	push   %eax
801015e3:	e8 ef eb ff ff       	call   801001d7 <bread>
801015e8:	83 c4 10             	add    $0x10,%esp
801015eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801015ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f1:	83 c0 5c             	add    $0x5c,%eax
801015f4:	83 ec 04             	sub    $0x4,%esp
801015f7:	6a 1c                	push   $0x1c
801015f9:	50                   	push   %eax
801015fa:	ff 75 0c             	pushl  0xc(%ebp)
801015fd:	e8 cd 42 00 00       	call   801058cf <memmove>
80101602:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101605:	83 ec 0c             	sub    $0xc,%esp
80101608:	ff 75 f4             	pushl  -0xc(%ebp)
8010160b:	e8 51 ec ff ff       	call   80100261 <brelse>
80101610:	83 c4 10             	add    $0x10,%esp
}
80101613:	90                   	nop
80101614:	c9                   	leave  
80101615:	c3                   	ret    

80101616 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101616:	f3 0f 1e fb          	endbr32 
8010161a:	55                   	push   %ebp
8010161b:	89 e5                	mov    %esp,%ebp
8010161d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101620:	8b 55 0c             	mov    0xc(%ebp),%edx
80101623:	8b 45 08             	mov    0x8(%ebp),%eax
80101626:	83 ec 08             	sub    $0x8,%esp
80101629:	52                   	push   %edx
8010162a:	50                   	push   %eax
8010162b:	e8 a7 eb ff ff       	call   801001d7 <bread>
80101630:	83 c4 10             	add    $0x10,%esp
80101633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101639:	83 c0 5c             	add    $0x5c,%eax
8010163c:	83 ec 04             	sub    $0x4,%esp
8010163f:	68 00 02 00 00       	push   $0x200
80101644:	6a 00                	push   $0x0
80101646:	50                   	push   %eax
80101647:	e8 bc 41 00 00       	call   80105808 <memset>
8010164c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010164f:	83 ec 0c             	sub    $0xc,%esp
80101652:	ff 75 f4             	pushl  -0xc(%ebp)
80101655:	e8 f1 23 00 00       	call   80103a4b <log_write>
8010165a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010165d:	83 ec 0c             	sub    $0xc,%esp
80101660:	ff 75 f4             	pushl  -0xc(%ebp)
80101663:	e8 f9 eb ff ff       	call   80100261 <brelse>
80101668:	83 c4 10             	add    $0x10,%esp
}
8010166b:	90                   	nop
8010166c:	c9                   	leave  
8010166d:	c3                   	ret    

8010166e <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010166e:	f3 0f 1e fb          	endbr32 
80101672:	55                   	push   %ebp
80101673:	89 e5                	mov    %esp,%ebp
80101675:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101678:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010167f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101686:	e9 13 01 00 00       	jmp    8010179e <balloc+0x130>
    bp = bread(dev, BBLOCK(b, sb));
8010168b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101694:	85 c0                	test   %eax,%eax
80101696:	0f 48 c2             	cmovs  %edx,%eax
80101699:	c1 f8 0c             	sar    $0xc,%eax
8010169c:	89 c2                	mov    %eax,%edx
8010169e:	a1 78 3a 11 80       	mov    0x80113a78,%eax
801016a3:	01 d0                	add    %edx,%eax
801016a5:	83 ec 08             	sub    $0x8,%esp
801016a8:	50                   	push   %eax
801016a9:	ff 75 08             	pushl  0x8(%ebp)
801016ac:	e8 26 eb ff ff       	call   801001d7 <bread>
801016b1:	83 c4 10             	add    $0x10,%esp
801016b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801016be:	e9 a6 00 00 00       	jmp    80101769 <balloc+0xfb>
      m = 1 << (bi % 8);
801016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c6:	99                   	cltd   
801016c7:	c1 ea 1d             	shr    $0x1d,%edx
801016ca:	01 d0                	add    %edx,%eax
801016cc:	83 e0 07             	and    $0x7,%eax
801016cf:	29 d0                	sub    %edx,%eax
801016d1:	ba 01 00 00 00       	mov    $0x1,%edx
801016d6:	89 c1                	mov    %eax,%ecx
801016d8:	d3 e2                	shl    %cl,%edx
801016da:	89 d0                	mov    %edx,%eax
801016dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016e2:	8d 50 07             	lea    0x7(%eax),%edx
801016e5:	85 c0                	test   %eax,%eax
801016e7:	0f 48 c2             	cmovs  %edx,%eax
801016ea:	c1 f8 03             	sar    $0x3,%eax
801016ed:	89 c2                	mov    %eax,%edx
801016ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016f2:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801016f7:	0f b6 c0             	movzbl %al,%eax
801016fa:	23 45 e8             	and    -0x18(%ebp),%eax
801016fd:	85 c0                	test   %eax,%eax
801016ff:	75 64                	jne    80101765 <balloc+0xf7>
        bp->data[bi/8] |= m;  // Mark block in use.
80101701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101704:	8d 50 07             	lea    0x7(%eax),%edx
80101707:	85 c0                	test   %eax,%eax
80101709:	0f 48 c2             	cmovs  %edx,%eax
8010170c:	c1 f8 03             	sar    $0x3,%eax
8010170f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101712:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101717:	89 d1                	mov    %edx,%ecx
80101719:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010171c:	09 ca                	or     %ecx,%edx
8010171e:	89 d1                	mov    %edx,%ecx
80101720:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101723:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	ff 75 ec             	pushl  -0x14(%ebp)
8010172d:	e8 19 23 00 00       	call   80103a4b <log_write>
80101732:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101735:	83 ec 0c             	sub    $0xc,%esp
80101738:	ff 75 ec             	pushl  -0x14(%ebp)
8010173b:	e8 21 eb ff ff       	call   80100261 <brelse>
80101740:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101743:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101746:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101749:	01 c2                	add    %eax,%edx
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	52                   	push   %edx
80101752:	50                   	push   %eax
80101753:	e8 be fe ff ff       	call   80101616 <bzero>
80101758:	83 c4 10             	add    $0x10,%esp
        return b + bi;
8010175b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101761:	01 d0                	add    %edx,%eax
80101763:	eb 57                	jmp    801017bc <balloc+0x14e>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101765:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101769:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101770:	7f 17                	jg     80101789 <balloc+0x11b>
80101772:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101778:	01 d0                	add    %edx,%eax
8010177a:	89 c2                	mov    %eax,%edx
8010177c:	a1 60 3a 11 80       	mov    0x80113a60,%eax
80101781:	39 c2                	cmp    %eax,%edx
80101783:	0f 82 3a ff ff ff    	jb     801016c3 <balloc+0x55>
      }
    }
    brelse(bp);
80101789:	83 ec 0c             	sub    $0xc,%esp
8010178c:	ff 75 ec             	pushl  -0x14(%ebp)
8010178f:	e8 cd ea ff ff       	call   80100261 <brelse>
80101794:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101797:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010179e:	8b 15 60 3a 11 80    	mov    0x80113a60,%edx
801017a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a7:	39 c2                	cmp    %eax,%edx
801017a9:	0f 87 dc fe ff ff    	ja     8010168b <balloc+0x1d>
  }
  panic("balloc: out of blocks");
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	68 70 96 10 80       	push   $0x80109670
801017b7:	e8 4c ee ff ff       	call   80100608 <panic>
}
801017bc:	c9                   	leave  
801017bd:	c3                   	ret    

801017be <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801017be:	f3 0f 1e fb          	endbr32 
801017c2:	55                   	push   %ebp
801017c3:	89 e5                	mov    %esp,%ebp
801017c5:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801017c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801017cb:	c1 e8 0c             	shr    $0xc,%eax
801017ce:	89 c2                	mov    %eax,%edx
801017d0:	a1 78 3a 11 80       	mov    0x80113a78,%eax
801017d5:	01 c2                	add    %eax,%edx
801017d7:	8b 45 08             	mov    0x8(%ebp),%eax
801017da:	83 ec 08             	sub    $0x8,%esp
801017dd:	52                   	push   %edx
801017de:	50                   	push   %eax
801017df:	e8 f3 e9 ff ff       	call   801001d7 <bread>
801017e4:	83 c4 10             	add    $0x10,%esp
801017e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801017ed:	25 ff 0f 00 00       	and    $0xfff,%eax
801017f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801017f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f8:	99                   	cltd   
801017f9:	c1 ea 1d             	shr    $0x1d,%edx
801017fc:	01 d0                	add    %edx,%eax
801017fe:	83 e0 07             	and    $0x7,%eax
80101801:	29 d0                	sub    %edx,%eax
80101803:	ba 01 00 00 00       	mov    $0x1,%edx
80101808:	89 c1                	mov    %eax,%ecx
8010180a:	d3 e2                	shl    %cl,%edx
8010180c:	89 d0                	mov    %edx,%eax
8010180e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101814:	8d 50 07             	lea    0x7(%eax),%edx
80101817:	85 c0                	test   %eax,%eax
80101819:	0f 48 c2             	cmovs  %edx,%eax
8010181c:	c1 f8 03             	sar    $0x3,%eax
8010181f:	89 c2                	mov    %eax,%edx
80101821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101824:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101829:	0f b6 c0             	movzbl %al,%eax
8010182c:	23 45 ec             	and    -0x14(%ebp),%eax
8010182f:	85 c0                	test   %eax,%eax
80101831:	75 0d                	jne    80101840 <bfree+0x82>
    panic("freeing free block");
80101833:	83 ec 0c             	sub    $0xc,%esp
80101836:	68 86 96 10 80       	push   $0x80109686
8010183b:	e8 c8 ed ff ff       	call   80100608 <panic>
  bp->data[bi/8] &= ~m;
80101840:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101843:	8d 50 07             	lea    0x7(%eax),%edx
80101846:	85 c0                	test   %eax,%eax
80101848:	0f 48 c2             	cmovs  %edx,%eax
8010184b:	c1 f8 03             	sar    $0x3,%eax
8010184e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101851:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101856:	89 d1                	mov    %edx,%ecx
80101858:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010185b:	f7 d2                	not    %edx
8010185d:	21 ca                	and    %ecx,%edx
8010185f:	89 d1                	mov    %edx,%ecx
80101861:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101864:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
80101868:	83 ec 0c             	sub    $0xc,%esp
8010186b:	ff 75 f4             	pushl  -0xc(%ebp)
8010186e:	e8 d8 21 00 00       	call   80103a4b <log_write>
80101873:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	ff 75 f4             	pushl  -0xc(%ebp)
8010187c:	e8 e0 e9 ff ff       	call   80100261 <brelse>
80101881:	83 c4 10             	add    $0x10,%esp
}
80101884:	90                   	nop
80101885:	c9                   	leave  
80101886:	c3                   	ret    

80101887 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101887:	f3 0f 1e fb          	endbr32 
8010188b:	55                   	push   %ebp
8010188c:	89 e5                	mov    %esp,%ebp
8010188e:	57                   	push   %edi
8010188f:	56                   	push   %esi
80101890:	53                   	push   %ebx
80101891:	83 ec 2c             	sub    $0x2c,%esp
  int i = 0;
80101894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
8010189b:	83 ec 08             	sub    $0x8,%esp
8010189e:	68 99 96 10 80       	push   $0x80109699
801018a3:	68 80 3a 11 80       	push   $0x80113a80
801018a8:	e8 96 3c 00 00       	call   80105543 <initlock>
801018ad:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801018b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801018b7:	eb 2d                	jmp    801018e6 <iinit+0x5f>
    initsleeplock(&icache.inode[i].lock, "inode");
801018b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801018bc:	89 d0                	mov    %edx,%eax
801018be:	c1 e0 03             	shl    $0x3,%eax
801018c1:	01 d0                	add    %edx,%eax
801018c3:	c1 e0 04             	shl    $0x4,%eax
801018c6:	83 c0 30             	add    $0x30,%eax
801018c9:	05 80 3a 11 80       	add    $0x80113a80,%eax
801018ce:	83 c0 10             	add    $0x10,%eax
801018d1:	83 ec 08             	sub    $0x8,%esp
801018d4:	68 a0 96 10 80       	push   $0x801096a0
801018d9:	50                   	push   %eax
801018da:	e8 d1 3a 00 00       	call   801053b0 <initsleeplock>
801018df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NINODE; i++) {
801018e2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801018e6:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801018ea:	7e cd                	jle    801018b9 <iinit+0x32>
  }

  readsb(dev, &sb);
801018ec:	83 ec 08             	sub    $0x8,%esp
801018ef:	68 60 3a 11 80       	push   $0x80113a60
801018f4:	ff 75 08             	pushl  0x8(%ebp)
801018f7:	e8 d4 fc ff ff       	call   801015d0 <readsb>
801018fc:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018ff:	a1 78 3a 11 80       	mov    0x80113a78,%eax
80101904:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101907:	8b 3d 74 3a 11 80    	mov    0x80113a74,%edi
8010190d:	8b 35 70 3a 11 80    	mov    0x80113a70,%esi
80101913:	8b 1d 6c 3a 11 80    	mov    0x80113a6c,%ebx
80101919:	8b 0d 68 3a 11 80    	mov    0x80113a68,%ecx
8010191f:	8b 15 64 3a 11 80    	mov    0x80113a64,%edx
80101925:	a1 60 3a 11 80       	mov    0x80113a60,%eax
8010192a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010192d:	57                   	push   %edi
8010192e:	56                   	push   %esi
8010192f:	53                   	push   %ebx
80101930:	51                   	push   %ecx
80101931:	52                   	push   %edx
80101932:	50                   	push   %eax
80101933:	68 a8 96 10 80       	push   $0x801096a8
80101938:	e8 db ea ff ff       	call   80100418 <cprintf>
8010193d:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101940:	90                   	nop
80101941:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101944:	5b                   	pop    %ebx
80101945:	5e                   	pop    %esi
80101946:	5f                   	pop    %edi
80101947:	5d                   	pop    %ebp
80101948:	c3                   	ret    

80101949 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101949:	f3 0f 1e fb          	endbr32 
8010194d:	55                   	push   %ebp
8010194e:	89 e5                	mov    %esp,%ebp
80101950:	83 ec 28             	sub    $0x28,%esp
80101953:	8b 45 0c             	mov    0xc(%ebp),%eax
80101956:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010195a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101961:	e9 9e 00 00 00       	jmp    80101a04 <ialloc+0xbb>
    bp = bread(dev, IBLOCK(inum, sb));
80101966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101969:	c1 e8 03             	shr    $0x3,%eax
8010196c:	89 c2                	mov    %eax,%edx
8010196e:	a1 74 3a 11 80       	mov    0x80113a74,%eax
80101973:	01 d0                	add    %edx,%eax
80101975:	83 ec 08             	sub    $0x8,%esp
80101978:	50                   	push   %eax
80101979:	ff 75 08             	pushl  0x8(%ebp)
8010197c:	e8 56 e8 ff ff       	call   801001d7 <bread>
80101981:	83 c4 10             	add    $0x10,%esp
80101984:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101987:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101990:	83 e0 07             	and    $0x7,%eax
80101993:	c1 e0 06             	shl    $0x6,%eax
80101996:	01 d0                	add    %edx,%eax
80101998:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
8010199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010199e:	0f b7 00             	movzwl (%eax),%eax
801019a1:	66 85 c0             	test   %ax,%ax
801019a4:	75 4c                	jne    801019f2 <ialloc+0xa9>
      memset(dip, 0, sizeof(*dip));
801019a6:	83 ec 04             	sub    $0x4,%esp
801019a9:	6a 40                	push   $0x40
801019ab:	6a 00                	push   $0x0
801019ad:	ff 75 ec             	pushl  -0x14(%ebp)
801019b0:	e8 53 3e 00 00       	call   80105808 <memset>
801019b5:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801019b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801019bb:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801019bf:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801019c2:	83 ec 0c             	sub    $0xc,%esp
801019c5:	ff 75 f0             	pushl  -0x10(%ebp)
801019c8:	e8 7e 20 00 00       	call   80103a4b <log_write>
801019cd:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 f0             	pushl  -0x10(%ebp)
801019d6:	e8 86 e8 ff ff       	call   80100261 <brelse>
801019db:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e1:	83 ec 08             	sub    $0x8,%esp
801019e4:	50                   	push   %eax
801019e5:	ff 75 08             	pushl  0x8(%ebp)
801019e8:	e8 fc 00 00 00       	call   80101ae9 <iget>
801019ed:	83 c4 10             	add    $0x10,%esp
801019f0:	eb 30                	jmp    80101a22 <ialloc+0xd9>
    }
    brelse(bp);
801019f2:	83 ec 0c             	sub    $0xc,%esp
801019f5:	ff 75 f0             	pushl  -0x10(%ebp)
801019f8:	e8 64 e8 ff ff       	call   80100261 <brelse>
801019fd:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101a00:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101a04:	8b 15 68 3a 11 80    	mov    0x80113a68,%edx
80101a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0d:	39 c2                	cmp    %eax,%edx
80101a0f:	0f 87 51 ff ff ff    	ja     80101966 <ialloc+0x1d>
  }
  panic("ialloc: no inodes");
80101a15:	83 ec 0c             	sub    $0xc,%esp
80101a18:	68 fb 96 10 80       	push   $0x801096fb
80101a1d:	e8 e6 eb ff ff       	call   80100608 <panic>
}
80101a22:	c9                   	leave  
80101a23:	c3                   	ret    

80101a24 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101a24:	f3 0f 1e fb          	endbr32 
80101a28:	55                   	push   %ebp
80101a29:	89 e5                	mov    %esp,%ebp
80101a2b:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a31:	8b 40 04             	mov    0x4(%eax),%eax
80101a34:	c1 e8 03             	shr    $0x3,%eax
80101a37:	89 c2                	mov    %eax,%edx
80101a39:	a1 74 3a 11 80       	mov    0x80113a74,%eax
80101a3e:	01 c2                	add    %eax,%edx
80101a40:	8b 45 08             	mov    0x8(%ebp),%eax
80101a43:	8b 00                	mov    (%eax),%eax
80101a45:	83 ec 08             	sub    $0x8,%esp
80101a48:	52                   	push   %edx
80101a49:	50                   	push   %eax
80101a4a:	e8 88 e7 ff ff       	call   801001d7 <bread>
80101a4f:	83 c4 10             	add    $0x10,%esp
80101a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a58:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5e:	8b 40 04             	mov    0x4(%eax),%eax
80101a61:	83 e0 07             	and    $0x7,%eax
80101a64:	c1 e0 06             	shl    $0x6,%eax
80101a67:	01 d0                	add    %edx,%eax
80101a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6f:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a76:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a83:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101a87:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8a:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a91:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a9f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	8b 50 58             	mov    0x58(%eax),%edx
80101aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aac:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab2:	8d 50 5c             	lea    0x5c(%eax),%edx
80101ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ab8:	83 c0 0c             	add    $0xc,%eax
80101abb:	83 ec 04             	sub    $0x4,%esp
80101abe:	6a 34                	push   $0x34
80101ac0:	52                   	push   %edx
80101ac1:	50                   	push   %eax
80101ac2:	e8 08 3e 00 00       	call   801058cf <memmove>
80101ac7:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101aca:	83 ec 0c             	sub    $0xc,%esp
80101acd:	ff 75 f4             	pushl  -0xc(%ebp)
80101ad0:	e8 76 1f 00 00       	call   80103a4b <log_write>
80101ad5:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101ad8:	83 ec 0c             	sub    $0xc,%esp
80101adb:	ff 75 f4             	pushl  -0xc(%ebp)
80101ade:	e8 7e e7 ff ff       	call   80100261 <brelse>
80101ae3:	83 c4 10             	add    $0x10,%esp
}
80101ae6:	90                   	nop
80101ae7:	c9                   	leave  
80101ae8:	c3                   	ret    

80101ae9 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101ae9:	f3 0f 1e fb          	endbr32 
80101aed:	55                   	push   %ebp
80101aee:	89 e5                	mov    %esp,%ebp
80101af0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101af3:	83 ec 0c             	sub    $0xc,%esp
80101af6:	68 80 3a 11 80       	push   $0x80113a80
80101afb:	e8 69 3a 00 00       	call   80105569 <acquire>
80101b00:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101b03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b0a:	c7 45 f4 b4 3a 11 80 	movl   $0x80113ab4,-0xc(%ebp)
80101b11:	eb 60                	jmp    80101b73 <iget+0x8a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b16:	8b 40 08             	mov    0x8(%eax),%eax
80101b19:	85 c0                	test   %eax,%eax
80101b1b:	7e 39                	jle    80101b56 <iget+0x6d>
80101b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b20:	8b 00                	mov    (%eax),%eax
80101b22:	39 45 08             	cmp    %eax,0x8(%ebp)
80101b25:	75 2f                	jne    80101b56 <iget+0x6d>
80101b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b2a:	8b 40 04             	mov    0x4(%eax),%eax
80101b2d:	39 45 0c             	cmp    %eax,0xc(%ebp)
80101b30:	75 24                	jne    80101b56 <iget+0x6d>
      ip->ref++;
80101b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b35:	8b 40 08             	mov    0x8(%eax),%eax
80101b38:	8d 50 01             	lea    0x1(%eax),%edx
80101b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b3e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	68 80 3a 11 80       	push   $0x80113a80
80101b49:	e8 8d 3a 00 00       	call   801055db <release>
80101b4e:	83 c4 10             	add    $0x10,%esp
      return ip;
80101b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b54:	eb 77                	jmp    80101bcd <iget+0xe4>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101b56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101b5a:	75 10                	jne    80101b6c <iget+0x83>
80101b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b5f:	8b 40 08             	mov    0x8(%eax),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	75 06                	jne    80101b6c <iget+0x83>
      empty = ip;
80101b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101b6c:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101b73:	81 7d f4 d4 56 11 80 	cmpl   $0x801156d4,-0xc(%ebp)
80101b7a:	72 97                	jb     80101b13 <iget+0x2a>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101b80:	75 0d                	jne    80101b8f <iget+0xa6>
    panic("iget: no inodes");
80101b82:	83 ec 0c             	sub    $0xc,%esp
80101b85:	68 0d 97 10 80       	push   $0x8010970d
80101b8a:	e8 79 ea ff ff       	call   80100608 <panic>

  ip = empty;
80101b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b98:	8b 55 08             	mov    0x8(%ebp),%edx
80101b9b:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ba3:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ba9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bb3:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
80101bba:	83 ec 0c             	sub    $0xc,%esp
80101bbd:	68 80 3a 11 80       	push   $0x80113a80
80101bc2:	e8 14 3a 00 00       	call   801055db <release>
80101bc7:	83 c4 10             	add    $0x10,%esp

  return ip;
80101bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101bcd:	c9                   	leave  
80101bce:	c3                   	ret    

80101bcf <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101bcf:	f3 0f 1e fb          	endbr32 
80101bd3:	55                   	push   %ebp
80101bd4:	89 e5                	mov    %esp,%ebp
80101bd6:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bd9:	83 ec 0c             	sub    $0xc,%esp
80101bdc:	68 80 3a 11 80       	push   $0x80113a80
80101be1:	e8 83 39 00 00       	call   80105569 <acquire>
80101be6:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 40 08             	mov    0x8(%eax),%eax
80101bef:	8d 50 01             	lea    0x1(%eax),%edx
80101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bf8:	83 ec 0c             	sub    $0xc,%esp
80101bfb:	68 80 3a 11 80       	push   $0x80113a80
80101c00:	e8 d6 39 00 00       	call   801055db <release>
80101c05:	83 c4 10             	add    $0x10,%esp
  return ip;
80101c08:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101c0b:	c9                   	leave  
80101c0c:	c3                   	ret    

80101c0d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101c0d:	f3 0f 1e fb          	endbr32 
80101c11:	55                   	push   %ebp
80101c12:	89 e5                	mov    %esp,%ebp
80101c14:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c1b:	74 0a                	je     80101c27 <ilock+0x1a>
80101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c20:	8b 40 08             	mov    0x8(%eax),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	7f 0d                	jg     80101c34 <ilock+0x27>
    panic("ilock");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 1d 97 10 80       	push   $0x8010971d
80101c2f:	e8 d4 e9 ff ff       	call   80100608 <panic>

  acquiresleep(&ip->lock);
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	83 c0 0c             	add    $0xc,%eax
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	50                   	push   %eax
80101c3e:	e8 ad 37 00 00       	call   801053f0 <acquiresleep>
80101c43:	83 c4 10             	add    $0x10,%esp

  if(ip->valid == 0){
80101c46:	8b 45 08             	mov    0x8(%ebp),%eax
80101c49:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c4c:	85 c0                	test   %eax,%eax
80101c4e:	0f 85 cd 00 00 00    	jne    80101d21 <ilock+0x114>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 40 04             	mov    0x4(%eax),%eax
80101c5a:	c1 e8 03             	shr    $0x3,%eax
80101c5d:	89 c2                	mov    %eax,%edx
80101c5f:	a1 74 3a 11 80       	mov    0x80113a74,%eax
80101c64:	01 c2                	add    %eax,%edx
80101c66:	8b 45 08             	mov    0x8(%ebp),%eax
80101c69:	8b 00                	mov    (%eax),%eax
80101c6b:	83 ec 08             	sub    $0x8,%esp
80101c6e:	52                   	push   %edx
80101c6f:	50                   	push   %eax
80101c70:	e8 62 e5 ff ff       	call   801001d7 <bread>
80101c75:	83 c4 10             	add    $0x10,%esp
80101c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7e:	8d 50 5c             	lea    0x5c(%eax),%edx
80101c81:	8b 45 08             	mov    0x8(%ebp),%eax
80101c84:	8b 40 04             	mov    0x4(%eax),%eax
80101c87:	83 e0 07             	and    $0x7,%eax
80101c8a:	c1 e0 06             	shl    $0x6,%eax
80101c8d:	01 d0                	add    %edx,%eax
80101c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c95:	0f b7 10             	movzwl (%eax),%edx
80101c98:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9b:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca2:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca9:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb0:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb7:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cbe:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ccc:	8b 50 08             	mov    0x8(%eax),%edx
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd8:	8d 50 0c             	lea    0xc(%eax),%edx
80101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cde:	83 c0 5c             	add    $0x5c,%eax
80101ce1:	83 ec 04             	sub    $0x4,%esp
80101ce4:	6a 34                	push   $0x34
80101ce6:	52                   	push   %edx
80101ce7:	50                   	push   %eax
80101ce8:	e8 e2 3b 00 00       	call   801058cf <memmove>
80101ced:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101cf0:	83 ec 0c             	sub    $0xc,%esp
80101cf3:	ff 75 f4             	pushl  -0xc(%ebp)
80101cf6:	e8 66 e5 ff ff       	call   80100261 <brelse>
80101cfb:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
80101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80101d01:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101d08:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101d0f:	66 85 c0             	test   %ax,%ax
80101d12:	75 0d                	jne    80101d21 <ilock+0x114>
      panic("ilock: no type");
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	68 23 97 10 80       	push   $0x80109723
80101d1c:	e8 e7 e8 ff ff       	call   80100608 <panic>
  }
}
80101d21:	90                   	nop
80101d22:	c9                   	leave  
80101d23:	c3                   	ret    

80101d24 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101d24:	f3 0f 1e fb          	endbr32 
80101d28:	55                   	push   %ebp
80101d29:	89 e5                	mov    %esp,%ebp
80101d2b:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101d32:	74 20                	je     80101d54 <iunlock+0x30>
80101d34:	8b 45 08             	mov    0x8(%ebp),%eax
80101d37:	83 c0 0c             	add    $0xc,%eax
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	50                   	push   %eax
80101d3e:	e8 67 37 00 00       	call   801054aa <holdingsleep>
80101d43:	83 c4 10             	add    $0x10,%esp
80101d46:	85 c0                	test   %eax,%eax
80101d48:	74 0a                	je     80101d54 <iunlock+0x30>
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	8b 40 08             	mov    0x8(%eax),%eax
80101d50:	85 c0                	test   %eax,%eax
80101d52:	7f 0d                	jg     80101d61 <iunlock+0x3d>
    panic("iunlock");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 32 97 10 80       	push   $0x80109732
80101d5c:	e8 a7 e8 ff ff       	call   80100608 <panic>

  releasesleep(&ip->lock);
80101d61:	8b 45 08             	mov    0x8(%ebp),%eax
80101d64:	83 c0 0c             	add    $0xc,%eax
80101d67:	83 ec 0c             	sub    $0xc,%esp
80101d6a:	50                   	push   %eax
80101d6b:	e8 e8 36 00 00       	call   80105458 <releasesleep>
80101d70:	83 c4 10             	add    $0x10,%esp
}
80101d73:	90                   	nop
80101d74:	c9                   	leave  
80101d75:	c3                   	ret    

80101d76 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101d76:	f3 0f 1e fb          	endbr32 
80101d7a:	55                   	push   %ebp
80101d7b:	89 e5                	mov    %esp,%ebp
80101d7d:	83 ec 18             	sub    $0x18,%esp
  acquiresleep(&ip->lock);
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	83 c0 0c             	add    $0xc,%eax
80101d86:	83 ec 0c             	sub    $0xc,%esp
80101d89:	50                   	push   %eax
80101d8a:	e8 61 36 00 00       	call   801053f0 <acquiresleep>
80101d8f:	83 c4 10             	add    $0x10,%esp
  if(ip->valid && ip->nlink == 0){
80101d92:	8b 45 08             	mov    0x8(%ebp),%eax
80101d95:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d98:	85 c0                	test   %eax,%eax
80101d9a:	74 6a                	je     80101e06 <iput+0x90>
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101da3:	66 85 c0             	test   %ax,%ax
80101da6:	75 5e                	jne    80101e06 <iput+0x90>
    acquire(&icache.lock);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	68 80 3a 11 80       	push   $0x80113a80
80101db0:	e8 b4 37 00 00       	call   80105569 <acquire>
80101db5:	83 c4 10             	add    $0x10,%esp
    int r = ip->ref;
80101db8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbb:	8b 40 08             	mov    0x8(%eax),%eax
80101dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101dc1:	83 ec 0c             	sub    $0xc,%esp
80101dc4:	68 80 3a 11 80       	push   $0x80113a80
80101dc9:	e8 0d 38 00 00       	call   801055db <release>
80101dce:	83 c4 10             	add    $0x10,%esp
    if(r == 1){
80101dd1:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101dd5:	75 2f                	jne    80101e06 <iput+0x90>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	ff 75 08             	pushl  0x8(%ebp)
80101ddd:	e8 b5 01 00 00       	call   80101f97 <itrunc>
80101de2:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
80101de5:	8b 45 08             	mov    0x8(%ebp),%eax
80101de8:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101dee:	83 ec 0c             	sub    $0xc,%esp
80101df1:	ff 75 08             	pushl  0x8(%ebp)
80101df4:	e8 2b fc ff ff       	call   80101a24 <iupdate>
80101df9:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	83 c0 0c             	add    $0xc,%eax
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	50                   	push   %eax
80101e10:	e8 43 36 00 00       	call   80105458 <releasesleep>
80101e15:	83 c4 10             	add    $0x10,%esp

  acquire(&icache.lock);
80101e18:	83 ec 0c             	sub    $0xc,%esp
80101e1b:	68 80 3a 11 80       	push   $0x80113a80
80101e20:	e8 44 37 00 00       	call   80105569 <acquire>
80101e25:	83 c4 10             	add    $0x10,%esp
  ip->ref--;
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 40 08             	mov    0x8(%eax),%eax
80101e2e:	8d 50 ff             	lea    -0x1(%eax),%edx
80101e31:	8b 45 08             	mov    0x8(%ebp),%eax
80101e34:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101e37:	83 ec 0c             	sub    $0xc,%esp
80101e3a:	68 80 3a 11 80       	push   $0x80113a80
80101e3f:	e8 97 37 00 00       	call   801055db <release>
80101e44:	83 c4 10             	add    $0x10,%esp
}
80101e47:	90                   	nop
80101e48:	c9                   	leave  
80101e49:	c3                   	ret    

80101e4a <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101e4a:	f3 0f 1e fb          	endbr32 
80101e4e:	55                   	push   %ebp
80101e4f:	89 e5                	mov    %esp,%ebp
80101e51:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101e54:	83 ec 0c             	sub    $0xc,%esp
80101e57:	ff 75 08             	pushl  0x8(%ebp)
80101e5a:	e8 c5 fe ff ff       	call   80101d24 <iunlock>
80101e5f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101e62:	83 ec 0c             	sub    $0xc,%esp
80101e65:	ff 75 08             	pushl  0x8(%ebp)
80101e68:	e8 09 ff ff ff       	call   80101d76 <iput>
80101e6d:	83 c4 10             	add    $0x10,%esp
}
80101e70:	90                   	nop
80101e71:	c9                   	leave  
80101e72:	c3                   	ret    

80101e73 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101e73:	f3 0f 1e fb          	endbr32 
80101e77:	55                   	push   %ebp
80101e78:	89 e5                	mov    %esp,%ebp
80101e7a:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e7d:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101e81:	77 42                	ja     80101ec5 <bmap+0x52>
    if((addr = ip->addrs[bn]) == 0)
80101e83:	8b 45 08             	mov    0x8(%ebp),%eax
80101e86:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e89:	83 c2 14             	add    $0x14,%edx
80101e8c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e97:	75 24                	jne    80101ebd <bmap+0x4a>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e99:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9c:	8b 00                	mov    (%eax),%eax
80101e9e:	83 ec 0c             	sub    $0xc,%esp
80101ea1:	50                   	push   %eax
80101ea2:	e8 c7 f7 ff ff       	call   8010166e <balloc>
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101eb3:	8d 4a 14             	lea    0x14(%edx),%ecx
80101eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eb9:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ec0:	e9 d0 00 00 00       	jmp    80101f95 <bmap+0x122>
  }
  bn -= NDIRECT;
80101ec5:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101ec9:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ecd:	0f 87 b5 00 00 00    	ja     80101f88 <bmap+0x115>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed6:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ee3:	75 20                	jne    80101f05 <bmap+0x92>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee8:	8b 00                	mov    (%eax),%eax
80101eea:	83 ec 0c             	sub    $0xc,%esp
80101eed:	50                   	push   %eax
80101eee:	e8 7b f7 ff ff       	call   8010166e <balloc>
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101eff:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101f05:	8b 45 08             	mov    0x8(%ebp),%eax
80101f08:	8b 00                	mov    (%eax),%eax
80101f0a:	83 ec 08             	sub    $0x8,%esp
80101f0d:	ff 75 f4             	pushl  -0xc(%ebp)
80101f10:	50                   	push   %eax
80101f11:	e8 c1 e2 ff ff       	call   801001d7 <bread>
80101f16:	83 c4 10             	add    $0x10,%esp
80101f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f1f:	83 c0 5c             	add    $0x5c,%eax
80101f22:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101f25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f32:	01 d0                	add    %edx,%eax
80101f34:	8b 00                	mov    (%eax),%eax
80101f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101f3d:	75 36                	jne    80101f75 <bmap+0x102>
      a[bn] = addr = balloc(ip->dev);
80101f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f42:	8b 00                	mov    (%eax),%eax
80101f44:	83 ec 0c             	sub    $0xc,%esp
80101f47:	50                   	push   %eax
80101f48:	e8 21 f7 ff ff       	call   8010166e <balloc>
80101f4d:	83 c4 10             	add    $0x10,%esp
80101f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f60:	01 c2                	add    %eax,%edx
80101f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f65:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101f67:	83 ec 0c             	sub    $0xc,%esp
80101f6a:	ff 75 f0             	pushl  -0x10(%ebp)
80101f6d:	e8 d9 1a 00 00       	call   80103a4b <log_write>
80101f72:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	ff 75 f0             	pushl  -0x10(%ebp)
80101f7b:	e8 e1 e2 ff ff       	call   80100261 <brelse>
80101f80:	83 c4 10             	add    $0x10,%esp
    return addr;
80101f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f86:	eb 0d                	jmp    80101f95 <bmap+0x122>
  }

  panic("bmap: out of range");
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	68 3a 97 10 80       	push   $0x8010973a
80101f90:	e8 73 e6 ff ff       	call   80100608 <panic>
}
80101f95:	c9                   	leave  
80101f96:	c3                   	ret    

80101f97 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f97:	f3 0f 1e fb          	endbr32 
80101f9b:	55                   	push   %ebp
80101f9c:	89 e5                	mov    %esp,%ebp
80101f9e:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fa8:	eb 45                	jmp    80101fef <itrunc+0x58>
    if(ip->addrs[i]){
80101faa:	8b 45 08             	mov    0x8(%ebp),%eax
80101fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fb0:	83 c2 14             	add    $0x14,%edx
80101fb3:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101fb7:	85 c0                	test   %eax,%eax
80101fb9:	74 30                	je     80101feb <itrunc+0x54>
      bfree(ip->dev, ip->addrs[i]);
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fc1:	83 c2 14             	add    $0x14,%edx
80101fc4:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101fc8:	8b 55 08             	mov    0x8(%ebp),%edx
80101fcb:	8b 12                	mov    (%edx),%edx
80101fcd:	83 ec 08             	sub    $0x8,%esp
80101fd0:	50                   	push   %eax
80101fd1:	52                   	push   %edx
80101fd2:	e8 e7 f7 ff ff       	call   801017be <bfree>
80101fd7:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101fda:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fe0:	83 c2 14             	add    $0x14,%edx
80101fe3:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101fea:	00 
  for(i = 0; i < NDIRECT; i++){
80101feb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101fef:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ff3:	7e b5                	jle    80101faa <itrunc+0x13>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101ffe:	85 c0                	test   %eax,%eax
80102000:	0f 84 aa 00 00 00    	je     801020b0 <itrunc+0x119>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102006:	8b 45 08             	mov    0x8(%ebp),%eax
80102009:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010200f:	8b 45 08             	mov    0x8(%ebp),%eax
80102012:	8b 00                	mov    (%eax),%eax
80102014:	83 ec 08             	sub    $0x8,%esp
80102017:	52                   	push   %edx
80102018:	50                   	push   %eax
80102019:	e8 b9 e1 ff ff       	call   801001d7 <bread>
8010201e:	83 c4 10             	add    $0x10,%esp
80102021:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80102024:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102027:	83 c0 5c             	add    $0x5c,%eax
8010202a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010202d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80102034:	eb 3c                	jmp    80102072 <itrunc+0xdb>
      if(a[j])
80102036:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102039:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102040:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102043:	01 d0                	add    %edx,%eax
80102045:	8b 00                	mov    (%eax),%eax
80102047:	85 c0                	test   %eax,%eax
80102049:	74 23                	je     8010206e <itrunc+0xd7>
        bfree(ip->dev, a[j]);
8010204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010204e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80102055:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102058:	01 d0                	add    %edx,%eax
8010205a:	8b 00                	mov    (%eax),%eax
8010205c:	8b 55 08             	mov    0x8(%ebp),%edx
8010205f:	8b 12                	mov    (%edx),%edx
80102061:	83 ec 08             	sub    $0x8,%esp
80102064:	50                   	push   %eax
80102065:	52                   	push   %edx
80102066:	e8 53 f7 ff ff       	call   801017be <bfree>
8010206b:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
8010206e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80102072:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102075:	83 f8 7f             	cmp    $0x7f,%eax
80102078:	76 bc                	jbe    80102036 <itrunc+0x9f>
    }
    brelse(bp);
8010207a:	83 ec 0c             	sub    $0xc,%esp
8010207d:	ff 75 ec             	pushl  -0x14(%ebp)
80102080:	e8 dc e1 ff ff       	call   80100261 <brelse>
80102085:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102091:	8b 55 08             	mov    0x8(%ebp),%edx
80102094:	8b 12                	mov    (%edx),%edx
80102096:	83 ec 08             	sub    $0x8,%esp
80102099:	50                   	push   %eax
8010209a:	52                   	push   %edx
8010209b:	e8 1e f7 ff ff       	call   801017be <bfree>
801020a0:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
801020a3:	8b 45 08             	mov    0x8(%ebp),%eax
801020a6:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801020ad:	00 00 00 
  }

  ip->size = 0;
801020b0:	8b 45 08             	mov    0x8(%ebp),%eax
801020b3:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
801020ba:	83 ec 0c             	sub    $0xc,%esp
801020bd:	ff 75 08             	pushl  0x8(%ebp)
801020c0:	e8 5f f9 ff ff       	call   80101a24 <iupdate>
801020c5:	83 c4 10             	add    $0x10,%esp
}
801020c8:	90                   	nop
801020c9:	c9                   	leave  
801020ca:	c3                   	ret    

801020cb <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801020cb:	f3 0f 1e fb          	endbr32 
801020cf:	55                   	push   %ebp
801020d0:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
801020d2:	8b 45 08             	mov    0x8(%ebp),%eax
801020d5:	8b 00                	mov    (%eax),%eax
801020d7:	89 c2                	mov    %eax,%edx
801020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801020dc:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
801020df:	8b 45 08             	mov    0x8(%ebp),%eax
801020e2:	8b 50 04             	mov    0x4(%eax),%edx
801020e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020e8:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
801020eb:	8b 45 08             	mov    0x8(%ebp),%eax
801020ee:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801020f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f5:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801020ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80102102:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102106:	8b 45 08             	mov    0x8(%ebp),%eax
80102109:	8b 50 58             	mov    0x58(%eax),%edx
8010210c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010210f:	89 50 10             	mov    %edx,0x10(%eax)
}
80102112:	90                   	nop
80102113:	5d                   	pop    %ebp
80102114:	c3                   	ret    

80102115 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102115:	f3 0f 1e fb          	endbr32 
80102119:	55                   	push   %ebp
8010211a:	89 e5                	mov    %esp,%ebp
8010211c:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010211f:	8b 45 08             	mov    0x8(%ebp),%eax
80102122:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102126:	66 83 f8 03          	cmp    $0x3,%ax
8010212a:	75 5c                	jne    80102188 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010212c:	8b 45 08             	mov    0x8(%ebp),%eax
8010212f:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102133:	66 85 c0             	test   %ax,%ax
80102136:	78 20                	js     80102158 <readi+0x43>
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010213f:	66 83 f8 09          	cmp    $0x9,%ax
80102143:	7f 13                	jg     80102158 <readi+0x43>
80102145:	8b 45 08             	mov    0x8(%ebp),%eax
80102148:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010214c:	98                   	cwtl   
8010214d:	8b 04 c5 00 3a 11 80 	mov    -0x7feec600(,%eax,8),%eax
80102154:	85 c0                	test   %eax,%eax
80102156:	75 0a                	jne    80102162 <readi+0x4d>
      return -1;
80102158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010215d:	e9 0a 01 00 00       	jmp    8010226c <readi+0x157>
    return devsw[ip->major].read(ip, dst, n);
80102162:	8b 45 08             	mov    0x8(%ebp),%eax
80102165:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102169:	98                   	cwtl   
8010216a:	8b 04 c5 00 3a 11 80 	mov    -0x7feec600(,%eax,8),%eax
80102171:	8b 55 14             	mov    0x14(%ebp),%edx
80102174:	83 ec 04             	sub    $0x4,%esp
80102177:	52                   	push   %edx
80102178:	ff 75 0c             	pushl  0xc(%ebp)
8010217b:	ff 75 08             	pushl  0x8(%ebp)
8010217e:	ff d0                	call   *%eax
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	e9 e4 00 00 00       	jmp    8010226c <readi+0x157>
  }

  if(off > ip->size || off + n < off)
80102188:	8b 45 08             	mov    0x8(%ebp),%eax
8010218b:	8b 40 58             	mov    0x58(%eax),%eax
8010218e:	39 45 10             	cmp    %eax,0x10(%ebp)
80102191:	77 0d                	ja     801021a0 <readi+0x8b>
80102193:	8b 55 10             	mov    0x10(%ebp),%edx
80102196:	8b 45 14             	mov    0x14(%ebp),%eax
80102199:	01 d0                	add    %edx,%eax
8010219b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010219e:	76 0a                	jbe    801021aa <readi+0x95>
    return -1;
801021a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a5:	e9 c2 00 00 00       	jmp    8010226c <readi+0x157>
  if(off + n > ip->size)
801021aa:	8b 55 10             	mov    0x10(%ebp),%edx
801021ad:	8b 45 14             	mov    0x14(%ebp),%eax
801021b0:	01 c2                	add    %eax,%edx
801021b2:	8b 45 08             	mov    0x8(%ebp),%eax
801021b5:	8b 40 58             	mov    0x58(%eax),%eax
801021b8:	39 c2                	cmp    %eax,%edx
801021ba:	76 0c                	jbe    801021c8 <readi+0xb3>
    n = ip->size - off;
801021bc:	8b 45 08             	mov    0x8(%ebp),%eax
801021bf:	8b 40 58             	mov    0x58(%eax),%eax
801021c2:	2b 45 10             	sub    0x10(%ebp),%eax
801021c5:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021cf:	e9 89 00 00 00       	jmp    8010225d <readi+0x148>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021d4:	8b 45 10             	mov    0x10(%ebp),%eax
801021d7:	c1 e8 09             	shr    $0x9,%eax
801021da:	83 ec 08             	sub    $0x8,%esp
801021dd:	50                   	push   %eax
801021de:	ff 75 08             	pushl  0x8(%ebp)
801021e1:	e8 8d fc ff ff       	call   80101e73 <bmap>
801021e6:	83 c4 10             	add    $0x10,%esp
801021e9:	8b 55 08             	mov    0x8(%ebp),%edx
801021ec:	8b 12                	mov    (%edx),%edx
801021ee:	83 ec 08             	sub    $0x8,%esp
801021f1:	50                   	push   %eax
801021f2:	52                   	push   %edx
801021f3:	e8 df df ff ff       	call   801001d7 <bread>
801021f8:	83 c4 10             	add    $0x10,%esp
801021fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021fe:	8b 45 10             	mov    0x10(%ebp),%eax
80102201:	25 ff 01 00 00       	and    $0x1ff,%eax
80102206:	ba 00 02 00 00       	mov    $0x200,%edx
8010220b:	29 c2                	sub    %eax,%edx
8010220d:	8b 45 14             	mov    0x14(%ebp),%eax
80102210:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102213:	39 c2                	cmp    %eax,%edx
80102215:	0f 46 c2             	cmovbe %edx,%eax
80102218:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010221e:	8d 50 5c             	lea    0x5c(%eax),%edx
80102221:	8b 45 10             	mov    0x10(%ebp),%eax
80102224:	25 ff 01 00 00       	and    $0x1ff,%eax
80102229:	01 d0                	add    %edx,%eax
8010222b:	83 ec 04             	sub    $0x4,%esp
8010222e:	ff 75 ec             	pushl  -0x14(%ebp)
80102231:	50                   	push   %eax
80102232:	ff 75 0c             	pushl  0xc(%ebp)
80102235:	e8 95 36 00 00       	call   801058cf <memmove>
8010223a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010223d:	83 ec 0c             	sub    $0xc,%esp
80102240:	ff 75 f0             	pushl  -0x10(%ebp)
80102243:	e8 19 e0 ff ff       	call   80100261 <brelse>
80102248:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010224b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010224e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102251:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102254:	01 45 10             	add    %eax,0x10(%ebp)
80102257:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010225a:	01 45 0c             	add    %eax,0xc(%ebp)
8010225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102260:	3b 45 14             	cmp    0x14(%ebp),%eax
80102263:	0f 82 6b ff ff ff    	jb     801021d4 <readi+0xbf>
  }
  return n;
80102269:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010226c:	c9                   	leave  
8010226d:	c3                   	ret    

8010226e <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010226e:	f3 0f 1e fb          	endbr32 
80102272:	55                   	push   %ebp
80102273:	89 e5                	mov    %esp,%ebp
80102275:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102278:	8b 45 08             	mov    0x8(%ebp),%eax
8010227b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010227f:	66 83 f8 03          	cmp    $0x3,%ax
80102283:	75 5c                	jne    801022e1 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102285:	8b 45 08             	mov    0x8(%ebp),%eax
80102288:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010228c:	66 85 c0             	test   %ax,%ax
8010228f:	78 20                	js     801022b1 <writei+0x43>
80102291:	8b 45 08             	mov    0x8(%ebp),%eax
80102294:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102298:	66 83 f8 09          	cmp    $0x9,%ax
8010229c:	7f 13                	jg     801022b1 <writei+0x43>
8010229e:	8b 45 08             	mov    0x8(%ebp),%eax
801022a1:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801022a5:	98                   	cwtl   
801022a6:	8b 04 c5 04 3a 11 80 	mov    -0x7feec5fc(,%eax,8),%eax
801022ad:	85 c0                	test   %eax,%eax
801022af:	75 0a                	jne    801022bb <writei+0x4d>
      return -1;
801022b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b6:	e9 3b 01 00 00       	jmp    801023f6 <writei+0x188>
    return devsw[ip->major].write(ip, src, n);
801022bb:	8b 45 08             	mov    0x8(%ebp),%eax
801022be:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801022c2:	98                   	cwtl   
801022c3:	8b 04 c5 04 3a 11 80 	mov    -0x7feec5fc(,%eax,8),%eax
801022ca:	8b 55 14             	mov    0x14(%ebp),%edx
801022cd:	83 ec 04             	sub    $0x4,%esp
801022d0:	52                   	push   %edx
801022d1:	ff 75 0c             	pushl  0xc(%ebp)
801022d4:	ff 75 08             	pushl  0x8(%ebp)
801022d7:	ff d0                	call   *%eax
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	e9 15 01 00 00       	jmp    801023f6 <writei+0x188>
  }

  if(off > ip->size || off + n < off)
801022e1:	8b 45 08             	mov    0x8(%ebp),%eax
801022e4:	8b 40 58             	mov    0x58(%eax),%eax
801022e7:	39 45 10             	cmp    %eax,0x10(%ebp)
801022ea:	77 0d                	ja     801022f9 <writei+0x8b>
801022ec:	8b 55 10             	mov    0x10(%ebp),%edx
801022ef:	8b 45 14             	mov    0x14(%ebp),%eax
801022f2:	01 d0                	add    %edx,%eax
801022f4:	39 45 10             	cmp    %eax,0x10(%ebp)
801022f7:	76 0a                	jbe    80102303 <writei+0x95>
    return -1;
801022f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022fe:	e9 f3 00 00 00       	jmp    801023f6 <writei+0x188>
  if(off + n > MAXFILE*BSIZE)
80102303:	8b 55 10             	mov    0x10(%ebp),%edx
80102306:	8b 45 14             	mov    0x14(%ebp),%eax
80102309:	01 d0                	add    %edx,%eax
8010230b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102310:	76 0a                	jbe    8010231c <writei+0xae>
    return -1;
80102312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102317:	e9 da 00 00 00       	jmp    801023f6 <writei+0x188>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010231c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102323:	e9 97 00 00 00       	jmp    801023bf <writei+0x151>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102328:	8b 45 10             	mov    0x10(%ebp),%eax
8010232b:	c1 e8 09             	shr    $0x9,%eax
8010232e:	83 ec 08             	sub    $0x8,%esp
80102331:	50                   	push   %eax
80102332:	ff 75 08             	pushl  0x8(%ebp)
80102335:	e8 39 fb ff ff       	call   80101e73 <bmap>
8010233a:	83 c4 10             	add    $0x10,%esp
8010233d:	8b 55 08             	mov    0x8(%ebp),%edx
80102340:	8b 12                	mov    (%edx),%edx
80102342:	83 ec 08             	sub    $0x8,%esp
80102345:	50                   	push   %eax
80102346:	52                   	push   %edx
80102347:	e8 8b de ff ff       	call   801001d7 <bread>
8010234c:	83 c4 10             	add    $0x10,%esp
8010234f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102352:	8b 45 10             	mov    0x10(%ebp),%eax
80102355:	25 ff 01 00 00       	and    $0x1ff,%eax
8010235a:	ba 00 02 00 00       	mov    $0x200,%edx
8010235f:	29 c2                	sub    %eax,%edx
80102361:	8b 45 14             	mov    0x14(%ebp),%eax
80102364:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102367:	39 c2                	cmp    %eax,%edx
80102369:	0f 46 c2             	cmovbe %edx,%eax
8010236c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102372:	8d 50 5c             	lea    0x5c(%eax),%edx
80102375:	8b 45 10             	mov    0x10(%ebp),%eax
80102378:	25 ff 01 00 00       	and    $0x1ff,%eax
8010237d:	01 d0                	add    %edx,%eax
8010237f:	83 ec 04             	sub    $0x4,%esp
80102382:	ff 75 ec             	pushl  -0x14(%ebp)
80102385:	ff 75 0c             	pushl  0xc(%ebp)
80102388:	50                   	push   %eax
80102389:	e8 41 35 00 00       	call   801058cf <memmove>
8010238e:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102391:	83 ec 0c             	sub    $0xc,%esp
80102394:	ff 75 f0             	pushl  -0x10(%ebp)
80102397:	e8 af 16 00 00       	call   80103a4b <log_write>
8010239c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010239f:	83 ec 0c             	sub    $0xc,%esp
801023a2:	ff 75 f0             	pushl  -0x10(%ebp)
801023a5:	e8 b7 de ff ff       	call   80100261 <brelse>
801023aa:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023b0:	01 45 f4             	add    %eax,-0xc(%ebp)
801023b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023b6:	01 45 10             	add    %eax,0x10(%ebp)
801023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023bc:	01 45 0c             	add    %eax,0xc(%ebp)
801023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c2:	3b 45 14             	cmp    0x14(%ebp),%eax
801023c5:	0f 82 5d ff ff ff    	jb     80102328 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801023cb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801023cf:	74 22                	je     801023f3 <writei+0x185>
801023d1:	8b 45 08             	mov    0x8(%ebp),%eax
801023d4:	8b 40 58             	mov    0x58(%eax),%eax
801023d7:	39 45 10             	cmp    %eax,0x10(%ebp)
801023da:	76 17                	jbe    801023f3 <writei+0x185>
    ip->size = off;
801023dc:	8b 45 08             	mov    0x8(%ebp),%eax
801023df:	8b 55 10             	mov    0x10(%ebp),%edx
801023e2:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801023e5:	83 ec 0c             	sub    $0xc,%esp
801023e8:	ff 75 08             	pushl  0x8(%ebp)
801023eb:	e8 34 f6 ff ff       	call   80101a24 <iupdate>
801023f0:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801023f3:	8b 45 14             	mov    0x14(%ebp),%eax
}
801023f6:	c9                   	leave  
801023f7:	c3                   	ret    

801023f8 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801023f8:	f3 0f 1e fb          	endbr32 
801023fc:	55                   	push   %ebp
801023fd:	89 e5                	mov    %esp,%ebp
801023ff:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102402:	83 ec 04             	sub    $0x4,%esp
80102405:	6a 0e                	push   $0xe
80102407:	ff 75 0c             	pushl  0xc(%ebp)
8010240a:	ff 75 08             	pushl  0x8(%ebp)
8010240d:	e8 5b 35 00 00       	call   8010596d <strncmp>
80102412:	83 c4 10             	add    $0x10,%esp
}
80102415:	c9                   	leave  
80102416:	c3                   	ret    

80102417 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102417:	f3 0f 1e fb          	endbr32 
8010241b:	55                   	push   %ebp
8010241c:	89 e5                	mov    %esp,%ebp
8010241e:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102428:	66 83 f8 01          	cmp    $0x1,%ax
8010242c:	74 0d                	je     8010243b <dirlookup+0x24>
    panic("dirlookup not DIR");
8010242e:	83 ec 0c             	sub    $0xc,%esp
80102431:	68 4d 97 10 80       	push   $0x8010974d
80102436:	e8 cd e1 ff ff       	call   80100608 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010243b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102442:	eb 7b                	jmp    801024bf <dirlookup+0xa8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102444:	6a 10                	push   $0x10
80102446:	ff 75 f4             	pushl  -0xc(%ebp)
80102449:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010244c:	50                   	push   %eax
8010244d:	ff 75 08             	pushl  0x8(%ebp)
80102450:	e8 c0 fc ff ff       	call   80102115 <readi>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	83 f8 10             	cmp    $0x10,%eax
8010245b:	74 0d                	je     8010246a <dirlookup+0x53>
      panic("dirlookup read");
8010245d:	83 ec 0c             	sub    $0xc,%esp
80102460:	68 5f 97 10 80       	push   $0x8010975f
80102465:	e8 9e e1 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
8010246a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010246e:	66 85 c0             	test   %ax,%ax
80102471:	74 47                	je     801024ba <dirlookup+0xa3>
      continue;
    if(namecmp(name, de.name) == 0){
80102473:	83 ec 08             	sub    $0x8,%esp
80102476:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102479:	83 c0 02             	add    $0x2,%eax
8010247c:	50                   	push   %eax
8010247d:	ff 75 0c             	pushl  0xc(%ebp)
80102480:	e8 73 ff ff ff       	call   801023f8 <namecmp>
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	85 c0                	test   %eax,%eax
8010248a:	75 2f                	jne    801024bb <dirlookup+0xa4>
      // entry matches path element
      if(poff)
8010248c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102490:	74 08                	je     8010249a <dirlookup+0x83>
        *poff = off;
80102492:	8b 45 10             	mov    0x10(%ebp),%eax
80102495:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102498:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010249a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010249e:	0f b7 c0             	movzwl %ax,%eax
801024a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801024a4:	8b 45 08             	mov    0x8(%ebp),%eax
801024a7:	8b 00                	mov    (%eax),%eax
801024a9:	83 ec 08             	sub    $0x8,%esp
801024ac:	ff 75 f0             	pushl  -0x10(%ebp)
801024af:	50                   	push   %eax
801024b0:	e8 34 f6 ff ff       	call   80101ae9 <iget>
801024b5:	83 c4 10             	add    $0x10,%esp
801024b8:	eb 19                	jmp    801024d3 <dirlookup+0xbc>
      continue;
801024ba:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
801024bb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801024bf:	8b 45 08             	mov    0x8(%ebp),%eax
801024c2:	8b 40 58             	mov    0x58(%eax),%eax
801024c5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801024c8:	0f 82 76 ff ff ff    	jb     80102444 <dirlookup+0x2d>
    }
  }

  return 0;
801024ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024d3:	c9                   	leave  
801024d4:	c3                   	ret    

801024d5 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801024d5:	f3 0f 1e fb          	endbr32 
801024d9:	55                   	push   %ebp
801024da:	89 e5                	mov    %esp,%ebp
801024dc:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801024df:	83 ec 04             	sub    $0x4,%esp
801024e2:	6a 00                	push   $0x0
801024e4:	ff 75 0c             	pushl  0xc(%ebp)
801024e7:	ff 75 08             	pushl  0x8(%ebp)
801024ea:	e8 28 ff ff ff       	call   80102417 <dirlookup>
801024ef:	83 c4 10             	add    $0x10,%esp
801024f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024f9:	74 18                	je     80102513 <dirlink+0x3e>
    iput(ip);
801024fb:	83 ec 0c             	sub    $0xc,%esp
801024fe:	ff 75 f0             	pushl  -0x10(%ebp)
80102501:	e8 70 f8 ff ff       	call   80101d76 <iput>
80102506:	83 c4 10             	add    $0x10,%esp
    return -1;
80102509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010250e:	e9 9c 00 00 00       	jmp    801025af <dirlink+0xda>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010251a:	eb 39                	jmp    80102555 <dirlink+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251f:	6a 10                	push   $0x10
80102521:	50                   	push   %eax
80102522:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102525:	50                   	push   %eax
80102526:	ff 75 08             	pushl  0x8(%ebp)
80102529:	e8 e7 fb ff ff       	call   80102115 <readi>
8010252e:	83 c4 10             	add    $0x10,%esp
80102531:	83 f8 10             	cmp    $0x10,%eax
80102534:	74 0d                	je     80102543 <dirlink+0x6e>
      panic("dirlink read");
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	68 6e 97 10 80       	push   $0x8010976e
8010253e:	e8 c5 e0 ff ff       	call   80100608 <panic>
    if(de.inum == 0)
80102543:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102547:	66 85 c0             	test   %ax,%ax
8010254a:	74 18                	je     80102564 <dirlink+0x8f>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010254f:	83 c0 10             	add    $0x10,%eax
80102552:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102555:	8b 45 08             	mov    0x8(%ebp),%eax
80102558:	8b 50 58             	mov    0x58(%eax),%edx
8010255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010255e:	39 c2                	cmp    %eax,%edx
80102560:	77 ba                	ja     8010251c <dirlink+0x47>
80102562:	eb 01                	jmp    80102565 <dirlink+0x90>
      break;
80102564:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102565:	83 ec 04             	sub    $0x4,%esp
80102568:	6a 0e                	push   $0xe
8010256a:	ff 75 0c             	pushl  0xc(%ebp)
8010256d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102570:	83 c0 02             	add    $0x2,%eax
80102573:	50                   	push   %eax
80102574:	e8 4e 34 00 00       	call   801059c7 <strncpy>
80102579:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010257c:	8b 45 10             	mov    0x10(%ebp),%eax
8010257f:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102586:	6a 10                	push   $0x10
80102588:	50                   	push   %eax
80102589:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010258c:	50                   	push   %eax
8010258d:	ff 75 08             	pushl  0x8(%ebp)
80102590:	e8 d9 fc ff ff       	call   8010226e <writei>
80102595:	83 c4 10             	add    $0x10,%esp
80102598:	83 f8 10             	cmp    $0x10,%eax
8010259b:	74 0d                	je     801025aa <dirlink+0xd5>
    panic("dirlink");
8010259d:	83 ec 0c             	sub    $0xc,%esp
801025a0:	68 7b 97 10 80       	push   $0x8010977b
801025a5:	e8 5e e0 ff ff       	call   80100608 <panic>

  return 0;
801025aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025af:	c9                   	leave  
801025b0:	c3                   	ret    

801025b1 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801025b1:	f3 0f 1e fb          	endbr32 
801025b5:	55                   	push   %ebp
801025b6:	89 e5                	mov    %esp,%ebp
801025b8:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801025bb:	eb 04                	jmp    801025c1 <skipelem+0x10>
    path++;
801025bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801025c1:	8b 45 08             	mov    0x8(%ebp),%eax
801025c4:	0f b6 00             	movzbl (%eax),%eax
801025c7:	3c 2f                	cmp    $0x2f,%al
801025c9:	74 f2                	je     801025bd <skipelem+0xc>
  if(*path == 0)
801025cb:	8b 45 08             	mov    0x8(%ebp),%eax
801025ce:	0f b6 00             	movzbl (%eax),%eax
801025d1:	84 c0                	test   %al,%al
801025d3:	75 07                	jne    801025dc <skipelem+0x2b>
    return 0;
801025d5:	b8 00 00 00 00       	mov    $0x0,%eax
801025da:	eb 77                	jmp    80102653 <skipelem+0xa2>
  s = path;
801025dc:	8b 45 08             	mov    0x8(%ebp),%eax
801025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801025e2:	eb 04                	jmp    801025e8 <skipelem+0x37>
    path++;
801025e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
801025eb:	0f b6 00             	movzbl (%eax),%eax
801025ee:	3c 2f                	cmp    $0x2f,%al
801025f0:	74 0a                	je     801025fc <skipelem+0x4b>
801025f2:	8b 45 08             	mov    0x8(%ebp),%eax
801025f5:	0f b6 00             	movzbl (%eax),%eax
801025f8:	84 c0                	test   %al,%al
801025fa:	75 e8                	jne    801025e4 <skipelem+0x33>
  len = path - s;
801025fc:	8b 45 08             	mov    0x8(%ebp),%eax
801025ff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102602:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102605:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102609:	7e 15                	jle    80102620 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010260b:	83 ec 04             	sub    $0x4,%esp
8010260e:	6a 0e                	push   $0xe
80102610:	ff 75 f4             	pushl  -0xc(%ebp)
80102613:	ff 75 0c             	pushl  0xc(%ebp)
80102616:	e8 b4 32 00 00       	call   801058cf <memmove>
8010261b:	83 c4 10             	add    $0x10,%esp
8010261e:	eb 26                	jmp    80102646 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102620:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102623:	83 ec 04             	sub    $0x4,%esp
80102626:	50                   	push   %eax
80102627:	ff 75 f4             	pushl  -0xc(%ebp)
8010262a:	ff 75 0c             	pushl  0xc(%ebp)
8010262d:	e8 9d 32 00 00       	call   801058cf <memmove>
80102632:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102635:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102638:	8b 45 0c             	mov    0xc(%ebp),%eax
8010263b:	01 d0                	add    %edx,%eax
8010263d:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102640:	eb 04                	jmp    80102646 <skipelem+0x95>
    path++;
80102642:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102646:	8b 45 08             	mov    0x8(%ebp),%eax
80102649:	0f b6 00             	movzbl (%eax),%eax
8010264c:	3c 2f                	cmp    $0x2f,%al
8010264e:	74 f2                	je     80102642 <skipelem+0x91>
  return path;
80102650:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102653:	c9                   	leave  
80102654:	c3                   	ret    

80102655 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102655:	f3 0f 1e fb          	endbr32 
80102659:	55                   	push   %ebp
8010265a:	89 e5                	mov    %esp,%ebp
8010265c:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010265f:	8b 45 08             	mov    0x8(%ebp),%eax
80102662:	0f b6 00             	movzbl (%eax),%eax
80102665:	3c 2f                	cmp    $0x2f,%al
80102667:	75 17                	jne    80102680 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
80102669:	83 ec 08             	sub    $0x8,%esp
8010266c:	6a 01                	push   $0x1
8010266e:	6a 01                	push   $0x1
80102670:	e8 74 f4 ff ff       	call   80101ae9 <iget>
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010267b:	e9 ba 00 00 00       	jmp    8010273a <namex+0xe5>
  else
    ip = idup(myproc()->cwd);
80102680:	e8 3c 1f 00 00       	call   801045c1 <myproc>
80102685:	8b 40 68             	mov    0x68(%eax),%eax
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	50                   	push   %eax
8010268c:	e8 3e f5 ff ff       	call   80101bcf <idup>
80102691:	83 c4 10             	add    $0x10,%esp
80102694:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102697:	e9 9e 00 00 00       	jmp    8010273a <namex+0xe5>
    ilock(ip);
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	ff 75 f4             	pushl  -0xc(%ebp)
801026a2:	e8 66 f5 ff ff       	call   80101c0d <ilock>
801026a7:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026ad:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801026b1:	66 83 f8 01          	cmp    $0x1,%ax
801026b5:	74 18                	je     801026cf <namex+0x7a>
      iunlockput(ip);
801026b7:	83 ec 0c             	sub    $0xc,%esp
801026ba:	ff 75 f4             	pushl  -0xc(%ebp)
801026bd:	e8 88 f7 ff ff       	call   80101e4a <iunlockput>
801026c2:	83 c4 10             	add    $0x10,%esp
      return 0;
801026c5:	b8 00 00 00 00       	mov    $0x0,%eax
801026ca:	e9 a7 00 00 00       	jmp    80102776 <namex+0x121>
    }
    if(nameiparent && *path == '\0'){
801026cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026d3:	74 20                	je     801026f5 <namex+0xa0>
801026d5:	8b 45 08             	mov    0x8(%ebp),%eax
801026d8:	0f b6 00             	movzbl (%eax),%eax
801026db:	84 c0                	test   %al,%al
801026dd:	75 16                	jne    801026f5 <namex+0xa0>
      // Stop one level early.
      iunlock(ip);
801026df:	83 ec 0c             	sub    $0xc,%esp
801026e2:	ff 75 f4             	pushl  -0xc(%ebp)
801026e5:	e8 3a f6 ff ff       	call   80101d24 <iunlock>
801026ea:	83 c4 10             	add    $0x10,%esp
      return ip;
801026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f0:	e9 81 00 00 00       	jmp    80102776 <namex+0x121>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026f5:	83 ec 04             	sub    $0x4,%esp
801026f8:	6a 00                	push   $0x0
801026fa:	ff 75 10             	pushl  0x10(%ebp)
801026fd:	ff 75 f4             	pushl  -0xc(%ebp)
80102700:	e8 12 fd ff ff       	call   80102417 <dirlookup>
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010270b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010270f:	75 15                	jne    80102726 <namex+0xd1>
      iunlockput(ip);
80102711:	83 ec 0c             	sub    $0xc,%esp
80102714:	ff 75 f4             	pushl  -0xc(%ebp)
80102717:	e8 2e f7 ff ff       	call   80101e4a <iunlockput>
8010271c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010271f:	b8 00 00 00 00       	mov    $0x0,%eax
80102724:	eb 50                	jmp    80102776 <namex+0x121>
    }
    iunlockput(ip);
80102726:	83 ec 0c             	sub    $0xc,%esp
80102729:	ff 75 f4             	pushl  -0xc(%ebp)
8010272c:	e8 19 f7 ff ff       	call   80101e4a <iunlockput>
80102731:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010273a:	83 ec 08             	sub    $0x8,%esp
8010273d:	ff 75 10             	pushl  0x10(%ebp)
80102740:	ff 75 08             	pushl  0x8(%ebp)
80102743:	e8 69 fe ff ff       	call   801025b1 <skipelem>
80102748:	83 c4 10             	add    $0x10,%esp
8010274b:	89 45 08             	mov    %eax,0x8(%ebp)
8010274e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102752:	0f 85 44 ff ff ff    	jne    8010269c <namex+0x47>
  }
  if(nameiparent){
80102758:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010275c:	74 15                	je     80102773 <namex+0x11e>
    iput(ip);
8010275e:	83 ec 0c             	sub    $0xc,%esp
80102761:	ff 75 f4             	pushl  -0xc(%ebp)
80102764:	e8 0d f6 ff ff       	call   80101d76 <iput>
80102769:	83 c4 10             	add    $0x10,%esp
    return 0;
8010276c:	b8 00 00 00 00       	mov    $0x0,%eax
80102771:	eb 03                	jmp    80102776 <namex+0x121>
  }
  return ip;
80102773:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102776:	c9                   	leave  
80102777:	c3                   	ret    

80102778 <namei>:

struct inode*
namei(char *path)
{
80102778:	f3 0f 1e fb          	endbr32 
8010277c:	55                   	push   %ebp
8010277d:	89 e5                	mov    %esp,%ebp
8010277f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102782:	83 ec 04             	sub    $0x4,%esp
80102785:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102788:	50                   	push   %eax
80102789:	6a 00                	push   $0x0
8010278b:	ff 75 08             	pushl  0x8(%ebp)
8010278e:	e8 c2 fe ff ff       	call   80102655 <namex>
80102793:	83 c4 10             	add    $0x10,%esp
}
80102796:	c9                   	leave  
80102797:	c3                   	ret    

80102798 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102798:	f3 0f 1e fb          	endbr32 
8010279c:	55                   	push   %ebp
8010279d:	89 e5                	mov    %esp,%ebp
8010279f:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801027a2:	83 ec 04             	sub    $0x4,%esp
801027a5:	ff 75 0c             	pushl  0xc(%ebp)
801027a8:	6a 01                	push   $0x1
801027aa:	ff 75 08             	pushl  0x8(%ebp)
801027ad:	e8 a3 fe ff ff       	call   80102655 <namex>
801027b2:	83 c4 10             	add    $0x10,%esp
}
801027b5:	c9                   	leave  
801027b6:	c3                   	ret    

801027b7 <inb>:
{
801027b7:	55                   	push   %ebp
801027b8:	89 e5                	mov    %esp,%ebp
801027ba:	83 ec 14             	sub    $0x14,%esp
801027bd:	8b 45 08             	mov    0x8(%ebp),%eax
801027c0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801027c8:	89 c2                	mov    %eax,%edx
801027ca:	ec                   	in     (%dx),%al
801027cb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801027ce:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801027d2:	c9                   	leave  
801027d3:	c3                   	ret    

801027d4 <insl>:
{
801027d4:	55                   	push   %ebp
801027d5:	89 e5                	mov    %esp,%ebp
801027d7:	57                   	push   %edi
801027d8:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801027d9:	8b 55 08             	mov    0x8(%ebp),%edx
801027dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027df:	8b 45 10             	mov    0x10(%ebp),%eax
801027e2:	89 cb                	mov    %ecx,%ebx
801027e4:	89 df                	mov    %ebx,%edi
801027e6:	89 c1                	mov    %eax,%ecx
801027e8:	fc                   	cld    
801027e9:	f3 6d                	rep insl (%dx),%es:(%edi)
801027eb:	89 c8                	mov    %ecx,%eax
801027ed:	89 fb                	mov    %edi,%ebx
801027ef:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801027f2:	89 45 10             	mov    %eax,0x10(%ebp)
}
801027f5:	90                   	nop
801027f6:	5b                   	pop    %ebx
801027f7:	5f                   	pop    %edi
801027f8:	5d                   	pop    %ebp
801027f9:	c3                   	ret    

801027fa <outb>:
{
801027fa:	55                   	push   %ebp
801027fb:	89 e5                	mov    %esp,%ebp
801027fd:	83 ec 08             	sub    $0x8,%esp
80102800:	8b 45 08             	mov    0x8(%ebp),%eax
80102803:	8b 55 0c             	mov    0xc(%ebp),%edx
80102806:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010280a:	89 d0                	mov    %edx,%eax
8010280c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010280f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102813:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102817:	ee                   	out    %al,(%dx)
}
80102818:	90                   	nop
80102819:	c9                   	leave  
8010281a:	c3                   	ret    

8010281b <outsl>:
{
8010281b:	55                   	push   %ebp
8010281c:	89 e5                	mov    %esp,%ebp
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102820:	8b 55 08             	mov    0x8(%ebp),%edx
80102823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102826:	8b 45 10             	mov    0x10(%ebp),%eax
80102829:	89 cb                	mov    %ecx,%ebx
8010282b:	89 de                	mov    %ebx,%esi
8010282d:	89 c1                	mov    %eax,%ecx
8010282f:	fc                   	cld    
80102830:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102832:	89 c8                	mov    %ecx,%eax
80102834:	89 f3                	mov    %esi,%ebx
80102836:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102839:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010283c:	90                   	nop
8010283d:	5b                   	pop    %ebx
8010283e:	5e                   	pop    %esi
8010283f:	5d                   	pop    %ebp
80102840:	c3                   	ret    

80102841 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102841:	f3 0f 1e fb          	endbr32 
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
80102848:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010284b:	90                   	nop
8010284c:	68 f7 01 00 00       	push   $0x1f7
80102851:	e8 61 ff ff ff       	call   801027b7 <inb>
80102856:	83 c4 04             	add    $0x4,%esp
80102859:	0f b6 c0             	movzbl %al,%eax
8010285c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102862:	25 c0 00 00 00       	and    $0xc0,%eax
80102867:	83 f8 40             	cmp    $0x40,%eax
8010286a:	75 e0                	jne    8010284c <idewait+0xb>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010286c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102870:	74 11                	je     80102883 <idewait+0x42>
80102872:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102875:	83 e0 21             	and    $0x21,%eax
80102878:	85 c0                	test   %eax,%eax
8010287a:	74 07                	je     80102883 <idewait+0x42>
    return -1;
8010287c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102881:	eb 05                	jmp    80102888 <idewait+0x47>
  return 0;
80102883:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102888:	c9                   	leave  
80102889:	c3                   	ret    

8010288a <ideinit>:

void
ideinit(void)
{
8010288a:	f3 0f 1e fb          	endbr32 
8010288e:	55                   	push   %ebp
8010288f:	89 e5                	mov    %esp,%ebp
80102891:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102894:	83 ec 08             	sub    $0x8,%esp
80102897:	68 83 97 10 80       	push   $0x80109783
8010289c:	68 00 d6 10 80       	push   $0x8010d600
801028a1:	e8 9d 2c 00 00       	call   80105543 <initlock>
801028a6:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801028a9:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
801028ae:	83 e8 01             	sub    $0x1,%eax
801028b1:	83 ec 08             	sub    $0x8,%esp
801028b4:	50                   	push   %eax
801028b5:	6a 0e                	push   $0xe
801028b7:	e8 bb 04 00 00       	call   80102d77 <ioapicenable>
801028bc:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801028bf:	83 ec 0c             	sub    $0xc,%esp
801028c2:	6a 00                	push   $0x0
801028c4:	e8 78 ff ff ff       	call   80102841 <idewait>
801028c9:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801028cc:	83 ec 08             	sub    $0x8,%esp
801028cf:	68 f0 00 00 00       	push   $0xf0
801028d4:	68 f6 01 00 00       	push   $0x1f6
801028d9:	e8 1c ff ff ff       	call   801027fa <outb>
801028de:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801028e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801028e8:	eb 24                	jmp    8010290e <ideinit+0x84>
    if(inb(0x1f7) != 0){
801028ea:	83 ec 0c             	sub    $0xc,%esp
801028ed:	68 f7 01 00 00       	push   $0x1f7
801028f2:	e8 c0 fe ff ff       	call   801027b7 <inb>
801028f7:	83 c4 10             	add    $0x10,%esp
801028fa:	84 c0                	test   %al,%al
801028fc:	74 0c                	je     8010290a <ideinit+0x80>
      havedisk1 = 1;
801028fe:	c7 05 38 d6 10 80 01 	movl   $0x1,0x8010d638
80102905:	00 00 00 
      break;
80102908:	eb 0d                	jmp    80102917 <ideinit+0x8d>
  for(i=0; i<1000; i++){
8010290a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010290e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102915:	7e d3                	jle    801028ea <ideinit+0x60>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102917:	83 ec 08             	sub    $0x8,%esp
8010291a:	68 e0 00 00 00       	push   $0xe0
8010291f:	68 f6 01 00 00       	push   $0x1f6
80102924:	e8 d1 fe ff ff       	call   801027fa <outb>
80102929:	83 c4 10             	add    $0x10,%esp
}
8010292c:	90                   	nop
8010292d:	c9                   	leave  
8010292e:	c3                   	ret    

8010292f <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010292f:	f3 0f 1e fb          	endbr32 
80102933:	55                   	push   %ebp
80102934:	89 e5                	mov    %esp,%ebp
80102936:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010293d:	75 0d                	jne    8010294c <idestart+0x1d>
    panic("idestart");
8010293f:	83 ec 0c             	sub    $0xc,%esp
80102942:	68 87 97 10 80       	push   $0x80109787
80102947:	e8 bc dc ff ff       	call   80100608 <panic>
  if(b->blockno >= FSSIZE)
8010294c:	8b 45 08             	mov    0x8(%ebp),%eax
8010294f:	8b 40 08             	mov    0x8(%eax),%eax
80102952:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102957:	76 0d                	jbe    80102966 <idestart+0x37>
    panic("incorrect blockno");
80102959:	83 ec 0c             	sub    $0xc,%esp
8010295c:	68 90 97 10 80       	push   $0x80109790
80102961:	e8 a2 dc ff ff       	call   80100608 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102966:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010296d:	8b 45 08             	mov    0x8(%ebp),%eax
80102970:	8b 50 08             	mov    0x8(%eax),%edx
80102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102976:	0f af c2             	imul   %edx,%eax
80102979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010297c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102980:	75 07                	jne    80102989 <idestart+0x5a>
80102982:	b8 20 00 00 00       	mov    $0x20,%eax
80102987:	eb 05                	jmp    8010298e <idestart+0x5f>
80102989:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010298e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102991:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102995:	75 07                	jne    8010299e <idestart+0x6f>
80102997:	b8 30 00 00 00       	mov    $0x30,%eax
8010299c:	eb 05                	jmp    801029a3 <idestart+0x74>
8010299e:	b8 c5 00 00 00       	mov    $0xc5,%eax
801029a3:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801029a6:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801029aa:	7e 0d                	jle    801029b9 <idestart+0x8a>
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 87 97 10 80       	push   $0x80109787
801029b4:	e8 4f dc ff ff       	call   80100608 <panic>

  idewait(0);
801029b9:	83 ec 0c             	sub    $0xc,%esp
801029bc:	6a 00                	push   $0x0
801029be:	e8 7e fe ff ff       	call   80102841 <idewait>
801029c3:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801029c6:	83 ec 08             	sub    $0x8,%esp
801029c9:	6a 00                	push   $0x0
801029cb:	68 f6 03 00 00       	push   $0x3f6
801029d0:	e8 25 fe ff ff       	call   801027fa <outb>
801029d5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029db:	0f b6 c0             	movzbl %al,%eax
801029de:	83 ec 08             	sub    $0x8,%esp
801029e1:	50                   	push   %eax
801029e2:	68 f2 01 00 00       	push   $0x1f2
801029e7:	e8 0e fe ff ff       	call   801027fa <outb>
801029ec:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
801029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801029f2:	0f b6 c0             	movzbl %al,%eax
801029f5:	83 ec 08             	sub    $0x8,%esp
801029f8:	50                   	push   %eax
801029f9:	68 f3 01 00 00       	push   $0x1f3
801029fe:	e8 f7 fd ff ff       	call   801027fa <outb>
80102a03:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a09:	c1 f8 08             	sar    $0x8,%eax
80102a0c:	0f b6 c0             	movzbl %al,%eax
80102a0f:	83 ec 08             	sub    $0x8,%esp
80102a12:	50                   	push   %eax
80102a13:	68 f4 01 00 00       	push   $0x1f4
80102a18:	e8 dd fd ff ff       	call   801027fa <outb>
80102a1d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a23:	c1 f8 10             	sar    $0x10,%eax
80102a26:	0f b6 c0             	movzbl %al,%eax
80102a29:	83 ec 08             	sub    $0x8,%esp
80102a2c:	50                   	push   %eax
80102a2d:	68 f5 01 00 00       	push   $0x1f5
80102a32:	e8 c3 fd ff ff       	call   801027fa <outb>
80102a37:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a3d:	8b 40 04             	mov    0x4(%eax),%eax
80102a40:	c1 e0 04             	shl    $0x4,%eax
80102a43:	83 e0 10             	and    $0x10,%eax
80102a46:	89 c2                	mov    %eax,%edx
80102a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a4b:	c1 f8 18             	sar    $0x18,%eax
80102a4e:	83 e0 0f             	and    $0xf,%eax
80102a51:	09 d0                	or     %edx,%eax
80102a53:	83 c8 e0             	or     $0xffffffe0,%eax
80102a56:	0f b6 c0             	movzbl %al,%eax
80102a59:	83 ec 08             	sub    $0x8,%esp
80102a5c:	50                   	push   %eax
80102a5d:	68 f6 01 00 00       	push   $0x1f6
80102a62:	e8 93 fd ff ff       	call   801027fa <outb>
80102a67:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6d:	8b 00                	mov    (%eax),%eax
80102a6f:	83 e0 04             	and    $0x4,%eax
80102a72:	85 c0                	test   %eax,%eax
80102a74:	74 35                	je     80102aab <idestart+0x17c>
    outb(0x1f7, write_cmd);
80102a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102a79:	0f b6 c0             	movzbl %al,%eax
80102a7c:	83 ec 08             	sub    $0x8,%esp
80102a7f:	50                   	push   %eax
80102a80:	68 f7 01 00 00       	push   $0x1f7
80102a85:	e8 70 fd ff ff       	call   801027fa <outb>
80102a8a:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a90:	83 c0 5c             	add    $0x5c,%eax
80102a93:	83 ec 04             	sub    $0x4,%esp
80102a96:	68 80 00 00 00       	push   $0x80
80102a9b:	50                   	push   %eax
80102a9c:	68 f0 01 00 00       	push   $0x1f0
80102aa1:	e8 75 fd ff ff       	call   8010281b <outsl>
80102aa6:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102aa9:	eb 17                	jmp    80102ac2 <idestart+0x193>
    outb(0x1f7, read_cmd);
80102aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102aae:	0f b6 c0             	movzbl %al,%eax
80102ab1:	83 ec 08             	sub    $0x8,%esp
80102ab4:	50                   	push   %eax
80102ab5:	68 f7 01 00 00       	push   $0x1f7
80102aba:	e8 3b fd ff ff       	call   801027fa <outb>
80102abf:	83 c4 10             	add    $0x10,%esp
}
80102ac2:	90                   	nop
80102ac3:	c9                   	leave  
80102ac4:	c3                   	ret    

80102ac5 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102ac5:	f3 0f 1e fb          	endbr32 
80102ac9:	55                   	push   %ebp
80102aca:	89 e5                	mov    %esp,%ebp
80102acc:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102acf:	83 ec 0c             	sub    $0xc,%esp
80102ad2:	68 00 d6 10 80       	push   $0x8010d600
80102ad7:	e8 8d 2a 00 00       	call   80105569 <acquire>
80102adc:	83 c4 10             	add    $0x10,%esp

  if((b = idequeue) == 0){
80102adf:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102aeb:	75 15                	jne    80102b02 <ideintr+0x3d>
    release(&idelock);
80102aed:	83 ec 0c             	sub    $0xc,%esp
80102af0:	68 00 d6 10 80       	push   $0x8010d600
80102af5:	e8 e1 2a 00 00       	call   801055db <release>
80102afa:	83 c4 10             	add    $0x10,%esp
    return;
80102afd:	e9 9a 00 00 00       	jmp    80102b9c <ideintr+0xd7>
  }
  idequeue = b->qnext;
80102b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b05:	8b 40 58             	mov    0x58(%eax),%eax
80102b08:	a3 34 d6 10 80       	mov    %eax,0x8010d634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b10:	8b 00                	mov    (%eax),%eax
80102b12:	83 e0 04             	and    $0x4,%eax
80102b15:	85 c0                	test   %eax,%eax
80102b17:	75 2d                	jne    80102b46 <ideintr+0x81>
80102b19:	83 ec 0c             	sub    $0xc,%esp
80102b1c:	6a 01                	push   $0x1
80102b1e:	e8 1e fd ff ff       	call   80102841 <idewait>
80102b23:	83 c4 10             	add    $0x10,%esp
80102b26:	85 c0                	test   %eax,%eax
80102b28:	78 1c                	js     80102b46 <ideintr+0x81>
    insl(0x1f0, b->data, BSIZE/4);
80102b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2d:	83 c0 5c             	add    $0x5c,%eax
80102b30:	83 ec 04             	sub    $0x4,%esp
80102b33:	68 80 00 00 00       	push   $0x80
80102b38:	50                   	push   %eax
80102b39:	68 f0 01 00 00       	push   $0x1f0
80102b3e:	e8 91 fc ff ff       	call   801027d4 <insl>
80102b43:	83 c4 10             	add    $0x10,%esp

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b49:	8b 00                	mov    (%eax),%eax
80102b4b:	83 c8 02             	or     $0x2,%eax
80102b4e:	89 c2                	mov    %eax,%edx
80102b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b53:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b58:	8b 00                	mov    (%eax),%eax
80102b5a:	83 e0 fb             	and    $0xfffffffb,%eax
80102b5d:	89 c2                	mov    %eax,%edx
80102b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b62:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102b64:	83 ec 0c             	sub    $0xc,%esp
80102b67:	ff 75 f4             	pushl  -0xc(%ebp)
80102b6a:	e8 7a 26 00 00       	call   801051e9 <wakeup>
80102b6f:	83 c4 10             	add    $0x10,%esp

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102b72:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102b77:	85 c0                	test   %eax,%eax
80102b79:	74 11                	je     80102b8c <ideintr+0xc7>
    idestart(idequeue);
80102b7b:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	50                   	push   %eax
80102b84:	e8 a6 fd ff ff       	call   8010292f <idestart>
80102b89:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102b8c:	83 ec 0c             	sub    $0xc,%esp
80102b8f:	68 00 d6 10 80       	push   $0x8010d600
80102b94:	e8 42 2a 00 00       	call   801055db <release>
80102b99:	83 c4 10             	add    $0x10,%esp
}
80102b9c:	c9                   	leave  
80102b9d:	c3                   	ret    

80102b9e <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b9e:	f3 0f 1e fb          	endbr32 
80102ba2:	55                   	push   %ebp
80102ba3:	89 e5                	mov    %esp,%ebp
80102ba5:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80102bab:	83 c0 0c             	add    $0xc,%eax
80102bae:	83 ec 0c             	sub    $0xc,%esp
80102bb1:	50                   	push   %eax
80102bb2:	e8 f3 28 00 00       	call   801054aa <holdingsleep>
80102bb7:	83 c4 10             	add    $0x10,%esp
80102bba:	85 c0                	test   %eax,%eax
80102bbc:	75 0d                	jne    80102bcb <iderw+0x2d>
    panic("iderw: buf not locked");
80102bbe:	83 ec 0c             	sub    $0xc,%esp
80102bc1:	68 a2 97 10 80       	push   $0x801097a2
80102bc6:	e8 3d da ff ff       	call   80100608 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bce:	8b 00                	mov    (%eax),%eax
80102bd0:	83 e0 06             	and    $0x6,%eax
80102bd3:	83 f8 02             	cmp    $0x2,%eax
80102bd6:	75 0d                	jne    80102be5 <iderw+0x47>
    panic("iderw: nothing to do");
80102bd8:	83 ec 0c             	sub    $0xc,%esp
80102bdb:	68 b8 97 10 80       	push   $0x801097b8
80102be0:	e8 23 da ff ff       	call   80100608 <panic>
  if(b->dev != 0 && !havedisk1)
80102be5:	8b 45 08             	mov    0x8(%ebp),%eax
80102be8:	8b 40 04             	mov    0x4(%eax),%eax
80102beb:	85 c0                	test   %eax,%eax
80102bed:	74 16                	je     80102c05 <iderw+0x67>
80102bef:	a1 38 d6 10 80       	mov    0x8010d638,%eax
80102bf4:	85 c0                	test   %eax,%eax
80102bf6:	75 0d                	jne    80102c05 <iderw+0x67>
    panic("iderw: ide disk 1 not present");
80102bf8:	83 ec 0c             	sub    $0xc,%esp
80102bfb:	68 cd 97 10 80       	push   $0x801097cd
80102c00:	e8 03 da ff ff       	call   80100608 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102c05:	83 ec 0c             	sub    $0xc,%esp
80102c08:	68 00 d6 10 80       	push   $0x8010d600
80102c0d:	e8 57 29 00 00       	call   80105569 <acquire>
80102c12:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102c15:	8b 45 08             	mov    0x8(%ebp),%eax
80102c18:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c1f:	c7 45 f4 34 d6 10 80 	movl   $0x8010d634,-0xc(%ebp)
80102c26:	eb 0b                	jmp    80102c33 <iderw+0x95>
80102c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2b:	8b 00                	mov    (%eax),%eax
80102c2d:	83 c0 58             	add    $0x58,%eax
80102c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c36:	8b 00                	mov    (%eax),%eax
80102c38:	85 c0                	test   %eax,%eax
80102c3a:	75 ec                	jne    80102c28 <iderw+0x8a>
    ;
  *pp = b;
80102c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c3f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c42:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102c44:	a1 34 d6 10 80       	mov    0x8010d634,%eax
80102c49:	39 45 08             	cmp    %eax,0x8(%ebp)
80102c4c:	75 23                	jne    80102c71 <iderw+0xd3>
    idestart(b);
80102c4e:	83 ec 0c             	sub    $0xc,%esp
80102c51:	ff 75 08             	pushl  0x8(%ebp)
80102c54:	e8 d6 fc ff ff       	call   8010292f <idestart>
80102c59:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c5c:	eb 13                	jmp    80102c71 <iderw+0xd3>
    sleep(b, &idelock);
80102c5e:	83 ec 08             	sub    $0x8,%esp
80102c61:	68 00 d6 10 80       	push   $0x8010d600
80102c66:	ff 75 08             	pushl  0x8(%ebp)
80102c69:	e8 89 24 00 00       	call   801050f7 <sleep>
80102c6e:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c71:	8b 45 08             	mov    0x8(%ebp),%eax
80102c74:	8b 00                	mov    (%eax),%eax
80102c76:	83 e0 06             	and    $0x6,%eax
80102c79:	83 f8 02             	cmp    $0x2,%eax
80102c7c:	75 e0                	jne    80102c5e <iderw+0xc0>
  }


  release(&idelock);
80102c7e:	83 ec 0c             	sub    $0xc,%esp
80102c81:	68 00 d6 10 80       	push   $0x8010d600
80102c86:	e8 50 29 00 00       	call   801055db <release>
80102c8b:	83 c4 10             	add    $0x10,%esp
}
80102c8e:	90                   	nop
80102c8f:	c9                   	leave  
80102c90:	c3                   	ret    

80102c91 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102c91:	f3 0f 1e fb          	endbr32 
80102c95:	55                   	push   %ebp
80102c96:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102c98:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80102ca0:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102ca2:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102ca7:	8b 40 10             	mov    0x10(%eax),%eax
}
80102caa:	5d                   	pop    %ebp
80102cab:	c3                   	ret    

80102cac <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102cac:	f3 0f 1e fb          	endbr32 
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102cb3:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102cb8:	8b 55 08             	mov    0x8(%ebp),%edx
80102cbb:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102cbd:	a1 d4 56 11 80       	mov    0x801156d4,%eax
80102cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
80102cc5:	89 50 10             	mov    %edx,0x10(%eax)
}
80102cc8:	90                   	nop
80102cc9:	5d                   	pop    %ebp
80102cca:	c3                   	ret    

80102ccb <ioapicinit>:

void
ioapicinit(void)
{
80102ccb:	f3 0f 1e fb          	endbr32 
80102ccf:	55                   	push   %ebp
80102cd0:	89 e5                	mov    %esp,%ebp
80102cd2:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102cd5:	c7 05 d4 56 11 80 00 	movl   $0xfec00000,0x801156d4
80102cdc:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102cdf:	6a 01                	push   $0x1
80102ce1:	e8 ab ff ff ff       	call   80102c91 <ioapicread>
80102ce6:	83 c4 04             	add    $0x4,%esp
80102ce9:	c1 e8 10             	shr    $0x10,%eax
80102cec:	25 ff 00 00 00       	and    $0xff,%eax
80102cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102cf4:	6a 00                	push   $0x0
80102cf6:	e8 96 ff ff ff       	call   80102c91 <ioapicread>
80102cfb:	83 c4 04             	add    $0x4,%esp
80102cfe:	c1 e8 18             	shr    $0x18,%eax
80102d01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102d04:	0f b6 05 00 58 11 80 	movzbl 0x80115800,%eax
80102d0b:	0f b6 c0             	movzbl %al,%eax
80102d0e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102d11:	74 10                	je     80102d23 <ioapicinit+0x58>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	68 ec 97 10 80       	push   $0x801097ec
80102d1b:	e8 f8 d6 ff ff       	call   80100418 <cprintf>
80102d20:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102d2a:	eb 3f                	jmp    80102d6b <ioapicinit+0xa0>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d2f:	83 c0 20             	add    $0x20,%eax
80102d32:	0d 00 00 01 00       	or     $0x10000,%eax
80102d37:	89 c2                	mov    %eax,%edx
80102d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3c:	83 c0 08             	add    $0x8,%eax
80102d3f:	01 c0                	add    %eax,%eax
80102d41:	83 ec 08             	sub    $0x8,%esp
80102d44:	52                   	push   %edx
80102d45:	50                   	push   %eax
80102d46:	e8 61 ff ff ff       	call   80102cac <ioapicwrite>
80102d4b:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d51:	83 c0 08             	add    $0x8,%eax
80102d54:	01 c0                	add    %eax,%eax
80102d56:	83 c0 01             	add    $0x1,%eax
80102d59:	83 ec 08             	sub    $0x8,%esp
80102d5c:	6a 00                	push   $0x0
80102d5e:	50                   	push   %eax
80102d5f:	e8 48 ff ff ff       	call   80102cac <ioapicwrite>
80102d64:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102d67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102d71:	7e b9                	jle    80102d2c <ioapicinit+0x61>
  }
}
80102d73:	90                   	nop
80102d74:	90                   	nop
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    

80102d77 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102d77:	f3 0f 1e fb          	endbr32 
80102d7b:	55                   	push   %ebp
80102d7c:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102d81:	83 c0 20             	add    $0x20,%eax
80102d84:	89 c2                	mov    %eax,%edx
80102d86:	8b 45 08             	mov    0x8(%ebp),%eax
80102d89:	83 c0 08             	add    $0x8,%eax
80102d8c:	01 c0                	add    %eax,%eax
80102d8e:	52                   	push   %edx
80102d8f:	50                   	push   %eax
80102d90:	e8 17 ff ff ff       	call   80102cac <ioapicwrite>
80102d95:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d98:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d9b:	c1 e0 18             	shl    $0x18,%eax
80102d9e:	89 c2                	mov    %eax,%edx
80102da0:	8b 45 08             	mov    0x8(%ebp),%eax
80102da3:	83 c0 08             	add    $0x8,%eax
80102da6:	01 c0                	add    %eax,%eax
80102da8:	83 c0 01             	add    $0x1,%eax
80102dab:	52                   	push   %edx
80102dac:	50                   	push   %eax
80102dad:	e8 fa fe ff ff       	call   80102cac <ioapicwrite>
80102db2:	83 c4 08             	add    $0x8,%esp
}
80102db5:	90                   	nop
80102db6:	c9                   	leave  
80102db7:	c3                   	ret    

80102db8 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102db8:	f3 0f 1e fb          	endbr32 
80102dbc:	55                   	push   %ebp
80102dbd:	89 e5                	mov    %esp,%ebp
80102dbf:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102dc2:	83 ec 08             	sub    $0x8,%esp
80102dc5:	68 20 98 10 80       	push   $0x80109820
80102dca:	68 e0 56 11 80       	push   $0x801156e0
80102dcf:	e8 6f 27 00 00       	call   80105543 <initlock>
80102dd4:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102dd7:	c7 05 14 57 11 80 00 	movl   $0x0,0x80115714
80102dde:	00 00 00 
  freerange(vstart, vend);
80102de1:	83 ec 08             	sub    $0x8,%esp
80102de4:	ff 75 0c             	pushl  0xc(%ebp)
80102de7:	ff 75 08             	pushl  0x8(%ebp)
80102dea:	e8 2e 00 00 00       	call   80102e1d <freerange>
80102def:	83 c4 10             	add    $0x10,%esp
}
80102df2:	90                   	nop
80102df3:	c9                   	leave  
80102df4:	c3                   	ret    

80102df5 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102df5:	f3 0f 1e fb          	endbr32 
80102df9:	55                   	push   %ebp
80102dfa:	89 e5                	mov    %esp,%ebp
80102dfc:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102dff:	83 ec 08             	sub    $0x8,%esp
80102e02:	ff 75 0c             	pushl  0xc(%ebp)
80102e05:	ff 75 08             	pushl  0x8(%ebp)
80102e08:	e8 10 00 00 00       	call   80102e1d <freerange>
80102e0d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102e10:	c7 05 14 57 11 80 01 	movl   $0x1,0x80115714
80102e17:	00 00 00 
}
80102e1a:	90                   	nop
80102e1b:	c9                   	leave  
80102e1c:	c3                   	ret    

80102e1d <freerange>:

void
freerange(void *vstart, void *vend)
{
80102e1d:	f3 0f 1e fb          	endbr32 
80102e21:	55                   	push   %ebp
80102e22:	89 e5                	mov    %esp,%ebp
80102e24:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102e27:	8b 45 08             	mov    0x8(%ebp),%eax
80102e2a:	05 ff 0f 00 00       	add    $0xfff,%eax
80102e2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e37:	eb 15                	jmp    80102e4e <freerange+0x31>
    kfree(p);
80102e39:	83 ec 0c             	sub    $0xc,%esp
80102e3c:	ff 75 f4             	pushl  -0xc(%ebp)
80102e3f:	e8 1b 00 00 00       	call   80102e5f <kfree>
80102e44:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e47:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e51:	05 00 10 00 00       	add    $0x1000,%eax
80102e56:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102e59:	73 de                	jae    80102e39 <freerange+0x1c>
}
80102e5b:	90                   	nop
80102e5c:	90                   	nop
80102e5d:	c9                   	leave  
80102e5e:	c3                   	ret    

80102e5f <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102e5f:	f3 0f 1e fb          	endbr32 
80102e63:	55                   	push   %ebp
80102e64:	89 e5                	mov    %esp,%ebp
80102e66:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102e69:	8b 45 08             	mov    0x8(%ebp),%eax
80102e6c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102e71:	85 c0                	test   %eax,%eax
80102e73:	75 18                	jne    80102e8d <kfree+0x2e>
80102e75:	81 7d 08 48 a7 11 80 	cmpl   $0x8011a748,0x8(%ebp)
80102e7c:	72 0f                	jb     80102e8d <kfree+0x2e>
80102e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102e81:	05 00 00 00 80       	add    $0x80000000,%eax
80102e86:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102e8b:	76 0d                	jbe    80102e9a <kfree+0x3b>
    panic("kfree");
80102e8d:	83 ec 0c             	sub    $0xc,%esp
80102e90:	68 25 98 10 80       	push   $0x80109825
80102e95:	e8 6e d7 ff ff       	call   80100608 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102e9a:	83 ec 04             	sub    $0x4,%esp
80102e9d:	68 00 10 00 00       	push   $0x1000
80102ea2:	6a 01                	push   $0x1
80102ea4:	ff 75 08             	pushl  0x8(%ebp)
80102ea7:	e8 5c 29 00 00       	call   80105808 <memset>
80102eac:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102eaf:	a1 14 57 11 80       	mov    0x80115714,%eax
80102eb4:	85 c0                	test   %eax,%eax
80102eb6:	74 10                	je     80102ec8 <kfree+0x69>
    acquire(&kmem.lock);
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	68 e0 56 11 80       	push   $0x801156e0
80102ec0:	e8 a4 26 00 00       	call   80105569 <acquire>
80102ec5:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80102ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ece:	8b 15 18 57 11 80    	mov    0x80115718,%edx
80102ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed7:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102edc:	a3 18 57 11 80       	mov    %eax,0x80115718
  if(kmem.use_lock)
80102ee1:	a1 14 57 11 80       	mov    0x80115714,%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 10                	je     80102efa <kfree+0x9b>
    release(&kmem.lock);
80102eea:	83 ec 0c             	sub    $0xc,%esp
80102eed:	68 e0 56 11 80       	push   $0x801156e0
80102ef2:	e8 e4 26 00 00       	call   801055db <release>
80102ef7:	83 c4 10             	add    $0x10,%esp
}
80102efa:	90                   	nop
80102efb:	c9                   	leave  
80102efc:	c3                   	ret    

80102efd <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102efd:	f3 0f 1e fb          	endbr32 
80102f01:	55                   	push   %ebp
80102f02:	89 e5                	mov    %esp,%ebp
80102f04:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102f07:	a1 14 57 11 80       	mov    0x80115714,%eax
80102f0c:	85 c0                	test   %eax,%eax
80102f0e:	74 10                	je     80102f20 <kalloc+0x23>
    acquire(&kmem.lock);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 e0 56 11 80       	push   $0x801156e0
80102f18:	e8 4c 26 00 00       	call   80105569 <acquire>
80102f1d:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102f20:	a1 18 57 11 80       	mov    0x80115718,%eax
80102f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102f2c:	74 0a                	je     80102f38 <kalloc+0x3b>
    kmem.freelist = r->next;
80102f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f31:	8b 00                	mov    (%eax),%eax
80102f33:	a3 18 57 11 80       	mov    %eax,0x80115718
  if(kmem.use_lock)
80102f38:	a1 14 57 11 80       	mov    0x80115714,%eax
80102f3d:	85 c0                	test   %eax,%eax
80102f3f:	74 10                	je     80102f51 <kalloc+0x54>
    release(&kmem.lock);
80102f41:	83 ec 0c             	sub    $0xc,%esp
80102f44:	68 e0 56 11 80       	push   $0x801156e0
80102f49:	e8 8d 26 00 00       	call   801055db <release>
80102f4e:	83 c4 10             	add    $0x10,%esp
  cprintf("p4Debug : kalloc returns %d %x\n", PPN(V2P(r)), V2P(r));
80102f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f54:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80102f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f5d:	05 00 00 00 80       	add    $0x80000000,%eax
80102f62:	c1 e8 0c             	shr    $0xc,%eax
80102f65:	83 ec 04             	sub    $0x4,%esp
80102f68:	52                   	push   %edx
80102f69:	50                   	push   %eax
80102f6a:	68 2c 98 10 80       	push   $0x8010982c
80102f6f:	e8 a4 d4 ff ff       	call   80100418 <cprintf>
80102f74:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102f7a:	c9                   	leave  
80102f7b:	c3                   	ret    

80102f7c <inb>:
{
80102f7c:	55                   	push   %ebp
80102f7d:	89 e5                	mov    %esp,%ebp
80102f7f:	83 ec 14             	sub    $0x14,%esp
80102f82:	8b 45 08             	mov    0x8(%ebp),%eax
80102f85:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f89:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102f8d:	89 c2                	mov    %eax,%edx
80102f8f:	ec                   	in     (%dx),%al
80102f90:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f93:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f97:	c9                   	leave  
80102f98:	c3                   	ret    

80102f99 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f99:	f3 0f 1e fb          	endbr32 
80102f9d:	55                   	push   %ebp
80102f9e:	89 e5                	mov    %esp,%ebp
80102fa0:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102fa3:	6a 64                	push   $0x64
80102fa5:	e8 d2 ff ff ff       	call   80102f7c <inb>
80102faa:	83 c4 04             	add    $0x4,%esp
80102fad:	0f b6 c0             	movzbl %al,%eax
80102fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fb6:	83 e0 01             	and    $0x1,%eax
80102fb9:	85 c0                	test   %eax,%eax
80102fbb:	75 0a                	jne    80102fc7 <kbdgetc+0x2e>
    return -1;
80102fbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fc2:	e9 23 01 00 00       	jmp    801030ea <kbdgetc+0x151>
  data = inb(KBDATAP);
80102fc7:	6a 60                	push   $0x60
80102fc9:	e8 ae ff ff ff       	call   80102f7c <inb>
80102fce:	83 c4 04             	add    $0x4,%esp
80102fd1:	0f b6 c0             	movzbl %al,%eax
80102fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102fd7:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102fde:	75 17                	jne    80102ff7 <kbdgetc+0x5e>
    shift |= E0ESC;
80102fe0:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80102fe5:	83 c8 40             	or     $0x40,%eax
80102fe8:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
80102fed:	b8 00 00 00 00       	mov    $0x0,%eax
80102ff2:	e9 f3 00 00 00       	jmp    801030ea <kbdgetc+0x151>
  } else if(data & 0x80){
80102ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ffa:	25 80 00 00 00       	and    $0x80,%eax
80102fff:	85 c0                	test   %eax,%eax
80103001:	74 45                	je     80103048 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103003:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103008:	83 e0 40             	and    $0x40,%eax
8010300b:	85 c0                	test   %eax,%eax
8010300d:	75 08                	jne    80103017 <kbdgetc+0x7e>
8010300f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103012:	83 e0 7f             	and    $0x7f,%eax
80103015:	eb 03                	jmp    8010301a <kbdgetc+0x81>
80103017:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010301a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010301d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103020:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103025:	0f b6 00             	movzbl (%eax),%eax
80103028:	83 c8 40             	or     $0x40,%eax
8010302b:	0f b6 c0             	movzbl %al,%eax
8010302e:	f7 d0                	not    %eax
80103030:	89 c2                	mov    %eax,%edx
80103032:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103037:	21 d0                	and    %edx,%eax
80103039:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
    return 0;
8010303e:	b8 00 00 00 00       	mov    $0x0,%eax
80103043:	e9 a2 00 00 00       	jmp    801030ea <kbdgetc+0x151>
  } else if(shift & E0ESC){
80103048:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
8010304d:	83 e0 40             	and    $0x40,%eax
80103050:	85 c0                	test   %eax,%eax
80103052:	74 14                	je     80103068 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103054:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
8010305b:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103060:	83 e0 bf             	and    $0xffffffbf,%eax
80103063:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  }

  shift |= shiftcode[data];
80103068:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010306b:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103070:	0f b6 00             	movzbl (%eax),%eax
80103073:	0f b6 d0             	movzbl %al,%edx
80103076:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
8010307b:	09 d0                	or     %edx,%eax
8010307d:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  shift ^= togglecode[data];
80103082:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103085:	05 20 b1 10 80       	add    $0x8010b120,%eax
8010308a:	0f b6 00             	movzbl (%eax),%eax
8010308d:	0f b6 d0             	movzbl %al,%edx
80103090:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
80103095:	31 d0                	xor    %edx,%eax
80103097:	a3 3c d6 10 80       	mov    %eax,0x8010d63c
  c = charcode[shift & (CTL | SHIFT)][data];
8010309c:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
801030a1:	83 e0 03             	and    $0x3,%eax
801030a4:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
801030ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030ae:	01 d0                	add    %edx,%eax
801030b0:	0f b6 00             	movzbl (%eax),%eax
801030b3:	0f b6 c0             	movzbl %al,%eax
801030b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801030b9:	a1 3c d6 10 80       	mov    0x8010d63c,%eax
801030be:	83 e0 08             	and    $0x8,%eax
801030c1:	85 c0                	test   %eax,%eax
801030c3:	74 22                	je     801030e7 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
801030c5:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801030c9:	76 0c                	jbe    801030d7 <kbdgetc+0x13e>
801030cb:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801030cf:	77 06                	ja     801030d7 <kbdgetc+0x13e>
      c += 'A' - 'a';
801030d1:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
801030d5:	eb 10                	jmp    801030e7 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
801030d7:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801030db:	76 0a                	jbe    801030e7 <kbdgetc+0x14e>
801030dd:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801030e1:	77 04                	ja     801030e7 <kbdgetc+0x14e>
      c += 'a' - 'A';
801030e3:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
801030e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801030ea:	c9                   	leave  
801030eb:	c3                   	ret    

801030ec <kbdintr>:

void
kbdintr(void)
{
801030ec:	f3 0f 1e fb          	endbr32 
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
801030f6:	83 ec 0c             	sub    $0xc,%esp
801030f9:	68 99 2f 10 80       	push   $0x80102f99
801030fe:	e8 a5 d7 ff ff       	call   801008a8 <consoleintr>
80103103:	83 c4 10             	add    $0x10,%esp
}
80103106:	90                   	nop
80103107:	c9                   	leave  
80103108:	c3                   	ret    

80103109 <inb>:
{
80103109:	55                   	push   %ebp
8010310a:	89 e5                	mov    %esp,%ebp
8010310c:	83 ec 14             	sub    $0x14,%esp
8010310f:	8b 45 08             	mov    0x8(%ebp),%eax
80103112:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103116:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010311a:	89 c2                	mov    %eax,%edx
8010311c:	ec                   	in     (%dx),%al
8010311d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103120:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103124:	c9                   	leave  
80103125:	c3                   	ret    

80103126 <outb>:
{
80103126:	55                   	push   %ebp
80103127:	89 e5                	mov    %esp,%ebp
80103129:	83 ec 08             	sub    $0x8,%esp
8010312c:	8b 45 08             	mov    0x8(%ebp),%eax
8010312f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103132:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103136:	89 d0                	mov    %edx,%eax
80103138:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010313b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010313f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103143:	ee                   	out    %al,(%dx)
}
80103144:	90                   	nop
80103145:	c9                   	leave  
80103146:	c3                   	ret    

80103147 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80103147:	f3 0f 1e fb          	endbr32 
8010314b:	55                   	push   %ebp
8010314c:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010314e:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103153:	8b 55 08             	mov    0x8(%ebp),%edx
80103156:	c1 e2 02             	shl    $0x2,%edx
80103159:	01 c2                	add    %eax,%edx
8010315b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010315e:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80103160:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103165:	83 c0 20             	add    $0x20,%eax
80103168:	8b 00                	mov    (%eax),%eax
}
8010316a:	90                   	nop
8010316b:	5d                   	pop    %ebp
8010316c:	c3                   	ret    

8010316d <lapicinit>:

void
lapicinit(void)
{
8010316d:	f3 0f 1e fb          	endbr32 
80103171:	55                   	push   %ebp
80103172:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103174:	a1 1c 57 11 80       	mov    0x8011571c,%eax
80103179:	85 c0                	test   %eax,%eax
8010317b:	0f 84 0c 01 00 00    	je     8010328d <lapicinit+0x120>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103181:	68 3f 01 00 00       	push   $0x13f
80103186:	6a 3c                	push   $0x3c
80103188:	e8 ba ff ff ff       	call   80103147 <lapicw>
8010318d:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103190:	6a 0b                	push   $0xb
80103192:	68 f8 00 00 00       	push   $0xf8
80103197:	e8 ab ff ff ff       	call   80103147 <lapicw>
8010319c:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010319f:	68 20 00 02 00       	push   $0x20020
801031a4:	68 c8 00 00 00       	push   $0xc8
801031a9:	e8 99 ff ff ff       	call   80103147 <lapicw>
801031ae:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
801031b1:	68 80 96 98 00       	push   $0x989680
801031b6:	68 e0 00 00 00       	push   $0xe0
801031bb:	e8 87 ff ff ff       	call   80103147 <lapicw>
801031c0:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801031c3:	68 00 00 01 00       	push   $0x10000
801031c8:	68 d4 00 00 00       	push   $0xd4
801031cd:	e8 75 ff ff ff       	call   80103147 <lapicw>
801031d2:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801031d5:	68 00 00 01 00       	push   $0x10000
801031da:	68 d8 00 00 00       	push   $0xd8
801031df:	e8 63 ff ff ff       	call   80103147 <lapicw>
801031e4:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801031e7:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801031ec:	83 c0 30             	add    $0x30,%eax
801031ef:	8b 00                	mov    (%eax),%eax
801031f1:	c1 e8 10             	shr    $0x10,%eax
801031f4:	25 fc 00 00 00       	and    $0xfc,%eax
801031f9:	85 c0                	test   %eax,%eax
801031fb:	74 12                	je     8010320f <lapicinit+0xa2>
    lapicw(PCINT, MASKED);
801031fd:	68 00 00 01 00       	push   $0x10000
80103202:	68 d0 00 00 00       	push   $0xd0
80103207:	e8 3b ff ff ff       	call   80103147 <lapicw>
8010320c:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010320f:	6a 33                	push   $0x33
80103211:	68 dc 00 00 00       	push   $0xdc
80103216:	e8 2c ff ff ff       	call   80103147 <lapicw>
8010321b:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010321e:	6a 00                	push   $0x0
80103220:	68 a0 00 00 00       	push   $0xa0
80103225:	e8 1d ff ff ff       	call   80103147 <lapicw>
8010322a:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010322d:	6a 00                	push   $0x0
8010322f:	68 a0 00 00 00       	push   $0xa0
80103234:	e8 0e ff ff ff       	call   80103147 <lapicw>
80103239:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010323c:	6a 00                	push   $0x0
8010323e:	6a 2c                	push   $0x2c
80103240:	e8 02 ff ff ff       	call   80103147 <lapicw>
80103245:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103248:	6a 00                	push   $0x0
8010324a:	68 c4 00 00 00       	push   $0xc4
8010324f:	e8 f3 fe ff ff       	call   80103147 <lapicw>
80103254:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103257:	68 00 85 08 00       	push   $0x88500
8010325c:	68 c0 00 00 00       	push   $0xc0
80103261:	e8 e1 fe ff ff       	call   80103147 <lapicw>
80103266:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103269:	90                   	nop
8010326a:	a1 1c 57 11 80       	mov    0x8011571c,%eax
8010326f:	05 00 03 00 00       	add    $0x300,%eax
80103274:	8b 00                	mov    (%eax),%eax
80103276:	25 00 10 00 00       	and    $0x1000,%eax
8010327b:	85 c0                	test   %eax,%eax
8010327d:	75 eb                	jne    8010326a <lapicinit+0xfd>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010327f:	6a 00                	push   $0x0
80103281:	6a 20                	push   $0x20
80103283:	e8 bf fe ff ff       	call   80103147 <lapicw>
80103288:	83 c4 08             	add    $0x8,%esp
8010328b:	eb 01                	jmp    8010328e <lapicinit+0x121>
    return;
8010328d:	90                   	nop
}
8010328e:	c9                   	leave  
8010328f:	c3                   	ret    

80103290 <lapicid>:

int
lapicid(void)
{
80103290:	f3 0f 1e fb          	endbr32 
80103294:	55                   	push   %ebp
80103295:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80103297:	a1 1c 57 11 80       	mov    0x8011571c,%eax
8010329c:	85 c0                	test   %eax,%eax
8010329e:	75 07                	jne    801032a7 <lapicid+0x17>
    return 0;
801032a0:	b8 00 00 00 00       	mov    $0x0,%eax
801032a5:	eb 0d                	jmp    801032b4 <lapicid+0x24>
  return lapic[ID] >> 24;
801032a7:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801032ac:	83 c0 20             	add    $0x20,%eax
801032af:	8b 00                	mov    (%eax),%eax
801032b1:	c1 e8 18             	shr    $0x18,%eax
}
801032b4:	5d                   	pop    %ebp
801032b5:	c3                   	ret    

801032b6 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801032b6:	f3 0f 1e fb          	endbr32 
801032ba:	55                   	push   %ebp
801032bb:	89 e5                	mov    %esp,%ebp
  if(lapic)
801032bd:	a1 1c 57 11 80       	mov    0x8011571c,%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 0c                	je     801032d2 <lapiceoi+0x1c>
    lapicw(EOI, 0);
801032c6:	6a 00                	push   $0x0
801032c8:	6a 2c                	push   $0x2c
801032ca:	e8 78 fe ff ff       	call   80103147 <lapicw>
801032cf:	83 c4 08             	add    $0x8,%esp
}
801032d2:	90                   	nop
801032d3:	c9                   	leave  
801032d4:	c3                   	ret    

801032d5 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801032d5:	f3 0f 1e fb          	endbr32 
801032d9:	55                   	push   %ebp
801032da:	89 e5                	mov    %esp,%ebp
}
801032dc:	90                   	nop
801032dd:	5d                   	pop    %ebp
801032de:	c3                   	ret    

801032df <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801032df:	f3 0f 1e fb          	endbr32 
801032e3:	55                   	push   %ebp
801032e4:	89 e5                	mov    %esp,%ebp
801032e6:	83 ec 14             	sub    $0x14,%esp
801032e9:	8b 45 08             	mov    0x8(%ebp),%eax
801032ec:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801032ef:	6a 0f                	push   $0xf
801032f1:	6a 70                	push   $0x70
801032f3:	e8 2e fe ff ff       	call   80103126 <outb>
801032f8:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801032fb:	6a 0a                	push   $0xa
801032fd:	6a 71                	push   $0x71
801032ff:	e8 22 fe ff ff       	call   80103126 <outb>
80103304:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103307:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010330e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103311:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103316:	8b 45 0c             	mov    0xc(%ebp),%eax
80103319:	c1 e8 04             	shr    $0x4,%eax
8010331c:	89 c2                	mov    %eax,%edx
8010331e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103321:	83 c0 02             	add    $0x2,%eax
80103324:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103327:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010332b:	c1 e0 18             	shl    $0x18,%eax
8010332e:	50                   	push   %eax
8010332f:	68 c4 00 00 00       	push   $0xc4
80103334:	e8 0e fe ff ff       	call   80103147 <lapicw>
80103339:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010333c:	68 00 c5 00 00       	push   $0xc500
80103341:	68 c0 00 00 00       	push   $0xc0
80103346:	e8 fc fd ff ff       	call   80103147 <lapicw>
8010334b:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010334e:	68 c8 00 00 00       	push   $0xc8
80103353:	e8 7d ff ff ff       	call   801032d5 <microdelay>
80103358:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010335b:	68 00 85 00 00       	push   $0x8500
80103360:	68 c0 00 00 00       	push   $0xc0
80103365:	e8 dd fd ff ff       	call   80103147 <lapicw>
8010336a:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010336d:	6a 64                	push   $0x64
8010336f:	e8 61 ff ff ff       	call   801032d5 <microdelay>
80103374:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103377:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010337e:	eb 3d                	jmp    801033bd <lapicstartap+0xde>
    lapicw(ICRHI, apicid<<24);
80103380:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103384:	c1 e0 18             	shl    $0x18,%eax
80103387:	50                   	push   %eax
80103388:	68 c4 00 00 00       	push   $0xc4
8010338d:	e8 b5 fd ff ff       	call   80103147 <lapicw>
80103392:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103395:	8b 45 0c             	mov    0xc(%ebp),%eax
80103398:	c1 e8 0c             	shr    $0xc,%eax
8010339b:	80 cc 06             	or     $0x6,%ah
8010339e:	50                   	push   %eax
8010339f:	68 c0 00 00 00       	push   $0xc0
801033a4:	e8 9e fd ff ff       	call   80103147 <lapicw>
801033a9:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801033ac:	68 c8 00 00 00       	push   $0xc8
801033b1:	e8 1f ff ff ff       	call   801032d5 <microdelay>
801033b6:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801033b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801033bd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801033c1:	7e bd                	jle    80103380 <lapicstartap+0xa1>
  }
}
801033c3:	90                   	nop
801033c4:	90                   	nop
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    

801033c7 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
801033c7:	f3 0f 1e fb          	endbr32 
801033cb:	55                   	push   %ebp
801033cc:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801033ce:	8b 45 08             	mov    0x8(%ebp),%eax
801033d1:	0f b6 c0             	movzbl %al,%eax
801033d4:	50                   	push   %eax
801033d5:	6a 70                	push   $0x70
801033d7:	e8 4a fd ff ff       	call   80103126 <outb>
801033dc:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801033df:	68 c8 00 00 00       	push   $0xc8
801033e4:	e8 ec fe ff ff       	call   801032d5 <microdelay>
801033e9:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801033ec:	6a 71                	push   $0x71
801033ee:	e8 16 fd ff ff       	call   80103109 <inb>
801033f3:	83 c4 04             	add    $0x4,%esp
801033f6:	0f b6 c0             	movzbl %al,%eax
}
801033f9:	c9                   	leave  
801033fa:	c3                   	ret    

801033fb <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801033fb:	f3 0f 1e fb          	endbr32 
801033ff:	55                   	push   %ebp
80103400:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103402:	6a 00                	push   $0x0
80103404:	e8 be ff ff ff       	call   801033c7 <cmos_read>
80103409:	83 c4 04             	add    $0x4,%esp
8010340c:	8b 55 08             	mov    0x8(%ebp),%edx
8010340f:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103411:	6a 02                	push   $0x2
80103413:	e8 af ff ff ff       	call   801033c7 <cmos_read>
80103418:	83 c4 04             	add    $0x4,%esp
8010341b:	8b 55 08             	mov    0x8(%ebp),%edx
8010341e:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103421:	6a 04                	push   $0x4
80103423:	e8 9f ff ff ff       	call   801033c7 <cmos_read>
80103428:	83 c4 04             	add    $0x4,%esp
8010342b:	8b 55 08             	mov    0x8(%ebp),%edx
8010342e:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103431:	6a 07                	push   $0x7
80103433:	e8 8f ff ff ff       	call   801033c7 <cmos_read>
80103438:	83 c4 04             	add    $0x4,%esp
8010343b:	8b 55 08             	mov    0x8(%ebp),%edx
8010343e:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
80103441:	6a 08                	push   $0x8
80103443:	e8 7f ff ff ff       	call   801033c7 <cmos_read>
80103448:	83 c4 04             	add    $0x4,%esp
8010344b:	8b 55 08             	mov    0x8(%ebp),%edx
8010344e:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
80103451:	6a 09                	push   $0x9
80103453:	e8 6f ff ff ff       	call   801033c7 <cmos_read>
80103458:	83 c4 04             	add    $0x4,%esp
8010345b:	8b 55 08             	mov    0x8(%ebp),%edx
8010345e:	89 42 14             	mov    %eax,0x14(%edx)
}
80103461:	90                   	nop
80103462:	c9                   	leave  
80103463:	c3                   	ret    

80103464 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103464:	f3 0f 1e fb          	endbr32 
80103468:	55                   	push   %ebp
80103469:	89 e5                	mov    %esp,%ebp
8010346b:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010346e:	6a 0b                	push   $0xb
80103470:	e8 52 ff ff ff       	call   801033c7 <cmos_read>
80103475:	83 c4 04             	add    $0x4,%esp
80103478:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010347e:	83 e0 04             	and    $0x4,%eax
80103481:	85 c0                	test   %eax,%eax
80103483:	0f 94 c0             	sete   %al
80103486:	0f b6 c0             	movzbl %al,%eax
80103489:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010348c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010348f:	50                   	push   %eax
80103490:	e8 66 ff ff ff       	call   801033fb <fill_rtcdate>
80103495:	83 c4 04             	add    $0x4,%esp
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103498:	6a 0a                	push   $0xa
8010349a:	e8 28 ff ff ff       	call   801033c7 <cmos_read>
8010349f:	83 c4 04             	add    $0x4,%esp
801034a2:	25 80 00 00 00       	and    $0x80,%eax
801034a7:	85 c0                	test   %eax,%eax
801034a9:	75 27                	jne    801034d2 <cmostime+0x6e>
        continue;
    fill_rtcdate(&t2);
801034ab:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034ae:	50                   	push   %eax
801034af:	e8 47 ff ff ff       	call   801033fb <fill_rtcdate>
801034b4:	83 c4 04             	add    $0x4,%esp
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801034b7:	83 ec 04             	sub    $0x4,%esp
801034ba:	6a 18                	push   $0x18
801034bc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034bf:	50                   	push   %eax
801034c0:	8d 45 d8             	lea    -0x28(%ebp),%eax
801034c3:	50                   	push   %eax
801034c4:	e8 aa 23 00 00       	call   80105873 <memcmp>
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 05                	je     801034d5 <cmostime+0x71>
801034d0:	eb ba                	jmp    8010348c <cmostime+0x28>
        continue;
801034d2:	90                   	nop
    fill_rtcdate(&t1);
801034d3:	eb b7                	jmp    8010348c <cmostime+0x28>
      break;
801034d5:	90                   	nop
  }

  // convert
  if(bcd) {
801034d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801034da:	0f 84 b4 00 00 00    	je     80103594 <cmostime+0x130>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801034e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801034e3:	c1 e8 04             	shr    $0x4,%eax
801034e6:	89 c2                	mov    %eax,%edx
801034e8:	89 d0                	mov    %edx,%eax
801034ea:	c1 e0 02             	shl    $0x2,%eax
801034ed:	01 d0                	add    %edx,%eax
801034ef:	01 c0                	add    %eax,%eax
801034f1:	89 c2                	mov    %eax,%edx
801034f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801034f6:	83 e0 0f             	and    $0xf,%eax
801034f9:	01 d0                	add    %edx,%eax
801034fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801034fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103501:	c1 e8 04             	shr    $0x4,%eax
80103504:	89 c2                	mov    %eax,%edx
80103506:	89 d0                	mov    %edx,%eax
80103508:	c1 e0 02             	shl    $0x2,%eax
8010350b:	01 d0                	add    %edx,%eax
8010350d:	01 c0                	add    %eax,%eax
8010350f:	89 c2                	mov    %eax,%edx
80103511:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103514:	83 e0 0f             	and    $0xf,%eax
80103517:	01 d0                	add    %edx,%eax
80103519:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010351c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010351f:	c1 e8 04             	shr    $0x4,%eax
80103522:	89 c2                	mov    %eax,%edx
80103524:	89 d0                	mov    %edx,%eax
80103526:	c1 e0 02             	shl    $0x2,%eax
80103529:	01 d0                	add    %edx,%eax
8010352b:	01 c0                	add    %eax,%eax
8010352d:	89 c2                	mov    %eax,%edx
8010352f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103532:	83 e0 0f             	and    $0xf,%eax
80103535:	01 d0                	add    %edx,%eax
80103537:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010353a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010353d:	c1 e8 04             	shr    $0x4,%eax
80103540:	89 c2                	mov    %eax,%edx
80103542:	89 d0                	mov    %edx,%eax
80103544:	c1 e0 02             	shl    $0x2,%eax
80103547:	01 d0                	add    %edx,%eax
80103549:	01 c0                	add    %eax,%eax
8010354b:	89 c2                	mov    %eax,%edx
8010354d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103550:	83 e0 0f             	and    $0xf,%eax
80103553:	01 d0                	add    %edx,%eax
80103555:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103558:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010355b:	c1 e8 04             	shr    $0x4,%eax
8010355e:	89 c2                	mov    %eax,%edx
80103560:	89 d0                	mov    %edx,%eax
80103562:	c1 e0 02             	shl    $0x2,%eax
80103565:	01 d0                	add    %edx,%eax
80103567:	01 c0                	add    %eax,%eax
80103569:	89 c2                	mov    %eax,%edx
8010356b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010356e:	83 e0 0f             	and    $0xf,%eax
80103571:	01 d0                	add    %edx,%eax
80103573:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103576:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103579:	c1 e8 04             	shr    $0x4,%eax
8010357c:	89 c2                	mov    %eax,%edx
8010357e:	89 d0                	mov    %edx,%eax
80103580:	c1 e0 02             	shl    $0x2,%eax
80103583:	01 d0                	add    %edx,%eax
80103585:	01 c0                	add    %eax,%eax
80103587:	89 c2                	mov    %eax,%edx
80103589:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010358c:	83 e0 0f             	and    $0xf,%eax
8010358f:	01 d0                	add    %edx,%eax
80103591:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103594:	8b 45 08             	mov    0x8(%ebp),%eax
80103597:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010359a:	89 10                	mov    %edx,(%eax)
8010359c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010359f:	89 50 04             	mov    %edx,0x4(%eax)
801035a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801035a5:	89 50 08             	mov    %edx,0x8(%eax)
801035a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801035ab:	89 50 0c             	mov    %edx,0xc(%eax)
801035ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035b1:	89 50 10             	mov    %edx,0x10(%eax)
801035b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801035b7:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801035ba:	8b 45 08             	mov    0x8(%ebp),%eax
801035bd:	8b 40 14             	mov    0x14(%eax),%eax
801035c0:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801035c6:	8b 45 08             	mov    0x8(%ebp),%eax
801035c9:	89 50 14             	mov    %edx,0x14(%eax)
}
801035cc:	90                   	nop
801035cd:	c9                   	leave  
801035ce:	c3                   	ret    

801035cf <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801035cf:	f3 0f 1e fb          	endbr32 
801035d3:	55                   	push   %ebp
801035d4:	89 e5                	mov    %esp,%ebp
801035d6:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801035d9:	83 ec 08             	sub    $0x8,%esp
801035dc:	68 4c 98 10 80       	push   $0x8010984c
801035e1:	68 20 57 11 80       	push   $0x80115720
801035e6:	e8 58 1f 00 00       	call   80105543 <initlock>
801035eb:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801035ee:	83 ec 08             	sub    $0x8,%esp
801035f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801035f4:	50                   	push   %eax
801035f5:	ff 75 08             	pushl  0x8(%ebp)
801035f8:	e8 d3 df ff ff       	call   801015d0 <readsb>
801035fd:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103600:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103603:	a3 54 57 11 80       	mov    %eax,0x80115754
  log.size = sb.nlog;
80103608:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010360b:	a3 58 57 11 80       	mov    %eax,0x80115758
  log.dev = dev;
80103610:	8b 45 08             	mov    0x8(%ebp),%eax
80103613:	a3 64 57 11 80       	mov    %eax,0x80115764
  recover_from_log();
80103618:	e8 bf 01 00 00       	call   801037dc <recover_from_log>
}
8010361d:	90                   	nop
8010361e:	c9                   	leave  
8010361f:	c3                   	ret    

80103620 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103620:	f3 0f 1e fb          	endbr32 
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010362a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103631:	e9 95 00 00 00       	jmp    801036cb <install_trans+0xab>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103636:	8b 15 54 57 11 80    	mov    0x80115754,%edx
8010363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010363f:	01 d0                	add    %edx,%eax
80103641:	83 c0 01             	add    $0x1,%eax
80103644:	89 c2                	mov    %eax,%edx
80103646:	a1 64 57 11 80       	mov    0x80115764,%eax
8010364b:	83 ec 08             	sub    $0x8,%esp
8010364e:	52                   	push   %edx
8010364f:	50                   	push   %eax
80103650:	e8 82 cb ff ff       	call   801001d7 <bread>
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010365e:	83 c0 10             	add    $0x10,%eax
80103661:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
80103668:	89 c2                	mov    %eax,%edx
8010366a:	a1 64 57 11 80       	mov    0x80115764,%eax
8010366f:	83 ec 08             	sub    $0x8,%esp
80103672:	52                   	push   %edx
80103673:	50                   	push   %eax
80103674:	e8 5e cb ff ff       	call   801001d7 <bread>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103682:	8d 50 5c             	lea    0x5c(%eax),%edx
80103685:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103688:	83 c0 5c             	add    $0x5c,%eax
8010368b:	83 ec 04             	sub    $0x4,%esp
8010368e:	68 00 02 00 00       	push   $0x200
80103693:	52                   	push   %edx
80103694:	50                   	push   %eax
80103695:	e8 35 22 00 00       	call   801058cf <memmove>
8010369a:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010369d:	83 ec 0c             	sub    $0xc,%esp
801036a0:	ff 75 ec             	pushl  -0x14(%ebp)
801036a3:	e8 6c cb ff ff       	call   80100214 <bwrite>
801036a8:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	ff 75 f0             	pushl  -0x10(%ebp)
801036b1:	e8 ab cb ff ff       	call   80100261 <brelse>
801036b6:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801036b9:	83 ec 0c             	sub    $0xc,%esp
801036bc:	ff 75 ec             	pushl  -0x14(%ebp)
801036bf:	e8 9d cb ff ff       	call   80100261 <brelse>
801036c4:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801036c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036cb:	a1 68 57 11 80       	mov    0x80115768,%eax
801036d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801036d3:	0f 8c 5d ff ff ff    	jl     80103636 <install_trans+0x16>
  }
}
801036d9:	90                   	nop
801036da:	90                   	nop
801036db:	c9                   	leave  
801036dc:	c3                   	ret    

801036dd <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801036dd:	f3 0f 1e fb          	endbr32 
801036e1:	55                   	push   %ebp
801036e2:	89 e5                	mov    %esp,%ebp
801036e4:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801036e7:	a1 54 57 11 80       	mov    0x80115754,%eax
801036ec:	89 c2                	mov    %eax,%edx
801036ee:	a1 64 57 11 80       	mov    0x80115764,%eax
801036f3:	83 ec 08             	sub    $0x8,%esp
801036f6:	52                   	push   %edx
801036f7:	50                   	push   %eax
801036f8:	e8 da ca ff ff       	call   801001d7 <bread>
801036fd:	83 c4 10             	add    $0x10,%esp
80103700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103706:	83 c0 5c             	add    $0x5c,%eax
80103709:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010370f:	8b 00                	mov    (%eax),%eax
80103711:	a3 68 57 11 80       	mov    %eax,0x80115768
  for (i = 0; i < log.lh.n; i++) {
80103716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010371d:	eb 1b                	jmp    8010373a <read_head+0x5d>
    log.lh.block[i] = lh->block[i];
8010371f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103722:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103725:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103729:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010372c:	83 c2 10             	add    $0x10,%edx
8010372f:	89 04 95 2c 57 11 80 	mov    %eax,-0x7feea8d4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103736:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010373a:	a1 68 57 11 80       	mov    0x80115768,%eax
8010373f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103742:	7c db                	jl     8010371f <read_head+0x42>
  }
  brelse(buf);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	ff 75 f0             	pushl  -0x10(%ebp)
8010374a:	e8 12 cb ff ff       	call   80100261 <brelse>
8010374f:	83 c4 10             	add    $0x10,%esp
}
80103752:	90                   	nop
80103753:	c9                   	leave  
80103754:	c3                   	ret    

80103755 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103755:	f3 0f 1e fb          	endbr32 
80103759:	55                   	push   %ebp
8010375a:	89 e5                	mov    %esp,%ebp
8010375c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010375f:	a1 54 57 11 80       	mov    0x80115754,%eax
80103764:	89 c2                	mov    %eax,%edx
80103766:	a1 64 57 11 80       	mov    0x80115764,%eax
8010376b:	83 ec 08             	sub    $0x8,%esp
8010376e:	52                   	push   %edx
8010376f:	50                   	push   %eax
80103770:	e8 62 ca ff ff       	call   801001d7 <bread>
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010377e:	83 c0 5c             	add    $0x5c,%eax
80103781:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103784:	8b 15 68 57 11 80    	mov    0x80115768,%edx
8010378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010378d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010378f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103796:	eb 1b                	jmp    801037b3 <write_head+0x5e>
    hb->block[i] = log.lh.block[i];
80103798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010379b:	83 c0 10             	add    $0x10,%eax
8010379e:	8b 0c 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%ecx
801037a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037ab:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801037af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037b3:	a1 68 57 11 80       	mov    0x80115768,%eax
801037b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037bb:	7c db                	jl     80103798 <write_head+0x43>
  }
  bwrite(buf);
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	ff 75 f0             	pushl  -0x10(%ebp)
801037c3:	e8 4c ca ff ff       	call   80100214 <bwrite>
801037c8:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801037cb:	83 ec 0c             	sub    $0xc,%esp
801037ce:	ff 75 f0             	pushl  -0x10(%ebp)
801037d1:	e8 8b ca ff ff       	call   80100261 <brelse>
801037d6:	83 c4 10             	add    $0x10,%esp
}
801037d9:	90                   	nop
801037da:	c9                   	leave  
801037db:	c3                   	ret    

801037dc <recover_from_log>:

static void
recover_from_log(void)
{
801037dc:	f3 0f 1e fb          	endbr32 
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  read_head();
801037e6:	e8 f2 fe ff ff       	call   801036dd <read_head>
  install_trans(); // if committed, copy from log to disk
801037eb:	e8 30 fe ff ff       	call   80103620 <install_trans>
  log.lh.n = 0;
801037f0:	c7 05 68 57 11 80 00 	movl   $0x0,0x80115768
801037f7:	00 00 00 
  write_head(); // clear the log
801037fa:	e8 56 ff ff ff       	call   80103755 <write_head>
}
801037ff:	90                   	nop
80103800:	c9                   	leave  
80103801:	c3                   	ret    

80103802 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103802:	f3 0f 1e fb          	endbr32 
80103806:	55                   	push   %ebp
80103807:	89 e5                	mov    %esp,%ebp
80103809:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	68 20 57 11 80       	push   $0x80115720
80103814:	e8 50 1d 00 00       	call   80105569 <acquire>
80103819:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010381c:	a1 60 57 11 80       	mov    0x80115760,%eax
80103821:	85 c0                	test   %eax,%eax
80103823:	74 17                	je     8010383c <begin_op+0x3a>
      sleep(&log, &log.lock);
80103825:	83 ec 08             	sub    $0x8,%esp
80103828:	68 20 57 11 80       	push   $0x80115720
8010382d:	68 20 57 11 80       	push   $0x80115720
80103832:	e8 c0 18 00 00       	call   801050f7 <sleep>
80103837:	83 c4 10             	add    $0x10,%esp
8010383a:	eb e0                	jmp    8010381c <begin_op+0x1a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010383c:	8b 0d 68 57 11 80    	mov    0x80115768,%ecx
80103842:	a1 5c 57 11 80       	mov    0x8011575c,%eax
80103847:	8d 50 01             	lea    0x1(%eax),%edx
8010384a:	89 d0                	mov    %edx,%eax
8010384c:	c1 e0 02             	shl    $0x2,%eax
8010384f:	01 d0                	add    %edx,%eax
80103851:	01 c0                	add    %eax,%eax
80103853:	01 c8                	add    %ecx,%eax
80103855:	83 f8 1e             	cmp    $0x1e,%eax
80103858:	7e 17                	jle    80103871 <begin_op+0x6f>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010385a:	83 ec 08             	sub    $0x8,%esp
8010385d:	68 20 57 11 80       	push   $0x80115720
80103862:	68 20 57 11 80       	push   $0x80115720
80103867:	e8 8b 18 00 00       	call   801050f7 <sleep>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	eb ab                	jmp    8010381c <begin_op+0x1a>
    } else {
      log.outstanding += 1;
80103871:	a1 5c 57 11 80       	mov    0x8011575c,%eax
80103876:	83 c0 01             	add    $0x1,%eax
80103879:	a3 5c 57 11 80       	mov    %eax,0x8011575c
      release(&log.lock);
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	68 20 57 11 80       	push   $0x80115720
80103886:	e8 50 1d 00 00       	call   801055db <release>
8010388b:	83 c4 10             	add    $0x10,%esp
      break;
8010388e:	90                   	nop
    }
  }
}
8010388f:	90                   	nop
80103890:	c9                   	leave  
80103891:	c3                   	ret    

80103892 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103892:	f3 0f 1e fb          	endbr32 
80103896:	55                   	push   %ebp
80103897:	89 e5                	mov    %esp,%ebp
80103899:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010389c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801038a3:	83 ec 0c             	sub    $0xc,%esp
801038a6:	68 20 57 11 80       	push   $0x80115720
801038ab:	e8 b9 1c 00 00       	call   80105569 <acquire>
801038b0:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801038b3:	a1 5c 57 11 80       	mov    0x8011575c,%eax
801038b8:	83 e8 01             	sub    $0x1,%eax
801038bb:	a3 5c 57 11 80       	mov    %eax,0x8011575c
  if(log.committing)
801038c0:	a1 60 57 11 80       	mov    0x80115760,%eax
801038c5:	85 c0                	test   %eax,%eax
801038c7:	74 0d                	je     801038d6 <end_op+0x44>
    panic("log.committing");
801038c9:	83 ec 0c             	sub    $0xc,%esp
801038cc:	68 50 98 10 80       	push   $0x80109850
801038d1:	e8 32 cd ff ff       	call   80100608 <panic>
  if(log.outstanding == 0){
801038d6:	a1 5c 57 11 80       	mov    0x8011575c,%eax
801038db:	85 c0                	test   %eax,%eax
801038dd:	75 13                	jne    801038f2 <end_op+0x60>
    do_commit = 1;
801038df:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801038e6:	c7 05 60 57 11 80 01 	movl   $0x1,0x80115760
801038ed:	00 00 00 
801038f0:	eb 10                	jmp    80103902 <end_op+0x70>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801038f2:	83 ec 0c             	sub    $0xc,%esp
801038f5:	68 20 57 11 80       	push   $0x80115720
801038fa:	e8 ea 18 00 00       	call   801051e9 <wakeup>
801038ff:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103902:	83 ec 0c             	sub    $0xc,%esp
80103905:	68 20 57 11 80       	push   $0x80115720
8010390a:	e8 cc 1c 00 00       	call   801055db <release>
8010390f:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103916:	74 3f                	je     80103957 <end_op+0xc5>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103918:	e8 fa 00 00 00       	call   80103a17 <commit>
    acquire(&log.lock);
8010391d:	83 ec 0c             	sub    $0xc,%esp
80103920:	68 20 57 11 80       	push   $0x80115720
80103925:	e8 3f 1c 00 00       	call   80105569 <acquire>
8010392a:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010392d:	c7 05 60 57 11 80 00 	movl   $0x0,0x80115760
80103934:	00 00 00 
    wakeup(&log);
80103937:	83 ec 0c             	sub    $0xc,%esp
8010393a:	68 20 57 11 80       	push   $0x80115720
8010393f:	e8 a5 18 00 00       	call   801051e9 <wakeup>
80103944:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103947:	83 ec 0c             	sub    $0xc,%esp
8010394a:	68 20 57 11 80       	push   $0x80115720
8010394f:	e8 87 1c 00 00       	call   801055db <release>
80103954:	83 c4 10             	add    $0x10,%esp
  }
}
80103957:	90                   	nop
80103958:	c9                   	leave  
80103959:	c3                   	ret    

8010395a <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010395a:	f3 0f 1e fb          	endbr32 
8010395e:	55                   	push   %ebp
8010395f:	89 e5                	mov    %esp,%ebp
80103961:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103964:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010396b:	e9 95 00 00 00       	jmp    80103a05 <write_log+0xab>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103970:	8b 15 54 57 11 80    	mov    0x80115754,%edx
80103976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103979:	01 d0                	add    %edx,%eax
8010397b:	83 c0 01             	add    $0x1,%eax
8010397e:	89 c2                	mov    %eax,%edx
80103980:	a1 64 57 11 80       	mov    0x80115764,%eax
80103985:	83 ec 08             	sub    $0x8,%esp
80103988:	52                   	push   %edx
80103989:	50                   	push   %eax
8010398a:	e8 48 c8 ff ff       	call   801001d7 <bread>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103998:	83 c0 10             	add    $0x10,%eax
8010399b:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
801039a2:	89 c2                	mov    %eax,%edx
801039a4:	a1 64 57 11 80       	mov    0x80115764,%eax
801039a9:	83 ec 08             	sub    $0x8,%esp
801039ac:	52                   	push   %edx
801039ad:	50                   	push   %eax
801039ae:	e8 24 c8 ff ff       	call   801001d7 <bread>
801039b3:	83 c4 10             	add    $0x10,%esp
801039b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801039b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039bc:	8d 50 5c             	lea    0x5c(%eax),%edx
801039bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039c2:	83 c0 5c             	add    $0x5c,%eax
801039c5:	83 ec 04             	sub    $0x4,%esp
801039c8:	68 00 02 00 00       	push   $0x200
801039cd:	52                   	push   %edx
801039ce:	50                   	push   %eax
801039cf:	e8 fb 1e 00 00       	call   801058cf <memmove>
801039d4:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801039d7:	83 ec 0c             	sub    $0xc,%esp
801039da:	ff 75 f0             	pushl  -0x10(%ebp)
801039dd:	e8 32 c8 ff ff       	call   80100214 <bwrite>
801039e2:	83 c4 10             	add    $0x10,%esp
    brelse(from);
801039e5:	83 ec 0c             	sub    $0xc,%esp
801039e8:	ff 75 ec             	pushl  -0x14(%ebp)
801039eb:	e8 71 c8 ff ff       	call   80100261 <brelse>
801039f0:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801039f3:	83 ec 0c             	sub    $0xc,%esp
801039f6:	ff 75 f0             	pushl  -0x10(%ebp)
801039f9:	e8 63 c8 ff ff       	call   80100261 <brelse>
801039fe:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103a01:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a05:	a1 68 57 11 80       	mov    0x80115768,%eax
80103a0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a0d:	0f 8c 5d ff ff ff    	jl     80103970 <write_log+0x16>
  }
}
80103a13:	90                   	nop
80103a14:	90                   	nop
80103a15:	c9                   	leave  
80103a16:	c3                   	ret    

80103a17 <commit>:

static void
commit()
{
80103a17:	f3 0f 1e fb          	endbr32 
80103a1b:	55                   	push   %ebp
80103a1c:	89 e5                	mov    %esp,%ebp
80103a1e:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a21:	a1 68 57 11 80       	mov    0x80115768,%eax
80103a26:	85 c0                	test   %eax,%eax
80103a28:	7e 1e                	jle    80103a48 <commit+0x31>
    write_log();     // Write modified blocks from cache to log
80103a2a:	e8 2b ff ff ff       	call   8010395a <write_log>
    write_head();    // Write header to disk -- the real commit
80103a2f:	e8 21 fd ff ff       	call   80103755 <write_head>
    install_trans(); // Now install writes to home locations
80103a34:	e8 e7 fb ff ff       	call   80103620 <install_trans>
    log.lh.n = 0;
80103a39:	c7 05 68 57 11 80 00 	movl   $0x0,0x80115768
80103a40:	00 00 00 
    write_head();    // Erase the transaction from the log
80103a43:	e8 0d fd ff ff       	call   80103755 <write_head>
  }
}
80103a48:	90                   	nop
80103a49:	c9                   	leave  
80103a4a:	c3                   	ret    

80103a4b <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a4b:	f3 0f 1e fb          	endbr32 
80103a4f:	55                   	push   %ebp
80103a50:	89 e5                	mov    %esp,%ebp
80103a52:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a55:	a1 68 57 11 80       	mov    0x80115768,%eax
80103a5a:	83 f8 1d             	cmp    $0x1d,%eax
80103a5d:	7f 12                	jg     80103a71 <log_write+0x26>
80103a5f:	a1 68 57 11 80       	mov    0x80115768,%eax
80103a64:	8b 15 58 57 11 80    	mov    0x80115758,%edx
80103a6a:	83 ea 01             	sub    $0x1,%edx
80103a6d:	39 d0                	cmp    %edx,%eax
80103a6f:	7c 0d                	jl     80103a7e <log_write+0x33>
    panic("too big a transaction");
80103a71:	83 ec 0c             	sub    $0xc,%esp
80103a74:	68 5f 98 10 80       	push   $0x8010985f
80103a79:	e8 8a cb ff ff       	call   80100608 <panic>
  if (log.outstanding < 1)
80103a7e:	a1 5c 57 11 80       	mov    0x8011575c,%eax
80103a83:	85 c0                	test   %eax,%eax
80103a85:	7f 0d                	jg     80103a94 <log_write+0x49>
    panic("log_write outside of trans");
80103a87:	83 ec 0c             	sub    $0xc,%esp
80103a8a:	68 75 98 10 80       	push   $0x80109875
80103a8f:	e8 74 cb ff ff       	call   80100608 <panic>

  acquire(&log.lock);
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 20 57 11 80       	push   $0x80115720
80103a9c:	e8 c8 1a 00 00       	call   80105569 <acquire>
80103aa1:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103aab:	eb 1d                	jmp    80103aca <log_write+0x7f>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab0:	83 c0 10             	add    $0x10,%eax
80103ab3:	8b 04 85 2c 57 11 80 	mov    -0x7feea8d4(,%eax,4),%eax
80103aba:	89 c2                	mov    %eax,%edx
80103abc:	8b 45 08             	mov    0x8(%ebp),%eax
80103abf:	8b 40 08             	mov    0x8(%eax),%eax
80103ac2:	39 c2                	cmp    %eax,%edx
80103ac4:	74 10                	je     80103ad6 <log_write+0x8b>
  for (i = 0; i < log.lh.n; i++) {
80103ac6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103aca:	a1 68 57 11 80       	mov    0x80115768,%eax
80103acf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103ad2:	7c d9                	jl     80103aad <log_write+0x62>
80103ad4:	eb 01                	jmp    80103ad7 <log_write+0x8c>
      break;
80103ad6:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80103ada:	8b 40 08             	mov    0x8(%eax),%eax
80103add:	89 c2                	mov    %eax,%edx
80103adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae2:	83 c0 10             	add    $0x10,%eax
80103ae5:	89 14 85 2c 57 11 80 	mov    %edx,-0x7feea8d4(,%eax,4)
  if (i == log.lh.n)
80103aec:	a1 68 57 11 80       	mov    0x80115768,%eax
80103af1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103af4:	75 0d                	jne    80103b03 <log_write+0xb8>
    log.lh.n++;
80103af6:	a1 68 57 11 80       	mov    0x80115768,%eax
80103afb:	83 c0 01             	add    $0x1,%eax
80103afe:	a3 68 57 11 80       	mov    %eax,0x80115768
  b->flags |= B_DIRTY; // prevent eviction
80103b03:	8b 45 08             	mov    0x8(%ebp),%eax
80103b06:	8b 00                	mov    (%eax),%eax
80103b08:	83 c8 04             	or     $0x4,%eax
80103b0b:	89 c2                	mov    %eax,%edx
80103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103b10:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b12:	83 ec 0c             	sub    $0xc,%esp
80103b15:	68 20 57 11 80       	push   $0x80115720
80103b1a:	e8 bc 1a 00 00       	call   801055db <release>
80103b1f:	83 c4 10             	add    $0x10,%esp
}
80103b22:	90                   	nop
80103b23:	c9                   	leave  
80103b24:	c3                   	ret    

80103b25 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103b25:	55                   	push   %ebp
80103b26:	89 e5                	mov    %esp,%ebp
80103b28:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b2b:	8b 55 08             	mov    0x8(%ebp),%edx
80103b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b31:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b34:	f0 87 02             	lock xchg %eax,(%edx)
80103b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103b3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103b3d:	c9                   	leave  
80103b3e:	c3                   	ret    

80103b3f <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103b3f:	f3 0f 1e fb          	endbr32 
80103b43:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103b47:	83 e4 f0             	and    $0xfffffff0,%esp
80103b4a:	ff 71 fc             	pushl  -0x4(%ecx)
80103b4d:	55                   	push   %ebp
80103b4e:	89 e5                	mov    %esp,%ebp
80103b50:	51                   	push   %ecx
80103b51:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b54:	83 ec 08             	sub    $0x8,%esp
80103b57:	68 00 00 40 80       	push   $0x80400000
80103b5c:	68 48 a7 11 80       	push   $0x8011a748
80103b61:	e8 52 f2 ff ff       	call   80102db8 <kinit1>
80103b66:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103b69:	e8 8d 48 00 00       	call   801083fb <kvmalloc>
  mpinit();        // detect other processors
80103b6e:	e8 d9 03 00 00       	call   80103f4c <mpinit>
  lapicinit();     // interrupt controller
80103b73:	e8 f5 f5 ff ff       	call   8010316d <lapicinit>
  seginit();       // segment descriptors
80103b78:	e8 36 43 00 00       	call   80107eb3 <seginit>
  picinit();       // disable pic
80103b7d:	e8 35 05 00 00       	call   801040b7 <picinit>
  ioapicinit();    // another interrupt controller
80103b82:	e8 44 f1 ff ff       	call   80102ccb <ioapicinit>
  consoleinit();   // console hardware
80103b87:	e8 55 d0 ff ff       	call   80100be1 <consoleinit>
  uartinit();      // serial port
80103b8c:	e8 ab 36 00 00       	call   8010723c <uartinit>
  pinit();         // process table
80103b91:	e8 6e 09 00 00       	call   80104504 <pinit>
  tvinit();        // trap vectors
80103b96:	e8 29 32 00 00       	call   80106dc4 <tvinit>
  binit();         // buffer cache
80103b9b:	e8 94 c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103ba0:	e8 00 d6 ff ff       	call   801011a5 <fileinit>
  ideinit();       // disk 
80103ba5:	e8 e0 ec ff ff       	call   8010288a <ideinit>
  startothers();   // start other processors
80103baa:	e8 88 00 00 00       	call   80103c37 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103baf:	83 ec 08             	sub    $0x8,%esp
80103bb2:	68 00 00 00 8e       	push   $0x8e000000
80103bb7:	68 00 00 40 80       	push   $0x80400000
80103bbc:	e8 34 f2 ff ff       	call   80102df5 <kinit2>
80103bc1:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103bc4:	e8 34 0b 00 00       	call   801046fd <userinit>
  mpmain();        // finish this processor's setup
80103bc9:	e8 1e 00 00 00       	call   80103bec <mpmain>

80103bce <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103bce:	f3 0f 1e fb          	endbr32 
80103bd2:	55                   	push   %ebp
80103bd3:	89 e5                	mov    %esp,%ebp
80103bd5:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103bd8:	e8 3a 48 00 00       	call   80108417 <switchkvm>
  seginit();
80103bdd:	e8 d1 42 00 00       	call   80107eb3 <seginit>
  lapicinit();
80103be2:	e8 86 f5 ff ff       	call   8010316d <lapicinit>
  mpmain();
80103be7:	e8 00 00 00 00       	call   80103bec <mpmain>

80103bec <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103bec:	f3 0f 1e fb          	endbr32 
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	53                   	push   %ebx
80103bf4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103bf7:	e8 2a 09 00 00       	call   80104526 <cpuid>
80103bfc:	89 c3                	mov    %eax,%ebx
80103bfe:	e8 23 09 00 00       	call   80104526 <cpuid>
80103c03:	83 ec 04             	sub    $0x4,%esp
80103c06:	53                   	push   %ebx
80103c07:	50                   	push   %eax
80103c08:	68 90 98 10 80       	push   $0x80109890
80103c0d:	e8 06 c8 ff ff       	call   80100418 <cprintf>
80103c12:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103c15:	e8 24 33 00 00       	call   80106f3e <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103c1a:	e8 26 09 00 00       	call   80104545 <mycpu>
80103c1f:	05 a0 00 00 00       	add    $0xa0,%eax
80103c24:	83 ec 08             	sub    $0x8,%esp
80103c27:	6a 01                	push   $0x1
80103c29:	50                   	push   %eax
80103c2a:	e8 f6 fe ff ff       	call   80103b25 <xchg>
80103c2f:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103c32:	e8 bc 12 00 00       	call   80104ef3 <scheduler>

80103c37 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103c37:	f3 0f 1e fb          	endbr32 
80103c3b:	55                   	push   %ebp
80103c3c:	89 e5                	mov    %esp,%ebp
80103c3e:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103c41:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c48:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103c4d:	83 ec 04             	sub    $0x4,%esp
80103c50:	50                   	push   %eax
80103c51:	68 0c d5 10 80       	push   $0x8010d50c
80103c56:	ff 75 f0             	pushl  -0x10(%ebp)
80103c59:	e8 71 1c 00 00       	call   801058cf <memmove>
80103c5e:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103c61:	c7 45 f4 20 58 11 80 	movl   $0x80115820,-0xc(%ebp)
80103c68:	eb 79                	jmp    80103ce3 <startothers+0xac>
    if(c == mycpu())  // We've started already.
80103c6a:	e8 d6 08 00 00       	call   80104545 <mycpu>
80103c6f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103c72:	74 67                	je     80103cdb <startothers+0xa4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103c74:	e8 84 f2 ff ff       	call   80102efd <kalloc>
80103c79:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c7f:	83 e8 04             	sub    $0x4,%eax
80103c82:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103c85:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103c8b:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
80103c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c90:	83 e8 08             	sub    $0x8,%eax
80103c93:	c7 00 ce 3b 10 80    	movl   $0x80103bce,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103c99:	b8 00 c0 10 80       	mov    $0x8010c000,%eax
80103c9e:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ca7:	83 e8 0c             	sub    $0xc,%eax
80103caa:	89 10                	mov    %edx,(%eax)

    lapicstartap(c->apicid, V2P(code));
80103cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103caf:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb8:	0f b6 00             	movzbl (%eax),%eax
80103cbb:	0f b6 c0             	movzbl %al,%eax
80103cbe:	83 ec 08             	sub    $0x8,%esp
80103cc1:	52                   	push   %edx
80103cc2:	50                   	push   %eax
80103cc3:	e8 17 f6 ff ff       	call   801032df <lapicstartap>
80103cc8:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103ccb:	90                   	nop
80103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccf:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80103cd5:	85 c0                	test   %eax,%eax
80103cd7:	74 f3                	je     80103ccc <startothers+0x95>
80103cd9:	eb 01                	jmp    80103cdc <startothers+0xa5>
      continue;
80103cdb:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103cdc:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103ce3:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80103ce8:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80103cee:	05 20 58 11 80       	add    $0x80115820,%eax
80103cf3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103cf6:	0f 82 6e ff ff ff    	jb     80103c6a <startothers+0x33>
      ;
  }
}
80103cfc:	90                   	nop
80103cfd:	90                   	nop
80103cfe:	c9                   	leave  
80103cff:	c3                   	ret    

80103d00 <inb>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 14             	sub    $0x14,%esp
80103d06:	8b 45 08             	mov    0x8(%ebp),%eax
80103d09:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d0d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103d11:	89 c2                	mov    %eax,%edx
80103d13:	ec                   	in     (%dx),%al
80103d14:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103d17:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103d1b:	c9                   	leave  
80103d1c:	c3                   	ret    

80103d1d <outb>:
{
80103d1d:	55                   	push   %ebp
80103d1e:	89 e5                	mov    %esp,%ebp
80103d20:	83 ec 08             	sub    $0x8,%esp
80103d23:	8b 45 08             	mov    0x8(%ebp),%eax
80103d26:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d29:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103d2d:	89 d0                	mov    %edx,%eax
80103d2f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d32:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d36:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103d3a:	ee                   	out    %al,(%dx)
}
80103d3b:	90                   	nop
80103d3c:	c9                   	leave  
80103d3d:	c3                   	ret    

80103d3e <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103d3e:	f3 0f 1e fb          	endbr32 
80103d42:	55                   	push   %ebp
80103d43:	89 e5                	mov    %esp,%ebp
80103d45:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103d48:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103d56:	eb 15                	jmp    80103d6d <sum+0x2f>
    sum += addr[i];
80103d58:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d5e:	01 d0                	add    %edx,%eax
80103d60:	0f b6 00             	movzbl (%eax),%eax
80103d63:	0f b6 c0             	movzbl %al,%eax
80103d66:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103d69:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103d70:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103d73:	7c e3                	jl     80103d58 <sum+0x1a>
  return sum;
80103d75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103d78:	c9                   	leave  
80103d79:	c3                   	ret    

80103d7a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103d7a:	f3 0f 1e fb          	endbr32 
80103d7e:	55                   	push   %ebp
80103d7f:	89 e5                	mov    %esp,%ebp
80103d81:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103d84:	8b 45 08             	mov    0x8(%ebp),%eax
80103d87:	05 00 00 00 80       	add    $0x80000000,%eax
80103d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d95:	01 d0                	add    %edx,%eax
80103d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103da0:	eb 36                	jmp    80103dd8 <mpsearch1+0x5e>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103da2:	83 ec 04             	sub    $0x4,%esp
80103da5:	6a 04                	push   $0x4
80103da7:	68 a4 98 10 80       	push   $0x801098a4
80103dac:	ff 75 f4             	pushl  -0xc(%ebp)
80103daf:	e8 bf 1a 00 00       	call   80105873 <memcmp>
80103db4:	83 c4 10             	add    $0x10,%esp
80103db7:	85 c0                	test   %eax,%eax
80103db9:	75 19                	jne    80103dd4 <mpsearch1+0x5a>
80103dbb:	83 ec 08             	sub    $0x8,%esp
80103dbe:	6a 10                	push   $0x10
80103dc0:	ff 75 f4             	pushl  -0xc(%ebp)
80103dc3:	e8 76 ff ff ff       	call   80103d3e <sum>
80103dc8:	83 c4 10             	add    $0x10,%esp
80103dcb:	84 c0                	test   %al,%al
80103dcd:	75 05                	jne    80103dd4 <mpsearch1+0x5a>
      return (struct mp*)p;
80103dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dd2:	eb 11                	jmp    80103de5 <mpsearch1+0x6b>
  for(p = addr; p < e; p += sizeof(struct mp))
80103dd4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ddb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103dde:	72 c2                	jb     80103da2 <mpsearch1+0x28>
  return 0;
80103de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103de5:	c9                   	leave  
80103de6:	c3                   	ret    

80103de7 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103de7:	f3 0f 1e fb          	endbr32 
80103deb:	55                   	push   %ebp
80103dec:	89 e5                	mov    %esp,%ebp
80103dee:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103df1:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dfb:	83 c0 0f             	add    $0xf,%eax
80103dfe:	0f b6 00             	movzbl (%eax),%eax
80103e01:	0f b6 c0             	movzbl %al,%eax
80103e04:	c1 e0 08             	shl    $0x8,%eax
80103e07:	89 c2                	mov    %eax,%edx
80103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0c:	83 c0 0e             	add    $0xe,%eax
80103e0f:	0f b6 00             	movzbl (%eax),%eax
80103e12:	0f b6 c0             	movzbl %al,%eax
80103e15:	09 d0                	or     %edx,%eax
80103e17:	c1 e0 04             	shl    $0x4,%eax
80103e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e21:	74 21                	je     80103e44 <mpsearch+0x5d>
    if((mp = mpsearch1(p, 1024)))
80103e23:	83 ec 08             	sub    $0x8,%esp
80103e26:	68 00 04 00 00       	push   $0x400
80103e2b:	ff 75 f0             	pushl  -0x10(%ebp)
80103e2e:	e8 47 ff ff ff       	call   80103d7a <mpsearch1>
80103e33:	83 c4 10             	add    $0x10,%esp
80103e36:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e3d:	74 51                	je     80103e90 <mpsearch+0xa9>
      return mp;
80103e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e42:	eb 61                	jmp    80103ea5 <mpsearch+0xbe>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e47:	83 c0 14             	add    $0x14,%eax
80103e4a:	0f b6 00             	movzbl (%eax),%eax
80103e4d:	0f b6 c0             	movzbl %al,%eax
80103e50:	c1 e0 08             	shl    $0x8,%eax
80103e53:	89 c2                	mov    %eax,%edx
80103e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e58:	83 c0 13             	add    $0x13,%eax
80103e5b:	0f b6 00             	movzbl (%eax),%eax
80103e5e:	0f b6 c0             	movzbl %al,%eax
80103e61:	09 d0                	or     %edx,%eax
80103e63:	c1 e0 0a             	shl    $0xa,%eax
80103e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e6c:	2d 00 04 00 00       	sub    $0x400,%eax
80103e71:	83 ec 08             	sub    $0x8,%esp
80103e74:	68 00 04 00 00       	push   $0x400
80103e79:	50                   	push   %eax
80103e7a:	e8 fb fe ff ff       	call   80103d7a <mpsearch1>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103e89:	74 05                	je     80103e90 <mpsearch+0xa9>
      return mp;
80103e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103e8e:	eb 15                	jmp    80103ea5 <mpsearch+0xbe>
  }
  return mpsearch1(0xF0000, 0x10000);
80103e90:	83 ec 08             	sub    $0x8,%esp
80103e93:	68 00 00 01 00       	push   $0x10000
80103e98:	68 00 00 0f 00       	push   $0xf0000
80103e9d:	e8 d8 fe ff ff       	call   80103d7a <mpsearch1>
80103ea2:	83 c4 10             	add    $0x10,%esp
}
80103ea5:	c9                   	leave  
80103ea6:	c3                   	ret    

80103ea7 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103ea7:	f3 0f 1e fb          	endbr32 
80103eab:	55                   	push   %ebp
80103eac:	89 e5                	mov    %esp,%ebp
80103eae:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103eb1:	e8 31 ff ff ff       	call   80103de7 <mpsearch>
80103eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ebd:	74 0a                	je     80103ec9 <mpconfig+0x22>
80103ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec2:	8b 40 04             	mov    0x4(%eax),%eax
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	75 07                	jne    80103ed0 <mpconfig+0x29>
    return 0;
80103ec9:	b8 00 00 00 00       	mov    $0x0,%eax
80103ece:	eb 7a                	jmp    80103f4a <mpconfig+0xa3>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed3:	8b 40 04             	mov    0x4(%eax),%eax
80103ed6:	05 00 00 00 80       	add    $0x80000000,%eax
80103edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ede:	83 ec 04             	sub    $0x4,%esp
80103ee1:	6a 04                	push   $0x4
80103ee3:	68 a9 98 10 80       	push   $0x801098a9
80103ee8:	ff 75 f0             	pushl  -0x10(%ebp)
80103eeb:	e8 83 19 00 00       	call   80105873 <memcmp>
80103ef0:	83 c4 10             	add    $0x10,%esp
80103ef3:	85 c0                	test   %eax,%eax
80103ef5:	74 07                	je     80103efe <mpconfig+0x57>
    return 0;
80103ef7:	b8 00 00 00 00       	mov    $0x0,%eax
80103efc:	eb 4c                	jmp    80103f4a <mpconfig+0xa3>
  if(conf->version != 1 && conf->version != 4)
80103efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f01:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f05:	3c 01                	cmp    $0x1,%al
80103f07:	74 12                	je     80103f1b <mpconfig+0x74>
80103f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f0c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f10:	3c 04                	cmp    $0x4,%al
80103f12:	74 07                	je     80103f1b <mpconfig+0x74>
    return 0;
80103f14:	b8 00 00 00 00       	mov    $0x0,%eax
80103f19:	eb 2f                	jmp    80103f4a <mpconfig+0xa3>
  if(sum((uchar*)conf, conf->length) != 0)
80103f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f1e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103f22:	0f b7 c0             	movzwl %ax,%eax
80103f25:	83 ec 08             	sub    $0x8,%esp
80103f28:	50                   	push   %eax
80103f29:	ff 75 f0             	pushl  -0x10(%ebp)
80103f2c:	e8 0d fe ff ff       	call   80103d3e <sum>
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	84 c0                	test   %al,%al
80103f36:	74 07                	je     80103f3f <mpconfig+0x98>
    return 0;
80103f38:	b8 00 00 00 00       	mov    $0x0,%eax
80103f3d:	eb 0b                	jmp    80103f4a <mpconfig+0xa3>
  *pmp = mp;
80103f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f45:	89 10                	mov    %edx,(%eax)
  return conf;
80103f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103f4a:	c9                   	leave  
80103f4b:	c3                   	ret    

80103f4c <mpinit>:

void
mpinit(void)
{
80103f4c:	f3 0f 1e fb          	endbr32 
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103f5c:	50                   	push   %eax
80103f5d:	e8 45 ff ff ff       	call   80103ea7 <mpconfig>
80103f62:	83 c4 10             	add    $0x10,%esp
80103f65:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f6c:	75 0d                	jne    80103f7b <mpinit+0x2f>
    panic("Expect to run on an SMP");
80103f6e:	83 ec 0c             	sub    $0xc,%esp
80103f71:	68 ae 98 10 80       	push   $0x801098ae
80103f76:	e8 8d c6 ff ff       	call   80100608 <panic>
  ismp = 1;
80103f7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f85:	8b 40 24             	mov    0x24(%eax),%eax
80103f88:	a3 1c 57 11 80       	mov    %eax,0x8011571c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f90:	83 c0 2c             	add    $0x2c,%eax
80103f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f99:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103f9d:	0f b7 d0             	movzwl %ax,%edx
80103fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103fa3:	01 d0                	add    %edx,%eax
80103fa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103fa8:	e9 8c 00 00 00       	jmp    80104039 <mpinit+0xed>
    switch(*p){
80103fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb0:	0f b6 00             	movzbl (%eax),%eax
80103fb3:	0f b6 c0             	movzbl %al,%eax
80103fb6:	83 f8 04             	cmp    $0x4,%eax
80103fb9:	7f 76                	jg     80104031 <mpinit+0xe5>
80103fbb:	83 f8 03             	cmp    $0x3,%eax
80103fbe:	7d 6b                	jge    8010402b <mpinit+0xdf>
80103fc0:	83 f8 02             	cmp    $0x2,%eax
80103fc3:	74 4e                	je     80104013 <mpinit+0xc7>
80103fc5:	83 f8 02             	cmp    $0x2,%eax
80103fc8:	7f 67                	jg     80104031 <mpinit+0xe5>
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 07                	je     80103fd5 <mpinit+0x89>
80103fce:	83 f8 01             	cmp    $0x1,%eax
80103fd1:	74 58                	je     8010402b <mpinit+0xdf>
80103fd3:	eb 5c                	jmp    80104031 <mpinit+0xe5>
    case MPPROC:
      proc = (struct mpproc*)p;
80103fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
80103fdb:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80103fe0:	83 f8 07             	cmp    $0x7,%eax
80103fe3:	7f 28                	jg     8010400d <mpinit+0xc1>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103fe5:	8b 15 a0 5d 11 80    	mov    0x80115da0,%edx
80103feb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103fee:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ff2:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103ff8:	81 c2 20 58 11 80    	add    $0x80115820,%edx
80103ffe:	88 02                	mov    %al,(%edx)
        ncpu++;
80104000:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
80104005:	83 c0 01             	add    $0x1,%eax
80104008:	a3 a0 5d 11 80       	mov    %eax,0x80115da0
      }
      p += sizeof(struct mpproc);
8010400d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80104011:	eb 26                	jmp    80104039 <mpinit+0xed>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80104013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010401c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104020:	a2 00 58 11 80       	mov    %al,0x80115800
      p += sizeof(struct mpioapic);
80104025:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104029:	eb 0e                	jmp    80104039 <mpinit+0xed>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010402b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010402f:	eb 08                	jmp    80104039 <mpinit+0xed>
    default:
      ismp = 0;
80104031:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80104038:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
8010403f:	0f 82 68 ff ff ff    	jb     80103fad <mpinit+0x61>
    }
  }
  if(!ismp)
80104045:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104049:	75 0d                	jne    80104058 <mpinit+0x10c>
    panic("Didn't find a suitable machine");
8010404b:	83 ec 0c             	sub    $0xc,%esp
8010404e:	68 c8 98 10 80       	push   $0x801098c8
80104053:	e8 b0 c5 ff ff       	call   80100608 <panic>

  if(mp->imcrp){
80104058:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010405b:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
8010405f:	84 c0                	test   %al,%al
80104061:	74 30                	je     80104093 <mpinit+0x147>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80104063:	83 ec 08             	sub    $0x8,%esp
80104066:	6a 70                	push   $0x70
80104068:	6a 22                	push   $0x22
8010406a:	e8 ae fc ff ff       	call   80103d1d <outb>
8010406f:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80104072:	83 ec 0c             	sub    $0xc,%esp
80104075:	6a 23                	push   $0x23
80104077:	e8 84 fc ff ff       	call   80103d00 <inb>
8010407c:	83 c4 10             	add    $0x10,%esp
8010407f:	83 c8 01             	or     $0x1,%eax
80104082:	0f b6 c0             	movzbl %al,%eax
80104085:	83 ec 08             	sub    $0x8,%esp
80104088:	50                   	push   %eax
80104089:	6a 23                	push   $0x23
8010408b:	e8 8d fc ff ff       	call   80103d1d <outb>
80104090:	83 c4 10             	add    $0x10,%esp
  }
}
80104093:	90                   	nop
80104094:	c9                   	leave  
80104095:	c3                   	ret    

80104096 <outb>:
{
80104096:	55                   	push   %ebp
80104097:	89 e5                	mov    %esp,%ebp
80104099:	83 ec 08             	sub    $0x8,%esp
8010409c:	8b 45 08             	mov    0x8(%ebp),%eax
8010409f:	8b 55 0c             	mov    0xc(%ebp),%edx
801040a2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801040a6:	89 d0                	mov    %edx,%eax
801040a8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801040ab:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801040af:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801040b3:	ee                   	out    %al,(%dx)
}
801040b4:	90                   	nop
801040b5:	c9                   	leave  
801040b6:	c3                   	ret    

801040b7 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801040b7:	f3 0f 1e fb          	endbr32 
801040bb:	55                   	push   %ebp
801040bc:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801040be:	68 ff 00 00 00       	push   $0xff
801040c3:	6a 21                	push   $0x21
801040c5:	e8 cc ff ff ff       	call   80104096 <outb>
801040ca:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801040cd:	68 ff 00 00 00       	push   $0xff
801040d2:	68 a1 00 00 00       	push   $0xa1
801040d7:	e8 ba ff ff ff       	call   80104096 <outb>
801040dc:	83 c4 08             	add    $0x8,%esp
}
801040df:	90                   	nop
801040e0:	c9                   	leave  
801040e1:	c3                   	ret    

801040e2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040e2:	f3 0f 1e fb          	endbr32 
801040e6:	55                   	push   %ebp
801040e7:	89 e5                	mov    %esp,%ebp
801040e9:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ff:	8b 10                	mov    (%eax),%edx
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104106:	e8 bc d0 ff ff       	call   801011c7 <filealloc>
8010410b:	8b 55 08             	mov    0x8(%ebp),%edx
8010410e:	89 02                	mov    %eax,(%edx)
80104110:	8b 45 08             	mov    0x8(%ebp),%eax
80104113:	8b 00                	mov    (%eax),%eax
80104115:	85 c0                	test   %eax,%eax
80104117:	0f 84 c8 00 00 00    	je     801041e5 <pipealloc+0x103>
8010411d:	e8 a5 d0 ff ff       	call   801011c7 <filealloc>
80104122:	8b 55 0c             	mov    0xc(%ebp),%edx
80104125:	89 02                	mov    %eax,(%edx)
80104127:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412a:	8b 00                	mov    (%eax),%eax
8010412c:	85 c0                	test   %eax,%eax
8010412e:	0f 84 b1 00 00 00    	je     801041e5 <pipealloc+0x103>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104134:	e8 c4 ed ff ff       	call   80102efd <kalloc>
80104139:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010413c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104140:	0f 84 a2 00 00 00    	je     801041e8 <pipealloc+0x106>
    goto bad;
  p->readopen = 1;
80104146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104149:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104150:	00 00 00 
  p->writeopen = 1;
80104153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104156:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010415d:	00 00 00 
  p->nwrite = 0;
80104160:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104163:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010416a:	00 00 00 
  p->nread = 0;
8010416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104170:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104177:	00 00 00 
  initlock(&p->lock, "pipe");
8010417a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417d:	83 ec 08             	sub    $0x8,%esp
80104180:	68 e7 98 10 80       	push   $0x801098e7
80104185:	50                   	push   %eax
80104186:	e8 b8 13 00 00       	call   80105543 <initlock>
8010418b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010418e:	8b 45 08             	mov    0x8(%ebp),%eax
80104191:	8b 00                	mov    (%eax),%eax
80104193:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104199:	8b 45 08             	mov    0x8(%ebp),%eax
8010419c:	8b 00                	mov    (%eax),%eax
8010419e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	8b 00                	mov    (%eax),%eax
801041a7:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	8b 00                	mov    (%eax),%eax
801041b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b3:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b9:	8b 00                	mov    (%eax),%eax
801041bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c4:	8b 00                	mov    (%eax),%eax
801041c6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801041cd:	8b 00                	mov    (%eax),%eax
801041cf:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d6:	8b 00                	mov    (%eax),%eax
801041d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041db:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041de:	b8 00 00 00 00       	mov    $0x0,%eax
801041e3:	eb 51                	jmp    80104236 <pipealloc+0x154>
    goto bad;
801041e5:	90                   	nop
801041e6:	eb 01                	jmp    801041e9 <pipealloc+0x107>
    goto bad;
801041e8:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
801041e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041ed:	74 0e                	je     801041fd <pipealloc+0x11b>
    kfree((char*)p);
801041ef:	83 ec 0c             	sub    $0xc,%esp
801041f2:	ff 75 f4             	pushl  -0xc(%ebp)
801041f5:	e8 65 ec ff ff       	call   80102e5f <kfree>
801041fa:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	8b 00                	mov    (%eax),%eax
80104202:	85 c0                	test   %eax,%eax
80104204:	74 11                	je     80104217 <pipealloc+0x135>
    fileclose(*f0);
80104206:	8b 45 08             	mov    0x8(%ebp),%eax
80104209:	8b 00                	mov    (%eax),%eax
8010420b:	83 ec 0c             	sub    $0xc,%esp
8010420e:	50                   	push   %eax
8010420f:	e8 79 d0 ff ff       	call   8010128d <fileclose>
80104214:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421a:	8b 00                	mov    (%eax),%eax
8010421c:	85 c0                	test   %eax,%eax
8010421e:	74 11                	je     80104231 <pipealloc+0x14f>
    fileclose(*f1);
80104220:	8b 45 0c             	mov    0xc(%ebp),%eax
80104223:	8b 00                	mov    (%eax),%eax
80104225:	83 ec 0c             	sub    $0xc,%esp
80104228:	50                   	push   %eax
80104229:	e8 5f d0 ff ff       	call   8010128d <fileclose>
8010422e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104236:	c9                   	leave  
80104237:	c3                   	ret    

80104238 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104238:	f3 0f 1e fb          	endbr32 
8010423c:	55                   	push   %ebp
8010423d:	89 e5                	mov    %esp,%ebp
8010423f:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104242:	8b 45 08             	mov    0x8(%ebp),%eax
80104245:	83 ec 0c             	sub    $0xc,%esp
80104248:	50                   	push   %eax
80104249:	e8 1b 13 00 00       	call   80105569 <acquire>
8010424e:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104251:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104255:	74 23                	je     8010427a <pipeclose+0x42>
    p->writeopen = 0;
80104257:	8b 45 08             	mov    0x8(%ebp),%eax
8010425a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104261:	00 00 00 
    wakeup(&p->nread);
80104264:	8b 45 08             	mov    0x8(%ebp),%eax
80104267:	05 34 02 00 00       	add    $0x234,%eax
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	50                   	push   %eax
80104270:	e8 74 0f 00 00       	call   801051e9 <wakeup>
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	eb 21                	jmp    8010429b <pipeclose+0x63>
  } else {
    p->readopen = 0;
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104284:	00 00 00 
    wakeup(&p->nwrite);
80104287:	8b 45 08             	mov    0x8(%ebp),%eax
8010428a:	05 38 02 00 00       	add    $0x238,%eax
8010428f:	83 ec 0c             	sub    $0xc,%esp
80104292:	50                   	push   %eax
80104293:	e8 51 0f 00 00       	call   801051e9 <wakeup>
80104298:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010429b:	8b 45 08             	mov    0x8(%ebp),%eax
8010429e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042a4:	85 c0                	test   %eax,%eax
801042a6:	75 2c                	jne    801042d4 <pipeclose+0x9c>
801042a8:	8b 45 08             	mov    0x8(%ebp),%eax
801042ab:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042b1:	85 c0                	test   %eax,%eax
801042b3:	75 1f                	jne    801042d4 <pipeclose+0x9c>
    release(&p->lock);
801042b5:	8b 45 08             	mov    0x8(%ebp),%eax
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	50                   	push   %eax
801042bc:	e8 1a 13 00 00       	call   801055db <release>
801042c1:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	ff 75 08             	pushl  0x8(%ebp)
801042ca:	e8 90 eb ff ff       	call   80102e5f <kfree>
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	eb 10                	jmp    801042e4 <pipeclose+0xac>
  } else
    release(&p->lock);
801042d4:	8b 45 08             	mov    0x8(%ebp),%eax
801042d7:	83 ec 0c             	sub    $0xc,%esp
801042da:	50                   	push   %eax
801042db:	e8 fb 12 00 00       	call   801055db <release>
801042e0:	83 c4 10             	add    $0x10,%esp
}
801042e3:	90                   	nop
801042e4:	90                   	nop
801042e5:	c9                   	leave  
801042e6:	c3                   	ret    

801042e7 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801042e7:	f3 0f 1e fb          	endbr32 
801042eb:	55                   	push   %ebp
801042ec:	89 e5                	mov    %esp,%ebp
801042ee:	53                   	push   %ebx
801042ef:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042f2:	8b 45 08             	mov    0x8(%ebp),%eax
801042f5:	83 ec 0c             	sub    $0xc,%esp
801042f8:	50                   	push   %eax
801042f9:	e8 6b 12 00 00       	call   80105569 <acquire>
801042fe:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104308:	e9 ad 00 00 00       	jmp    801043ba <pipewrite+0xd3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
8010430d:	8b 45 08             	mov    0x8(%ebp),%eax
80104310:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104316:	85 c0                	test   %eax,%eax
80104318:	74 0c                	je     80104326 <pipewrite+0x3f>
8010431a:	e8 a2 02 00 00       	call   801045c1 <myproc>
8010431f:	8b 40 24             	mov    0x24(%eax),%eax
80104322:	85 c0                	test   %eax,%eax
80104324:	74 19                	je     8010433f <pipewrite+0x58>
        release(&p->lock);
80104326:	8b 45 08             	mov    0x8(%ebp),%eax
80104329:	83 ec 0c             	sub    $0xc,%esp
8010432c:	50                   	push   %eax
8010432d:	e8 a9 12 00 00       	call   801055db <release>
80104332:	83 c4 10             	add    $0x10,%esp
        return -1;
80104335:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010433a:	e9 a9 00 00 00       	jmp    801043e8 <pipewrite+0x101>
      }
      wakeup(&p->nread);
8010433f:	8b 45 08             	mov    0x8(%ebp),%eax
80104342:	05 34 02 00 00       	add    $0x234,%eax
80104347:	83 ec 0c             	sub    $0xc,%esp
8010434a:	50                   	push   %eax
8010434b:	e8 99 0e 00 00       	call   801051e9 <wakeup>
80104350:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104353:	8b 45 08             	mov    0x8(%ebp),%eax
80104356:	8b 55 08             	mov    0x8(%ebp),%edx
80104359:	81 c2 38 02 00 00    	add    $0x238,%edx
8010435f:	83 ec 08             	sub    $0x8,%esp
80104362:	50                   	push   %eax
80104363:	52                   	push   %edx
80104364:	e8 8e 0d 00 00       	call   801050f7 <sleep>
80104369:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010436c:	8b 45 08             	mov    0x8(%ebp),%eax
8010436f:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104375:	8b 45 08             	mov    0x8(%ebp),%eax
80104378:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010437e:	05 00 02 00 00       	add    $0x200,%eax
80104383:	39 c2                	cmp    %eax,%edx
80104385:	74 86                	je     8010430d <pipewrite+0x26>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104387:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010438a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104390:	8b 45 08             	mov    0x8(%ebp),%eax
80104393:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104399:	8d 48 01             	lea    0x1(%eax),%ecx
8010439c:	8b 55 08             	mov    0x8(%ebp),%edx
8010439f:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801043a5:	25 ff 01 00 00       	and    $0x1ff,%eax
801043aa:	89 c1                	mov    %eax,%ecx
801043ac:	0f b6 13             	movzbl (%ebx),%edx
801043af:	8b 45 08             	mov    0x8(%ebp),%eax
801043b2:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801043b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bd:	3b 45 10             	cmp    0x10(%ebp),%eax
801043c0:	7c aa                	jl     8010436c <pipewrite+0x85>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043c2:	8b 45 08             	mov    0x8(%ebp),%eax
801043c5:	05 34 02 00 00       	add    $0x234,%eax
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	50                   	push   %eax
801043ce:	e8 16 0e 00 00       	call   801051e9 <wakeup>
801043d3:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d6:	8b 45 08             	mov    0x8(%ebp),%eax
801043d9:	83 ec 0c             	sub    $0xc,%esp
801043dc:	50                   	push   %eax
801043dd:	e8 f9 11 00 00       	call   801055db <release>
801043e2:	83 c4 10             	add    $0x10,%esp
  return n;
801043e5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043eb:	c9                   	leave  
801043ec:	c3                   	ret    

801043ed <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043ed:	f3 0f 1e fb          	endbr32 
801043f1:	55                   	push   %ebp
801043f2:	89 e5                	mov    %esp,%ebp
801043f4:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	50                   	push   %eax
801043fe:	e8 66 11 00 00       	call   80105569 <acquire>
80104403:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104406:	eb 3e                	jmp    80104446 <piperead+0x59>
    if(myproc()->killed){
80104408:	e8 b4 01 00 00       	call   801045c1 <myproc>
8010440d:	8b 40 24             	mov    0x24(%eax),%eax
80104410:	85 c0                	test   %eax,%eax
80104412:	74 19                	je     8010442d <piperead+0x40>
      release(&p->lock);
80104414:	8b 45 08             	mov    0x8(%ebp),%eax
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	50                   	push   %eax
8010441b:	e8 bb 11 00 00       	call   801055db <release>
80104420:	83 c4 10             	add    $0x10,%esp
      return -1;
80104423:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104428:	e9 be 00 00 00       	jmp    801044eb <piperead+0xfe>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010442d:	8b 45 08             	mov    0x8(%ebp),%eax
80104430:	8b 55 08             	mov    0x8(%ebp),%edx
80104433:	81 c2 34 02 00 00    	add    $0x234,%edx
80104439:	83 ec 08             	sub    $0x8,%esp
8010443c:	50                   	push   %eax
8010443d:	52                   	push   %edx
8010443e:	e8 b4 0c 00 00       	call   801050f7 <sleep>
80104443:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104446:	8b 45 08             	mov    0x8(%ebp),%eax
80104449:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010444f:	8b 45 08             	mov    0x8(%ebp),%eax
80104452:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104458:	39 c2                	cmp    %eax,%edx
8010445a:	75 0d                	jne    80104469 <piperead+0x7c>
8010445c:	8b 45 08             	mov    0x8(%ebp),%eax
8010445f:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104465:	85 c0                	test   %eax,%eax
80104467:	75 9f                	jne    80104408 <piperead+0x1b>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104470:	eb 48                	jmp    801044ba <piperead+0xcd>
    if(p->nread == p->nwrite)
80104472:	8b 45 08             	mov    0x8(%ebp),%eax
80104475:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010447b:	8b 45 08             	mov    0x8(%ebp),%eax
8010447e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104484:	39 c2                	cmp    %eax,%edx
80104486:	74 3c                	je     801044c4 <piperead+0xd7>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104488:	8b 45 08             	mov    0x8(%ebp),%eax
8010448b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104491:	8d 48 01             	lea    0x1(%eax),%ecx
80104494:	8b 55 08             	mov    0x8(%ebp),%edx
80104497:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010449d:	25 ff 01 00 00       	and    $0x1ff,%eax
801044a2:	89 c1                	mov    %eax,%ecx
801044a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044aa:	01 c2                	add    %eax,%edx
801044ac:	8b 45 08             	mov    0x8(%ebp),%eax
801044af:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801044b4:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bd:	3b 45 10             	cmp    0x10(%ebp),%eax
801044c0:	7c b0                	jl     80104472 <piperead+0x85>
801044c2:	eb 01                	jmp    801044c5 <piperead+0xd8>
      break;
801044c4:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044c5:	8b 45 08             	mov    0x8(%ebp),%eax
801044c8:	05 38 02 00 00       	add    $0x238,%eax
801044cd:	83 ec 0c             	sub    $0xc,%esp
801044d0:	50                   	push   %eax
801044d1:	e8 13 0d 00 00       	call   801051e9 <wakeup>
801044d6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d9:	8b 45 08             	mov    0x8(%ebp),%eax
801044dc:	83 ec 0c             	sub    $0xc,%esp
801044df:	50                   	push   %eax
801044e0:	e8 f6 10 00 00       	call   801055db <release>
801044e5:	83 c4 10             	add    $0x10,%esp
  return i;
801044e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044eb:	c9                   	leave  
801044ec:	c3                   	ret    

801044ed <readeflags>:
{
801044ed:	55                   	push   %ebp
801044ee:	89 e5                	mov    %esp,%ebp
801044f0:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f3:	9c                   	pushf  
801044f4:	58                   	pop    %eax
801044f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044fb:	c9                   	leave  
801044fc:	c3                   	ret    

801044fd <sti>:
{
801044fd:	55                   	push   %ebp
801044fe:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104500:	fb                   	sti    
}
80104501:	90                   	nop
80104502:	5d                   	pop    %ebp
80104503:	c3                   	ret    

80104504 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104504:	f3 0f 1e fb          	endbr32 
80104508:	55                   	push   %ebp
80104509:	89 e5                	mov    %esp,%ebp
8010450b:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
8010450e:	83 ec 08             	sub    $0x8,%esp
80104511:	68 ec 98 10 80       	push   $0x801098ec
80104516:	68 c0 5d 11 80       	push   $0x80115dc0
8010451b:	e8 23 10 00 00       	call   80105543 <initlock>
80104520:	83 c4 10             	add    $0x10,%esp
}
80104523:	90                   	nop
80104524:	c9                   	leave  
80104525:	c3                   	ret    

80104526 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
80104526:	f3 0f 1e fb          	endbr32 
8010452a:	55                   	push   %ebp
8010452b:	89 e5                	mov    %esp,%ebp
8010452d:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104530:	e8 10 00 00 00       	call   80104545 <mycpu>
80104535:	2d 20 58 11 80       	sub    $0x80115820,%eax
8010453a:	c1 f8 04             	sar    $0x4,%eax
8010453d:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104543:	c9                   	leave  
80104544:	c3                   	ret    

80104545 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80104545:	f3 0f 1e fb          	endbr32 
80104549:	55                   	push   %ebp
8010454a:	89 e5                	mov    %esp,%ebp
8010454c:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010454f:	e8 99 ff ff ff       	call   801044ed <readeflags>
80104554:	25 00 02 00 00       	and    $0x200,%eax
80104559:	85 c0                	test   %eax,%eax
8010455b:	74 0d                	je     8010456a <mycpu+0x25>
    panic("mycpu called with interrupts enabled\n");
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	68 f4 98 10 80       	push   $0x801098f4
80104565:	e8 9e c0 ff ff       	call   80100608 <panic>
  
  apicid = lapicid();
8010456a:	e8 21 ed ff ff       	call   80103290 <lapicid>
8010456f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104579:	eb 2d                	jmp    801045a8 <mycpu+0x63>
    if (cpus[i].apicid == apicid)
8010457b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457e:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104584:	05 20 58 11 80       	add    $0x80115820,%eax
80104589:	0f b6 00             	movzbl (%eax),%eax
8010458c:	0f b6 c0             	movzbl %al,%eax
8010458f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104592:	75 10                	jne    801045a4 <mycpu+0x5f>
      return &cpus[i];
80104594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104597:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010459d:	05 20 58 11 80       	add    $0x80115820,%eax
801045a2:	eb 1b                	jmp    801045bf <mycpu+0x7a>
  for (i = 0; i < ncpu; ++i) {
801045a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045a8:	a1 a0 5d 11 80       	mov    0x80115da0,%eax
801045ad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801045b0:	7c c9                	jl     8010457b <mycpu+0x36>
  }
  panic("unknown apicid\n");
801045b2:	83 ec 0c             	sub    $0xc,%esp
801045b5:	68 1a 99 10 80       	push   $0x8010991a
801045ba:	e8 49 c0 ff ff       	call   80100608 <panic>
}
801045bf:	c9                   	leave  
801045c0:	c3                   	ret    

801045c1 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801045c1:	f3 0f 1e fb          	endbr32 
801045c5:	55                   	push   %ebp
801045c6:	89 e5                	mov    %esp,%ebp
801045c8:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801045cb:	e8 25 11 00 00       	call   801056f5 <pushcli>
  c = mycpu();
801045d0:	e8 70 ff ff ff       	call   80104545 <mycpu>
801045d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045db:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801045e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
801045e4:	e8 5d 11 00 00       	call   80105746 <popcli>
  return p;
801045e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801045ec:	c9                   	leave  
801045ed:	c3                   	ret    

801045ee <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801045ee:	f3 0f 1e fb          	endbr32 
801045f2:	55                   	push   %ebp
801045f3:	89 e5                	mov    %esp,%ebp
801045f5:	83 ec 18             	sub    $0x18,%esp
  char *sp;

  //clock queue testing
  //cprintf("clock queue:%p\n", clock_queue[0]);

  acquire(&ptable.lock);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 c0 5d 11 80       	push   $0x80115dc0
80104600:	e8 64 0f 00 00       	call   80105569 <acquire>
80104605:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104608:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
8010460f:	eb 11                	jmp    80104622 <allocproc+0x34>
    if(p->state == UNUSED)
80104611:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104614:	8b 40 0c             	mov    0xc(%eax),%eax
80104617:	85 c0                	test   %eax,%eax
80104619:	74 2a                	je     80104645 <allocproc+0x57>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010461b:	81 45 f4 04 01 00 00 	addl   $0x104,-0xc(%ebp)
80104622:	81 7d f4 f4 9e 11 80 	cmpl   $0x80119ef4,-0xc(%ebp)
80104629:	72 e6                	jb     80104611 <allocproc+0x23>
      goto found;

  release(&ptable.lock);
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	68 c0 5d 11 80       	push   $0x80115dc0
80104633:	e8 a3 0f 00 00       	call   801055db <release>
80104638:	83 c4 10             	add    $0x10,%esp
  return 0;
8010463b:	b8 00 00 00 00       	mov    $0x0,%eax
80104640:	e9 b6 00 00 00       	jmp    801046fb <allocproc+0x10d>
      goto found;
80104645:	90                   	nop
80104646:	f3 0f 1e fb          	endbr32 

found:
  p->state = EMBRYO;
8010464a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464d:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104654:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80104659:	8d 50 01             	lea    0x1(%eax),%edx
8010465c:	89 15 00 d0 10 80    	mov    %edx,0x8010d000
80104662:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104665:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	68 c0 5d 11 80       	push   $0x80115dc0
80104670:	e8 66 0f 00 00       	call   801055db <release>
80104675:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104678:	e8 80 e8 ff ff       	call   80102efd <kalloc>
8010467d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104680:	89 42 08             	mov    %eax,0x8(%edx)
80104683:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104686:	8b 40 08             	mov    0x8(%eax),%eax
80104689:	85 c0                	test   %eax,%eax
8010468b:	75 11                	jne    8010469e <allocproc+0xb0>
    p->state = UNUSED;
8010468d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104690:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104697:	b8 00 00 00 00       	mov    $0x0,%eax
8010469c:	eb 5d                	jmp    801046fb <allocproc+0x10d>
  }
  sp = p->kstack + KSTACKSIZE;
8010469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a1:	8b 40 08             	mov    0x8(%eax),%eax
801046a4:	05 00 10 00 00       	add    $0x1000,%eax
801046a9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801046ac:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046b6:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801046b9:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801046bd:	ba 7e 6d 10 80       	mov    $0x80106d7e,%edx
801046c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046c5:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801046c7:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046d1:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d7:	8b 40 1c             	mov    0x1c(%eax),%eax
801046da:	83 ec 04             	sub    $0x4,%esp
801046dd:	6a 14                	push   $0x14
801046df:	6a 00                	push   $0x0
801046e1:	50                   	push   %eax
801046e2:	e8 21 11 00 00       	call   80105808 <memset>
801046e7:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ed:	8b 40 1c             	mov    0x1c(%eax),%eax
801046f0:	ba ad 50 10 80       	mov    $0x801050ad,%edx
801046f5:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801046f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046fb:	c9                   	leave  
801046fc:	c3                   	ret    

801046fd <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801046fd:	f3 0f 1e fb          	endbr32 
80104701:	55                   	push   %ebp
80104702:	89 e5                	mov    %esp,%ebp
80104704:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104707:	e8 e2 fe ff ff       	call   801045ee <allocproc>
8010470c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  
  initproc = p;
8010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104712:	a3 40 d6 10 80       	mov    %eax,0x8010d640
  if((p->pgdir = setupkvm()) == 0)
80104717:	e8 42 3c 00 00       	call   8010835e <setupkvm>
8010471c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010471f:	89 42 04             	mov    %eax,0x4(%edx)
80104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104725:	8b 40 04             	mov    0x4(%eax),%eax
80104728:	85 c0                	test   %eax,%eax
8010472a:	75 0d                	jne    80104739 <userinit+0x3c>
    panic("userinit: out of memory?");
8010472c:	83 ec 0c             	sub    $0xc,%esp
8010472f:	68 2a 99 10 80       	push   $0x8010992a
80104734:	e8 cf be ff ff       	call   80100608 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104739:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104741:	8b 40 04             	mov    0x4(%eax),%eax
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	52                   	push   %edx
80104748:	68 e0 d4 10 80       	push   $0x8010d4e0
8010474d:	50                   	push   %eax
8010474e:	e8 84 3e 00 00       	call   801085d7 <inituvm>
80104753:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104759:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010475f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104762:	8b 40 18             	mov    0x18(%eax),%eax
80104765:	83 ec 04             	sub    $0x4,%esp
80104768:	6a 4c                	push   $0x4c
8010476a:	6a 00                	push   $0x0
8010476c:	50                   	push   %eax
8010476d:	e8 96 10 00 00       	call   80105808 <memset>
80104772:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	8b 40 18             	mov    0x18(%eax),%eax
8010477b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104784:	8b 40 18             	mov    0x18(%eax),%eax
80104787:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	8b 50 18             	mov    0x18(%eax),%edx
80104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104796:	8b 40 18             	mov    0x18(%eax),%eax
80104799:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010479d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801047a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a4:	8b 50 18             	mov    0x18(%eax),%edx
801047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047aa:	8b 40 18             	mov    0x18(%eax),%eax
801047ad:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047b1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801047b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b8:	8b 40 18             	mov    0x18(%eax),%eax
801047bb:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c5:	8b 40 18             	mov    0x18(%eax),%eax
801047c8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d2:	8b 40 18             	mov    0x18(%eax),%eax
801047d5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801047dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047df:	83 c0 6c             	add    $0x6c,%eax
801047e2:	83 ec 04             	sub    $0x4,%esp
801047e5:	6a 10                	push   $0x10
801047e7:	68 43 99 10 80       	push   $0x80109943
801047ec:	50                   	push   %eax
801047ed:	e8 31 12 00 00       	call   80105a23 <safestrcpy>
801047f2:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801047f5:	83 ec 0c             	sub    $0xc,%esp
801047f8:	68 4c 99 10 80       	push   $0x8010994c
801047fd:	e8 76 df ff ff       	call   80102778 <namei>
80104802:	83 c4 10             	add    $0x10,%esp
80104805:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104808:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
8010480b:	83 ec 0c             	sub    $0xc,%esp
8010480e:	68 c0 5d 11 80       	push   $0x80115dc0
80104813:	e8 51 0d 00 00       	call   80105569 <acquire>
80104818:	83 c4 10             	add    $0x10,%esp

  p->state = RUNNABLE;
8010481b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104825:	83 ec 0c             	sub    $0xc,%esp
80104828:	68 c0 5d 11 80       	push   $0x80115dc0
8010482d:	e8 a9 0d 00 00       	call   801055db <release>
80104832:	83 c4 10             	add    $0x10,%esp
}
80104835:	90                   	nop
80104836:	c9                   	leave  
80104837:	c3                   	ret    

80104838 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104838:	f3 0f 1e fb          	endbr32 
8010483c:	55                   	push   %ebp
8010483d:	89 e5                	mov    %esp,%ebp
8010483f:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  struct proc *curproc = myproc();
80104842:	e8 7a fd ff ff       	call   801045c1 <myproc>
80104847:	89 45 e8             	mov    %eax,-0x18(%ebp)

  sz = curproc->sz;
8010484a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010484d:	8b 00                	mov    (%eax),%eax
8010484f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104852:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104856:	7e 52                	jle    801048aa <growproc+0x72>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104858:	8b 55 08             	mov    0x8(%ebp),%edx
8010485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485e:	01 c2                	add    %eax,%edx
80104860:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104863:	8b 40 04             	mov    0x4(%eax),%eax
80104866:	83 ec 04             	sub    $0x4,%esp
80104869:	52                   	push   %edx
8010486a:	ff 75 f4             	pushl  -0xc(%ebp)
8010486d:	50                   	push   %eax
8010486e:	e8 a9 3e 00 00       	call   8010871c <allocuvm>
80104873:	83 c4 10             	add    $0x10,%esp
80104876:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010487d:	75 0a                	jne    80104889 <growproc+0x51>
      return -1;
8010487f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104884:	e9 9b 01 00 00       	jmp    80104a24 <growproc+0x1ec>
    }
    mencrypt((void *)curproc->sz, PGROUNDUP(n)/PGSIZE);
80104889:	8b 45 08             	mov    0x8(%ebp),%eax
8010488c:	05 ff 0f 00 00       	add    $0xfff,%eax
80104891:	c1 f8 0c             	sar    $0xc,%eax
80104894:	89 c2                	mov    %eax,%edx
80104896:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104899:	8b 00                	mov    (%eax),%eax
8010489b:	83 ec 08             	sub    $0x8,%esp
8010489e:	52                   	push   %edx
8010489f:	50                   	push   %eax
801048a0:	e8 c8 47 00 00       	call   8010906d <mencrypt>
801048a5:	83 c4 10             	add    $0x10,%esp
801048a8:	eb 37                	jmp    801048e1 <growproc+0xa9>

  } else if(n < 0){ 
801048aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048ae:	79 31                	jns    801048e1 <growproc+0xa9>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)      
801048b0:	8b 55 08             	mov    0x8(%ebp),%edx
801048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b6:	01 c2                	add    %eax,%edx
801048b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048bb:	8b 40 04             	mov    0x4(%eax),%eax
801048be:	83 ec 04             	sub    $0x4,%esp
801048c1:	52                   	push   %edx
801048c2:	ff 75 f4             	pushl  -0xc(%ebp)
801048c5:	50                   	push   %eax
801048c6:	e8 5a 3f 00 00       	call   80108825 <deallocuvm>
801048cb:	83 c4 10             	add    $0x10,%esp
801048ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048d5:	75 0a                	jne    801048e1 <growproc+0xa9>
      return -1;
801048d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048dc:	e9 43 01 00 00       	jmp    80104a24 <growproc+0x1ec>
    
    //TODO: Check all virtual addresses, ones greater than sz have been deallocated, so delete them
  }

  curproc->sz = sz;
801048e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e7:	89 10                	mov    %edx,(%eax)

  for (int i = 0; i < CLOCKSIZE; i++) {
801048e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801048f0:	e9 12 01 00 00       	jmp    80104a07 <growproc+0x1cf>
    if (curproc->clock_queue[i].is_full) {
801048f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801048f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048fb:	83 c2 07             	add    $0x7,%edx
801048fe:	c1 e2 04             	shl    $0x4,%edx
80104901:	01 d0                	add    %edx,%eax
80104903:	83 c0 0c             	add    $0xc,%eax
80104906:	8b 00                	mov    (%eax),%eax
80104908:	85 c0                	test   %eax,%eax
8010490a:	0f 84 f3 00 00 00    	je     80104a03 <growproc+0x1cb>
      if ((uint)curproc->clock_queue[i].va >= curproc->sz) {
80104910:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104913:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104916:	83 c2 07             	add    $0x7,%edx
80104919:	c1 e2 04             	shl    $0x4,%edx
8010491c:	01 d0                	add    %edx,%eax
8010491e:	83 c0 14             	add    $0x14,%eax
80104921:	8b 00                	mov    (%eax),%eax
80104923:	89 c2                	mov    %eax,%edx
80104925:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104928:	8b 00                	mov    (%eax),%eax
8010492a:	39 c2                	cmp    %eax,%edx
8010492c:	0f 82 d1 00 00 00    	jb     80104a03 <growproc+0x1cb>

        //Evict
        for (int j = i; j < CLOCKSIZE - 1; j++) {
80104932:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104935:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104938:	eb 7f                	jmp    801049b9 <growproc+0x181>
          curproc->clock_queue[j].va = curproc->clock_queue[j+1].va;
8010493a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010493d:	8d 50 01             	lea    0x1(%eax),%edx
80104940:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104943:	83 c2 07             	add    $0x7,%edx
80104946:	c1 e2 04             	shl    $0x4,%edx
80104949:	01 d0                	add    %edx,%eax
8010494b:	83 c0 14             	add    $0x14,%eax
8010494e:	8b 00                	mov    (%eax),%eax
80104950:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104953:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80104956:	83 c1 07             	add    $0x7,%ecx
80104959:	c1 e1 04             	shl    $0x4,%ecx
8010495c:	01 ca                	add    %ecx,%edx
8010495e:	83 c2 14             	add    $0x14,%edx
80104961:	89 02                	mov    %eax,(%edx)
          curproc->clock_queue[j].is_full = curproc->clock_queue[j+1].is_full;
80104963:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104966:	8d 50 01             	lea    0x1(%eax),%edx
80104969:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010496c:	83 c2 07             	add    $0x7,%edx
8010496f:	c1 e2 04             	shl    $0x4,%edx
80104972:	01 d0                	add    %edx,%eax
80104974:	83 c0 0c             	add    $0xc,%eax
80104977:	8b 00                	mov    (%eax),%eax
80104979:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010497c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010497f:	83 c1 07             	add    $0x7,%ecx
80104982:	c1 e1 04             	shl    $0x4,%ecx
80104985:	01 ca                	add    %ecx,%edx
80104987:	83 c2 0c             	add    $0xc,%edx
8010498a:	89 02                	mov    %eax,(%edx)
          curproc->clock_queue[j].pte = curproc->clock_queue[j+1].pte;
8010498c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010498f:	8d 50 01             	lea    0x1(%eax),%edx
80104992:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104995:	83 c2 07             	add    $0x7,%edx
80104998:	c1 e2 04             	shl    $0x4,%edx
8010499b:	01 d0                	add    %edx,%eax
8010499d:	83 c0 18             	add    $0x18,%eax
801049a0:	8b 00                	mov    (%eax),%eax
801049a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
801049a5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801049a8:	83 c1 07             	add    $0x7,%ecx
801049ab:	c1 e1 04             	shl    $0x4,%ecx
801049ae:	01 ca                	add    %ecx,%edx
801049b0:	83 c2 18             	add    $0x18,%edx
801049b3:	89 02                	mov    %eax,(%edx)
        for (int j = i; j < CLOCKSIZE - 1; j++) {
801049b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801049b9:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
801049bd:	0f 8e 77 ff ff ff    	jle    8010493a <growproc+0x102>
        }
        curproc->clock_queue[CLOCKSIZE - 1].va = 0;
801049c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049c6:	c7 80 f4 00 00 00 00 	movl   $0x0,0xf4(%eax)
801049cd:	00 00 00 
        curproc->clock_queue[CLOCKSIZE - 1].is_full = 0;
801049d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049d3:	c7 80 ec 00 00 00 00 	movl   $0x0,0xec(%eax)
801049da:	00 00 00 
        curproc->clock_queue[CLOCKSIZE - 1].pte = 0;
801049dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049e0:	c7 80 f8 00 00 00 00 	movl   $0x0,0xf8(%eax)
801049e7:	00 00 00 
        curproc->q_count--;
801049ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049ed:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
801049f3:	8d 50 ff             	lea    -0x1(%eax),%edx
801049f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801049f9:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
        i--;
801049ff:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  for (int i = 0; i < CLOCKSIZE; i++) {
80104a03:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104a07:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80104a0b:	0f 8e e4 fe ff ff    	jle    801048f5 <growproc+0xbd>
      }
    }
  }

  switchuvm(curproc);
80104a11:	83 ec 0c             	sub    $0xc,%esp
80104a14:	ff 75 e8             	pushl  -0x18(%ebp)
80104a17:	e8 18 3a 00 00       	call   80108434 <switchuvm>
80104a1c:	83 c4 10             	add    $0x10,%esp
  
  // Encrypt the heap, size of newly alloced - original size
  //mencrypt((char*)sz, n / PGSIZE);
  return 0;
80104a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a24:	c9                   	leave  
80104a25:	c3                   	ret    

80104a26 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104a26:	f3 0f 1e fb          	endbr32 
80104a2a:	55                   	push   %ebp
80104a2b:	89 e5                	mov    %esp,%ebp
80104a2d:	57                   	push   %edi
80104a2e:	56                   	push   %esi
80104a2f:	53                   	push   %ebx
80104a30:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104a33:	e8 89 fb ff ff       	call   801045c1 <myproc>
80104a38:	89 45 dc             	mov    %eax,-0x24(%ebp)

    // Allocate process.
  if((np = allocproc()) == 0){
80104a3b:	e8 ae fb ff ff       	call   801045ee <allocproc>
80104a40:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104a43:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104a47:	75 0a                	jne    80104a53 <fork+0x2d>
    return -1;
80104a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a4e:	e9 4a 02 00 00       	jmp    80104c9d <fork+0x277>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104a53:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a56:	8b 10                	mov    (%eax),%edx
80104a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a5b:	8b 40 04             	mov    0x4(%eax),%eax
80104a5e:	83 ec 08             	sub    $0x8,%esp
80104a61:	52                   	push   %edx
80104a62:	50                   	push   %eax
80104a63:	e8 6b 3f 00 00       	call   801089d3 <copyuvm>
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104a6e:	89 42 04             	mov    %eax,0x4(%edx)
80104a71:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a74:	8b 40 04             	mov    0x4(%eax),%eax
80104a77:	85 c0                	test   %eax,%eax
80104a79:	75 30                	jne    80104aab <fork+0x85>
    kfree(np->kstack);
80104a7b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a7e:	8b 40 08             	mov    0x8(%eax),%eax
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	50                   	push   %eax
80104a85:	e8 d5 e3 ff ff       	call   80102e5f <kfree>
80104a8a:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104a97:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104a9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa6:	e9 f2 01 00 00       	jmp    80104c9d <fork+0x277>
  }
  np->sz = curproc->sz;
80104aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aae:	8b 10                	mov    (%eax),%edx
80104ab0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ab3:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
80104ab5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ab8:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104abb:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104abe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ac1:	8b 48 18             	mov    0x18(%eax),%ecx
80104ac4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ac7:	8b 40 18             	mov    0x18(%eax),%eax
80104aca:	89 c2                	mov    %eax,%edx
80104acc:	89 cb                	mov    %ecx,%ebx
80104ace:	b8 13 00 00 00       	mov    $0x13,%eax
80104ad3:	89 d7                	mov    %edx,%edi
80104ad5:	89 de                	mov    %ebx,%esi
80104ad7:	89 c1                	mov    %eax,%ecx
80104ad9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // COPT THE QUEUE

  np->q_head = &np->clock_queue[0];
80104adb:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ade:	8d 50 7c             	lea    0x7c(%eax),%edx
80104ae1:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104ae4:	89 90 fc 00 00 00    	mov    %edx,0xfc(%eax)
  np->q_count = curproc->q_count;
80104aea:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aed:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
80104af3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104af6:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)

  int j;
  for (j = 0; j < CLOCKSIZE - 1; j++ ){
80104afc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80104b03:	eb 2d                	jmp    80104b32 <fork+0x10c>
    np->clock_queue[j].next = &np->clock_queue[j+1];
80104b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b08:	83 c0 01             	add    $0x1,%eax
80104b0b:	83 c0 07             	add    $0x7,%eax
80104b0e:	c1 e0 04             	shl    $0x4,%eax
80104b11:	89 c2                	mov    %eax,%edx
80104b13:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104b16:	01 d0                	add    %edx,%eax
80104b18:	8d 50 0c             	lea    0xc(%eax),%edx
80104b1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104b1e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104b21:	83 c1 07             	add    $0x7,%ecx
80104b24:	c1 e1 04             	shl    $0x4,%ecx
80104b27:	01 c8                	add    %ecx,%eax
80104b29:	83 c0 10             	add    $0x10,%eax
80104b2c:	89 10                	mov    %edx,(%eax)
  for (j = 0; j < CLOCKSIZE - 1; j++ ){
80104b2e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80104b32:	83 7d e0 06          	cmpl   $0x6,-0x20(%ebp)
80104b36:	7e cd                	jle    80104b05 <fork+0xdf>
  }
  j = CLOCKSIZE - 1;
80104b38:	c7 45 e0 07 00 00 00 	movl   $0x7,-0x20(%ebp)
  np->clock_queue[j].next = &np->clock_queue[0];
80104b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104b42:	8d 50 7c             	lea    0x7c(%eax),%edx
80104b45:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104b48:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104b4b:	83 c1 07             	add    $0x7,%ecx
80104b4e:	c1 e1 04             	shl    $0x4,%ecx
80104b51:	01 c8                	add    %ecx,%eax
80104b53:	83 c0 10             	add    $0x10,%eax
80104b56:	89 10                	mov    %edx,(%eax)

  for (i = 0; i < CLOCKSIZE; i++) {
80104b58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b5f:	eb 76                	jmp    80104bd7 <fork+0x1b1>
    np->clock_queue[i].va = curproc->clock_queue[i].va;
80104b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b67:	83 c2 07             	add    $0x7,%edx
80104b6a:	c1 e2 04             	shl    $0x4,%edx
80104b6d:	01 d0                	add    %edx,%eax
80104b6f:	83 c0 14             	add    $0x14,%eax
80104b72:	8b 00                	mov    (%eax),%eax
80104b74:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104b77:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104b7a:	83 c1 07             	add    $0x7,%ecx
80104b7d:	c1 e1 04             	shl    $0x4,%ecx
80104b80:	01 ca                	add    %ecx,%edx
80104b82:	83 c2 14             	add    $0x14,%edx
80104b85:	89 02                	mov    %eax,(%edx)
    np->clock_queue[i].is_full = curproc->clock_queue[i].is_full;
80104b87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b8d:	83 c2 07             	add    $0x7,%edx
80104b90:	c1 e2 04             	shl    $0x4,%edx
80104b93:	01 d0                	add    %edx,%eax
80104b95:	83 c0 0c             	add    $0xc,%eax
80104b98:	8b 00                	mov    (%eax),%eax
80104b9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104ba0:	83 c1 07             	add    $0x7,%ecx
80104ba3:	c1 e1 04             	shl    $0x4,%ecx
80104ba6:	01 ca                	add    %ecx,%edx
80104ba8:	83 c2 0c             	add    $0xc,%edx
80104bab:	89 02                	mov    %eax,(%edx)
    np->clock_queue[i].pte = curproc->clock_queue[i].pte;
80104bad:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104bb3:	83 c2 07             	add    $0x7,%edx
80104bb6:	c1 e2 04             	shl    $0x4,%edx
80104bb9:	01 d0                	add    %edx,%eax
80104bbb:	83 c0 18             	add    $0x18,%eax
80104bbe:	8b 00                	mov    (%eax),%eax
80104bc0:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104bc3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104bc6:	83 c1 07             	add    $0x7,%ecx
80104bc9:	c1 e1 04             	shl    $0x4,%ecx
80104bcc:	01 ca                	add    %ecx,%edx
80104bce:	83 c2 18             	add    $0x18,%edx
80104bd1:	89 02                	mov    %eax,(%edx)
  for (i = 0; i < CLOCKSIZE; i++) {
80104bd3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104bd7:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80104bdb:	7e 84                	jle    80104b61 <fork+0x13b>
    
  }


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104bdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104be0:	8b 40 18             	mov    0x18(%eax),%eax
80104be3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104bea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104bf1:	eb 3b                	jmp    80104c2e <fork+0x208>
    if(curproc->ofile[i])
80104bf3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bf6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104bf9:	83 c2 08             	add    $0x8,%edx
80104bfc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c00:	85 c0                	test   %eax,%eax
80104c02:	74 26                	je     80104c2a <fork+0x204>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104c04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c0a:	83 c2 08             	add    $0x8,%edx
80104c0d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c11:	83 ec 0c             	sub    $0xc,%esp
80104c14:	50                   	push   %eax
80104c15:	e8 1e c6 ff ff       	call   80101238 <filedup>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104c20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104c23:	83 c1 08             	add    $0x8,%ecx
80104c26:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104c2a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104c2e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104c32:	7e bf                	jle    80104bf3 <fork+0x1cd>
  np->cwd = idup(curproc->cwd);
80104c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c37:	8b 40 68             	mov    0x68(%eax),%eax
80104c3a:	83 ec 0c             	sub    $0xc,%esp
80104c3d:	50                   	push   %eax
80104c3e:	e8 8c cf ff ff       	call   80101bcf <idup>
80104c43:	83 c4 10             	add    $0x10,%esp
80104c46:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104c49:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c4f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c52:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c55:	83 c0 6c             	add    $0x6c,%eax
80104c58:	83 ec 04             	sub    $0x4,%esp
80104c5b:	6a 10                	push   $0x10
80104c5d:	52                   	push   %edx
80104c5e:	50                   	push   %eax
80104c5f:	e8 bf 0d 00 00       	call   80105a23 <safestrcpy>
80104c64:	83 c4 10             	add    $0x10,%esp

  pid = np->pid;
80104c67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c6a:	8b 40 10             	mov    0x10(%eax),%eax
80104c6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  acquire(&ptable.lock);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	68 c0 5d 11 80       	push   $0x80115dc0
80104c78:	e8 ec 08 00 00       	call   80105569 <acquire>
80104c7d:	83 c4 10             	add    $0x10,%esp

  np->state = RUNNABLE;
80104c80:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c83:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104c8a:	83 ec 0c             	sub    $0xc,%esp
80104c8d:	68 c0 5d 11 80       	push   $0x80115dc0
80104c92:	e8 44 09 00 00       	call   801055db <release>
80104c97:	83 c4 10             	add    $0x10,%esp

  return pid;
80104c9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ca0:	5b                   	pop    %ebx
80104ca1:	5e                   	pop    %esi
80104ca2:	5f                   	pop    %edi
80104ca3:	5d                   	pop    %ebp
80104ca4:	c3                   	ret    

80104ca5 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104ca5:	f3 0f 1e fb          	endbr32 
80104ca9:	55                   	push   %ebp
80104caa:	89 e5                	mov    %esp,%ebp
80104cac:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80104caf:	e8 0d f9 ff ff       	call   801045c1 <myproc>
80104cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
80104cb7:	a1 40 d6 10 80       	mov    0x8010d640,%eax
80104cbc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104cbf:	75 0d                	jne    80104cce <exit+0x29>
    panic("init exiting");
80104cc1:	83 ec 0c             	sub    $0xc,%esp
80104cc4:	68 4e 99 10 80       	push   $0x8010994e
80104cc9:	e8 3a b9 ff ff       	call   80100608 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104cce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104cd5:	eb 3f                	jmp    80104d16 <exit+0x71>
    if(curproc->ofile[fd]){
80104cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cdd:	83 c2 08             	add    $0x8,%edx
80104ce0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	74 2a                	je     80104d12 <exit+0x6d>
      fileclose(curproc->ofile[fd]);
80104ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ceb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cee:	83 c2 08             	add    $0x8,%edx
80104cf1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cf5:	83 ec 0c             	sub    $0xc,%esp
80104cf8:	50                   	push   %eax
80104cf9:	e8 8f c5 ff ff       	call   8010128d <fileclose>
80104cfe:	83 c4 10             	add    $0x10,%esp
      curproc->ofile[fd] = 0;
80104d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d04:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d07:	83 c2 08             	add    $0x8,%edx
80104d0a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104d11:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104d12:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104d16:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104d1a:	7e bb                	jle    80104cd7 <exit+0x32>
    }
  }

  begin_op();
80104d1c:	e8 e1 ea ff ff       	call   80103802 <begin_op>
  iput(curproc->cwd);
80104d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d24:	8b 40 68             	mov    0x68(%eax),%eax
80104d27:	83 ec 0c             	sub    $0xc,%esp
80104d2a:	50                   	push   %eax
80104d2b:	e8 46 d0 ff ff       	call   80101d76 <iput>
80104d30:	83 c4 10             	add    $0x10,%esp
  end_op();
80104d33:	e8 5a eb ff ff       	call   80103892 <end_op>
  curproc->cwd = 0;
80104d38:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d3b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104d42:	83 ec 0c             	sub    $0xc,%esp
80104d45:	68 c0 5d 11 80       	push   $0x80115dc0
80104d4a:	e8 1a 08 00 00       	call   80105569 <acquire>
80104d4f:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d55:	8b 40 14             	mov    0x14(%eax),%eax
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	50                   	push   %eax
80104d5c:	e8 41 04 00 00       	call   801051a2 <wakeup1>
80104d61:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d64:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104d6b:	eb 3a                	jmp    80104da7 <exit+0x102>
    if(p->parent == curproc){
80104d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d70:	8b 40 14             	mov    0x14(%eax),%eax
80104d73:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104d76:	75 28                	jne    80104da0 <exit+0xfb>
      p->parent = initproc;
80104d78:	8b 15 40 d6 10 80    	mov    0x8010d640,%edx
80104d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d81:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d87:	8b 40 0c             	mov    0xc(%eax),%eax
80104d8a:	83 f8 05             	cmp    $0x5,%eax
80104d8d:	75 11                	jne    80104da0 <exit+0xfb>
        wakeup1(initproc);
80104d8f:	a1 40 d6 10 80       	mov    0x8010d640,%eax
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	50                   	push   %eax
80104d98:	e8 05 04 00 00       	call   801051a2 <wakeup1>
80104d9d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104da0:	81 45 f4 04 01 00 00 	addl   $0x104,-0xc(%ebp)
80104da7:	81 7d f4 f4 9e 11 80 	cmpl   $0x80119ef4,-0xc(%ebp)
80104dae:	72 bd                	jb     80104d6d <exit+0xc8>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104db3:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104dba:	e8 f3 01 00 00       	call   80104fb2 <sched>
  panic("zombie exit");
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	68 5b 99 10 80       	push   $0x8010995b
80104dc7:	e8 3c b8 ff ff       	call   80100608 <panic>

80104dcc <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104dcc:	f3 0f 1e fb          	endbr32 
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104dd6:	e8 e6 f7 ff ff       	call   801045c1 <myproc>
80104ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
80104dde:	83 ec 0c             	sub    $0xc,%esp
80104de1:	68 c0 5d 11 80       	push   $0x80115dc0
80104de6:	e8 7e 07 00 00       	call   80105569 <acquire>
80104deb:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104dee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df5:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104dfc:	e9 a4 00 00 00       	jmp    80104ea5 <wait+0xd9>
      if(p->parent != curproc)
80104e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e04:	8b 40 14             	mov    0x14(%eax),%eax
80104e07:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104e0a:	0f 85 8d 00 00 00    	jne    80104e9d <wait+0xd1>
        continue;
      havekids = 1;
80104e10:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e1d:	83 f8 05             	cmp    $0x5,%eax
80104e20:	75 7c                	jne    80104e9e <wait+0xd2>
        // Found one.
        pid = p->pid;
80104e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e25:	8b 40 10             	mov    0x10(%eax),%eax
80104e28:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2e:	8b 40 08             	mov    0x8(%eax),%eax
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	50                   	push   %eax
80104e35:	e8 25 e0 ff ff       	call   80102e5f <kfree>
80104e3a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4a:	8b 40 04             	mov    0x4(%eax),%eax
80104e4d:	83 ec 0c             	sub    $0xc,%esp
80104e50:	50                   	push   %eax
80104e51:	e8 99 3a 00 00       	call   801088ef <freevm>
80104e56:	83 c4 10             	add    $0x10,%esp
        p->pid = 0;
80104e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e70:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e77:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104e88:	83 ec 0c             	sub    $0xc,%esp
80104e8b:	68 c0 5d 11 80       	push   $0x80115dc0
80104e90:	e8 46 07 00 00       	call   801055db <release>
80104e95:	83 c4 10             	add    $0x10,%esp
        return pid;
80104e98:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104e9b:	eb 54                	jmp    80104ef1 <wait+0x125>
        continue;
80104e9d:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e9e:	81 45 f4 04 01 00 00 	addl   $0x104,-0xc(%ebp)
80104ea5:	81 7d f4 f4 9e 11 80 	cmpl   $0x80119ef4,-0xc(%ebp)
80104eac:	0f 82 4f ff ff ff    	jb     80104e01 <wait+0x35>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104eb6:	74 0a                	je     80104ec2 <wait+0xf6>
80104eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ebb:	8b 40 24             	mov    0x24(%eax),%eax
80104ebe:	85 c0                	test   %eax,%eax
80104ec0:	74 17                	je     80104ed9 <wait+0x10d>
      release(&ptable.lock);
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 c0 5d 11 80       	push   $0x80115dc0
80104eca:	e8 0c 07 00 00       	call   801055db <release>
80104ecf:	83 c4 10             	add    $0x10,%esp
      return -1;
80104ed2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed7:	eb 18                	jmp    80104ef1 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104ed9:	83 ec 08             	sub    $0x8,%esp
80104edc:	68 c0 5d 11 80       	push   $0x80115dc0
80104ee1:	ff 75 ec             	pushl  -0x14(%ebp)
80104ee4:	e8 0e 02 00 00       	call   801050f7 <sleep>
80104ee9:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104eec:	e9 fd fe ff ff       	jmp    80104dee <wait+0x22>
  }
}
80104ef1:	c9                   	leave  
80104ef2:	c3                   	ret    

80104ef3 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104ef3:	f3 0f 1e fb          	endbr32 
80104ef7:	55                   	push   %ebp
80104ef8:	89 e5                	mov    %esp,%ebp
80104efa:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104efd:	e8 43 f6 ff ff       	call   80104545 <mycpu>
80104f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
80104f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f08:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104f0f:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
80104f12:	e8 e6 f5 ff ff       	call   801044fd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104f17:	83 ec 0c             	sub    $0xc,%esp
80104f1a:	68 c0 5d 11 80       	push   $0x80115dc0
80104f1f:	e8 45 06 00 00       	call   80105569 <acquire>
80104f24:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f27:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80104f2e:	eb 64                	jmp    80104f94 <scheduler+0xa1>
      if(p->state != RUNNABLE)
80104f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f33:	8b 40 0c             	mov    0xc(%eax),%eax
80104f36:	83 f8 03             	cmp    $0x3,%eax
80104f39:	75 51                	jne    80104f8c <scheduler+0x99>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f41:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104f47:	83 ec 0c             	sub    $0xc,%esp
80104f4a:	ff 75 f4             	pushl  -0xc(%ebp)
80104f4d:	e8 e2 34 00 00       	call   80108434 <switchuvm>
80104f52:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f58:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f62:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f65:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f68:	83 c2 04             	add    $0x4,%edx
80104f6b:	83 ec 08             	sub    $0x8,%esp
80104f6e:	50                   	push   %eax
80104f6f:	52                   	push   %edx
80104f70:	e8 27 0b 00 00       	call   80105a9c <swtch>
80104f75:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104f78:	e8 9a 34 00 00       	call   80108417 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f80:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104f87:	00 00 00 
80104f8a:	eb 01                	jmp    80104f8d <scheduler+0x9a>
        continue;
80104f8c:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f8d:	81 45 f4 04 01 00 00 	addl   $0x104,-0xc(%ebp)
80104f94:	81 7d f4 f4 9e 11 80 	cmpl   $0x80119ef4,-0xc(%ebp)
80104f9b:	72 93                	jb     80104f30 <scheduler+0x3d>
    }
    release(&ptable.lock);
80104f9d:	83 ec 0c             	sub    $0xc,%esp
80104fa0:	68 c0 5d 11 80       	push   $0x80115dc0
80104fa5:	e8 31 06 00 00       	call   801055db <release>
80104faa:	83 c4 10             	add    $0x10,%esp
    sti();
80104fad:	e9 60 ff ff ff       	jmp    80104f12 <scheduler+0x1f>

80104fb2 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104fb2:	f3 0f 1e fb          	endbr32 
80104fb6:	55                   	push   %ebp
80104fb7:	89 e5                	mov    %esp,%ebp
80104fb9:	83 ec 18             	sub    $0x18,%esp
  int intena;
  struct proc *p = myproc();
80104fbc:	e8 00 f6 ff ff       	call   801045c1 <myproc>
80104fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	68 c0 5d 11 80       	push   $0x80115dc0
80104fcc:	e8 df 06 00 00       	call   801056b0 <holding>
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	75 0d                	jne    80104fe5 <sched+0x33>
    panic("sched ptable.lock");
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	68 67 99 10 80       	push   $0x80109967
80104fe0:	e8 23 b6 ff ff       	call   80100608 <panic>
  if(mycpu()->ncli != 1)
80104fe5:	e8 5b f5 ff ff       	call   80104545 <mycpu>
80104fea:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ff0:	83 f8 01             	cmp    $0x1,%eax
80104ff3:	74 0d                	je     80105002 <sched+0x50>
    panic("sched locks");
80104ff5:	83 ec 0c             	sub    $0xc,%esp
80104ff8:	68 79 99 10 80       	push   $0x80109979
80104ffd:	e8 06 b6 ff ff       	call   80100608 <panic>
  if(p->state == RUNNING)
80105002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105005:	8b 40 0c             	mov    0xc(%eax),%eax
80105008:	83 f8 04             	cmp    $0x4,%eax
8010500b:	75 0d                	jne    8010501a <sched+0x68>
    panic("sched running");
8010500d:	83 ec 0c             	sub    $0xc,%esp
80105010:	68 85 99 10 80       	push   $0x80109985
80105015:	e8 ee b5 ff ff       	call   80100608 <panic>
  if(readeflags()&FL_IF)
8010501a:	e8 ce f4 ff ff       	call   801044ed <readeflags>
8010501f:	25 00 02 00 00       	and    $0x200,%eax
80105024:	85 c0                	test   %eax,%eax
80105026:	74 0d                	je     80105035 <sched+0x83>
    panic("sched interruptible");
80105028:	83 ec 0c             	sub    $0xc,%esp
8010502b:	68 93 99 10 80       	push   $0x80109993
80105030:	e8 d3 b5 ff ff       	call   80100608 <panic>
  intena = mycpu()->intena;
80105035:	e8 0b f5 ff ff       	call   80104545 <mycpu>
8010503a:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105040:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80105043:	e8 fd f4 ff ff       	call   80104545 <mycpu>
80105048:	8b 40 04             	mov    0x4(%eax),%eax
8010504b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010504e:	83 c2 1c             	add    $0x1c,%edx
80105051:	83 ec 08             	sub    $0x8,%esp
80105054:	50                   	push   %eax
80105055:	52                   	push   %edx
80105056:	e8 41 0a 00 00       	call   80105a9c <swtch>
8010505b:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
8010505e:	e8 e2 f4 ff ff       	call   80104545 <mycpu>
80105063:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105066:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
8010506c:	90                   	nop
8010506d:	c9                   	leave  
8010506e:	c3                   	ret    

8010506f <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010506f:	f3 0f 1e fb          	endbr32 
80105073:	55                   	push   %ebp
80105074:	89 e5                	mov    %esp,%ebp
80105076:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105079:	83 ec 0c             	sub    $0xc,%esp
8010507c:	68 c0 5d 11 80       	push   $0x80115dc0
80105081:	e8 e3 04 00 00       	call   80105569 <acquire>
80105086:	83 c4 10             	add    $0x10,%esp
  myproc()->state = RUNNABLE;
80105089:	e8 33 f5 ff ff       	call   801045c1 <myproc>
8010508e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80105095:	e8 18 ff ff ff       	call   80104fb2 <sched>
  release(&ptable.lock);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	68 c0 5d 11 80       	push   $0x80115dc0
801050a2:	e8 34 05 00 00       	call   801055db <release>
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	90                   	nop
801050ab:	c9                   	leave  
801050ac:	c3                   	ret    

801050ad <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801050ad:	f3 0f 1e fb          	endbr32 
801050b1:	55                   	push   %ebp
801050b2:	89 e5                	mov    %esp,%ebp
801050b4:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801050b7:	83 ec 0c             	sub    $0xc,%esp
801050ba:	68 c0 5d 11 80       	push   $0x80115dc0
801050bf:	e8 17 05 00 00       	call   801055db <release>
801050c4:	83 c4 10             	add    $0x10,%esp

  if (first) {
801050c7:	a1 04 d0 10 80       	mov    0x8010d004,%eax
801050cc:	85 c0                	test   %eax,%eax
801050ce:	74 24                	je     801050f4 <forkret+0x47>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801050d0:	c7 05 04 d0 10 80 00 	movl   $0x0,0x8010d004
801050d7:	00 00 00 
    iinit(ROOTDEV);
801050da:	83 ec 0c             	sub    $0xc,%esp
801050dd:	6a 01                	push   $0x1
801050df:	e8 a3 c7 ff ff       	call   80101887 <iinit>
801050e4:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	6a 01                	push   $0x1
801050ec:	e8 de e4 ff ff       	call   801035cf <initlog>
801050f1:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801050f4:	90                   	nop
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    

801050f7 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801050f7:	f3 0f 1e fb          	endbr32 
801050fb:	55                   	push   %ebp
801050fc:	89 e5                	mov    %esp,%ebp
801050fe:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = myproc();
80105101:	e8 bb f4 ff ff       	call   801045c1 <myproc>
80105106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80105109:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010510d:	75 0d                	jne    8010511c <sleep+0x25>
    panic("sleep");
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	68 a7 99 10 80       	push   $0x801099a7
80105117:	e8 ec b4 ff ff       	call   80100608 <panic>

  if(lk == 0)
8010511c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105120:	75 0d                	jne    8010512f <sleep+0x38>
    panic("sleep without lk");
80105122:	83 ec 0c             	sub    $0xc,%esp
80105125:	68 ad 99 10 80       	push   $0x801099ad
8010512a:	e8 d9 b4 ff ff       	call   80100608 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010512f:	81 7d 0c c0 5d 11 80 	cmpl   $0x80115dc0,0xc(%ebp)
80105136:	74 1e                	je     80105156 <sleep+0x5f>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 c0 5d 11 80       	push   $0x80115dc0
80105140:	e8 24 04 00 00       	call   80105569 <acquire>
80105145:	83 c4 10             	add    $0x10,%esp
    release(lk);
80105148:	83 ec 0c             	sub    $0xc,%esp
8010514b:	ff 75 0c             	pushl  0xc(%ebp)
8010514e:	e8 88 04 00 00       	call   801055db <release>
80105153:	83 c4 10             	add    $0x10,%esp
  }
  // Go to sleep.
  p->chan = chan;
80105156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105159:	8b 55 08             	mov    0x8(%ebp),%edx
8010515c:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
8010515f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105162:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80105169:	e8 44 fe ff ff       	call   80104fb2 <sched>

  // Tidy up.
  p->chan = 0;
8010516e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105171:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80105178:	81 7d 0c c0 5d 11 80 	cmpl   $0x80115dc0,0xc(%ebp)
8010517f:	74 1e                	je     8010519f <sleep+0xa8>
    release(&ptable.lock);
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	68 c0 5d 11 80       	push   $0x80115dc0
80105189:	e8 4d 04 00 00       	call   801055db <release>
8010518e:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80105191:	83 ec 0c             	sub    $0xc,%esp
80105194:	ff 75 0c             	pushl  0xc(%ebp)
80105197:	e8 cd 03 00 00       	call   80105569 <acquire>
8010519c:	83 c4 10             	add    $0x10,%esp
  }
}
8010519f:	90                   	nop
801051a0:	c9                   	leave  
801051a1:	c3                   	ret    

801051a2 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801051a2:	f3 0f 1e fb          	endbr32 
801051a6:	55                   	push   %ebp
801051a7:	89 e5                	mov    %esp,%ebp
801051a9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051ac:	c7 45 fc f4 5d 11 80 	movl   $0x80115df4,-0x4(%ebp)
801051b3:	eb 27                	jmp    801051dc <wakeup1+0x3a>
    if(p->state == SLEEPING && p->chan == chan)
801051b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051b8:	8b 40 0c             	mov    0xc(%eax),%eax
801051bb:	83 f8 02             	cmp    $0x2,%eax
801051be:	75 15                	jne    801051d5 <wakeup1+0x33>
801051c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051c3:	8b 40 20             	mov    0x20(%eax),%eax
801051c6:	39 45 08             	cmp    %eax,0x8(%ebp)
801051c9:	75 0a                	jne    801051d5 <wakeup1+0x33>
      p->state = RUNNABLE;
801051cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051d5:	81 45 fc 04 01 00 00 	addl   $0x104,-0x4(%ebp)
801051dc:	81 7d fc f4 9e 11 80 	cmpl   $0x80119ef4,-0x4(%ebp)
801051e3:	72 d0                	jb     801051b5 <wakeup1+0x13>
}
801051e5:	90                   	nop
801051e6:	90                   	nop
801051e7:	c9                   	leave  
801051e8:	c3                   	ret    

801051e9 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801051e9:	f3 0f 1e fb          	endbr32 
801051ed:	55                   	push   %ebp
801051ee:	89 e5                	mov    %esp,%ebp
801051f0:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801051f3:	83 ec 0c             	sub    $0xc,%esp
801051f6:	68 c0 5d 11 80       	push   $0x80115dc0
801051fb:	e8 69 03 00 00       	call   80105569 <acquire>
80105200:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105203:	83 ec 0c             	sub    $0xc,%esp
80105206:	ff 75 08             	pushl  0x8(%ebp)
80105209:	e8 94 ff ff ff       	call   801051a2 <wakeup1>
8010520e:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105211:	83 ec 0c             	sub    $0xc,%esp
80105214:	68 c0 5d 11 80       	push   $0x80115dc0
80105219:	e8 bd 03 00 00       	call   801055db <release>
8010521e:	83 c4 10             	add    $0x10,%esp
}
80105221:	90                   	nop
80105222:	c9                   	leave  
80105223:	c3                   	ret    

80105224 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105224:	f3 0f 1e fb          	endbr32 
80105228:	55                   	push   %ebp
80105229:	89 e5                	mov    %esp,%ebp
8010522b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010522e:	83 ec 0c             	sub    $0xc,%esp
80105231:	68 c0 5d 11 80       	push   $0x80115dc0
80105236:	e8 2e 03 00 00       	call   80105569 <acquire>
8010523b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010523e:	c7 45 f4 f4 5d 11 80 	movl   $0x80115df4,-0xc(%ebp)
80105245:	eb 48                	jmp    8010528f <kill+0x6b>
    if(p->pid == pid){
80105247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524a:	8b 40 10             	mov    0x10(%eax),%eax
8010524d:	39 45 08             	cmp    %eax,0x8(%ebp)
80105250:	75 36                	jne    80105288 <kill+0x64>
      p->killed = 1;
80105252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105255:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010525c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525f:	8b 40 0c             	mov    0xc(%eax),%eax
80105262:	83 f8 02             	cmp    $0x2,%eax
80105265:	75 0a                	jne    80105271 <kill+0x4d>
        p->state = RUNNABLE;
80105267:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010526a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	68 c0 5d 11 80       	push   $0x80115dc0
80105279:	e8 5d 03 00 00       	call   801055db <release>
8010527e:	83 c4 10             	add    $0x10,%esp
      return 0;
80105281:	b8 00 00 00 00       	mov    $0x0,%eax
80105286:	eb 25                	jmp    801052ad <kill+0x89>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105288:	81 45 f4 04 01 00 00 	addl   $0x104,-0xc(%ebp)
8010528f:	81 7d f4 f4 9e 11 80 	cmpl   $0x80119ef4,-0xc(%ebp)
80105296:	72 af                	jb     80105247 <kill+0x23>
    }
  }
  release(&ptable.lock);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	68 c0 5d 11 80       	push   $0x80115dc0
801052a0:	e8 36 03 00 00       	call   801055db <release>
801052a5:	83 c4 10             	add    $0x10,%esp
  return -1;
801052a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ad:	c9                   	leave  
801052ae:	c3                   	ret    

801052af <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801052af:	f3 0f 1e fb          	endbr32 
801052b3:	55                   	push   %ebp
801052b4:	89 e5                	mov    %esp,%ebp
801052b6:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052b9:	c7 45 f0 f4 5d 11 80 	movl   $0x80115df4,-0x10(%ebp)
801052c0:	e9 da 00 00 00       	jmp    8010539f <procdump+0xf0>
    if(p->state == UNUSED)
801052c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052c8:	8b 40 0c             	mov    0xc(%eax),%eax
801052cb:	85 c0                	test   %eax,%eax
801052cd:	0f 84 c4 00 00 00    	je     80105397 <procdump+0xe8>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801052d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052d6:	8b 40 0c             	mov    0xc(%eax),%eax
801052d9:	83 f8 05             	cmp    $0x5,%eax
801052dc:	77 23                	ja     80105301 <procdump+0x52>
801052de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e1:	8b 40 0c             	mov    0xc(%eax),%eax
801052e4:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801052eb:	85 c0                	test   %eax,%eax
801052ed:	74 12                	je     80105301 <procdump+0x52>
      state = states[p->state];
801052ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f2:	8b 40 0c             	mov    0xc(%eax),%eax
801052f5:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801052fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801052ff:	eb 07                	jmp    80105308 <procdump+0x59>
    else
      state = "???";
80105301:	c7 45 ec be 99 10 80 	movl   $0x801099be,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105308:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010530b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010530e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105311:	8b 40 10             	mov    0x10(%eax),%eax
80105314:	52                   	push   %edx
80105315:	ff 75 ec             	pushl  -0x14(%ebp)
80105318:	50                   	push   %eax
80105319:	68 c2 99 10 80       	push   $0x801099c2
8010531e:	e8 f5 b0 ff ff       	call   80100418 <cprintf>
80105323:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105326:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105329:	8b 40 0c             	mov    0xc(%eax),%eax
8010532c:	83 f8 02             	cmp    $0x2,%eax
8010532f:	75 54                	jne    80105385 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105334:	8b 40 1c             	mov    0x1c(%eax),%eax
80105337:	8b 40 0c             	mov    0xc(%eax),%eax
8010533a:	83 c0 08             	add    $0x8,%eax
8010533d:	89 c2                	mov    %eax,%edx
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105345:	50                   	push   %eax
80105346:	52                   	push   %edx
80105347:	e8 e5 02 00 00       	call   80105631 <getcallerpcs>
8010534c:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010534f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105356:	eb 1c                	jmp    80105374 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80105358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535b:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
8010535f:	83 ec 08             	sub    $0x8,%esp
80105362:	50                   	push   %eax
80105363:	68 cb 99 10 80       	push   $0x801099cb
80105368:	e8 ab b0 ff ff       	call   80100418 <cprintf>
8010536d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105370:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105374:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105378:	7f 0b                	jg     80105385 <procdump+0xd6>
8010537a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105381:	85 c0                	test   %eax,%eax
80105383:	75 d3                	jne    80105358 <procdump+0xa9>
    }
    cprintf("\n");
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	68 cf 99 10 80       	push   $0x801099cf
8010538d:	e8 86 b0 ff ff       	call   80100418 <cprintf>
80105392:	83 c4 10             	add    $0x10,%esp
80105395:	eb 01                	jmp    80105398 <procdump+0xe9>
      continue;
80105397:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105398:	81 45 f0 04 01 00 00 	addl   $0x104,-0x10(%ebp)
8010539f:	81 7d f0 f4 9e 11 80 	cmpl   $0x80119ef4,-0x10(%ebp)
801053a6:	0f 82 19 ff ff ff    	jb     801052c5 <procdump+0x16>
  }
}
801053ac:	90                   	nop
801053ad:	90                   	nop
801053ae:	c9                   	leave  
801053af:	c3                   	ret    

801053b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801053b0:	f3 0f 1e fb          	endbr32 
801053b4:	55                   	push   %ebp
801053b5:	89 e5                	mov    %esp,%ebp
801053b7:	83 ec 08             	sub    $0x8,%esp
  initlock(&lk->lk, "sleep lock");
801053ba:	8b 45 08             	mov    0x8(%ebp),%eax
801053bd:	83 c0 04             	add    $0x4,%eax
801053c0:	83 ec 08             	sub    $0x8,%esp
801053c3:	68 fb 99 10 80       	push   $0x801099fb
801053c8:	50                   	push   %eax
801053c9:	e8 75 01 00 00       	call   80105543 <initlock>
801053ce:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801053d1:	8b 45 08             	mov    0x8(%ebp),%eax
801053d4:	8b 55 0c             	mov    0xc(%ebp),%edx
801053d7:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801053da:	8b 45 08             	mov    0x8(%ebp),%eax
801053dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801053e3:	8b 45 08             	mov    0x8(%ebp),%eax
801053e6:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
801053ed:	90                   	nop
801053ee:	c9                   	leave  
801053ef:	c3                   	ret    

801053f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
801053fa:	8b 45 08             	mov    0x8(%ebp),%eax
801053fd:	83 c0 04             	add    $0x4,%eax
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	50                   	push   %eax
80105404:	e8 60 01 00 00       	call   80105569 <acquire>
80105409:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
8010540c:	eb 15                	jmp    80105423 <acquiresleep+0x33>
    sleep(lk, &lk->lk);
8010540e:	8b 45 08             	mov    0x8(%ebp),%eax
80105411:	83 c0 04             	add    $0x4,%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	50                   	push   %eax
80105418:	ff 75 08             	pushl  0x8(%ebp)
8010541b:	e8 d7 fc ff ff       	call   801050f7 <sleep>
80105420:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80105423:	8b 45 08             	mov    0x8(%ebp),%eax
80105426:	8b 00                	mov    (%eax),%eax
80105428:	85 c0                	test   %eax,%eax
8010542a:	75 e2                	jne    8010540e <acquiresleep+0x1e>
  }
  lk->locked = 1;
8010542c:	8b 45 08             	mov    0x8(%ebp),%eax
8010542f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80105435:	e8 87 f1 ff ff       	call   801045c1 <myproc>
8010543a:	8b 50 10             	mov    0x10(%eax),%edx
8010543d:	8b 45 08             	mov    0x8(%ebp),%eax
80105440:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80105443:	8b 45 08             	mov    0x8(%ebp),%eax
80105446:	83 c0 04             	add    $0x4,%eax
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	50                   	push   %eax
8010544d:	e8 89 01 00 00       	call   801055db <release>
80105452:	83 c4 10             	add    $0x10,%esp
}
80105455:	90                   	nop
80105456:	c9                   	leave  
80105457:	c3                   	ret    

80105458 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105458:	f3 0f 1e fb          	endbr32 
8010545c:	55                   	push   %ebp
8010545d:	89 e5                	mov    %esp,%ebp
8010545f:	83 ec 08             	sub    $0x8,%esp
  acquire(&lk->lk);
80105462:	8b 45 08             	mov    0x8(%ebp),%eax
80105465:	83 c0 04             	add    $0x4,%eax
80105468:	83 ec 0c             	sub    $0xc,%esp
8010546b:	50                   	push   %eax
8010546c:	e8 f8 00 00 00       	call   80105569 <acquire>
80105471:	83 c4 10             	add    $0x10,%esp
  lk->locked = 0;
80105474:	8b 45 08             	mov    0x8(%ebp),%eax
80105477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010547d:	8b 45 08             	mov    0x8(%ebp),%eax
80105480:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	ff 75 08             	pushl  0x8(%ebp)
8010548d:	e8 57 fd ff ff       	call   801051e9 <wakeup>
80105492:	83 c4 10             	add    $0x10,%esp
  release(&lk->lk);
80105495:	8b 45 08             	mov    0x8(%ebp),%eax
80105498:	83 c0 04             	add    $0x4,%eax
8010549b:	83 ec 0c             	sub    $0xc,%esp
8010549e:	50                   	push   %eax
8010549f:	e8 37 01 00 00       	call   801055db <release>
801054a4:	83 c4 10             	add    $0x10,%esp
}
801054a7:	90                   	nop
801054a8:	c9                   	leave  
801054a9:	c3                   	ret    

801054aa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801054aa:	f3 0f 1e fb          	endbr32 
801054ae:	55                   	push   %ebp
801054af:	89 e5                	mov    %esp,%ebp
801054b1:	53                   	push   %ebx
801054b2:	83 ec 14             	sub    $0x14,%esp
  int r;
  
  acquire(&lk->lk);
801054b5:	8b 45 08             	mov    0x8(%ebp),%eax
801054b8:	83 c0 04             	add    $0x4,%eax
801054bb:	83 ec 0c             	sub    $0xc,%esp
801054be:	50                   	push   %eax
801054bf:	e8 a5 00 00 00       	call   80105569 <acquire>
801054c4:	83 c4 10             	add    $0x10,%esp
  r = lk->locked && (lk->pid == myproc()->pid);
801054c7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ca:	8b 00                	mov    (%eax),%eax
801054cc:	85 c0                	test   %eax,%eax
801054ce:	74 19                	je     801054e9 <holdingsleep+0x3f>
801054d0:	8b 45 08             	mov    0x8(%ebp),%eax
801054d3:	8b 58 3c             	mov    0x3c(%eax),%ebx
801054d6:	e8 e6 f0 ff ff       	call   801045c1 <myproc>
801054db:	8b 40 10             	mov    0x10(%eax),%eax
801054de:	39 c3                	cmp    %eax,%ebx
801054e0:	75 07                	jne    801054e9 <holdingsleep+0x3f>
801054e2:	b8 01 00 00 00       	mov    $0x1,%eax
801054e7:	eb 05                	jmp    801054ee <holdingsleep+0x44>
801054e9:	b8 00 00 00 00       	mov    $0x0,%eax
801054ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801054f1:	8b 45 08             	mov    0x8(%ebp),%eax
801054f4:	83 c0 04             	add    $0x4,%eax
801054f7:	83 ec 0c             	sub    $0xc,%esp
801054fa:	50                   	push   %eax
801054fb:	e8 db 00 00 00       	call   801055db <release>
80105500:	83 c4 10             	add    $0x10,%esp
  return r;
80105503:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105509:	c9                   	leave  
8010550a:	c3                   	ret    

8010550b <readeflags>:
{
8010550b:	55                   	push   %ebp
8010550c:	89 e5                	mov    %esp,%ebp
8010550e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105511:	9c                   	pushf  
80105512:	58                   	pop    %eax
80105513:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105516:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105519:	c9                   	leave  
8010551a:	c3                   	ret    

8010551b <cli>:
{
8010551b:	55                   	push   %ebp
8010551c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010551e:	fa                   	cli    
}
8010551f:	90                   	nop
80105520:	5d                   	pop    %ebp
80105521:	c3                   	ret    

80105522 <sti>:
{
80105522:	55                   	push   %ebp
80105523:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105525:	fb                   	sti    
}
80105526:	90                   	nop
80105527:	5d                   	pop    %ebp
80105528:	c3                   	ret    

80105529 <xchg>:
{
80105529:	55                   	push   %ebp
8010552a:	89 e5                	mov    %esp,%ebp
8010552c:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
8010552f:	8b 55 08             	mov    0x8(%ebp),%edx
80105532:	8b 45 0c             	mov    0xc(%ebp),%eax
80105535:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105538:	f0 87 02             	lock xchg %eax,(%edx)
8010553b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
8010553e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105541:	c9                   	leave  
80105542:	c3                   	ret    

80105543 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105543:	f3 0f 1e fb          	endbr32 
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010554a:	8b 45 08             	mov    0x8(%ebp),%eax
8010554d:	8b 55 0c             	mov    0xc(%ebp),%edx
80105550:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105553:	8b 45 08             	mov    0x8(%ebp),%eax
80105556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010555c:	8b 45 08             	mov    0x8(%ebp),%eax
8010555f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105566:	90                   	nop
80105567:	5d                   	pop    %ebp
80105568:	c3                   	ret    

80105569 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105569:	f3 0f 1e fb          	endbr32 
8010556d:	55                   	push   %ebp
8010556e:	89 e5                	mov    %esp,%ebp
80105570:	53                   	push   %ebx
80105571:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105574:	e8 7c 01 00 00       	call   801056f5 <pushcli>
  if(holding(lk))
80105579:	8b 45 08             	mov    0x8(%ebp),%eax
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	50                   	push   %eax
80105580:	e8 2b 01 00 00       	call   801056b0 <holding>
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	85 c0                	test   %eax,%eax
8010558a:	74 0d                	je     80105599 <acquire+0x30>
    panic("acquire");
8010558c:	83 ec 0c             	sub    $0xc,%esp
8010558f:	68 06 9a 10 80       	push   $0x80109a06
80105594:	e8 6f b0 ff ff       	call   80100608 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105599:	90                   	nop
8010559a:	8b 45 08             	mov    0x8(%ebp),%eax
8010559d:	83 ec 08             	sub    $0x8,%esp
801055a0:	6a 01                	push   $0x1
801055a2:	50                   	push   %eax
801055a3:	e8 81 ff ff ff       	call   80105529 <xchg>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	75 eb                	jne    8010559a <acquire+0x31>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801055af:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801055b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055b7:	e8 89 ef ff ff       	call   80104545 <mycpu>
801055bc:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801055bf:	8b 45 08             	mov    0x8(%ebp),%eax
801055c2:	83 c0 0c             	add    $0xc,%eax
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	50                   	push   %eax
801055c9:	8d 45 08             	lea    0x8(%ebp),%eax
801055cc:	50                   	push   %eax
801055cd:	e8 5f 00 00 00       	call   80105631 <getcallerpcs>
801055d2:	83 c4 10             	add    $0x10,%esp
}
801055d5:	90                   	nop
801055d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055d9:	c9                   	leave  
801055da:	c3                   	ret    

801055db <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055db:	f3 0f 1e fb          	endbr32 
801055df:	55                   	push   %ebp
801055e0:	89 e5                	mov    %esp,%ebp
801055e2:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	ff 75 08             	pushl  0x8(%ebp)
801055eb:	e8 c0 00 00 00       	call   801056b0 <holding>
801055f0:	83 c4 10             	add    $0x10,%esp
801055f3:	85 c0                	test   %eax,%eax
801055f5:	75 0d                	jne    80105604 <release+0x29>
    panic("release");
801055f7:	83 ec 0c             	sub    $0xc,%esp
801055fa:	68 0e 9a 10 80       	push   $0x80109a0e
801055ff:	e8 04 b0 ff ff       	call   80100608 <panic>

  lk->pcs[0] = 0;
80105604:	8b 45 08             	mov    0x8(%ebp),%eax
80105607:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010560e:	8b 45 08             	mov    0x8(%ebp),%eax
80105611:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105618:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010561d:	8b 45 08             	mov    0x8(%ebp),%eax
80105620:	8b 55 08             	mov    0x8(%ebp),%edx
80105623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105629:	e8 18 01 00 00       	call   80105746 <popcli>
}
8010562e:	90                   	nop
8010562f:	c9                   	leave  
80105630:	c3                   	ret    

80105631 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105631:	f3 0f 1e fb          	endbr32 
80105635:	55                   	push   %ebp
80105636:	89 e5                	mov    %esp,%ebp
80105638:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010563b:	8b 45 08             	mov    0x8(%ebp),%eax
8010563e:	83 e8 08             	sub    $0x8,%eax
80105641:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105644:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010564b:	eb 38                	jmp    80105685 <getcallerpcs+0x54>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010564d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105651:	74 53                	je     801056a6 <getcallerpcs+0x75>
80105653:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010565a:	76 4a                	jbe    801056a6 <getcallerpcs+0x75>
8010565c:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105660:	74 44                	je     801056a6 <getcallerpcs+0x75>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105662:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105665:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010566c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566f:	01 c2                	add    %eax,%edx
80105671:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105674:	8b 40 04             	mov    0x4(%eax),%eax
80105677:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105679:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010567c:	8b 00                	mov    (%eax),%eax
8010567e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105681:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105685:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105689:	7e c2                	jle    8010564d <getcallerpcs+0x1c>
  }
  for(; i < 10; i++)
8010568b:	eb 19                	jmp    801056a6 <getcallerpcs+0x75>
    pcs[i] = 0;
8010568d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105697:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569a:	01 d0                	add    %edx,%eax
8010569c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801056a6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056aa:	7e e1                	jle    8010568d <getcallerpcs+0x5c>
}
801056ac:	90                   	nop
801056ad:	90                   	nop
801056ae:	c9                   	leave  
801056af:	c3                   	ret    

801056b0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	53                   	push   %ebx
801056b8:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801056bb:	e8 35 00 00 00       	call   801056f5 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801056c0:	8b 45 08             	mov    0x8(%ebp),%eax
801056c3:	8b 00                	mov    (%eax),%eax
801056c5:	85 c0                	test   %eax,%eax
801056c7:	74 16                	je     801056df <holding+0x2f>
801056c9:	8b 45 08             	mov    0x8(%ebp),%eax
801056cc:	8b 58 08             	mov    0x8(%eax),%ebx
801056cf:	e8 71 ee ff ff       	call   80104545 <mycpu>
801056d4:	39 c3                	cmp    %eax,%ebx
801056d6:	75 07                	jne    801056df <holding+0x2f>
801056d8:	b8 01 00 00 00       	mov    $0x1,%eax
801056dd:	eb 05                	jmp    801056e4 <holding+0x34>
801056df:	b8 00 00 00 00       	mov    $0x0,%eax
801056e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
801056e7:	e8 5a 00 00 00       	call   80105746 <popcli>
  return r;
801056ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801056ef:	83 c4 14             	add    $0x14,%esp
801056f2:	5b                   	pop    %ebx
801056f3:	5d                   	pop    %ebp
801056f4:	c3                   	ret    

801056f5 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056f5:	f3 0f 1e fb          	endbr32 
801056f9:	55                   	push   %ebp
801056fa:	89 e5                	mov    %esp,%ebp
801056fc:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801056ff:	e8 07 fe ff ff       	call   8010550b <readeflags>
80105704:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80105707:	e8 0f fe ff ff       	call   8010551b <cli>
  if(mycpu()->ncli == 0)
8010570c:	e8 34 ee ff ff       	call   80104545 <mycpu>
80105711:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105717:	85 c0                	test   %eax,%eax
80105719:	75 14                	jne    8010572f <pushcli+0x3a>
    mycpu()->intena = eflags & FL_IF;
8010571b:	e8 25 ee ff ff       	call   80104545 <mycpu>
80105720:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105723:	81 e2 00 02 00 00    	and    $0x200,%edx
80105729:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
8010572f:	e8 11 ee ff ff       	call   80104545 <mycpu>
80105734:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010573a:	83 c2 01             	add    $0x1,%edx
8010573d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105743:	90                   	nop
80105744:	c9                   	leave  
80105745:	c3                   	ret    

80105746 <popcli>:

void
popcli(void)
{
80105746:	f3 0f 1e fb          	endbr32 
8010574a:	55                   	push   %ebp
8010574b:	89 e5                	mov    %esp,%ebp
8010574d:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105750:	e8 b6 fd ff ff       	call   8010550b <readeflags>
80105755:	25 00 02 00 00       	and    $0x200,%eax
8010575a:	85 c0                	test   %eax,%eax
8010575c:	74 0d                	je     8010576b <popcli+0x25>
    panic("popcli - interruptible");
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	68 16 9a 10 80       	push   $0x80109a16
80105766:	e8 9d ae ff ff       	call   80100608 <panic>
  if(--mycpu()->ncli < 0)
8010576b:	e8 d5 ed ff ff       	call   80104545 <mycpu>
80105770:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105776:	83 ea 01             	sub    $0x1,%edx
80105779:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010577f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105785:	85 c0                	test   %eax,%eax
80105787:	79 0d                	jns    80105796 <popcli+0x50>
    panic("popcli");
80105789:	83 ec 0c             	sub    $0xc,%esp
8010578c:	68 2d 9a 10 80       	push   $0x80109a2d
80105791:	e8 72 ae ff ff       	call   80100608 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105796:	e8 aa ed ff ff       	call   80104545 <mycpu>
8010579b:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801057a1:	85 c0                	test   %eax,%eax
801057a3:	75 14                	jne    801057b9 <popcli+0x73>
801057a5:	e8 9b ed ff ff       	call   80104545 <mycpu>
801057aa:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057b0:	85 c0                	test   %eax,%eax
801057b2:	74 05                	je     801057b9 <popcli+0x73>
    sti();
801057b4:	e8 69 fd ff ff       	call   80105522 <sti>
}
801057b9:	90                   	nop
801057ba:	c9                   	leave  
801057bb:	c3                   	ret    

801057bc <stosb>:
{
801057bc:	55                   	push   %ebp
801057bd:	89 e5                	mov    %esp,%ebp
801057bf:	57                   	push   %edi
801057c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057c4:	8b 55 10             	mov    0x10(%ebp),%edx
801057c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ca:	89 cb                	mov    %ecx,%ebx
801057cc:	89 df                	mov    %ebx,%edi
801057ce:	89 d1                	mov    %edx,%ecx
801057d0:	fc                   	cld    
801057d1:	f3 aa                	rep stos %al,%es:(%edi)
801057d3:	89 ca                	mov    %ecx,%edx
801057d5:	89 fb                	mov    %edi,%ebx
801057d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057da:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057dd:	90                   	nop
801057de:	5b                   	pop    %ebx
801057df:	5f                   	pop    %edi
801057e0:	5d                   	pop    %ebp
801057e1:	c3                   	ret    

801057e2 <stosl>:
{
801057e2:	55                   	push   %ebp
801057e3:	89 e5                	mov    %esp,%ebp
801057e5:	57                   	push   %edi
801057e6:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057ea:	8b 55 10             	mov    0x10(%ebp),%edx
801057ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f0:	89 cb                	mov    %ecx,%ebx
801057f2:	89 df                	mov    %ebx,%edi
801057f4:	89 d1                	mov    %edx,%ecx
801057f6:	fc                   	cld    
801057f7:	f3 ab                	rep stos %eax,%es:(%edi)
801057f9:	89 ca                	mov    %ecx,%edx
801057fb:	89 fb                	mov    %edi,%ebx
801057fd:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105800:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105803:	90                   	nop
80105804:	5b                   	pop    %ebx
80105805:	5f                   	pop    %edi
80105806:	5d                   	pop    %ebp
80105807:	c3                   	ret    

80105808 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105808:	f3 0f 1e fb          	endbr32 
8010580c:	55                   	push   %ebp
8010580d:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010580f:	8b 45 08             	mov    0x8(%ebp),%eax
80105812:	83 e0 03             	and    $0x3,%eax
80105815:	85 c0                	test   %eax,%eax
80105817:	75 43                	jne    8010585c <memset+0x54>
80105819:	8b 45 10             	mov    0x10(%ebp),%eax
8010581c:	83 e0 03             	and    $0x3,%eax
8010581f:	85 c0                	test   %eax,%eax
80105821:	75 39                	jne    8010585c <memset+0x54>
    c &= 0xFF;
80105823:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010582a:	8b 45 10             	mov    0x10(%ebp),%eax
8010582d:	c1 e8 02             	shr    $0x2,%eax
80105830:	89 c1                	mov    %eax,%ecx
80105832:	8b 45 0c             	mov    0xc(%ebp),%eax
80105835:	c1 e0 18             	shl    $0x18,%eax
80105838:	89 c2                	mov    %eax,%edx
8010583a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583d:	c1 e0 10             	shl    $0x10,%eax
80105840:	09 c2                	or     %eax,%edx
80105842:	8b 45 0c             	mov    0xc(%ebp),%eax
80105845:	c1 e0 08             	shl    $0x8,%eax
80105848:	09 d0                	or     %edx,%eax
8010584a:	0b 45 0c             	or     0xc(%ebp),%eax
8010584d:	51                   	push   %ecx
8010584e:	50                   	push   %eax
8010584f:	ff 75 08             	pushl  0x8(%ebp)
80105852:	e8 8b ff ff ff       	call   801057e2 <stosl>
80105857:	83 c4 0c             	add    $0xc,%esp
8010585a:	eb 12                	jmp    8010586e <memset+0x66>
  } else
    stosb(dst, c, n);
8010585c:	8b 45 10             	mov    0x10(%ebp),%eax
8010585f:	50                   	push   %eax
80105860:	ff 75 0c             	pushl  0xc(%ebp)
80105863:	ff 75 08             	pushl  0x8(%ebp)
80105866:	e8 51 ff ff ff       	call   801057bc <stosb>
8010586b:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010586e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105871:	c9                   	leave  
80105872:	c3                   	ret    

80105873 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105873:	f3 0f 1e fb          	endbr32 
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010587d:	8b 45 08             	mov    0x8(%ebp),%eax
80105880:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105883:	8b 45 0c             	mov    0xc(%ebp),%eax
80105886:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105889:	eb 30                	jmp    801058bb <memcmp+0x48>
    if(*s1 != *s2)
8010588b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010588e:	0f b6 10             	movzbl (%eax),%edx
80105891:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105894:	0f b6 00             	movzbl (%eax),%eax
80105897:	38 c2                	cmp    %al,%dl
80105899:	74 18                	je     801058b3 <memcmp+0x40>
      return *s1 - *s2;
8010589b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010589e:	0f b6 00             	movzbl (%eax),%eax
801058a1:	0f b6 d0             	movzbl %al,%edx
801058a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058a7:	0f b6 00             	movzbl (%eax),%eax
801058aa:	0f b6 c0             	movzbl %al,%eax
801058ad:	29 c2                	sub    %eax,%edx
801058af:	89 d0                	mov    %edx,%eax
801058b1:	eb 1a                	jmp    801058cd <memcmp+0x5a>
    s1++, s2++;
801058b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058b7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801058bb:	8b 45 10             	mov    0x10(%ebp),%eax
801058be:	8d 50 ff             	lea    -0x1(%eax),%edx
801058c1:	89 55 10             	mov    %edx,0x10(%ebp)
801058c4:	85 c0                	test   %eax,%eax
801058c6:	75 c3                	jne    8010588b <memcmp+0x18>
  }

  return 0;
801058c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058cd:	c9                   	leave  
801058ce:	c3                   	ret    

801058cf <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058cf:	f3 0f 1e fb          	endbr32 
801058d3:	55                   	push   %ebp
801058d4:	89 e5                	mov    %esp,%ebp
801058d6:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801058dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058df:	8b 45 08             	mov    0x8(%ebp),%eax
801058e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058eb:	73 54                	jae    80105941 <memmove+0x72>
801058ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058f0:	8b 45 10             	mov    0x10(%ebp),%eax
801058f3:	01 d0                	add    %edx,%eax
801058f5:	39 45 f8             	cmp    %eax,-0x8(%ebp)
801058f8:	73 47                	jae    80105941 <memmove+0x72>
    s += n;
801058fa:	8b 45 10             	mov    0x10(%ebp),%eax
801058fd:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105900:	8b 45 10             	mov    0x10(%ebp),%eax
80105903:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105906:	eb 13                	jmp    8010591b <memmove+0x4c>
      *--d = *--s;
80105908:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010590c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105910:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105913:	0f b6 10             	movzbl (%eax),%edx
80105916:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105919:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010591b:	8b 45 10             	mov    0x10(%ebp),%eax
8010591e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105921:	89 55 10             	mov    %edx,0x10(%ebp)
80105924:	85 c0                	test   %eax,%eax
80105926:	75 e0                	jne    80105908 <memmove+0x39>
  if(s < d && s + n > d){
80105928:	eb 24                	jmp    8010594e <memmove+0x7f>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010592a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010592d:	8d 42 01             	lea    0x1(%edx),%eax
80105930:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105933:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105936:	8d 48 01             	lea    0x1(%eax),%ecx
80105939:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010593c:	0f b6 12             	movzbl (%edx),%edx
8010593f:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105941:	8b 45 10             	mov    0x10(%ebp),%eax
80105944:	8d 50 ff             	lea    -0x1(%eax),%edx
80105947:	89 55 10             	mov    %edx,0x10(%ebp)
8010594a:	85 c0                	test   %eax,%eax
8010594c:	75 dc                	jne    8010592a <memmove+0x5b>

  return dst;
8010594e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105951:	c9                   	leave  
80105952:	c3                   	ret    

80105953 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105953:	f3 0f 1e fb          	endbr32 
80105957:	55                   	push   %ebp
80105958:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010595a:	ff 75 10             	pushl  0x10(%ebp)
8010595d:	ff 75 0c             	pushl  0xc(%ebp)
80105960:	ff 75 08             	pushl  0x8(%ebp)
80105963:	e8 67 ff ff ff       	call   801058cf <memmove>
80105968:	83 c4 0c             	add    $0xc,%esp
}
8010596b:	c9                   	leave  
8010596c:	c3                   	ret    

8010596d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010596d:	f3 0f 1e fb          	endbr32 
80105971:	55                   	push   %ebp
80105972:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105974:	eb 0c                	jmp    80105982 <strncmp+0x15>
    n--, p++, q++;
80105976:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010597a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010597e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105982:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105986:	74 1a                	je     801059a2 <strncmp+0x35>
80105988:	8b 45 08             	mov    0x8(%ebp),%eax
8010598b:	0f b6 00             	movzbl (%eax),%eax
8010598e:	84 c0                	test   %al,%al
80105990:	74 10                	je     801059a2 <strncmp+0x35>
80105992:	8b 45 08             	mov    0x8(%ebp),%eax
80105995:	0f b6 10             	movzbl (%eax),%edx
80105998:	8b 45 0c             	mov    0xc(%ebp),%eax
8010599b:	0f b6 00             	movzbl (%eax),%eax
8010599e:	38 c2                	cmp    %al,%dl
801059a0:	74 d4                	je     80105976 <strncmp+0x9>
  if(n == 0)
801059a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a6:	75 07                	jne    801059af <strncmp+0x42>
    return 0;
801059a8:	b8 00 00 00 00       	mov    $0x0,%eax
801059ad:	eb 16                	jmp    801059c5 <strncmp+0x58>
  return (uchar)*p - (uchar)*q;
801059af:	8b 45 08             	mov    0x8(%ebp),%eax
801059b2:	0f b6 00             	movzbl (%eax),%eax
801059b5:	0f b6 d0             	movzbl %al,%edx
801059b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059bb:	0f b6 00             	movzbl (%eax),%eax
801059be:	0f b6 c0             	movzbl %al,%eax
801059c1:	29 c2                	sub    %eax,%edx
801059c3:	89 d0                	mov    %edx,%eax
}
801059c5:	5d                   	pop    %ebp
801059c6:	c3                   	ret    

801059c7 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059c7:	f3 0f 1e fb          	endbr32 
801059cb:	55                   	push   %ebp
801059cc:	89 e5                	mov    %esp,%ebp
801059ce:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801059d1:	8b 45 08             	mov    0x8(%ebp),%eax
801059d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059d7:	90                   	nop
801059d8:	8b 45 10             	mov    0x10(%ebp),%eax
801059db:	8d 50 ff             	lea    -0x1(%eax),%edx
801059de:	89 55 10             	mov    %edx,0x10(%ebp)
801059e1:	85 c0                	test   %eax,%eax
801059e3:	7e 2c                	jle    80105a11 <strncpy+0x4a>
801059e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801059e8:	8d 42 01             	lea    0x1(%edx),%eax
801059eb:	89 45 0c             	mov    %eax,0xc(%ebp)
801059ee:	8b 45 08             	mov    0x8(%ebp),%eax
801059f1:	8d 48 01             	lea    0x1(%eax),%ecx
801059f4:	89 4d 08             	mov    %ecx,0x8(%ebp)
801059f7:	0f b6 12             	movzbl (%edx),%edx
801059fa:	88 10                	mov    %dl,(%eax)
801059fc:	0f b6 00             	movzbl (%eax),%eax
801059ff:	84 c0                	test   %al,%al
80105a01:	75 d5                	jne    801059d8 <strncpy+0x11>
    ;
  while(n-- > 0)
80105a03:	eb 0c                	jmp    80105a11 <strncpy+0x4a>
    *s++ = 0;
80105a05:	8b 45 08             	mov    0x8(%ebp),%eax
80105a08:	8d 50 01             	lea    0x1(%eax),%edx
80105a0b:	89 55 08             	mov    %edx,0x8(%ebp)
80105a0e:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105a11:	8b 45 10             	mov    0x10(%ebp),%eax
80105a14:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a17:	89 55 10             	mov    %edx,0x10(%ebp)
80105a1a:	85 c0                	test   %eax,%eax
80105a1c:	7f e7                	jg     80105a05 <strncpy+0x3e>
  return os;
80105a1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a21:	c9                   	leave  
80105a22:	c3                   	ret    

80105a23 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a23:	f3 0f 1e fb          	endbr32 
80105a27:	55                   	push   %ebp
80105a28:	89 e5                	mov    %esp,%ebp
80105a2a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a37:	7f 05                	jg     80105a3e <safestrcpy+0x1b>
    return os;
80105a39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a3c:	eb 31                	jmp    80105a6f <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a3e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a46:	7e 1e                	jle    80105a66 <safestrcpy+0x43>
80105a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a4b:	8d 42 01             	lea    0x1(%edx),%eax
80105a4e:	89 45 0c             	mov    %eax,0xc(%ebp)
80105a51:	8b 45 08             	mov    0x8(%ebp),%eax
80105a54:	8d 48 01             	lea    0x1(%eax),%ecx
80105a57:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105a5a:	0f b6 12             	movzbl (%edx),%edx
80105a5d:	88 10                	mov    %dl,(%eax)
80105a5f:	0f b6 00             	movzbl (%eax),%eax
80105a62:	84 c0                	test   %al,%al
80105a64:	75 d8                	jne    80105a3e <safestrcpy+0x1b>
    ;
  *s = 0;
80105a66:	8b 45 08             	mov    0x8(%ebp),%eax
80105a69:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a6f:	c9                   	leave  
80105a70:	c3                   	ret    

80105a71 <strlen>:

int
strlen(const char *s)
{
80105a71:	f3 0f 1e fb          	endbr32 
80105a75:	55                   	push   %ebp
80105a76:	89 e5                	mov    %esp,%ebp
80105a78:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a7b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a82:	eb 04                	jmp    80105a88 <strlen+0x17>
80105a84:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a88:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8e:	01 d0                	add    %edx,%eax
80105a90:	0f b6 00             	movzbl (%eax),%eax
80105a93:	84 c0                	test   %al,%al
80105a95:	75 ed                	jne    80105a84 <strlen+0x13>
    ;
  return n;
80105a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a9a:	c9                   	leave  
80105a9b:	c3                   	ret    

80105a9c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105a9c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105aa0:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105aa4:	55                   	push   %ebp
  pushl %ebx
80105aa5:	53                   	push   %ebx
  pushl %esi
80105aa6:	56                   	push   %esi
  pushl %edi
80105aa7:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105aa8:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105aaa:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105aac:	5f                   	pop    %edi
  popl %esi
80105aad:	5e                   	pop    %esi
  popl %ebx
80105aae:	5b                   	pop    %ebx
  popl %ebp
80105aaf:	5d                   	pop    %ebp
  ret
80105ab0:	c3                   	ret    

80105ab1 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105ab1:	f3 0f 1e fb          	endbr32 
80105ab5:	55                   	push   %ebp
80105ab6:	89 e5                	mov    %esp,%ebp
80105ab8:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105abb:	e8 01 eb ff ff       	call   801045c1 <myproc>
80105ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac6:	8b 00                	mov    (%eax),%eax
80105ac8:	39 45 08             	cmp    %eax,0x8(%ebp)
80105acb:	73 0f                	jae    80105adc <fetchint+0x2b>
80105acd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad0:	8d 50 04             	lea    0x4(%eax),%edx
80105ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad6:	8b 00                	mov    (%eax),%eax
80105ad8:	39 c2                	cmp    %eax,%edx
80105ada:	76 07                	jbe    80105ae3 <fetchint+0x32>
    return -1;
80105adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae1:	eb 0f                	jmp    80105af2 <fetchint+0x41>
  *ip = *(int*)(addr);
80105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae6:	8b 10                	mov    (%eax),%edx
80105ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aeb:	89 10                	mov    %edx,(%eax)
  return 0;
80105aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    

80105af4 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105af4:	f3 0f 1e fb          	endbr32 
80105af8:	55                   	push   %ebp
80105af9:	89 e5                	mov    %esp,%ebp
80105afb:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
80105afe:	e8 be ea ff ff       	call   801045c1 <myproc>
80105b03:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
80105b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b09:	8b 00                	mov    (%eax),%eax
80105b0b:	39 45 08             	cmp    %eax,0x8(%ebp)
80105b0e:	72 07                	jb     80105b17 <fetchstr+0x23>
    return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b15:	eb 43                	jmp    80105b5a <fetchstr+0x66>
  *pp = (char*)addr;
80105b17:	8b 55 08             	mov    0x8(%ebp),%edx
80105b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1d:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
80105b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b22:	8b 00                	mov    (%eax),%eax
80105b24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105b27:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2a:	8b 00                	mov    (%eax),%eax
80105b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b2f:	eb 1c                	jmp    80105b4d <fetchstr+0x59>
    if(*s == 0)
80105b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b34:	0f b6 00             	movzbl (%eax),%eax
80105b37:	84 c0                	test   %al,%al
80105b39:	75 0e                	jne    80105b49 <fetchstr+0x55>
      return s - *pp;
80105b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b3e:	8b 00                	mov    (%eax),%eax
80105b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b43:	29 c2                	sub    %eax,%edx
80105b45:	89 d0                	mov    %edx,%eax
80105b47:	eb 11                	jmp    80105b5a <fetchstr+0x66>
  for(s = *pp; s < ep; s++){
80105b49:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b50:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80105b53:	72 dc                	jb     80105b31 <fetchstr+0x3d>
  }
  return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b5a:	c9                   	leave  
80105b5b:	c3                   	ret    

80105b5c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b5c:	f3 0f 1e fb          	endbr32 
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105b66:	e8 56 ea ff ff       	call   801045c1 <myproc>
80105b6b:	8b 40 18             	mov    0x18(%eax),%eax
80105b6e:	8b 40 44             	mov    0x44(%eax),%eax
80105b71:	8b 55 08             	mov    0x8(%ebp),%edx
80105b74:	c1 e2 02             	shl    $0x2,%edx
80105b77:	01 d0                	add    %edx,%eax
80105b79:	83 c0 04             	add    $0x4,%eax
80105b7c:	83 ec 08             	sub    $0x8,%esp
80105b7f:	ff 75 0c             	pushl  0xc(%ebp)
80105b82:	50                   	push   %eax
80105b83:	e8 29 ff ff ff       	call   80105ab1 <fetchint>
80105b88:	83 c4 10             	add    $0x10,%esp
}
80105b8b:	c9                   	leave  
80105b8c:	c3                   	ret    

80105b8d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b8d:	f3 0f 1e fb          	endbr32 
80105b91:	55                   	push   %ebp
80105b92:	89 e5                	mov    %esp,%ebp
80105b94:	83 ec 18             	sub    $0x18,%esp
  int i;
  struct proc *curproc = myproc();
80105b97:	e8 25 ea ff ff       	call   801045c1 <myproc>
80105b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105b9f:	83 ec 08             	sub    $0x8,%esp
80105ba2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ba5:	50                   	push   %eax
80105ba6:	ff 75 08             	pushl  0x8(%ebp)
80105ba9:	e8 ae ff ff ff       	call   80105b5c <argint>
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	85 c0                	test   %eax,%eax
80105bb3:	79 07                	jns    80105bbc <argptr+0x2f>
    return -1;
80105bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bba:	eb 3b                	jmp    80105bf7 <argptr+0x6a>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105bbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bc0:	78 1f                	js     80105be1 <argptr+0x54>
80105bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc5:	8b 00                	mov    (%eax),%eax
80105bc7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bca:	39 d0                	cmp    %edx,%eax
80105bcc:	76 13                	jbe    80105be1 <argptr+0x54>
80105bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd1:	89 c2                	mov    %eax,%edx
80105bd3:	8b 45 10             	mov    0x10(%ebp),%eax
80105bd6:	01 c2                	add    %eax,%edx
80105bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdb:	8b 00                	mov    (%eax),%eax
80105bdd:	39 c2                	cmp    %eax,%edx
80105bdf:	76 07                	jbe    80105be8 <argptr+0x5b>
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be6:	eb 0f                	jmp    80105bf7 <argptr+0x6a>
  *pp = (char*)i;
80105be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105beb:	89 c2                	mov    %eax,%edx
80105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bf0:	89 10                	mov    %edx,(%eax)
  return 0;
80105bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bf7:	c9                   	leave  
80105bf8:	c3                   	ret    

80105bf9 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bf9:	f3 0f 1e fb          	endbr32 
80105bfd:	55                   	push   %ebp
80105bfe:	89 e5                	mov    %esp,%ebp
80105c00:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105c03:	83 ec 08             	sub    $0x8,%esp
80105c06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	ff 75 08             	pushl  0x8(%ebp)
80105c0d:	e8 4a ff ff ff       	call   80105b5c <argint>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	79 07                	jns    80105c20 <argstr+0x27>
    return -1;
80105c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1e:	eb 12                	jmp    80105c32 <argstr+0x39>
  return fetchstr(addr, pp);
80105c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c23:	83 ec 08             	sub    $0x8,%esp
80105c26:	ff 75 0c             	pushl  0xc(%ebp)
80105c29:	50                   	push   %eax
80105c2a:	e8 c5 fe ff ff       	call   80105af4 <fetchstr>
80105c2f:	83 c4 10             	add    $0x10,%esp
}
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    

80105c34 <syscall>:
[SYS_dump_rawphymem] sys_dump_rawphymem,
};

void
syscall(void)
{
80105c34:	f3 0f 1e fb          	endbr32 
80105c38:	55                   	push   %ebp
80105c39:	89 e5                	mov    %esp,%ebp
80105c3b:	83 ec 18             	sub    $0x18,%esp
  int num;
  struct proc *curproc = myproc();
80105c3e:	e8 7e e9 ff ff       	call   801045c1 <myproc>
80105c43:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c49:	8b 40 18             	mov    0x18(%eax),%eax
80105c4c:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c56:	7e 2f                	jle    80105c87 <syscall+0x53>
80105c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5b:	83 f8 18             	cmp    $0x18,%eax
80105c5e:	77 27                	ja     80105c87 <syscall+0x53>
80105c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c63:	8b 04 85 20 d0 10 80 	mov    -0x7fef2fe0(,%eax,4),%eax
80105c6a:	85 c0                	test   %eax,%eax
80105c6c:	74 19                	je     80105c87 <syscall+0x53>
    curproc->tf->eax = syscalls[num]();
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	8b 04 85 20 d0 10 80 	mov    -0x7fef2fe0(,%eax,4),%eax
80105c78:	ff d0                	call   *%eax
80105c7a:	89 c2                	mov    %eax,%edx
80105c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7f:	8b 40 18             	mov    0x18(%eax),%eax
80105c82:	89 50 1c             	mov    %edx,0x1c(%eax)
80105c85:	eb 2c                	jmp    80105cb3 <syscall+0x7f>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8a:	8d 50 6c             	lea    0x6c(%eax),%edx
    cprintf("%d %s: unknown sys call %d\n",
80105c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c90:	8b 40 10             	mov    0x10(%eax),%eax
80105c93:	ff 75 f0             	pushl  -0x10(%ebp)
80105c96:	52                   	push   %edx
80105c97:	50                   	push   %eax
80105c98:	68 34 9a 10 80       	push   $0x80109a34
80105c9d:	e8 76 a7 ff ff       	call   80100418 <cprintf>
80105ca2:	83 c4 10             	add    $0x10,%esp
    curproc->tf->eax = -1;
80105ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca8:	8b 40 18             	mov    0x18(%eax),%eax
80105cab:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105cb2:	90                   	nop
80105cb3:	90                   	nop
80105cb4:	c9                   	leave  
80105cb5:	c3                   	ret    

80105cb6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cb6:	f3 0f 1e fb          	endbr32 
80105cba:	55                   	push   %ebp
80105cbb:	89 e5                	mov    %esp,%ebp
80105cbd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105cc0:	83 ec 08             	sub    $0x8,%esp
80105cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cc6:	50                   	push   %eax
80105cc7:	ff 75 08             	pushl  0x8(%ebp)
80105cca:	e8 8d fe ff ff       	call   80105b5c <argint>
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	85 c0                	test   %eax,%eax
80105cd4:	79 07                	jns    80105cdd <argfd+0x27>
    return -1;
80105cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cdb:	eb 4f                	jmp    80105d2c <argfd+0x76>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	78 20                	js     80105d04 <argfd+0x4e>
80105ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce7:	83 f8 0f             	cmp    $0xf,%eax
80105cea:	7f 18                	jg     80105d04 <argfd+0x4e>
80105cec:	e8 d0 e8 ff ff       	call   801045c1 <myproc>
80105cf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf4:	83 c2 08             	add    $0x8,%edx
80105cf7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d02:	75 07                	jne    80105d0b <argfd+0x55>
    return -1;
80105d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d09:	eb 21                	jmp    80105d2c <argfd+0x76>
  if(pfd)
80105d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d0f:	74 08                	je     80105d19 <argfd+0x63>
    *pfd = fd;
80105d11:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d14:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d17:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d1d:	74 08                	je     80105d27 <argfd+0x71>
    *pf = f;
80105d1f:	8b 45 10             	mov    0x10(%ebp),%eax
80105d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d25:	89 10                	mov    %edx,(%eax)
  return 0;
80105d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d2c:	c9                   	leave  
80105d2d:	c3                   	ret    

80105d2e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d2e:	f3 0f 1e fb          	endbr32 
80105d32:	55                   	push   %ebp
80105d33:	89 e5                	mov    %esp,%ebp
80105d35:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105d38:	e8 84 e8 ff ff       	call   801045c1 <myproc>
80105d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105d40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d47:	eb 2a                	jmp    80105d73 <fdalloc+0x45>
    if(curproc->ofile[fd] == 0){
80105d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d4f:	83 c2 08             	add    $0x8,%edx
80105d52:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d56:	85 c0                	test   %eax,%eax
80105d58:	75 15                	jne    80105d6f <fdalloc+0x41>
      curproc->ofile[fd] = f;
80105d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d60:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d63:	8b 55 08             	mov    0x8(%ebp),%edx
80105d66:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6d:	eb 0f                	jmp    80105d7e <fdalloc+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105d6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d73:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d77:	7e d0                	jle    80105d49 <fdalloc+0x1b>
    }
  }
  return -1;
80105d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7e:	c9                   	leave  
80105d7f:	c3                   	ret    

80105d80 <sys_dup>:

int
sys_dup(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105d8a:	83 ec 04             	sub    $0x4,%esp
80105d8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d90:	50                   	push   %eax
80105d91:	6a 00                	push   $0x0
80105d93:	6a 00                	push   $0x0
80105d95:	e8 1c ff ff ff       	call   80105cb6 <argfd>
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	85 c0                	test   %eax,%eax
80105d9f:	79 07                	jns    80105da8 <sys_dup+0x28>
    return -1;
80105da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da6:	eb 31                	jmp    80105dd9 <sys_dup+0x59>
  if((fd=fdalloc(f)) < 0)
80105da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dab:	83 ec 0c             	sub    $0xc,%esp
80105dae:	50                   	push   %eax
80105daf:	e8 7a ff ff ff       	call   80105d2e <fdalloc>
80105db4:	83 c4 10             	add    $0x10,%esp
80105db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dbe:	79 07                	jns    80105dc7 <sys_dup+0x47>
    return -1;
80105dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc5:	eb 12                	jmp    80105dd9 <sys_dup+0x59>
  filedup(f);
80105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dca:	83 ec 0c             	sub    $0xc,%esp
80105dcd:	50                   	push   %eax
80105dce:	e8 65 b4 ff ff       	call   80101238 <filedup>
80105dd3:	83 c4 10             	add    $0x10,%esp
  return fd;
80105dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105dd9:	c9                   	leave  
80105dda:	c3                   	ret    

80105ddb <sys_read>:

int
sys_read(void)
{
80105ddb:	f3 0f 1e fb          	endbr32 
80105ddf:	55                   	push   %ebp
80105de0:	89 e5                	mov    %esp,%ebp
80105de2:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105de5:	83 ec 04             	sub    $0x4,%esp
80105de8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105deb:	50                   	push   %eax
80105dec:	6a 00                	push   $0x0
80105dee:	6a 00                	push   $0x0
80105df0:	e8 c1 fe ff ff       	call   80105cb6 <argfd>
80105df5:	83 c4 10             	add    $0x10,%esp
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	78 2e                	js     80105e2a <sys_read+0x4f>
80105dfc:	83 ec 08             	sub    $0x8,%esp
80105dff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e02:	50                   	push   %eax
80105e03:	6a 02                	push   $0x2
80105e05:	e8 52 fd ff ff       	call   80105b5c <argint>
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	85 c0                	test   %eax,%eax
80105e0f:	78 19                	js     80105e2a <sys_read+0x4f>
80105e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e14:	83 ec 04             	sub    $0x4,%esp
80105e17:	50                   	push   %eax
80105e18:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e1b:	50                   	push   %eax
80105e1c:	6a 01                	push   $0x1
80105e1e:	e8 6a fd ff ff       	call   80105b8d <argptr>
80105e23:	83 c4 10             	add    $0x10,%esp
80105e26:	85 c0                	test   %eax,%eax
80105e28:	79 07                	jns    80105e31 <sys_read+0x56>
    return -1;
80105e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2f:	eb 17                	jmp    80105e48 <sys_read+0x6d>
  return fileread(f, p, n);
80105e31:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e34:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3a:	83 ec 04             	sub    $0x4,%esp
80105e3d:	51                   	push   %ecx
80105e3e:	52                   	push   %edx
80105e3f:	50                   	push   %eax
80105e40:	e8 8f b5 ff ff       	call   801013d4 <fileread>
80105e45:	83 c4 10             	add    $0x10,%esp
}
80105e48:	c9                   	leave  
80105e49:	c3                   	ret    

80105e4a <sys_write>:

int
sys_write(void)
{
80105e4a:	f3 0f 1e fb          	endbr32 
80105e4e:	55                   	push   %ebp
80105e4f:	89 e5                	mov    %esp,%ebp
80105e51:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e54:	83 ec 04             	sub    $0x4,%esp
80105e57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e5a:	50                   	push   %eax
80105e5b:	6a 00                	push   $0x0
80105e5d:	6a 00                	push   $0x0
80105e5f:	e8 52 fe ff ff       	call   80105cb6 <argfd>
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	85 c0                	test   %eax,%eax
80105e69:	78 2e                	js     80105e99 <sys_write+0x4f>
80105e6b:	83 ec 08             	sub    $0x8,%esp
80105e6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e71:	50                   	push   %eax
80105e72:	6a 02                	push   $0x2
80105e74:	e8 e3 fc ff ff       	call   80105b5c <argint>
80105e79:	83 c4 10             	add    $0x10,%esp
80105e7c:	85 c0                	test   %eax,%eax
80105e7e:	78 19                	js     80105e99 <sys_write+0x4f>
80105e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e83:	83 ec 04             	sub    $0x4,%esp
80105e86:	50                   	push   %eax
80105e87:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e8a:	50                   	push   %eax
80105e8b:	6a 01                	push   $0x1
80105e8d:	e8 fb fc ff ff       	call   80105b8d <argptr>
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	85 c0                	test   %eax,%eax
80105e97:	79 07                	jns    80105ea0 <sys_write+0x56>
    return -1;
80105e99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9e:	eb 17                	jmp    80105eb7 <sys_write+0x6d>
  return filewrite(f, p, n);
80105ea0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105ea3:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea9:	83 ec 04             	sub    $0x4,%esp
80105eac:	51                   	push   %ecx
80105ead:	52                   	push   %edx
80105eae:	50                   	push   %eax
80105eaf:	e8 dc b5 ff ff       	call   80101490 <filewrite>
80105eb4:	83 c4 10             	add    $0x10,%esp
}
80105eb7:	c9                   	leave  
80105eb8:	c3                   	ret    

80105eb9 <sys_close>:

int
sys_close(void)
{
80105eb9:	f3 0f 1e fb          	endbr32 
80105ebd:	55                   	push   %ebp
80105ebe:	89 e5                	mov    %esp,%ebp
80105ec0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105ec3:	83 ec 04             	sub    $0x4,%esp
80105ec6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ec9:	50                   	push   %eax
80105eca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ecd:	50                   	push   %eax
80105ece:	6a 00                	push   $0x0
80105ed0:	e8 e1 fd ff ff       	call   80105cb6 <argfd>
80105ed5:	83 c4 10             	add    $0x10,%esp
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	79 07                	jns    80105ee3 <sys_close+0x2a>
    return -1;
80105edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee1:	eb 27                	jmp    80105f0a <sys_close+0x51>
  myproc()->ofile[fd] = 0;
80105ee3:	e8 d9 e6 ff ff       	call   801045c1 <myproc>
80105ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eeb:	83 c2 08             	add    $0x8,%edx
80105eee:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105ef5:	00 
  fileclose(f);
80105ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef9:	83 ec 0c             	sub    $0xc,%esp
80105efc:	50                   	push   %eax
80105efd:	e8 8b b3 ff ff       	call   8010128d <fileclose>
80105f02:	83 c4 10             	add    $0x10,%esp
  return 0;
80105f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f0a:	c9                   	leave  
80105f0b:	c3                   	ret    

80105f0c <sys_fstat>:

int
sys_fstat(void)
{
80105f0c:	f3 0f 1e fb          	endbr32 
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105f16:	83 ec 04             	sub    $0x4,%esp
80105f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f1c:	50                   	push   %eax
80105f1d:	6a 00                	push   $0x0
80105f1f:	6a 00                	push   $0x0
80105f21:	e8 90 fd ff ff       	call   80105cb6 <argfd>
80105f26:	83 c4 10             	add    $0x10,%esp
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	78 17                	js     80105f44 <sys_fstat+0x38>
80105f2d:	83 ec 04             	sub    $0x4,%esp
80105f30:	6a 14                	push   $0x14
80105f32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f35:	50                   	push   %eax
80105f36:	6a 01                	push   $0x1
80105f38:	e8 50 fc ff ff       	call   80105b8d <argptr>
80105f3d:	83 c4 10             	add    $0x10,%esp
80105f40:	85 c0                	test   %eax,%eax
80105f42:	79 07                	jns    80105f4b <sys_fstat+0x3f>
    return -1;
80105f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f49:	eb 13                	jmp    80105f5e <sys_fstat+0x52>
  return filestat(f, st);
80105f4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f51:	83 ec 08             	sub    $0x8,%esp
80105f54:	52                   	push   %edx
80105f55:	50                   	push   %eax
80105f56:	e8 1e b4 ff ff       	call   80101379 <filestat>
80105f5b:	83 c4 10             	add    $0x10,%esp
}
80105f5e:	c9                   	leave  
80105f5f:	c3                   	ret    

80105f60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105f6a:	83 ec 08             	sub    $0x8,%esp
80105f6d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f70:	50                   	push   %eax
80105f71:	6a 00                	push   $0x0
80105f73:	e8 81 fc ff ff       	call   80105bf9 <argstr>
80105f78:	83 c4 10             	add    $0x10,%esp
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	78 15                	js     80105f94 <sys_link+0x34>
80105f7f:	83 ec 08             	sub    $0x8,%esp
80105f82:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f85:	50                   	push   %eax
80105f86:	6a 01                	push   $0x1
80105f88:	e8 6c fc ff ff       	call   80105bf9 <argstr>
80105f8d:	83 c4 10             	add    $0x10,%esp
80105f90:	85 c0                	test   %eax,%eax
80105f92:	79 0a                	jns    80105f9e <sys_link+0x3e>
    return -1;
80105f94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f99:	e9 68 01 00 00       	jmp    80106106 <sys_link+0x1a6>

  begin_op();
80105f9e:	e8 5f d8 ff ff       	call   80103802 <begin_op>
  if((ip = namei(old)) == 0){
80105fa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fa6:	83 ec 0c             	sub    $0xc,%esp
80105fa9:	50                   	push   %eax
80105faa:	e8 c9 c7 ff ff       	call   80102778 <namei>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fb9:	75 0f                	jne    80105fca <sys_link+0x6a>
    end_op();
80105fbb:	e8 d2 d8 ff ff       	call   80103892 <end_op>
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	e9 3c 01 00 00       	jmp    80106106 <sys_link+0x1a6>
  }

  ilock(ip);
80105fca:	83 ec 0c             	sub    $0xc,%esp
80105fcd:	ff 75 f4             	pushl  -0xc(%ebp)
80105fd0:	e8 38 bc ff ff       	call   80101c0d <ilock>
80105fd5:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdb:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105fdf:	66 83 f8 01          	cmp    $0x1,%ax
80105fe3:	75 1d                	jne    80106002 <sys_link+0xa2>
    iunlockput(ip);
80105fe5:	83 ec 0c             	sub    $0xc,%esp
80105fe8:	ff 75 f4             	pushl  -0xc(%ebp)
80105feb:	e8 5a be ff ff       	call   80101e4a <iunlockput>
80105ff0:	83 c4 10             	add    $0x10,%esp
    end_op();
80105ff3:	e8 9a d8 ff ff       	call   80103892 <end_op>
    return -1;
80105ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffd:	e9 04 01 00 00       	jmp    80106106 <sys_link+0x1a6>
  }

  ip->nlink++;
80106002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106005:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106009:	83 c0 01             	add    $0x1,%eax
8010600c:	89 c2                	mov    %eax,%edx
8010600e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106011:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106015:	83 ec 0c             	sub    $0xc,%esp
80106018:	ff 75 f4             	pushl  -0xc(%ebp)
8010601b:	e8 04 ba ff ff       	call   80101a24 <iupdate>
80106020:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106023:	83 ec 0c             	sub    $0xc,%esp
80106026:	ff 75 f4             	pushl  -0xc(%ebp)
80106029:	e8 f6 bc ff ff       	call   80101d24 <iunlock>
8010602e:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106031:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106034:	83 ec 08             	sub    $0x8,%esp
80106037:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010603a:	52                   	push   %edx
8010603b:	50                   	push   %eax
8010603c:	e8 57 c7 ff ff       	call   80102798 <nameiparent>
80106041:	83 c4 10             	add    $0x10,%esp
80106044:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106047:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010604b:	74 71                	je     801060be <sys_link+0x15e>
    goto bad;
  ilock(dp);
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	ff 75 f0             	pushl  -0x10(%ebp)
80106053:	e8 b5 bb ff ff       	call   80101c0d <ilock>
80106058:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010605b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605e:	8b 10                	mov    (%eax),%edx
80106060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106063:	8b 00                	mov    (%eax),%eax
80106065:	39 c2                	cmp    %eax,%edx
80106067:	75 1d                	jne    80106086 <sys_link+0x126>
80106069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606c:	8b 40 04             	mov    0x4(%eax),%eax
8010606f:	83 ec 04             	sub    $0x4,%esp
80106072:	50                   	push   %eax
80106073:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106076:	50                   	push   %eax
80106077:	ff 75 f0             	pushl  -0x10(%ebp)
8010607a:	e8 56 c4 ff ff       	call   801024d5 <dirlink>
8010607f:	83 c4 10             	add    $0x10,%esp
80106082:	85 c0                	test   %eax,%eax
80106084:	79 10                	jns    80106096 <sys_link+0x136>
    iunlockput(dp);
80106086:	83 ec 0c             	sub    $0xc,%esp
80106089:	ff 75 f0             	pushl  -0x10(%ebp)
8010608c:	e8 b9 bd ff ff       	call   80101e4a <iunlockput>
80106091:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106094:	eb 29                	jmp    801060bf <sys_link+0x15f>
  }
  iunlockput(dp);
80106096:	83 ec 0c             	sub    $0xc,%esp
80106099:	ff 75 f0             	pushl  -0x10(%ebp)
8010609c:	e8 a9 bd ff ff       	call   80101e4a <iunlockput>
801060a1:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801060a4:	83 ec 0c             	sub    $0xc,%esp
801060a7:	ff 75 f4             	pushl  -0xc(%ebp)
801060aa:	e8 c7 bc ff ff       	call   80101d76 <iput>
801060af:	83 c4 10             	add    $0x10,%esp

  end_op();
801060b2:	e8 db d7 ff ff       	call   80103892 <end_op>

  return 0;
801060b7:	b8 00 00 00 00       	mov    $0x0,%eax
801060bc:	eb 48                	jmp    80106106 <sys_link+0x1a6>
    goto bad;
801060be:	90                   	nop

bad:
  ilock(ip);
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	ff 75 f4             	pushl  -0xc(%ebp)
801060c5:	e8 43 bb ff ff       	call   80101c0d <ilock>
801060ca:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
801060cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d0:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801060d4:	83 e8 01             	sub    $0x1,%eax
801060d7:	89 c2                	mov    %eax,%edx
801060d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060dc:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	ff 75 f4             	pushl  -0xc(%ebp)
801060e6:	e8 39 b9 ff ff       	call   80101a24 <iupdate>
801060eb:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801060ee:	83 ec 0c             	sub    $0xc,%esp
801060f1:	ff 75 f4             	pushl  -0xc(%ebp)
801060f4:	e8 51 bd ff ff       	call   80101e4a <iunlockput>
801060f9:	83 c4 10             	add    $0x10,%esp
  end_op();
801060fc:	e8 91 d7 ff ff       	call   80103892 <end_op>
  return -1;
80106101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106106:	c9                   	leave  
80106107:	c3                   	ret    

80106108 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106108:	f3 0f 1e fb          	endbr32 
8010610c:	55                   	push   %ebp
8010610d:	89 e5                	mov    %esp,%ebp
8010610f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106112:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106119:	eb 40                	jmp    8010615b <isdirempty+0x53>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010611b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611e:	6a 10                	push   $0x10
80106120:	50                   	push   %eax
80106121:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106124:	50                   	push   %eax
80106125:	ff 75 08             	pushl  0x8(%ebp)
80106128:	e8 e8 bf ff ff       	call   80102115 <readi>
8010612d:	83 c4 10             	add    $0x10,%esp
80106130:	83 f8 10             	cmp    $0x10,%eax
80106133:	74 0d                	je     80106142 <isdirempty+0x3a>
      panic("isdirempty: readi");
80106135:	83 ec 0c             	sub    $0xc,%esp
80106138:	68 50 9a 10 80       	push   $0x80109a50
8010613d:	e8 c6 a4 ff ff       	call   80100608 <panic>
    if(de.inum != 0)
80106142:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106146:	66 85 c0             	test   %ax,%ax
80106149:	74 07                	je     80106152 <isdirempty+0x4a>
      return 0;
8010614b:	b8 00 00 00 00       	mov    $0x0,%eax
80106150:	eb 1b                	jmp    8010616d <isdirempty+0x65>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106155:	83 c0 10             	add    $0x10,%eax
80106158:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010615b:	8b 45 08             	mov    0x8(%ebp),%eax
8010615e:	8b 50 58             	mov    0x58(%eax),%edx
80106161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106164:	39 c2                	cmp    %eax,%edx
80106166:	77 b3                	ja     8010611b <isdirempty+0x13>
  }
  return 1;
80106168:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010616d:	c9                   	leave  
8010616e:	c3                   	ret    

8010616f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010616f:	f3 0f 1e fb          	endbr32 
80106173:	55                   	push   %ebp
80106174:	89 e5                	mov    %esp,%ebp
80106176:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106179:	83 ec 08             	sub    $0x8,%esp
8010617c:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010617f:	50                   	push   %eax
80106180:	6a 00                	push   $0x0
80106182:	e8 72 fa ff ff       	call   80105bf9 <argstr>
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	85 c0                	test   %eax,%eax
8010618c:	79 0a                	jns    80106198 <sys_unlink+0x29>
    return -1;
8010618e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106193:	e9 bf 01 00 00       	jmp    80106357 <sys_unlink+0x1e8>

  begin_op();
80106198:	e8 65 d6 ff ff       	call   80103802 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010619d:	8b 45 cc             	mov    -0x34(%ebp),%eax
801061a0:	83 ec 08             	sub    $0x8,%esp
801061a3:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801061a6:	52                   	push   %edx
801061a7:	50                   	push   %eax
801061a8:	e8 eb c5 ff ff       	call   80102798 <nameiparent>
801061ad:	83 c4 10             	add    $0x10,%esp
801061b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061b7:	75 0f                	jne    801061c8 <sys_unlink+0x59>
    end_op();
801061b9:	e8 d4 d6 ff ff       	call   80103892 <end_op>
    return -1;
801061be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c3:	e9 8f 01 00 00       	jmp    80106357 <sys_unlink+0x1e8>
  }

  ilock(dp);
801061c8:	83 ec 0c             	sub    $0xc,%esp
801061cb:	ff 75 f4             	pushl  -0xc(%ebp)
801061ce:	e8 3a ba ff ff       	call   80101c0d <ilock>
801061d3:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801061d6:	83 ec 08             	sub    $0x8,%esp
801061d9:	68 62 9a 10 80       	push   $0x80109a62
801061de:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061e1:	50                   	push   %eax
801061e2:	e8 11 c2 ff ff       	call   801023f8 <namecmp>
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	85 c0                	test   %eax,%eax
801061ec:	0f 84 49 01 00 00    	je     8010633b <sys_unlink+0x1cc>
801061f2:	83 ec 08             	sub    $0x8,%esp
801061f5:	68 64 9a 10 80       	push   $0x80109a64
801061fa:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801061fd:	50                   	push   %eax
801061fe:	e8 f5 c1 ff ff       	call   801023f8 <namecmp>
80106203:	83 c4 10             	add    $0x10,%esp
80106206:	85 c0                	test   %eax,%eax
80106208:	0f 84 2d 01 00 00    	je     8010633b <sys_unlink+0x1cc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010620e:	83 ec 04             	sub    $0x4,%esp
80106211:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106214:	50                   	push   %eax
80106215:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106218:	50                   	push   %eax
80106219:	ff 75 f4             	pushl  -0xc(%ebp)
8010621c:	e8 f6 c1 ff ff       	call   80102417 <dirlookup>
80106221:	83 c4 10             	add    $0x10,%esp
80106224:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106227:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010622b:	0f 84 0d 01 00 00    	je     8010633e <sys_unlink+0x1cf>
    goto bad;
  ilock(ip);
80106231:	83 ec 0c             	sub    $0xc,%esp
80106234:	ff 75 f0             	pushl  -0x10(%ebp)
80106237:	e8 d1 b9 ff ff       	call   80101c0d <ilock>
8010623c:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010623f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106242:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106246:	66 85 c0             	test   %ax,%ax
80106249:	7f 0d                	jg     80106258 <sys_unlink+0xe9>
    panic("unlink: nlink < 1");
8010624b:	83 ec 0c             	sub    $0xc,%esp
8010624e:	68 67 9a 10 80       	push   $0x80109a67
80106253:	e8 b0 a3 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010625f:	66 83 f8 01          	cmp    $0x1,%ax
80106263:	75 25                	jne    8010628a <sys_unlink+0x11b>
80106265:	83 ec 0c             	sub    $0xc,%esp
80106268:	ff 75 f0             	pushl  -0x10(%ebp)
8010626b:	e8 98 fe ff ff       	call   80106108 <isdirempty>
80106270:	83 c4 10             	add    $0x10,%esp
80106273:	85 c0                	test   %eax,%eax
80106275:	75 13                	jne    8010628a <sys_unlink+0x11b>
    iunlockput(ip);
80106277:	83 ec 0c             	sub    $0xc,%esp
8010627a:	ff 75 f0             	pushl  -0x10(%ebp)
8010627d:	e8 c8 bb ff ff       	call   80101e4a <iunlockput>
80106282:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106285:	e9 b5 00 00 00       	jmp    8010633f <sys_unlink+0x1d0>
  }

  memset(&de, 0, sizeof(de));
8010628a:	83 ec 04             	sub    $0x4,%esp
8010628d:	6a 10                	push   $0x10
8010628f:	6a 00                	push   $0x0
80106291:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106294:	50                   	push   %eax
80106295:	e8 6e f5 ff ff       	call   80105808 <memset>
8010629a:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010629d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801062a0:	6a 10                	push   $0x10
801062a2:	50                   	push   %eax
801062a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062a6:	50                   	push   %eax
801062a7:	ff 75 f4             	pushl  -0xc(%ebp)
801062aa:	e8 bf bf ff ff       	call   8010226e <writei>
801062af:	83 c4 10             	add    $0x10,%esp
801062b2:	83 f8 10             	cmp    $0x10,%eax
801062b5:	74 0d                	je     801062c4 <sys_unlink+0x155>
    panic("unlink: writei");
801062b7:	83 ec 0c             	sub    $0xc,%esp
801062ba:	68 79 9a 10 80       	push   $0x80109a79
801062bf:	e8 44 a3 ff ff       	call   80100608 <panic>
  if(ip->type == T_DIR){
801062c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062cb:	66 83 f8 01          	cmp    $0x1,%ax
801062cf:	75 21                	jne    801062f2 <sys_unlink+0x183>
    dp->nlink--;
801062d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d4:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801062d8:	83 e8 01             	sub    $0x1,%eax
801062db:	89 c2                	mov    %eax,%edx
801062dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e0:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801062e4:	83 ec 0c             	sub    $0xc,%esp
801062e7:	ff 75 f4             	pushl  -0xc(%ebp)
801062ea:	e8 35 b7 ff ff       	call   80101a24 <iupdate>
801062ef:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801062f2:	83 ec 0c             	sub    $0xc,%esp
801062f5:	ff 75 f4             	pushl  -0xc(%ebp)
801062f8:	e8 4d bb ff ff       	call   80101e4a <iunlockput>
801062fd:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106300:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106303:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106307:	83 e8 01             	sub    $0x1,%eax
8010630a:	89 c2                	mov    %eax,%edx
8010630c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010630f:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106313:	83 ec 0c             	sub    $0xc,%esp
80106316:	ff 75 f0             	pushl  -0x10(%ebp)
80106319:	e8 06 b7 ff ff       	call   80101a24 <iupdate>
8010631e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106321:	83 ec 0c             	sub    $0xc,%esp
80106324:	ff 75 f0             	pushl  -0x10(%ebp)
80106327:	e8 1e bb ff ff       	call   80101e4a <iunlockput>
8010632c:	83 c4 10             	add    $0x10,%esp

  end_op();
8010632f:	e8 5e d5 ff ff       	call   80103892 <end_op>

  return 0;
80106334:	b8 00 00 00 00       	mov    $0x0,%eax
80106339:	eb 1c                	jmp    80106357 <sys_unlink+0x1e8>
    goto bad;
8010633b:	90                   	nop
8010633c:	eb 01                	jmp    8010633f <sys_unlink+0x1d0>
    goto bad;
8010633e:	90                   	nop

bad:
  iunlockput(dp);
8010633f:	83 ec 0c             	sub    $0xc,%esp
80106342:	ff 75 f4             	pushl  -0xc(%ebp)
80106345:	e8 00 bb ff ff       	call   80101e4a <iunlockput>
8010634a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010634d:	e8 40 d5 ff ff       	call   80103892 <end_op>
  return -1;
80106352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106357:	c9                   	leave  
80106358:	c3                   	ret    

80106359 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106359:	f3 0f 1e fb          	endbr32 
8010635d:	55                   	push   %ebp
8010635e:	89 e5                	mov    %esp,%ebp
80106360:	83 ec 38             	sub    $0x38,%esp
80106363:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106366:	8b 55 10             	mov    0x10(%ebp),%edx
80106369:	8b 45 14             	mov    0x14(%ebp),%eax
8010636c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106370:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106374:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106378:	83 ec 08             	sub    $0x8,%esp
8010637b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010637e:	50                   	push   %eax
8010637f:	ff 75 08             	pushl  0x8(%ebp)
80106382:	e8 11 c4 ff ff       	call   80102798 <nameiparent>
80106387:	83 c4 10             	add    $0x10,%esp
8010638a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010638d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106391:	75 0a                	jne    8010639d <create+0x44>
    return 0;
80106393:	b8 00 00 00 00       	mov    $0x0,%eax
80106398:	e9 8e 01 00 00       	jmp    8010652b <create+0x1d2>
  ilock(dp);
8010639d:	83 ec 0c             	sub    $0xc,%esp
801063a0:	ff 75 f4             	pushl  -0xc(%ebp)
801063a3:	e8 65 b8 ff ff       	call   80101c0d <ilock>
801063a8:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
801063ab:	83 ec 04             	sub    $0x4,%esp
801063ae:	6a 00                	push   $0x0
801063b0:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801063b3:	50                   	push   %eax
801063b4:	ff 75 f4             	pushl  -0xc(%ebp)
801063b7:	e8 5b c0 ff ff       	call   80102417 <dirlookup>
801063bc:	83 c4 10             	add    $0x10,%esp
801063bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063c6:	74 50                	je     80106418 <create+0xbf>
    iunlockput(dp);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ce:	e8 77 ba ff ff       	call   80101e4a <iunlockput>
801063d3:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801063d6:	83 ec 0c             	sub    $0xc,%esp
801063d9:	ff 75 f0             	pushl  -0x10(%ebp)
801063dc:	e8 2c b8 ff ff       	call   80101c0d <ilock>
801063e1:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801063e4:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801063e9:	75 15                	jne    80106400 <create+0xa7>
801063eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ee:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801063f2:	66 83 f8 02          	cmp    $0x2,%ax
801063f6:	75 08                	jne    80106400 <create+0xa7>
      return ip;
801063f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063fb:	e9 2b 01 00 00       	jmp    8010652b <create+0x1d2>
    iunlockput(ip);
80106400:	83 ec 0c             	sub    $0xc,%esp
80106403:	ff 75 f0             	pushl  -0x10(%ebp)
80106406:	e8 3f ba ff ff       	call   80101e4a <iunlockput>
8010640b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010640e:	b8 00 00 00 00       	mov    $0x0,%eax
80106413:	e9 13 01 00 00       	jmp    8010652b <create+0x1d2>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106418:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010641c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641f:	8b 00                	mov    (%eax),%eax
80106421:	83 ec 08             	sub    $0x8,%esp
80106424:	52                   	push   %edx
80106425:	50                   	push   %eax
80106426:	e8 1e b5 ff ff       	call   80101949 <ialloc>
8010642b:	83 c4 10             	add    $0x10,%esp
8010642e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106435:	75 0d                	jne    80106444 <create+0xeb>
    panic("create: ialloc");
80106437:	83 ec 0c             	sub    $0xc,%esp
8010643a:	68 88 9a 10 80       	push   $0x80109a88
8010643f:	e8 c4 a1 ff ff       	call   80100608 <panic>

  ilock(ip);
80106444:	83 ec 0c             	sub    $0xc,%esp
80106447:	ff 75 f0             	pushl  -0x10(%ebp)
8010644a:	e8 be b7 ff ff       	call   80101c0d <ilock>
8010644f:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106455:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106459:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
8010645d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106460:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106464:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80106468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646b:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80106471:	83 ec 0c             	sub    $0xc,%esp
80106474:	ff 75 f0             	pushl  -0x10(%ebp)
80106477:	e8 a8 b5 ff ff       	call   80101a24 <iupdate>
8010647c:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010647f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106484:	75 6a                	jne    801064f0 <create+0x197>
    dp->nlink++;  // for ".."
80106486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106489:	0f b7 40 56          	movzwl 0x56(%eax),%eax
8010648d:	83 c0 01             	add    $0x1,%eax
80106490:	89 c2                	mov    %eax,%edx
80106492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106495:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106499:	83 ec 0c             	sub    $0xc,%esp
8010649c:	ff 75 f4             	pushl  -0xc(%ebp)
8010649f:	e8 80 b5 ff ff       	call   80101a24 <iupdate>
801064a4:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801064a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064aa:	8b 40 04             	mov    0x4(%eax),%eax
801064ad:	83 ec 04             	sub    $0x4,%esp
801064b0:	50                   	push   %eax
801064b1:	68 62 9a 10 80       	push   $0x80109a62
801064b6:	ff 75 f0             	pushl  -0x10(%ebp)
801064b9:	e8 17 c0 ff ff       	call   801024d5 <dirlink>
801064be:	83 c4 10             	add    $0x10,%esp
801064c1:	85 c0                	test   %eax,%eax
801064c3:	78 1e                	js     801064e3 <create+0x18a>
801064c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064c8:	8b 40 04             	mov    0x4(%eax),%eax
801064cb:	83 ec 04             	sub    $0x4,%esp
801064ce:	50                   	push   %eax
801064cf:	68 64 9a 10 80       	push   $0x80109a64
801064d4:	ff 75 f0             	pushl  -0x10(%ebp)
801064d7:	e8 f9 bf ff ff       	call   801024d5 <dirlink>
801064dc:	83 c4 10             	add    $0x10,%esp
801064df:	85 c0                	test   %eax,%eax
801064e1:	79 0d                	jns    801064f0 <create+0x197>
      panic("create dots");
801064e3:	83 ec 0c             	sub    $0xc,%esp
801064e6:	68 97 9a 10 80       	push   $0x80109a97
801064eb:	e8 18 a1 ff ff       	call   80100608 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f3:	8b 40 04             	mov    0x4(%eax),%eax
801064f6:	83 ec 04             	sub    $0x4,%esp
801064f9:	50                   	push   %eax
801064fa:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801064fd:	50                   	push   %eax
801064fe:	ff 75 f4             	pushl  -0xc(%ebp)
80106501:	e8 cf bf ff ff       	call   801024d5 <dirlink>
80106506:	83 c4 10             	add    $0x10,%esp
80106509:	85 c0                	test   %eax,%eax
8010650b:	79 0d                	jns    8010651a <create+0x1c1>
    panic("create: dirlink");
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	68 a3 9a 10 80       	push   $0x80109aa3
80106515:	e8 ee a0 ff ff       	call   80100608 <panic>

  iunlockput(dp);
8010651a:	83 ec 0c             	sub    $0xc,%esp
8010651d:	ff 75 f4             	pushl  -0xc(%ebp)
80106520:	e8 25 b9 ff ff       	call   80101e4a <iunlockput>
80106525:	83 c4 10             	add    $0x10,%esp

  return ip;
80106528:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010652b:	c9                   	leave  
8010652c:	c3                   	ret    

8010652d <sys_open>:

int
sys_open(void)
{
8010652d:	f3 0f 1e fb          	endbr32 
80106531:	55                   	push   %ebp
80106532:	89 e5                	mov    %esp,%ebp
80106534:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106537:	83 ec 08             	sub    $0x8,%esp
8010653a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010653d:	50                   	push   %eax
8010653e:	6a 00                	push   $0x0
80106540:	e8 b4 f6 ff ff       	call   80105bf9 <argstr>
80106545:	83 c4 10             	add    $0x10,%esp
80106548:	85 c0                	test   %eax,%eax
8010654a:	78 15                	js     80106561 <sys_open+0x34>
8010654c:	83 ec 08             	sub    $0x8,%esp
8010654f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106552:	50                   	push   %eax
80106553:	6a 01                	push   $0x1
80106555:	e8 02 f6 ff ff       	call   80105b5c <argint>
8010655a:	83 c4 10             	add    $0x10,%esp
8010655d:	85 c0                	test   %eax,%eax
8010655f:	79 0a                	jns    8010656b <sys_open+0x3e>
    return -1;
80106561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106566:	e9 61 01 00 00       	jmp    801066cc <sys_open+0x19f>

  begin_op();
8010656b:	e8 92 d2 ff ff       	call   80103802 <begin_op>

  if(omode & O_CREATE){
80106570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106573:	25 00 02 00 00       	and    $0x200,%eax
80106578:	85 c0                	test   %eax,%eax
8010657a:	74 2a                	je     801065a6 <sys_open+0x79>
    ip = create(path, T_FILE, 0, 0);
8010657c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010657f:	6a 00                	push   $0x0
80106581:	6a 00                	push   $0x0
80106583:	6a 02                	push   $0x2
80106585:	50                   	push   %eax
80106586:	e8 ce fd ff ff       	call   80106359 <create>
8010658b:	83 c4 10             	add    $0x10,%esp
8010658e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106595:	75 75                	jne    8010660c <sys_open+0xdf>
      end_op();
80106597:	e8 f6 d2 ff ff       	call   80103892 <end_op>
      return -1;
8010659c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065a1:	e9 26 01 00 00       	jmp    801066cc <sys_open+0x19f>
    }
  } else {
    if((ip = namei(path)) == 0){
801065a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801065a9:	83 ec 0c             	sub    $0xc,%esp
801065ac:	50                   	push   %eax
801065ad:	e8 c6 c1 ff ff       	call   80102778 <namei>
801065b2:	83 c4 10             	add    $0x10,%esp
801065b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065bc:	75 0f                	jne    801065cd <sys_open+0xa0>
      end_op();
801065be:	e8 cf d2 ff ff       	call   80103892 <end_op>
      return -1;
801065c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c8:	e9 ff 00 00 00       	jmp    801066cc <sys_open+0x19f>
    }
    ilock(ip);
801065cd:	83 ec 0c             	sub    $0xc,%esp
801065d0:	ff 75 f4             	pushl  -0xc(%ebp)
801065d3:	e8 35 b6 ff ff       	call   80101c0d <ilock>
801065d8:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801065db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065de:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801065e2:	66 83 f8 01          	cmp    $0x1,%ax
801065e6:	75 24                	jne    8010660c <sys_open+0xdf>
801065e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065eb:	85 c0                	test   %eax,%eax
801065ed:	74 1d                	je     8010660c <sys_open+0xdf>
      iunlockput(ip);
801065ef:	83 ec 0c             	sub    $0xc,%esp
801065f2:	ff 75 f4             	pushl  -0xc(%ebp)
801065f5:	e8 50 b8 ff ff       	call   80101e4a <iunlockput>
801065fa:	83 c4 10             	add    $0x10,%esp
      end_op();
801065fd:	e8 90 d2 ff ff       	call   80103892 <end_op>
      return -1;
80106602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106607:	e9 c0 00 00 00       	jmp    801066cc <sys_open+0x19f>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010660c:	e8 b6 ab ff ff       	call   801011c7 <filealloc>
80106611:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106618:	74 17                	je     80106631 <sys_open+0x104>
8010661a:	83 ec 0c             	sub    $0xc,%esp
8010661d:	ff 75 f0             	pushl  -0x10(%ebp)
80106620:	e8 09 f7 ff ff       	call   80105d2e <fdalloc>
80106625:	83 c4 10             	add    $0x10,%esp
80106628:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010662b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010662f:	79 2e                	jns    8010665f <sys_open+0x132>
    if(f)
80106631:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106635:	74 0e                	je     80106645 <sys_open+0x118>
      fileclose(f);
80106637:	83 ec 0c             	sub    $0xc,%esp
8010663a:	ff 75 f0             	pushl  -0x10(%ebp)
8010663d:	e8 4b ac ff ff       	call   8010128d <fileclose>
80106642:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106645:	83 ec 0c             	sub    $0xc,%esp
80106648:	ff 75 f4             	pushl  -0xc(%ebp)
8010664b:	e8 fa b7 ff ff       	call   80101e4a <iunlockput>
80106650:	83 c4 10             	add    $0x10,%esp
    end_op();
80106653:	e8 3a d2 ff ff       	call   80103892 <end_op>
    return -1;
80106658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665d:	eb 6d                	jmp    801066cc <sys_open+0x19f>
  }
  iunlock(ip);
8010665f:	83 ec 0c             	sub    $0xc,%esp
80106662:	ff 75 f4             	pushl  -0xc(%ebp)
80106665:	e8 ba b6 ff ff       	call   80101d24 <iunlock>
8010666a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010666d:	e8 20 d2 ff ff       	call   80103892 <end_op>

  f->type = FD_INODE;
80106672:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106675:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010667b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010667e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106681:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106687:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010668e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106691:	83 e0 01             	and    $0x1,%eax
80106694:	85 c0                	test   %eax,%eax
80106696:	0f 94 c0             	sete   %al
80106699:	89 c2                	mov    %eax,%edx
8010669b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010669e:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801066a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a4:	83 e0 01             	and    $0x1,%eax
801066a7:	85 c0                	test   %eax,%eax
801066a9:	75 0a                	jne    801066b5 <sys_open+0x188>
801066ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066ae:	83 e0 02             	and    $0x2,%eax
801066b1:	85 c0                	test   %eax,%eax
801066b3:	74 07                	je     801066bc <sys_open+0x18f>
801066b5:	b8 01 00 00 00       	mov    $0x1,%eax
801066ba:	eb 05                	jmp    801066c1 <sys_open+0x194>
801066bc:	b8 00 00 00 00       	mov    $0x0,%eax
801066c1:	89 c2                	mov    %eax,%edx
801066c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c6:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801066c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801066cc:	c9                   	leave  
801066cd:	c3                   	ret    

801066ce <sys_mkdir>:

int
sys_mkdir(void)
{
801066ce:	f3 0f 1e fb          	endbr32 
801066d2:	55                   	push   %ebp
801066d3:	89 e5                	mov    %esp,%ebp
801066d5:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066d8:	e8 25 d1 ff ff       	call   80103802 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801066dd:	83 ec 08             	sub    $0x8,%esp
801066e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066e3:	50                   	push   %eax
801066e4:	6a 00                	push   $0x0
801066e6:	e8 0e f5 ff ff       	call   80105bf9 <argstr>
801066eb:	83 c4 10             	add    $0x10,%esp
801066ee:	85 c0                	test   %eax,%eax
801066f0:	78 1b                	js     8010670d <sys_mkdir+0x3f>
801066f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066f5:	6a 00                	push   $0x0
801066f7:	6a 00                	push   $0x0
801066f9:	6a 01                	push   $0x1
801066fb:	50                   	push   %eax
801066fc:	e8 58 fc ff ff       	call   80106359 <create>
80106701:	83 c4 10             	add    $0x10,%esp
80106704:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010670b:	75 0c                	jne    80106719 <sys_mkdir+0x4b>
    end_op();
8010670d:	e8 80 d1 ff ff       	call   80103892 <end_op>
    return -1;
80106712:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106717:	eb 18                	jmp    80106731 <sys_mkdir+0x63>
  }
  iunlockput(ip);
80106719:	83 ec 0c             	sub    $0xc,%esp
8010671c:	ff 75 f4             	pushl  -0xc(%ebp)
8010671f:	e8 26 b7 ff ff       	call   80101e4a <iunlockput>
80106724:	83 c4 10             	add    $0x10,%esp
  end_op();
80106727:	e8 66 d1 ff ff       	call   80103892 <end_op>
  return 0;
8010672c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106731:	c9                   	leave  
80106732:	c3                   	ret    

80106733 <sys_mknod>:

int
sys_mknod(void)
{
80106733:	f3 0f 1e fb          	endbr32 
80106737:	55                   	push   %ebp
80106738:	89 e5                	mov    %esp,%ebp
8010673a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010673d:	e8 c0 d0 ff ff       	call   80103802 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106742:	83 ec 08             	sub    $0x8,%esp
80106745:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106748:	50                   	push   %eax
80106749:	6a 00                	push   $0x0
8010674b:	e8 a9 f4 ff ff       	call   80105bf9 <argstr>
80106750:	83 c4 10             	add    $0x10,%esp
80106753:	85 c0                	test   %eax,%eax
80106755:	78 4f                	js     801067a6 <sys_mknod+0x73>
     argint(1, &major) < 0 ||
80106757:	83 ec 08             	sub    $0x8,%esp
8010675a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010675d:	50                   	push   %eax
8010675e:	6a 01                	push   $0x1
80106760:	e8 f7 f3 ff ff       	call   80105b5c <argint>
80106765:	83 c4 10             	add    $0x10,%esp
  if((argstr(0, &path)) < 0 ||
80106768:	85 c0                	test   %eax,%eax
8010676a:	78 3a                	js     801067a6 <sys_mknod+0x73>
     argint(2, &minor) < 0 ||
8010676c:	83 ec 08             	sub    $0x8,%esp
8010676f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106772:	50                   	push   %eax
80106773:	6a 02                	push   $0x2
80106775:	e8 e2 f3 ff ff       	call   80105b5c <argint>
8010677a:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
8010677d:	85 c0                	test   %eax,%eax
8010677f:	78 25                	js     801067a6 <sys_mknod+0x73>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106781:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106784:	0f bf c8             	movswl %ax,%ecx
80106787:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010678a:	0f bf d0             	movswl %ax,%edx
8010678d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106790:	51                   	push   %ecx
80106791:	52                   	push   %edx
80106792:	6a 03                	push   $0x3
80106794:	50                   	push   %eax
80106795:	e8 bf fb ff ff       	call   80106359 <create>
8010679a:	83 c4 10             	add    $0x10,%esp
8010679d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     argint(2, &minor) < 0 ||
801067a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067a4:	75 0c                	jne    801067b2 <sys_mknod+0x7f>
    end_op();
801067a6:	e8 e7 d0 ff ff       	call   80103892 <end_op>
    return -1;
801067ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b0:	eb 18                	jmp    801067ca <sys_mknod+0x97>
  }
  iunlockput(ip);
801067b2:	83 ec 0c             	sub    $0xc,%esp
801067b5:	ff 75 f4             	pushl  -0xc(%ebp)
801067b8:	e8 8d b6 ff ff       	call   80101e4a <iunlockput>
801067bd:	83 c4 10             	add    $0x10,%esp
  end_op();
801067c0:	e8 cd d0 ff ff       	call   80103892 <end_op>
  return 0;
801067c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067ca:	c9                   	leave  
801067cb:	c3                   	ret    

801067cc <sys_chdir>:

int
sys_chdir(void)
{
801067cc:	f3 0f 1e fb          	endbr32 
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801067d6:	e8 e6 dd ff ff       	call   801045c1 <myproc>
801067db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
801067de:	e8 1f d0 ff ff       	call   80103802 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801067e3:	83 ec 08             	sub    $0x8,%esp
801067e6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801067e9:	50                   	push   %eax
801067ea:	6a 00                	push   $0x0
801067ec:	e8 08 f4 ff ff       	call   80105bf9 <argstr>
801067f1:	83 c4 10             	add    $0x10,%esp
801067f4:	85 c0                	test   %eax,%eax
801067f6:	78 18                	js     80106810 <sys_chdir+0x44>
801067f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801067fb:	83 ec 0c             	sub    $0xc,%esp
801067fe:	50                   	push   %eax
801067ff:	e8 74 bf ff ff       	call   80102778 <namei>
80106804:	83 c4 10             	add    $0x10,%esp
80106807:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010680a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010680e:	75 0c                	jne    8010681c <sys_chdir+0x50>
    end_op();
80106810:	e8 7d d0 ff ff       	call   80103892 <end_op>
    return -1;
80106815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681a:	eb 68                	jmp    80106884 <sys_chdir+0xb8>
  }
  ilock(ip);
8010681c:	83 ec 0c             	sub    $0xc,%esp
8010681f:	ff 75 f0             	pushl  -0x10(%ebp)
80106822:	e8 e6 b3 ff ff       	call   80101c0d <ilock>
80106827:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010682a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010682d:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106831:	66 83 f8 01          	cmp    $0x1,%ax
80106835:	74 1a                	je     80106851 <sys_chdir+0x85>
    iunlockput(ip);
80106837:	83 ec 0c             	sub    $0xc,%esp
8010683a:	ff 75 f0             	pushl  -0x10(%ebp)
8010683d:	e8 08 b6 ff ff       	call   80101e4a <iunlockput>
80106842:	83 c4 10             	add    $0x10,%esp
    end_op();
80106845:	e8 48 d0 ff ff       	call   80103892 <end_op>
    return -1;
8010684a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684f:	eb 33                	jmp    80106884 <sys_chdir+0xb8>
  }
  iunlock(ip);
80106851:	83 ec 0c             	sub    $0xc,%esp
80106854:	ff 75 f0             	pushl  -0x10(%ebp)
80106857:	e8 c8 b4 ff ff       	call   80101d24 <iunlock>
8010685c:	83 c4 10             	add    $0x10,%esp
  iput(curproc->cwd);
8010685f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106862:	8b 40 68             	mov    0x68(%eax),%eax
80106865:	83 ec 0c             	sub    $0xc,%esp
80106868:	50                   	push   %eax
80106869:	e8 08 b5 ff ff       	call   80101d76 <iput>
8010686e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106871:	e8 1c d0 ff ff       	call   80103892 <end_op>
  curproc->cwd = ip;
80106876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106879:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010687c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010687f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    

80106886 <sys_exec>:

int
sys_exec(void)
{
80106886:	f3 0f 1e fb          	endbr32 
8010688a:	55                   	push   %ebp
8010688b:	89 e5                	mov    %esp,%ebp
8010688d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106893:	83 ec 08             	sub    $0x8,%esp
80106896:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106899:	50                   	push   %eax
8010689a:	6a 00                	push   $0x0
8010689c:	e8 58 f3 ff ff       	call   80105bf9 <argstr>
801068a1:	83 c4 10             	add    $0x10,%esp
801068a4:	85 c0                	test   %eax,%eax
801068a6:	78 18                	js     801068c0 <sys_exec+0x3a>
801068a8:	83 ec 08             	sub    $0x8,%esp
801068ab:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801068b1:	50                   	push   %eax
801068b2:	6a 01                	push   $0x1
801068b4:	e8 a3 f2 ff ff       	call   80105b5c <argint>
801068b9:	83 c4 10             	add    $0x10,%esp
801068bc:	85 c0                	test   %eax,%eax
801068be:	79 0a                	jns    801068ca <sys_exec+0x44>
    return -1;
801068c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c5:	e9 c6 00 00 00       	jmp    80106990 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
801068ca:	83 ec 04             	sub    $0x4,%esp
801068cd:	68 80 00 00 00       	push   $0x80
801068d2:	6a 00                	push   $0x0
801068d4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801068da:	50                   	push   %eax
801068db:	e8 28 ef ff ff       	call   80105808 <memset>
801068e0:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801068e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801068ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ed:	83 f8 1f             	cmp    $0x1f,%eax
801068f0:	76 0a                	jbe    801068fc <sys_exec+0x76>
      return -1;
801068f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f7:	e9 94 00 00 00       	jmp    80106990 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801068fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ff:	c1 e0 02             	shl    $0x2,%eax
80106902:	89 c2                	mov    %eax,%edx
80106904:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010690a:	01 c2                	add    %eax,%edx
8010690c:	83 ec 08             	sub    $0x8,%esp
8010690f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106915:	50                   	push   %eax
80106916:	52                   	push   %edx
80106917:	e8 95 f1 ff ff       	call   80105ab1 <fetchint>
8010691c:	83 c4 10             	add    $0x10,%esp
8010691f:	85 c0                	test   %eax,%eax
80106921:	79 07                	jns    8010692a <sys_exec+0xa4>
      return -1;
80106923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106928:	eb 66                	jmp    80106990 <sys_exec+0x10a>
    if(uarg == 0){
8010692a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106930:	85 c0                	test   %eax,%eax
80106932:	75 27                	jne    8010695b <sys_exec+0xd5>
      argv[i] = 0;
80106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106937:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010693e:	00 00 00 00 
      break;
80106942:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106943:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106946:	83 ec 08             	sub    $0x8,%esp
80106949:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010694f:	52                   	push   %edx
80106950:	50                   	push   %eax
80106951:	e8 da a2 ff ff       	call   80100c30 <exec>
80106956:	83 c4 10             	add    $0x10,%esp
80106959:	eb 35                	jmp    80106990 <sys_exec+0x10a>
    if(fetchstr(uarg, &argv[i]) < 0)
8010695b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106961:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106964:	c1 e2 02             	shl    $0x2,%edx
80106967:	01 c2                	add    %eax,%edx
80106969:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010696f:	83 ec 08             	sub    $0x8,%esp
80106972:	52                   	push   %edx
80106973:	50                   	push   %eax
80106974:	e8 7b f1 ff ff       	call   80105af4 <fetchstr>
80106979:	83 c4 10             	add    $0x10,%esp
8010697c:	85 c0                	test   %eax,%eax
8010697e:	79 07                	jns    80106987 <sys_exec+0x101>
      return -1;
80106980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106985:	eb 09                	jmp    80106990 <sys_exec+0x10a>
  for(i=0;; i++){
80106987:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010698b:	e9 5a ff ff ff       	jmp    801068ea <sys_exec+0x64>
}
80106990:	c9                   	leave  
80106991:	c3                   	ret    

80106992 <sys_pipe>:

int
sys_pipe(void)
{
80106992:	f3 0f 1e fb          	endbr32 
80106996:	55                   	push   %ebp
80106997:	89 e5                	mov    %esp,%ebp
80106999:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010699c:	83 ec 04             	sub    $0x4,%esp
8010699f:	6a 08                	push   $0x8
801069a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069a4:	50                   	push   %eax
801069a5:	6a 00                	push   $0x0
801069a7:	e8 e1 f1 ff ff       	call   80105b8d <argptr>
801069ac:	83 c4 10             	add    $0x10,%esp
801069af:	85 c0                	test   %eax,%eax
801069b1:	79 0a                	jns    801069bd <sys_pipe+0x2b>
    return -1;
801069b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069b8:	e9 ae 00 00 00       	jmp    80106a6b <sys_pipe+0xd9>
  if(pipealloc(&rf, &wf) < 0)
801069bd:	83 ec 08             	sub    $0x8,%esp
801069c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069c3:	50                   	push   %eax
801069c4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801069c7:	50                   	push   %eax
801069c8:	e8 15 d7 ff ff       	call   801040e2 <pipealloc>
801069cd:	83 c4 10             	add    $0x10,%esp
801069d0:	85 c0                	test   %eax,%eax
801069d2:	79 0a                	jns    801069de <sys_pipe+0x4c>
    return -1;
801069d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d9:	e9 8d 00 00 00       	jmp    80106a6b <sys_pipe+0xd9>
  fd0 = -1;
801069de:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801069e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801069e8:	83 ec 0c             	sub    $0xc,%esp
801069eb:	50                   	push   %eax
801069ec:	e8 3d f3 ff ff       	call   80105d2e <fdalloc>
801069f1:	83 c4 10             	add    $0x10,%esp
801069f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069fb:	78 18                	js     80106a15 <sys_pipe+0x83>
801069fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a00:	83 ec 0c             	sub    $0xc,%esp
80106a03:	50                   	push   %eax
80106a04:	e8 25 f3 ff ff       	call   80105d2e <fdalloc>
80106a09:	83 c4 10             	add    $0x10,%esp
80106a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a13:	79 3e                	jns    80106a53 <sys_pipe+0xc1>
    if(fd0 >= 0)
80106a15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a19:	78 13                	js     80106a2e <sys_pipe+0x9c>
      myproc()->ofile[fd0] = 0;
80106a1b:	e8 a1 db ff ff       	call   801045c1 <myproc>
80106a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a23:	83 c2 08             	add    $0x8,%edx
80106a26:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a2d:	00 
    fileclose(rf);
80106a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106a31:	83 ec 0c             	sub    $0xc,%esp
80106a34:	50                   	push   %eax
80106a35:	e8 53 a8 ff ff       	call   8010128d <fileclose>
80106a3a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106a3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a40:	83 ec 0c             	sub    $0xc,%esp
80106a43:	50                   	push   %eax
80106a44:	e8 44 a8 ff ff       	call   8010128d <fileclose>
80106a49:	83 c4 10             	add    $0x10,%esp
    return -1;
80106a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a51:	eb 18                	jmp    80106a6b <sys_pipe+0xd9>
  }
  fd[0] = fd0;
80106a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a59:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a5e:	8d 50 04             	lea    0x4(%eax),%edx
80106a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a64:	89 02                	mov    %eax,(%edx)
  return 0;
80106a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a6b:	c9                   	leave  
80106a6c:	c3                   	ret    

80106a6d <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106a6d:	f3 0f 1e fb          	endbr32 
80106a71:	55                   	push   %ebp
80106a72:	89 e5                	mov    %esp,%ebp
80106a74:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106a77:	e8 aa df ff ff       	call   80104a26 <fork>
}
80106a7c:	c9                   	leave  
80106a7d:	c3                   	ret    

80106a7e <sys_exit>:

int
sys_exit(void)
{
80106a7e:	f3 0f 1e fb          	endbr32 
80106a82:	55                   	push   %ebp
80106a83:	89 e5                	mov    %esp,%ebp
80106a85:	83 ec 08             	sub    $0x8,%esp
  exit();
80106a88:	e8 18 e2 ff ff       	call   80104ca5 <exit>
  return 0;  // not reached
80106a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a92:	c9                   	leave  
80106a93:	c3                   	ret    

80106a94 <sys_wait>:

int
sys_wait(void)
{
80106a94:	f3 0f 1e fb          	endbr32 
80106a98:	55                   	push   %ebp
80106a99:	89 e5                	mov    %esp,%ebp
80106a9b:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106a9e:	e8 29 e3 ff ff       	call   80104dcc <wait>
}
80106aa3:	c9                   	leave  
80106aa4:	c3                   	ret    

80106aa5 <sys_kill>:

int
sys_kill(void)
{
80106aa5:	f3 0f 1e fb          	endbr32 
80106aa9:	55                   	push   %ebp
80106aaa:	89 e5                	mov    %esp,%ebp
80106aac:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106aaf:	83 ec 08             	sub    $0x8,%esp
80106ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ab5:	50                   	push   %eax
80106ab6:	6a 00                	push   $0x0
80106ab8:	e8 9f f0 ff ff       	call   80105b5c <argint>
80106abd:	83 c4 10             	add    $0x10,%esp
80106ac0:	85 c0                	test   %eax,%eax
80106ac2:	79 07                	jns    80106acb <sys_kill+0x26>
    return -1;
80106ac4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ac9:	eb 0f                	jmp    80106ada <sys_kill+0x35>
  return kill(pid);
80106acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ace:	83 ec 0c             	sub    $0xc,%esp
80106ad1:	50                   	push   %eax
80106ad2:	e8 4d e7 ff ff       	call   80105224 <kill>
80106ad7:	83 c4 10             	add    $0x10,%esp
}
80106ada:	c9                   	leave  
80106adb:	c3                   	ret    

80106adc <sys_getpid>:

int
sys_getpid(void)
{
80106adc:	f3 0f 1e fb          	endbr32 
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106ae6:	e8 d6 da ff ff       	call   801045c1 <myproc>
80106aeb:	8b 40 10             	mov    0x10(%eax),%eax
}
80106aee:	c9                   	leave  
80106aef:	c3                   	ret    

80106af0 <sys_sbrk>:

int
sys_sbrk(void)
{
80106af0:	f3 0f 1e fb          	endbr32 
80106af4:	55                   	push   %ebp
80106af5:	89 e5                	mov    %esp,%ebp
80106af7:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106afa:	83 ec 08             	sub    $0x8,%esp
80106afd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b00:	50                   	push   %eax
80106b01:	6a 00                	push   $0x0
80106b03:	e8 54 f0 ff ff       	call   80105b5c <argint>
80106b08:	83 c4 10             	add    $0x10,%esp
80106b0b:	85 c0                	test   %eax,%eax
80106b0d:	79 07                	jns    80106b16 <sys_sbrk+0x26>
    return -1;
80106b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b14:	eb 27                	jmp    80106b3d <sys_sbrk+0x4d>
  addr = myproc()->sz;
80106b16:	e8 a6 da ff ff       	call   801045c1 <myproc>
80106b1b:	8b 00                	mov    (%eax),%eax
80106b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b23:	83 ec 0c             	sub    $0xc,%esp
80106b26:	50                   	push   %eax
80106b27:	e8 0c dd ff ff       	call   80104838 <growproc>
80106b2c:	83 c4 10             	add    $0x10,%esp
80106b2f:	85 c0                	test   %eax,%eax
80106b31:	79 07                	jns    80106b3a <sys_sbrk+0x4a>
    return -1;
80106b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b38:	eb 03                	jmp    80106b3d <sys_sbrk+0x4d>
  return addr;
80106b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b3d:	c9                   	leave  
80106b3e:	c3                   	ret    

80106b3f <sys_sleep>:

int
sys_sleep(void)
{
80106b3f:	f3 0f 1e fb          	endbr32 
80106b43:	55                   	push   %ebp
80106b44:	89 e5                	mov    %esp,%ebp
80106b46:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106b49:	83 ec 08             	sub    $0x8,%esp
80106b4c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b4f:	50                   	push   %eax
80106b50:	6a 00                	push   $0x0
80106b52:	e8 05 f0 ff ff       	call   80105b5c <argint>
80106b57:	83 c4 10             	add    $0x10,%esp
80106b5a:	85 c0                	test   %eax,%eax
80106b5c:	79 07                	jns    80106b65 <sys_sleep+0x26>
    return -1;
80106b5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b63:	eb 76                	jmp    80106bdb <sys_sleep+0x9c>
  acquire(&tickslock);
80106b65:	83 ec 0c             	sub    $0xc,%esp
80106b68:	68 00 9f 11 80       	push   $0x80119f00
80106b6d:	e8 f7 e9 ff ff       	call   80105569 <acquire>
80106b72:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106b75:	a1 40 a7 11 80       	mov    0x8011a740,%eax
80106b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106b7d:	eb 38                	jmp    80106bb7 <sys_sleep+0x78>
    if(myproc()->killed){
80106b7f:	e8 3d da ff ff       	call   801045c1 <myproc>
80106b84:	8b 40 24             	mov    0x24(%eax),%eax
80106b87:	85 c0                	test   %eax,%eax
80106b89:	74 17                	je     80106ba2 <sys_sleep+0x63>
      release(&tickslock);
80106b8b:	83 ec 0c             	sub    $0xc,%esp
80106b8e:	68 00 9f 11 80       	push   $0x80119f00
80106b93:	e8 43 ea ff ff       	call   801055db <release>
80106b98:	83 c4 10             	add    $0x10,%esp
      return -1;
80106b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba0:	eb 39                	jmp    80106bdb <sys_sleep+0x9c>
    }
    sleep(&ticks, &tickslock);
80106ba2:	83 ec 08             	sub    $0x8,%esp
80106ba5:	68 00 9f 11 80       	push   $0x80119f00
80106baa:	68 40 a7 11 80       	push   $0x8011a740
80106baf:	e8 43 e5 ff ff       	call   801050f7 <sleep>
80106bb4:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106bb7:	a1 40 a7 11 80       	mov    0x8011a740,%eax
80106bbc:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106bbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bc2:	39 d0                	cmp    %edx,%eax
80106bc4:	72 b9                	jb     80106b7f <sys_sleep+0x40>
  }
  release(&tickslock);
80106bc6:	83 ec 0c             	sub    $0xc,%esp
80106bc9:	68 00 9f 11 80       	push   $0x80119f00
80106bce:	e8 08 ea ff ff       	call   801055db <release>
80106bd3:	83 c4 10             	add    $0x10,%esp
  return 0;
80106bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bdb:	c9                   	leave  
80106bdc:	c3                   	ret    

80106bdd <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106bdd:	f3 0f 1e fb          	endbr32 
80106be1:	55                   	push   %ebp
80106be2:	89 e5                	mov    %esp,%ebp
80106be4:	83 ec 18             	sub    $0x18,%esp
  uint xticks;

  acquire(&tickslock);
80106be7:	83 ec 0c             	sub    $0xc,%esp
80106bea:	68 00 9f 11 80       	push   $0x80119f00
80106bef:	e8 75 e9 ff ff       	call   80105569 <acquire>
80106bf4:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106bf7:	a1 40 a7 11 80       	mov    0x8011a740,%eax
80106bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106bff:	83 ec 0c             	sub    $0xc,%esp
80106c02:	68 00 9f 11 80       	push   $0x80119f00
80106c07:	e8 cf e9 ff ff       	call   801055db <release>
80106c0c:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c12:	c9                   	leave  
80106c13:	c3                   	ret    

80106c14 <sys_mencrypt>:

//changed: added wrapper here
int sys_mencrypt(void) {
80106c14:	f3 0f 1e fb          	endbr32 
80106c18:	55                   	push   %ebp
80106c19:	89 e5                	mov    %esp,%ebp
80106c1b:	83 ec 18             	sub    $0x18,%esp
  int len;
  char * virtual_addr;

  if(argint(1, &len) < 0)
80106c1e:	83 ec 08             	sub    $0x8,%esp
80106c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c24:	50                   	push   %eax
80106c25:	6a 01                	push   $0x1
80106c27:	e8 30 ef ff ff       	call   80105b5c <argint>
80106c2c:	83 c4 10             	add    $0x10,%esp
80106c2f:	85 c0                	test   %eax,%eax
80106c31:	79 07                	jns    80106c3a <sys_mencrypt+0x26>
    return -1;
80106c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c38:	eb 50                	jmp    80106c8a <sys_mencrypt+0x76>
  if (len <= 0) {
80106c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c3d:	85 c0                	test   %eax,%eax
80106c3f:	7f 07                	jg     80106c48 <sys_mencrypt+0x34>
    return -1;
80106c41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c46:	eb 42                	jmp    80106c8a <sys_mencrypt+0x76>
  }
  if(argptr(0, &virtual_addr, 1) < 0)
80106c48:	83 ec 04             	sub    $0x4,%esp
80106c4b:	6a 01                	push   $0x1
80106c4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c50:	50                   	push   %eax
80106c51:	6a 00                	push   $0x0
80106c53:	e8 35 ef ff ff       	call   80105b8d <argptr>
80106c58:	83 c4 10             	add    $0x10,%esp
80106c5b:	85 c0                	test   %eax,%eax
80106c5d:	79 07                	jns    80106c66 <sys_mencrypt+0x52>
    return -1;
80106c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c64:	eb 24                	jmp    80106c8a <sys_mencrypt+0x76>
  if ((void *) virtual_addr >= P2V(PHYSTOP)) {
80106c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c69:	3d ff ff ff 8d       	cmp    $0x8dffffff,%eax
80106c6e:	76 07                	jbe    80106c77 <sys_mencrypt+0x63>
    return -1;
80106c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c75:	eb 13                	jmp    80106c8a <sys_mencrypt+0x76>
  }
  return mencrypt(virtual_addr, len);
80106c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c7d:	83 ec 08             	sub    $0x8,%esp
80106c80:	52                   	push   %edx
80106c81:	50                   	push   %eax
80106c82:	e8 e6 23 00 00       	call   8010906d <mencrypt>
80106c87:	83 c4 10             	add    $0x10,%esp
}
80106c8a:	c9                   	leave  
80106c8b:	c3                   	ret    

80106c8c <sys_getpgtable>:

int sys_getpgtable(void) {
80106c8c:	f3 0f 1e fb          	endbr32 
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 18             	sub    $0x18,%esp
  struct pt_entry * entries; 
  int num;
  int wsetOnly;

  if(argint(2, &wsetOnly) < 0)
80106c96:	83 ec 08             	sub    $0x8,%esp
80106c99:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106c9c:	50                   	push   %eax
80106c9d:	6a 02                	push   $0x2
80106c9f:	e8 b8 ee ff ff       	call   80105b5c <argint>
80106ca4:	83 c4 10             	add    $0x10,%esp
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	79 07                	jns    80106cb2 <sys_getpgtable+0x26>
    return -1;
80106cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb0:	eb 56                	jmp    80106d08 <sys_getpgtable+0x7c>
  if(argint(1, &num) < 0)
80106cb2:	83 ec 08             	sub    $0x8,%esp
80106cb5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cb8:	50                   	push   %eax
80106cb9:	6a 01                	push   $0x1
80106cbb:	e8 9c ee ff ff       	call   80105b5c <argint>
80106cc0:	83 c4 10             	add    $0x10,%esp
80106cc3:	85 c0                	test   %eax,%eax
80106cc5:	79 07                	jns    80106cce <sys_getpgtable+0x42>
    return -1;
80106cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ccc:	eb 3a                	jmp    80106d08 <sys_getpgtable+0x7c>
  if(argptr(0, (char**)&entries, num*sizeof(struct pt_entry)) < 0){
80106cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cd1:	c1 e0 03             	shl    $0x3,%eax
80106cd4:	83 ec 04             	sub    $0x4,%esp
80106cd7:	50                   	push   %eax
80106cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cdb:	50                   	push   %eax
80106cdc:	6a 00                	push   $0x0
80106cde:	e8 aa ee ff ff       	call   80105b8d <argptr>
80106ce3:	83 c4 10             	add    $0x10,%esp
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	79 07                	jns    80106cf1 <sys_getpgtable+0x65>
    return -1;
80106cea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cef:	eb 17                	jmp    80106d08 <sys_getpgtable+0x7c>
  }
  return getpgtable(entries, num, wsetOnly);
80106cf1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106cf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfa:	83 ec 04             	sub    $0x4,%esp
80106cfd:	51                   	push   %ecx
80106cfe:	52                   	push   %edx
80106cff:	50                   	push   %eax
80106d00:	e8 9e 25 00 00       	call   801092a3 <getpgtable>
80106d05:	83 c4 10             	add    $0x10,%esp
}
80106d08:	c9                   	leave  
80106d09:	c3                   	ret    

80106d0a <sys_dump_rawphymem>:


int sys_dump_rawphymem(void) {
80106d0a:	f3 0f 1e fb          	endbr32 
80106d0e:	55                   	push   %ebp
80106d0f:	89 e5                	mov    %esp,%ebp
80106d11:	83 ec 18             	sub    $0x18,%esp
  char * physical_addr; 
  char * buffer;

  if(argptr(1, &buffer, PGSIZE) < 0)
80106d14:	83 ec 04             	sub    $0x4,%esp
80106d17:	68 00 10 00 00       	push   $0x1000
80106d1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d1f:	50                   	push   %eax
80106d20:	6a 01                	push   $0x1
80106d22:	e8 66 ee ff ff       	call   80105b8d <argptr>
80106d27:	83 c4 10             	add    $0x10,%esp
80106d2a:	85 c0                	test   %eax,%eax
80106d2c:	79 07                	jns    80106d35 <sys_dump_rawphymem+0x2b>
    return -1;
80106d2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d33:	eb 2f                	jmp    80106d64 <sys_dump_rawphymem+0x5a>
  if(argint(0, (int*)&physical_addr) < 0)
80106d35:	83 ec 08             	sub    $0x8,%esp
80106d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d3b:	50                   	push   %eax
80106d3c:	6a 00                	push   $0x0
80106d3e:	e8 19 ee ff ff       	call   80105b5c <argint>
80106d43:	83 c4 10             	add    $0x10,%esp
80106d46:	85 c0                	test   %eax,%eax
80106d48:	79 07                	jns    80106d51 <sys_dump_rawphymem+0x47>
    return -1;
80106d4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d4f:	eb 13                	jmp    80106d64 <sys_dump_rawphymem+0x5a>
  return dump_rawphymem(physical_addr, buffer);
80106d51:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d57:	83 ec 08             	sub    $0x8,%esp
80106d5a:	52                   	push   %edx
80106d5b:	50                   	push   %eax
80106d5c:	e8 81 27 00 00       	call   801094e2 <dump_rawphymem>
80106d61:	83 c4 10             	add    $0x10,%esp
80106d64:	c9                   	leave  
80106d65:	c3                   	ret    

80106d66 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106d66:	1e                   	push   %ds
  pushl %es
80106d67:	06                   	push   %es
  pushl %fs
80106d68:	0f a0                	push   %fs
  pushl %gs
80106d6a:	0f a8                	push   %gs
  pushal
80106d6c:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106d6d:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106d71:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106d73:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106d75:	54                   	push   %esp
  call trap
80106d76:	e8 df 01 00 00       	call   80106f5a <trap>
  addl $4, %esp
80106d7b:	83 c4 04             	add    $0x4,%esp

80106d7e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106d7e:	61                   	popa   
  popl %gs
80106d7f:	0f a9                	pop    %gs
  popl %fs
80106d81:	0f a1                	pop    %fs
  popl %es
80106d83:	07                   	pop    %es
  popl %ds
80106d84:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106d85:	83 c4 08             	add    $0x8,%esp
  iret
80106d88:	cf                   	iret   

80106d89 <lidt>:
{
80106d89:	55                   	push   %ebp
80106d8a:	89 e5                	mov    %esp,%ebp
80106d8c:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d92:	83 e8 01             	sub    $0x1,%eax
80106d95:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106d99:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106da0:	8b 45 08             	mov    0x8(%ebp),%eax
80106da3:	c1 e8 10             	shr    $0x10,%eax
80106da6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106daa:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106dad:	0f 01 18             	lidtl  (%eax)
}
80106db0:	90                   	nop
80106db1:	c9                   	leave  
80106db2:	c3                   	ret    

80106db3 <rcr2>:

static inline uint
rcr2(void)
{
80106db3:	55                   	push   %ebp
80106db4:	89 e5                	mov    %esp,%ebp
80106db6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106db9:	0f 20 d0             	mov    %cr2,%eax
80106dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106dc2:	c9                   	leave  
80106dc3:	c3                   	ret    

80106dc4 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106dc4:	f3 0f 1e fb          	endbr32 
80106dc8:	55                   	push   %ebp
80106dc9:	89 e5                	mov    %esp,%ebp
80106dcb:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106dce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106dd5:	e9 c3 00 00 00       	jmp    80106e9d <tvinit+0xd9>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ddd:	8b 04 85 84 d0 10 80 	mov    -0x7fef2f7c(,%eax,4),%eax
80106de4:	89 c2                	mov    %eax,%edx
80106de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106de9:	66 89 14 c5 40 9f 11 	mov    %dx,-0x7fee60c0(,%eax,8)
80106df0:	80 
80106df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df4:	66 c7 04 c5 42 9f 11 	movw   $0x8,-0x7fee60be(,%eax,8)
80106dfb:	80 08 00 
80106dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e01:	0f b6 14 c5 44 9f 11 	movzbl -0x7fee60bc(,%eax,8),%edx
80106e08:	80 
80106e09:	83 e2 e0             	and    $0xffffffe0,%edx
80106e0c:	88 14 c5 44 9f 11 80 	mov    %dl,-0x7fee60bc(,%eax,8)
80106e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e16:	0f b6 14 c5 44 9f 11 	movzbl -0x7fee60bc(,%eax,8),%edx
80106e1d:	80 
80106e1e:	83 e2 1f             	and    $0x1f,%edx
80106e21:	88 14 c5 44 9f 11 80 	mov    %dl,-0x7fee60bc(,%eax,8)
80106e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e2b:	0f b6 14 c5 45 9f 11 	movzbl -0x7fee60bb(,%eax,8),%edx
80106e32:	80 
80106e33:	83 e2 f0             	and    $0xfffffff0,%edx
80106e36:	83 ca 0e             	or     $0xe,%edx
80106e39:	88 14 c5 45 9f 11 80 	mov    %dl,-0x7fee60bb(,%eax,8)
80106e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e43:	0f b6 14 c5 45 9f 11 	movzbl -0x7fee60bb(,%eax,8),%edx
80106e4a:	80 
80106e4b:	83 e2 ef             	and    $0xffffffef,%edx
80106e4e:	88 14 c5 45 9f 11 80 	mov    %dl,-0x7fee60bb(,%eax,8)
80106e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e58:	0f b6 14 c5 45 9f 11 	movzbl -0x7fee60bb(,%eax,8),%edx
80106e5f:	80 
80106e60:	83 e2 9f             	and    $0xffffff9f,%edx
80106e63:	88 14 c5 45 9f 11 80 	mov    %dl,-0x7fee60bb(,%eax,8)
80106e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6d:	0f b6 14 c5 45 9f 11 	movzbl -0x7fee60bb(,%eax,8),%edx
80106e74:	80 
80106e75:	83 ca 80             	or     $0xffffff80,%edx
80106e78:	88 14 c5 45 9f 11 80 	mov    %dl,-0x7fee60bb(,%eax,8)
80106e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e82:	8b 04 85 84 d0 10 80 	mov    -0x7fef2f7c(,%eax,4),%eax
80106e89:	c1 e8 10             	shr    $0x10,%eax
80106e8c:	89 c2                	mov    %eax,%edx
80106e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e91:	66 89 14 c5 46 9f 11 	mov    %dx,-0x7fee60ba(,%eax,8)
80106e98:	80 
  for(i = 0; i < 256; i++)
80106e99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e9d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106ea4:	0f 8e 30 ff ff ff    	jle    80106dda <tvinit+0x16>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106eaa:	a1 84 d1 10 80       	mov    0x8010d184,%eax
80106eaf:	66 a3 40 a1 11 80    	mov    %ax,0x8011a140
80106eb5:	66 c7 05 42 a1 11 80 	movw   $0x8,0x8011a142
80106ebc:	08 00 
80106ebe:	0f b6 05 44 a1 11 80 	movzbl 0x8011a144,%eax
80106ec5:	83 e0 e0             	and    $0xffffffe0,%eax
80106ec8:	a2 44 a1 11 80       	mov    %al,0x8011a144
80106ecd:	0f b6 05 44 a1 11 80 	movzbl 0x8011a144,%eax
80106ed4:	83 e0 1f             	and    $0x1f,%eax
80106ed7:	a2 44 a1 11 80       	mov    %al,0x8011a144
80106edc:	0f b6 05 45 a1 11 80 	movzbl 0x8011a145,%eax
80106ee3:	83 c8 0f             	or     $0xf,%eax
80106ee6:	a2 45 a1 11 80       	mov    %al,0x8011a145
80106eeb:	0f b6 05 45 a1 11 80 	movzbl 0x8011a145,%eax
80106ef2:	83 e0 ef             	and    $0xffffffef,%eax
80106ef5:	a2 45 a1 11 80       	mov    %al,0x8011a145
80106efa:	0f b6 05 45 a1 11 80 	movzbl 0x8011a145,%eax
80106f01:	83 c8 60             	or     $0x60,%eax
80106f04:	a2 45 a1 11 80       	mov    %al,0x8011a145
80106f09:	0f b6 05 45 a1 11 80 	movzbl 0x8011a145,%eax
80106f10:	83 c8 80             	or     $0xffffff80,%eax
80106f13:	a2 45 a1 11 80       	mov    %al,0x8011a145
80106f18:	a1 84 d1 10 80       	mov    0x8010d184,%eax
80106f1d:	c1 e8 10             	shr    $0x10,%eax
80106f20:	66 a3 46 a1 11 80    	mov    %ax,0x8011a146

  initlock(&tickslock, "time");
80106f26:	83 ec 08             	sub    $0x8,%esp
80106f29:	68 b4 9a 10 80       	push   $0x80109ab4
80106f2e:	68 00 9f 11 80       	push   $0x80119f00
80106f33:	e8 0b e6 ff ff       	call   80105543 <initlock>
80106f38:	83 c4 10             	add    $0x10,%esp
}
80106f3b:	90                   	nop
80106f3c:	c9                   	leave  
80106f3d:	c3                   	ret    

80106f3e <idtinit>:

void
idtinit(void)
{
80106f3e:	f3 0f 1e fb          	endbr32 
80106f42:	55                   	push   %ebp
80106f43:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106f45:	68 00 08 00 00       	push   $0x800
80106f4a:	68 40 9f 11 80       	push   $0x80119f40
80106f4f:	e8 35 fe ff ff       	call   80106d89 <lidt>
80106f54:	83 c4 08             	add    $0x8,%esp
}
80106f57:	90                   	nop
80106f58:	c9                   	leave  
80106f59:	c3                   	ret    

80106f5a <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106f5a:	f3 0f 1e fb          	endbr32 
80106f5e:	55                   	push   %ebp
80106f5f:	89 e5                	mov    %esp,%ebp
80106f61:	57                   	push   %edi
80106f62:	56                   	push   %esi
80106f63:	53                   	push   %ebx
80106f64:	83 ec 2c             	sub    $0x2c,%esp
  if(tf->trapno == T_SYSCALL){
80106f67:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6a:	8b 40 30             	mov    0x30(%eax),%eax
80106f6d:	83 f8 40             	cmp    $0x40,%eax
80106f70:	75 3b                	jne    80106fad <trap+0x53>
    if(myproc()->killed)
80106f72:	e8 4a d6 ff ff       	call   801045c1 <myproc>
80106f77:	8b 40 24             	mov    0x24(%eax),%eax
80106f7a:	85 c0                	test   %eax,%eax
80106f7c:	74 05                	je     80106f83 <trap+0x29>
      exit();
80106f7e:	e8 22 dd ff ff       	call   80104ca5 <exit>
    myproc()->tf = tf;
80106f83:	e8 39 d6 ff ff       	call   801045c1 <myproc>
80106f88:	8b 55 08             	mov    0x8(%ebp),%edx
80106f8b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106f8e:	e8 a1 ec ff ff       	call   80105c34 <syscall>
    if(myproc()->killed)
80106f93:	e8 29 d6 ff ff       	call   801045c1 <myproc>
80106f98:	8b 40 24             	mov    0x24(%eax),%eax
80106f9b:	85 c0                	test   %eax,%eax
80106f9d:	0f 84 52 02 00 00    	je     801071f5 <trap+0x29b>
      exit();
80106fa3:	e8 fd dc ff ff       	call   80104ca5 <exit>
    return;
80106fa8:	e9 48 02 00 00       	jmp    801071f5 <trap+0x29b>
  }
  char *addr;
  switch(tf->trapno){
80106fad:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb0:	8b 40 30             	mov    0x30(%eax),%eax
80106fb3:	83 e8 0e             	sub    $0xe,%eax
80106fb6:	83 f8 31             	cmp    $0x31,%eax
80106fb9:	0f 87 fe 00 00 00    	ja     801070bd <trap+0x163>
80106fbf:	8b 04 85 8c 9b 10 80 	mov    -0x7fef6474(,%eax,4),%eax
80106fc6:	3e ff e0             	notrack jmp *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106fc9:	e8 58 d5 ff ff       	call   80104526 <cpuid>
80106fce:	85 c0                	test   %eax,%eax
80106fd0:	75 3d                	jne    8010700f <trap+0xb5>
      acquire(&tickslock);
80106fd2:	83 ec 0c             	sub    $0xc,%esp
80106fd5:	68 00 9f 11 80       	push   $0x80119f00
80106fda:	e8 8a e5 ff ff       	call   80105569 <acquire>
80106fdf:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106fe2:	a1 40 a7 11 80       	mov    0x8011a740,%eax
80106fe7:	83 c0 01             	add    $0x1,%eax
80106fea:	a3 40 a7 11 80       	mov    %eax,0x8011a740
      wakeup(&ticks);
80106fef:	83 ec 0c             	sub    $0xc,%esp
80106ff2:	68 40 a7 11 80       	push   $0x8011a740
80106ff7:	e8 ed e1 ff ff       	call   801051e9 <wakeup>
80106ffc:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106fff:	83 ec 0c             	sub    $0xc,%esp
80107002:	68 00 9f 11 80       	push   $0x80119f00
80107007:	e8 cf e5 ff ff       	call   801055db <release>
8010700c:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010700f:	e8 a2 c2 ff ff       	call   801032b6 <lapiceoi>
    break;
80107014:	e9 5c 01 00 00       	jmp    80107175 <trap+0x21b>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107019:	e8 a7 ba ff ff       	call   80102ac5 <ideintr>
    lapiceoi();
8010701e:	e8 93 c2 ff ff       	call   801032b6 <lapiceoi>
    break;
80107023:	e9 4d 01 00 00       	jmp    80107175 <trap+0x21b>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107028:	e8 bf c0 ff ff       	call   801030ec <kbdintr>
    lapiceoi();
8010702d:	e8 84 c2 ff ff       	call   801032b6 <lapiceoi>
    break;
80107032:	e9 3e 01 00 00       	jmp    80107175 <trap+0x21b>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107037:	e8 9b 03 00 00       	call   801073d7 <uartintr>
    lapiceoi();
8010703c:	e8 75 c2 ff ff       	call   801032b6 <lapiceoi>
    break;
80107041:	e9 2f 01 00 00       	jmp    80107175 <trap+0x21b>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107046:	8b 45 08             	mov    0x8(%ebp),%eax
80107049:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010704c:	8b 45 08             	mov    0x8(%ebp),%eax
8010704f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107053:	0f b7 d8             	movzwl %ax,%ebx
80107056:	e8 cb d4 ff ff       	call   80104526 <cpuid>
8010705b:	56                   	push   %esi
8010705c:	53                   	push   %ebx
8010705d:	50                   	push   %eax
8010705e:	68 bc 9a 10 80       	push   $0x80109abc
80107063:	e8 b0 93 ff ff       	call   80100418 <cprintf>
80107068:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010706b:	e8 46 c2 ff ff       	call   801032b6 <lapiceoi>
    break;
80107070:	e9 00 01 00 00       	jmp    80107175 <trap+0x21b>
  case T_PGFLT:
    //Food for thought: How can one distinguish between a regular page fault and a decryption request?
    cprintf("p4Debug : Page fault !\n");
80107075:	83 ec 0c             	sub    $0xc,%esp
80107078:	68 e0 9a 10 80       	push   $0x80109ae0
8010707d:	e8 96 93 ff ff       	call   80100418 <cprintf>
80107082:	83 c4 10             	add    $0x10,%esp
    addr = (char*)rcr2();
80107085:	e8 29 fd ff ff       	call   80106db3 <rcr2>
8010708a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (mdecrypt(addr))
8010708d:	83 ec 0c             	sub    $0xc,%esp
80107090:	ff 75 e4             	pushl  -0x1c(%ebp)
80107093:	e8 1d 1e 00 00       	call   80108eb5 <mdecrypt>
80107098:	83 c4 10             	add    $0x10,%esp
8010709b:	85 c0                	test   %eax,%eax
8010709d:	0f 84 d1 00 00 00    	je     80107174 <trap+0x21a>
    {
        cprintf("p4Debug: Memory fault\n");
801070a3:	83 ec 0c             	sub    $0xc,%esp
801070a6:	68 f8 9a 10 80       	push   $0x80109af8
801070ab:	e8 68 93 ff ff       	call   80100418 <cprintf>
801070b0:	83 c4 10             	add    $0x10,%esp
        exit();
801070b3:	e8 ed db ff ff       	call   80104ca5 <exit>
    };
    break;
801070b8:	e9 b7 00 00 00       	jmp    80107174 <trap+0x21a>
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801070bd:	e8 ff d4 ff ff       	call   801045c1 <myproc>
801070c2:	85 c0                	test   %eax,%eax
801070c4:	74 11                	je     801070d7 <trap+0x17d>
801070c6:	8b 45 08             	mov    0x8(%ebp),%eax
801070c9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070cd:	0f b7 c0             	movzwl %ax,%eax
801070d0:	83 e0 03             	and    $0x3,%eax
801070d3:	85 c0                	test   %eax,%eax
801070d5:	75 39                	jne    80107110 <trap+0x1b6>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801070d7:	e8 d7 fc ff ff       	call   80106db3 <rcr2>
801070dc:	89 c3                	mov    %eax,%ebx
801070de:	8b 45 08             	mov    0x8(%ebp),%eax
801070e1:	8b 70 38             	mov    0x38(%eax),%esi
801070e4:	e8 3d d4 ff ff       	call   80104526 <cpuid>
801070e9:	8b 55 08             	mov    0x8(%ebp),%edx
801070ec:	8b 52 30             	mov    0x30(%edx),%edx
801070ef:	83 ec 0c             	sub    $0xc,%esp
801070f2:	53                   	push   %ebx
801070f3:	56                   	push   %esi
801070f4:	50                   	push   %eax
801070f5:	52                   	push   %edx
801070f6:	68 10 9b 10 80       	push   $0x80109b10
801070fb:	e8 18 93 ff ff       	call   80100418 <cprintf>
80107100:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80107103:	83 ec 0c             	sub    $0xc,%esp
80107106:	68 42 9b 10 80       	push   $0x80109b42
8010710b:	e8 f8 94 ff ff       	call   80100608 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107110:	e8 9e fc ff ff       	call   80106db3 <rcr2>
80107115:	89 c6                	mov    %eax,%esi
80107117:	8b 45 08             	mov    0x8(%ebp),%eax
8010711a:	8b 40 38             	mov    0x38(%eax),%eax
8010711d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107120:	e8 01 d4 ff ff       	call   80104526 <cpuid>
80107125:	89 c3                	mov    %eax,%ebx
80107127:	8b 45 08             	mov    0x8(%ebp),%eax
8010712a:	8b 48 34             	mov    0x34(%eax),%ecx
8010712d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80107130:	8b 45 08             	mov    0x8(%ebp),%eax
80107133:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80107136:	e8 86 d4 ff ff       	call   801045c1 <myproc>
8010713b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010713e:	89 55 cc             	mov    %edx,-0x34(%ebp)
80107141:	e8 7b d4 ff ff       	call   801045c1 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107146:	8b 40 10             	mov    0x10(%eax),%eax
80107149:	56                   	push   %esi
8010714a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010714d:	53                   	push   %ebx
8010714e:	ff 75 d0             	pushl  -0x30(%ebp)
80107151:	57                   	push   %edi
80107152:	ff 75 cc             	pushl  -0x34(%ebp)
80107155:	50                   	push   %eax
80107156:	68 48 9b 10 80       	push   $0x80109b48
8010715b:	e8 b8 92 ff ff       	call   80100418 <cprintf>
80107160:	83 c4 20             	add    $0x20,%esp
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80107163:	e8 59 d4 ff ff       	call   801045c1 <myproc>
80107168:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010716f:	eb 04                	jmp    80107175 <trap+0x21b>
    break;
80107171:	90                   	nop
80107172:	eb 01                	jmp    80107175 <trap+0x21b>
    break;
80107174:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107175:	e8 47 d4 ff ff       	call   801045c1 <myproc>
8010717a:	85 c0                	test   %eax,%eax
8010717c:	74 23                	je     801071a1 <trap+0x247>
8010717e:	e8 3e d4 ff ff       	call   801045c1 <myproc>
80107183:	8b 40 24             	mov    0x24(%eax),%eax
80107186:	85 c0                	test   %eax,%eax
80107188:	74 17                	je     801071a1 <trap+0x247>
8010718a:	8b 45 08             	mov    0x8(%ebp),%eax
8010718d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107191:	0f b7 c0             	movzwl %ax,%eax
80107194:	83 e0 03             	and    $0x3,%eax
80107197:	83 f8 03             	cmp    $0x3,%eax
8010719a:	75 05                	jne    801071a1 <trap+0x247>
    exit();
8010719c:	e8 04 db ff ff       	call   80104ca5 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801071a1:	e8 1b d4 ff ff       	call   801045c1 <myproc>
801071a6:	85 c0                	test   %eax,%eax
801071a8:	74 1d                	je     801071c7 <trap+0x26d>
801071aa:	e8 12 d4 ff ff       	call   801045c1 <myproc>
801071af:	8b 40 0c             	mov    0xc(%eax),%eax
801071b2:	83 f8 04             	cmp    $0x4,%eax
801071b5:	75 10                	jne    801071c7 <trap+0x26d>
     tf->trapno == T_IRQ0+IRQ_TIMER)
801071b7:	8b 45 08             	mov    0x8(%ebp),%eax
801071ba:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
801071bd:	83 f8 20             	cmp    $0x20,%eax
801071c0:	75 05                	jne    801071c7 <trap+0x26d>
    yield();
801071c2:	e8 a8 de ff ff       	call   8010506f <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801071c7:	e8 f5 d3 ff ff       	call   801045c1 <myproc>
801071cc:	85 c0                	test   %eax,%eax
801071ce:	74 26                	je     801071f6 <trap+0x29c>
801071d0:	e8 ec d3 ff ff       	call   801045c1 <myproc>
801071d5:	8b 40 24             	mov    0x24(%eax),%eax
801071d8:	85 c0                	test   %eax,%eax
801071da:	74 1a                	je     801071f6 <trap+0x29c>
801071dc:	8b 45 08             	mov    0x8(%ebp),%eax
801071df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071e3:	0f b7 c0             	movzwl %ax,%eax
801071e6:	83 e0 03             	and    $0x3,%eax
801071e9:	83 f8 03             	cmp    $0x3,%eax
801071ec:	75 08                	jne    801071f6 <trap+0x29c>
    exit();
801071ee:	e8 b2 da ff ff       	call   80104ca5 <exit>
801071f3:	eb 01                	jmp    801071f6 <trap+0x29c>
    return;
801071f5:	90                   	nop
}
801071f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f9:	5b                   	pop    %ebx
801071fa:	5e                   	pop    %esi
801071fb:	5f                   	pop    %edi
801071fc:	5d                   	pop    %ebp
801071fd:	c3                   	ret    

801071fe <inb>:
{
801071fe:	55                   	push   %ebp
801071ff:	89 e5                	mov    %esp,%ebp
80107201:	83 ec 14             	sub    $0x14,%esp
80107204:	8b 45 08             	mov    0x8(%ebp),%eax
80107207:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010720b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010720f:	89 c2                	mov    %eax,%edx
80107211:	ec                   	in     (%dx),%al
80107212:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107215:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107219:	c9                   	leave  
8010721a:	c3                   	ret    

8010721b <outb>:
{
8010721b:	55                   	push   %ebp
8010721c:	89 e5                	mov    %esp,%ebp
8010721e:	83 ec 08             	sub    $0x8,%esp
80107221:	8b 45 08             	mov    0x8(%ebp),%eax
80107224:	8b 55 0c             	mov    0xc(%ebp),%edx
80107227:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010722b:	89 d0                	mov    %edx,%eax
8010722d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107230:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107234:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107238:	ee                   	out    %al,(%dx)
}
80107239:	90                   	nop
8010723a:	c9                   	leave  
8010723b:	c3                   	ret    

8010723c <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010723c:	f3 0f 1e fb          	endbr32 
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107246:	6a 00                	push   $0x0
80107248:	68 fa 03 00 00       	push   $0x3fa
8010724d:	e8 c9 ff ff ff       	call   8010721b <outb>
80107252:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107255:	68 80 00 00 00       	push   $0x80
8010725a:	68 fb 03 00 00       	push   $0x3fb
8010725f:	e8 b7 ff ff ff       	call   8010721b <outb>
80107264:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107267:	6a 0c                	push   $0xc
80107269:	68 f8 03 00 00       	push   $0x3f8
8010726e:	e8 a8 ff ff ff       	call   8010721b <outb>
80107273:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107276:	6a 00                	push   $0x0
80107278:	68 f9 03 00 00       	push   $0x3f9
8010727d:	e8 99 ff ff ff       	call   8010721b <outb>
80107282:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107285:	6a 03                	push   $0x3
80107287:	68 fb 03 00 00       	push   $0x3fb
8010728c:	e8 8a ff ff ff       	call   8010721b <outb>
80107291:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107294:	6a 00                	push   $0x0
80107296:	68 fc 03 00 00       	push   $0x3fc
8010729b:	e8 7b ff ff ff       	call   8010721b <outb>
801072a0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072a3:	6a 01                	push   $0x1
801072a5:	68 f9 03 00 00       	push   $0x3f9
801072aa:	e8 6c ff ff ff       	call   8010721b <outb>
801072af:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801072b2:	68 fd 03 00 00       	push   $0x3fd
801072b7:	e8 42 ff ff ff       	call   801071fe <inb>
801072bc:	83 c4 04             	add    $0x4,%esp
801072bf:	3c ff                	cmp    $0xff,%al
801072c1:	74 61                	je     80107324 <uartinit+0xe8>
    return;
  uart = 1;
801072c3:	c7 05 44 d6 10 80 01 	movl   $0x1,0x8010d644
801072ca:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801072cd:	68 fa 03 00 00       	push   $0x3fa
801072d2:	e8 27 ff ff ff       	call   801071fe <inb>
801072d7:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801072da:	68 f8 03 00 00       	push   $0x3f8
801072df:	e8 1a ff ff ff       	call   801071fe <inb>
801072e4:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
801072e7:	83 ec 08             	sub    $0x8,%esp
801072ea:	6a 00                	push   $0x0
801072ec:	6a 04                	push   $0x4
801072ee:	e8 84 ba ff ff       	call   80102d77 <ioapicenable>
801072f3:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801072f6:	c7 45 f4 54 9c 10 80 	movl   $0x80109c54,-0xc(%ebp)
801072fd:	eb 19                	jmp    80107318 <uartinit+0xdc>
    uartputc(*p);
801072ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107302:	0f b6 00             	movzbl (%eax),%eax
80107305:	0f be c0             	movsbl %al,%eax
80107308:	83 ec 0c             	sub    $0xc,%esp
8010730b:	50                   	push   %eax
8010730c:	e8 16 00 00 00       	call   80107327 <uartputc>
80107311:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107314:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731b:	0f b6 00             	movzbl (%eax),%eax
8010731e:	84 c0                	test   %al,%al
80107320:	75 dd                	jne    801072ff <uartinit+0xc3>
80107322:	eb 01                	jmp    80107325 <uartinit+0xe9>
    return;
80107324:	90                   	nop
}
80107325:	c9                   	leave  
80107326:	c3                   	ret    

80107327 <uartputc>:

void
uartputc(int c)
{
80107327:	f3 0f 1e fb          	endbr32 
8010732b:	55                   	push   %ebp
8010732c:	89 e5                	mov    %esp,%ebp
8010732e:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107331:	a1 44 d6 10 80       	mov    0x8010d644,%eax
80107336:	85 c0                	test   %eax,%eax
80107338:	74 53                	je     8010738d <uartputc+0x66>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010733a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107341:	eb 11                	jmp    80107354 <uartputc+0x2d>
    microdelay(10);
80107343:	83 ec 0c             	sub    $0xc,%esp
80107346:	6a 0a                	push   $0xa
80107348:	e8 88 bf ff ff       	call   801032d5 <microdelay>
8010734d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107350:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107354:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107358:	7f 1a                	jg     80107374 <uartputc+0x4d>
8010735a:	83 ec 0c             	sub    $0xc,%esp
8010735d:	68 fd 03 00 00       	push   $0x3fd
80107362:	e8 97 fe ff ff       	call   801071fe <inb>
80107367:	83 c4 10             	add    $0x10,%esp
8010736a:	0f b6 c0             	movzbl %al,%eax
8010736d:	83 e0 20             	and    $0x20,%eax
80107370:	85 c0                	test   %eax,%eax
80107372:	74 cf                	je     80107343 <uartputc+0x1c>
  outb(COM1+0, c);
80107374:	8b 45 08             	mov    0x8(%ebp),%eax
80107377:	0f b6 c0             	movzbl %al,%eax
8010737a:	83 ec 08             	sub    $0x8,%esp
8010737d:	50                   	push   %eax
8010737e:	68 f8 03 00 00       	push   $0x3f8
80107383:	e8 93 fe ff ff       	call   8010721b <outb>
80107388:	83 c4 10             	add    $0x10,%esp
8010738b:	eb 01                	jmp    8010738e <uartputc+0x67>
    return;
8010738d:	90                   	nop
}
8010738e:	c9                   	leave  
8010738f:	c3                   	ret    

80107390 <uartgetc>:

static int
uartgetc(void)
{
80107390:	f3 0f 1e fb          	endbr32 
80107394:	55                   	push   %ebp
80107395:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107397:	a1 44 d6 10 80       	mov    0x8010d644,%eax
8010739c:	85 c0                	test   %eax,%eax
8010739e:	75 07                	jne    801073a7 <uartgetc+0x17>
    return -1;
801073a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073a5:	eb 2e                	jmp    801073d5 <uartgetc+0x45>
  if(!(inb(COM1+5) & 0x01))
801073a7:	68 fd 03 00 00       	push   $0x3fd
801073ac:	e8 4d fe ff ff       	call   801071fe <inb>
801073b1:	83 c4 04             	add    $0x4,%esp
801073b4:	0f b6 c0             	movzbl %al,%eax
801073b7:	83 e0 01             	and    $0x1,%eax
801073ba:	85 c0                	test   %eax,%eax
801073bc:	75 07                	jne    801073c5 <uartgetc+0x35>
    return -1;
801073be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073c3:	eb 10                	jmp    801073d5 <uartgetc+0x45>
  return inb(COM1+0);
801073c5:	68 f8 03 00 00       	push   $0x3f8
801073ca:	e8 2f fe ff ff       	call   801071fe <inb>
801073cf:	83 c4 04             	add    $0x4,%esp
801073d2:	0f b6 c0             	movzbl %al,%eax
}
801073d5:	c9                   	leave  
801073d6:	c3                   	ret    

801073d7 <uartintr>:

void
uartintr(void)
{
801073d7:	f3 0f 1e fb          	endbr32 
801073db:	55                   	push   %ebp
801073dc:	89 e5                	mov    %esp,%ebp
801073de:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801073e1:	83 ec 0c             	sub    $0xc,%esp
801073e4:	68 90 73 10 80       	push   $0x80107390
801073e9:	e8 ba 94 ff ff       	call   801008a8 <consoleintr>
801073ee:	83 c4 10             	add    $0x10,%esp
}
801073f1:	90                   	nop
801073f2:	c9                   	leave  
801073f3:	c3                   	ret    

801073f4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $0
801073f6:	6a 00                	push   $0x0
  jmp alltraps
801073f8:	e9 69 f9 ff ff       	jmp    80106d66 <alltraps>

801073fd <vector1>:
.globl vector1
vector1:
  pushl $0
801073fd:	6a 00                	push   $0x0
  pushl $1
801073ff:	6a 01                	push   $0x1
  jmp alltraps
80107401:	e9 60 f9 ff ff       	jmp    80106d66 <alltraps>

80107406 <vector2>:
.globl vector2
vector2:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $2
80107408:	6a 02                	push   $0x2
  jmp alltraps
8010740a:	e9 57 f9 ff ff       	jmp    80106d66 <alltraps>

8010740f <vector3>:
.globl vector3
vector3:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $3
80107411:	6a 03                	push   $0x3
  jmp alltraps
80107413:	e9 4e f9 ff ff       	jmp    80106d66 <alltraps>

80107418 <vector4>:
.globl vector4
vector4:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $4
8010741a:	6a 04                	push   $0x4
  jmp alltraps
8010741c:	e9 45 f9 ff ff       	jmp    80106d66 <alltraps>

80107421 <vector5>:
.globl vector5
vector5:
  pushl $0
80107421:	6a 00                	push   $0x0
  pushl $5
80107423:	6a 05                	push   $0x5
  jmp alltraps
80107425:	e9 3c f9 ff ff       	jmp    80106d66 <alltraps>

8010742a <vector6>:
.globl vector6
vector6:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $6
8010742c:	6a 06                	push   $0x6
  jmp alltraps
8010742e:	e9 33 f9 ff ff       	jmp    80106d66 <alltraps>

80107433 <vector7>:
.globl vector7
vector7:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $7
80107435:	6a 07                	push   $0x7
  jmp alltraps
80107437:	e9 2a f9 ff ff       	jmp    80106d66 <alltraps>

8010743c <vector8>:
.globl vector8
vector8:
  pushl $8
8010743c:	6a 08                	push   $0x8
  jmp alltraps
8010743e:	e9 23 f9 ff ff       	jmp    80106d66 <alltraps>

80107443 <vector9>:
.globl vector9
vector9:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $9
80107445:	6a 09                	push   $0x9
  jmp alltraps
80107447:	e9 1a f9 ff ff       	jmp    80106d66 <alltraps>

8010744c <vector10>:
.globl vector10
vector10:
  pushl $10
8010744c:	6a 0a                	push   $0xa
  jmp alltraps
8010744e:	e9 13 f9 ff ff       	jmp    80106d66 <alltraps>

80107453 <vector11>:
.globl vector11
vector11:
  pushl $11
80107453:	6a 0b                	push   $0xb
  jmp alltraps
80107455:	e9 0c f9 ff ff       	jmp    80106d66 <alltraps>

8010745a <vector12>:
.globl vector12
vector12:
  pushl $12
8010745a:	6a 0c                	push   $0xc
  jmp alltraps
8010745c:	e9 05 f9 ff ff       	jmp    80106d66 <alltraps>

80107461 <vector13>:
.globl vector13
vector13:
  pushl $13
80107461:	6a 0d                	push   $0xd
  jmp alltraps
80107463:	e9 fe f8 ff ff       	jmp    80106d66 <alltraps>

80107468 <vector14>:
.globl vector14
vector14:
  pushl $14
80107468:	6a 0e                	push   $0xe
  jmp alltraps
8010746a:	e9 f7 f8 ff ff       	jmp    80106d66 <alltraps>

8010746f <vector15>:
.globl vector15
vector15:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $15
80107471:	6a 0f                	push   $0xf
  jmp alltraps
80107473:	e9 ee f8 ff ff       	jmp    80106d66 <alltraps>

80107478 <vector16>:
.globl vector16
vector16:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $16
8010747a:	6a 10                	push   $0x10
  jmp alltraps
8010747c:	e9 e5 f8 ff ff       	jmp    80106d66 <alltraps>

80107481 <vector17>:
.globl vector17
vector17:
  pushl $17
80107481:	6a 11                	push   $0x11
  jmp alltraps
80107483:	e9 de f8 ff ff       	jmp    80106d66 <alltraps>

80107488 <vector18>:
.globl vector18
vector18:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $18
8010748a:	6a 12                	push   $0x12
  jmp alltraps
8010748c:	e9 d5 f8 ff ff       	jmp    80106d66 <alltraps>

80107491 <vector19>:
.globl vector19
vector19:
  pushl $0
80107491:	6a 00                	push   $0x0
  pushl $19
80107493:	6a 13                	push   $0x13
  jmp alltraps
80107495:	e9 cc f8 ff ff       	jmp    80106d66 <alltraps>

8010749a <vector20>:
.globl vector20
vector20:
  pushl $0
8010749a:	6a 00                	push   $0x0
  pushl $20
8010749c:	6a 14                	push   $0x14
  jmp alltraps
8010749e:	e9 c3 f8 ff ff       	jmp    80106d66 <alltraps>

801074a3 <vector21>:
.globl vector21
vector21:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $21
801074a5:	6a 15                	push   $0x15
  jmp alltraps
801074a7:	e9 ba f8 ff ff       	jmp    80106d66 <alltraps>

801074ac <vector22>:
.globl vector22
vector22:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $22
801074ae:	6a 16                	push   $0x16
  jmp alltraps
801074b0:	e9 b1 f8 ff ff       	jmp    80106d66 <alltraps>

801074b5 <vector23>:
.globl vector23
vector23:
  pushl $0
801074b5:	6a 00                	push   $0x0
  pushl $23
801074b7:	6a 17                	push   $0x17
  jmp alltraps
801074b9:	e9 a8 f8 ff ff       	jmp    80106d66 <alltraps>

801074be <vector24>:
.globl vector24
vector24:
  pushl $0
801074be:	6a 00                	push   $0x0
  pushl $24
801074c0:	6a 18                	push   $0x18
  jmp alltraps
801074c2:	e9 9f f8 ff ff       	jmp    80106d66 <alltraps>

801074c7 <vector25>:
.globl vector25
vector25:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $25
801074c9:	6a 19                	push   $0x19
  jmp alltraps
801074cb:	e9 96 f8 ff ff       	jmp    80106d66 <alltraps>

801074d0 <vector26>:
.globl vector26
vector26:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $26
801074d2:	6a 1a                	push   $0x1a
  jmp alltraps
801074d4:	e9 8d f8 ff ff       	jmp    80106d66 <alltraps>

801074d9 <vector27>:
.globl vector27
vector27:
  pushl $0
801074d9:	6a 00                	push   $0x0
  pushl $27
801074db:	6a 1b                	push   $0x1b
  jmp alltraps
801074dd:	e9 84 f8 ff ff       	jmp    80106d66 <alltraps>

801074e2 <vector28>:
.globl vector28
vector28:
  pushl $0
801074e2:	6a 00                	push   $0x0
  pushl $28
801074e4:	6a 1c                	push   $0x1c
  jmp alltraps
801074e6:	e9 7b f8 ff ff       	jmp    80106d66 <alltraps>

801074eb <vector29>:
.globl vector29
vector29:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $29
801074ed:	6a 1d                	push   $0x1d
  jmp alltraps
801074ef:	e9 72 f8 ff ff       	jmp    80106d66 <alltraps>

801074f4 <vector30>:
.globl vector30
vector30:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $30
801074f6:	6a 1e                	push   $0x1e
  jmp alltraps
801074f8:	e9 69 f8 ff ff       	jmp    80106d66 <alltraps>

801074fd <vector31>:
.globl vector31
vector31:
  pushl $0
801074fd:	6a 00                	push   $0x0
  pushl $31
801074ff:	6a 1f                	push   $0x1f
  jmp alltraps
80107501:	e9 60 f8 ff ff       	jmp    80106d66 <alltraps>

80107506 <vector32>:
.globl vector32
vector32:
  pushl $0
80107506:	6a 00                	push   $0x0
  pushl $32
80107508:	6a 20                	push   $0x20
  jmp alltraps
8010750a:	e9 57 f8 ff ff       	jmp    80106d66 <alltraps>

8010750f <vector33>:
.globl vector33
vector33:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $33
80107511:	6a 21                	push   $0x21
  jmp alltraps
80107513:	e9 4e f8 ff ff       	jmp    80106d66 <alltraps>

80107518 <vector34>:
.globl vector34
vector34:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $34
8010751a:	6a 22                	push   $0x22
  jmp alltraps
8010751c:	e9 45 f8 ff ff       	jmp    80106d66 <alltraps>

80107521 <vector35>:
.globl vector35
vector35:
  pushl $0
80107521:	6a 00                	push   $0x0
  pushl $35
80107523:	6a 23                	push   $0x23
  jmp alltraps
80107525:	e9 3c f8 ff ff       	jmp    80106d66 <alltraps>

8010752a <vector36>:
.globl vector36
vector36:
  pushl $0
8010752a:	6a 00                	push   $0x0
  pushl $36
8010752c:	6a 24                	push   $0x24
  jmp alltraps
8010752e:	e9 33 f8 ff ff       	jmp    80106d66 <alltraps>

80107533 <vector37>:
.globl vector37
vector37:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $37
80107535:	6a 25                	push   $0x25
  jmp alltraps
80107537:	e9 2a f8 ff ff       	jmp    80106d66 <alltraps>

8010753c <vector38>:
.globl vector38
vector38:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $38
8010753e:	6a 26                	push   $0x26
  jmp alltraps
80107540:	e9 21 f8 ff ff       	jmp    80106d66 <alltraps>

80107545 <vector39>:
.globl vector39
vector39:
  pushl $0
80107545:	6a 00                	push   $0x0
  pushl $39
80107547:	6a 27                	push   $0x27
  jmp alltraps
80107549:	e9 18 f8 ff ff       	jmp    80106d66 <alltraps>

8010754e <vector40>:
.globl vector40
vector40:
  pushl $0
8010754e:	6a 00                	push   $0x0
  pushl $40
80107550:	6a 28                	push   $0x28
  jmp alltraps
80107552:	e9 0f f8 ff ff       	jmp    80106d66 <alltraps>

80107557 <vector41>:
.globl vector41
vector41:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $41
80107559:	6a 29                	push   $0x29
  jmp alltraps
8010755b:	e9 06 f8 ff ff       	jmp    80106d66 <alltraps>

80107560 <vector42>:
.globl vector42
vector42:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $42
80107562:	6a 2a                	push   $0x2a
  jmp alltraps
80107564:	e9 fd f7 ff ff       	jmp    80106d66 <alltraps>

80107569 <vector43>:
.globl vector43
vector43:
  pushl $0
80107569:	6a 00                	push   $0x0
  pushl $43
8010756b:	6a 2b                	push   $0x2b
  jmp alltraps
8010756d:	e9 f4 f7 ff ff       	jmp    80106d66 <alltraps>

80107572 <vector44>:
.globl vector44
vector44:
  pushl $0
80107572:	6a 00                	push   $0x0
  pushl $44
80107574:	6a 2c                	push   $0x2c
  jmp alltraps
80107576:	e9 eb f7 ff ff       	jmp    80106d66 <alltraps>

8010757b <vector45>:
.globl vector45
vector45:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $45
8010757d:	6a 2d                	push   $0x2d
  jmp alltraps
8010757f:	e9 e2 f7 ff ff       	jmp    80106d66 <alltraps>

80107584 <vector46>:
.globl vector46
vector46:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $46
80107586:	6a 2e                	push   $0x2e
  jmp alltraps
80107588:	e9 d9 f7 ff ff       	jmp    80106d66 <alltraps>

8010758d <vector47>:
.globl vector47
vector47:
  pushl $0
8010758d:	6a 00                	push   $0x0
  pushl $47
8010758f:	6a 2f                	push   $0x2f
  jmp alltraps
80107591:	e9 d0 f7 ff ff       	jmp    80106d66 <alltraps>

80107596 <vector48>:
.globl vector48
vector48:
  pushl $0
80107596:	6a 00                	push   $0x0
  pushl $48
80107598:	6a 30                	push   $0x30
  jmp alltraps
8010759a:	e9 c7 f7 ff ff       	jmp    80106d66 <alltraps>

8010759f <vector49>:
.globl vector49
vector49:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $49
801075a1:	6a 31                	push   $0x31
  jmp alltraps
801075a3:	e9 be f7 ff ff       	jmp    80106d66 <alltraps>

801075a8 <vector50>:
.globl vector50
vector50:
  pushl $0
801075a8:	6a 00                	push   $0x0
  pushl $50
801075aa:	6a 32                	push   $0x32
  jmp alltraps
801075ac:	e9 b5 f7 ff ff       	jmp    80106d66 <alltraps>

801075b1 <vector51>:
.globl vector51
vector51:
  pushl $0
801075b1:	6a 00                	push   $0x0
  pushl $51
801075b3:	6a 33                	push   $0x33
  jmp alltraps
801075b5:	e9 ac f7 ff ff       	jmp    80106d66 <alltraps>

801075ba <vector52>:
.globl vector52
vector52:
  pushl $0
801075ba:	6a 00                	push   $0x0
  pushl $52
801075bc:	6a 34                	push   $0x34
  jmp alltraps
801075be:	e9 a3 f7 ff ff       	jmp    80106d66 <alltraps>

801075c3 <vector53>:
.globl vector53
vector53:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $53
801075c5:	6a 35                	push   $0x35
  jmp alltraps
801075c7:	e9 9a f7 ff ff       	jmp    80106d66 <alltraps>

801075cc <vector54>:
.globl vector54
vector54:
  pushl $0
801075cc:	6a 00                	push   $0x0
  pushl $54
801075ce:	6a 36                	push   $0x36
  jmp alltraps
801075d0:	e9 91 f7 ff ff       	jmp    80106d66 <alltraps>

801075d5 <vector55>:
.globl vector55
vector55:
  pushl $0
801075d5:	6a 00                	push   $0x0
  pushl $55
801075d7:	6a 37                	push   $0x37
  jmp alltraps
801075d9:	e9 88 f7 ff ff       	jmp    80106d66 <alltraps>

801075de <vector56>:
.globl vector56
vector56:
  pushl $0
801075de:	6a 00                	push   $0x0
  pushl $56
801075e0:	6a 38                	push   $0x38
  jmp alltraps
801075e2:	e9 7f f7 ff ff       	jmp    80106d66 <alltraps>

801075e7 <vector57>:
.globl vector57
vector57:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $57
801075e9:	6a 39                	push   $0x39
  jmp alltraps
801075eb:	e9 76 f7 ff ff       	jmp    80106d66 <alltraps>

801075f0 <vector58>:
.globl vector58
vector58:
  pushl $0
801075f0:	6a 00                	push   $0x0
  pushl $58
801075f2:	6a 3a                	push   $0x3a
  jmp alltraps
801075f4:	e9 6d f7 ff ff       	jmp    80106d66 <alltraps>

801075f9 <vector59>:
.globl vector59
vector59:
  pushl $0
801075f9:	6a 00                	push   $0x0
  pushl $59
801075fb:	6a 3b                	push   $0x3b
  jmp alltraps
801075fd:	e9 64 f7 ff ff       	jmp    80106d66 <alltraps>

80107602 <vector60>:
.globl vector60
vector60:
  pushl $0
80107602:	6a 00                	push   $0x0
  pushl $60
80107604:	6a 3c                	push   $0x3c
  jmp alltraps
80107606:	e9 5b f7 ff ff       	jmp    80106d66 <alltraps>

8010760b <vector61>:
.globl vector61
vector61:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $61
8010760d:	6a 3d                	push   $0x3d
  jmp alltraps
8010760f:	e9 52 f7 ff ff       	jmp    80106d66 <alltraps>

80107614 <vector62>:
.globl vector62
vector62:
  pushl $0
80107614:	6a 00                	push   $0x0
  pushl $62
80107616:	6a 3e                	push   $0x3e
  jmp alltraps
80107618:	e9 49 f7 ff ff       	jmp    80106d66 <alltraps>

8010761d <vector63>:
.globl vector63
vector63:
  pushl $0
8010761d:	6a 00                	push   $0x0
  pushl $63
8010761f:	6a 3f                	push   $0x3f
  jmp alltraps
80107621:	e9 40 f7 ff ff       	jmp    80106d66 <alltraps>

80107626 <vector64>:
.globl vector64
vector64:
  pushl $0
80107626:	6a 00                	push   $0x0
  pushl $64
80107628:	6a 40                	push   $0x40
  jmp alltraps
8010762a:	e9 37 f7 ff ff       	jmp    80106d66 <alltraps>

8010762f <vector65>:
.globl vector65
vector65:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $65
80107631:	6a 41                	push   $0x41
  jmp alltraps
80107633:	e9 2e f7 ff ff       	jmp    80106d66 <alltraps>

80107638 <vector66>:
.globl vector66
vector66:
  pushl $0
80107638:	6a 00                	push   $0x0
  pushl $66
8010763a:	6a 42                	push   $0x42
  jmp alltraps
8010763c:	e9 25 f7 ff ff       	jmp    80106d66 <alltraps>

80107641 <vector67>:
.globl vector67
vector67:
  pushl $0
80107641:	6a 00                	push   $0x0
  pushl $67
80107643:	6a 43                	push   $0x43
  jmp alltraps
80107645:	e9 1c f7 ff ff       	jmp    80106d66 <alltraps>

8010764a <vector68>:
.globl vector68
vector68:
  pushl $0
8010764a:	6a 00                	push   $0x0
  pushl $68
8010764c:	6a 44                	push   $0x44
  jmp alltraps
8010764e:	e9 13 f7 ff ff       	jmp    80106d66 <alltraps>

80107653 <vector69>:
.globl vector69
vector69:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $69
80107655:	6a 45                	push   $0x45
  jmp alltraps
80107657:	e9 0a f7 ff ff       	jmp    80106d66 <alltraps>

8010765c <vector70>:
.globl vector70
vector70:
  pushl $0
8010765c:	6a 00                	push   $0x0
  pushl $70
8010765e:	6a 46                	push   $0x46
  jmp alltraps
80107660:	e9 01 f7 ff ff       	jmp    80106d66 <alltraps>

80107665 <vector71>:
.globl vector71
vector71:
  pushl $0
80107665:	6a 00                	push   $0x0
  pushl $71
80107667:	6a 47                	push   $0x47
  jmp alltraps
80107669:	e9 f8 f6 ff ff       	jmp    80106d66 <alltraps>

8010766e <vector72>:
.globl vector72
vector72:
  pushl $0
8010766e:	6a 00                	push   $0x0
  pushl $72
80107670:	6a 48                	push   $0x48
  jmp alltraps
80107672:	e9 ef f6 ff ff       	jmp    80106d66 <alltraps>

80107677 <vector73>:
.globl vector73
vector73:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $73
80107679:	6a 49                	push   $0x49
  jmp alltraps
8010767b:	e9 e6 f6 ff ff       	jmp    80106d66 <alltraps>

80107680 <vector74>:
.globl vector74
vector74:
  pushl $0
80107680:	6a 00                	push   $0x0
  pushl $74
80107682:	6a 4a                	push   $0x4a
  jmp alltraps
80107684:	e9 dd f6 ff ff       	jmp    80106d66 <alltraps>

80107689 <vector75>:
.globl vector75
vector75:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $75
8010768b:	6a 4b                	push   $0x4b
  jmp alltraps
8010768d:	e9 d4 f6 ff ff       	jmp    80106d66 <alltraps>

80107692 <vector76>:
.globl vector76
vector76:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $76
80107694:	6a 4c                	push   $0x4c
  jmp alltraps
80107696:	e9 cb f6 ff ff       	jmp    80106d66 <alltraps>

8010769b <vector77>:
.globl vector77
vector77:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $77
8010769d:	6a 4d                	push   $0x4d
  jmp alltraps
8010769f:	e9 c2 f6 ff ff       	jmp    80106d66 <alltraps>

801076a4 <vector78>:
.globl vector78
vector78:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $78
801076a6:	6a 4e                	push   $0x4e
  jmp alltraps
801076a8:	e9 b9 f6 ff ff       	jmp    80106d66 <alltraps>

801076ad <vector79>:
.globl vector79
vector79:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $79
801076af:	6a 4f                	push   $0x4f
  jmp alltraps
801076b1:	e9 b0 f6 ff ff       	jmp    80106d66 <alltraps>

801076b6 <vector80>:
.globl vector80
vector80:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $80
801076b8:	6a 50                	push   $0x50
  jmp alltraps
801076ba:	e9 a7 f6 ff ff       	jmp    80106d66 <alltraps>

801076bf <vector81>:
.globl vector81
vector81:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $81
801076c1:	6a 51                	push   $0x51
  jmp alltraps
801076c3:	e9 9e f6 ff ff       	jmp    80106d66 <alltraps>

801076c8 <vector82>:
.globl vector82
vector82:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $82
801076ca:	6a 52                	push   $0x52
  jmp alltraps
801076cc:	e9 95 f6 ff ff       	jmp    80106d66 <alltraps>

801076d1 <vector83>:
.globl vector83
vector83:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $83
801076d3:	6a 53                	push   $0x53
  jmp alltraps
801076d5:	e9 8c f6 ff ff       	jmp    80106d66 <alltraps>

801076da <vector84>:
.globl vector84
vector84:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $84
801076dc:	6a 54                	push   $0x54
  jmp alltraps
801076de:	e9 83 f6 ff ff       	jmp    80106d66 <alltraps>

801076e3 <vector85>:
.globl vector85
vector85:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $85
801076e5:	6a 55                	push   $0x55
  jmp alltraps
801076e7:	e9 7a f6 ff ff       	jmp    80106d66 <alltraps>

801076ec <vector86>:
.globl vector86
vector86:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $86
801076ee:	6a 56                	push   $0x56
  jmp alltraps
801076f0:	e9 71 f6 ff ff       	jmp    80106d66 <alltraps>

801076f5 <vector87>:
.globl vector87
vector87:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $87
801076f7:	6a 57                	push   $0x57
  jmp alltraps
801076f9:	e9 68 f6 ff ff       	jmp    80106d66 <alltraps>

801076fe <vector88>:
.globl vector88
vector88:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $88
80107700:	6a 58                	push   $0x58
  jmp alltraps
80107702:	e9 5f f6 ff ff       	jmp    80106d66 <alltraps>

80107707 <vector89>:
.globl vector89
vector89:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $89
80107709:	6a 59                	push   $0x59
  jmp alltraps
8010770b:	e9 56 f6 ff ff       	jmp    80106d66 <alltraps>

80107710 <vector90>:
.globl vector90
vector90:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $90
80107712:	6a 5a                	push   $0x5a
  jmp alltraps
80107714:	e9 4d f6 ff ff       	jmp    80106d66 <alltraps>

80107719 <vector91>:
.globl vector91
vector91:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $91
8010771b:	6a 5b                	push   $0x5b
  jmp alltraps
8010771d:	e9 44 f6 ff ff       	jmp    80106d66 <alltraps>

80107722 <vector92>:
.globl vector92
vector92:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $92
80107724:	6a 5c                	push   $0x5c
  jmp alltraps
80107726:	e9 3b f6 ff ff       	jmp    80106d66 <alltraps>

8010772b <vector93>:
.globl vector93
vector93:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $93
8010772d:	6a 5d                	push   $0x5d
  jmp alltraps
8010772f:	e9 32 f6 ff ff       	jmp    80106d66 <alltraps>

80107734 <vector94>:
.globl vector94
vector94:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $94
80107736:	6a 5e                	push   $0x5e
  jmp alltraps
80107738:	e9 29 f6 ff ff       	jmp    80106d66 <alltraps>

8010773d <vector95>:
.globl vector95
vector95:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $95
8010773f:	6a 5f                	push   $0x5f
  jmp alltraps
80107741:	e9 20 f6 ff ff       	jmp    80106d66 <alltraps>

80107746 <vector96>:
.globl vector96
vector96:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $96
80107748:	6a 60                	push   $0x60
  jmp alltraps
8010774a:	e9 17 f6 ff ff       	jmp    80106d66 <alltraps>

8010774f <vector97>:
.globl vector97
vector97:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $97
80107751:	6a 61                	push   $0x61
  jmp alltraps
80107753:	e9 0e f6 ff ff       	jmp    80106d66 <alltraps>

80107758 <vector98>:
.globl vector98
vector98:
  pushl $0
80107758:	6a 00                	push   $0x0
  pushl $98
8010775a:	6a 62                	push   $0x62
  jmp alltraps
8010775c:	e9 05 f6 ff ff       	jmp    80106d66 <alltraps>

80107761 <vector99>:
.globl vector99
vector99:
  pushl $0
80107761:	6a 00                	push   $0x0
  pushl $99
80107763:	6a 63                	push   $0x63
  jmp alltraps
80107765:	e9 fc f5 ff ff       	jmp    80106d66 <alltraps>

8010776a <vector100>:
.globl vector100
vector100:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $100
8010776c:	6a 64                	push   $0x64
  jmp alltraps
8010776e:	e9 f3 f5 ff ff       	jmp    80106d66 <alltraps>

80107773 <vector101>:
.globl vector101
vector101:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $101
80107775:	6a 65                	push   $0x65
  jmp alltraps
80107777:	e9 ea f5 ff ff       	jmp    80106d66 <alltraps>

8010777c <vector102>:
.globl vector102
vector102:
  pushl $0
8010777c:	6a 00                	push   $0x0
  pushl $102
8010777e:	6a 66                	push   $0x66
  jmp alltraps
80107780:	e9 e1 f5 ff ff       	jmp    80106d66 <alltraps>

80107785 <vector103>:
.globl vector103
vector103:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $103
80107787:	6a 67                	push   $0x67
  jmp alltraps
80107789:	e9 d8 f5 ff ff       	jmp    80106d66 <alltraps>

8010778e <vector104>:
.globl vector104
vector104:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $104
80107790:	6a 68                	push   $0x68
  jmp alltraps
80107792:	e9 cf f5 ff ff       	jmp    80106d66 <alltraps>

80107797 <vector105>:
.globl vector105
vector105:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $105
80107799:	6a 69                	push   $0x69
  jmp alltraps
8010779b:	e9 c6 f5 ff ff       	jmp    80106d66 <alltraps>

801077a0 <vector106>:
.globl vector106
vector106:
  pushl $0
801077a0:	6a 00                	push   $0x0
  pushl $106
801077a2:	6a 6a                	push   $0x6a
  jmp alltraps
801077a4:	e9 bd f5 ff ff       	jmp    80106d66 <alltraps>

801077a9 <vector107>:
.globl vector107
vector107:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $107
801077ab:	6a 6b                	push   $0x6b
  jmp alltraps
801077ad:	e9 b4 f5 ff ff       	jmp    80106d66 <alltraps>

801077b2 <vector108>:
.globl vector108
vector108:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $108
801077b4:	6a 6c                	push   $0x6c
  jmp alltraps
801077b6:	e9 ab f5 ff ff       	jmp    80106d66 <alltraps>

801077bb <vector109>:
.globl vector109
vector109:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $109
801077bd:	6a 6d                	push   $0x6d
  jmp alltraps
801077bf:	e9 a2 f5 ff ff       	jmp    80106d66 <alltraps>

801077c4 <vector110>:
.globl vector110
vector110:
  pushl $0
801077c4:	6a 00                	push   $0x0
  pushl $110
801077c6:	6a 6e                	push   $0x6e
  jmp alltraps
801077c8:	e9 99 f5 ff ff       	jmp    80106d66 <alltraps>

801077cd <vector111>:
.globl vector111
vector111:
  pushl $0
801077cd:	6a 00                	push   $0x0
  pushl $111
801077cf:	6a 6f                	push   $0x6f
  jmp alltraps
801077d1:	e9 90 f5 ff ff       	jmp    80106d66 <alltraps>

801077d6 <vector112>:
.globl vector112
vector112:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $112
801077d8:	6a 70                	push   $0x70
  jmp alltraps
801077da:	e9 87 f5 ff ff       	jmp    80106d66 <alltraps>

801077df <vector113>:
.globl vector113
vector113:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $113
801077e1:	6a 71                	push   $0x71
  jmp alltraps
801077e3:	e9 7e f5 ff ff       	jmp    80106d66 <alltraps>

801077e8 <vector114>:
.globl vector114
vector114:
  pushl $0
801077e8:	6a 00                	push   $0x0
  pushl $114
801077ea:	6a 72                	push   $0x72
  jmp alltraps
801077ec:	e9 75 f5 ff ff       	jmp    80106d66 <alltraps>

801077f1 <vector115>:
.globl vector115
vector115:
  pushl $0
801077f1:	6a 00                	push   $0x0
  pushl $115
801077f3:	6a 73                	push   $0x73
  jmp alltraps
801077f5:	e9 6c f5 ff ff       	jmp    80106d66 <alltraps>

801077fa <vector116>:
.globl vector116
vector116:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $116
801077fc:	6a 74                	push   $0x74
  jmp alltraps
801077fe:	e9 63 f5 ff ff       	jmp    80106d66 <alltraps>

80107803 <vector117>:
.globl vector117
vector117:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $117
80107805:	6a 75                	push   $0x75
  jmp alltraps
80107807:	e9 5a f5 ff ff       	jmp    80106d66 <alltraps>

8010780c <vector118>:
.globl vector118
vector118:
  pushl $0
8010780c:	6a 00                	push   $0x0
  pushl $118
8010780e:	6a 76                	push   $0x76
  jmp alltraps
80107810:	e9 51 f5 ff ff       	jmp    80106d66 <alltraps>

80107815 <vector119>:
.globl vector119
vector119:
  pushl $0
80107815:	6a 00                	push   $0x0
  pushl $119
80107817:	6a 77                	push   $0x77
  jmp alltraps
80107819:	e9 48 f5 ff ff       	jmp    80106d66 <alltraps>

8010781e <vector120>:
.globl vector120
vector120:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $120
80107820:	6a 78                	push   $0x78
  jmp alltraps
80107822:	e9 3f f5 ff ff       	jmp    80106d66 <alltraps>

80107827 <vector121>:
.globl vector121
vector121:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $121
80107829:	6a 79                	push   $0x79
  jmp alltraps
8010782b:	e9 36 f5 ff ff       	jmp    80106d66 <alltraps>

80107830 <vector122>:
.globl vector122
vector122:
  pushl $0
80107830:	6a 00                	push   $0x0
  pushl $122
80107832:	6a 7a                	push   $0x7a
  jmp alltraps
80107834:	e9 2d f5 ff ff       	jmp    80106d66 <alltraps>

80107839 <vector123>:
.globl vector123
vector123:
  pushl $0
80107839:	6a 00                	push   $0x0
  pushl $123
8010783b:	6a 7b                	push   $0x7b
  jmp alltraps
8010783d:	e9 24 f5 ff ff       	jmp    80106d66 <alltraps>

80107842 <vector124>:
.globl vector124
vector124:
  pushl $0
80107842:	6a 00                	push   $0x0
  pushl $124
80107844:	6a 7c                	push   $0x7c
  jmp alltraps
80107846:	e9 1b f5 ff ff       	jmp    80106d66 <alltraps>

8010784b <vector125>:
.globl vector125
vector125:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $125
8010784d:	6a 7d                	push   $0x7d
  jmp alltraps
8010784f:	e9 12 f5 ff ff       	jmp    80106d66 <alltraps>

80107854 <vector126>:
.globl vector126
vector126:
  pushl $0
80107854:	6a 00                	push   $0x0
  pushl $126
80107856:	6a 7e                	push   $0x7e
  jmp alltraps
80107858:	e9 09 f5 ff ff       	jmp    80106d66 <alltraps>

8010785d <vector127>:
.globl vector127
vector127:
  pushl $0
8010785d:	6a 00                	push   $0x0
  pushl $127
8010785f:	6a 7f                	push   $0x7f
  jmp alltraps
80107861:	e9 00 f5 ff ff       	jmp    80106d66 <alltraps>

80107866 <vector128>:
.globl vector128
vector128:
  pushl $0
80107866:	6a 00                	push   $0x0
  pushl $128
80107868:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010786d:	e9 f4 f4 ff ff       	jmp    80106d66 <alltraps>

80107872 <vector129>:
.globl vector129
vector129:
  pushl $0
80107872:	6a 00                	push   $0x0
  pushl $129
80107874:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107879:	e9 e8 f4 ff ff       	jmp    80106d66 <alltraps>

8010787e <vector130>:
.globl vector130
vector130:
  pushl $0
8010787e:	6a 00                	push   $0x0
  pushl $130
80107880:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107885:	e9 dc f4 ff ff       	jmp    80106d66 <alltraps>

8010788a <vector131>:
.globl vector131
vector131:
  pushl $0
8010788a:	6a 00                	push   $0x0
  pushl $131
8010788c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107891:	e9 d0 f4 ff ff       	jmp    80106d66 <alltraps>

80107896 <vector132>:
.globl vector132
vector132:
  pushl $0
80107896:	6a 00                	push   $0x0
  pushl $132
80107898:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010789d:	e9 c4 f4 ff ff       	jmp    80106d66 <alltraps>

801078a2 <vector133>:
.globl vector133
vector133:
  pushl $0
801078a2:	6a 00                	push   $0x0
  pushl $133
801078a4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078a9:	e9 b8 f4 ff ff       	jmp    80106d66 <alltraps>

801078ae <vector134>:
.globl vector134
vector134:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $134
801078b0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078b5:	e9 ac f4 ff ff       	jmp    80106d66 <alltraps>

801078ba <vector135>:
.globl vector135
vector135:
  pushl $0
801078ba:	6a 00                	push   $0x0
  pushl $135
801078bc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078c1:	e9 a0 f4 ff ff       	jmp    80106d66 <alltraps>

801078c6 <vector136>:
.globl vector136
vector136:
  pushl $0
801078c6:	6a 00                	push   $0x0
  pushl $136
801078c8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801078cd:	e9 94 f4 ff ff       	jmp    80106d66 <alltraps>

801078d2 <vector137>:
.globl vector137
vector137:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $137
801078d4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801078d9:	e9 88 f4 ff ff       	jmp    80106d66 <alltraps>

801078de <vector138>:
.globl vector138
vector138:
  pushl $0
801078de:	6a 00                	push   $0x0
  pushl $138
801078e0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801078e5:	e9 7c f4 ff ff       	jmp    80106d66 <alltraps>

801078ea <vector139>:
.globl vector139
vector139:
  pushl $0
801078ea:	6a 00                	push   $0x0
  pushl $139
801078ec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801078f1:	e9 70 f4 ff ff       	jmp    80106d66 <alltraps>

801078f6 <vector140>:
.globl vector140
vector140:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $140
801078f8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801078fd:	e9 64 f4 ff ff       	jmp    80106d66 <alltraps>

80107902 <vector141>:
.globl vector141
vector141:
  pushl $0
80107902:	6a 00                	push   $0x0
  pushl $141
80107904:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107909:	e9 58 f4 ff ff       	jmp    80106d66 <alltraps>

8010790e <vector142>:
.globl vector142
vector142:
  pushl $0
8010790e:	6a 00                	push   $0x0
  pushl $142
80107910:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107915:	e9 4c f4 ff ff       	jmp    80106d66 <alltraps>

8010791a <vector143>:
.globl vector143
vector143:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $143
8010791c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107921:	e9 40 f4 ff ff       	jmp    80106d66 <alltraps>

80107926 <vector144>:
.globl vector144
vector144:
  pushl $0
80107926:	6a 00                	push   $0x0
  pushl $144
80107928:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010792d:	e9 34 f4 ff ff       	jmp    80106d66 <alltraps>

80107932 <vector145>:
.globl vector145
vector145:
  pushl $0
80107932:	6a 00                	push   $0x0
  pushl $145
80107934:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107939:	e9 28 f4 ff ff       	jmp    80106d66 <alltraps>

8010793e <vector146>:
.globl vector146
vector146:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $146
80107940:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107945:	e9 1c f4 ff ff       	jmp    80106d66 <alltraps>

8010794a <vector147>:
.globl vector147
vector147:
  pushl $0
8010794a:	6a 00                	push   $0x0
  pushl $147
8010794c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107951:	e9 10 f4 ff ff       	jmp    80106d66 <alltraps>

80107956 <vector148>:
.globl vector148
vector148:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $148
80107958:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010795d:	e9 04 f4 ff ff       	jmp    80106d66 <alltraps>

80107962 <vector149>:
.globl vector149
vector149:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $149
80107964:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107969:	e9 f8 f3 ff ff       	jmp    80106d66 <alltraps>

8010796e <vector150>:
.globl vector150
vector150:
  pushl $0
8010796e:	6a 00                	push   $0x0
  pushl $150
80107970:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107975:	e9 ec f3 ff ff       	jmp    80106d66 <alltraps>

8010797a <vector151>:
.globl vector151
vector151:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $151
8010797c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107981:	e9 e0 f3 ff ff       	jmp    80106d66 <alltraps>

80107986 <vector152>:
.globl vector152
vector152:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $152
80107988:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010798d:	e9 d4 f3 ff ff       	jmp    80106d66 <alltraps>

80107992 <vector153>:
.globl vector153
vector153:
  pushl $0
80107992:	6a 00                	push   $0x0
  pushl $153
80107994:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107999:	e9 c8 f3 ff ff       	jmp    80106d66 <alltraps>

8010799e <vector154>:
.globl vector154
vector154:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $154
801079a0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079a5:	e9 bc f3 ff ff       	jmp    80106d66 <alltraps>

801079aa <vector155>:
.globl vector155
vector155:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $155
801079ac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079b1:	e9 b0 f3 ff ff       	jmp    80106d66 <alltraps>

801079b6 <vector156>:
.globl vector156
vector156:
  pushl $0
801079b6:	6a 00                	push   $0x0
  pushl $156
801079b8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079bd:	e9 a4 f3 ff ff       	jmp    80106d66 <alltraps>

801079c2 <vector157>:
.globl vector157
vector157:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $157
801079c4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801079c9:	e9 98 f3 ff ff       	jmp    80106d66 <alltraps>

801079ce <vector158>:
.globl vector158
vector158:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $158
801079d0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801079d5:	e9 8c f3 ff ff       	jmp    80106d66 <alltraps>

801079da <vector159>:
.globl vector159
vector159:
  pushl $0
801079da:	6a 00                	push   $0x0
  pushl $159
801079dc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801079e1:	e9 80 f3 ff ff       	jmp    80106d66 <alltraps>

801079e6 <vector160>:
.globl vector160
vector160:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $160
801079e8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801079ed:	e9 74 f3 ff ff       	jmp    80106d66 <alltraps>

801079f2 <vector161>:
.globl vector161
vector161:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $161
801079f4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801079f9:	e9 68 f3 ff ff       	jmp    80106d66 <alltraps>

801079fe <vector162>:
.globl vector162
vector162:
  pushl $0
801079fe:	6a 00                	push   $0x0
  pushl $162
80107a00:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a05:	e9 5c f3 ff ff       	jmp    80106d66 <alltraps>

80107a0a <vector163>:
.globl vector163
vector163:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $163
80107a0c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a11:	e9 50 f3 ff ff       	jmp    80106d66 <alltraps>

80107a16 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $164
80107a18:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a1d:	e9 44 f3 ff ff       	jmp    80106d66 <alltraps>

80107a22 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a22:	6a 00                	push   $0x0
  pushl $165
80107a24:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a29:	e9 38 f3 ff ff       	jmp    80106d66 <alltraps>

80107a2e <vector166>:
.globl vector166
vector166:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $166
80107a30:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a35:	e9 2c f3 ff ff       	jmp    80106d66 <alltraps>

80107a3a <vector167>:
.globl vector167
vector167:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $167
80107a3c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a41:	e9 20 f3 ff ff       	jmp    80106d66 <alltraps>

80107a46 <vector168>:
.globl vector168
vector168:
  pushl $0
80107a46:	6a 00                	push   $0x0
  pushl $168
80107a48:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a4d:	e9 14 f3 ff ff       	jmp    80106d66 <alltraps>

80107a52 <vector169>:
.globl vector169
vector169:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $169
80107a54:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a59:	e9 08 f3 ff ff       	jmp    80106d66 <alltraps>

80107a5e <vector170>:
.globl vector170
vector170:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $170
80107a60:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a65:	e9 fc f2 ff ff       	jmp    80106d66 <alltraps>

80107a6a <vector171>:
.globl vector171
vector171:
  pushl $0
80107a6a:	6a 00                	push   $0x0
  pushl $171
80107a6c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107a71:	e9 f0 f2 ff ff       	jmp    80106d66 <alltraps>

80107a76 <vector172>:
.globl vector172
vector172:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $172
80107a78:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107a7d:	e9 e4 f2 ff ff       	jmp    80106d66 <alltraps>

80107a82 <vector173>:
.globl vector173
vector173:
  pushl $0
80107a82:	6a 00                	push   $0x0
  pushl $173
80107a84:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107a89:	e9 d8 f2 ff ff       	jmp    80106d66 <alltraps>

80107a8e <vector174>:
.globl vector174
vector174:
  pushl $0
80107a8e:	6a 00                	push   $0x0
  pushl $174
80107a90:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107a95:	e9 cc f2 ff ff       	jmp    80106d66 <alltraps>

80107a9a <vector175>:
.globl vector175
vector175:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $175
80107a9c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107aa1:	e9 c0 f2 ff ff       	jmp    80106d66 <alltraps>

80107aa6 <vector176>:
.globl vector176
vector176:
  pushl $0
80107aa6:	6a 00                	push   $0x0
  pushl $176
80107aa8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107aad:	e9 b4 f2 ff ff       	jmp    80106d66 <alltraps>

80107ab2 <vector177>:
.globl vector177
vector177:
  pushl $0
80107ab2:	6a 00                	push   $0x0
  pushl $177
80107ab4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107ab9:	e9 a8 f2 ff ff       	jmp    80106d66 <alltraps>

80107abe <vector178>:
.globl vector178
vector178:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $178
80107ac0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107ac5:	e9 9c f2 ff ff       	jmp    80106d66 <alltraps>

80107aca <vector179>:
.globl vector179
vector179:
  pushl $0
80107aca:	6a 00                	push   $0x0
  pushl $179
80107acc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107ad1:	e9 90 f2 ff ff       	jmp    80106d66 <alltraps>

80107ad6 <vector180>:
.globl vector180
vector180:
  pushl $0
80107ad6:	6a 00                	push   $0x0
  pushl $180
80107ad8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107add:	e9 84 f2 ff ff       	jmp    80106d66 <alltraps>

80107ae2 <vector181>:
.globl vector181
vector181:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $181
80107ae4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107ae9:	e9 78 f2 ff ff       	jmp    80106d66 <alltraps>

80107aee <vector182>:
.globl vector182
vector182:
  pushl $0
80107aee:	6a 00                	push   $0x0
  pushl $182
80107af0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107af5:	e9 6c f2 ff ff       	jmp    80106d66 <alltraps>

80107afa <vector183>:
.globl vector183
vector183:
  pushl $0
80107afa:	6a 00                	push   $0x0
  pushl $183
80107afc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b01:	e9 60 f2 ff ff       	jmp    80106d66 <alltraps>

80107b06 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $184
80107b08:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b0d:	e9 54 f2 ff ff       	jmp    80106d66 <alltraps>

80107b12 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b12:	6a 00                	push   $0x0
  pushl $185
80107b14:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b19:	e9 48 f2 ff ff       	jmp    80106d66 <alltraps>

80107b1e <vector186>:
.globl vector186
vector186:
  pushl $0
80107b1e:	6a 00                	push   $0x0
  pushl $186
80107b20:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b25:	e9 3c f2 ff ff       	jmp    80106d66 <alltraps>

80107b2a <vector187>:
.globl vector187
vector187:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $187
80107b2c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b31:	e9 30 f2 ff ff       	jmp    80106d66 <alltraps>

80107b36 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b36:	6a 00                	push   $0x0
  pushl $188
80107b38:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b3d:	e9 24 f2 ff ff       	jmp    80106d66 <alltraps>

80107b42 <vector189>:
.globl vector189
vector189:
  pushl $0
80107b42:	6a 00                	push   $0x0
  pushl $189
80107b44:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b49:	e9 18 f2 ff ff       	jmp    80106d66 <alltraps>

80107b4e <vector190>:
.globl vector190
vector190:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $190
80107b50:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b55:	e9 0c f2 ff ff       	jmp    80106d66 <alltraps>

80107b5a <vector191>:
.globl vector191
vector191:
  pushl $0
80107b5a:	6a 00                	push   $0x0
  pushl $191
80107b5c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b61:	e9 00 f2 ff ff       	jmp    80106d66 <alltraps>

80107b66 <vector192>:
.globl vector192
vector192:
  pushl $0
80107b66:	6a 00                	push   $0x0
  pushl $192
80107b68:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107b6d:	e9 f4 f1 ff ff       	jmp    80106d66 <alltraps>

80107b72 <vector193>:
.globl vector193
vector193:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $193
80107b74:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107b79:	e9 e8 f1 ff ff       	jmp    80106d66 <alltraps>

80107b7e <vector194>:
.globl vector194
vector194:
  pushl $0
80107b7e:	6a 00                	push   $0x0
  pushl $194
80107b80:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107b85:	e9 dc f1 ff ff       	jmp    80106d66 <alltraps>

80107b8a <vector195>:
.globl vector195
vector195:
  pushl $0
80107b8a:	6a 00                	push   $0x0
  pushl $195
80107b8c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107b91:	e9 d0 f1 ff ff       	jmp    80106d66 <alltraps>

80107b96 <vector196>:
.globl vector196
vector196:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $196
80107b98:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107b9d:	e9 c4 f1 ff ff       	jmp    80106d66 <alltraps>

80107ba2 <vector197>:
.globl vector197
vector197:
  pushl $0
80107ba2:	6a 00                	push   $0x0
  pushl $197
80107ba4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107ba9:	e9 b8 f1 ff ff       	jmp    80106d66 <alltraps>

80107bae <vector198>:
.globl vector198
vector198:
  pushl $0
80107bae:	6a 00                	push   $0x0
  pushl $198
80107bb0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107bb5:	e9 ac f1 ff ff       	jmp    80106d66 <alltraps>

80107bba <vector199>:
.globl vector199
vector199:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $199
80107bbc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bc1:	e9 a0 f1 ff ff       	jmp    80106d66 <alltraps>

80107bc6 <vector200>:
.globl vector200
vector200:
  pushl $0
80107bc6:	6a 00                	push   $0x0
  pushl $200
80107bc8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107bcd:	e9 94 f1 ff ff       	jmp    80106d66 <alltraps>

80107bd2 <vector201>:
.globl vector201
vector201:
  pushl $0
80107bd2:	6a 00                	push   $0x0
  pushl $201
80107bd4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107bd9:	e9 88 f1 ff ff       	jmp    80106d66 <alltraps>

80107bde <vector202>:
.globl vector202
vector202:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $202
80107be0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107be5:	e9 7c f1 ff ff       	jmp    80106d66 <alltraps>

80107bea <vector203>:
.globl vector203
vector203:
  pushl $0
80107bea:	6a 00                	push   $0x0
  pushl $203
80107bec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107bf1:	e9 70 f1 ff ff       	jmp    80106d66 <alltraps>

80107bf6 <vector204>:
.globl vector204
vector204:
  pushl $0
80107bf6:	6a 00                	push   $0x0
  pushl $204
80107bf8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107bfd:	e9 64 f1 ff ff       	jmp    80106d66 <alltraps>

80107c02 <vector205>:
.globl vector205
vector205:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $205
80107c04:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c09:	e9 58 f1 ff ff       	jmp    80106d66 <alltraps>

80107c0e <vector206>:
.globl vector206
vector206:
  pushl $0
80107c0e:	6a 00                	push   $0x0
  pushl $206
80107c10:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c15:	e9 4c f1 ff ff       	jmp    80106d66 <alltraps>

80107c1a <vector207>:
.globl vector207
vector207:
  pushl $0
80107c1a:	6a 00                	push   $0x0
  pushl $207
80107c1c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c21:	e9 40 f1 ff ff       	jmp    80106d66 <alltraps>

80107c26 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $208
80107c28:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c2d:	e9 34 f1 ff ff       	jmp    80106d66 <alltraps>

80107c32 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c32:	6a 00                	push   $0x0
  pushl $209
80107c34:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c39:	e9 28 f1 ff ff       	jmp    80106d66 <alltraps>

80107c3e <vector210>:
.globl vector210
vector210:
  pushl $0
80107c3e:	6a 00                	push   $0x0
  pushl $210
80107c40:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c45:	e9 1c f1 ff ff       	jmp    80106d66 <alltraps>

80107c4a <vector211>:
.globl vector211
vector211:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $211
80107c4c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c51:	e9 10 f1 ff ff       	jmp    80106d66 <alltraps>

80107c56 <vector212>:
.globl vector212
vector212:
  pushl $0
80107c56:	6a 00                	push   $0x0
  pushl $212
80107c58:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c5d:	e9 04 f1 ff ff       	jmp    80106d66 <alltraps>

80107c62 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c62:	6a 00                	push   $0x0
  pushl $213
80107c64:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107c69:	e9 f8 f0 ff ff       	jmp    80106d66 <alltraps>

80107c6e <vector214>:
.globl vector214
vector214:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $214
80107c70:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107c75:	e9 ec f0 ff ff       	jmp    80106d66 <alltraps>

80107c7a <vector215>:
.globl vector215
vector215:
  pushl $0
80107c7a:	6a 00                	push   $0x0
  pushl $215
80107c7c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107c81:	e9 e0 f0 ff ff       	jmp    80106d66 <alltraps>

80107c86 <vector216>:
.globl vector216
vector216:
  pushl $0
80107c86:	6a 00                	push   $0x0
  pushl $216
80107c88:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107c8d:	e9 d4 f0 ff ff       	jmp    80106d66 <alltraps>

80107c92 <vector217>:
.globl vector217
vector217:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $217
80107c94:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107c99:	e9 c8 f0 ff ff       	jmp    80106d66 <alltraps>

80107c9e <vector218>:
.globl vector218
vector218:
  pushl $0
80107c9e:	6a 00                	push   $0x0
  pushl $218
80107ca0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ca5:	e9 bc f0 ff ff       	jmp    80106d66 <alltraps>

80107caa <vector219>:
.globl vector219
vector219:
  pushl $0
80107caa:	6a 00                	push   $0x0
  pushl $219
80107cac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107cb1:	e9 b0 f0 ff ff       	jmp    80106d66 <alltraps>

80107cb6 <vector220>:
.globl vector220
vector220:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $220
80107cb8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107cbd:	e9 a4 f0 ff ff       	jmp    80106d66 <alltraps>

80107cc2 <vector221>:
.globl vector221
vector221:
  pushl $0
80107cc2:	6a 00                	push   $0x0
  pushl $221
80107cc4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107cc9:	e9 98 f0 ff ff       	jmp    80106d66 <alltraps>

80107cce <vector222>:
.globl vector222
vector222:
  pushl $0
80107cce:	6a 00                	push   $0x0
  pushl $222
80107cd0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107cd5:	e9 8c f0 ff ff       	jmp    80106d66 <alltraps>

80107cda <vector223>:
.globl vector223
vector223:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $223
80107cdc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107ce1:	e9 80 f0 ff ff       	jmp    80106d66 <alltraps>

80107ce6 <vector224>:
.globl vector224
vector224:
  pushl $0
80107ce6:	6a 00                	push   $0x0
  pushl $224
80107ce8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107ced:	e9 74 f0 ff ff       	jmp    80106d66 <alltraps>

80107cf2 <vector225>:
.globl vector225
vector225:
  pushl $0
80107cf2:	6a 00                	push   $0x0
  pushl $225
80107cf4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107cf9:	e9 68 f0 ff ff       	jmp    80106d66 <alltraps>

80107cfe <vector226>:
.globl vector226
vector226:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $226
80107d00:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d05:	e9 5c f0 ff ff       	jmp    80106d66 <alltraps>

80107d0a <vector227>:
.globl vector227
vector227:
  pushl $0
80107d0a:	6a 00                	push   $0x0
  pushl $227
80107d0c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d11:	e9 50 f0 ff ff       	jmp    80106d66 <alltraps>

80107d16 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d16:	6a 00                	push   $0x0
  pushl $228
80107d18:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d1d:	e9 44 f0 ff ff       	jmp    80106d66 <alltraps>

80107d22 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $229
80107d24:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d29:	e9 38 f0 ff ff       	jmp    80106d66 <alltraps>

80107d2e <vector230>:
.globl vector230
vector230:
  pushl $0
80107d2e:	6a 00                	push   $0x0
  pushl $230
80107d30:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d35:	e9 2c f0 ff ff       	jmp    80106d66 <alltraps>

80107d3a <vector231>:
.globl vector231
vector231:
  pushl $0
80107d3a:	6a 00                	push   $0x0
  pushl $231
80107d3c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d41:	e9 20 f0 ff ff       	jmp    80106d66 <alltraps>

80107d46 <vector232>:
.globl vector232
vector232:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $232
80107d48:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d4d:	e9 14 f0 ff ff       	jmp    80106d66 <alltraps>

80107d52 <vector233>:
.globl vector233
vector233:
  pushl $0
80107d52:	6a 00                	push   $0x0
  pushl $233
80107d54:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d59:	e9 08 f0 ff ff       	jmp    80106d66 <alltraps>

80107d5e <vector234>:
.globl vector234
vector234:
  pushl $0
80107d5e:	6a 00                	push   $0x0
  pushl $234
80107d60:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d65:	e9 fc ef ff ff       	jmp    80106d66 <alltraps>

80107d6a <vector235>:
.globl vector235
vector235:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $235
80107d6c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107d71:	e9 f0 ef ff ff       	jmp    80106d66 <alltraps>

80107d76 <vector236>:
.globl vector236
vector236:
  pushl $0
80107d76:	6a 00                	push   $0x0
  pushl $236
80107d78:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107d7d:	e9 e4 ef ff ff       	jmp    80106d66 <alltraps>

80107d82 <vector237>:
.globl vector237
vector237:
  pushl $0
80107d82:	6a 00                	push   $0x0
  pushl $237
80107d84:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107d89:	e9 d8 ef ff ff       	jmp    80106d66 <alltraps>

80107d8e <vector238>:
.globl vector238
vector238:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $238
80107d90:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107d95:	e9 cc ef ff ff       	jmp    80106d66 <alltraps>

80107d9a <vector239>:
.globl vector239
vector239:
  pushl $0
80107d9a:	6a 00                	push   $0x0
  pushl $239
80107d9c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107da1:	e9 c0 ef ff ff       	jmp    80106d66 <alltraps>

80107da6 <vector240>:
.globl vector240
vector240:
  pushl $0
80107da6:	6a 00                	push   $0x0
  pushl $240
80107da8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107dad:	e9 b4 ef ff ff       	jmp    80106d66 <alltraps>

80107db2 <vector241>:
.globl vector241
vector241:
  pushl $0
80107db2:	6a 00                	push   $0x0
  pushl $241
80107db4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107db9:	e9 a8 ef ff ff       	jmp    80106d66 <alltraps>

80107dbe <vector242>:
.globl vector242
vector242:
  pushl $0
80107dbe:	6a 00                	push   $0x0
  pushl $242
80107dc0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107dc5:	e9 9c ef ff ff       	jmp    80106d66 <alltraps>

80107dca <vector243>:
.globl vector243
vector243:
  pushl $0
80107dca:	6a 00                	push   $0x0
  pushl $243
80107dcc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107dd1:	e9 90 ef ff ff       	jmp    80106d66 <alltraps>

80107dd6 <vector244>:
.globl vector244
vector244:
  pushl $0
80107dd6:	6a 00                	push   $0x0
  pushl $244
80107dd8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107ddd:	e9 84 ef ff ff       	jmp    80106d66 <alltraps>

80107de2 <vector245>:
.globl vector245
vector245:
  pushl $0
80107de2:	6a 00                	push   $0x0
  pushl $245
80107de4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107de9:	e9 78 ef ff ff       	jmp    80106d66 <alltraps>

80107dee <vector246>:
.globl vector246
vector246:
  pushl $0
80107dee:	6a 00                	push   $0x0
  pushl $246
80107df0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107df5:	e9 6c ef ff ff       	jmp    80106d66 <alltraps>

80107dfa <vector247>:
.globl vector247
vector247:
  pushl $0
80107dfa:	6a 00                	push   $0x0
  pushl $247
80107dfc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e01:	e9 60 ef ff ff       	jmp    80106d66 <alltraps>

80107e06 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e06:	6a 00                	push   $0x0
  pushl $248
80107e08:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e0d:	e9 54 ef ff ff       	jmp    80106d66 <alltraps>

80107e12 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e12:	6a 00                	push   $0x0
  pushl $249
80107e14:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e19:	e9 48 ef ff ff       	jmp    80106d66 <alltraps>

80107e1e <vector250>:
.globl vector250
vector250:
  pushl $0
80107e1e:	6a 00                	push   $0x0
  pushl $250
80107e20:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e25:	e9 3c ef ff ff       	jmp    80106d66 <alltraps>

80107e2a <vector251>:
.globl vector251
vector251:
  pushl $0
80107e2a:	6a 00                	push   $0x0
  pushl $251
80107e2c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e31:	e9 30 ef ff ff       	jmp    80106d66 <alltraps>

80107e36 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e36:	6a 00                	push   $0x0
  pushl $252
80107e38:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e3d:	e9 24 ef ff ff       	jmp    80106d66 <alltraps>

80107e42 <vector253>:
.globl vector253
vector253:
  pushl $0
80107e42:	6a 00                	push   $0x0
  pushl $253
80107e44:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e49:	e9 18 ef ff ff       	jmp    80106d66 <alltraps>

80107e4e <vector254>:
.globl vector254
vector254:
  pushl $0
80107e4e:	6a 00                	push   $0x0
  pushl $254
80107e50:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e55:	e9 0c ef ff ff       	jmp    80106d66 <alltraps>

80107e5a <vector255>:
.globl vector255
vector255:
  pushl $0
80107e5a:	6a 00                	push   $0x0
  pushl $255
80107e5c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e61:	e9 00 ef ff ff       	jmp    80106d66 <alltraps>

80107e66 <lgdt>:
{
80107e66:	55                   	push   %ebp
80107e67:	89 e5                	mov    %esp,%ebp
80107e69:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e6f:	83 e8 01             	sub    $0x1,%eax
80107e72:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107e76:	8b 45 08             	mov    0x8(%ebp),%eax
80107e79:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e80:	c1 e8 10             	shr    $0x10,%eax
80107e83:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107e87:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107e8a:	0f 01 10             	lgdtl  (%eax)
}
80107e8d:	90                   	nop
80107e8e:	c9                   	leave  
80107e8f:	c3                   	ret    

80107e90 <ltr>:
{
80107e90:	55                   	push   %ebp
80107e91:	89 e5                	mov    %esp,%ebp
80107e93:	83 ec 04             	sub    $0x4,%esp
80107e96:	8b 45 08             	mov    0x8(%ebp),%eax
80107e99:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107e9d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107ea1:	0f 00 d8             	ltr    %ax
}
80107ea4:	90                   	nop
80107ea5:	c9                   	leave  
80107ea6:	c3                   	ret    

80107ea7 <lcr3>:

static inline void
lcr3(uint val)
{
80107ea7:	55                   	push   %ebp
80107ea8:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80107ead:	0f 22 d8             	mov    %eax,%cr3
}
80107eb0:	90                   	nop
80107eb1:	5d                   	pop    %ebp
80107eb2:	c3                   	ret    

80107eb3 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107eb3:	f3 0f 1e fb          	endbr32 
80107eb7:	55                   	push   %ebp
80107eb8:	89 e5                	mov    %esp,%ebp
80107eba:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107ebd:	e8 64 c6 ff ff       	call   80104526 <cpuid>
80107ec2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107ec8:	05 20 58 11 80       	add    $0x80115820,%eax
80107ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ed3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edc:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ee5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eec:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107ef0:	83 e2 f0             	and    $0xfffffff0,%edx
80107ef3:	83 ca 0a             	or     $0xa,%edx
80107ef6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f00:	83 ca 10             	or     $0x10,%edx
80107f03:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f09:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f0d:	83 e2 9f             	and    $0xffffff9f,%edx
80107f10:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f16:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f1a:	83 ca 80             	or     $0xffffff80,%edx
80107f1d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f23:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f27:	83 ca 0f             	or     $0xf,%edx
80107f2a:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f30:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f34:	83 e2 ef             	and    $0xffffffef,%edx
80107f37:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f41:	83 e2 df             	and    $0xffffffdf,%edx
80107f44:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f4a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f4e:	83 ca 40             	or     $0x40,%edx
80107f51:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f57:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f5b:	83 ca 80             	or     $0xffffff80,%edx
80107f5e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f64:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f6b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107f72:	ff ff 
80107f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f77:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107f7e:	00 00 
80107f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f83:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107f94:	83 e2 f0             	and    $0xfffffff0,%edx
80107f97:	83 ca 02             	or     $0x2,%edx
80107f9a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107faa:	83 ca 10             	or     $0x10,%edx
80107fad:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fbd:	83 e2 9f             	and    $0xffffff9f,%edx
80107fc0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107fd0:	83 ca 80             	or     $0xffffff80,%edx
80107fd3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdc:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107fe3:	83 ca 0f             	or     $0xf,%edx
80107fe6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fef:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107ff6:	83 e2 ef             	and    $0xffffffef,%edx
80107ff9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108002:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108009:	83 e2 df             	and    $0xffffffdf,%edx
8010800c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108015:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010801c:	83 ca 40             	or     $0x40,%edx
8010801f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108028:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010802f:	83 ca 80             	or     $0xffffff80,%edx
80108032:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010804c:	ff ff 
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80108058:	00 00 
8010805a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805d:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108067:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010806e:	83 e2 f0             	and    $0xfffffff0,%edx
80108071:	83 ca 0a             	or     $0xa,%edx
80108074:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010807a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108084:	83 ca 10             	or     $0x10,%edx
80108087:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010808d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108090:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108097:	83 ca 60             	or     $0x60,%edx
8010809a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801080aa:	83 ca 80             	or     $0xffffff80,%edx
801080ad:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801080b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080bd:	83 ca 0f             	or     $0xf,%edx
801080c0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080d0:	83 e2 ef             	and    $0xffffffef,%edx
801080d3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080e3:	83 e2 df             	and    $0xffffffdf,%edx
801080e6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ef:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801080f6:	83 ca 40             	or     $0x40,%edx
801080f9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801080ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108102:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108109:	83 ca 80             	or     $0xffffff80,%edx
8010810c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010811c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811f:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108126:	ff ff 
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108132:	00 00 
80108134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108137:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010813e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108141:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108148:	83 e2 f0             	and    $0xfffffff0,%edx
8010814b:	83 ca 02             	or     $0x2,%edx
8010814e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108157:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010815e:	83 ca 10             	or     $0x10,%edx
80108161:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108171:	83 ca 60             	or     $0x60,%edx
80108174:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010817a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108184:	83 ca 80             	or     $0xffffff80,%edx
80108187:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010818d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108190:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108197:	83 ca 0f             	or     $0xf,%edx
8010819a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081aa:	83 e2 ef             	and    $0xffffffef,%edx
801081ad:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081bd:	83 e2 df             	and    $0xffffffdf,%edx
801081c0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081d0:	83 ca 40             	or     $0x40,%edx
801081d3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081dc:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801081e3:	83 ca 80             	or     $0xffffff80,%edx
801081e6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ef:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801081f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f9:	83 c0 70             	add    $0x70,%eax
801081fc:	83 ec 08             	sub    $0x8,%esp
801081ff:	6a 30                	push   $0x30
80108201:	50                   	push   %eax
80108202:	e8 5f fc ff ff       	call   80107e66 <lgdt>
80108207:	83 c4 10             	add    $0x10,%esp
}
8010820a:	90                   	nop
8010820b:	c9                   	leave  
8010820c:	c3                   	ret    

8010820d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010820d:	f3 0f 1e fb          	endbr32 
80108211:	55                   	push   %ebp
80108212:	89 e5                	mov    %esp,%ebp
80108214:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010821a:	c1 e8 16             	shr    $0x16,%eax
8010821d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108224:	8b 45 08             	mov    0x8(%ebp),%eax
80108227:	01 d0                	add    %edx,%eax
80108229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010822c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010822f:	8b 00                	mov    (%eax),%eax
80108231:	83 e0 01             	and    $0x1,%eax
80108234:	85 c0                	test   %eax,%eax
80108236:	74 14                	je     8010824c <walkpgdir+0x3f>
    //if (!alloc)
      //cprintf("page directory is good\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108238:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010823b:	8b 00                	mov    (%eax),%eax
8010823d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108242:	05 00 00 00 80       	add    $0x80000000,%eax
80108247:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010824a:	eb 42                	jmp    8010828e <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010824c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108250:	74 0e                	je     80108260 <walkpgdir+0x53>
80108252:	e8 a6 ac ff ff       	call   80102efd <kalloc>
80108257:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010825a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010825e:	75 07                	jne    80108267 <walkpgdir+0x5a>
      return 0;
80108260:	b8 00 00 00 00       	mov    $0x0,%eax
80108265:	eb 3e                	jmp    801082a5 <walkpgdir+0x98>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108267:	83 ec 04             	sub    $0x4,%esp
8010826a:	68 00 10 00 00       	push   $0x1000
8010826f:	6a 00                	push   $0x0
80108271:	ff 75 f4             	pushl  -0xc(%ebp)
80108274:	e8 8f d5 ff ff       	call   80105808 <memset>
80108279:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010827c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827f:	05 00 00 00 80       	add    $0x80000000,%eax
80108284:	83 c8 07             	or     $0x7,%eax
80108287:	89 c2                	mov    %eax,%edx
80108289:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010828c:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010828e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108291:	c1 e8 0c             	shr    $0xc,%eax
80108294:	25 ff 03 00 00       	and    $0x3ff,%eax
80108299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801082a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a3:	01 d0                	add    %edx,%eax
}
801082a5:	c9                   	leave  
801082a6:	c3                   	ret    

801082a7 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801082a7:	f3 0f 1e fb          	endbr32 
801082ab:	55                   	push   %ebp
801082ac:	89 e5                	mov    %esp,%ebp
801082ae:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801082b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801082b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801082bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801082bf:	8b 45 10             	mov    0x10(%ebp),%eax
801082c2:	01 d0                	add    %edx,%eax
801082c4:	83 e8 01             	sub    $0x1,%eax
801082c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801082cf:	83 ec 04             	sub    $0x4,%esp
801082d2:	6a 01                	push   $0x1
801082d4:	ff 75 f4             	pushl  -0xc(%ebp)
801082d7:	ff 75 08             	pushl  0x8(%ebp)
801082da:	e8 2e ff ff ff       	call   8010820d <walkpgdir>
801082df:	83 c4 10             	add    $0x10,%esp
801082e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082e9:	75 07                	jne    801082f2 <mappages+0x4b>
      return -1;
801082eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082f0:	eb 6a                	jmp    8010835c <mappages+0xb5>
    if(*pte & (PTE_P | PTE_E))
801082f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082f5:	8b 00                	mov    (%eax),%eax
801082f7:	25 01 04 00 00       	and    $0x401,%eax
801082fc:	85 c0                	test   %eax,%eax
801082fe:	74 0d                	je     8010830d <mappages+0x66>
      panic("p4Debug, remapping page");
80108300:	83 ec 0c             	sub    $0xc,%esp
80108303:	68 5c 9c 10 80       	push   $0x80109c5c
80108308:	e8 fb 82 ff ff       	call   80100608 <panic>

    if (perm & PTE_E)
8010830d:	8b 45 18             	mov    0x18(%ebp),%eax
80108310:	25 00 04 00 00       	and    $0x400,%eax
80108315:	85 c0                	test   %eax,%eax
80108317:	74 12                	je     8010832b <mappages+0x84>
      *pte = pa | perm | PTE_E;
80108319:	8b 45 18             	mov    0x18(%ebp),%eax
8010831c:	0b 45 14             	or     0x14(%ebp),%eax
8010831f:	80 cc 04             	or     $0x4,%ah
80108322:	89 c2                	mov    %eax,%edx
80108324:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108327:	89 10                	mov    %edx,(%eax)
80108329:	eb 10                	jmp    8010833b <mappages+0x94>
    else
      *pte = pa | perm | PTE_P;
8010832b:	8b 45 18             	mov    0x18(%ebp),%eax
8010832e:	0b 45 14             	or     0x14(%ebp),%eax
80108331:	83 c8 01             	or     $0x1,%eax
80108334:	89 c2                	mov    %eax,%edx
80108336:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108339:	89 10                	mov    %edx,(%eax)


    if(a == last)
8010833b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108341:	74 13                	je     80108356 <mappages+0xaf>
      break;
    a += PGSIZE;
80108343:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010834a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108351:	e9 79 ff ff ff       	jmp    801082cf <mappages+0x28>
      break;
80108356:	90                   	nop
  }
  return 0;
80108357:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010835c:	c9                   	leave  
8010835d:	c3                   	ret    

8010835e <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010835e:	f3 0f 1e fb          	endbr32 
80108362:	55                   	push   %ebp
80108363:	89 e5                	mov    %esp,%ebp
80108365:	53                   	push   %ebx
80108366:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108369:	e8 8f ab ff ff       	call   80102efd <kalloc>
8010836e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108371:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108375:	75 07                	jne    8010837e <setupkvm+0x20>
    return 0;
80108377:	b8 00 00 00 00       	mov    $0x0,%eax
8010837c:	eb 78                	jmp    801083f6 <setupkvm+0x98>
  memset(pgdir, 0, PGSIZE);
8010837e:	83 ec 04             	sub    $0x4,%esp
80108381:	68 00 10 00 00       	push   $0x1000
80108386:	6a 00                	push   $0x0
80108388:	ff 75 f0             	pushl  -0x10(%ebp)
8010838b:	e8 78 d4 ff ff       	call   80105808 <memset>
80108390:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108393:	c7 45 f4 a0 d4 10 80 	movl   $0x8010d4a0,-0xc(%ebp)
8010839a:	eb 4e                	jmp    801083ea <setupkvm+0x8c>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010839c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0) {
801083a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a5:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801083a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ab:	8b 58 08             	mov    0x8(%eax),%ebx
801083ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b1:	8b 40 04             	mov    0x4(%eax),%eax
801083b4:	29 c3                	sub    %eax,%ebx
801083b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b9:	8b 00                	mov    (%eax),%eax
801083bb:	83 ec 0c             	sub    $0xc,%esp
801083be:	51                   	push   %ecx
801083bf:	52                   	push   %edx
801083c0:	53                   	push   %ebx
801083c1:	50                   	push   %eax
801083c2:	ff 75 f0             	pushl  -0x10(%ebp)
801083c5:	e8 dd fe ff ff       	call   801082a7 <mappages>
801083ca:	83 c4 20             	add    $0x20,%esp
801083cd:	85 c0                	test   %eax,%eax
801083cf:	79 15                	jns    801083e6 <setupkvm+0x88>
      freevm(pgdir);
801083d1:	83 ec 0c             	sub    $0xc,%esp
801083d4:	ff 75 f0             	pushl  -0x10(%ebp)
801083d7:	e8 13 05 00 00       	call   801088ef <freevm>
801083dc:	83 c4 10             	add    $0x10,%esp
      return 0;
801083df:	b8 00 00 00 00       	mov    $0x0,%eax
801083e4:	eb 10                	jmp    801083f6 <setupkvm+0x98>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801083e6:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801083ea:	81 7d f4 e0 d4 10 80 	cmpl   $0x8010d4e0,-0xc(%ebp)
801083f1:	72 a9                	jb     8010839c <setupkvm+0x3e>
    }
  return pgdir;
801083f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801083f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801083f9:	c9                   	leave  
801083fa:	c3                   	ret    

801083fb <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801083fb:	f3 0f 1e fb          	endbr32 
801083ff:	55                   	push   %ebp
80108400:	89 e5                	mov    %esp,%ebp
80108402:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108405:	e8 54 ff ff ff       	call   8010835e <setupkvm>
8010840a:	a3 44 a7 11 80       	mov    %eax,0x8011a744
  switchkvm();
8010840f:	e8 03 00 00 00       	call   80108417 <switchkvm>
}
80108414:	90                   	nop
80108415:	c9                   	leave  
80108416:	c3                   	ret    

80108417 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108417:	f3 0f 1e fb          	endbr32 
8010841b:	55                   	push   %ebp
8010841c:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010841e:	a1 44 a7 11 80       	mov    0x8011a744,%eax
80108423:	05 00 00 00 80       	add    $0x80000000,%eax
80108428:	50                   	push   %eax
80108429:	e8 79 fa ff ff       	call   80107ea7 <lcr3>
8010842e:	83 c4 04             	add    $0x4,%esp
}
80108431:	90                   	nop
80108432:	c9                   	leave  
80108433:	c3                   	ret    

80108434 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108434:	f3 0f 1e fb          	endbr32 
80108438:	55                   	push   %ebp
80108439:	89 e5                	mov    %esp,%ebp
8010843b:	56                   	push   %esi
8010843c:	53                   	push   %ebx
8010843d:	83 ec 10             	sub    $0x10,%esp
  if(p == 0)
80108440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108444:	75 0d                	jne    80108453 <switchuvm+0x1f>
    panic("switchuvm: no process");
80108446:	83 ec 0c             	sub    $0xc,%esp
80108449:	68 74 9c 10 80       	push   $0x80109c74
8010844e:	e8 b5 81 ff ff       	call   80100608 <panic>
  if(p->kstack == 0)
80108453:	8b 45 08             	mov    0x8(%ebp),%eax
80108456:	8b 40 08             	mov    0x8(%eax),%eax
80108459:	85 c0                	test   %eax,%eax
8010845b:	75 0d                	jne    8010846a <switchuvm+0x36>
    panic("switchuvm: no kstack");
8010845d:	83 ec 0c             	sub    $0xc,%esp
80108460:	68 8a 9c 10 80       	push   $0x80109c8a
80108465:	e8 9e 81 ff ff       	call   80100608 <panic>
  if(p->pgdir == 0)
8010846a:	8b 45 08             	mov    0x8(%ebp),%eax
8010846d:	8b 40 04             	mov    0x4(%eax),%eax
80108470:	85 c0                	test   %eax,%eax
80108472:	75 0d                	jne    80108481 <switchuvm+0x4d>
    panic("switchuvm: no pgdir");
80108474:	83 ec 0c             	sub    $0xc,%esp
80108477:	68 9f 9c 10 80       	push   $0x80109c9f
8010847c:	e8 87 81 ff ff       	call   80100608 <panic>

  pushcli();
80108481:	e8 6f d2 ff ff       	call   801056f5 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108486:	e8 ba c0 ff ff       	call   80104545 <mycpu>
8010848b:	89 c3                	mov    %eax,%ebx
8010848d:	e8 b3 c0 ff ff       	call   80104545 <mycpu>
80108492:	83 c0 08             	add    $0x8,%eax
80108495:	89 c6                	mov    %eax,%esi
80108497:	e8 a9 c0 ff ff       	call   80104545 <mycpu>
8010849c:	83 c0 08             	add    $0x8,%eax
8010849f:	c1 e8 10             	shr    $0x10,%eax
801084a2:	88 45 f7             	mov    %al,-0x9(%ebp)
801084a5:	e8 9b c0 ff ff       	call   80104545 <mycpu>
801084aa:	83 c0 08             	add    $0x8,%eax
801084ad:	c1 e8 18             	shr    $0x18,%eax
801084b0:	89 c2                	mov    %eax,%edx
801084b2:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801084b9:	67 00 
801084bb:	66 89 b3 9a 00 00 00 	mov    %si,0x9a(%ebx)
801084c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
801084c6:	88 83 9c 00 00 00    	mov    %al,0x9c(%ebx)
801084cc:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801084d3:	83 e0 f0             	and    $0xfffffff0,%eax
801084d6:	83 c8 09             	or     $0x9,%eax
801084d9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801084df:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801084e6:	83 c8 10             	or     $0x10,%eax
801084e9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801084ef:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
801084f6:	83 e0 9f             	and    $0xffffff9f,%eax
801084f9:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
801084ff:	0f b6 83 9d 00 00 00 	movzbl 0x9d(%ebx),%eax
80108506:	83 c8 80             	or     $0xffffff80,%eax
80108509:	88 83 9d 00 00 00    	mov    %al,0x9d(%ebx)
8010850f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108516:	83 e0 f0             	and    $0xfffffff0,%eax
80108519:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010851f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108526:	83 e0 ef             	and    $0xffffffef,%eax
80108529:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010852f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108536:	83 e0 df             	and    $0xffffffdf,%eax
80108539:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010853f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108546:	83 c8 40             	or     $0x40,%eax
80108549:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010854f:	0f b6 83 9e 00 00 00 	movzbl 0x9e(%ebx),%eax
80108556:	83 e0 7f             	and    $0x7f,%eax
80108559:	88 83 9e 00 00 00    	mov    %al,0x9e(%ebx)
8010855f:	88 93 9f 00 00 00    	mov    %dl,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80108565:	e8 db bf ff ff       	call   80104545 <mycpu>
8010856a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108571:	83 e2 ef             	and    $0xffffffef,%edx
80108574:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010857a:	e8 c6 bf ff ff       	call   80104545 <mycpu>
8010857f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108585:	8b 45 08             	mov    0x8(%ebp),%eax
80108588:	8b 40 08             	mov    0x8(%eax),%eax
8010858b:	89 c3                	mov    %eax,%ebx
8010858d:	e8 b3 bf ff ff       	call   80104545 <mycpu>
80108592:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
80108598:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010859b:	e8 a5 bf ff ff       	call   80104545 <mycpu>
801085a0:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801085a6:	83 ec 0c             	sub    $0xc,%esp
801085a9:	6a 28                	push   $0x28
801085ab:	e8 e0 f8 ff ff       	call   80107e90 <ltr>
801085b0:	83 c4 10             	add    $0x10,%esp
  lcr3(V2P(p->pgdir));  // switch to process's address space
801085b3:	8b 45 08             	mov    0x8(%ebp),%eax
801085b6:	8b 40 04             	mov    0x4(%eax),%eax
801085b9:	05 00 00 00 80       	add    $0x80000000,%eax
801085be:	83 ec 0c             	sub    $0xc,%esp
801085c1:	50                   	push   %eax
801085c2:	e8 e0 f8 ff ff       	call   80107ea7 <lcr3>
801085c7:	83 c4 10             	add    $0x10,%esp
  popcli();
801085ca:	e8 77 d1 ff ff       	call   80105746 <popcli>
}
801085cf:	90                   	nop
801085d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801085d3:	5b                   	pop    %ebx
801085d4:	5e                   	pop    %esi
801085d5:	5d                   	pop    %ebp
801085d6:	c3                   	ret    

801085d7 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801085d7:	f3 0f 1e fb          	endbr32 
801085db:	55                   	push   %ebp
801085dc:	89 e5                	mov    %esp,%ebp
801085de:	83 ec 18             	sub    $0x18,%esp
  char *mem;

  if(sz >= PGSIZE)
801085e1:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801085e8:	76 0d                	jbe    801085f7 <inituvm+0x20>
    panic("inituvm: more than a page");
801085ea:	83 ec 0c             	sub    $0xc,%esp
801085ed:	68 b3 9c 10 80       	push   $0x80109cb3
801085f2:	e8 11 80 ff ff       	call   80100608 <panic>
  mem = kalloc();
801085f7:	e8 01 a9 ff ff       	call   80102efd <kalloc>
801085fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801085ff:	83 ec 04             	sub    $0x4,%esp
80108602:	68 00 10 00 00       	push   $0x1000
80108607:	6a 00                	push   $0x0
80108609:	ff 75 f4             	pushl  -0xc(%ebp)
8010860c:	e8 f7 d1 ff ff       	call   80105808 <memset>
80108611:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108617:	05 00 00 00 80       	add    $0x80000000,%eax
8010861c:	83 ec 0c             	sub    $0xc,%esp
8010861f:	6a 06                	push   $0x6
80108621:	50                   	push   %eax
80108622:	68 00 10 00 00       	push   $0x1000
80108627:	6a 00                	push   $0x0
80108629:	ff 75 08             	pushl  0x8(%ebp)
8010862c:	e8 76 fc ff ff       	call   801082a7 <mappages>
80108631:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108634:	83 ec 04             	sub    $0x4,%esp
80108637:	ff 75 10             	pushl  0x10(%ebp)
8010863a:	ff 75 0c             	pushl  0xc(%ebp)
8010863d:	ff 75 f4             	pushl  -0xc(%ebp)
80108640:	e8 8a d2 ff ff       	call   801058cf <memmove>
80108645:	83 c4 10             	add    $0x10,%esp
}
80108648:	90                   	nop
80108649:	c9                   	leave  
8010864a:	c3                   	ret    

8010864b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010864b:	f3 0f 1e fb          	endbr32 
8010864f:	55                   	push   %ebp
80108650:	89 e5                	mov    %esp,%ebp
80108652:	83 ec 18             	sub    $0x18,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108655:	8b 45 0c             	mov    0xc(%ebp),%eax
80108658:	25 ff 0f 00 00       	and    $0xfff,%eax
8010865d:	85 c0                	test   %eax,%eax
8010865f:	74 0d                	je     8010866e <loaduvm+0x23>
    panic("loaduvm: addr must be page aligned");
80108661:	83 ec 0c             	sub    $0xc,%esp
80108664:	68 d0 9c 10 80       	push   $0x80109cd0
80108669:	e8 9a 7f ff ff       	call   80100608 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010866e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108675:	e9 8f 00 00 00       	jmp    80108709 <loaduvm+0xbe>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010867a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010867d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108680:	01 d0                	add    %edx,%eax
80108682:	83 ec 04             	sub    $0x4,%esp
80108685:	6a 00                	push   $0x0
80108687:	50                   	push   %eax
80108688:	ff 75 08             	pushl  0x8(%ebp)
8010868b:	e8 7d fb ff ff       	call   8010820d <walkpgdir>
80108690:	83 c4 10             	add    $0x10,%esp
80108693:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108696:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010869a:	75 0d                	jne    801086a9 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
8010869c:	83 ec 0c             	sub    $0xc,%esp
8010869f:	68 f3 9c 10 80       	push   $0x80109cf3
801086a4:	e8 5f 7f ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
801086a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086ac:	8b 00                	mov    (%eax),%eax
801086ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801086b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801086b6:	8b 45 18             	mov    0x18(%ebp),%eax
801086b9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086bc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801086c1:	77 0b                	ja     801086ce <loaduvm+0x83>
      n = sz - i;
801086c3:	8b 45 18             	mov    0x18(%ebp),%eax
801086c6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801086c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801086cc:	eb 07                	jmp    801086d5 <loaduvm+0x8a>
    else
      n = PGSIZE;
801086ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801086d5:	8b 55 14             	mov    0x14(%ebp),%edx
801086d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086db:	01 d0                	add    %edx,%eax
801086dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
801086e0:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801086e6:	ff 75 f0             	pushl  -0x10(%ebp)
801086e9:	50                   	push   %eax
801086ea:	52                   	push   %edx
801086eb:	ff 75 10             	pushl  0x10(%ebp)
801086ee:	e8 22 9a ff ff       	call   80102115 <readi>
801086f3:	83 c4 10             	add    $0x10,%esp
801086f6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
801086f9:	74 07                	je     80108702 <loaduvm+0xb7>
      return -1;
801086fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108700:	eb 18                	jmp    8010871a <loaduvm+0xcf>
  for(i = 0; i < sz; i += PGSIZE){
80108702:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010870c:	3b 45 18             	cmp    0x18(%ebp),%eax
8010870f:	0f 82 65 ff ff ff    	jb     8010867a <loaduvm+0x2f>
  }
  return 0;
80108715:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010871a:	c9                   	leave  
8010871b:	c3                   	ret    

8010871c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) // TODO: Add queue code to this
{
8010871c:	f3 0f 1e fb          	endbr32 
80108720:	55                   	push   %ebp
80108721:	89 e5                	mov    %esp,%ebp
80108723:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108726:	8b 45 10             	mov    0x10(%ebp),%eax
80108729:	85 c0                	test   %eax,%eax
8010872b:	79 0a                	jns    80108737 <allocuvm+0x1b>
    return 0;
8010872d:	b8 00 00 00 00       	mov    $0x0,%eax
80108732:	e9 ec 00 00 00       	jmp    80108823 <allocuvm+0x107>
  if(newsz < oldsz)
80108737:	8b 45 10             	mov    0x10(%ebp),%eax
8010873a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010873d:	73 08                	jae    80108747 <allocuvm+0x2b>
    return oldsz;
8010873f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108742:	e9 dc 00 00 00       	jmp    80108823 <allocuvm+0x107>

  a = PGROUNDUP(oldsz);
80108747:	8b 45 0c             	mov    0xc(%ebp),%eax
8010874a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010874f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108757:	e9 b8 00 00 00       	jmp    80108814 <allocuvm+0xf8>
    mem = kalloc();
8010875c:	e8 9c a7 ff ff       	call   80102efd <kalloc>
80108761:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108764:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108768:	75 2e                	jne    80108798 <allocuvm+0x7c>
      cprintf("allocuvm out of memory\n");
8010876a:	83 ec 0c             	sub    $0xc,%esp
8010876d:	68 11 9d 10 80       	push   $0x80109d11
80108772:	e8 a1 7c ff ff       	call   80100418 <cprintf>
80108777:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010877a:	83 ec 04             	sub    $0x4,%esp
8010877d:	ff 75 0c             	pushl  0xc(%ebp)
80108780:	ff 75 10             	pushl  0x10(%ebp)
80108783:	ff 75 08             	pushl  0x8(%ebp)
80108786:	e8 9a 00 00 00       	call   80108825 <deallocuvm>
8010878b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010878e:	b8 00 00 00 00       	mov    $0x0,%eax
80108793:	e9 8b 00 00 00       	jmp    80108823 <allocuvm+0x107>
    }
    memset(mem, 0, PGSIZE);
80108798:	83 ec 04             	sub    $0x4,%esp
8010879b:	68 00 10 00 00       	push   $0x1000
801087a0:	6a 00                	push   $0x0
801087a2:	ff 75 f0             	pushl  -0x10(%ebp)
801087a5:	e8 5e d0 ff ff       	call   80105808 <memset>
801087aa:	83 c4 10             	add    $0x10,%esp
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801087ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087b0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801087b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b9:	83 ec 0c             	sub    $0xc,%esp
801087bc:	6a 06                	push   $0x6
801087be:	52                   	push   %edx
801087bf:	68 00 10 00 00       	push   $0x1000
801087c4:	50                   	push   %eax
801087c5:	ff 75 08             	pushl  0x8(%ebp)
801087c8:	e8 da fa ff ff       	call   801082a7 <mappages>
801087cd:	83 c4 20             	add    $0x20,%esp
801087d0:	85 c0                	test   %eax,%eax
801087d2:	79 39                	jns    8010880d <allocuvm+0xf1>
      cprintf("allocuvm out of memory (2)\n");
801087d4:	83 ec 0c             	sub    $0xc,%esp
801087d7:	68 29 9d 10 80       	push   $0x80109d29
801087dc:	e8 37 7c ff ff       	call   80100418 <cprintf>
801087e1:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801087e4:	83 ec 04             	sub    $0x4,%esp
801087e7:	ff 75 0c             	pushl  0xc(%ebp)
801087ea:	ff 75 10             	pushl  0x10(%ebp)
801087ed:	ff 75 08             	pushl  0x8(%ebp)
801087f0:	e8 30 00 00 00       	call   80108825 <deallocuvm>
801087f5:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
801087f8:	83 ec 0c             	sub    $0xc,%esp
801087fb:	ff 75 f0             	pushl  -0x10(%ebp)
801087fe:	e8 5c a6 ff ff       	call   80102e5f <kfree>
80108803:	83 c4 10             	add    $0x10,%esp
      return 0;
80108806:	b8 00 00 00 00       	mov    $0x0,%eax
8010880b:	eb 16                	jmp    80108823 <allocuvm+0x107>
  for(; a < newsz; a += PGSIZE){
8010880d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108817:	3b 45 10             	cmp    0x10(%ebp),%eax
8010881a:	0f 82 3c ff ff ff    	jb     8010875c <allocuvm+0x40>
    }
  }
  return newsz;
80108820:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108823:	c9                   	leave  
80108824:	c3                   	ret    

80108825 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108825:	f3 0f 1e fb          	endbr32 
80108829:	55                   	push   %ebp
8010882a:	89 e5                	mov    %esp,%ebp
8010882c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010882f:	8b 45 10             	mov    0x10(%ebp),%eax
80108832:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108835:	72 08                	jb     8010883f <deallocuvm+0x1a>
    return oldsz;
80108837:	8b 45 0c             	mov    0xc(%ebp),%eax
8010883a:	e9 ae 00 00 00       	jmp    801088ed <deallocuvm+0xc8>

  a = PGROUNDUP(newsz);
8010883f:	8b 45 10             	mov    0x10(%ebp),%eax
80108842:	05 ff 0f 00 00       	add    $0xfff,%eax
80108847:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010884c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010884f:	e9 8a 00 00 00       	jmp    801088de <deallocuvm+0xb9>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108857:	83 ec 04             	sub    $0x4,%esp
8010885a:	6a 00                	push   $0x0
8010885c:	50                   	push   %eax
8010885d:	ff 75 08             	pushl  0x8(%ebp)
80108860:	e8 a8 f9 ff ff       	call   8010820d <walkpgdir>
80108865:	83 c4 10             	add    $0x10,%esp
80108868:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010886b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010886f:	75 16                	jne    80108887 <deallocuvm+0x62>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108874:	c1 e8 16             	shr    $0x16,%eax
80108877:	83 c0 01             	add    $0x1,%eax
8010887a:	c1 e0 16             	shl    $0x16,%eax
8010887d:	2d 00 10 00 00       	sub    $0x1000,%eax
80108882:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108885:	eb 50                	jmp    801088d7 <deallocuvm+0xb2>
    else if((*pte & (PTE_P | PTE_E)) != 0){
80108887:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010888a:	8b 00                	mov    (%eax),%eax
8010888c:	25 01 04 00 00       	and    $0x401,%eax
80108891:	85 c0                	test   %eax,%eax
80108893:	74 42                	je     801088d7 <deallocuvm+0xb2>
      pa = PTE_ADDR(*pte);
80108895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108898:	8b 00                	mov    (%eax),%eax
8010889a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010889f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801088a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088a6:	75 0d                	jne    801088b5 <deallocuvm+0x90>
        panic("kfree");
801088a8:	83 ec 0c             	sub    $0xc,%esp
801088ab:	68 45 9d 10 80       	push   $0x80109d45
801088b0:	e8 53 7d ff ff       	call   80100608 <panic>
      char *v = P2V(pa);
801088b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801088b8:	05 00 00 00 80       	add    $0x80000000,%eax
801088bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801088c0:	83 ec 0c             	sub    $0xc,%esp
801088c3:	ff 75 e8             	pushl  -0x18(%ebp)
801088c6:	e8 94 a5 ff ff       	call   80102e5f <kfree>
801088cb:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801088ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801088d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801088d7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088e4:	0f 82 6a ff ff ff    	jb     80108854 <deallocuvm+0x2f>
    }
  }
  return newsz;
801088ea:	8b 45 10             	mov    0x10(%ebp),%eax
}
801088ed:	c9                   	leave  
801088ee:	c3                   	ret    

801088ef <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801088ef:	f3 0f 1e fb          	endbr32 
801088f3:	55                   	push   %ebp
801088f4:	89 e5                	mov    %esp,%ebp
801088f6:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801088f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801088fd:	75 0d                	jne    8010890c <freevm+0x1d>
    panic("freevm: no pgdir");
801088ff:	83 ec 0c             	sub    $0xc,%esp
80108902:	68 4b 9d 10 80       	push   $0x80109d4b
80108907:	e8 fc 7c ff ff       	call   80100608 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010890c:	83 ec 04             	sub    $0x4,%esp
8010890f:	6a 00                	push   $0x0
80108911:	68 00 00 00 80       	push   $0x80000000
80108916:	ff 75 08             	pushl  0x8(%ebp)
80108919:	e8 07 ff ff ff       	call   80108825 <deallocuvm>
8010891e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108921:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108928:	eb 4a                	jmp    80108974 <freevm+0x85>
    if(pgdir[i] & (PTE_P | PTE_E)){
8010892a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108934:	8b 45 08             	mov    0x8(%ebp),%eax
80108937:	01 d0                	add    %edx,%eax
80108939:	8b 00                	mov    (%eax),%eax
8010893b:	25 01 04 00 00       	and    $0x401,%eax
80108940:	85 c0                	test   %eax,%eax
80108942:	74 2c                	je     80108970 <freevm+0x81>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108947:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010894e:	8b 45 08             	mov    0x8(%ebp),%eax
80108951:	01 d0                	add    %edx,%eax
80108953:	8b 00                	mov    (%eax),%eax
80108955:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010895a:	05 00 00 00 80       	add    $0x80000000,%eax
8010895f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108962:	83 ec 0c             	sub    $0xc,%esp
80108965:	ff 75 f0             	pushl  -0x10(%ebp)
80108968:	e8 f2 a4 ff ff       	call   80102e5f <kfree>
8010896d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108970:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108974:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010897b:	76 ad                	jbe    8010892a <freevm+0x3b>
    }
  }
  kfree((char*)pgdir);
8010897d:	83 ec 0c             	sub    $0xc,%esp
80108980:	ff 75 08             	pushl  0x8(%ebp)
80108983:	e8 d7 a4 ff ff       	call   80102e5f <kfree>
80108988:	83 c4 10             	add    $0x10,%esp
}
8010898b:	90                   	nop
8010898c:	c9                   	leave  
8010898d:	c3                   	ret    

8010898e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010898e:	f3 0f 1e fb          	endbr32 
80108992:	55                   	push   %ebp
80108993:	89 e5                	mov    %esp,%ebp
80108995:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108998:	83 ec 04             	sub    $0x4,%esp
8010899b:	6a 00                	push   $0x0
8010899d:	ff 75 0c             	pushl  0xc(%ebp)
801089a0:	ff 75 08             	pushl  0x8(%ebp)
801089a3:	e8 65 f8 ff ff       	call   8010820d <walkpgdir>
801089a8:	83 c4 10             	add    $0x10,%esp
801089ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801089ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801089b2:	75 0d                	jne    801089c1 <clearpteu+0x33>
    panic("clearpteu");
801089b4:	83 ec 0c             	sub    $0xc,%esp
801089b7:	68 5c 9d 10 80       	push   $0x80109d5c
801089bc:	e8 47 7c ff ff       	call   80100608 <panic>
  *pte &= ~PTE_U;
801089c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c4:	8b 00                	mov    (%eax),%eax
801089c6:	83 e0 fb             	and    $0xfffffffb,%eax
801089c9:	89 c2                	mov    %eax,%edx
801089cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ce:	89 10                	mov    %edx,(%eax)
}
801089d0:	90                   	nop
801089d1:	c9                   	leave  
801089d2:	c3                   	ret    

801089d3 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801089d3:	f3 0f 1e fb          	endbr32 
801089d7:	55                   	push   %ebp
801089d8:	89 e5                	mov    %esp,%ebp
801089da:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801089dd:	e8 7c f9 ff ff       	call   8010835e <setupkvm>
801089e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801089e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089e9:	75 0a                	jne    801089f5 <copyuvm+0x22>
    return 0;
801089eb:	b8 00 00 00 00       	mov    $0x0,%eax
801089f0:	e9 fa 00 00 00       	jmp    80108aef <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
801089f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089fc:	e9 c9 00 00 00       	jmp    80108aca <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a04:	83 ec 04             	sub    $0x4,%esp
80108a07:	6a 00                	push   $0x0
80108a09:	50                   	push   %eax
80108a0a:	ff 75 08             	pushl  0x8(%ebp)
80108a0d:	e8 fb f7 ff ff       	call   8010820d <walkpgdir>
80108a12:	83 c4 10             	add    $0x10,%esp
80108a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a1c:	75 0d                	jne    80108a2b <copyuvm+0x58>
      panic("p4Debug: inside copyuvm, pte should exist");
80108a1e:	83 ec 0c             	sub    $0xc,%esp
80108a21:	68 68 9d 10 80       	push   $0x80109d68
80108a26:	e8 dd 7b ff ff       	call   80100608 <panic>
    if(!(*pte & (PTE_P | PTE_E)))
80108a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a2e:	8b 00                	mov    (%eax),%eax
80108a30:	25 01 04 00 00       	and    $0x401,%eax
80108a35:	85 c0                	test   %eax,%eax
80108a37:	75 0d                	jne    80108a46 <copyuvm+0x73>
      panic("p4Debug: inside copyuvm, page not present");
80108a39:	83 ec 0c             	sub    $0xc,%esp
80108a3c:	68 94 9d 10 80       	push   $0x80109d94
80108a41:	e8 c2 7b ff ff       	call   80100608 <panic>
    pa = PTE_ADDR(*pte);
80108a46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a49:	8b 00                	mov    (%eax),%eax
80108a4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a50:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a56:	8b 00                	mov    (%eax),%eax
80108a58:	25 ff 0f 00 00       	and    $0xfff,%eax
80108a5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108a60:	e8 98 a4 ff ff       	call   80102efd <kalloc>
80108a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108a68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108a6c:	74 6d                	je     80108adb <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a71:	05 00 00 00 80       	add    $0x80000000,%eax
80108a76:	83 ec 04             	sub    $0x4,%esp
80108a79:	68 00 10 00 00       	push   $0x1000
80108a7e:	50                   	push   %eax
80108a7f:	ff 75 e0             	pushl  -0x20(%ebp)
80108a82:	e8 48 ce ff ff       	call   801058cf <memmove>
80108a87:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108a8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108a90:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a99:	83 ec 0c             	sub    $0xc,%esp
80108a9c:	52                   	push   %edx
80108a9d:	51                   	push   %ecx
80108a9e:	68 00 10 00 00       	push   $0x1000
80108aa3:	50                   	push   %eax
80108aa4:	ff 75 f0             	pushl  -0x10(%ebp)
80108aa7:	e8 fb f7 ff ff       	call   801082a7 <mappages>
80108aac:	83 c4 20             	add    $0x20,%esp
80108aaf:	85 c0                	test   %eax,%eax
80108ab1:	79 10                	jns    80108ac3 <copyuvm+0xf0>
      kfree(mem);
80108ab3:	83 ec 0c             	sub    $0xc,%esp
80108ab6:	ff 75 e0             	pushl  -0x20(%ebp)
80108ab9:	e8 a1 a3 ff ff       	call   80102e5f <kfree>
80108abe:	83 c4 10             	add    $0x10,%esp
      goto bad;
80108ac1:	eb 19                	jmp    80108adc <copyuvm+0x109>
  for(i = 0; i < sz; i += PGSIZE){
80108ac3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108acd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ad0:	0f 82 2b ff ff ff    	jb     80108a01 <copyuvm+0x2e>
    }
  }
  return d;
80108ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ad9:	eb 14                	jmp    80108aef <copyuvm+0x11c>
      goto bad;
80108adb:	90                   	nop

bad:
  freevm(d);
80108adc:	83 ec 0c             	sub    $0xc,%esp
80108adf:	ff 75 f0             	pushl  -0x10(%ebp)
80108ae2:	e8 08 fe ff ff       	call   801088ef <freevm>
80108ae7:	83 c4 10             	add    $0x10,%esp
  return 0;
80108aea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108aef:	c9                   	leave  
80108af0:	c3                   	ret    

80108af1 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108af1:	f3 0f 1e fb          	endbr32 
80108af5:	55                   	push   %ebp
80108af6:	89 e5                	mov    %esp,%ebp
80108af8:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108afb:	83 ec 04             	sub    $0x4,%esp
80108afe:	6a 00                	push   $0x0
80108b00:	ff 75 0c             	pushl  0xc(%ebp)
80108b03:	ff 75 08             	pushl  0x8(%ebp)
80108b06:	e8 02 f7 ff ff       	call   8010820d <walkpgdir>
80108b0b:	83 c4 10             	add    $0x10,%esp
80108b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // p4Debug: Check for page's present and encrypted flags.
  if(((*pte & PTE_P) | (*pte & PTE_E)) == 0)
80108b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b14:	8b 00                	mov    (%eax),%eax
80108b16:	25 01 04 00 00       	and    $0x401,%eax
80108b1b:	85 c0                	test   %eax,%eax
80108b1d:	75 07                	jne    80108b26 <uva2ka+0x35>
    return 0;
80108b1f:	b8 00 00 00 00       	mov    $0x0,%eax
80108b24:	eb 22                	jmp    80108b48 <uva2ka+0x57>
  if((*pte & PTE_U) == 0)
80108b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b29:	8b 00                	mov    (%eax),%eax
80108b2b:	83 e0 04             	and    $0x4,%eax
80108b2e:	85 c0                	test   %eax,%eax
80108b30:	75 07                	jne    80108b39 <uva2ka+0x48>
    return 0;
80108b32:	b8 00 00 00 00       	mov    $0x0,%eax
80108b37:	eb 0f                	jmp    80108b48 <uva2ka+0x57>
  return (char*)P2V(PTE_ADDR(*pte));
80108b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3c:	8b 00                	mov    (%eax),%eax
80108b3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b43:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108b48:	c9                   	leave  
80108b49:	c3                   	ret    

80108b4a <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108b4a:	f3 0f 1e fb          	endbr32 
80108b4e:	55                   	push   %ebp
80108b4f:	89 e5                	mov    %esp,%ebp
80108b51:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108b54:	8b 45 10             	mov    0x10(%ebp),%eax
80108b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108b5a:	eb 7f                	jmp    80108bdb <copyout+0x91>
    va0 = (uint)PGROUNDDOWN(va);
80108b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b6a:	83 ec 08             	sub    $0x8,%esp
80108b6d:	50                   	push   %eax
80108b6e:	ff 75 08             	pushl  0x8(%ebp)
80108b71:	e8 7b ff ff ff       	call   80108af1 <uva2ka>
80108b76:	83 c4 10             	add    $0x10,%esp
80108b79:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108b7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108b80:	75 07                	jne    80108b89 <copyout+0x3f>
    {
      //p4Debug : Cannot find page in kernel space.
      return -1;
80108b82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108b87:	eb 61                	jmp    80108bea <copyout+0xa0>
    }
    n = PGSIZE - (va - va0);
80108b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b8c:	2b 45 0c             	sub    0xc(%ebp),%eax
80108b8f:	05 00 10 00 00       	add    $0x1000,%eax
80108b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b9a:	3b 45 14             	cmp    0x14(%ebp),%eax
80108b9d:	76 06                	jbe    80108ba5 <copyout+0x5b>
      n = len;
80108b9f:	8b 45 14             	mov    0x14(%ebp),%eax
80108ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ba8:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108bab:	89 c2                	mov    %eax,%edx
80108bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108bb0:	01 d0                	add    %edx,%eax
80108bb2:	83 ec 04             	sub    $0x4,%esp
80108bb5:	ff 75 f0             	pushl  -0x10(%ebp)
80108bb8:	ff 75 f4             	pushl  -0xc(%ebp)
80108bbb:	50                   	push   %eax
80108bbc:	e8 0e cd ff ff       	call   801058cf <memmove>
80108bc1:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc7:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bcd:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bd3:	05 00 10 00 00       	add    $0x1000,%eax
80108bd8:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108bdb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108bdf:	0f 85 77 ff ff ff    	jne    80108b5c <copyout+0x12>
  }
  return 0;
80108be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bea:	c9                   	leave  
80108beb:	c3                   	ret    

80108bec <translate_and_set>:

//This function is just like uva2ka but sets the PTE_E bit and clears PTE_P
char* translate_and_set(pde_t *pgdir, char *uva) {
80108bec:	f3 0f 1e fb          	endbr32 
80108bf0:	55                   	push   %ebp
80108bf1:	89 e5                	mov    %esp,%ebp
80108bf3:	83 ec 18             	sub    $0x18,%esp
  cprintf("p4Debug: setting PTE_E for %p, VPN %d\n", uva, PPN(uva));
80108bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bf9:	c1 e8 0c             	shr    $0xc,%eax
80108bfc:	83 ec 04             	sub    $0x4,%esp
80108bff:	50                   	push   %eax
80108c00:	ff 75 0c             	pushl  0xc(%ebp)
80108c03:	68 c0 9d 10 80       	push   $0x80109dc0
80108c08:	e8 0b 78 ff ff       	call   80100418 <cprintf>
80108c0d:	83 c4 10             	add    $0x10,%esp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80108c10:	83 ec 04             	sub    $0x4,%esp
80108c13:	6a 00                	push   $0x0
80108c15:	ff 75 0c             	pushl  0xc(%ebp)
80108c18:	ff 75 08             	pushl  0x8(%ebp)
80108c1b:	e8 ed f5 ff ff       	call   8010820d <walkpgdir>
80108c20:	83 c4 10             	add    $0x10,%esp
80108c23:	89 45 f4             	mov    %eax,-0xc(%ebp)

  //p4Debug: If page is not present AND it is not encrypted.
  if((*pte & PTE_P) == 0 && (*pte & PTE_E) == 0)
80108c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c29:	8b 00                	mov    (%eax),%eax
80108c2b:	83 e0 01             	and    $0x1,%eax
80108c2e:	85 c0                	test   %eax,%eax
80108c30:	75 18                	jne    80108c4a <translate_and_set+0x5e>
80108c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c35:	8b 00                	mov    (%eax),%eax
80108c37:	25 00 04 00 00       	and    $0x400,%eax
80108c3c:	85 c0                	test   %eax,%eax
80108c3e:	75 0a                	jne    80108c4a <translate_and_set+0x5e>
    return 0;
80108c40:	b8 00 00 00 00       	mov    $0x0,%eax
80108c45:	e9 93 00 00 00       	jmp    80108cdd <translate_and_set+0xf1>
  //p4Debug: If page is already encrypted, i.e. PTE_E is set, return NULL as error;
  if((*pte & PTE_E)) {
80108c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4d:	8b 00                	mov    (%eax),%eax
80108c4f:	25 00 04 00 00       	and    $0x400,%eax
80108c54:	85 c0                	test   %eax,%eax
80108c56:	74 07                	je     80108c5f <translate_and_set+0x73>
    return 0;
80108c58:	b8 00 00 00 00       	mov    $0x0,%eax
80108c5d:	eb 7e                	jmp    80108cdd <translate_and_set+0xf1>
  }
  // p4Debug: Check if users are allowed to use this page
  if((*pte & PTE_U) == 0)
80108c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c62:	8b 00                	mov    (%eax),%eax
80108c64:	83 e0 04             	and    $0x4,%eax
80108c67:	85 c0                	test   %eax,%eax
80108c69:	75 07                	jne    80108c72 <translate_and_set+0x86>
    return 0;
80108c6b:	b8 00 00 00 00       	mov    $0x0,%eax
80108c70:	eb 6b                	jmp    80108cdd <translate_and_set+0xf1>
  //p4Debug: Set Page as encrypted and not present so that we can trap(see trap.c) to decrypt page
  cprintf("p4Debug: PTE was %x and its pointer %p\n", *pte, pte);
80108c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c75:	8b 00                	mov    (%eax),%eax
80108c77:	83 ec 04             	sub    $0x4,%esp
80108c7a:	ff 75 f4             	pushl  -0xc(%ebp)
80108c7d:	50                   	push   %eax
80108c7e:	68 e8 9d 10 80       	push   $0x80109de8
80108c83:	e8 90 77 ff ff       	call   80100418 <cprintf>
80108c88:	83 c4 10             	add    $0x10,%esp
  *pte = *pte | PTE_E;
80108c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8e:	8b 00                	mov    (%eax),%eax
80108c90:	80 cc 04             	or     $0x4,%ah
80108c93:	89 c2                	mov    %eax,%edx
80108c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c98:	89 10                	mov    %edx,(%eax)
  *pte = *pte & ~PTE_P;
80108c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9d:	8b 00                	mov    (%eax),%eax
80108c9f:	83 e0 fe             	and    $0xfffffffe,%eax
80108ca2:	89 c2                	mov    %eax,%edx
80108ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca7:	89 10                	mov    %edx,(%eax)
  *pte = *pte & ~PTE_A;
80108ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cac:	8b 00                	mov    (%eax),%eax
80108cae:	83 e0 df             	and    $0xffffffdf,%eax
80108cb1:	89 c2                	mov    %eax,%edx
80108cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb6:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: PTE is now %x\n", *pte);
80108cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cbb:	8b 00                	mov    (%eax),%eax
80108cbd:	83 ec 08             	sub    $0x8,%esp
80108cc0:	50                   	push   %eax
80108cc1:	68 10 9e 10 80       	push   $0x80109e10
80108cc6:	e8 4d 77 ff ff       	call   80100418 <cprintf>
80108ccb:	83 c4 10             	add    $0x10,%esp
  return (char*)P2V(PTE_ADDR(*pte));
80108cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd1:	8b 00                	mov    (%eax),%eax
80108cd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108cd8:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108cdd:	c9                   	leave  
80108cde:	c3                   	ret    

80108cdf <enqueue>:

//Enqueues things. Evicts them too!
void enqueue(char * virtual_addr, struct proc * p, pde_t* mypd) {
80108cdf:	f3 0f 1e fb          	endbr32 
80108ce3:	55                   	push   %ebp
80108ce4:	89 e5                	mov    %esp,%ebp
80108ce6:	53                   	push   %ebx
80108ce7:	83 ec 14             	sub    $0x14,%esp


  // iterate the not-full queue and find an empty spot for the page
  int i;
  for (i = 0; i < CLOCKSIZE; i++) {
80108cea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108cf1:	e9 cd 00 00 00       	jmp    80108dc3 <enqueue+0xe4>

    //if queue has an empty spot, add it.
    if (!(p->clock_queue[i].is_full)) {
80108cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108cfc:	83 c2 07             	add    $0x7,%edx
80108cff:	c1 e2 04             	shl    $0x4,%edx
80108d02:	01 d0                	add    %edx,%eax
80108d04:	83 c0 0c             	add    $0xc,%eax
80108d07:	8b 00                	mov    (%eax),%eax
80108d09:	85 c0                	test   %eax,%eax
80108d0b:	0f 85 ae 00 00 00    	jne    80108dbf <enqueue+0xe0>
      p->clock_queue[i].va = virtual_addr; // Set the virtal address
80108d11:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d17:	83 c2 07             	add    $0x7,%edx
80108d1a:	c1 e2 04             	shl    $0x4,%edx
80108d1d:	01 d0                	add    %edx,%eax
80108d1f:	8d 50 14             	lea    0x14(%eax),%edx
80108d22:	8b 45 08             	mov    0x8(%ebp),%eax
80108d25:	89 02                	mov    %eax,(%edx)
      p->clock_queue[i].is_full = 1;
80108d27:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d2d:	83 c2 07             	add    $0x7,%edx
80108d30:	c1 e2 04             	shl    $0x4,%edx
80108d33:	01 d0                	add    %edx,%eax
80108d35:	83 c0 0c             	add    $0xc,%eax
80108d38:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      p->clock_queue[i].pte = walkpgdir(mypd, virtual_addr, 0);
80108d3e:	83 ec 04             	sub    $0x4,%esp
80108d41:	6a 00                	push   $0x0
80108d43:	ff 75 08             	pushl  0x8(%ebp)
80108d46:	ff 75 10             	pushl  0x10(%ebp)
80108d49:	e8 bf f4 ff ff       	call   8010820d <walkpgdir>
80108d4e:	83 c4 10             	add    $0x10,%esp
80108d51:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d54:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108d57:	83 c1 07             	add    $0x7,%ecx
80108d5a:	c1 e1 04             	shl    $0x4,%ecx
80108d5d:	01 ca                	add    %ecx,%edx
80108d5f:	83 c2 18             	add    $0x18,%edx
80108d62:	89 02                	mov    %eax,(%edx)

      cprintf("PTE_A: %x VA: %p\n", *p->clock_queue[i].pte & PTE_A, p->clock_queue[i].va);
80108d64:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d6a:	83 c2 07             	add    $0x7,%edx
80108d6d:	c1 e2 04             	shl    $0x4,%edx
80108d70:	01 d0                	add    %edx,%eax
80108d72:	83 c0 14             	add    $0x14,%eax
80108d75:	8b 00                	mov    (%eax),%eax
80108d77:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d7a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80108d7d:	83 c1 07             	add    $0x7,%ecx
80108d80:	c1 e1 04             	shl    $0x4,%ecx
80108d83:	01 ca                	add    %ecx,%edx
80108d85:	83 c2 18             	add    $0x18,%edx
80108d88:	8b 12                	mov    (%edx),%edx
80108d8a:	8b 12                	mov    (%edx),%edx
80108d8c:	83 e2 20             	and    $0x20,%edx
80108d8f:	83 ec 04             	sub    $0x4,%esp
80108d92:	50                   	push   %eax
80108d93:	52                   	push   %edx
80108d94:	68 28 9e 10 80       	push   $0x80109e28
80108d99:	e8 7a 76 ff ff       	call   80100418 <cprintf>
80108d9e:	83 c4 10             	add    $0x10,%esp

      p->q_count++;
80108da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108da4:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
80108daa:	8d 50 01             	lea    0x1(%eax),%edx
80108dad:	8b 45 0c             	mov    0xc(%ebp),%eax
80108db0:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
      i = -1;
80108db6:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
      break; // empty spot was filled so break the loop
80108dbd:	eb 0e                	jmp    80108dcd <enqueue+0xee>
  for (i = 0; i < CLOCKSIZE; i++) {
80108dbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108dc3:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80108dc7:	0f 8e 29 ff ff ff    	jle    80108cf6 <enqueue+0x17>
    }
  }
  

  // If the Queue is full, now need to iterate through the pages and check if the PTE_A bit = 0
  if (i != -1) {// For loop goes here
80108dcd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
80108dd1:	0f 84 d8 00 00 00    	je     80108eaf <enqueue+0x1d0>
  
    i = 0;
80108dd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //int k = 0;
    for (;;p->q_head = p->q_head->next) {

      //cprintf("count: %d\n", p->q_count);
      //if (p->q_head >= p->q_count) { p->q_head = 0; } // The count here is always 8
      pte_t * curr_pte = walkpgdir(mypd, p->q_head->va, 0);
80108dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80108de1:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
80108de7:	8b 40 08             	mov    0x8(%eax),%eax
80108dea:	83 ec 04             	sub    $0x4,%esp
80108ded:	6a 00                	push   $0x0
80108def:	50                   	push   %eax
80108df0:	ff 75 10             	pushl  0x10(%ebp)
80108df3:	e8 15 f4 ff ff       	call   8010820d <walkpgdir>
80108df8:	83 c4 10             	add    $0x10,%esp
80108dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if (*curr_pte & PTE_A) {
80108dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e01:	8b 00                	mov    (%eax),%eax
80108e03:	83 e0 20             	and    $0x20,%eax
80108e06:	85 c0                	test   %eax,%eax
80108e08:	74 11                	je     80108e1b <enqueue+0x13c>
        *curr_pte = *curr_pte & ~PTE_A;
80108e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e0d:	8b 00                	mov    (%eax),%eax
80108e0f:	83 e0 df             	and    $0xffffffdf,%eax
80108e12:	89 c2                	mov    %eax,%edx
80108e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e17:	89 10                	mov    %edx,(%eax)
80108e19:	eb 7a                	jmp    80108e95 <enqueue+0x1b6>
      } else {
        //Eviction code
        mencrypt(p->q_head->va, 1);
80108e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e1e:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
80108e24:	8b 40 08             	mov    0x8(%eax),%eax
80108e27:	83 ec 08             	sub    $0x8,%esp
80108e2a:	6a 01                	push   $0x1
80108e2c:	50                   	push   %eax
80108e2d:	e8 3b 02 00 00       	call   8010906d <mencrypt>
80108e32:	83 c4 10             	add    $0x10,%esp
        // New node
        p->q_head->va = virtual_addr; // Set the virtal address
80108e35:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e38:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
80108e3e:	8b 55 08             	mov    0x8(%ebp),%edx
80108e41:	89 50 08             	mov    %edx,0x8(%eax)
        p->q_head->pte = walkpgdir(mypd, virtual_addr, 0);
80108e44:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e47:	8b 98 fc 00 00 00    	mov    0xfc(%eax),%ebx
80108e4d:	83 ec 04             	sub    $0x4,%esp
80108e50:	6a 00                	push   $0x0
80108e52:	ff 75 08             	pushl  0x8(%ebp)
80108e55:	ff 75 10             	pushl  0x10(%ebp)
80108e58:	e8 b0 f3 ff ff       	call   8010820d <walkpgdir>
80108e5d:	83 c4 10             	add    $0x10,%esp
80108e60:	89 43 0c             	mov    %eax,0xc(%ebx)
        cprintf("PTE_A: %x VA: %p\n", *p->q_head->pte & PTE_A, p->q_head->va);
80108e63:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e66:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
80108e6c:	8b 40 08             	mov    0x8(%eax),%eax
80108e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e72:	8b 92 fc 00 00 00    	mov    0xfc(%edx),%edx
80108e78:	8b 52 0c             	mov    0xc(%edx),%edx
80108e7b:	8b 12                	mov    (%edx),%edx
80108e7d:	83 e2 20             	and    $0x20,%edx
80108e80:	83 ec 04             	sub    $0x4,%esp
80108e83:	50                   	push   %eax
80108e84:	52                   	push   %edx
80108e85:	68 28 9e 10 80       	push   $0x80109e28
80108e8a:	e8 89 75 ff ff       	call   80100418 <cprintf>
80108e8f:	83 c4 10             	add    $0x10,%esp
        break;
80108e92:	90                   	nop
  //     a_bit = 1;
  //   }
  //   cprintf("node x -- va: %p access: %d\n accessed: ", p->clock_queue[i].va, a_bit);
  // }

}
80108e93:	eb 1a                	jmp    80108eaf <enqueue+0x1d0>
    for (;;p->q_head = p->q_head->next) {
80108e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e98:	8b 80 fc 00 00 00    	mov    0xfc(%eax),%eax
80108e9e:	8b 50 04             	mov    0x4(%eax),%edx
80108ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ea4:	89 90 fc 00 00 00    	mov    %edx,0xfc(%eax)
80108eaa:	e9 2f ff ff ff       	jmp    80108dde <enqueue+0xff>
}
80108eaf:	90                   	nop
80108eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108eb3:	c9                   	leave  
80108eb4:	c3                   	ret    

80108eb5 <mdecrypt>:


int mdecrypt(char *virtual_addr) {
80108eb5:	f3 0f 1e fb          	endbr32 
80108eb9:	55                   	push   %ebp
80108eba:	89 e5                	mov    %esp,%ebp
80108ebc:	83 ec 28             	sub    $0x28,%esp


  // After the page is decrypted, check which page needs to be evicted in queue, and add new page to it
  // AND the bit you’re looking for with the pte entry and do some logic checking - to check bits

  cprintf("p4Debug:  mdecrypt VPN %d, %p, pid %d\n", PPN(virtual_addr), virtual_addr, myproc()->pid);
80108ebf:	e8 fd b6 ff ff       	call   801045c1 <myproc>
80108ec4:	8b 40 10             	mov    0x10(%eax),%eax
80108ec7:	8b 55 08             	mov    0x8(%ebp),%edx
80108eca:	c1 ea 0c             	shr    $0xc,%edx
80108ecd:	50                   	push   %eax
80108ece:	ff 75 08             	pushl  0x8(%ebp)
80108ed1:	52                   	push   %edx
80108ed2:	68 3c 9e 10 80       	push   $0x80109e3c
80108ed7:	e8 3c 75 ff ff       	call   80100418 <cprintf>
80108edc:	83 c4 10             	add    $0x10,%esp
  //p4Debug: virtual_addr is a virtual address in this PID's userspace.
  struct proc * p = myproc();
80108edf:	e8 dd b6 ff ff       	call   801045c1 <myproc>
80108ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t* mypd = p->pgdir;
80108ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eea:	8b 40 04             	mov    0x4(%eax),%eax
80108eed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  //set the present bit to true and encrypt bit to false
  pte_t * pte = walkpgdir(mypd, virtual_addr, 0);
80108ef0:	83 ec 04             	sub    $0x4,%esp
80108ef3:	6a 00                	push   $0x0
80108ef5:	ff 75 08             	pushl  0x8(%ebp)
80108ef8:	ff 75 e8             	pushl  -0x18(%ebp)
80108efb:	e8 0d f3 ff ff       	call   8010820d <walkpgdir>
80108f00:	83 c4 10             	add    $0x10,%esp
80108f03:	89 45 e4             	mov    %eax,-0x1c(%ebp)


    cprintf("%d\n", CLOCKSIZE);
80108f06:	83 ec 08             	sub    $0x8,%esp
80108f09:	6a 08                	push   $0x8
80108f0b:	68 63 9e 10 80       	push   $0x80109e63
80108f10:	e8 03 75 ff ff       	call   80100418 <cprintf>
80108f15:	83 c4 10             	add    $0x10,%esp
    

  if (!pte || *pte == 0) {
80108f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108f1c:	74 09                	je     80108f27 <mdecrypt+0x72>
80108f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f21:	8b 00                	mov    (%eax),%eax
80108f23:	85 c0                	test   %eax,%eax
80108f25:	75 1a                	jne    80108f41 <mdecrypt+0x8c>
    cprintf("p4Debug: walkpgdir failed\n");
80108f27:	83 ec 0c             	sub    $0xc,%esp
80108f2a:	68 67 9e 10 80       	push   $0x80109e67
80108f2f:	e8 e4 74 ff ff       	call   80100418 <cprintf>
80108f34:	83 c4 10             	add    $0x10,%esp
    return -1;
80108f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f3c:	e9 2a 01 00 00       	jmp    8010906b <mdecrypt+0x1b6>
  }
  cprintf("p4Debug: pte was %x\n", *pte);
80108f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f44:	8b 00                	mov    (%eax),%eax
80108f46:	83 ec 08             	sub    $0x8,%esp
80108f49:	50                   	push   %eax
80108f4a:	68 82 9e 10 80       	push   $0x80109e82
80108f4f:	e8 c4 74 ff ff       	call   80100418 <cprintf>
80108f54:	83 c4 10             	add    $0x10,%esp
  *pte = *pte & ~PTE_E;
80108f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f5a:	8b 00                	mov    (%eax),%eax
80108f5c:	80 e4 fb             	and    $0xfb,%ah
80108f5f:	89 c2                	mov    %eax,%edx
80108f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f64:	89 10                	mov    %edx,(%eax)
  *pte = *pte | PTE_P;
80108f66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f69:	8b 00                	mov    (%eax),%eax
80108f6b:	83 c8 01             	or     $0x1,%eax
80108f6e:	89 c2                	mov    %eax,%edx
80108f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f73:	89 10                	mov    %edx,(%eax)
  *pte = *pte | PTE_A;
80108f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f78:	8b 00                	mov    (%eax),%eax
80108f7a:	83 c8 20             	or     $0x20,%eax
80108f7d:	89 c2                	mov    %eax,%edx
80108f7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f82:	89 10                	mov    %edx,(%eax)
  cprintf("p4Debug: pte is %x\n", *pte);
80108f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f87:	8b 00                	mov    (%eax),%eax
80108f89:	83 ec 08             	sub    $0x8,%esp
80108f8c:	50                   	push   %eax
80108f8d:	68 97 9e 10 80       	push   $0x80109e97
80108f92:	e8 81 74 ff ff       	call   80100418 <cprintf>
80108f97:	83 c4 10             	add    $0x10,%esp
  char * original = uva2ka(mypd, virtual_addr) + OFFSET(virtual_addr);
80108f9a:	83 ec 08             	sub    $0x8,%esp
80108f9d:	ff 75 08             	pushl  0x8(%ebp)
80108fa0:	ff 75 e8             	pushl  -0x18(%ebp)
80108fa3:	e8 49 fb ff ff       	call   80108af1 <uva2ka>
80108fa8:	83 c4 10             	add    $0x10,%esp
80108fab:	8b 55 08             	mov    0x8(%ebp),%edx
80108fae:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80108fb4:	01 d0                	add    %edx,%eax
80108fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  cprintf("p4Debug: Original in decrypt was %p\n", original);
80108fb9:	83 ec 08             	sub    $0x8,%esp
80108fbc:	ff 75 e0             	pushl  -0x20(%ebp)
80108fbf:	68 ac 9e 10 80       	push   $0x80109eac
80108fc4:	e8 4f 74 ff ff       	call   80100418 <cprintf>
80108fc9:	83 c4 10             	add    $0x10,%esp
  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
80108fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80108fcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fd4:	89 45 08             	mov    %eax,0x8(%ebp)
  cprintf("p4Debug: mdecrypt: rounded down va is %p\n", virtual_addr);
80108fd7:	83 ec 08             	sub    $0x8,%esp
80108fda:	ff 75 08             	pushl  0x8(%ebp)
80108fdd:	68 d4 9e 10 80       	push   $0x80109ed4
80108fe2:	e8 31 74 ff ff       	call   80100418 <cprintf>
80108fe7:	83 c4 10             	add    $0x10,%esp

  char * kvp = uva2ka(mypd, virtual_addr);
80108fea:	83 ec 08             	sub    $0x8,%esp
80108fed:	ff 75 08             	pushl  0x8(%ebp)
80108ff0:	ff 75 e8             	pushl  -0x18(%ebp)
80108ff3:	e8 f9 fa ff ff       	call   80108af1 <uva2ka>
80108ff8:	83 c4 10             	add    $0x10,%esp
80108ffb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (!kvp || *kvp == 0) {
80108ffe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80109002:	74 0a                	je     8010900e <mdecrypt+0x159>
80109004:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109007:	0f b6 00             	movzbl (%eax),%eax
8010900a:	84 c0                	test   %al,%al
8010900c:	75 07                	jne    80109015 <mdecrypt+0x160>
    return -1;
8010900e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109013:	eb 56                	jmp    8010906b <mdecrypt+0x1b6>
  }
  char * slider = virtual_addr;
80109015:	8b 45 08             	mov    0x8(%ebp),%eax
80109018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
8010901b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80109022:	eb 17                	jmp    8010903b <mdecrypt+0x186>
    *slider = *slider ^ 0xFF;
80109024:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109027:	0f b6 00             	movzbl (%eax),%eax
8010902a:	f7 d0                	not    %eax
8010902c:	89 c2                	mov    %eax,%edx
8010902e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109031:	88 10                	mov    %dl,(%eax)
    slider++;
80109033:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  for (int offset = 0; offset < PGSIZE; offset++) {
80109037:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010903b:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80109042:	7e e0                	jle    80109024 <mdecrypt+0x16f>
  }

  enqueue(virtual_addr, p, mypd);
80109044:	83 ec 04             	sub    $0x4,%esp
80109047:	ff 75 e8             	pushl  -0x18(%ebp)
8010904a:	ff 75 ec             	pushl  -0x14(%ebp)
8010904d:	ff 75 08             	pushl  0x8(%ebp)
80109050:	e8 8a fc ff ff       	call   80108cdf <enqueue>
80109055:	83 c4 10             	add    $0x10,%esp
  //     //if queue has an empty spot, add it.
  //     if (proc->clock_queue[i].PTE_A == 0) {
  //         proc->clock_queue[i].vpn = 100; // Set the page address, check mmu.h
  //     }
  // }
  switchuvm(p);
80109058:	83 ec 0c             	sub    $0xc,%esp
8010905b:	ff 75 ec             	pushl  -0x14(%ebp)
8010905e:	e8 d1 f3 ff ff       	call   80108434 <switchuvm>
80109063:	83 c4 10             	add    $0x10,%esp

  

  return 0;
80109066:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010906b:	c9                   	leave  
8010906c:	c3                   	ret    

8010906d <mencrypt>:

int mencrypt(char *virtual_addr, int len) {
8010906d:	f3 0f 1e fb          	endbr32 
80109071:	55                   	push   %ebp
80109072:	89 e5                	mov    %esp,%ebp
80109074:	83 ec 38             	sub    $0x38,%esp

  cprintf("p4Debug: mencrypt: %p %d\n", virtual_addr, len);
80109077:	83 ec 04             	sub    $0x4,%esp
8010907a:	ff 75 0c             	pushl  0xc(%ebp)
8010907d:	ff 75 08             	pushl  0x8(%ebp)
80109080:	68 fe 9e 10 80       	push   $0x80109efe
80109085:	e8 8e 73 ff ff       	call   80100418 <cprintf>
8010908a:	83 c4 10             	add    $0x10,%esp
  //the given pointer is a virtual address in this pid's userspace
  struct proc * p = myproc();
8010908d:	e8 2f b5 ff ff       	call   801045c1 <myproc>
80109092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pde_t* mypd = p->pgdir;
80109095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109098:	8b 40 04             	mov    0x4(%eax),%eax
8010909b:	89 45 e0             	mov    %eax,-0x20(%ebp)

  virtual_addr = (char *)PGROUNDDOWN((uint)virtual_addr);
8010909e:	8b 45 08             	mov    0x8(%ebp),%eax
801090a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090a6:	89 45 08             	mov    %eax,0x8(%ebp)

  //error checking first. all or nothing.
  char * slider = virtual_addr;
801090a9:	8b 45 08             	mov    0x8(%ebp),%eax
801090ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
801090af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801090b6:	eb 55                	jmp    8010910d <mencrypt+0xa0>
    //check page table for each translation first
    char * kvp = uva2ka(mypd, slider);
801090b8:	83 ec 08             	sub    $0x8,%esp
801090bb:	ff 75 f4             	pushl  -0xc(%ebp)
801090be:	ff 75 e0             	pushl  -0x20(%ebp)
801090c1:	e8 2b fa ff ff       	call   80108af1 <uva2ka>
801090c6:	83 c4 10             	add    $0x10,%esp
801090c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    cprintf("p4Debug: slider %p, kvp for err check is %p\n",slider, kvp);
801090cc:	83 ec 04             	sub    $0x4,%esp
801090cf:	ff 75 d0             	pushl  -0x30(%ebp)
801090d2:	ff 75 f4             	pushl  -0xc(%ebp)
801090d5:	68 18 9f 10 80       	push   $0x80109f18
801090da:	e8 39 73 ff ff       	call   80100418 <cprintf>
801090df:	83 c4 10             	add    $0x10,%esp
    if (!kvp) {
801090e2:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
801090e6:	75 1a                	jne    80109102 <mencrypt+0x95>
      cprintf("p4Debug: mencrypt: kvp = NULL\n");
801090e8:	83 ec 0c             	sub    $0xc,%esp
801090eb:	68 48 9f 10 80       	push   $0x80109f48
801090f0:	e8 23 73 ff ff       	call   80100418 <cprintf>
801090f5:	83 c4 10             	add    $0x10,%esp
      return -1;
801090f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801090fd:	e9 3f 01 00 00       	jmp    80109241 <mencrypt+0x1d4>
    }
    slider = slider + PGSIZE;
80109102:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  for (int i = 0; i < len; i++) { 
80109109:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010910d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109110:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109113:	7c a3                	jl     801090b8 <mencrypt+0x4b>
  }

  //encrypt stage. Have to do this before setting flag 
  //or else we'll page fault
  slider = virtual_addr;
80109115:	8b 45 08             	mov    0x8(%ebp),%eax
80109118:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for (int i = 0; i < len; i++) {
8010911b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80109122:	e9 f8 00 00 00       	jmp    8010921f <mencrypt+0x1b2>
    cprintf("p4Debug: mencryptr: VPN %d, %p\n", PPN(slider), slider);
80109127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912a:	c1 e8 0c             	shr    $0xc,%eax
8010912d:	83 ec 04             	sub    $0x4,%esp
80109130:	ff 75 f4             	pushl  -0xc(%ebp)
80109133:	50                   	push   %eax
80109134:	68 68 9f 10 80       	push   $0x80109f68
80109139:	e8 da 72 ff ff       	call   80100418 <cprintf>
8010913e:	83 c4 10             	add    $0x10,%esp
    //kvp = kernel virtual pointer
    //virtual address in kernel space that maps to the given pointer
    char * kvp = uva2ka(mypd, slider);
80109141:	83 ec 08             	sub    $0x8,%esp
80109144:	ff 75 f4             	pushl  -0xc(%ebp)
80109147:	ff 75 e0             	pushl  -0x20(%ebp)
8010914a:	e8 a2 f9 ff ff       	call   80108af1 <uva2ka>
8010914f:	83 c4 10             	add    $0x10,%esp
80109152:	89 45 dc             	mov    %eax,-0x24(%ebp)
    cprintf("p4Debug: kvp for encrypt stage is %p\n", kvp);
80109155:	83 ec 08             	sub    $0x8,%esp
80109158:	ff 75 dc             	pushl  -0x24(%ebp)
8010915b:	68 88 9f 10 80       	push   $0x80109f88
80109160:	e8 b3 72 ff ff       	call   80100418 <cprintf>
80109165:	83 c4 10             	add    $0x10,%esp
    pte_t * mypte = walkpgdir(mypd, slider, 0);
80109168:	83 ec 04             	sub    $0x4,%esp
8010916b:	6a 00                	push   $0x0
8010916d:	ff 75 f4             	pushl  -0xc(%ebp)
80109170:	ff 75 e0             	pushl  -0x20(%ebp)
80109173:	e8 95 f0 ff ff       	call   8010820d <walkpgdir>
80109178:	83 c4 10             	add    $0x10,%esp
8010917b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("p4Debug: pte is %x\n", *mypte);
8010917e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109181:	8b 00                	mov    (%eax),%eax
80109183:	83 ec 08             	sub    $0x8,%esp
80109186:	50                   	push   %eax
80109187:	68 97 9e 10 80       	push   $0x80109e97
8010918c:	e8 87 72 ff ff       	call   80100418 <cprintf>
80109191:	83 c4 10             	add    $0x10,%esp
    if (*mypte & PTE_E) {
80109194:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109197:	8b 00                	mov    (%eax),%eax
80109199:	25 00 04 00 00       	and    $0x400,%eax
8010919e:	85 c0                	test   %eax,%eax
801091a0:	74 19                	je     801091bb <mencrypt+0x14e>
      cprintf("p4Debug: already encrypted\n");
801091a2:	83 ec 0c             	sub    $0xc,%esp
801091a5:	68 ae 9f 10 80       	push   $0x80109fae
801091aa:	e8 69 72 ff ff       	call   80100418 <cprintf>
801091af:	83 c4 10             	add    $0x10,%esp
      slider += PGSIZE;
801091b2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
      continue;
801091b9:	eb 60                	jmp    8010921b <mencrypt+0x1ae>
    }
    for (int offset = 0; offset < PGSIZE; offset++) {
801091bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
801091c2:	eb 17                	jmp    801091db <mencrypt+0x16e>
      *slider = *slider ^ 0xFF;
801091c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c7:	0f b6 00             	movzbl (%eax),%eax
801091ca:	f7 d0                	not    %eax
801091cc:	89 c2                	mov    %eax,%edx
801091ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091d1:	88 10                	mov    %dl,(%eax)
      slider++;
801091d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    for (int offset = 0; offset < PGSIZE; offset++) {
801091d7:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
801091db:	81 7d e8 ff 0f 00 00 	cmpl   $0xfff,-0x18(%ebp)
801091e2:	7e e0                	jle    801091c4 <mencrypt+0x157>
    }
    char * kvp_translated = translate_and_set(mypd, slider-PGSIZE);
801091e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e7:	2d 00 10 00 00       	sub    $0x1000,%eax
801091ec:	83 ec 08             	sub    $0x8,%esp
801091ef:	50                   	push   %eax
801091f0:	ff 75 e0             	pushl  -0x20(%ebp)
801091f3:	e8 f4 f9 ff ff       	call   80108bec <translate_and_set>
801091f8:	83 c4 10             	add    $0x10,%esp
801091fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (!kvp_translated) {
801091fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80109202:	75 17                	jne    8010921b <mencrypt+0x1ae>
      cprintf("p4Debug: translate failed!");
80109204:	83 ec 0c             	sub    $0xc,%esp
80109207:	68 ca 9f 10 80       	push   $0x80109fca
8010920c:	e8 07 72 ff ff       	call   80100418 <cprintf>
80109211:	83 c4 10             	add    $0x10,%esp
      return -1;
80109214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109219:	eb 26                	jmp    80109241 <mencrypt+0x1d4>
  for (int i = 0; i < len; i++) {
8010921b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010921f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109222:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109225:	0f 8c fc fe ff ff    	jl     80109127 <mencrypt+0xba>
    }
  }

  switchuvm(myproc());
8010922b:	e8 91 b3 ff ff       	call   801045c1 <myproc>
80109230:	83 ec 0c             	sub    $0xc,%esp
80109233:	50                   	push   %eax
80109234:	e8 fb f1 ff ff       	call   80108434 <switchuvm>
80109239:	83 c4 10             	add    $0x10,%esp
  return 0;
8010923c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109241:	c9                   	leave  
80109242:	c3                   	ret    

80109243 <not_in_queue>:

int not_in_queue(pte_t * pte) {
80109243:	f3 0f 1e fb          	endbr32 
80109247:	55                   	push   %ebp
80109248:	89 e5                	mov    %esp,%ebp
8010924a:	83 ec 18             	sub    $0x18,%esp
  struct proc * p = myproc();
8010924d:	e8 6f b3 ff ff       	call   801045c1 <myproc>
80109252:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for (int i = 0; i < CLOCKSIZE; i++) {
80109255:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010925c:	eb 38                	jmp    80109296 <not_in_queue+0x53>
    if (pte == walkpgdir(p->pgdir, p->clock_queue[i].va, 0)) { return 0; }
8010925e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109261:	8b 55 f4             	mov    -0xc(%ebp),%edx
80109264:	83 c2 07             	add    $0x7,%edx
80109267:	c1 e2 04             	shl    $0x4,%edx
8010926a:	01 d0                	add    %edx,%eax
8010926c:	83 c0 14             	add    $0x14,%eax
8010926f:	8b 10                	mov    (%eax),%edx
80109271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109274:	8b 40 04             	mov    0x4(%eax),%eax
80109277:	83 ec 04             	sub    $0x4,%esp
8010927a:	6a 00                	push   $0x0
8010927c:	52                   	push   %edx
8010927d:	50                   	push   %eax
8010927e:	e8 8a ef ff ff       	call   8010820d <walkpgdir>
80109283:	83 c4 10             	add    $0x10,%esp
80109286:	39 45 08             	cmp    %eax,0x8(%ebp)
80109289:	75 07                	jne    80109292 <not_in_queue+0x4f>
8010928b:	b8 00 00 00 00       	mov    $0x0,%eax
80109290:	eb 0f                	jmp    801092a1 <not_in_queue+0x5e>
  for (int i = 0; i < CLOCKSIZE; i++) {
80109292:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109296:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010929a:	7e c2                	jle    8010925e <not_in_queue+0x1b>
  }
  return 1;
8010929c:	b8 01 00 00 00       	mov    $0x1,%eax
}
801092a1:	c9                   	leave  
801092a2:	c3                   	ret    

801092a3 <getpgtable>:

int getpgtable(struct pt_entry* pt_entries, int num, int wsetOnly) {
801092a3:	f3 0f 1e fb          	endbr32 
801092a7:	55                   	push   %ebp
801092a8:	89 e5                	mov    %esp,%ebp
801092aa:	83 ec 28             	sub    $0x28,%esp
  cprintf("p4Debug: getpgtable: %p, %d\n", pt_entries, num);
801092ad:	83 ec 04             	sub    $0x4,%esp
801092b0:	ff 75 0c             	pushl  0xc(%ebp)
801092b3:	ff 75 08             	pushl  0x8(%ebp)
801092b6:	68 e5 9f 10 80       	push   $0x80109fe5
801092bb:	e8 58 71 ff ff       	call   80100418 <cprintf>
801092c0:	83 c4 10             	add    $0x10,%esp

  struct proc *curproc = myproc();
801092c3:	e8 f9 b2 ff ff       	call   801045c1 <myproc>
801092c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  pde_t *pgdir = curproc->pgdir;
801092cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092ce:	8b 40 04             	mov    0x4(%eax),%eax
801092d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  uint uva = 0;
801092d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if (curproc->sz % PGSIZE == 0)
801092db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092de:	8b 00                	mov    (%eax),%eax
801092e0:	25 ff 0f 00 00       	and    $0xfff,%eax
801092e5:	85 c0                	test   %eax,%eax
801092e7:	75 0f                	jne    801092f8 <getpgtable+0x55>
    uva = curproc->sz - PGSIZE;
801092e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092ec:	8b 00                	mov    (%eax),%eax
801092ee:	2d 00 10 00 00       	sub    $0x1000,%eax
801092f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801092f6:	eb 0d                	jmp    80109305 <getpgtable+0x62>
  else 
    uva = PGROUNDDOWN(curproc->sz);
801092f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092fb:	8b 00                	mov    (%eax),%eax
801092fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109302:	89 45 f4             	mov    %eax,-0xc(%ebp)

  int i = 0;
80109305:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (;;uva -=PGSIZE)
  {
    
    pte_t *pte = walkpgdir(pgdir, (const void *)uva, 0);
8010930c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010930f:	83 ec 04             	sub    $0x4,%esp
80109312:	6a 00                	push   $0x0
80109314:	50                   	push   %eax
80109315:	ff 75 e8             	pushl  -0x18(%ebp)
80109318:	e8 f0 ee ff ff       	call   8010820d <walkpgdir>
8010931d:	83 c4 10             	add    $0x10,%esp
80109320:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if (!(*pte & PTE_U) || !(*pte & (PTE_P | PTE_E)))
80109323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109326:	8b 00                	mov    (%eax),%eax
80109328:	83 e0 04             	and    $0x4,%eax
8010932b:	85 c0                	test   %eax,%eax
8010932d:	0f 84 9a 01 00 00    	je     801094cd <getpgtable+0x22a>
80109333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109336:	8b 00                	mov    (%eax),%eax
80109338:	25 01 04 00 00       	and    $0x401,%eax
8010933d:	85 c0                	test   %eax,%eax
8010933f:	0f 84 88 01 00 00    	je     801094cd <getpgtable+0x22a>
      continue;
    
    if (wsetOnly && not_in_queue(pte)) {
80109345:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109349:	74 16                	je     80109361 <getpgtable+0xbe>
8010934b:	83 ec 0c             	sub    $0xc,%esp
8010934e:	ff 75 e4             	pushl  -0x1c(%ebp)
80109351:	e8 ed fe ff ff       	call   80109243 <not_in_queue>
80109356:	83 c4 10             	add    $0x10,%esp
80109359:	85 c0                	test   %eax,%eax
8010935b:	0f 85 6f 01 00 00    	jne    801094d0 <getpgtable+0x22d>
      continue;
    }

    pt_entries[i].pdx = PDX(uva);
80109361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109364:	c1 e8 16             	shr    $0x16,%eax
80109367:	89 c1                	mov    %eax,%ecx
80109369:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010936c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80109373:	8b 45 08             	mov    0x8(%ebp),%eax
80109376:	01 c2                	add    %eax,%edx
80109378:	89 c8                	mov    %ecx,%eax
8010937a:	66 25 ff 03          	and    $0x3ff,%ax
8010937e:	66 25 ff 03          	and    $0x3ff,%ax
80109382:	89 c1                	mov    %eax,%ecx
80109384:	0f b7 02             	movzwl (%edx),%eax
80109387:	66 25 00 fc          	and    $0xfc00,%ax
8010938b:	09 c8                	or     %ecx,%eax
8010938d:	66 89 02             	mov    %ax,(%edx)
    pt_entries[i].ptx = PTX(uva);
80109390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109393:	c1 e8 0c             	shr    $0xc,%eax
80109396:	89 c1                	mov    %eax,%ecx
80109398:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010939b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
801093a2:	8b 45 08             	mov    0x8(%ebp),%eax
801093a5:	01 c2                	add    %eax,%edx
801093a7:	89 c8                	mov    %ecx,%eax
801093a9:	66 25 ff 03          	and    $0x3ff,%ax
801093ad:	0f b7 c0             	movzwl %ax,%eax
801093b0:	25 ff 03 00 00       	and    $0x3ff,%eax
801093b5:	c1 e0 0a             	shl    $0xa,%eax
801093b8:	89 c1                	mov    %eax,%ecx
801093ba:	8b 02                	mov    (%edx),%eax
801093bc:	25 ff 03 f0 ff       	and    $0xfff003ff,%eax
801093c1:	09 c8                	or     %ecx,%eax
801093c3:	89 02                	mov    %eax,(%edx)
    pt_entries[i].ppage = *pte >> PTXSHIFT;
801093c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801093c8:	8b 00                	mov    (%eax),%eax
801093ca:	c1 e8 0c             	shr    $0xc,%eax
801093cd:	89 c2                	mov    %eax,%edx
801093cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801093d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801093d9:	8b 45 08             	mov    0x8(%ebp),%eax
801093dc:	01 c8                	add    %ecx,%eax
801093de:	81 e2 ff ff 0f 00    	and    $0xfffff,%edx
801093e4:	89 d1                	mov    %edx,%ecx
801093e6:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
801093ec:	8b 50 04             	mov    0x4(%eax),%edx
801093ef:	81 e2 00 00 f0 ff    	and    $0xfff00000,%edx
801093f5:	09 ca                	or     %ecx,%edx
801093f7:	89 50 04             	mov    %edx,0x4(%eax)
    pt_entries[i].present = *pte & PTE_P;
801093fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801093fd:	8b 08                	mov    (%eax),%ecx
801093ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109402:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80109409:	8b 45 08             	mov    0x8(%ebp),%eax
8010940c:	01 c2                	add    %eax,%edx
8010940e:	89 c8                	mov    %ecx,%eax
80109410:	83 e0 01             	and    $0x1,%eax
80109413:	83 e0 01             	and    $0x1,%eax
80109416:	c1 e0 04             	shl    $0x4,%eax
80109419:	89 c1                	mov    %eax,%ecx
8010941b:	0f b6 42 06          	movzbl 0x6(%edx),%eax
8010941f:	83 e0 ef             	and    $0xffffffef,%eax
80109422:	09 c8                	or     %ecx,%eax
80109424:	88 42 06             	mov    %al,0x6(%edx)
    pt_entries[i].writable = (*pte & PTE_W) > 0;
80109427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010942a:	8b 00                	mov    (%eax),%eax
8010942c:	83 e0 02             	and    $0x2,%eax
8010942f:	89 c2                	mov    %eax,%edx
80109431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109434:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010943b:	8b 45 08             	mov    0x8(%ebp),%eax
8010943e:	01 c8                	add    %ecx,%eax
80109440:	85 d2                	test   %edx,%edx
80109442:	0f 95 c2             	setne  %dl
80109445:	83 e2 01             	and    $0x1,%edx
80109448:	89 d1                	mov    %edx,%ecx
8010944a:	c1 e1 05             	shl    $0x5,%ecx
8010944d:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80109451:	83 e2 df             	and    $0xffffffdf,%edx
80109454:	09 ca                	or     %ecx,%edx
80109456:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].encrypted = (*pte & PTE_E) > 0;
80109459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010945c:	8b 00                	mov    (%eax),%eax
8010945e:	25 00 04 00 00       	and    $0x400,%eax
80109463:	89 c2                	mov    %eax,%edx
80109465:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109468:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010946f:	8b 45 08             	mov    0x8(%ebp),%eax
80109472:	01 c8                	add    %ecx,%eax
80109474:	85 d2                	test   %edx,%edx
80109476:	0f 95 c2             	setne  %dl
80109479:	89 d1                	mov    %edx,%ecx
8010947b:	c1 e1 07             	shl    $0x7,%ecx
8010947e:	0f b6 50 06          	movzbl 0x6(%eax),%edx
80109482:	83 e2 7f             	and    $0x7f,%edx
80109485:	09 ca                	or     %ecx,%edx
80109487:	88 50 06             	mov    %dl,0x6(%eax)
    pt_entries[i].ref = (*pte & PTE_A) > 0;
8010948a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010948d:	8b 00                	mov    (%eax),%eax
8010948f:	83 e0 20             	and    $0x20,%eax
80109492:	89 c2                	mov    %eax,%edx
80109494:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109497:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010949e:	8b 45 08             	mov    0x8(%ebp),%eax
801094a1:	01 c8                	add    %ecx,%eax
801094a3:	85 d2                	test   %edx,%edx
801094a5:	0f 95 c2             	setne  %dl
801094a8:	89 d1                	mov    %edx,%ecx
801094aa:	83 e1 01             	and    $0x1,%ecx
801094ad:	0f b6 50 07          	movzbl 0x7(%eax),%edx
801094b1:	83 e2 fe             	and    $0xfffffffe,%edx
801094b4:	09 ca                	or     %ecx,%edx
801094b6:	88 50 07             	mov    %dl,0x7(%eax)
    //PT_A flag needs to be modified as per clock algo.
    i ++;
801094b9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if (uva == 0 || i == num) break;
801094bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801094c1:	74 1a                	je     801094dd <getpgtable+0x23a>
801094c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801094c9:	74 12                	je     801094dd <getpgtable+0x23a>
801094cb:	eb 04                	jmp    801094d1 <getpgtable+0x22e>
      continue;
801094cd:	90                   	nop
801094ce:	eb 01                	jmp    801094d1 <getpgtable+0x22e>
      continue;
801094d0:	90                   	nop
  for (;;uva -=PGSIZE)
801094d1:	81 6d f4 00 10 00 00 	subl   $0x1000,-0xc(%ebp)
  {
801094d8:	e9 2f fe ff ff       	jmp    8010930c <getpgtable+0x69>

  }

  return i;
801094dd:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
801094e0:	c9                   	leave  
801094e1:	c3                   	ret    

801094e2 <dump_rawphymem>:


int dump_rawphymem(char *physical_addr, char * buffer) {
801094e2:	f3 0f 1e fb          	endbr32 
801094e6:	55                   	push   %ebp
801094e7:	89 e5                	mov    %esp,%ebp
801094e9:	56                   	push   %esi
801094ea:	53                   	push   %ebx
801094eb:	83 ec 10             	sub    $0x10,%esp
  *buffer = *buffer;
801094ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801094f1:	0f b6 10             	movzbl (%eax),%edx
801094f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801094f7:	88 10                	mov    %dl,(%eax)
  cprintf("p4Debug: dump_rawphymem: %p, %p\n", physical_addr, buffer);
801094f9:	83 ec 04             	sub    $0x4,%esp
801094fc:	ff 75 0c             	pushl  0xc(%ebp)
801094ff:	ff 75 08             	pushl  0x8(%ebp)
80109502:	68 04 a0 10 80       	push   $0x8010a004
80109507:	e8 0c 6f ff ff       	call   80100418 <cprintf>
8010950c:	83 c4 10             	add    $0x10,%esp
  int retval = copyout(myproc()->pgdir, (uint) buffer, (void *) PGROUNDDOWN((int)P2V(physical_addr)), PGSIZE);
8010950f:	8b 45 08             	mov    0x8(%ebp),%eax
80109512:	05 00 00 00 80       	add    $0x80000000,%eax
80109517:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010951c:	89 c6                	mov    %eax,%esi
8010951e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80109521:	e8 9b b0 ff ff       	call   801045c1 <myproc>
80109526:	8b 40 04             	mov    0x4(%eax),%eax
80109529:	68 00 10 00 00       	push   $0x1000
8010952e:	56                   	push   %esi
8010952f:	53                   	push   %ebx
80109530:	50                   	push   %eax
80109531:	e8 14 f6 ff ff       	call   80108b4a <copyout>
80109536:	83 c4 10             	add    $0x10,%esp
80109539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (retval)
8010953c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109540:	74 07                	je     80109549 <dump_rawphymem+0x67>
    return -1;
80109542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109547:	eb 05                	jmp    8010954e <dump_rawphymem+0x6c>
  return 0;
80109549:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010954e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109551:	5b                   	pop    %ebx
80109552:	5e                   	pop    %esi
80109553:	5d                   	pop    %ebp
80109554:	c3                   	ret    

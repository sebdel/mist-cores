;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Fri Nov  4 17:05:16 2016
;--------------------------------------------------------
	.module synth
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _ym2151_write
	.globl _ei
	.globl _init_interrupt_table
	.globl _die
	.globl _put_pixel
	.globl _cls
	.globl _clock50KHz
	.globl _vbl
	.globl _move_mouse
	.globl _printf
	.globl _cur_y
	.globl _cur_x
	.globl _mouse_b
	.globl _mouse_y
	.globl _mouse_x
	.globl _putchar
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_PsgAddrPort	=	0x0010
_PsgDataPort	=	0x0011
_keys	=	0x0020
_mouse_x_reg	=	0x0030
_mouse_y_reg	=	0x0031
_mouse_but_reg	=	0x0032
_FmgAddrPort	=	0x0040
_FmgDataPort	=	0x0041
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_mouse_x::
	.ds 2
_mouse_y::
	.ds 2
_mouse_b::
	.ds 1
_cur_x::
	.ds 1
_cur_y::
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;synth.c:46: void move_mouse() {
;	---------------------------------
; Function move_mouse
; ---------------------------------
_move_mouse::
;synth.c:49: mouse_x += (char)mouse_x_reg;
	in	a,(_mouse_x_reg)
	ld	d,a
	rla
	sbc	a, a
	ld	e,a
	ld	hl,#_mouse_x
	ld	a,(hl)
	add	a, d
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a, e
	ld	(hl),a
;synth.c:50: mouse_y -= (char)mouse_y_reg;
	in	a,(_mouse_y_reg)
	ld	d,a
	rla
	sbc	a, a
	ld	e,a
	ld	hl,#_mouse_y
	ld	a,(hl)
	sub	a, d
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	sbc	a, e
	ld	(hl),a
;synth.c:51: mouse_b = (char)mouse_but_reg;
	in	a,(_mouse_but_reg)
	ld	iy,#_mouse_b
	ld	0 (iy),a
;synth.c:54: if(mouse_x < 0)   mouse_x = 0;
	ld	a,(#_mouse_x + 1)
	bit	7,a
	jr	Z,00102$
	ld	hl,#0x0000
	ld	(_mouse_x),hl
00102$:
;synth.c:55: if(mouse_x > 319) mouse_x = 319;
	ld	a,#0x3F
	ld	iy,#_mouse_x
	cp	a, 0 (iy)
	ld	a,#0x01
	ld	iy,#_mouse_x
	sbc	a, 1 (iy)
	jp	PO, 00127$
	xor	a, #0x80
00127$:
	jp	P,00104$
	ld	hl,#0x013F
	ld	(_mouse_x),hl
00104$:
;synth.c:56: if(mouse_y < 0)   mouse_y = 0;
	ld	a,(#_mouse_y + 1)
	bit	7,a
	jr	Z,00106$
	ld	hl,#0x0000
	ld	(_mouse_y),hl
00106$:
;synth.c:57: if(mouse_y > 239)  mouse_y = 239;
	ld	a,#0xEF
	ld	iy,#_mouse_y
	cp	a, 0 (iy)
	ld	a,#0x00
	ld	iy,#_mouse_y
	sbc	a, 1 (iy)
	jp	PO, 00128$
	xor	a, #0x80
00128$:
	jp	P,00108$
	ld	hl,#0x00EF
	ld	(_mouse_y),hl
00108$:
;synth.c:60: *(unsigned char*)0x7efe = mouse_x;
	ld	a,(#_mouse_x + 0)
	ld	(#0x7EFE),a
;synth.c:61: *(unsigned char*)0x7eff = (mouse_x & 0x100) >> 8;
	ld	a,(#_mouse_x + 1)
	and	a, #0x01
	ld	d,a
	rlc	a
	sbc	a, a
	ld	hl,#0x7EFF
	ld	(hl),d
;synth.c:62: *(unsigned char*)0x7f00 = mouse_y;
	ld	a,(#_mouse_y + 0)
	ld	(#0x7F00),a
	ret
;synth.c:66: void vbl(void) __interrupt (0x30) {
;	---------------------------------
; Function vbl
; ---------------------------------
_vbl::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:68: move_mouse();
	call	_move_mouse
;synth.c:73: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:77: void clock50KHz(void) __interrupt (0x20) {
;	---------------------------------
; Function clock50KHz
; ---------------------------------
_clock50KHz::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:82: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:89: void putchar(char c) {
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;synth.c:91: unsigned char *dptr = (unsigned char*)(80*(8*cur_y) + 2*cur_x);
	ld	iy,#_cur_y
	ld	l,0 (iy)
	ld	h,#0x00
	ld	c, l
	ld	b, h
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	iy,#_cur_x
	ld	l,0 (iy)
	ld	h,#0x00
	add	hl, hl
	add	hl,de
	ld	-5 (ix),l
	ld	-4 (ix),h
;synth.c:94: if(c < 32) {
	ld	a,4 (ix)
	xor	a, #0x80
	sub	a, #0xA0
	jr	NC,00108$
;synth.c:95: if(c == '\r') 
	ld	a,4 (ix)
	sub	a, #0x0D
	jr	NZ,00102$
;synth.c:96: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
00102$:
;synth.c:98: if(c == '\n') {
	ld	a,4 (ix)
	sub	a, #0x0A
	jp	NZ,00118$
;synth.c:99: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:100: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:102: if(cur_y >= 30)
	ld	a,(#_cur_y + 0)
	sub	a, #0x1E
	jp	C,00118$
;synth.c:103: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
;synth.c:105: return;
	jp	00118$
00108$:
;synth.c:108: if(c < 0) return;
	bit	7, 4 (ix)
	jp	NZ,00118$
;synth.c:110: p = font+8*(unsigned char)(c-32);
	ld	a,4 (ix)
	add	a,#0xE0
	ld	l,a
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de,#_font
	add	hl,de
	ld	c, l
	ld	b, h
;synth.c:111: for(i=0;i<8;i++) {
	ld	a,-5 (ix)
	ld	-3 (ix),a
	ld	a,-4 (ix)
	ld	-2 (ix),a
	ld	e,#0x00
00116$:
;synth.c:112: unsigned char l = *p++;
	ld	a,(bc)
	ld	-6 (ix),a
	inc	bc
;synth.c:114: *dptr = ( 	((l & 0x80) ? 0x03:0x00) |
	ld	l,-3 (ix)
	ld	h,-2 (ix)
	bit	7, -6 (ix)
	jr	Z,00120$
	ld	-1 (ix),#0x03
	jr	00121$
00120$:
	ld	-1 (ix),#0x00
00121$:
;synth.c:115: ((l & 0x40) ? 0x0C:0x00) |
	bit	6, -6 (ix)
	jr	Z,00122$
	ld	a,#0x0C
	jr	00123$
00122$:
	ld	a,#0x00
00123$:
	or	a, -1 (ix)
	ld	-1 (ix),a
;synth.c:116: ((l & 0x20) ? 0x30:0x00) |
	bit	5, -6 (ix)
	jr	Z,00124$
	ld	a,#0x30
	jr	00125$
00124$:
	ld	a,#0x00
00125$:
	or	a, -1 (ix)
	ld	-1 (ix),a
;synth.c:117: ((l & 0x10) ? 0xC0:0x00));
	bit	4, -6 (ix)
	jr	Z,00126$
	ld	a,#0xC0
	jr	00127$
00126$:
	ld	a,#0x00
00127$:
	or	a, -1 (ix)
	ld	(hl),a
;synth.c:118: *(dptr + 1) = (((l & 0x08) ? 0x03:0x00) |
	ld	l,-3 (ix)
	ld	h,-2 (ix)
	inc	hl
	bit	3, -6 (ix)
	jr	Z,00128$
	ld	-1 (ix),#0x03
	jr	00129$
00128$:
	ld	-1 (ix),#0x00
00129$:
;synth.c:119: ((l & 0x04) ? 0x0C:0x00) |
	bit	2, -6 (ix)
	jr	Z,00130$
	ld	a,#0x0C
	jr	00131$
00130$:
	ld	a,#0x00
00131$:
	or	a, -1 (ix)
	ld	d,a
;synth.c:120: ((l & 0x02) ? 0x30:0x00) |
	bit	1, -6 (ix)
	jr	Z,00132$
	ld	a,#0x30
	jr	00133$
00132$:
	ld	a,#0x00
00133$:
	or	a, d
	ld	-1 (ix),a
;synth.c:121: ((l & 0x01) ? 0xC0:0x00));
	bit	0, -6 (ix)
	jr	Z,00134$
	ld	a,#0xC0
	jr	00135$
00134$:
	ld	a,#0x00
00135$:
	or	a, -1 (ix)
	ld	(hl),a
;synth.c:122: dptr += 80;
	ld	a,-3 (ix)
	add	a, #0x50
	ld	-3 (ix),a
	ld	a,-2 (ix)
	adc	a, #0x00
	ld	-2 (ix),a
;synth.c:111: for(i=0;i<8;i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x88
	jp	C,00116$
;synth.c:125: cur_x++;
	ld	hl, #_cur_x+0
	inc	(hl)
;synth.c:126: if(cur_x >= 40) {
	ld	a,(#_cur_x + 0)
	sub	a, #0x28
	jr	C,00118$
;synth.c:127: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:128: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:130: if(cur_y >= 30)
	ld	a,(#_cur_y + 0)
	sub	a, #0x1E
	jr	C,00118$
;synth.c:131: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
00118$:
	ld	sp, ix
	pop	ix
	ret
;synth.c:135: void cls(void) {
;	---------------------------------
; Function cls
; ---------------------------------
_cls::
;synth.c:139: for(i = 0; i < 240; i++) {
	ld	hl,#0x0000
	ld	e,l
	ld	d,h
00102$:
;synth.c:140: memset(p, 0, 80);
	ld	b,l
	ld	c,h
	push	hl
	ld	l, b
	ld	h, c
	ld	b, #0x50
00115$:
	ld	(hl), #0x00
	inc	hl
	djnz	00115$
	pop	hl
;synth.c:141: p += 80;
	ld	bc,#0x0050
	add	hl,bc
;synth.c:139: for(i = 0; i < 240; i++) {
	inc	de
	ld	a,e
	sub	a, #0xF0
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00102$
;synth.c:143: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:144: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
	ret
;synth.c:148: void put_pixel(int x, unsigned char y, unsigned char color) {
;	---------------------------------
; Function put_pixel
; ---------------------------------
_put_pixel::
	push	ix
	ld	ix,#0
	add	ix,sp
;synth.c:149: *((unsigned char*)(80*y+(x>>2))) = color;
	ld	c,6 (ix)
	ld	b,#0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e,4 (ix)
	ld	d,5 (ix)
	sra	d
	rr	e
	sra	d
	rr	e
	add	hl,de
	ld	a,7 (ix)
	ld	(hl),a
	pop	ix
	ret
;synth.c:152: void die (FRESULT rc) {
;	---------------------------------
; Function die
; ---------------------------------
_die::
	push	ix
	ld	ix,#0
	add	ix,sp
;synth.c:153: printf("Fail rc=%u", rc);
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#___str_0
	push	de
	push	hl
	call	_printf
	pop	af
	pop	af
00103$:
	jr	00103$
	pop	ix
	ret
___str_0:
	.ascii "Fail rc=%u"
	.db 0x00
;synth.c:163: void init_interrupt_table() {
;	---------------------------------
; Function init_interrupt_table
; ---------------------------------
_init_interrupt_table::
;synth.c:175: __endasm;
	ld hl,#0x8000
	ld a,h
	ld i,a
	ld iy,#_clock50KHz
	ld (#0x8020),iy
	ld iy,#_vbl
	ld (#0x8030),iy
	ret
;synth.c:178: void ei() {
;	---------------------------------
; Function ei
; ---------------------------------
_ei::
;synth.c:183: __endasm;
	im 2
	ei
	ret
;synth.c:186: void ym2151_write(unsigned char reg, unsigned char value) {
;	---------------------------------
; Function ym2151_write
; ---------------------------------
_ym2151_write::
;synth.c:190: for (i = 0; (FmgAddrPort & 0x80) && (i < 100); i++);
	ld	de,#0x0000
00104$:
	in	a,(_FmgAddrPort)
	rlca
	jr	NC,00101$
	ld	a,e
	sub	a, #0x64
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00101$
	inc	de
	jr	00104$
00101$:
;synth.c:191: FmgAddrPort = reg;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgAddrPort),a
;synth.c:192: FmgDataPort = value;
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgDataPort),a
	ret
;synth.c:195: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:198: init_interrupt_table();
	call	_init_interrupt_table
;synth.c:200: cls();
	call	_cls
;synth.c:202: printf("YM2151+YM2149 SoC ready.\r\nPress S or C...");
	ld	hl,#___str_1+0
	push	hl
	call	_printf
	pop	af
;synth.c:205: for(i = 0; i < 8; i++) {
	ld	e,#0x00
00111$:
;synth.c:206: *(char*)(0x7f10+i) = cursor_data[i];
	ld	a,e
	ld	c,a
	rla
	sbc	a, a
	ld	b,a
	ld	iy,#0x7F10
	add	iy, bc
	ld	hl,#_cursor_data
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	0 (iy), a
;synth.c:207: *(char*)(0x7f18+i) = cursor_mask[i];
	ld	hl,#0x7F18
	add	hl,bc
	ld	c, l
	ld	b, h
	ld	hl,#_cursor_mask
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	(bc),a
;synth.c:205: for(i = 0; i < 8; i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00111$
;synth.c:210: *(unsigned char*)0x7efd = 0x00;
	ld	hl,#0x7EFD
	ld	(hl),#0x00
;synth.c:212: *(unsigned char*)0x7efb = CURSOR_COLOR1;
	ld	l, #0xFB
	ld	(hl),#0xFF
;synth.c:213: *(unsigned char*)0x7efc = CURSOR_COLOR2;
	ld	l, #0xFC
	ld	(hl),#0xE0
;synth.c:216: ei();
	call	_ei
;synth.c:219: do {
00108$:
;synth.c:220: char c = keys;
	in	a,(_keys)
	ld	-1 (ix),a
;synth.c:223: if (c & 0x1) { 	// Space
	bit	0, -1 (ix)
	jr	Z,00103$
;synth.c:224: cls();
	call	_cls
;synth.c:225: ym2151_write(0x20, 0xC0);	// L/R
	ld	hl,#0xC020
	push	hl
	call	_ym2151_write
;synth.c:227: ym2151_write(0x28 + ch, 0x00);
	ld	hl, #0x0028
	ex	(sp),hl
	call	_ym2151_write
;synth.c:228: ym2151_write(0x30 + ch, 0x00);
	ld	hl, #0x0030
	ex	(sp),hl
	call	_ym2151_write
;synth.c:229: ym2151_write(0x38 + ch, 0x00);
	ld	hl, #0x0038
	ex	(sp),hl
	call	_ym2151_write
;synth.c:230: ym2151_write(0x40 + ch, 0x00);
	ld	hl, #0x0040
	ex	(sp),hl
	call	_ym2151_write
;synth.c:231: ym2151_write(0x60 + ch, 0x00);
	ld	hl, #0x0060
	ex	(sp),hl
	call	_ym2151_write
;synth.c:232: ym2151_write(0x80 + ch, 0x00);
	ld	hl, #0x0080
	ex	(sp),hl
	call	_ym2151_write
;synth.c:233: ym2151_write(0xA0 + ch, 0x00);
	ld	hl, #0x00A0
	ex	(sp),hl
	call	_ym2151_write
;synth.c:234: ym2151_write(0xC0 + ch, 0x00);
	ld	hl, #0x00C0
	ex	(sp),hl
	call	_ym2151_write
;synth.c:235: ym2151_write(0xE0 + ch, 0x00);
	ld	hl, #0x00E0
	ex	(sp),hl
	call	_ym2151_write
	pop	af
00103$:
;synth.c:237: if (c & 0x2) {	// S
	bit	1, -1 (ix)
	jr	Z,00105$
;synth.c:238: ym2151_write(0x1B, 0xC0);
	ld	hl,#0xC01B
	push	hl
	call	_ym2151_write
;synth.c:239: ym2151_write(0x08, 0x40);	// K_ON, MOD1, CH0
	ld	hl, #0x4008
	ex	(sp),hl
	call	_ym2151_write
	pop	af
00105$:
;synth.c:242: if (c & 0x4) {	// C
	bit	2, -1 (ix)
	jr	Z,00108$
;synth.c:243: ym2151_write(0x1B, 0x00);
	ld	hl,#0x001B
	push	hl
	call	_ym2151_write
;synth.c:244: ym2151_write(0x08, 0x00);	// K_OFF, CH0
	ld	hl, #0x0008
	ex	(sp),hl
	call	_ym2151_write
	pop	af
;synth.c:251: } while(1);
	jp	00108$
	inc	sp
	pop	ix
	ret
___str_1:
	.ascii "YM2151+YM2149 SoC ready."
	.db 0x0D
	.db 0x0A
	.ascii "Press S or C..."
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__mouse_x:
	.dw #0x00A0
__xinit__mouse_y:
	.dw #0x0078
__xinit__mouse_b:
	.db #0x00	; 0
__xinit__cur_x:
	.db #0x00	; 0
__xinit__cur_y:
	.db #0x00	; 0
	.area _CABS (ABS)

;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.4.0 #8981 (Jul 12 2014) (Linux)
; This file was generated Mon Jan 18 23:46:30 2016
;--------------------------------------------------------
	.module boot_rom
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _ei
	.globl _init_interrupt_table
	.globl _display_level
	.globl _splash
	.globl _draw_line
	.globl _die
	.globl _put_pixel
	.globl _cls
	.globl _clock50KHz
	.globl _vbl
	.globl _move_sprite
	.globl _play_music
	.globl _cycle_colors
	.globl _pf_lseek
	.globl _pf_read
	.globl _pf_open
	.globl _pf_mount
	.globl _abs
	.globl _printf
	.globl _cur_y
	.globl _cur_x
	.globl _curve_index
	.globl _rgb_state
	.globl _B
	.globl _G
	.globl _R
	.globl _rsec
	.globl _rptr
	.globl _frames
	.globl _level_c
	.globl _level_b
	.globl _level_a
	.globl _ym_buffer
	.globl _animation
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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ym_buffer::
	.ds 4096
_level_a::
	.ds 1
_level_b::
	.ds 1
_level_c::
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_frames::
	.ds 4
_rptr::
	.ds 2
_rsec::
	.ds 1
_R::
	.ds 1
_G::
	.ds 1
_B::
	.ds 1
_rgb_state::
	.ds 1
_curve_index::
	.ds 2
_cur_x::
	.ds 1
_cur_y::
	.ds 1
_vu_meter:
	.ds 16
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
;boot_rom.c:51: void cycle_colors() {
;	---------------------------------
; Function cycle_colors
; ---------------------------------
_cycle_colors_start::
_cycle_colors:
;boot_rom.c:53: *(unsigned char*)0x3f11 = R;
	ld	hl,#0x3F11
	ld	a,(#_R + 0)
	ld	(hl),a
;boot_rom.c:54: *(unsigned char*)0x3f12 = G;
	ld	l, #0x12
	ld	a,(#_G + 0)
	ld	(hl),a
;boot_rom.c:55: *(unsigned char*)0x3f13 = B;
	ld	l, #0x13
	ld	a,(#_B + 0)
	ld	(hl),a
;boot_rom.c:57: switch (rgb_state) {
	ld	a,#0x05
	ld	iy,#_rgb_state
	sub	a, 0 (iy)
	ret	C
	ld	iy,#_rgb_state
	ld	e,0 (iy)
	ld	d,#0x00
	ld	hl,#00150$
	add	hl,de
	add	hl,de
;boot_rom.c:58: case 0: // R->RG
	jp	(hl)
00150$:
	jr	00101$
	jr	00104$
	jr	00107$
	jr	00110$
	jr	00113$
	jr	00116$
00101$:
;boot_rom.c:59: G += CYCLE_SPEED;
	ld	hl, #_G+0
	inc	(hl)
	ld	hl, #_G+0
	inc	(hl)
;boot_rom.c:60: if (G == 254)
	ld	a,(#_G + 0)
	sub	a, #0xFE
	ret	NZ
;boot_rom.c:61: rgb_state = 1;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x01
;boot_rom.c:62: break;
	ret
;boot_rom.c:63: case 1: // RG->G
00104$:
;boot_rom.c:64: R -= CYCLE_SPEED;
	ld	hl, #_R+0
	dec	(hl)
	ld	hl, #_R+0
	dec	(hl)
;boot_rom.c:65: if (R == 0)
	ld	a,(#_R + 0)
	or	a, a
	ret	NZ
;boot_rom.c:66: rgb_state = 2;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x02
;boot_rom.c:67: break;
	ret
;boot_rom.c:68: case 2: // G->GB
00107$:
;boot_rom.c:69: B += CYCLE_SPEED;
	ld	hl, #_B+0
	inc	(hl)
	ld	hl, #_B+0
	inc	(hl)
;boot_rom.c:70: if (B == 254)
	ld	a,(#_B + 0)
	sub	a, #0xFE
	ret	NZ
;boot_rom.c:71: rgb_state = 3;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x03
;boot_rom.c:72: break;
	ret
;boot_rom.c:73: case 3: // GB->B
00110$:
;boot_rom.c:74: G -= CYCLE_SPEED;
	ld	hl, #_G+0
	dec	(hl)
	ld	hl, #_G+0
	dec	(hl)
;boot_rom.c:75: if (G == 0)
	ld	a,(#_G + 0)
	or	a, a
	ret	NZ
;boot_rom.c:76: rgb_state = 4;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x04
;boot_rom.c:77: break;
	ret
;boot_rom.c:78: case 4: // B->RB
00113$:
;boot_rom.c:79: R += CYCLE_SPEED;
	ld	hl, #_R+0
	inc	(hl)
	ld	hl, #_R+0
	inc	(hl)
;boot_rom.c:80: if (R == 254)
	ld	a,(#_R + 0)
	sub	a, #0xFE
	ret	NZ
;boot_rom.c:81: rgb_state = 5;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x05
;boot_rom.c:82: break;
	ret
;boot_rom.c:83: case 5: // RB->R
00116$:
;boot_rom.c:84: B -= CYCLE_SPEED;
	ld	hl, #_B+0
	dec	(hl)
	ld	hl, #_B+0
	dec	(hl)
;boot_rom.c:85: if (B == 0)
	ld	a,(#_B + 0)
	or	a, a
	ret	NZ
;boot_rom.c:86: rgb_state = 0;
	ld	hl,#_rgb_state + 0
	ld	(hl), #0x00
;boot_rom.c:88: }
	ret
_cycle_colors_end::
_animation:
	.ascii "|/-"
	.db 0x5C
	.db 0x00
;boot_rom.c:91: void play_music() {
;	---------------------------------
; Function play_music
; ---------------------------------
_play_music_start::
_play_music:
;boot_rom.c:95: if(frames) {
	ld	a,(#_frames + 3)
	ld	hl,#_frames + 2
	or	a,(hl)
	ld	hl,#_frames + 1
	or	a,(hl)
	ld	hl,#_frames + 0
	or	a,(hl)
	jp	Z,00108$
;boot_rom.c:96: frames--;
	ld	hl,#_frames
	ld	a,(hl)
	add	a,#0xFF
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a,#0xFF
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a,#0xFF
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a,#0xFF
	ld	(hl),a
;boot_rom.c:99: p = ym_buffer[rsec] + rptr;
	ld	de,#_ym_buffer+0
	ld	a,(#_rsec + 0)
	add	a, a
	ld	h,a
	ld	l,#0x00
	add	hl,de
	ld	de,(_rptr)
	add	hl,de
	ex	de,hl
;boot_rom.c:102: level_a = p[8] & 0x0f;
	push	de
	pop	iy
	ld	a,8 (iy)
	and	a, #0x0F
	ld	(#_level_a + 0),a
;boot_rom.c:103: level_b = p[9] & 0x0f;
	push	de
	pop	iy
	ld	a,9 (iy)
	and	a, #0x0F
	ld	(#_level_b + 0),a
;boot_rom.c:104: level_c = p[10] & 0x0f;
	push	de
	pop	iy
	ld	a,10 (iy)
	and	a, #0x0F
	ld	(#_level_c + 0),a
;boot_rom.c:107: PsgAddrPort = 0; PsgDataPort = *p++;
	ld	a,#0x00
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:108: PsgAddrPort = 1; PsgDataPort = *p++;
	ld	a,#0x01
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:109: PsgAddrPort = 2; PsgDataPort = *p++;
	ld	a,#0x02
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:110: PsgAddrPort = 3; PsgDataPort = *p++;
	ld	a,#0x03
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:111: PsgAddrPort = 4; PsgDataPort = *p++;
	ld	a,#0x04
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:112: PsgAddrPort = 5; PsgDataPort = *p++;
	ld	a,#0x05
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:113: PsgAddrPort = 6; PsgDataPort = *p++;
	ld	a,#0x06
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:114: PsgAddrPort = 7; PsgDataPort = *p++;
	ld	a,#0x07
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:115: PsgAddrPort = 8; PsgDataPort = *p++;
	ld	a,#0x08
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:116: PsgAddrPort = 9; PsgDataPort = *p++;
	ld	a,#0x09
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:117: PsgAddrPort = 10; PsgDataPort = *p++;
	ld	a,#0x0A
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:118: PsgAddrPort = 11; PsgDataPort = *p++;
	ld	a,#0x0B
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:119: PsgAddrPort = 12; PsgDataPort = *p++;
	ld	a,#0x0C
	out	(_PsgAddrPort),a
	ld	a,(de)
	out	(_PsgDataPort),a
	inc	de
;boot_rom.c:120: PsgAddrPort = 13;
	ld	a,#0x0D
	out	(_PsgAddrPort),a
;boot_rom.c:121: if(*p != 255) PsgDataPort = *p++;
	ld	a,(de)
	ld	h,a
	inc	a
	jr	Z,00102$
	ld	a,h
	out	(_PsgDataPort),a
00102$:
;boot_rom.c:123: rptr += 16;
	ld	hl,#_rptr
	ld	a,(hl)
	add	a, #0x10
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a, #0x00
	ld	(hl),a
;boot_rom.c:126: if(rptr == 512) {
	ld	a,(#_rptr + 0)
	or	a, a
	ret	NZ
	ld	a,(#_rptr + 1)
	sub	a, #0x02
	ret	NZ
;boot_rom.c:127: rsec++;
	ld	hl, #_rsec+0
	inc	(hl)
;boot_rom.c:128: rptr=0;
	ld	hl,#_rptr + 0
	ld	(hl), #0x00
	ld	hl,#_rptr + 1
	ld	(hl), #0x00
;boot_rom.c:130: if(rsec == BUFFERS)
	ld	a,(#_rsec + 0)
	sub	a, #0x08
	ret	NZ
;boot_rom.c:131: rsec = 0;
	ld	hl,#_rsec + 0
	ld	(hl), #0x00
	ret
00108$:
;boot_rom.c:135: level_a = 0;
	ld	hl,#_level_a + 0
	ld	(hl), #0x00
;boot_rom.c:136: level_b = 0;
	ld	hl,#_level_b + 0
	ld	(hl), #0x00
;boot_rom.c:137: level_c = 0;
	ld	hl,#_level_c + 0
	ld	(hl), #0x00
;boot_rom.c:138: PsgAddrPort = 8;  PsgDataPort = 0;
	ld	a,#0x08
	out	(_PsgAddrPort),a
	ld	a,#0x00
	out	(_PsgDataPort),a
;boot_rom.c:139: PsgAddrPort = 9;  PsgDataPort = 0;
	ld	a,#0x09
	out	(_PsgAddrPort),a
	ld	a,#0x00
	out	(_PsgDataPort),a
;boot_rom.c:140: PsgAddrPort = 10; PsgDataPort = 0;
	ld	a,#0x0A
	out	(_PsgAddrPort),a
	ld	a,#0x00
	out	(_PsgDataPort),a
	ret
_play_music_end::
;boot_rom.c:145: void move_sprite() {
;	---------------------------------
; Function move_sprite
; ---------------------------------
_move_sprite_start::
_move_sprite:
;boot_rom.c:147: *(unsigned char*)0x3efe = curve[curve_index];
	ld	de,#_curve+0
	ld	hl,(_curve_index)
	add	hl,de
	ld	a,(hl)
	ld	(#0x3EFE),a
;boot_rom.c:148: *(unsigned char*)0x3eff = curve[curve_index + 1];
	ld	hl,(_curve_index)
	inc	hl
	add	hl,de
	ld	a,(hl)
	ld	(#0x3EFF),a
;boot_rom.c:150: curve_index += 2;
	ld	hl,#_curve_index
	ld	a,(hl)
	add	a, #0x02
	ld	(hl),a
	inc	hl
	ld	a,(hl)
	adc	a, #0x00
	ld	(hl),a
;boot_rom.c:151: if (curve_index == curve_length)
	ld	a,(#_curve_index + 0)
	ld	iy,#_curve_length
	sub	a, 0 (iy)
	ret	NZ
	ld	a,(#_curve_index + 1)
	ld	iy,#_curve_length
	sub	a, 1 (iy)
	ret	NZ
;boot_rom.c:152: curve_index = 0;
	ld	hl,#_curve_index + 0
	ld	(hl), #0x00
	ld	hl,#_curve_index + 1
	ld	(hl), #0x00
	ret
_move_sprite_end::
;boot_rom.c:157: void vbl(void) __interrupt (0x30) {
;	---------------------------------
; Function vbl
; ---------------------------------
_vbl_start::
_vbl:
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;boot_rom.c:159: cycle_colors();
	call	_cycle_colors
;boot_rom.c:160: move_sprite();
	call	_move_sprite
;boot_rom.c:165: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
_vbl_end::
;boot_rom.c:169: void clock50KHz(void) __interrupt (0x20) {
;	---------------------------------
; Function clock50KHz
; ---------------------------------
_clock50KHz_start::
_clock50KHz:
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;boot_rom.c:171: play_music();
	call	_play_music
;boot_rom.c:176: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
_clock50KHz_end::
;boot_rom.c:182: void putchar(char c) {
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar_start::
_putchar:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-11
	add	hl,sp
	ld	sp,hl
;boot_rom.c:184: unsigned char *dptr = (unsigned char*)(160*(8*cur_y) + 8*cur_x);
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
	add	hl, hl
	ex	de,hl
	ld	iy,#_cur_x
	ld	l,0 (iy)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl,de
	ld	-6 (ix),l
	ld	-5 (ix),h
;boot_rom.c:187: if(c < 32) {
	ld	a,4 (ix)
	xor	a, #0x80
	sub	a, #0xA0
	jr	NC,00108$
;boot_rom.c:188: if(c == '\r') 
	ld	a,4 (ix)
	sub	a, #0x0D
	jr	NZ,00102$
;boot_rom.c:189: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
00102$:
;boot_rom.c:191: if(c == '\n') {
	ld	a,4 (ix)
	sub	a, #0x0A
	jp	NZ,00122$
;boot_rom.c:192: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;boot_rom.c:193: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;boot_rom.c:195: if(cur_y >= 12)
	ld	a,(#_cur_y + 0)
	sub	a, #0x0C
	jp	C,00122$
;boot_rom.c:196: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
;boot_rom.c:198: return;
	jp	00122$
00108$:
;boot_rom.c:201: if(c < 0) return;
	bit	7, 4 (ix)
	jp	NZ,00122$
;boot_rom.c:203: p = font+8*(unsigned char)(c-32);
	ld	a,4 (ix)
	add	a,#0xE0
	ld	l,a
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de,#_font
	add	hl,de
	ld	-8 (ix),l
	ld	-7 (ix),h
;boot_rom.c:204: for(i=0;i<8;i++) {
	ld	-9 (ix),#0x00
00120$:
;boot_rom.c:205: unsigned char l = *p++;
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	ld	-11 (ix),a
	inc	-8 (ix)
	jr	NZ,00180$
	inc	-7 (ix)
00180$:
;boot_rom.c:206: for(j=0;j<8;j++) {
	ld	-10 (ix),#0x08
	ld	a,-6 (ix)
	ld	-4 (ix),a
	ld	a,-5 (ix)
	ld	-3 (ix),a
00119$:
;boot_rom.c:207: *dptr++ = (l & 0x80) ? FG_COLOR:BG_COLOR;
	ld	a,-4 (ix)
	ld	-2 (ix),a
	ld	a,-3 (ix)
	ld	-1 (ix),a
	inc	-4 (ix)
	jr	NZ,00181$
	inc	-3 (ix)
00181$:
	bit	7, -11 (ix)
	jr	Z,00124$
	ld	a,#0xFF
	jr	00125$
00124$:
	ld	a,#0x73
00125$:
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
;boot_rom.c:208: l <<= 1;
	sla	-11 (ix)
	dec	-10 (ix)
;boot_rom.c:206: for(j=0;j<8;j++) {
	ld	a,-10 (ix)
	or	a, a
	jr	NZ,00119$
;boot_rom.c:210: dptr += (160-8);
	ld	a,-4 (ix)
	add	a, #0x98
	ld	-6 (ix),a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	-5 (ix),a
;boot_rom.c:204: for(i=0;i<8;i++) {
	inc	-9 (ix)
	ld	a,-9 (ix)
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00120$
;boot_rom.c:213: cur_x++;
	ld	hl, #_cur_x+0
	inc	(hl)
;boot_rom.c:214: if(cur_x >= 20) {
	ld	a,(#_cur_x + 0)
	sub	a, #0x14
	jr	C,00122$
;boot_rom.c:215: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;boot_rom.c:216: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;boot_rom.c:218: if(cur_y >= 12)
	ld	a,(#_cur_y + 0)
	sub	a, #0x0C
	jr	C,00122$
;boot_rom.c:219: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
00122$:
	ld	sp, ix
	pop	ix
	ret
_putchar_end::
;boot_rom.c:223: void cls(void) {
;	---------------------------------
; Function cls
; ---------------------------------
_cls_start::
_cls:
;boot_rom.c:227: for(i=0;i<100;i++) {
	ld	hl,#0x0000
	ld	d,#0x00
00102$:
;boot_rom.c:228: memset(p, BG_COLOR, 160);
	ld	e,l
	ld	b,h
	push	hl
	ld	l, e
	ld	h, b
	ld	b, #0xA0
00115$:
	ld	(hl), #0x73
	inc	hl
	djnz	00115$
	pop	hl
;boot_rom.c:229: p+=160;
	ld	bc,#0x00A0
	add	hl,bc
;boot_rom.c:227: for(i=0;i<100;i++) {
	inc	d
	ld	a,d
	sub	a, #0x64
	jr	C,00102$
;boot_rom.c:231: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;boot_rom.c:232: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
	ret
_cls_end::
;boot_rom.c:239: void put_pixel(unsigned char x, unsigned char y, unsigned char color) {
;	---------------------------------
; Function put_pixel
; ---------------------------------
_put_pixel_start::
_put_pixel:
	push	ix
	ld	ix,#0
	add	ix,sp
;boot_rom.c:240: *((unsigned char*)(160*y+x)) = color;
	ld	c,5 (ix)
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
	add	hl, hl
	ld	e,4 (ix)
	ld	d,#0x00
	add	hl,de
	ld	a,6 (ix)
	ld	(hl),a
	pop	ix
	ret
_put_pixel_end::
;boot_rom.c:243: void die (FRESULT rc) {
;	---------------------------------
; Function die
; ---------------------------------
_die_start::
_die:
	push	ix
	ld	ix,#0
	add	ix,sp
;boot_rom.c:244: printf("Fail rc=%u", rc);
	ld	e,4 (ix)
	ld	d,#0x00
	ld	hl,#___str_1
	push	de
	push	hl
	call	_printf
	pop	af
	pop	af
00103$:
	jr	00103$
	pop	ix
	ret
_die_end::
___str_1:
	.ascii "Fail rc=%u"
	.db 0x00
;boot_rom.c:249: void draw_line(unsigned char x, unsigned char y, 
;	---------------------------------
; Function draw_line
; ---------------------------------
_draw_line_start::
_draw_line:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-11
	add	hl,sp
	ld	sp,hl
;boot_rom.c:253: char dx1 = (x<x2)?1:-1;
	ld	a,4 (ix)
	sub	a, 6 (ix)
	jr	NC,00112$
	ld	c,#0x01
	jr	00113$
00112$:
	ld	c,#0xFF
00113$:
;boot_rom.c:254: char dy1 = (y<y2)?1:-1;
	ld	a,5 (ix)
	sub	a, 7 (ix)
	jr	NC,00114$
	ld	a,#0x01
	jr	00115$
00114$:
	ld	a,#0xFF
00115$:
	ld	-11 (ix),a
;boot_rom.c:257: longest = abs(x2 - x);
	ld	h,6 (ix)
	ld	l,#0x00
	ld	d,4 (ix)
	ld	e,#0x00
	ld	a,h
	sub	a, d
	ld	b,a
	ld	a,l
	sbc	a, e
	ld	d,a
	push	bc
	push	de
	ld	e,b
	push	de
	call	_abs
	pop	af
	pop	de
	pop	bc
	ld	e,l
;boot_rom.c:258: shortest = abs(y2 - y);
	ld	a,7 (ix)
	ld	-6 (ix),a
	ld	-5 (ix),#0x00
	ld	l,5 (ix)
	ld	h,#0x00
	ld	a,-6 (ix)
	sub	a, l
	ld	l,a
	ld	a,-5 (ix)
	sbc	a, h
	ld	h,a
	push	hl
	push	bc
	push	de
	push	hl
	call	_abs
	pop	af
	ld	-5 (ix),h
	ld	-6 (ix),l
	pop	de
	pop	bc
	pop	hl
	ld	a,-6 (ix)
	ld	-7 (ix),a
;boot_rom.c:259: if(longest<shortest) {
	ld	a,e
	sub	a, -7 (ix)
	jr	NC,00102$
;boot_rom.c:260: longest = abs(y2 - y);
	push	bc
	push	de
	push	hl
	call	_abs
	pop	af
	pop	de
	pop	bc
	ld	e,l
;boot_rom.c:261: shortest = abs(x2 - x);
	push	bc
	push	de
	ld	e,b
	push	de
	call	_abs
	pop	af
	pop	de
	pop	bc
	ld	-7 (ix),l
;boot_rom.c:262: dx2 = 0;            
	ld	-9 (ix),#0x00
;boot_rom.c:263: dy2 = dy1;
	ld	a,-11 (ix)
	ld	-10 (ix),a
	jr	00103$
00102$:
;boot_rom.c:265: dx2 = dx1;
	ld	-9 (ix),c
;boot_rom.c:266: dy2 = 0;
	ld	-10 (ix),#0x00
00103$:
;boot_rom.c:269: numerator = longest/2;
	ld	a,e
	srl	a
	ld	-6 (ix),a
;boot_rom.c:270: for(i=0;i<=longest;i++) {
	ld	-8 (ix),#0x00
00108$:
;boot_rom.c:271: put_pixel(x,y,color) ;
	push	bc
	push	de
	ld	h,8 (ix)
	ld	l,5 (ix)
	push	hl
	ld	a,4 (ix)
	push	af
	inc	sp
	call	_put_pixel
	pop	af
	inc	sp
	pop	de
	pop	bc
;boot_rom.c:272: if(numerator >= longest-shortest) {
	ld	l,e
	ld	h,#0x00
	ld	d,-7 (ix)
	ld	b,#0x00
	ld	a,l
	sub	a, d
	ld	-2 (ix),a
	ld	a,h
	sbc	a, b
	ld	-1 (ix),a
	ld	h,-6 (ix)
	ld	d,#0x00
;boot_rom.c:273: numerator += shortest ;
	ld	a,-6 (ix)
	add	a, -7 (ix)
	ld	l,a
;boot_rom.c:275: x += dx1;
	ld	a,4 (ix)
	ld	-3 (ix),a
;boot_rom.c:276: y += dy1;
	ld	a,5 (ix)
	ld	-4 (ix),a
;boot_rom.c:272: if(numerator >= longest-shortest) {
	ld	a,h
	sub	a, -2 (ix)
	ld	a,d
	sbc	a, -1 (ix)
	jp	PO, 00137$
	xor	a, #0x80
00137$:
	jp	M,00105$
;boot_rom.c:273: numerator += shortest ;
;boot_rom.c:274: numerator -= longest ;
	ld	a,l
	sub	a, e
	ld	-6 (ix),a
;boot_rom.c:275: x += dx1;
	ld	a,-3 (ix)
	add	a, c
	ld	4 (ix),a
;boot_rom.c:276: y += dy1;
	ld	a,-4 (ix)
	add	a, -11 (ix)
	ld	5 (ix),a
	jr	00109$
00105$:
;boot_rom.c:278: numerator += shortest ;
	ld	-6 (ix),l
;boot_rom.c:279: x += dx2;
	ld	a,-3 (ix)
	add	a, -9 (ix)
	ld	4 (ix),a
;boot_rom.c:280: y += dy2;
	ld	a,-4 (ix)
	add	a, -10 (ix)
	ld	5 (ix),a
00109$:
;boot_rom.c:270: for(i=0;i<=longest;i++) {
	inc	-8 (ix)
	ld	a,e
	sub	a, -8 (ix)
	jp	NC,00108$
	ld	sp, ix
	pop	ix
	ret
_draw_line_end::
;boot_rom.c:290: void splash() {
;	---------------------------------
; Function splash
; ---------------------------------
_splash_start::
_splash:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;boot_rom.c:291: unsigned char *pimg = image;
	ld	hl,#_image
;boot_rom.c:300: for (i = 0; i < 3; i++) {
	ld	iy,#0x1110
	ld	bc,#0x0000
00104$:
;boot_rom.c:301: memcpy (pscreen, pimg, SPLASH_W);
	push	iy
	pop	de
	inc	sp
	inc	sp
	push	hl
	push	hl
	push	bc
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	bc,#0x0040
	ldir
	pop	bc
	pop	hl
;boot_rom.c:302: pscreen += 160;
	ld	de,#0x00A0
	add	iy, de
;boot_rom.c:303: pimg += SPLASH_W;
	ld	de,#0x0040
	add	hl,de
;boot_rom.c:300: for (i = 0; i < 3; i++) {
	inc	bc
	ld	a,c
	sub	a, #0x03
	ld	a,b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00104$
	push	iy
	pop	de
	push	hl
	pop	iy
00107$:
;boot_rom.c:306: for (; i < SPLASH_H; i++) {
	ld	a,c
	sub	a, #0x2D
	ld	a,b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00102$
;boot_rom.c:307: memcpy (pscreen, pimg, SPLASH_W);
	inc	sp
	inc	sp
	push	de
	push	iy
	pop	hl
	push	de
	push	bc
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	ld	bc,#0x0040
	ldir
	pop	bc
	pop	de
;boot_rom.c:308: memset (pscreen + SPLASH_W, BG_SHADOW, 3);
	ld	hl,#0x0040
	add	hl,de
	ld	(hl), #0x2A
	inc	hl
	ld	(hl), #0x2A
	inc	hl
	ld	(hl), #0x2A
;boot_rom.c:309: pscreen += 160;
	ld	hl,#0x00A0
	add	hl,de
	ex	de,hl
;boot_rom.c:310: pimg += SPLASH_W;
	push	bc
	ld	bc,#0x0040
	add	iy, bc
	pop	bc
;boot_rom.c:306: for (; i < SPLASH_H; i++) {
	inc	bc
	jr	00107$
00102$:
;boot_rom.c:313: pscreen += 3;
	inc	de
	inc	de
	inc	de
00110$:
;boot_rom.c:314: for (; i < SPLASH_H + 3; i++) {
	ld	a,c
	sub	a, #0x30
	ld	a,b
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	NC,00112$
;boot_rom.c:315: memset (pscreen, BG_SHADOW, SPLASH_W);
	ld	l, e
	ld	h, d
	push	bc
	ld	b, #0x40
00140$:
	ld	(hl), #0x2A
	inc	hl
	djnz	00140$
	pop	bc
;boot_rom.c:316: pscreen += 160;
	ld	hl,#0x00A0
	add	hl,de
	ex	de,hl
;boot_rom.c:314: for (; i < SPLASH_H + 3; i++) {
	inc	bc
	jr	00110$
00112$:
	ld	sp, ix
	pop	ix
	ret
_splash_end::
;boot_rom.c:324: void display_level (char level, char line) {
;	---------------------------------
; Function display_level
; ---------------------------------
_display_level_start::
_display_level:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;boot_rom.c:326: unsigned char *ptr = 0 + line * 160;
	ld	c,5 (ix)
	ld	a, c
	rlc	a
	sbc	a, a
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
;boot_rom.c:327: for (i = 0; i < 16; i++) {
	ld	hl,#0x0000
	ex	(sp), hl
00105$:
;boot_rom.c:328: if (i < level) {
	ld	h,4 (ix)
	ld	a,4 (ix)
	rla
	sbc	a, a
	ld	l,a
;boot_rom.c:329: *ptr++ = vu_meter[i];
	ld	e, c
	ld	d, b
	inc	de
;boot_rom.c:328: if (i < level) {
	ld	a,-4 (ix)
	sub	a, h
	ld	a,-3 (ix)
	sbc	a, l
	jp	PO, 00118$
	xor	a, #0x80
00118$:
	jp	P,00102$
;boot_rom.c:329: *ptr++ = vu_meter[i];
	ld	iy,#_vu_meter
	push	bc
	ld	c,-4 (ix)
	ld	b,-3 (ix)
	add	iy, bc
	pop	bc
	ld	a, 0 (iy)
	ld	(bc),a
	ld	-2 (ix),e
	ld	-1 (ix),d
;boot_rom.c:330: *ptr++ = vu_meter[i];            
	ld	a, 0 (iy)
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
	ld	c,-2 (ix)
	ld	b,-1 (ix)
	inc	bc
	jr	00103$
00102$:
;boot_rom.c:332: *ptr++ = BG_COLOR;
	ld	a,#0x73
	ld	(bc),a
	ld	-2 (ix),e
	ld	-1 (ix),d
;boot_rom.c:333: *ptr++ = BG_COLOR;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x73
	ld	c,-2 (ix)
	ld	b,-1 (ix)
	inc	bc
00103$:
;boot_rom.c:335: *ptr++;
	inc	bc
;boot_rom.c:327: for (i = 0; i < 16; i++) {
	inc	-4 (ix)
	jr	NZ,00119$
	inc	-3 (ix)
00119$:
	ld	a,-4 (ix)
	sub	a, #0x10
	ld	a,-3 (ix)
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00105$
	ld	sp, ix
	pop	ix
	ret
_display_level_end::
;boot_rom.c:345: void init_interrupt_table() {
;	---------------------------------
; Function init_interrupt_table
; ---------------------------------
_init_interrupt_table_start::
_init_interrupt_table:
;boot_rom.c:358: __endasm;
	ld hl,#0x8000
	ld a,h
	ld i,a
	ld iy,#_clock50KHz
	ld (#0x8020),iy
	ld iy,#_vbl
	ld (#0x8030),iy
	ret
_init_interrupt_table_end::
;boot_rom.c:361: void ei() {
;	---------------------------------
; Function ei
; ---------------------------------
_ei_start::
_ei:
;boot_rom.c:366: __endasm;
	im 2
	ei
	ret
_ei_end::
;boot_rom.c:369: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main_start::
_main:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-63
	add	hl,sp
	ld	sp,hl
;boot_rom.c:373: BYTE wsec = 0;
	ld	-63 (ix),#0x00
;boot_rom.c:381: init_interrupt_table();
	call	_init_interrupt_table
;boot_rom.c:384: *(unsigned char*)0x3f10 = KEY_COLOR;
	ld	hl,#0x3F10
	ld	(hl),#0x18
;boot_rom.c:385: *(unsigned char*)0x3f11 = 0x00;
	ld	l, #0x11
	ld	(hl),#0x00
;boot_rom.c:386: *(unsigned char*)0x3f12 = 0x00;
	ld	l, #0x12
	ld	(hl),#0x00
;boot_rom.c:387: *(unsigned char*)0x3f13 = 0x00;
	ld	l, #0x13
	ld	(hl),#0x00
;boot_rom.c:389: cls();
	call	_cls
;boot_rom.c:390: splash();
	call	_splash
;boot_rom.c:393: while(!(keys & 1));
00101$:
	in	a,(_keys)
	rrca
	jr	NC,00101$
;boot_rom.c:395: level_a = prev_level_a = 0;
	ld	hl,#_level_a + 0
	ld	(hl), #0x00
;boot_rom.c:396: level_b = prev_level_a = 0;
	ld	hl,#_level_b + 0
	ld	(hl), #0x00
;boot_rom.c:397: level_c = prev_level_a = 0;
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
	ld	hl,#_level_c + 0
	ld	(hl), #0x00
;boot_rom.c:402: for(i=0;i<8;i++) {
	ld	e,#0x00
00156$:
;boot_rom.c:403: *(char*)(0x3f00+i) = cursor_data[i];
	ld	a,e
	ld	c,a
	rla
	sbc	a, a
	ld	b,a
	ld	iy,#0x3F00
	add	iy,bc
	ld	hl,#_cursor_data
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	0 (iy), a
;boot_rom.c:404: *(char*)(0x3f08+i) = cursor_mask[i];
	ld	hl,#0x3F08
	add	hl,bc
	ld	c, l
	ld	b, h
	ld	hl,#_cursor_mask
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	(bc),a
;boot_rom.c:402: for(i=0;i<8;i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00156$
;boot_rom.c:408: *(unsigned char*)0x3efd = 0x10;
	ld	hl,#0x3EFD
	ld	(hl),#0x10
;boot_rom.c:411: *(unsigned char*)0x3efb = CURSOR_COLOR1;
	ld	l, #0xFB
	ld	(hl),#0xFF
;boot_rom.c:412: *(unsigned char*)0x3efc = CURSOR_COLOR2;
	ld	l, #0xFC
	ld	(hl),#0xE0
;boot_rom.c:414: curve_index = 0;
	ld	hl,#_curve_index + 0
	ld	(hl), #0x00
	ld	hl,#_curve_index + 1
	ld	(hl), #0x00
;boot_rom.c:416: rc = pf_mount(&fatfs);
	ld	hl,#0x0007
	add	hl,sp
	push	hl
	call	_pf_mount
	pop	af
	ld	a,l
;boot_rom.c:417: if (rc) die(rc);
	or	a, a
	jr	Z,00106$
	push	af
	inc	sp
	call	_die
	inc	sp
00106$:
;boot_rom.c:419: ei();
	call	_ei
;boot_rom.c:423: rc = pf_open("SONG.YM");
	ld	hl,#___str_2
	push	hl
	call	_pf_open
	pop	af
	ld	h,l
;boot_rom.c:424: if(rc == FR_NO_FILE) {
	ld	a,h
	sub	a, #0x03
	jr	NZ,00109$
;boot_rom.c:425: printf("File not found");
	ld	hl,#___str_3
	push	hl
	call	_printf
	pop	af
00159$:
	jr	00159$
00109$:
;boot_rom.c:428: if (rc) die(rc);
	ld	a,h
	or	a, a
	jr	Z,00180$
	push	hl
	inc	sp
	call	_die
	inc	sp
;boot_rom.c:442: while((wsec == rsec) && frames) {
00180$:
00120$:
	ld	a,-63 (ix)
	ld	iy,#_rsec
	sub	a, 0 (iy)
	jp	NZ,00122$
	ld	a,(#_frames + 3)
	ld	hl,#_frames + 2
	or	a,(hl)
	ld	hl,#_frames + 1
	or	a,(hl)
	ld	hl,#_frames + 0
	or	a,(hl)
	jr	Z,00122$
;boot_rom.c:444: if (level_a != prev_level_a) {
	ld	hl,#_level_a + 0
	ld	d, (hl)
	ld	e,#0x00
	ld	a,-2 (ix)
	sub	a, d
	jr	NZ,00290$
	ld	a,-1 (ix)
	sub	a, e
	jr	Z,00114$
00290$:
;boot_rom.c:445: prev_level_a = level_a;
	ld	-2 (ix),d
	ld	-1 (ix),e
;boot_rom.c:446: display_level (level_a, 95);
	ld	a,#0x5F
	push	af
	inc	sp
	ld	a,(_level_a)
	push	af
	inc	sp
	call	_display_level
	pop	af
00114$:
;boot_rom.c:448: if (level_b != prev_level_b) {
	ld	hl,#_level_b + 0
	ld	e, (hl)
	ld	d,#0x00
	ld	a,-9 (ix)
	sub	a, e
	jr	NZ,00291$
	ld	a,-8 (ix)
	sub	a, d
	jr	Z,00116$
00291$:
;boot_rom.c:449: prev_level_b = level_b;
	ld	-9 (ix),e
	ld	-8 (ix),d
;boot_rom.c:450: display_level (level_b, 97);
	ld	a,#0x61
	push	af
	inc	sp
	ld	a,(_level_b)
	push	af
	inc	sp
	call	_display_level
	pop	af
00116$:
;boot_rom.c:452: if (level_c != prev_level_c) {
	ld	hl,#_level_c + 0
	ld	d, (hl)
	ld	b,#0x00
	ld	a,-4 (ix)
	sub	a, d
	jr	NZ,00292$
	ld	a,-3 (ix)
	sub	a, b
	jr	Z,00120$
00292$:
;boot_rom.c:453: prev_level_c = level_c;
	ld	-4 (ix),d
	ld	-3 (ix),b
;boot_rom.c:454: display_level (level_c, 99);
	ld	a,#0x63
	push	af
	inc	sp
	ld	a,(_level_c)
	push	af
	inc	sp
	call	_display_level
	pop	af
	jp	00120$
00122$:
;boot_rom.c:473: rc = pf_read(ym_buffer[wsec], 512, &bytes_read);
	ld	hl,#0x0001
	add	hl,sp
	ex	de,hl
	ld	a, -63 (ix)
	add	a, a
	ld	h,a
	ld	l,#0x00
	ld	bc,#_ym_buffer
	add	hl,bc
	push	de
	ld	bc,#0x0200
	push	bc
	push	hl
	call	_pf_read
	pop	af
	pop	af
	pop	af
	ld	-5 (ix),l
;boot_rom.c:476: if(!frames) {
	ld	a,(#_frames + 3)
	ld	hl,#_frames + 2
	or	a,(hl)
	ld	hl,#_frames + 1
	or	a,(hl)
	ld	hl,#_frames + 0
	or	a,(hl)
	jp	NZ,00144$
;boot_rom.c:478: if((ym_buffer[0][0] != 'Y')||(ym_buffer[0][1] != 'M')) {
	ld	a, (#_ym_buffer + 0)
	sub	a, #0x59
	jr	NZ,00124$
	ld	a, (#_ym_buffer + 1)
	sub	a, #0x4D
	jr	Z,00125$
00124$:
;boot_rom.c:479: printf("No YM file!\n");
	ld	hl,#___str_4
	push	hl
	call	_printf
	pop	af
00161$:
	jr	00161$
00125$:
;boot_rom.c:486: if(ym_buffer[0][19] & 1) {
	ld	a, (#_ym_buffer + 19)
	rrca
	jr	NC,00129$
;boot_rom.c:487: printf("No Interleave!\n");
	ld	hl,#___str_5
	push	hl
	call	_printf
	pop	af
00163$:
	jr	00163$
00129$:
;boot_rom.c:492: if(ym_buffer[0][20] || ym_buffer[0][21]) {
	ld	a,(#_ym_buffer + 20)
	ld	-14 (ix), a
	or	a, a
	jr	NZ,00131$
	ld	a, (#_ym_buffer + 21)
	or	a, a
	jr	Z,00132$
00131$:
;boot_rom.c:493: printf("No Digidrums!\n");
	ld	hl,#___str_6
	push	hl
	call	_printf
	pop	af
00165$:
	jr	00165$
00132$:
;boot_rom.c:498: rptr = 34;
	ld	hl,#_rptr + 0
	ld	(hl), #0x22
	ld	hl,#_rptr + 1
	ld	(hl), #0x00
;boot_rom.c:500: while(ym_buffer[0][rptr]) rptr++;  // song name
00134$:
	ld	hl,(_rptr)
	ld	-7 (ix),l
	ld	-6 (ix),h
	ld	a,#<(_ym_buffer)
	add	a, -7 (ix)
	ld	-7 (ix),a
	ld	a,#>(_ym_buffer)
	adc	a, -6 (ix)
	ld	-6 (ix),a
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	b,(hl)
	ld	hl,(_rptr)
	inc	hl
	ld	a,b
	or	a, a
	jr	Z,00136$
	ld	(_rptr),hl
	jr	00134$
00136$:
;boot_rom.c:501: rptr++;
	ld	(_rptr),hl
;boot_rom.c:503: while(ym_buffer[0][rptr]) rptr++;  // author name
00137$:
	ld	hl,(_rptr)
	ld	-7 (ix),l
	ld	-6 (ix),h
	ld	a,#<(_ym_buffer)
	add	a, -7 (ix)
	ld	-7 (ix),a
	ld	a,#>(_ym_buffer)
	adc	a, -6 (ix)
	ld	-6 (ix),a
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	b,(hl)
;boot_rom.c:500: while(ym_buffer[0][rptr]) rptr++;  // song name
	ld	a,(#_rptr + 0)
	add	a, #0x01
	ld	-7 (ix),a
	ld	a,(#_rptr + 1)
	adc	a, #0x00
	ld	-6 (ix),a
;boot_rom.c:503: while(ym_buffer[0][rptr]) rptr++;  // author name
	ld	a,b
	or	a, a
	jr	Z,00139$
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	(_rptr),hl
	jr	00137$
00139$:
;boot_rom.c:504: rptr++;
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	(_rptr),hl
;boot_rom.c:505: while(ym_buffer[0][rptr]) rptr++;  // song comment
00140$:
	ld	hl,(_rptr)
	ld	de,#_ym_buffer
	add	hl,de
	ld	d,(hl)
;boot_rom.c:500: while(ym_buffer[0][rptr]) rptr++;  // song name
	ld	a,(#_rptr + 0)
	add	a, #0x01
	ld	-7 (ix),a
	ld	a,(#_rptr + 1)
	adc	a, #0x00
	ld	-6 (ix),a
;boot_rom.c:505: while(ym_buffer[0][rptr]) rptr++;  // song comment
	ld	a,d
	or	a, a
	jr	Z,00142$
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	(_rptr),hl
	jr	00140$
00142$:
;boot_rom.c:506: rptr++;
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	(_rptr),hl
;boot_rom.c:509: frames = 256l*256l*256l*ym_buffer[0][12] + 256l*256l*ym_buffer[0][13] + 
	ld	a, (#_ym_buffer + 12)
	ld	l,a
	ld	h,#0x00
	ld	de,#0x0000
	push	af
	ld	-13 (ix),l
	ld	-12 (ix),h
	ld	-11 (ix),e
	ld	-10 (ix),d
	pop	af
	ld	a,#0x18
00297$:
	sla	-13 (ix)
	rl	-12 (ix)
	rl	-11 (ix)
	rl	-10 (ix)
	dec	a
	jr	NZ,00297$
	ld	a, (#_ym_buffer + 13)
	ld	l,a
	ld	h,#0x00
	ld	de,#0x0000
	ld	b,#0x10
00299$:
	add	hl, hl
	rl	e
	rl	d
	djnz	00299$
	ld	a,-13 (ix)
	add	a, l
	ld	-13 (ix),a
	ld	a,-12 (ix)
	adc	a, h
	ld	-12 (ix),a
	ld	a,-11 (ix)
	adc	a, e
	ld	-11 (ix),a
	ld	a,-10 (ix)
	adc	a, d
	ld	-10 (ix),a
;boot_rom.c:510: 256l*ym_buffer[0][14] + ym_buffer[0][15];
	ld	a, (#_ym_buffer + 14)
	ld	l,a
	ld	h,#0x00
	ld	de,#0x0000
	ld	b,#0x08
00301$:
	add	hl, hl
	rl	e
	rl	d
	djnz	00301$
	ld	a,-13 (ix)
	add	a, l
	ld	-13 (ix),a
	ld	a,-12 (ix)
	adc	a, h
	ld	-12 (ix),a
	ld	a,-11 (ix)
	adc	a, e
	ld	-11 (ix),a
	ld	a,-10 (ix)
	adc	a, d
	ld	-10 (ix),a
	ld	a, (#_ym_buffer + 15)
	ld	e,a
	ld	d,#0x00
	ld	a,d
	rla
	sbc	a, a
	ld	b,a
	ld	c,a
	ld	a,-13 (ix)
	ld	hl,#_frames
	add	a, e
	ld	(hl),a
	ld	a,-12 (ix)
	adc	a, d
	inc	hl
	ld	(hl),a
	ld	a,-11 (ix)
	adc	a, b
	inc	hl
	ld	(hl),a
	ld	a,-10 (ix)
	adc	a, c
	inc	hl
	ld	(hl),a
00144$:
;boot_rom.c:515: wsec++;
	inc	-63 (ix)
;boot_rom.c:516: if(wsec == BUFFERS)
	ld	a,-63 (ix)
	sub	a, #0x08
	jr	NZ,00149$
;boot_rom.c:517: wsec = 0;
	ld	-63 (ix),#0x00
00149$:
;boot_rom.c:523: } while((!rc) && (bytes_read == 512));
	ld	a,-5 (ix)
	or	a, a
	jr	NZ,00150$
	ld	a,-62 (ix)
	or	a, a
	jr	NZ,00305$
	ld	a,-61 (ix)
	sub	a, #0x02
	jp	Z,00120$
00305$:
00150$:
;boot_rom.c:526: rc = pf_lseek ((DWORD)0);
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	call	_pf_lseek
	pop	af
	pop	af
;boot_rom.c:527: frames = 0;
	xor	a, a
	ld	(#_frames + 0),a
	ld	(#_frames + 1),a
	ld	(#_frames + 2),a
	ld	(#_frames + 3),a
;boot_rom.c:528: rptr = 0xffff;
	ld	hl,#_rptr + 0
	ld	(hl), #0xFF
	ld	hl,#_rptr + 1
	ld	(hl), #0xFF
;boot_rom.c:529: rsec = 0;
	ld	hl,#_rsec + 0
	ld	(hl), #0x00
;boot_rom.c:531: goto restart;
;boot_rom.c:537: while(1);
	jp	00120$
_main_end::
___str_2:
	.ascii "SONG.YM"
	.db 0x00
___str_3:
	.ascii "File not found"
	.db 0x00
___str_4:
	.ascii "No YM file!"
	.db 0x0A
	.db 0x00
___str_5:
	.ascii "No Interleave!"
	.db 0x0A
	.db 0x00
___str_6:
	.ascii "No Digidrums!"
	.db 0x0A
	.db 0x00
___str_7:
	.ascii "done."
	.db 0x0A
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__frames:
	.byte #0x00,#0x00,#0x00,#0x00	; 0
__xinit__rptr:
	.dw #0xFFFF
__xinit__rsec:
	.db #0x00	; 0
__xinit__R:
	.db #0xFE	; 254
__xinit__G:
	.db #0x00	; 0
__xinit__B:
	.db #0x00	; 0
__xinit__rgb_state:
	.db #0x00	; 0
__xinit__curve_index:
	.dw #0x0000
__xinit__cur_x:
	.db #0x00	; 0
__xinit__cur_y:
	.db #0x00	; 0
__xinit__vu_meter:
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0x1C	; 28
	.db #0xFC	; 252
	.db #0xFC	; 252
	.db #0xE0	; 224
	.db #0xE0	; 224
	.area _CABS (ABS)

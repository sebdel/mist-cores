;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Tue Nov  8 16:43:03 2016
;--------------------------------------------------------
	.module text
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _hex
	.globl _text_char
	.globl _text_hex
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_hex::
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
;text.c:10: void text_char(unsigned char *dst, unsigned char c) {
;	---------------------------------
; Function text_char
; ---------------------------------
_text_char::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
	dec	sp
;text.c:11: unsigned char *p = font + FONT_HEIGHT * (unsigned char)(c - 32);
	ld	a,6 (ix)
	add	a,#0xE0
	ld	c,a
	ld	b,#0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	de,#_font
	add	hl,de
	ld	c, l
	ld	b, h
;text.c:14: for(i = 0; i < FONT_HEIGHT; i ++) {
	ld	a,4 (ix)
	ld	-5 (ix),a
	ld	a,5 (ix)
	ld	-4 (ix),a
	ld	e,#0x00
00102$:
;text.c:15: unsigned char l = *p++;
	ld	a,(bc)
	ld	l,a
	inc	bc
;text.c:17: *dst = (((l & 0x80) ? 0x03:0x00) |
	ld	a,-5 (ix)
	ld	-2 (ix),a
	ld	a,-4 (ix)
	ld	-1 (ix),a
	bit	7, l
	jr	Z,00106$
	ld	-3 (ix),#0x03
	jr	00107$
00106$:
	ld	-3 (ix),#0x00
00107$:
;text.c:18: ((l & 0x40) ? 0x0C:0x00) |
	bit	6, l
	jr	Z,00108$
	ld	a,#0x0C
	jr	00109$
00108$:
	ld	a,#0x00
00109$:
	or	a, -3 (ix)
	ld	h,a
;text.c:19: ((l & 0x20) ? 0x30:0x00) |
	bit	5, l
	jr	Z,00110$
	ld	a,#0x30
	jr	00111$
00110$:
	ld	a,#0x00
00111$:
	or	a, h
	ld	h,a
;text.c:20: ((l & 0x10) ? 0xC0:0x00));
	bit	4, l
	jr	Z,00112$
	ld	a,#0xC0
	jr	00113$
00112$:
	ld	a,#0x00
00113$:
	or	a, h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
;text.c:21: dst += 80;
	ld	a,-5 (ix)
	add	a, #0x50
	ld	-5 (ix),a
	ld	a,-4 (ix)
	adc	a, #0x00
	ld	-4 (ix),a
;text.c:14: for(i = 0; i < FONT_HEIGHT; i ++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x86
	jr	C,00102$
	ld	sp, ix
	pop	ix
	ret
;text.c:25: void text_hex(unsigned char *dst, unsigned char value) {
;	---------------------------------
; Function text_hex
; ---------------------------------
_text_hex::
;text.c:27: text_char(dst, hex[(value >> 4) & 0x0F]);
	ld	de,#_hex+0
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a,#0x0F
	and	a, #0x0F
	ld	l, a
	ld	h,#0x00
	add	hl,de
	ld	h,(hl)
	push	de
	push	hl
	inc	sp
	ld	hl, #5
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	call	_text_char
	pop	af
	inc	sp
	pop	de
;text.c:28: text_char(dst+1, hex[value & 0xF]);
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	and	a, #0x0F
	ld	l, a
	ld	h,#0x00
	add	hl,de
	ld	b,(hl)
	ld	hl, #2
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	de
	push	bc
	inc	sp
	push	de
	call	_text_char
	pop	af
	inc	sp
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__hex:
	.db #0x30	; 48	'0'
	.db #0x31	; 49	'1'
	.db #0x32	; 50	'2'
	.db #0x33	; 51	'3'
	.db #0x34	; 52	'4'
	.db #0x35	; 53	'5'
	.db #0x36	; 54	'6'
	.db #0x37	; 55	'7'
	.db #0x38	; 56	'8'
	.db #0x39	; 57	'9'
	.db #0x41	; 65	'A'
	.db #0x42	; 66	'B'
	.db #0x43	; 67	'C'
	.db #0x44	; 68	'D'
	.db #0x45	; 69	'E'
	.db #0x46	; 70	'F'
	.area _CABS (ABS)

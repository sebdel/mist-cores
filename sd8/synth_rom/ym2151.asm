;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Tue Nov  8 14:11:26 2016
;--------------------------------------------------------
	.module ym2151
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _ym2151_setLFOAmplitude
	.globl __wait_busy
	.globl _ym2151_write
	.globl _ym2151_read
	.globl _ym2151_setCT1
	.globl _ym2151_setCT2
	.globl _ym2151_setLFOWaveform
	.globl _ym2151_setLFOFrequency
	.globl _ym2151_setLFOModulation
	.globl _ym2151_resetLFO
	.globl _ym2151_setNoiseEnable
	.globl _ym2151_setNoiseFrequency
	.globl _ym2151_setKeyState
	.globl _ym2151_setChannels
	.globl _ym2151_setConnections
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
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
;ym2151.c:5: void _wait_busy() {
;	---------------------------------
; Function _wait_busy
; ---------------------------------
__wait_busy::
;ym2151.c:9: for (i = 0; (FmgAddrPort & 0x80) && (i < 100); i++);
	ld	de,#0x0000
00104$:
	in	a,(_FmgAddrPort)
	rlca
	ret	NC
	ld	a,e
	sub	a, #0x64
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	ret	NC
	inc	de
	jr	00104$
;ym2151.c:12: void ym2151_write(unsigned char reg, unsigned char value) {
;	---------------------------------
; Function ym2151_write
; ---------------------------------
_ym2151_write::
;ym2151.c:14: _wait_busy();
	call	__wait_busy
;ym2151.c:16: FmgAddrPort = reg;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgAddrPort),a
;ym2151.c:17: FmgDataPort = value;
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgDataPort),a
	ret
;ym2151.c:20: unsigned char ym2151_read(unsigned char reg) {
;	---------------------------------
; Function ym2151_read
; ---------------------------------
_ym2151_read::
;ym2151.c:21: _wait_busy();
	call	__wait_busy
;ym2151.c:23: FmgAddrPort = reg;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgAddrPort),a
;ym2151.c:24: return FmgDataPort;
	in	a,(_FmgDataPort)
	ld	l,a
	ret
;ym2151.c:27: void ym2151_setCT1(unsigned char value) {
;	---------------------------------
; Function ym2151_setCT1
; ---------------------------------
_ym2151_setCT1::
;ym2151.c:28: unsigned char reg = ym2151_read(0x1B);
	ld	a,#0x1B
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	h,l
;ym2151.c:30: ym2151_write(0x1B, value ? reg | 0x40 : reg & 0xBF);
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	6, h
	jr	00104$
00103$:
	res	6, h
00104$:
	push	hl
	inc	sp
	ld	a,#0x1B
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:33: void ym2151_setCT2(unsigned char value) {
;	---------------------------------
; Function ym2151_setCT2
; ---------------------------------
_ym2151_setCT2::
;ym2151.c:34: unsigned char reg = ym2151_read(0x1B);
	ld	a,#0x1B
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	h,l
;ym2151.c:36: ym2151_write(0x1B, value ? reg | 0x80 : reg & 0x7F);
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	7, h
	jr	00104$
00103$:
	res	7, h
00104$:
	push	hl
	inc	sp
	ld	a,#0x1B
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:39: void ym2151_setLFOWaveform(E_YM_WAVEFORM wf) {
;	---------------------------------
; Function ym2151_setLFOWaveform
; ---------------------------------
_ym2151_setLFOWaveform::
;ym2151.c:40: unsigned char reg = ym2151_read(0x1B);
	ld	a,#0x1B
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:42: ym2151_write(0x1B, (reg & 0xFC) | wf);
	and	a, #0xFC
	ld	hl, #2+0
	add	hl, sp
	or	a, (hl)
	ld	d,a
	ld	e,#0x1B
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:45: void ym2151_setLFOFrequency(unsigned char value) {
;	---------------------------------
; Function ym2151_setLFOFrequency
; ---------------------------------
_ym2151_setLFOFrequency::
;ym2151.c:46: ym2151_write(0x18, value);
	ld	hl, #2+0
	add	hl, sp
	ld	d, (hl)
	ld	e,#0x18
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:49: void ym2151_setLFOModulation(E_YM_MODULATION mod) {
;	---------------------------------
; Function ym2151_setLFOModulation
; ---------------------------------
_ym2151_setLFOModulation::
;ym2151.c:50: unsigned char reg = ym2151_read(0x19);
	ld	a,#0x19
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:52: ym2151_write(0x19, (reg & 0x7F) | mod); 
	and	a, #0x7F
	ld	hl, #2+0
	add	hl, sp
	or	a, (hl)
	ld	d,a
	ld	e,#0x19
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:55: void ym2151_setLFOAmplitude(unsigned char value) {
;	---------------------------------
; Function ym2151_setLFOAmplitude
; ---------------------------------
_ym2151_setLFOAmplitude::
;ym2151.c:56: unsigned char reg = ym2151_read(0x19);
	ld	a,#0x19
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:58: ym2151_write(0x19, (reg & 0x80) | (value & 0x7F)); 
	and	a, #0x80
	ld	h,a
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x7F
	or	a, h
	ld	d,a
	ld	e,#0x19
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:61: void ym2151_resetLFO() {
;	---------------------------------
; Function ym2151_resetLFO
; ---------------------------------
_ym2151_resetLFO::
;ym2151.c:62: unsigned char reg = ym2151_read(0x01);
	ld	a,#0x01
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:64: ym2151_write(0x01, reg ^ 0x02);
	xor	a, #0x02
	ld	d,a
	ld	e,#0x01
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:67: void ym2151_setNoiseEnable(unsigned char value) {
;	---------------------------------
; Function ym2151_setNoiseEnable
; ---------------------------------
_ym2151_setNoiseEnable::
;ym2151.c:68: unsigned char reg = ym2151_read(0x0F);
	ld	a,#0x0F
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	h,l
;ym2151.c:70: ym2151_write(0x0F, value ? reg | 0x80 : reg & 0x7F); 
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	7, h
	jr	00104$
00103$:
	res	7, h
00104$:
	push	hl
	inc	sp
	ld	a,#0x0F
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:73: void ym2151_setNoiseFrequency(unsigned char value) {
;	---------------------------------
; Function ym2151_setNoiseFrequency
; ---------------------------------
_ym2151_setNoiseFrequency::
;ym2151.c:74: unsigned char reg = ym2151_read(0x0F);
	ld	a,#0x0F
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:76: ym2151_write(0x0F, (reg & 0xE0) | (value & 0x1F)); 
	and	a, #0xE0
	ld	h,a
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x1F
	or	a, h
	ld	d,a
	ld	e,#0x0F
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:79: void ym2151_setKeyState(unsigned char channel, E_YM_KEY key) {
;	---------------------------------
; Function ym2151_setKeyState
; ---------------------------------
_ym2151_setKeyState::
;ym2151.c:80: ym2151_write(0x08, key | (channel & 0x07));
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	and	a, #0x07
	ld	hl, #3+0
	add	hl, sp
	or	a, (hl)
	ld	d,a
	ld	e,#0x08
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:83: void ym2151_setChannels(E_YM_CHANNELS channels) {
;	---------------------------------
; Function ym2151_setChannels
; ---------------------------------
_ym2151_setChannels::
;ym2151.c:84: unsigned char reg = ym2151_read(0x20);
	ld	a,#0x20
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:86: ym2151_write(0x20, (reg & 0x3F) | channels);
	and	a, #0x3F
	ld	hl, #2+0
	add	hl, sp
	or	a, (hl)
	ld	d,a
	ld	e,#0x20
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:89: void ym2151_setConnections(unsigned char connect) {
;	---------------------------------
; Function ym2151_setConnections
; ---------------------------------
_ym2151_setConnections::
;ym2151.c:90: unsigned char reg = ym2151_read(0x20);
	ld	a,#0x20
	push	af
	inc	sp
	call	_ym2151_read
	inc	sp
	ld	a,l
;ym2151.c:92: ym2151_write(0x20, (reg & 0xF8) | (connect & 0x07));
	and	a, #0xF8
	ld	h,a
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x07
	or	a, h
	ld	d,a
	ld	e,#0x20
	push	de
	call	_ym2151_write
	pop	af
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)

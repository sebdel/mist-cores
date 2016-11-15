;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Thu Nov 10 13:21:35 2016
;--------------------------------------------------------
	.module ym2151
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl __wait_busy
	.globl _nb_bits
	.globl _dbg_print
	.globl _text_hex
	.globl _text_char
	.globl _registers
	.globl _ym2151_init
	.globl _ym2151_write
	.globl _ym2151_setCT1
	.globl _ym2151_setCT2
	.globl _ym2151_setLFOWaveform
	.globl _ym2151_setLFOFrequency
	.globl _ym2151_setLFOModulation
	.globl _ym2151_setLFOAmplitude
	.globl _ym2151_resetLFO
	.globl _ym2151_setNoiseEnable
	.globl _ym2151_setNoiseFrequency
	.globl _ym2151_setKeyState
	.globl _ym2151_setKeyNote
	.globl _ym2151_setKeyFraction
	.globl _ym2151_setChannels
	.globl _ym2151_setConnections
	.globl _ym2151_setAmplitudeModulationSensitivity
	.globl _ym2151_setPhaseModulationSensitivity
	.globl _ym2151_setDetune1PhaseMultiply
	.globl _ym2151_setTotalLevel
	.globl _ym2151_setKeyScalingAttackRate
	.globl _ym2151_setAMSEnableDecayRate1
	.globl _ym2151_setDetune2DecayRate2
	.globl _ym2151_setDecayLevelReleaseRate
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_FmgAddrPort	=	0x0040
_FmgDataPort	=	0x0041
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_registers::
	.ds 21
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
;ym2151.c:10: void dbg_print(unsigned char reg, unsigned char value, unsigned char i, unsigned char j) {
;	---------------------------------
; Function dbg_print
; ---------------------------------
_dbg_print::
;ym2151.c:13: text_char(dst, 'R');
	ld	a,#0x52
	push	af
	inc	sp
	ld	hl,#0x4880
	push	hl
	call	_text_char
	pop	af
	inc	sp
;ym2151.c:14: text_hex(dst+1, reg);
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl,#0x4881
	push	hl
	call	_text_hex
	pop	af
	inc	sp
;ym2151.c:15: text_char(dst+3, '=');
	ld	a,#0x3D
	push	af
	inc	sp
	ld	hl,#0x4883
	push	hl
	call	_text_char
	pop	af
	inc	sp
;ym2151.c:16: text_hex(dst+4, value);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl,#0x4884
	push	hl
	call	_text_hex
	pop	af
	inc	sp
;ym2151.c:18: text_hex(dst+8, i);
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl,#0x4888
	push	hl
	call	_text_hex
	pop	af
	inc	sp
;ym2151.c:19: text_hex(dst+11, j);
	ld	hl, #5+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl,#0x488B
	push	hl
	call	_text_hex
	pop	af
	inc	sp
	ret
;ym2151.c:22: unsigned char nb_bits(unsigned char quartet) {
;	---------------------------------
; Function nb_bits
; ---------------------------------
_nb_bits::
	ld	hl,#-16
	add	hl,sp
	ld	sp,hl
;ym2151.c:23: unsigned char nb[16] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};
	ld	hl,#0x0000
	add	hl,sp
	ex	de,hl
	xor	a, a
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x01
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	(hl),#0x01
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x02
	ld	hl,#0x0004
	add	hl,de
	ld	(hl),#0x01
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x02
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#0x02
	ld	hl,#0x0007
	add	hl,de
	ld	(hl),#0x03
	ld	hl,#0x0008
	add	hl,de
	ld	(hl),#0x01
	ld	hl,#0x0009
	add	hl,de
	ld	(hl),#0x02
	ld	hl,#0x000A
	add	hl,de
	ld	(hl),#0x02
	ld	hl,#0x000B
	add	hl,de
	ld	(hl),#0x03
	ld	hl,#0x000C
	add	hl,de
	ld	(hl),#0x02
	ld	hl,#0x000D
	add	hl,de
	ld	(hl),#0x03
	ld	hl,#0x000E
	add	hl,de
	ld	(hl),#0x03
	ld	hl,#0x000F
	add	hl,de
	ld	(hl),#0x04
;ym2151.c:25: return nb[quartet & 0x0f];
	ld	hl, #18+0
	add	hl, sp
	ld	a, (hl)
	and	a, #0x0F
	ld	l, a
	ld	h,#0x00
	add	hl,de
	ld	l,(hl)
	ld	iy,#16
	add	iy,sp
	ld	sp,iy
	ret
;ym2151.c:28: unsigned char _wait_busy() {
;	---------------------------------
; Function _wait_busy
; ---------------------------------
__wait_busy::
;ym2151.c:32: for (i = 0; (FmgDataPort & 0x80) && (i < 100); i++);
	ld	d,#0x00
00104$:
	in	a,(_FmgDataPort)
	rlca
	jr	NC,00101$
	ld	a,d
	sub	a, #0x64
	jr	NC,00101$
	inc	d
	jr	00104$
00101$:
;ym2151.c:34: return i;
	ld	l,d
	ret
;ym2151.c:37: void ym2151_init() {
;	---------------------------------
; Function ym2151_init
; ---------------------------------
_ym2151_init::
;ym2151.c:40: memset(&registers, 0, sizeof(struct s_ym2151_registers));
	ld	hl,#_registers
	ld	b, #0x15
00111$:
	ld	(hl), #0x00
	inc	hl
	djnz	00111$
;ym2151.c:42: ym2151_write(0x01, registers._0x01_);
	ld	a, (#_registers + 0)
	ld	d,a
	ld	e,#0x01
	push	de
	call	_ym2151_write
	pop	af
;ym2151.c:43: ym2151_write(0x0F, registers._0x0F_);
	ld	a, (#_registers + 1)
	ld	d,a
	ld	e,#0x0F
	push	de
	call	_ym2151_write
	pop	af
;ym2151.c:44: ym2151_write(0x18, registers._0x18_);
	ld	a, (#_registers + 2)
	ld	d,a
	ld	e,#0x18
	push	de
	call	_ym2151_write
	pop	af
;ym2151.c:45: ym2151_write(0x19, registers._0x19_);
	ld	a, (#_registers + 3)
	ld	d,a
	ld	e,#0x19
	push	de
	call	_ym2151_write
	pop	af
;ym2151.c:46: ym2151_write(0x1B, registers._0x1B_);
	ld	a, (#_registers + 4)
	ld	d,a
	ld	e,#0x1B
	push	de
	call	_ym2151_write
	pop	af
;ym2151.c:48: for (i = 0; i < 8; i++) 
	ld	e,#0x00
00102$:
;ym2151.c:49: ym2151_write(0x20 + i, registers._0x20_[i]);
	ld	hl,#(_registers + 0x0005)
	ld	d,#0x00
	add	hl, de
	ld	h,(hl)
	ld	a,e
	add	a, #0x20
	push	de
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	de
;ym2151.c:48: for (i = 0; i < 8; i++) 
	inc	e
	ld	a,e
	sub	a, #0x08
	jr	C,00102$
	ret
;ym2151.c:52: void ym2151_write(unsigned char reg, unsigned char value) {
;	---------------------------------
; Function ym2151_write
; ---------------------------------
_ym2151_write::
;ym2151.c:56: i = _wait_busy();
	call	__wait_busy
	ld	d,l
;ym2151.c:57: FmgAddrPort = reg;
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgAddrPort),a
;ym2151.c:58: FmgDataPort = value;
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	out	(_FmgDataPort),a
;ym2151.c:60: j = _wait_busy();
	push	de
	call	__wait_busy
	ld	h,l
	pop	de
;ym2151.c:61: dbg_print(reg, value, i, j);
	push	hl
	inc	sp
	push	de
	inc	sp
	ld	hl, #5+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	hl, #5+0
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_dbg_print
	pop	af
	pop	af
	ret
;ym2151.c:65: void ym2151_setCT1(unsigned char value) {
;	---------------------------------
; Function ym2151_setCT1
; ---------------------------------
_ym2151_setCT1::
;ym2151.c:66: registers._0x1B_ = value ? registers._0x1B_ | 0x40 : registers._0x1B_ & 0xBF;
	ld	hl,#_registers+4
	ld	d,(hl)
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	6, d
	jr	00104$
00103$:
	res	6, d
00104$:
	ld	(hl),d
;ym2151.c:68: ym2151_write(0x1B, registers._0x1B_);
	ld	e, #0x1B
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:71: void ym2151_setCT2(unsigned char value) {
;	---------------------------------
; Function ym2151_setCT2
; ---------------------------------
_ym2151_setCT2::
;ym2151.c:72: registers._0x1B_ = value ? registers._0x1B_ | 0x80 : registers._0x1B_ & 0x7F;
	ld	hl,#_registers+4
	ld	d,(hl)
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	7, d
	jr	00104$
00103$:
	res	7, d
00104$:
	ld	(hl),d
;ym2151.c:74: ym2151_write(0x1B, registers._0x1B_);
	ld	e, #0x1B
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:77: void ym2151_setLFOWaveform(E_YM_WAVEFORM wf) {
;	---------------------------------
; Function ym2151_setLFOWaveform
; ---------------------------------
_ym2151_setLFOWaveform::
;ym2151.c:78: registers._0x1B_ = (registers._0x1B_ & 0xFC) | wf;
	ld	hl,#_registers+4
	ld	a,(hl)
	and	a, #0xFC
	ld	iy,#2
	add	iy,sp
	or	a, 0 (iy)
	ld	(hl),a
;ym2151.c:80: ym2151_write(0x1B, registers._0x1B_);
	ld	d,a
	ld	e,#0x1B
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:83: void ym2151_setLFOFrequency(unsigned char value) {
;	---------------------------------
; Function ym2151_setLFOFrequency
; ---------------------------------
_ym2151_setLFOFrequency::
;ym2151.c:84: registers._0x18_ = value;
	ld	hl,#_registers+2
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	ld	(hl),a
;ym2151.c:86: ym2151_write(0x18, registers._0x18_);
	ld	d, 0 (iy)
	ld	e,#0x18
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:89: void ym2151_setLFOModulation(E_YM_MODULATION mod) {
;	---------------------------------
; Function ym2151_setLFOModulation
; ---------------------------------
_ym2151_setLFOModulation::
;ym2151.c:90: registers._0x19_ = (registers._0x19_ & 0x7F) | mod;
	ld	hl,#_registers+3
	ld	a,(hl)
	and	a, #0x7F
	ld	iy,#2
	add	iy,sp
	or	a, 0 (iy)
	ld	(hl),a
;ym2151.c:92: ym2151_write(0x19, registers._0x19_); 
	ld	d,a
	ld	e,#0x19
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:95: void ym2151_setLFOAmplitude(unsigned char value) {
;	---------------------------------
; Function ym2151_setLFOAmplitude
; ---------------------------------
_ym2151_setLFOAmplitude::
;ym2151.c:96: registers._0x19_ = (registers._0x19_ & 0x80) | (value & 0x7F);
	ld	hl,#_registers+3
	ld	a,(hl)
	and	a, #0x80
	ld	d,a
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x7F
	or	a, d
	ld	(hl),a
;ym2151.c:98: ym2151_write(0x19, registers._0x19_); 
	ld	d,a
	ld	e,#0x19
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:101: void ym2151_resetLFO() {
;	---------------------------------
; Function ym2151_resetLFO
; ---------------------------------
_ym2151_resetLFO::
;ym2151.c:102: registers._0x01_ ^= 0x02;
	ld	hl,#_registers+0
	ld	a,(hl)
	xor	a, #0x02
	ld	(hl),a
;ym2151.c:104: ym2151_write(0x01, registers._0x01_);
	ld	d,a
	ld	e,#0x01
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:107: void ym2151_setNoiseEnable(unsigned char value) {
;	---------------------------------
; Function ym2151_setNoiseEnable
; ---------------------------------
_ym2151_setNoiseEnable::
;ym2151.c:108: registers._0x0F_ = value ? registers._0x0F_ | 0x80 : registers._0x0F_ & 0x7F; 
	ld	hl,#_registers+1
	ld	d,(hl)
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00103$
	set	7, d
	jr	00104$
00103$:
	res	7, d
00104$:
	ld	(hl),d
;ym2151.c:110: ym2151_write(0x0F, registers._0x0F_); 
	ld	e, #0x0F
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:113: void ym2151_setNoiseFrequency(unsigned char value) {
;	---------------------------------
; Function ym2151_setNoiseFrequency
; ---------------------------------
_ym2151_setNoiseFrequency::
;ym2151.c:114: registers._0x0F_ = (registers._0x0F_ & 0xE0) | (value & 0x1F); 
	ld	hl,#_registers+1
	ld	a,(hl)
	and	a, #0xE0
	ld	d,a
	ld	iy,#2
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x1F
	or	a, d
	ld	(hl),a
;ym2151.c:116: ym2151_write(0x0F, registers._0x0F_); 
	ld	d,a
	ld	e,#0x0F
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:119: void ym2151_setKeyState(unsigned char channel, E_YM_KEY key_config) {
;	---------------------------------
; Function ym2151_setKeyState
; ---------------------------------
_ym2151_setKeyState::
;ym2151.c:120: unsigned char kon_cmd = key_config | (channel & 0x07);	
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	and	a, #0x07
	ld	hl, #3+0
	add	hl, sp
	or	a, (hl)
;ym2151.c:122: ym2151_write(0x08, kon_cmd);
	ld	d,a
	ld	e,#0x08
	push	de
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:125: void ym2151_setKeyNote(unsigned char channel, unsigned char octave, unsigned char note) {
;	---------------------------------
; Function ym2151_setKeyNote
; ---------------------------------
_ym2151_setKeyNote::
;ym2151.c:126: ym2151_write(0x28 + channel, ((octave << 4) & 0x70) | (note & 0x0F));
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	and	a, #0x70
	ld	h,a
	ld	iy,#4
	add	iy,sp
	ld	a,0 (iy)
	and	a, #0x0F
	or	a, h
	ld	d,a
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x28
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:129: void ym2151_setKeyFraction(unsigned char channel, unsigned char fraction) {
;	---------------------------------
; Function ym2151_setKeyFraction
; ---------------------------------
_ym2151_setKeyFraction::
;ym2151.c:130: ym2151_write(0x30 + channel, (fraction << 2) & 0xFC);
	ld	hl, #3+0
	add	hl, sp
	ld	a, (hl)
	add	a, a
	add	a, a
	and	a, #0xFC
	ld	d,a
	ld	hl, #2+0
	add	hl, sp
	ld	a, (hl)
	add	a, #0x30
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:133: void ym2151_setChannels(unsigned char channel, E_YM_CHANNELS channels) {
;	---------------------------------
; Function ym2151_setChannels
; ---------------------------------
_ym2151_setChannels::
;ym2151.c:134: registers._0x20_[channel] = (registers._0x20_[channel] & 0x3F) | channels; 
	ld	hl,#_registers+5
	ld	iy,#2
	add	iy,sp
	ld	e,0 (iy)
	ld	c,e
	ld	b,#0x00
	add	hl,bc
	ld	a,(hl)
	and	a, #0x3F
	ld	iy,#3
	add	iy,sp
	or	a, 0 (iy)
	ld	d,a
	ld	(hl),d
;ym2151.c:136: ym2151_write(0x20 + channel, registers._0x20_[channel]);
	ld	a,e
	add	a, #0x20
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	ret
;ym2151.c:139: void ym2151_setConnections(unsigned char channel, unsigned char connect) {
;	---------------------------------
; Function ym2151_setConnections
; ---------------------------------
_ym2151_setConnections::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:140: registers._0x20_[channel] = (registers._0x20_[channel] & 0xF8) | (connect & 0x07); 
	ld	hl,#_registers+5
	ld	e,4 (ix)
	ld	c,e
	ld	b,#0x00
	add	hl,bc
	ld	a,(hl)
	and	a, #0xF8
	ld	d,a
	ld	a,5 (ix)
	and	a, #0x07
	or	a, d
	ld	d,a
	ld	(hl),d
;ym2151.c:142: ym2151_write(0x20 + channel, registers._0x20_[channel]);
	ld	a,e
	add	a, #0x20
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	ix
	ret
;ym2151.c:145: void ym2151_setAmplitudeModulationSensitivity(unsigned char channel, unsigned char ams) {
;	---------------------------------
; Function ym2151_setAmplitudeModulationSensitivity
; ---------------------------------
_ym2151_setAmplitudeModulationSensitivity::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:146: registers._0x38_[channel] = (registers._0x38_[channel] & 0xFC) | (ams & 0x03); 
	ld	hl,#_registers+13
	ld	e,4 (ix)
	ld	c,e
	ld	b,#0x00
	add	hl,bc
	ld	a,(hl)
	and	a, #0xFC
	ld	d,a
	ld	a,5 (ix)
	and	a, #0x03
	or	a, d
	ld	d,a
	ld	(hl),d
;ym2151.c:148: ym2151_write(0x38 + channel, registers._0x38_[channel]);
	ld	a,e
	add	a, #0x38
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	ix
	ret
;ym2151.c:151: void ym2151_setPhaseModulationSensitivity(unsigned char channel, unsigned char pms) {
;	---------------------------------
; Function ym2151_setPhaseModulationSensitivity
; ---------------------------------
_ym2151_setPhaseModulationSensitivity::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:152: registers._0x38_[channel] = (registers._0x38_[channel] & 0x8F) | (pms & 0x70); 
	ld	hl,#_registers+13
	ld	e,4 (ix)
	ld	c,e
	ld	b,#0x00
	add	hl,bc
	ld	a,(hl)
	and	a, #0x8F
	ld	d,a
	ld	a,5 (ix)
	and	a, #0x70
	or	a, d
	ld	d,a
	ld	(hl),d
;ym2151.c:154: ym2151_write(0x38 + channel, registers._0x38_[channel]);
	ld	a,e
	add	a, #0x38
	push	de
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	ix
	ret
;ym2151.c:157: void ym2151_setDetune1PhaseMultiply(unsigned char channel, E_YM_KEY key_config, unsigned char detune1, unsigned char phase_multiply) {
;	---------------------------------
; Function ym2151_setDetune1PhaseMultiply
; ---------------------------------
_ym2151_setDetune1PhaseMultiply::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:160: ym2151_write(0x40 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	ld	a,6 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	l,a
	ld	a,7 (ix)
	and	a, #0x0F
	ld	h,a
	ld	a,l
	and	a, #0x70
	or	a, h
	ld	h,a
;ym2151.c:159: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:160: ym2151_write(0x40 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	ld	a,4 (ix)
	add	a, #0x40
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:162: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:163: ym2151_write(0x48 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	ld	a,4 (ix)
	add	a, #0x48
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:165: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:166: ym2151_write(0x50 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	ld	a,4 (ix)
	add	a, #0x50
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:168: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:169: ym2151_write(0x58 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	ld	a,4 (ix)
	add	a, #0x58
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
;ym2151.c:173: void ym2151_setTotalLevel(unsigned char channel, E_YM_KEY key_config, unsigned char total_level) {
;	---------------------------------
; Function ym2151_setTotalLevel
; ---------------------------------
_ym2151_setTotalLevel::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:176: ym2151_write(0x60 + channel, total_level & 0x7F);
	ld	h,6 (ix)
	res	7, h
;ym2151.c:175: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:176: ym2151_write(0x60 + channel, total_level & 0x7F);
	ld	a,4 (ix)
	add	a, #0x60
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:178: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:179: ym2151_write(0x68 + channel, total_level & 0x7F);
	ld	a,4 (ix)
	add	a, #0x68
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:181: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:182: ym2151_write(0x70 + channel, total_level & 0x7F);
	ld	a,4 (ix)
	add	a, #0x70
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:184: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:185: ym2151_write(0x78 + channel, total_level & 0x7F);
	ld	a,4 (ix)
	add	a, #0x78
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
;ym2151.c:189: void ym2151_setKeyScalingAttackRate(unsigned char channel, E_YM_KEY key_config, unsigned char key_scaling, unsigned char attack_rate) {
;	---------------------------------
; Function ym2151_setKeyScalingAttackRate
; ---------------------------------
_ym2151_setKeyScalingAttackRate::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:192: ym2151_write(0x80 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	ld	a,6 (ix)
	rrca
	rrca
	and	a,#0xC0
	ld	l,a
	ld	a,7 (ix)
	and	a, #0x1F
	ld	h,a
	ld	a,l
	and	a, #0xC0
	or	a, h
	ld	h,a
;ym2151.c:191: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:192: ym2151_write(0x80 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	ld	a,4 (ix)
	add	a, #0x80
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:194: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:195: ym2151_write(0x88 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	ld	a,4 (ix)
	add	a, #0x88
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:197: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:198: ym2151_write(0x90 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	ld	a,4 (ix)
	add	a, #0x90
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:200: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:201: ym2151_write(0x98 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	ld	a,4 (ix)
	add	a, #0x98
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
;ym2151.c:205: void ym2151_setAMSEnableDecayRate1(unsigned char channel, E_YM_KEY key_config, unsigned char ams_enable, unsigned char decay_rate1) {
;	---------------------------------
; Function ym2151_setAMSEnableDecayRate1
; ---------------------------------
_ym2151_setAMSEnableDecayRate1::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:208: ym2151_write(0xA0 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	ld	a,7 (ix)
	and	a, #0x1F
	ld	l,a
;ym2151.c:207: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:208: ym2151_write(0xA0 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	ld	a,6 (ix)
	or	a, a
	jr	Z,00111$
	ld	a,#0x80
	jr	00112$
00111$:
	ld	a,#0x00
00112$:
	or	a, l
	ld	h,a
	ld	a,4 (ix)
	add	a, #0xA0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:210: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:211: ym2151_write(0xA8 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	ld	a,6 (ix)
	or	a, a
	jr	Z,00113$
	ld	a,#0x80
	jr	00114$
00113$:
	ld	a,#0x00
00114$:
	or	a, l
	ld	h,a
	ld	a,4 (ix)
	add	a, #0xA8
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:213: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:214: ym2151_write(0xB0 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	ld	a,6 (ix)
	or	a, a
	jr	Z,00115$
	ld	a,#0x80
	jr	00116$
00115$:
	ld	a,#0x00
00116$:
	or	a, l
	ld	h,a
	ld	a,4 (ix)
	add	a, #0xB0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:216: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:217: ym2151_write(0xB8 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	ld	a,6 (ix)
	or	a, a
	jr	Z,00117$
	ld	a,#0x80
	jr	00118$
00117$:
	ld	a,#0x00
00118$:
	or	a, l
	ld	h,a
	ld	a,4 (ix)
	add	a, #0xB8
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
;ym2151.c:221: void ym2151_setDetune2DecayRate2(unsigned char channel, E_YM_KEY key_config, unsigned char detune2, unsigned char decay_rate2) {
;	---------------------------------
; Function ym2151_setDetune2DecayRate2
; ---------------------------------
_ym2151_setDetune2DecayRate2::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:224: ym2151_write(0xC0 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	ld	a,6 (ix)
	rrca
	rrca
	and	a,#0xC0
	ld	l,a
	ld	a,7 (ix)
	and	a, #0x0F
	ld	h,a
	ld	a,l
	and	a, #0xC0
	or	a, h
	ld	h,a
;ym2151.c:223: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:224: ym2151_write(0xC0 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	ld	a,4 (ix)
	add	a, #0xC0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:226: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:227: ym2151_write(0xC8 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F)); 
	ld	a,4 (ix)
	add	a, #0xC8
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:229: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:230: ym2151_write(0xD0 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	ld	a,4 (ix)
	add	a, #0xD0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:232: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:233: ym2151_write(0xD8 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	ld	a,4 (ix)
	add	a, #0xD8
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
;ym2151.c:237: void ym2151_setDecayLevelReleaseRate(unsigned char channel, E_YM_KEY key_config, unsigned char decay_level, unsigned char release_rate) {
;	---------------------------------
; Function ym2151_setDecayLevelReleaseRate
; ---------------------------------
_ym2151_setDecayLevelReleaseRate::
	push	ix
	ld	ix,#0
	add	ix,sp
;ym2151.c:240: ym2151_write(0xE0 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	ld	a,6 (ix)
	rlca
	rlca
	rlca
	rlca
	and	a,#0xF0
	ld	l,a
	ld	a,7 (ix)
	and	a, #0x0F
	ld	h,a
	ld	a,l
	and	a, #0xF0
	or	a, h
	ld	h,a
;ym2151.c:239: if (key_config & YM_KEY_MOD1) {
	bit	6, 5 (ix)
	jr	Z,00102$
;ym2151.c:240: ym2151_write(0xE0 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	ld	a,4 (ix)
	add	a, #0xE0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00102$:
;ym2151.c:242: if (key_config & YM_KEY_MOD2) {
	bit	4, 5 (ix)
	jr	Z,00104$
;ym2151.c:243: ym2151_write(0xE8 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	ld	a,4 (ix)
	add	a, #0xE8
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00104$:
;ym2151.c:245: if (key_config & YM_KEY_CAR1) {
	bit	5, 5 (ix)
	jr	Z,00106$
;ym2151.c:246: ym2151_write(0xF0 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	ld	a,4 (ix)
	add	a, #0xF0
	push	hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
	pop	hl
00106$:
;ym2151.c:248: if (key_config & YM_KEY_CAR2) {
	bit	3, 5 (ix)
	jr	Z,00109$
;ym2151.c:249: ym2151_write(0xF8 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	ld	a,4 (ix)
	add	a, #0xF8
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_ym2151_write
	pop	af
00109$:
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)

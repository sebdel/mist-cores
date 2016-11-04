;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.4.0 #8981 (Jul 12 2014) (Linux)
; This file was generated Mon Jan 18 22:50:17 2016
;--------------------------------------------------------
	.module mmc
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _forward
	.globl _dly_us
	.globl _disk_initialize
	.globl _disk_readp
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
_DataPort	=	0x0000
_ControlPort	=	0x0001
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_buffer:
	.ds 512
_CardType:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_buffer_sector:
	.ds 4
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
;mmc.c:29: void dly_us(unsigned char n) {
;	---------------------------------
; Function dly_us
; ---------------------------------
_dly_us_start::
_dly_us:
;mmc.c:30: while(n--);
	ld	hl, #2+0
	add	hl, sp
	ld	d, (hl)
00101$:
	ld	e,d
	dec	d
	ld	a,e
	or	a, a
	jr	NZ,00101$
	ret
_dly_us_end::
;mmc.c:33: void forward(BYTE n) {
;	---------------------------------
; Function forward
; ---------------------------------
_forward_start::
_forward:
;mmc.c:34: }
	ret
_forward_end::
;mmc.c:85: BYTE rcvr_mmc (void)
;	---------------------------------
; Function rcvr_mmc
; ---------------------------------
_rcvr_mmc:
;mmc.c:87: DataPort = 0xff;
	ld	a,#0xFF
	out	(_DataPort),a
;mmc.c:94: __endasm;
	nop
	nop
;mmc.c:96: return DataPort;
	in	a,(_DataPort)
	ld	l,a
	ret
;mmc.c:104: void skip_mmc (
;	---------------------------------
; Function skip_mmc
; ---------------------------------
_skip_mmc:
;mmc.c:108: do {
	pop	bc
	pop	de
	push	de
	push	bc
00101$:
;mmc.c:109: DataPort = 0xff;
	ld	a,#0xFF
	out	(_DataPort),a
;mmc.c:110: } while (--n);
	dec	de
	ld	a,d
	or	a,e
	jr	NZ,00101$
	ret
;mmc.c:120: void release_spi (void)
;	---------------------------------
; Function release_spi
; ---------------------------------
_release_spi:
;mmc.c:122: CS_H();
	ld	a,#0x01
	out	(_ControlPort),a
;mmc.c:123: rcvr_mmc();
	jp	_rcvr_mmc
;mmc.c:132: BYTE send_cmd (
;	---------------------------------
; Function send_cmd
; ---------------------------------
_send_cmd:
	push	ix
	ld	ix,#0
	add	ix,sp
;mmc.c:140: if (cmd & 0x80) {	/* ACMD<n> is the command sequense of CMD55-CMD<n> */
	bit	7, 4 (ix)
	jr	Z,00104$
;mmc.c:141: cmd &= 0x7F;
	res	7, 4 (ix)
;mmc.c:142: res = send_cmd(CMD55, 0);
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x77
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
;mmc.c:143: if (res > 1) return res;
	ld	a,#0x01
	sub	a, l
	jp	C,00113$
00104$:
;mmc.c:147: CS_H(); rcvr_mmc();
	ld	a,#0x01
	out	(_ControlPort),a
	call	_rcvr_mmc
;mmc.c:148: CS_L(); rcvr_mmc();
	ld	a,#0x00
	out	(_ControlPort),a
	call	_rcvr_mmc
;mmc.c:151: XMIT_MMC(cmd);					/* Start + Command index */
	ld	a,4 (ix)
	out	(_DataPort),a
;mmc.c:152: XMIT_MMC((BYTE)(arg >> 24));	/* Argument[31..24] */
	push	af
	ld	l,5 (ix)
	ld	h,6 (ix)
	ld	e,7 (ix)
	ld	d,8 (ix)
	pop	af
	ld	b,#0x18
00141$:
	srl	d
	rr	e
	rr	h
	rr	l
	djnz	00141$
	ld	a,l
	out	(_DataPort),a
;mmc.c:153: XMIT_MMC((BYTE)(arg >> 16));	/* Argument[23..16] */
	push	af
	ld	l,5 (ix)
	ld	h,6 (ix)
	ld	e,7 (ix)
	ld	d,8 (ix)
	pop	af
	ld	b,#0x10
00143$:
	srl	d
	rr	e
	rr	h
	rr	l
	djnz	00143$
	ld	a,l
	out	(_DataPort),a
;mmc.c:154: XMIT_MMC((BYTE)(arg >> 8));		/* Argument[15..8] */
	push	af
	ld	h,5 (ix)
	ld	l,6 (ix)
	ld	e,7 (ix)
	ld	d,8 (ix)
	pop	af
	ld	b,#0x08
00145$:
	srl	d
	rr	e
	rr	l
	rr	h
	djnz	00145$
	ld	a,h
	out	(_DataPort),a
;mmc.c:155: XMIT_MMC((BYTE)arg);			/* Argument[7..0] */
	ld	a,5 (ix)
	out	(_DataPort),a
;mmc.c:156: n = 0x01;						/* Dummy CRC + Stop */
	ld	h,#0x01
;mmc.c:157: if (cmd == CMD0) n = 0x95;		/* Valid CRC for CMD0(0) */
	ld	a,4 (ix)
	sub	a, #0x40
	jr	NZ,00106$
	ld	h,#0x95
00106$:
;mmc.c:158: if (cmd == CMD8) n = 0x87;		/* Valid CRC for CMD8(0x1AA) */
	ld	a,4 (ix)
	sub	a, #0x48
	jr	NZ,00108$
	ld	h,#0x87
00108$:
;mmc.c:159: XMIT_MMC(n);
	ld	a,h
	out	(_DataPort),a
;mmc.c:163: do {
	ld	d,#0x0A
00110$:
;mmc.c:164: res = rcvr_mmc();
	push	de
	call	_rcvr_mmc
	pop	de
;mmc.c:165: } while ((res & 0x80) && --n);
	bit	7, l
	jr	Z,00112$
	dec	d
	ld	a,d
	or	a, a
	jr	NZ,00110$
00112$:
;mmc.c:167: return res;			/* Return with the response value */
00113$:
	pop	ix
	ret
;mmc.c:183: DSTATUS disk_initialize (void)
;	---------------------------------
; Function disk_initialize
; ---------------------------------
_disk_initialize_start::
_disk_initialize:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-7
	add	hl,sp
	ld	sp,hl
;mmc.c:188: CS_H();
	ld	a,#0x01
	out	(_ControlPort),a
;mmc.c:189: skip_mmc(10);			/* Dummy clocks */
	ld	hl,#0x000A
	push	hl
	call	_skip_mmc
	pop	af
;mmc.c:191: ty = 0;
	ld	-3 (ix),#0x00
;mmc.c:192: if (send_cmd(CMD0, 0) == 1) {			/* Enter Idle state */
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x40
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	dec	l
	jp	NZ,00125$
;mmc.c:193: if (send_cmd(CMD8, 0x1AA) == 1) {	/* SDv2 */
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x01AA
	push	hl
	ld	a,#0x48
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	dec	l
	jp	NZ,00122$
;mmc.c:194: for (n = 0; n < 4; n++) buf[n] = rcvr_mmc();	/* Get trailing return value of R7 resp */
	ld	hl,#0x0000
	add	hl,sp
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	e,#0x00
00126$:
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	d,#0x00
	add	hl, de
	push	hl
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	pop	hl
	ld	(hl),a
	inc	e
	ld	a,e
	sub	a, #0x04
	jr	C,00126$
;mmc.c:195: if (buf[2] == 0x01 && buf[3] == 0xAA) {			/* The card can work at vdd range of 2.7-3.6V */
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	a
	jp	NZ,00125$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	sub	a, #0xAA
	jp	NZ,00125$
;mmc.c:196: for (tmr = 1000; tmr; tmr--) {				/* Wait for leaving idle state (ACMD41 with HCS bit) */
	ld	de,#0x03E8
00128$:
;mmc.c:197: if (send_cmd(ACMD41, 1UL << 30) == 0) break;
	push	de
	ld	hl,#0x4000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0xE9
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,l
	pop	de
	or	a, a
	jr	Z,00104$
;mmc.c:198: DLY_US(1000);
	push	de
	ld	a,#0xE8
	push	af
	inc	sp
	call	_dly_us
	inc	sp
	pop	de
;mmc.c:196: for (tmr = 1000; tmr; tmr--) {				/* Wait for leaving idle state (ACMD41 with HCS bit) */
	dec	de
	ld	a,d
	or	a,e
	jr	NZ,00128$
00104$:
;mmc.c:200: if (tmr && send_cmd(CMD58, 0) == 0) {		/* Check CCS bit in the OCR */
	ld	a,d
	or	a,e
	jp	Z,00125$
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0x7A
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,l
;mmc.c:201: for (n = 0; n < 4; n++) buf[n] = rcvr_mmc();
	or	a,a
	jp	NZ,00125$
	ld	e,a
00130$:
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	d,#0x00
	add	hl, de
	push	hl
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	pop	hl
	ld	(hl),a
	inc	e
	ld	a,e
	sub	a, #0x04
	jr	C,00130$
;mmc.c:202: ty = (buf[0] & 0x40) ? CT_SD2 | CT_BLOCK : CT_SD2;	/* SDv2 (HC or SC) */
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	bit	6,(hl)
	jr	Z,00136$
	ld	a,#0x0C
	jr	00137$
00136$:
	ld	a,#0x04
00137$:
	ld	-3 (ix),a
	jr	00125$
00122$:
;mmc.c:206: if (send_cmd(ACMD41, 0) <= 1) 	{
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	a,#0xE9
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,#0x01
	sub	a, l
	jr	C,00113$
;mmc.c:207: ty = CT_SD1; cmd = ACMD41;	/* SDv1 */
	ld	-3 (ix),#0x02
	ld	d,#0xE9
	jr	00155$
00113$:
;mmc.c:209: ty = CT_MMC; cmd = CMD1;	/* MMCv3 */
	ld	-3 (ix),#0x01
	ld	d,#0x41
;mmc.c:211: for (tmr = 1000; tmr; tmr--) {			/* Wait for leaving idle state */
00155$:
	ld	bc,#0x03E8
00132$:
;mmc.c:212: if (send_cmd(cmd, 0) == 0) break;
	push	bc
	push	de
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	push	de
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,l
	pop	de
	pop	bc
	or	a, a
	jr	Z,00117$
;mmc.c:213: DLY_US(1000);
	push	bc
	push	de
	ld	a,#0xE8
	push	af
	inc	sp
	call	_dly_us
	inc	sp
	pop	de
	pop	bc
;mmc.c:211: for (tmr = 1000; tmr; tmr--) {			/* Wait for leaving idle state */
	dec	bc
	ld	a,b
	or	a,c
	jr	NZ,00132$
00117$:
;mmc.c:215: if (!tmr || send_cmd(CMD16, 512) != 0)			/* Set R/W block length to 512 */
	ld	a,b
	or	a,c
	jr	Z,00118$
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0200
	push	hl
	ld	a,#0x50
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,l
	or	a, a
	jr	Z,00125$
00118$:
;mmc.c:216: ty = 0;
	ld	-3 (ix),#0x00
00125$:
;mmc.c:219: CardType = ty;
	ld	a,-3 (ix)
	ld	(#_CardType + 0),a
;mmc.c:220: release_spi();
	call	_release_spi
;mmc.c:222: return ty ? 0 : STA_NOINIT;
	ld	a,-3 (ix)
	or	a, a
	jr	Z,00138$
	ld	l,#0x00
	jr	00139$
00138$:
	ld	l,#0x01
00139$:
	ld	sp, ix
	pop	ix
	ret
_disk_initialize_end::
;mmc.c:231: DRESULT disk_readp (
;	---------------------------------
; Function disk_readp
; ---------------------------------
_disk_readp_start::
_disk_readp:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-13
	add	hl,sp
	ld	sp,hl
;mmc.c:238: BYTE *buff_sec = buffer;
;mmc.c:243: if (!(CardType & CT_BLOCK)) sector *= 512;	/* Convert to byte address if needed */
	ld	iy,#_CardType
	bit	3, 0 (iy)
	jr	NZ,00102$
	push	af
	pop	af
	ld	b,#0x09
00231$:
	sla	6 (ix)
	rl	7 (ix)
	rl	8 (ix)
	rl	9 (ix)
	djnz	00231$
00102$:
;mmc.c:269: *buff++ = rcvr_mmc();
	ld	a,4 (ix)
	ld	-4 (ix),a
	ld	a,5 (ix)
	ld	-3 (ix),a
;mmc.c:248: while(count--)
	ld	a,12 (ix)
	ld	-2 (ix),a
	ld	a,13 (ix)
	ld	-1 (ix),a
;mmc.c:246: if(buffer_sector == sector) {
	ld	a,(#_buffer_sector + 0)
	sub	a, 6 (ix)
	jr	NZ,00107$
	ld	a,(#_buffer_sector + 1)
	sub	a, 7 (ix)
	jr	NZ,00107$
	ld	a,(#_buffer_sector + 2)
	sub	a, 8 (ix)
	jr	NZ,00107$
	ld	a,(#_buffer_sector + 3)
	sub	a, 9 (ix)
	jr	NZ,00107$
;mmc.c:247: buff_sec += offset;  // skip to requested bytes
	ld	a,#<(_buffer)
	add	a, 10 (ix)
	ld	c,a
	ld	a,#>(_buffer)
	adc	a, 11 (ix)
	ld	b,a
;mmc.c:248: while(count--)
	ld	e,-4 (ix)
	ld	d,-3 (ix)
	push	hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	pop	iy
	pop	hl
00103$:
	push	iy
	pop	hl
	dec	iy
	ld	a,h
	or	a,l
	jr	Z,00105$
;mmc.c:249: *buff++ = *buff_sec++;
	ld	a,(bc)
	inc	bc
	ld	(de),a
	inc	de
	jr	00103$
00105$:
;mmc.c:251: return RES_OK;
	ld	l,#0x00
	jp	00139$
00107$:
;mmc.c:254: res = RES_ERROR;
	ld	-7 (ix),#0x01
;mmc.c:255: if (send_cmd(CMD17, sector) == 0) {		/* READ_SINGLE_BLOCK */
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	ld	a,#0x51
	push	af
	inc	sp
	call	_send_cmd
	pop	af
	pop	af
	inc	sp
	ld	a,l
	or	a, a
	jp	NZ,00135$
;mmc.c:258: do {							/* Wait for data packet in timeout of 100ms */
	ld	de,#0x03E8
00109$:
;mmc.c:259: DLY_US(100);
	push	de
	ld	a,#0x64
	push	af
	inc	sp
	call	_dly_us
	inc	sp
	call	_rcvr_mmc
	pop	de
;mmc.c:261: } while (d == 0xFF && --tmr);
	ld	a,l
	inc	a
	jr	NZ,00111$
	dec	de
	ld	a,d
	or	a,e
	jr	NZ,00109$
00111$:
;mmc.c:263: if (d == 0xFE) {				/* A data packet arrived */
	ld	a,l
	sub	a, #0xFE
	jp	NZ,00135$
;mmc.c:266: if((!offset) && (count == 512)) {
	ld	a,11 (ix)
	or	a,10 (ix)
	jp	NZ,00129$
	ld	a,12 (ix)
	or	a, a
	jp	NZ,00129$
	ld	a,13 (ix)
	sub	a, #0x02
	jp	NZ,00129$
;mmc.c:268: for(c=0;c<64;c++) {
	ld	-13 (ix),#0x40
00138$:
;mmc.c:269: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:270: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:271: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:272: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:273: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:274: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:275: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
;mmc.c:276: *buff++ = rcvr_mmc();
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_rcvr_mmc
	ld	a,l
	pop	hl
	ld	(hl),a
	inc	hl
	ld	4 (ix),l
	ld	5 (ix),h
	ld	a,-13 (ix)
	add	a,#0xFF
;mmc.c:268: for(c=0;c<64;c++) {
	ld	-13 (ix), a
	or	a, a
	jp	NZ,00138$
;mmc.c:278: skip_mmc(2);
	ld	hl,#0x0002
	push	hl
	call	_skip_mmc
	pop	af
	jp	00130$
00129$:
;mmc.c:281: bc = 512 - offset - count;
	xor	a, a
	sub	a, 10 (ix)
	ld	l,a
	ld	a,#0x02
	sbc	a, 11 (ix)
	ld	h,a
	ld	a,l
	sub	a, 12 (ix)
	ld	l,a
	ld	a,h
	sbc	a, 13 (ix)
	ld	-9 (ix), l
	ld	-8 (ix), a
;mmc.c:284: while(offset--)
	ld	de,#_buffer
	ld	a,10 (ix)
	ld	-6 (ix),a
	ld	a,11 (ix)
	ld	-5 (ix),a
00113$:
	ld	c,-6 (ix)
	ld	b,-5 (ix)
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	dec	hl
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	a,b
	or	a,c
	jr	Z,00115$
;mmc.c:285: *buff_sec++ = rcvr_mmc();
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	ld	(de),a
	inc	de
	jr	00113$
00115$:
;mmc.c:288: if (buff) {	/* Store data to the memory */
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00157$
;mmc.c:289: do
	ld	c,-4 (ix)
	ld	b,-3 (ix)
	ld	-11 (ix),e
	ld	-10 (ix),d
	ld	e,-2 (ix)
	ld	d,-1 (ix)
00116$:
;mmc.c:290: *buff_sec++ = *buff++ = rcvr_mmc();
	push	bc
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	pop	bc
	ld	(bc),a
	inc	bc
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	(hl),a
	inc	-11 (ix)
	jr	NZ,00241$
	inc	-10 (ix)
00241$:
;mmc.c:291: while (--count);
	dec	de
	ld	a,d
	or	a,e
	jr	NZ,00116$
	pop	de
	pop	bc
	push	bc
	push	de
	jr	00159$
;mmc.c:293: do {
00157$:
	ld	c, e
	ld	b, d
	ld	e,-2 (ix)
	ld	d,-1 (ix)
00119$:
;mmc.c:294: *buff_sec++ = d = rcvr_mmc();
	push	bc
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	pop	bc
	ld	-12 (ix),a
	ld	(bc),a
	inc	bc
;mmc.c:295: FORWARD(d);
	push	bc
	push	de
	ld	a,-12 (ix)
	push	af
	inc	sp
	call	_forward
	inc	sp
	pop	de
	pop	bc
;mmc.c:296: } while (--count);
	dec	de
	ld	a,d
	or	a,e
	jr	NZ,00119$
;mmc.c:300: while(bc--)
00159$:
	ld	e,-9 (ix)
	ld	d,-8 (ix)
00125$:
	ld	h,e
	ld	l,d
	dec	de
	ld	a,l
	or	a,h
	jr	Z,00127$
;mmc.c:301: *buff_sec++ = rcvr_mmc();
	push	bc
	push	de
	call	_rcvr_mmc
	ld	a,l
	pop	de
	pop	bc
	ld	(bc),a
	inc	bc
	jr	00125$
00127$:
;mmc.c:304: skip_mmc(2);
	ld	hl,#0x0002
	push	hl
	call	_skip_mmc
	pop	af
;mmc.c:306: buffer_sector = sector;
	ld	de, #_buffer_sector
	ld	hl, #19
	add	hl, sp
	ld	bc, #4
	ldir
00130$:
;mmc.c:309: res = RES_OK;
	ld	-7 (ix),#0x00
00135$:
;mmc.c:313: release_spi();
	call	_release_spi
;mmc.c:315: return res;
	ld	l,-7 (ix)
00139$:
	ld	sp, ix
	pop	ix
	ret
_disk_readp_end::
	.area _CODE
	.area _INITIALIZER
__xinit__buffer_sector:
	.byte #0xFF,#0xFF,#0xFF,#0xFF	; 4294967295
	.area _CABS (ABS)

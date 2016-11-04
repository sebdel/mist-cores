;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Thu Nov  3 14:04:52 2016
;--------------------------------------------------------
	.module pff
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _disk_readp
	.globl _disk_initialize
	.globl _pf_mount
	.globl _pf_open
	.globl _pf_read
	.globl _pf_lseek
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_FatFs:
	.ds 2
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
;pff.c:328: void mem_set (void* dst, int val, int cnt) {
;	---------------------------------
; Function mem_set
; ---------------------------------
_mem_set:
	push	ix
	ld	ix,#0
	add	ix,sp
;pff.c:329: char *d = (char*)dst;
	ld	l,4 (ix)
	ld	h,5 (ix)
;pff.c:330: while (cnt--) *d++ = (char)val;
	ld	c,8 (ix)
	ld	b,9 (ix)
00101$:
	ld	d,c
	ld	e,b
	dec	bc
	ld	a,e
	or	a,d
	jr	Z,00104$
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	jr	00101$
00104$:
	pop	ix
	ret
;pff.c:335: int mem_cmp (const void* dst, const void* src, int cnt) {
;	---------------------------------
; Function mem_cmp
; ---------------------------------
_mem_cmp:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;pff.c:336: const char *d = (const char *)dst, *s = (const char *)src;
	ld	a,4 (ix)
	ld	-2 (ix),a
	ld	a,5 (ix)
	ld	-1 (ix),a
	ld	a,6 (ix)
	ld	-4 (ix),a
	ld	a,7 (ix)
	ld	-3 (ix),a
;pff.c:337: int r = 0;
	ld	hl,#0x0000
;pff.c:338: while (cnt-- && (r = *d++ - *s++) == 0) ;
	ld	c,8 (ix)
	ld	b,9 (ix)
00102$:
	ld	e, c
	ld	d, b
	dec	bc
	ld	a,d
	or	a,e
	jr	Z,00104$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	a,(hl)
	inc	-2 (ix)
	jr	NZ,00116$
	inc	-1 (ix)
00116$:
	ld	e,a
	rla
	sbc	a, a
	ld	d,a
	pop	hl
	push	hl
	ld	a,(hl)
	inc	-4 (ix)
	jr	NZ,00117$
	inc	-3 (ix)
00117$:
	ld	h,a
	rla
	sbc	a, a
	ld	l,a
	ld	a,e
	sub	a, h
	ld	e,a
	ld	a,d
	sbc	a, l
	ld	d,a
	ld	l, e
	ld	a,d
	ld	h,a
	or	a,e
	jr	Z,00102$
00104$:
;pff.c:339: return r;
	ld	sp, ix
	pop	ix
	ret
;pff.c:349: CLUST get_fat (	/* 1:IO error, Else:Cluster status */
;	---------------------------------
; Function get_fat
; ---------------------------------
_get_fat:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-8
	add	hl,sp
	ld	sp,hl
;pff.c:354: FATFS *fs = FatFs;
	ld	de,(_FatFs)
;pff.c:356: if (clst < 2 || clst >= fs->n_fatent)	/* Range check */
	ld	a,4 (ix)
	sub	a, #0x02
	ld	a,5 (ix)
	sbc	a, #0x00
	ld	a,6 (ix)
	sbc	a, #0x00
	ld	a,7 (ix)
	sbc	a, #0x00
	jr	C,00101$
	push	de
	pop	iy
	ld	l,6 (iy)
	ld	h,7 (iy)
	ld	c,8 (iy)
	ld	b,9 (iy)
	ld	a,4 (ix)
	sub	a, l
	ld	a,5 (ix)
	sbc	a, h
	ld	a,6 (ix)
	sbc	a, c
	ld	a,7 (ix)
	sbc	a, b
	jr	C,00102$
00101$:
;pff.c:357: return 1;
	ld	hl,#0x0001
	ld	de,#0x0000
	jp	00111$
00102$:
;pff.c:359: switch (fs->fs_type) {
	ld	a,(de)
	ld	b,a
;pff.c:378: if (disk_readp(buf, fs->fatbase + clst / 256, ((UINT)clst % 256) * 2, 2)) break;
	ld	l,4 (ix)
	ld	a,e
	add	a, #0x0A
	ld	e,a
	ld	a,d
	adc	a, #0x00
	ld	d,a
;pff.c:359: switch (fs->fs_type) {
	ld	a,b
	sub	a, #0x02
	jr	Z,00104$
	ld	a,b
	sub	a, #0x03
	jp	Z,00107$
	jp	00110$
;pff.c:377: case FS_FAT16 :
00104$:
;pff.c:378: if (disk_readp(buf, fs->fatbase + clst / 256, ((UINT)clst % 256) * 2, 2)) break;
	ld	h,#0x00
	add	hl, hl
	ld	c, l
	ld	b, h
	push	bc
	ld	hl, #0x0006
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	push	af
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	e,6 (ix)
	ld	d,7 (ix)
	pop	af
	ld	a,#0x08
00135$:
	srl	d
	rr	e
	rr	h
	rr	l
	dec	a
	jr	NZ,00135$
	ld	a,-4 (ix)
	add	a, l
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, h
	ld	-3 (ix),a
	ld	a,-2 (ix)
	adc	a, e
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, d
	ld	-1 (ix),a
	ld	hl,#0x0000
	add	hl,sp
	ex	de,hl
	push	de
	pop	iy
	push	de
	ld	hl,#0x0002
	push	hl
	push	bc
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	push	iy
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	pop	de
	or	a, a
	jp	NZ,00110$
;pff.c:379: return LD_WORD(buf);
	ld	l, e
	ld	h, d
	inc	hl
	ld	b, (hl)
	ld	c,#0x00
	ld	a,(de)
	ld	l,a
	ld	h,#0x00
	ld	a,l
	or	a, c
	ld	l,a
	ld	a,h
	or	a, b
	ld	h,a
	ld	de,#0x0000
	jp	00111$
;pff.c:382: case FS_FAT32 :
00107$:
;pff.c:383: if (disk_readp(buf, fs->fatbase + clst / 128, ((UINT)clst % 128) * 4, 4)) break;
	res	7, l
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	push	bc
	ld	hl, #0x0006
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	push	af
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	e,6 (ix)
	ld	d,7 (ix)
	pop	af
	ld	a,#0x07
00137$:
	srl	d
	rr	e
	rr	h
	rr	l
	dec	a
	jr	NZ,00137$
	ld	a,-4 (ix)
	add	a, l
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, h
	ld	-3 (ix),a
	ld	a,-2 (ix)
	adc	a, e
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, d
	ld	-1 (ix),a
	ld	hl,#0x0000
	add	hl,sp
	ex	de,hl
	push	de
	pop	iy
	push	de
	ld	hl,#0x0004
	push	hl
	push	bc
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	push	iy
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	pop	de
	or	a, a
	jp	NZ,00110$
;pff.c:384: return LD_DWORD(buf) & 0x0FFFFFFF;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	ld	bc,#0x0000
	push	af
	ld	-4 (ix),l
	ld	-3 (ix),h
	ld	-2 (ix),c
	ld	-1 (ix),b
	pop	af
	ld	a,#0x18
00139$:
	sla	-4 (ix)
	rl	-3 (ix)
	rl	-2 (ix)
	rl	-1 (ix)
	dec	a
	jr	NZ,00139$
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	ld	bc,#0x0000
	ld	a,#0x10
00141$:
	add	hl, hl
	rl	c
	rl	b
	dec	a
	jr	NZ,00141$
	ld	a,-4 (ix)
	or	a, l
	ld	-4 (ix),a
	ld	a,-3 (ix)
	or	a, h
	ld	-3 (ix),a
	ld	a,-2 (ix)
	or	a, c
	ld	-2 (ix),a
	ld	a,-1 (ix)
	or	a, b
	ld	-1 (ix),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	h, (hl)
	ld	l,#0x00
	ld	bc,#0x0000
	ld	a,-4 (ix)
	or	a, l
	ld	-4 (ix),a
	ld	a,-3 (ix)
	or	a, h
	ld	-3 (ix),a
	ld	a,-2 (ix)
	or	a, c
	ld	-2 (ix),a
	ld	a,-1 (ix)
	or	a, b
	ld	-1 (ix),a
	ld	a,(de)
	ld	l,a
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,l
	or	a, -4 (ix)
	ld	l,a
	ld	a,h
	or	a, -3 (ix)
	ld	h,a
	ld	a,e
	or	a, -2 (ix)
	ld	e,a
	ld	a,d
	or	a, -1 (ix)
	and	a, #0x0F
	ld	d,a
	jr	00111$
;pff.c:386: }
00110$:
;pff.c:388: return 1;	/* An error occured at the disk I/O layer */
	ld	hl,#0x0001
	ld	de,#0x0000
00111$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:399: DWORD clust2sect (	/* !=0: Sector number, 0: Failed - invalid cluster# */
;	---------------------------------
; Function clust2sect
; ---------------------------------
_clust2sect:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	push	af
;pff.c:403: FATFS *fs = FatFs;
	ld	bc,(_FatFs)
;pff.c:406: clst -= 2;
	ld	a,4 (ix)
	add	a,#0xFE
	ld	4 (ix),a
	ld	a,5 (ix)
	adc	a,#0xFF
	ld	5 (ix),a
	ld	a,6 (ix)
	adc	a,#0xFF
	ld	6 (ix),a
	ld	a,7 (ix)
	adc	a,#0xFF
	ld	7 (ix),a
;pff.c:407: if (clst >= (fs->n_fatent - 2)) return 0;		/* Invalid cluster# */
	push	bc
	pop	iy
	ld	l,6 (iy)
	ld	h,7 (iy)
	ld	e,8 (iy)
	ld	d,9 (iy)
	ld	a,l
	add	a,#0xFE
	ld	l,a
	ld	a,h
	adc	a,#0xFF
	ld	h,a
	ld	a,e
	adc	a,#0xFF
	ld	e,a
	ld	a,d
	adc	a,#0xFF
	ld	d,a
	ld	a,4 (ix)
	sub	a, l
	ld	a,5 (ix)
	sbc	a, h
	ld	a,6 (ix)
	sbc	a, e
	ld	a,7 (ix)
	sbc	a, d
	jr	C,00102$
	ld	hl,#0x0000
	ld	e,l
	ld	d,h
	jr	00103$
00102$:
;pff.c:408: return (DWORD)clst * fs->csize + fs->database;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e,(hl)
	ld	d,#0x00
	ld	hl,#0x0000
	push	bc
	push	hl
	push	de
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	__mullong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-1 (ix),d
	ld	-2 (ix),e
	ld	-3 (ix),h
	ld	-4 (ix),l
	pop	hl
	ld	de, #0x0012
	add	hl, de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,-4 (ix)
	add	a, e
	ld	l,a
	ld	a,-3 (ix)
	adc	a, d
	ld	h,a
	ld	a,-2 (ix)
	adc	a, c
	ld	e,a
	ld	a,-1 (ix)
	adc	a, b
	ld	d,a
00103$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:413: CLUST get_clust (
;	---------------------------------
; Function get_clust
; ---------------------------------
_get_clust:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;pff.c:417: FATFS *fs = FatFs;
	ld	hl,(_FatFs)
;pff.c:418: CLUST clst = 0;
	ld	de,#0x0000
	ld	bc,#0x0000
;pff.c:421: if (_FS_32ONLY || (_FS_FAT32 && fs->fs_type == FS_FAT32)) {
	ld	a,(hl)
	sub	a, #0x03
	jr	NZ,00102$
;pff.c:422: clst = LD_WORD(dir+DIR_FstClusHI);
	ld	a,4 (ix)
	add	a, #0x14
	ld	c,a
	ld	a,5 (ix)
	adc	a, #0x00
	ld	b,a
	ld	l, c
	ld	h, b
	inc	hl
	ld	d, (hl)
	ld	e,#0x00
	ld	a,(bc)
	ld	l,a
	ld	h,#0x00
	ld	a,e
	or	a, l
	ld	e,a
	ld	a,d
	or	a, h
	ld	d,a
	ld	bc,#0x0000
;pff.c:423: clst <<= 16;
	ld	a,#0x10
00113$:
	sla	e
	rl	d
	rl	c
	rl	b
	dec	a
	jr	NZ,00113$
00102$:
;pff.c:425: clst |= LD_WORD(dir+DIR_FstClusLO);
	ld	iy,#0x001A
	push	bc
	ld	c,4 (ix)
	ld	b,5 (ix)
	add	iy, bc
	pop	bc
	push	iy
	pop	hl
	inc	hl
	ld	h,(hl)
	ld	-1 (ix),h
	ld	-2 (ix),#0x00
	ld	a, 0 (iy)
	ld	l, #0x00
	or	a, -2 (ix)
	ld	h,a
	ld	a,l
	or	a, -1 (ix)
	ld	-6 (ix), h
	ld	-5 (ix), a
	ld	-4 (ix),#0x00
	ld	-3 (ix),#0x00
	ld	a,e
	or	a, -6 (ix)
	ld	l,a
	ld	a,d
	or	a, -5 (ix)
	ld	h,a
	ld	a,c
	or	a, -4 (ix)
	ld	e,a
	ld	a,b
	or	a, -3 (ix)
	ld	d,a
;pff.c:427: return clst;
	ld	sp, ix
	pop	ix
	ret
;pff.c:436: FRESULT dir_rewind (
;	---------------------------------
; Function dir_rewind
; ---------------------------------
_dir_rewind:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-8
	add	hl,sp
	ld	sp,hl
;pff.c:441: FATFS *fs = FatFs;
	ld	hl,(_FatFs)
	ld	-4 (ix),l
	ld	-3 (ix),h
;pff.c:444: dj->index = 0;
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	l, e
	ld	h, d
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;pff.c:445: clst = dj->sclust;
	push	de
	pop	iy
	ld	a,4 (iy)
	ld	-8 (ix),a
	ld	a,5 (iy)
	ld	-7 (ix),a
	ld	a,6 (iy)
	ld	-6 (ix),a
	ld	a,7 (iy)
	ld	-5 (ix),a
;pff.c:446: if (clst == 1 || clst >= fs->n_fatent)	/* Check start cluster range */
	ld	a,-8 (ix)
	dec	a
	jr	NZ,00133$
	ld	a,-7 (ix)
	or	a, a
	jr	NZ,00133$
	ld	a,-6 (ix)
	or	a, a
	jr	NZ,00133$
	ld	a,-5 (ix)
	or	a, a
	jr	Z,00101$
00133$:
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	bc, #0x0006
	add	hl, bc
	ld	b,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-8 (ix)
	sub	a, b
	ld	a,-7 (ix)
	sbc	a, c
	ld	a,-6 (ix)
	sbc	a, h
	ld	a,-5 (ix)
	sbc	a, l
	jr	C,00106$
00101$:
;pff.c:447: return FR_DISK_ERR;
	ld	l,#0x01
	jp	00109$
;pff.c:448: if (_FS_FAT32 && !clst && (_FS_32ONLY || fs->fs_type == FS_FAT32))	/* Replace cluster# 0 with root cluster# if in FAT32 */
00106$:
;pff.c:449: clst = (CLUST)fs->dirbase;
	ld	a,-4 (ix)
	add	a, #0x0E
	ld	c,a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	b,a
;pff.c:448: if (_FS_FAT32 && !clst && (_FS_32ONLY || fs->fs_type == FS_FAT32))	/* Replace cluster# 0 with root cluster# if in FAT32 */
	ld	a,-5 (ix)
	or	a, -6 (ix)
	or	a, -7 (ix)
	or	a,-8 (ix)
	jr	NZ,00105$
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	a,(hl)
	sub	a, #0x03
	jr	NZ,00105$
;pff.c:449: clst = (CLUST)fs->dirbase;
	push	de
	push	bc
	ld	e, c
	ld	d, b
	ld	hl, #0x0004
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	pop	de
00105$:
;pff.c:450: dj->clust = clst;						/* Current cluster */
	ld	hl,#0x0008
	add	hl,de
	push	de
	push	bc
	ex	de,hl
	ld	hl, #0x0004
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
	pop	de
;pff.c:451: dj->sect = (_FS_32ONLY || clst) ? clust2sect(clst) : fs->dirbase;	/* Current sector */
	ld	hl,#0x000C
	add	hl,de
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	a,-5 (ix)
	or	a, -6 (ix)
	or	a, -7 (ix)
	or	a,-8 (ix)
	jr	Z,00111$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	push	hl
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	push	hl
	call	_clust2sect
	pop	af
	pop	af
	ld	c,l
	ld	b,h
	jr	00112$
00111$:
	ld	l, c
	ld	h, b
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
00112$:
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
;pff.c:453: return FR_OK;	/* Seek succeeded */
	ld	l,#0x00
00109$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:464: FRESULT dir_next (	/* FR_OK:Succeeded, FR_NO_FILE:End of table */
;	---------------------------------
; Function dir_next
; ---------------------------------
_dir_next:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-16
	add	hl,sp
	ld	sp,hl
;pff.c:470: FATFS *fs = FatFs;
	ld	hl,(_FatFs)
	ld	-14 (ix),l
	ld	-13 (ix),h
;pff.c:473: i = dj->index + 1;
	ld	a,4 (ix)
	ld	-6 (ix),a
	ld	a,5 (ix)
	ld	-5 (ix),a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	de
	inc	sp
	inc	sp
	push	de
;pff.c:474: if (!i || !dj->sect)	/* Report EOT when index has reached 65535 */
	ld	a,-15 (ix)
	or	a,-16 (ix)
	jr	Z,00101$
	ld	a,-6 (ix)
	add	a, #0x0C
	ld	-12 (ix),a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	-11 (ix),a
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,b
	or	a, c
	or	a, d
	or	a,e
	jr	NZ,00102$
00101$:
;pff.c:475: return FR_NO_FILE;
	ld	l,#0x03
	jp	00117$
00102$:
;pff.c:477: if (!(i % 16)) {		/* Sector changed? */
	ld	a,-16 (ix)
	and	a, #0x0F
	jp	NZ,00116$
;pff.c:478: dj->sect++;			/* Next sector */
	inc	e
	jr	NZ,00149$
	inc	d
	jr	NZ,00149$
	inc	c
	jr	NZ,00149$
	inc	b
00149$:
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
;pff.c:480: if (dj->clust == 0) {	/* Static table */
	ld	a,-6 (ix)
	add	a, #0x08
	ld	-10 (ix),a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	-9 (ix),a
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,b
	or	a, c
	or	a, d
	or	a,e
	jr	NZ,00113$
;pff.c:481: if (i >= fs->n_rootdir)	/* Report EOT when end of table */
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x0004
	add	hl, de
	ld	e,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,-16 (ix)
	sub	a, e
	ld	a,-15 (ix)
	sbc	a, h
	jp	C,00116$
;pff.c:482: return FR_NO_FILE;
	ld	l,#0x03
	jp	00117$
00113$:
;pff.c:485: if (((i / 16) & (fs->csize - 1)) == 0) {	/* Cluster changed? */
	ld	a,-16 (ix)
	ld	-8 (ix),a
	ld	a,-15 (ix)
	ld	-7 (ix),a
	srl	-7 (ix)
	rr	-8 (ix)
	srl	-7 (ix)
	rr	-8 (ix)
	srl	-7 (ix)
	rr	-8 (ix)
	srl	-7 (ix)
	rr	-8 (ix)
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	dec	hl
	ld	a,l
	and	a, -8 (ix)
	ld	l,a
	ld	a,h
	and	a, -7 (ix)
	or	a,l
	jr	NZ,00116$
;pff.c:486: clst = get_fat(dj->clust);		/* Get next cluster */
	push	bc
	push	de
	call	_get_fat
	pop	af
	pop	af
	ld	c,l
	ld	b,h
;pff.c:487: if (clst <= 1) return FR_DISK_ERR;
	ld	a,#0x01
	cp	a, c
	ld	a,#0x00
	sbc	a, b
	ld	a,#0x00
	sbc	a, e
	ld	a,#0x00
	sbc	a, d
	jr	C,00107$
	ld	l,#0x01
	jr	00117$
00107$:
;pff.c:488: if (clst >= fs->n_fatent)		/* When it reached end of dynamic table */
	push	hl
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	push	hl
	pop	iy
	pop	hl
	ld	a,6 (iy)
	ld	-4 (ix),a
	ld	a,7 (iy)
	ld	-3 (ix),a
	ld	a,8 (iy)
	ld	-2 (ix),a
	ld	a,9 (iy)
	ld	-1 (ix),a
	ld	a,c
	sub	a, -4 (ix)
	ld	a,b
	sbc	a, -3 (ix)
	ld	a,e
	sbc	a, -2 (ix)
	ld	a,d
	sbc	a, -1 (ix)
	jr	C,00109$
;pff.c:489: return FR_NO_FILE;			/* Report EOT */
	ld	l,#0x03
	jr	00117$
00109$:
;pff.c:490: dj->clust = clst;				/* Initialize data for new cluster */
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
;pff.c:491: dj->sect = clust2sect(clst);
	push	de
	push	bc
	call	_clust2sect
	pop	af
	pop	af
	ld	b,l
	ld	c,h
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	ld	(hl),b
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
00116$:
;pff.c:496: dj->index = i;
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	a,-16 (ix)
	ld	(hl),a
	inc	hl
	ld	a,-15 (ix)
	ld	(hl),a
;pff.c:498: return FR_OK;
	ld	l,#0x00
00117$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:509: FRESULT dir_find (
;	---------------------------------
; Function dir_find
; ---------------------------------
_dir_find:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-7
	add	hl,sp
	ld	sp,hl
;pff.c:518: res = dir_rewind(dj);			/* Rewind directory object */
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_dir_rewind
	pop	af
;pff.c:519: if (res != FR_OK) return res;
	ld	a,l
	or	a, a
;pff.c:521: do {
	jp	NZ,00113$
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	-2 (ix),c
	ld	-1 (ix),b
00110$:
;pff.c:522: res = disk_readp(dir, dj->sect, (dj->index % 16) * 32, 32)	/* Read an entry */
	ld	l, c
	ld	h, b
	ld	d,(hl)
	inc	hl
	ld	h,(hl)
	ld	a,d
	and	a, #0x0F
	ld	l,a
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	a,(hl)
	ld	-6 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-5 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	push	bc
	ld	hl,#0x0020
	push	hl
	push	de
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	pop	bc
	or	a, a
	jr	Z,00115$
;pff.c:523: ? FR_DISK_ERR : FR_OK;
	ld	a,#0x01
	jr	00116$
00115$:
	ld	a,#0x00
00116$:
;pff.c:524: if (res != FR_OK) break;
	ld	-7 (ix), a
	or	a, a
	jr	NZ,00112$
;pff.c:525: c = dir[DIR_Name];	/* First character */
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	a,(hl)
;pff.c:526: if (c == 0) { res = FR_NO_FILE; break; }	/* Reached to end of table */
	or	a, a
	jr	NZ,00106$
	ld	-7 (ix),#0x03
	jr	00112$
00106$:
;pff.c:527: if (!(dir[DIR_Attr] & AM_VOL) && !mem_cmp(dir, dj->fn, 11)) /* Is it a valid entry? */
	ld	de, #0x000B
	add	hl, de
	bit	3,(hl)
	jr	NZ,00108$
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	de
	pop	iy
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	bc
	ld	de,#0x000B
	push	de
	push	iy
	push	hl
	call	_mem_cmp
	pop	af
	pop	af
	pop	af
	pop	bc
	ld	a,h
	or	a,l
	jr	Z,00112$
;pff.c:528: break;
00108$:
;pff.c:529: res = dir_next(dj);					/* Next entry */
	push	bc
	push	bc
	call	_dir_next
	pop	af
	pop	bc
;pff.c:530: } while (res == FR_OK);
	ld	-7 (ix), l
	ld	a, l
	or	a, a
	jp	Z,00110$
00112$:
;pff.c:532: return res;
	ld	l,-7 (ix)
00113$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:580: FRESULT create_name (
;	---------------------------------
; Function create_name
; ---------------------------------
_create_name:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-7
	add	hl,sp
	ld	sp,hl
;pff.c:594: sfn = dj->fn;
	ld	l,4 (ix)
	ld	h,5 (ix)
	inc	hl
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;pff.c:595: mem_set(sfn, ' ', 11);
	ld	l, c
	ld	h, b
	push	bc
	ld	de,#0x000B
	push	de
	ld	de,#0x0020
	push	de
	push	hl
	call	_mem_set
	ld	hl,#6
	add	hl,sp
	ld	sp,hl
	pop	bc
;pff.c:596: si = i = 0; ni = 8;
	ld	e,#0x00
	ld	-4 (ix),#0x08
;pff.c:597: p = *path;
	ld	a,6 (ix)
	ld	-3 (ix),a
	ld	a,7 (ix)
	ld	-2 (ix),a
	ld	l,-3 (ix)
	ld	h,-2 (ix)
	ld	a,(hl)
	ld	-7 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-6 (ix),a
	ld	-5 (ix),#0x00
00116$:
;pff.c:599: c = p[si++];
	ld	h,-5 (ix)
	inc	-5 (ix)
	ld	a,-7 (ix)
	add	a, h
	ld	l,a
	ld	a,-6 (ix)
	adc	a, #0x00
	ld	h,a
	ld	d,(hl)
;pff.c:600: if (c <= ' ' || c == '/') break;	/* Break on end of segment */
	ld	a,#0x20
	sub	a, d
	ld	a,#0x00
	rla
	ld	-1 (ix), a
	or	a, a
	jr	Z,00115$
;pff.c:601: if (c == '.' || i >= ni) {
	ld	a,d
	cp	a,#0x2F
	jr	Z,00115$
	sub	a, #0x2E
	jr	NZ,00151$
	ld	a,#0x01
	jr	00152$
00151$:
	xor	a,a
00152$:
	ld	h,a
	or	a, a
	jr	NZ,00107$
	ld	a,e
	sub	a, -4 (ix)
	jr	C,00111$
00107$:
;pff.c:602: if (ni != 8 || c != '.') break;
	ld	a,-4 (ix)
	sub	a,#0x08
	jr	NZ,00115$
	or	a,h
	jr	Z,00115$
;pff.c:603: i = 8; ni = 11;
	ld	e,#0x08
	ld	-4 (ix),#0x0B
;pff.c:604: continue;
	jr	00116$
;pff.c:618: if (_USE_LCC && IsLower(c)) c -= 0x20;	/* toupper */
00111$:
;pff.c:619: sfn[i++] = c;
	ld	h,e
	inc	e
	ld	l,h
	ld	h,#0x00
	add	hl,bc
	ld	(hl),d
	jr	00116$
00115$:
;pff.c:622: *path = &p[si];						/* Rerurn pointer to the next segment */
	ld	a,-7 (ix)
	add	a, -5 (ix)
	ld	e,a
	ld	a,-6 (ix)
	adc	a, #0x00
	ld	d,a
	ld	l,-3 (ix)
	ld	h,-2 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;pff.c:624: sfn[11] = (c <= ' ') ? 1 : 0;		/* Set last segment flag if end of path */
	ld	hl,#0x000B
	add	hl,bc
	ld	a,-1 (ix)
	or	a, a
	jr	NZ,00119$
	ld	a,#0x01
	jr	00120$
00119$:
	ld	a,#0x00
00120$:
	ld	(hl),a
;pff.c:626: return FR_OK;
	ld	l,#0x00
	ld	sp, ix
	pop	ix
	ret
;pff.c:679: FRESULT follow_path (	/* FR_OK(0): successful, !=0: error code */
;	---------------------------------
; Function follow_path
; ---------------------------------
_follow_path:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;pff.c:688: while (*path == ' ') path++;		/* Strip leading spaces */
	ld	l,8 (ix)
	ld	h,9 (ix)
00101$:
	ld	b,(hl)
	ld	e, l
	ld	d, h
	inc	de
	ld	a,b
	sub	a, #0x20
	jr	NZ,00131$
	ld	l, e
	ld	h, d
	ld	8 (ix),e
	ld	9 (ix),d
	jr	00101$
00131$:
	ld	8 (ix),l
	ld	9 (ix),h
;pff.c:689: if (*path == '/') path++;			/* Strip heading separator if exist */
	ld	a,b
	sub	a, #0x2F
	jr	NZ,00105$
	ld	8 (ix),e
	ld	9 (ix),d
00105$:
;pff.c:690: dj->sclust = 0;						/* Set start directory (always root dir) */
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	hl,#0x0004
	add	hl,bc
	ld	e,l
	ld	d,h
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;pff.c:692: if ((BYTE)*path < ' ') {			/* Null path means the root directory */
	ld	l,8 (ix)
	ld	h,9 (ix)
	ld	a, (hl)
	sub	a, #0x20
	jr	NC,00130$
;pff.c:693: res = dir_rewind(dj);
	push	bc
	call	_dir_rewind
	pop	af
	ld	-9 (ix),l
;pff.c:694: dir[0] = 0;
	ld	l,6 (ix)
	ld	h,7 (ix)
	ld	(hl),#0x00
	jp	00117$
00130$:
	ld	-6 (ix),c
	ld	-5 (ix),b
	ld	a,6 (ix)
	ld	-8 (ix),a
	ld	a,7 (ix)
	ld	-7 (ix),a
00118$:
;pff.c:698: res = create_name(dj, &path);	/* Get a segment */
	ld	hl,#0x0011
	add	hl,sp
	push	bc
	push	de
	push	hl
	push	bc
	call	_create_name
	pop	af
	pop	af
	pop	de
	pop	bc
;pff.c:699: if (res != FR_OK) break;
	ld	-9 (ix), l
	ld	a, l
	or	a, a
	jr	NZ,00117$
;pff.c:700: res = dir_find(dj, dir);		/* Find it */
	push	bc
	push	de
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	push	bc
	call	_dir_find
	pop	af
	pop	af
	pop	de
	pop	bc
;pff.c:701: if (res != FR_OK) break;		/* Could not find the object */
	ld	-9 (ix), l
	ld	a, l
	or	a, a
	jr	NZ,00117$
;pff.c:702: if (dj->fn[11]) break;			/* Last segment match. Function completed. */
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	inc	hl
	inc	hl
	ld	a, (hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	push	bc
	ld	bc, #0x000B
	add	hl, bc
	pop	bc
	ld	a,(hl)
	or	a, a
	jr	NZ,00117$
;pff.c:703: if (!(dir[DIR_Attr] & AM_DIR)) { /* Cannot follow path because it is a file */
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	push	bc
	ld	bc, #0x000B
	add	hl, bc
	pop	bc
	bit	4,(hl)
	jr	NZ,00113$
;pff.c:704: res = FR_NO_FILE; break;
	ld	-9 (ix),#0x03
	jr	00117$
00113$:
;pff.c:706: dj->sclust = get_clust(dir);	/* Follow next */
	push	bc
	push	de
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_get_clust
	pop	af
	ld	-1 (ix),d
	ld	-2 (ix),e
	ld	-3 (ix),h
	ld	-4 (ix),l
	pop	de
	pop	bc
	push	de
	push	bc
	ld	hl, #0x0009
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
	pop	de
	jp	00118$
00117$:
;pff.c:710: return res;
	ld	l,-9 (ix)
	ld	sp, ix
	pop	ix
	ret
;pff.c:721: BYTE check_fs (	/* 0:The FAT boot record, 1:Valid boot record but not an FAT, 2:Not a boot record, 3:Error */
;	---------------------------------
; Function check_fs
; ---------------------------------
_check_fs:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;pff.c:726: if (disk_readp(buf, sect, 510, 2))		/* Read the boot record */
	ld	hl,#0x0002
	push	hl
	ld	hl,#0x01FE
	push	hl
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a, l
	or	a, a
	jr	Z,00102$
;pff.c:727: return 3;
	ld	l,#0x03
	jp	00113$
00102$:
;pff.c:728: if (LD_WORD(buf) != 0xAA55)				/* Check record signature */
	ld	l,4 (ix)
	ld	h,5 (ix)
	inc	hl
	ld	d, (hl)
	ld	e,#0x00
	ld	a,4 (ix)
	ld	-2 (ix),a
	ld	a,5 (ix)
	ld	-1 (ix),a
	pop	hl
	push	hl
	ld	h,(hl)
	ld	l,#0x00
	ld	a,e
	or	a, h
	ld	e,a
	ld	a,d
	or	a, l
	ld	d,a
	ld	a,e
	sub	a, #0x55
	jr	NZ,00139$
	ld	a,d
	sub	a, #0xAA
	jr	Z,00107$
00139$:
;pff.c:729: return 2;
	ld	l,#0x02
	jp	00113$
;pff.c:731: if (!_FS_32ONLY && !disk_readp(buf, sect, BS_FilSysType, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT12/16 */
00107$:
	ld	hl,#0x0002
	push	hl
	ld	l, #0x36
	push	hl
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	pop	de
	push	de
	inc	de
	ld	a,l
	or	a, a
	jr	NZ,00111$
	ld	a,(de)
	ld	b,a
	ld	c,#0x00
	pop	hl
	push	hl
	ld	h,(hl)
	ld	l,#0x00
	ld	a,c
	or	a, h
	ld	c,a
	ld	a,b
	or	a, l
	ld	b,a
	ld	a,c
	sub	a, #0x46
	jr	NZ,00111$
	ld	a,b
;pff.c:732: return 0;
	sub	a,#0x41
	jr	NZ,00111$
	ld	l,a
	jr	00113$
;pff.c:733: if (_FS_FAT32 && !disk_readp(buf, sect, BS_FilSysType32, 2) && LD_WORD(buf) == 0x4146)	/* Check FAT32 */
00111$:
	push	de
	ld	hl,#0x0002
	push	hl
	ld	l, #0x52
	push	hl
	ld	l,8 (ix)
	ld	h,9 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	pop	de
	or	a, a
	jr	NZ,00110$
	ld	a,(de)
	ld	d,a
	ld	e,#0x00
	pop	hl
	push	hl
	ld	h,(hl)
	ld	l,#0x00
	ld	a,e
	or	a, h
	ld	e,a
	ld	a,d
	or	a, l
	ld	d,a
	ld	a,e
	sub	a, #0x46
	jr	NZ,00110$
	ld	a,d
;pff.c:734: return 0;
	sub	a,#0x41
	jr	NZ,00110$
	ld	l,a
	jr	00113$
00110$:
;pff.c:735: return 1;
	ld	l,#0x01
00113$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:753: FRESULT pf_mount (
;	---------------------------------
; Function pf_mount
; ---------------------------------
_pf_mount::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-78
	add	hl,sp
	ld	sp,hl
;pff.c:761: FatFs = 0;
	ld	hl,#0x0000
	ld	(_FatFs),hl
;pff.c:763: if (disk_initialize() & STA_NOINIT)	/* Check if the drive is ready or not */
	call	_disk_initialize
	ld	a,l
	rrca
	jr	NC,00102$
;pff.c:764: return FR_NOT_READY;
	ld	l,#0x02
	jp	00137$
00102$:
;pff.c:767: bsect = 0;
	xor	a, a
	ld	-73 (ix),a
	ld	-72 (ix),a
	ld	-71 (ix),a
	ld	-70 (ix),a
;pff.c:768: fmt = check_fs(buf, bsect);			/* Check sector 0 as an SFD format */
	ld	hl,#0x0009
	add	hl,sp
	ld	-2 (ix),l
	ld	-1 (ix),h
	ex	de,hl
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	push	de
	call	_check_fs
	pop	af
	pop	af
	pop	af
	ld	-3 (ix),l
;pff.c:774: if (buf[4]) {					/* Is the partition existing? */
	ld	a,-2 (ix)
	add	a, #0x04
	ld	-5 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-4 (ix),a
;pff.c:775: bsect = LD_DWORD(&buf[8]);	/* Partition offset in LBA */
	ld	a,-2 (ix)
	add	a, #0x0A
	ld	-9 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-8 (ix),a
	ld	a,-2 (ix)
	add	a, #0x09
	ld	-7 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-6 (ix),a
;pff.c:769: if (fmt == 1) {						/* Not an FAT boot record, it may be FDISK format */
	ld	a,-3 (ix)
	dec	a
	jp	NZ,00109$
;pff.c:771: if (disk_readp(buf, bsect, MBR_Table, 16)) {	/* 1st partition entry */
	ld	a,-2 (ix)
	ld	-11 (ix),a
	ld	a,-1 (ix)
	ld	-10 (ix),a
	ld	hl,#0x0010
	push	hl
	ld	hl,#0x01BE
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	hl,#0x0000
	push	hl
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	push	hl
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	or	a, a
	jr	Z,00106$
;pff.c:772: fmt = 3;
	ld	-3 (ix),#0x03
	jp	00109$
00106$:
;pff.c:774: if (buf[4]) {					/* Is the partition existing? */
	ld	l,-5 (ix)
	ld	h,-4 (ix)
	ld	a,(hl)
	or	a, a
	jp	Z,00109$
;pff.c:775: bsect = LD_DWORD(&buf[8]);	/* Partition offset in LBA */
	ld	a,-2 (ix)
	ld	-11 (ix),a
	ld	a,-1 (ix)
	ld	-10 (ix),a
	ld	a,-2 (ix)
	ld	-13 (ix),a
	ld	a,-1 (ix)
	ld	-12 (ix),a
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	de, #0x000B
	add	hl, de
	ld	a,(hl)
	ld	-13 (ix), a
	ld	-33 (ix),a
	ld	-32 (ix),#0x00
	ld	-31 (ix),#0x00
	ld	-30 (ix),#0x00
	push	af
	pop	af
	ld	b,#0x18
00198$:
	sla	-33 (ix)
	rl	-32 (ix)
	rl	-31 (ix)
	rl	-30 (ix)
	djnz	00198$
	ld	l,-9 (ix)
	ld	h,-8 (ix)
	ld	a,(hl)
	ld	-13 (ix), a
	ld	-17 (ix),a
	ld	-16 (ix),#0x00
	ld	-15 (ix),#0x00
	ld	-14 (ix),#0x00
	push	af
	pop	af
	ld	b,#0x10
00200$:
	sla	-17 (ix)
	rl	-16 (ix)
	rl	-15 (ix)
	rl	-14 (ix)
	djnz	00200$
	ld	a,-17 (ix)
	or	a, -33 (ix)
	ld	-17 (ix),a
	ld	a,-16 (ix)
	or	a, -32 (ix)
	ld	-16 (ix),a
	ld	a,-15 (ix)
	or	a, -31 (ix)
	ld	-15 (ix),a
	ld	a,-14 (ix)
	or	a, -30 (ix)
	ld	-14 (ix),a
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	a,(hl)
	ld	-33 (ix), a
	ld	-33 (ix),a
	ld	-32 (ix),#0x00
	ld	a,-33 (ix)
	ld	-32 (ix),a
	ld	-33 (ix), #0x00
	ld	-33 (ix), #0x00
	ld	a,-32 (ix)
	ld	-32 (ix),a
	ld	-31 (ix),#0x00
	ld	-30 (ix),#0x00
	ld	a,-17 (ix)
	or	a, -33 (ix)
	ld	-17 (ix),a
	ld	a,-16 (ix)
	or	a, -32 (ix)
	ld	-16 (ix),a
	ld	a,-15 (ix)
	or	a, -31 (ix)
	ld	-15 (ix),a
	ld	a,-14 (ix)
	or	a, -30 (ix)
	ld	-14 (ix),a
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	de, #0x0008
	add	hl, de
	ld	a,(hl)
	ld	-33 (ix), a
	ld	-33 (ix),a
	ld	-32 (ix),#0x00
	ld	-31 (ix),#0x00
	ld	-30 (ix),#0x00
	ld	a,-17 (ix)
	or	a, -33 (ix)
	ld	-17 (ix),a
	ld	a,-16 (ix)
	or	a, -32 (ix)
	ld	-16 (ix),a
	ld	a,-15 (ix)
	or	a, -31 (ix)
	ld	-15 (ix),a
	ld	a,-14 (ix)
	or	a, -30 (ix)
	ld	-14 (ix),a
	ld	hl, #5
	add	hl, sp
	ex	de, hl
	ld	hl, #61
	add	hl, sp
	ld	bc, #4
	ldir
;pff.c:776: fmt = check_fs(buf, bsect);	/* Check the partition */
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	ld	l,-71 (ix)
	ld	h,-70 (ix)
	push	hl
	ld	l,-73 (ix)
	ld	h,-72 (ix)
	push	hl
	push	de
	call	_check_fs
	pop	af
	pop	af
	pop	af
	ld	-3 (ix),l
00109$:
;pff.c:780: if (fmt == 3) return FR_DISK_ERR;
	ld	a,-3 (ix)
	sub	a, #0x03
	jr	NZ,00111$
	ld	l,#0x01
	jp	00137$
00111$:
;pff.c:781: if (fmt) return FR_NO_FILESYSTEM;	/* No valid FAT patition is found */
	ld	a,-3 (ix)
	or	a, a
	jr	Z,00113$
	ld	l,#0x06
	jp	00137$
00113$:
;pff.c:784: if (disk_readp(buf, bsect, 13, sizeof (buf))) return FR_DISK_ERR;
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	ld	hl,#0x0024
	push	hl
	ld	l, #0x0D
	push	hl
	ld	l,-71 (ix)
	ld	h,-70 (ix)
	push	hl
	ld	l,-73 (ix)
	ld	h,-72 (ix)
	push	hl
	push	de
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	or	a, a
	jr	Z,00115$
	ld	l,#0x01
	jp	00137$
00115$:
;pff.c:786: fsize = LD_WORD(buf+BPB_FATSz16-13);				/* Number of sectors per FAT */
	ld	l,-9 (ix)
	ld	h,-8 (ix)
	ld	d, (hl)
	ld	e,#0x00
	ld	l,-7 (ix)
	ld	h,-6 (ix)
	ld	l,(hl)
	ld	h,#0x00
	ld	a,e
	or	a, l
	ld	c,a
	ld	a,d
	or	a, h
	ld	b,a
	ld	de,#0x0000
;pff.c:787: if (!fsize) fsize = LD_DWORD(buf+BPB_FATSz32-13);
	ld	a,d
	or	a, e
	or	a, b
	or	a,c
	jp	NZ,00117$
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	bc, #0x001A
	add	hl, bc
	ld	l,(hl)
	ld	h,#0x00
	ld	bc,#0x0000
	push	af
	ld	-17 (ix),l
	ld	-16 (ix),h
	ld	-15 (ix),c
	ld	-14 (ix),b
	pop	af
	ld	a,#0x18
00204$:
	sla	-17 (ix)
	rl	-16 (ix)
	rl	-15 (ix)
	rl	-14 (ix)
	dec	a
	jr	NZ,00204$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	bc, #0x0019
	add	hl, bc
	ld	l,(hl)
	ld	h,#0x00
	ld	bc,#0x0000
	ld	a,#0x10
00206$:
	add	hl, hl
	rl	c
	rl	b
	dec	a
	jr	NZ,00206$
	ld	a,-17 (ix)
	or	a, l
	ld	-17 (ix),a
	ld	a,-16 (ix)
	or	a, h
	ld	-16 (ix),a
	ld	a,-15 (ix)
	or	a, c
	ld	-15 (ix),a
	ld	a,-14 (ix)
	or	a, b
	ld	-14 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	bc, #0x0018
	add	hl, bc
	ld	h, (hl)
	ld	l,#0x00
	ld	bc,#0x0000
	ld	a,-17 (ix)
	or	a, l
	ld	-17 (ix),a
	ld	a,-16 (ix)
	or	a, h
	ld	-16 (ix),a
	ld	a,-15 (ix)
	or	a, c
	ld	-15 (ix),a
	ld	a,-14 (ix)
	or	a, b
	ld	-14 (ix),a
	ex	de,hl
	ld	de, #0x0017
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,-17 (ix)
	or	a, l
	ld	c,a
	ld	a,-16 (ix)
	or	a, h
	ld	b,a
	ld	a,-15 (ix)
	or	a, e
	ld	e,a
	ld	a,-14 (ix)
	or	a, d
	ld	d,a
00117$:
;pff.c:789: fsize *= buf[BPB_NumFATs-13];						/* Number of sectors in FAT area */
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	-17 (ix),a
	ld	-16 (ix),#0x00
	ld	-15 (ix),#0x00
	ld	-14 (ix),#0x00
	ld	l,-15 (ix)
	ld	h,-14 (ix)
	push	hl
	ld	l,-17 (ix)
	ld	h,-16 (ix)
	push	hl
	push	de
	push	bc
	call	__mullong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-77 (ix),l
	ld	-76 (ix),h
	ld	-75 (ix),e
	ld	-74 (ix),d
;pff.c:790: fs->fatbase = bsect + LD_WORD(buf+BPB_RsvdSecCnt-13); /* FAT start sector (lba) */
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	hl,#0x000A
	add	hl,bc
	ld	-17 (ix),l
	ld	-16 (ix),h
	ld	a,-2 (ix)
	add	a, #0x01
	ld	-33 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-32 (ix),a
	ld	a,-2 (ix)
	add	a, #0x02
	ld	-13 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-12 (ix),a
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	l,(hl)
	ld	-10 (ix),l
	ld	-11 (ix),#0x00
	ld	l,-33 (ix)
	ld	h,-32 (ix)
	ld	l,(hl)
	ld	h,#0x00
	ld	a,l
	or	a, -11 (ix)
	ld	l,a
	ld	a,h
	or	a, -10 (ix)
	ld	h,a
	ld	de,#0x0000
	ld	a,-73 (ix)
	add	a, l
	ld	-29 (ix),a
	ld	a,-72 (ix)
	adc	a, h
	ld	-28 (ix),a
	ld	a,-71 (ix)
	adc	a, e
	ld	-27 (ix),a
	ld	a,-70 (ix)
	adc	a, d
	ld	-26 (ix),a
	push	bc
	ld	e,-17 (ix)
	ld	d,-16 (ix)
	ld	hl, #0x0033
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:791: fs->csize = buf[BPB_SecPerClus-13];					/* Number of sectors per cluster */
	ld	hl,#0x0002
	add	hl,bc
	ld	-29 (ix),l
	ld	-28 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	a,(hl)
	ld	l,-29 (ix)
	ld	h,-28 (ix)
	ld	(hl),a
;pff.c:792: fs->n_rootdir = LD_WORD(buf+BPB_RootEntCnt-13);		/* Nmuber of root directory entries */
	ld	hl,#0x0004
	add	hl,bc
	ld	-11 (ix),l
	ld	-10 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0005
	add	hl, de
	ld	d, (hl)
	ld	e,#0x00
	ld	l,-5 (ix)
	ld	h,-4 (ix)
	ld	l,(hl)
	ld	h,#0x00
	ld	a,e
	or	a, l
	ld	e,a
	ld	a,d
	or	a, h
	ld	d,a
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;pff.c:793: tsect = LD_WORD(buf+BPB_TotSec16-13);				/* Number of sectors on the file system */
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	push	de
	pop	iy
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0007
	add	hl, de
	ld	l,(hl)
	ld	-6 (ix),l
	ld	-7 (ix),#0x00
	ld	a, 6 (iy)
	ld	h, #0x00
	or	a, -7 (ix)
	ld	l,a
	ld	a,h
	or	a, -6 (ix)
	ld	h,a
	ld	de,#0x0000
	ld	-25 (ix),l
	ld	-24 (ix),h
	ld	-23 (ix),e
	ld	-22 (ix),d
;pff.c:794: if (!tsect) tsect = LD_DWORD(buf+BPB_TotSec32-13);
	ld	a,d
	or	a, e
	or	a, h
	or	a,l
	jp	NZ,00119$
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	push	de
	pop	iy
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0016
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	push	af
	ld	-21 (ix),l
	ld	-20 (ix),h
	ld	-19 (ix),e
	ld	-18 (ix),d
	pop	af
	ld	a,#0x18
00208$:
	sla	-21 (ix)
	rl	-20 (ix)
	rl	-19 (ix)
	rl	-18 (ix)
	dec	a
	jr	NZ,00208$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0015
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,#0x10
00210$:
	add	hl, hl
	rl	e
	rl	d
	dec	a
	jr	NZ,00210$
	ld	a,-21 (ix)
	or	a, l
	ld	-21 (ix),a
	ld	a,-20 (ix)
	or	a, h
	ld	-20 (ix),a
	ld	a,-19 (ix)
	or	a, e
	ld	-19 (ix),a
	ld	a,-18 (ix)
	or	a, d
	ld	-18 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0014
	add	hl, de
	ld	h, (hl)
	ld	l,#0x00
	ld	de,#0x0000
	ld	a,-21 (ix)
	or	a, l
	ld	-21 (ix),a
	ld	a,-20 (ix)
	or	a, h
	ld	-20 (ix),a
	ld	a,-19 (ix)
	or	a, e
	ld	-19 (ix),a
	ld	a,-18 (ix)
	or	a, d
	ld	-18 (ix),a
	ld	l,19 (iy)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,l
	or	a, -21 (ix)
	ld	l,a
	ld	a,h
	or	a, -20 (ix)
	ld	h,a
	ld	a,e
	or	a, -19 (ix)
	ld	e,a
	ld	a,d
	or	a, -18 (ix)
	ld	d,a
	ld	-25 (ix),l
	ld	-24 (ix),h
	ld	-23 (ix),e
	ld	-22 (ix),d
00119$:
;pff.c:796: - LD_WORD(buf+BPB_RsvdSecCnt-13) - fsize - fs->n_rootdir / 16
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	ld	d,(hl)
	ld	e,#0x00
	ld	l,-33 (ix)
	ld	h,-32 (ix)
	ld	h,(hl)
	ld	l,#0x00
	ld	a,e
	or	a, h
	ld	e,a
	ld	a,d
	or	a, l
	ld	d,a
	ld	hl,#0x0000
	ld	a,-25 (ix)
	sub	a, e
	ld	e,a
	ld	a,-24 (ix)
	sbc	a, d
	ld	d,a
	ld	a,-23 (ix)
	sbc	a, l
	ld	l,a
	ld	a,-22 (ix)
	sbc	a, h
	ld	h,a
	ld	a,e
	sub	a, -77 (ix)
	ld	-21 (ix),a
	ld	a,d
	sbc	a, -76 (ix)
	ld	-20 (ix),a
	ld	a,l
	sbc	a, -75 (ix)
	ld	-19 (ix),a
	ld	a,h
	sbc	a, -74 (ix)
	ld	-18 (ix),a
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	hl,#0x0000
	ld	a,-21 (ix)
	sub	a, e
	ld	-21 (ix),a
	ld	a,-20 (ix)
	sbc	a, d
	ld	-20 (ix),a
	ld	a,-19 (ix)
	sbc	a, h
	ld	-19 (ix),a
	ld	a,-18 (ix)
	sbc	a, l
	ld	-18 (ix),a
;pff.c:797: ) / fs->csize + 2;
	ld	l,-29 (ix)
	ld	h,-28 (ix)
	ld	e,(hl)
	ld	d,#0x00
	ld	hl,#0x0000
	push	bc
	push	hl
	push	de
	ld	l,-19 (ix)
	ld	h,-18 (ix)
	push	hl
	ld	l,-21 (ix)
	ld	h,-20 (ix)
	push	hl
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	pop	bc
	ld	a,l
	add	a, #0x02
	ld	l,a
	ld	a,h
	adc	a, #0x00
	ld	h,a
	ld	a,e
	adc	a, #0x00
	ld	e,a
	ld	a,d
	adc	a, #0x00
	ld	d,a
;pff.c:798: fs->n_fatent = (CLUST)mclst;
	ld	iy,#0x0006
	add	iy, bc
	ld	0 (iy),l
	ld	1 (iy),h
	ld	2 (iy),e
	ld	3 (iy),d
;pff.c:800: fmt = 0;							/* Determine the FAT sub type */
	ld	-78 (ix),#0x00
;pff.c:803: if (_FS_FAT16 && mclst >= 0xFF8 && mclst < 0xFFF7)
	ld	a,l
	sub	a, #0xF7
	ld	a,h
	sbc	a, #0xFF
	ld	a,e
	sbc	a, #0x00
	ld	a,d
	sbc	a, #0x00
	ld	a,#0x00
	rla
	ld	-21 (ix),a
	ld	a,l
	sub	a, #0xF8
	ld	a,h
	sbc	a, #0x0F
	ld	a,e
	sbc	a, #0x00
	ld	a,d
	sbc	a, #0x00
	jr	C,00129$
	ld	a,-21 (ix)
	or	a, a
	jr	Z,00129$
;pff.c:804: fmt = FS_FAT16;
	ld	-78 (ix),#0x02
;pff.c:805: if (_FS_FAT32 && mclst >= 0xFFF7)
00129$:
	ld	a,-21 (ix)
	or	a, a
	jr	NZ,00128$
;pff.c:806: fmt = FS_FAT32;
	ld	-78 (ix),#0x03
00128$:
;pff.c:807: if (!fmt) return FR_NO_FILESYSTEM;
	ld	a,-78 (ix)
	or	a, a
	jr	NZ,00131$
	ld	l,#0x06
	jp	00137$
00131$:
;pff.c:808: fs->fs_type = fmt;
	ld	a,-78 (ix)
	ld	(bc),a
;pff.c:811: fs->dirbase = LD_DWORD(buf+(BPB_RootClus-13));	/* Root directory start cluster */
	ld	hl,#0x000E
	add	hl,bc
	ld	-21 (ix),l
	ld	-20 (ix),h
;pff.c:810: if (_FS_32ONLY || (_FS_FAT32 && fmt == FS_FAT32))
	ld	a,-78 (ix)
	sub	a, #0x03
	jp	NZ,00133$
;pff.c:811: fs->dirbase = LD_DWORD(buf+(BPB_RootClus-13));	/* Root directory start cluster */
	ld	e,-2 (ix)
	ld	d,-1 (ix)
	push	de
	pop	iy
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0022
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	push	af
	ld	-25 (ix),l
	ld	-24 (ix),h
	ld	-23 (ix),e
	ld	-22 (ix),d
	pop	af
	ld	a,#0x18
00214$:
	sla	-25 (ix)
	rl	-24 (ix)
	rl	-23 (ix)
	rl	-22 (ix)
	dec	a
	jr	NZ,00214$
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0021
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,#0x10
00216$:
	add	hl, hl
	rl	e
	rl	d
	dec	a
	jr	NZ,00216$
	ld	a,-25 (ix)
	or	a, l
	ld	-25 (ix),a
	ld	a,-24 (ix)
	or	a, h
	ld	-24 (ix),a
	ld	a,-23 (ix)
	or	a, e
	ld	-23 (ix),a
	ld	a,-22 (ix)
	or	a, d
	ld	-22 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	de, #0x0020
	add	hl, de
	ld	h, (hl)
	ld	l,#0x00
	ld	de,#0x0000
	ld	a,-25 (ix)
	or	a, l
	ld	-25 (ix),a
	ld	a,-24 (ix)
	or	a, h
	ld	-24 (ix),a
	ld	a,-23 (ix)
	or	a, d
	ld	-23 (ix),a
	ld	a,-22 (ix)
	or	a, e
	ld	-22 (ix),a
	ld	l,31 (iy)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,-25 (ix)
	or	a, l
	ld	-25 (ix),a
	ld	a,-24 (ix)
	or	a, h
	ld	-24 (ix),a
	ld	a,-23 (ix)
	or	a, d
	ld	-23 (ix),a
	ld	a,-22 (ix)
	or	a, e
	ld	-22 (ix),a
	push	bc
	ld	e,-21 (ix)
	ld	d,-20 (ix)
	ld	hl, #0x0037
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
	jr	00134$
00133$:
;pff.c:813: fs->dirbase = fs->fatbase + fsize;				/* Root directory start sector (lba) */
	ld	l,-17 (ix)
	ld	h,-16 (ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	h,(hl)
	ld	l,a
	ld	a,d
	add	a, -77 (ix)
	ld	-25 (ix),a
	ld	a,e
	adc	a, -76 (ix)
	ld	-24 (ix),a
	ld	a,h
	adc	a, -75 (ix)
	ld	-23 (ix),a
	ld	a,l
	adc	a, -74 (ix)
	ld	-22 (ix),a
	push	bc
	ld	e,-21 (ix)
	ld	d,-20 (ix)
	ld	hl, #0x0037
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
00134$:
;pff.c:814: fs->database = fs->fatbase + fsize + fs->n_rootdir / 16;	/* Data start sector (lba) */
	ld	iy,#0x0012
	add	iy, bc
	ld	l,-17 (ix)
	ld	h,-16 (ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	ld	a,d
	add	a, -77 (ix)
	ld	-21 (ix),a
	ld	a,e
	adc	a, -76 (ix)
	ld	-20 (ix),a
	ld	a,l
	adc	a, -75 (ix)
	ld	-19 (ix),a
	ld	a,h
	adc	a, -74 (ix)
	ld	-18 (ix),a
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	hl,#0x0000
	ld	a,-21 (ix)
	add	a, e
	ld	e,a
	ld	a,-20 (ix)
	adc	a, d
	ld	d,a
	ld	a,-19 (ix)
	adc	a, l
	ld	l,a
	ld	a,-18 (ix)
	adc	a, h
	ld	h,a
	ld	0 (iy),e
	ld	1 (iy),d
	ld	2 (iy),l
	ld	3 (iy),h
;pff.c:816: fs->flag = 0;
	ld	l, c
	ld	h, b
	inc	hl
	ld	(hl),#0x00
;pff.c:817: FatFs = fs;
	ld	(_FatFs),bc
;pff.c:819: return FR_OK;
	ld	l,#0x00
00137$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:829: FRESULT pf_open (
;	---------------------------------
; Function pf_open
; ---------------------------------
_pf_open::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-74
	add	hl,sp
	ld	sp,hl
;pff.c:836: FATFS *fs = FatFs;
	ld	bc,(_FatFs)
;pff.c:839: if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	ld	a,b
	or	a,c
	jr	NZ,00102$
	ld	l,#0x05
	jp	00108$
00102$:
;pff.c:841: fs->flag = 0;
	ld	hl,#0x0001
	add	hl,bc
	ld	-4 (ix),l
	ld	-3 (ix),h
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#0x00
;pff.c:842: dj.fn = sp;
	ld	hl,#0x0000
	add	hl,sp
	ex	de,hl
	ld	hl,#0x0002
	add	hl,de
	ld	-2 (ix),l
	ld	-1 (ix),h
	ld	hl,#0x0030
	add	hl,sp
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	a,-6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,-5 (ix)
	ld	(hl),a
;pff.c:843: res = follow_path(&dj, dir, path);	/* Follow the file path */
	ld	hl,#0x0010
	add	hl,sp
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	push	de
	pop	iy
	push	bc
	ld	e,4 (ix)
	ld	d,5 (ix)
	push	de
	push	hl
	push	iy
	call	_follow_path
	pop	af
	pop	af
	pop	af
	ld	a,l
	pop	bc
	ld	l,a
;pff.c:844: if (res != FR_OK) return res;		/* Follow failed */
	or	a, a
	jp	NZ,00108$
;pff.c:845: if (!dir[0] || (dir[DIR_Attr] & AM_DIR))	/* It is a directory */
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	a,(hl)
	or	a, a
	jr	Z,00105$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	de, #0x000B
	add	hl, de
	bit	4,(hl)
	jr	Z,00106$
00105$:
;pff.c:846: return FR_NO_FILE;
	ld	l,#0x03
	jp	00108$
00106$:
;pff.c:848: fs->org_clust = get_clust(dir);		/* File start cluster */
	ld	hl,#0x001E
	add	hl,bc
	ld	e,-6 (ix)
	ld	d,-5 (ix)
	push	hl
	push	bc
	push	de
	call	_get_clust
	pop	af
	ld	-7 (ix),d
	ld	-8 (ix),e
	ld	-9 (ix),h
	ld	-10 (ix),l
	pop	bc
	pop	hl
	push	bc
	ex	de,hl
	ld	hl, #0x0042
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:849: fs->fsize = LD_DWORD(dir+DIR_FileSize);	/* File size */
	ld	iy,#0x001A
	add	iy, bc
	ld	a,-6 (ix)
	ld	-10 (ix),a
	ld	a,-5 (ix)
	ld	-9 (ix),a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	de, #0x001F
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	push	af
	ld	-14 (ix),l
	ld	-13 (ix),h
	ld	-12 (ix),d
	ld	-11 (ix),e
	pop	af
	ld	a,#0x18
00123$:
	sla	-14 (ix)
	rl	-13 (ix)
	rl	-12 (ix)
	rl	-11 (ix)
	dec	a
	jr	NZ,00123$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	de, #0x001E
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,#0x10
00125$:
	add	hl, hl
	rl	e
	rl	d
	dec	a
	jr	NZ,00125$
	ld	a,-14 (ix)
	or	a, l
	ld	-14 (ix),a
	ld	a,-13 (ix)
	or	a, h
	ld	-13 (ix),a
	ld	a,-12 (ix)
	or	a, e
	ld	-12 (ix),a
	ld	a,-11 (ix)
	or	a, d
	ld	-11 (ix),a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	de, #0x001D
	add	hl, de
	ld	h, (hl)
	ld	l,#0x00
	ld	de,#0x0000
	ld	a,-14 (ix)
	or	a, l
	ld	-14 (ix),a
	ld	a,-13 (ix)
	or	a, h
	ld	-13 (ix),a
	ld	a,-12 (ix)
	or	a, e
	ld	-12 (ix),a
	ld	a,-11 (ix)
	or	a, d
	ld	-11 (ix),a
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	de, #0x001C
	add	hl, de
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	ld	a,l
	or	a, -14 (ix)
	ld	l,a
	ld	a,h
	or	a, -13 (ix)
	ld	h,a
	ld	a,e
	or	a, -12 (ix)
	ld	e,a
	ld	a,d
	or	a, -11 (ix)
	ld	d,a
	ld	0 (iy),l
	ld	1 (iy),h
	ld	2 (iy),e
	ld	3 (iy),d
;pff.c:850: fs->fptr = 0;						/* File pointer */
	ld	hl,#0x0016
	add	hl,bc
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;pff.c:851: fs->flag = FA_OPENED;
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#0x01
;pff.c:853: return FR_OK;
	ld	l,#0x00
00108$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:864: FRESULT pf_read (
;	---------------------------------
; Function pf_read
; ---------------------------------
_pf_read::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-26
	add	hl,sp
	ld	sp,hl
;pff.c:874: BYTE cs, *rbuff = buff;
	ld	a,4 (ix)
	ld	-26 (ix),a
	ld	a,5 (ix)
	ld	-25 (ix),a
;pff.c:875: FATFS *fs = FatFs;
	ld	bc,(_FatFs)
;pff.c:878: *br = 0;
	ld	a,8 (ix)
	ld	-20 (ix),a
	ld	a,9 (ix)
	ld	-19 (ix),a
	ld	l,-20 (ix)
	ld	h,-19 (ix)
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;pff.c:879: if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	ld	a,b
	or	a,c
	jr	NZ,00102$
	ld	l,#0x05
	jp	00125$
00102$:
;pff.c:880: if (!(fs->flag & FA_OPENED))		/* Check if opened */
	ld	hl,#0x0001
	add	hl,bc
	ld	-8 (ix),l
	ld	-7 (ix),h
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	rrca
	jr	C,00104$
;pff.c:881: return FR_NOT_OPENED;
	ld	l,#0x04
	jp	00125$
00104$:
;pff.c:883: remain = fs->fsize - fs->fptr;
	push	bc
	pop	iy
	ld	a,26 (iy)
	ld	-24 (ix),a
	ld	a,27 (iy)
	ld	-23 (ix),a
	ld	a,28 (iy)
	ld	-22 (ix),a
	ld	a,29 (iy)
	ld	-21 (ix),a
	ld	hl,#0x0016
	add	hl,bc
	ld	-14 (ix),l
	ld	-13 (ix),h
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	l,(hl)
	ld	h,a
	ld	a,-24 (ix)
	sub	a, e
	ld	e,a
	ld	a,-23 (ix)
	sbc	a, d
	ld	d,a
	ld	a,-22 (ix)
	sbc	a, l
	ld	l,a
	ld	a,-21 (ix)
	sbc	a, h
	ld	h,a
;pff.c:884: if (btr > remain) btr = (UINT)remain;			/* Truncate btr by remaining bytes */
	ld	a,6 (ix)
	ld	-24 (ix),a
	ld	a,7 (ix)
	ld	-23 (ix),a
	ld	-22 (ix),#0x00
	ld	-21 (ix),#0x00
	ld	a,e
	sub	a, -24 (ix)
	ld	a,d
	sbc	a, -23 (ix)
	ld	a,l
	sbc	a, -22 (ix)
	ld	a,h
	sbc	a, -21 (ix)
	jr	NC,00141$
	ld	6 (ix),e
	ld	7 (ix),d
;pff.c:886: while (btr)	{									/* Repeat until all data transferred */
00141$:
	ld	hl,#0x0022
	add	hl,bc
	ld	-24 (ix),l
	ld	-23 (ix),h
	ld	-10 (ix),c
	ld	-9 (ix),b
	ld	-12 (ix),c
	ld	-11 (ix),b
	ld	hl,#0x0026
	add	hl,bc
	ld	-6 (ix),l
	ld	-5 (ix),h
00122$:
	ld	a,7 (ix)
	or	a,6 (ix)
	jp	Z,00124$
;pff.c:887: if ((fs->fptr % 512) == 0) {				/* On the sector boundary? */
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,c
	or	a, a
	jp	NZ,00117$
	bit	0, b
	jp	NZ,00117$
;pff.c:888: cs = (BYTE)(fs->fptr / 512 & (fs->csize - 1));	/* Sector offset in the cluster */
	push	af
	ld	-18 (ix),c
	ld	-17 (ix),b
	ld	-16 (ix),e
	ld	-15 (ix),d
	pop	af
	ld	a,#0x09
00185$:
	srl	-15 (ix)
	rr	-16 (ix)
	rr	-17 (ix)
	rr	-18 (ix)
	dec	a
	jr	NZ,00185$
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	inc	hl
	inc	hl
	ld	h,(hl)
	dec	h
	ld	-4 (ix),h
	ld	-3 (ix),#0x00
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
	ld	a,-4 (ix)
	and	a, -18 (ix)
	ld	-4 (ix),a
	ld	a,-3 (ix)
	and	a, -17 (ix)
	ld	-3 (ix),a
	ld	a,-2 (ix)
	and	a, -16 (ix)
	ld	-2 (ix),a
	ld	a,-1 (ix)
	and	a, -15 (ix)
	ld	-1 (ix),a
	ld	a,-4 (ix)
	ld	-4 (ix),a
;pff.c:889: if (!cs) {								/* On the cluster boundary? */
	or	a, a
	jr	NZ,00113$
;pff.c:890: if (fs->fptr == 0)					/* On the top of the file? */
	ld	a,d
	or	a, e
	or	a, b
	or	a,c
	jr	NZ,00108$
;pff.c:891: clst = fs->org_clust;
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	de, #0x001E
	add	hl, de
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	jr	00109$
00108$:
;pff.c:893: clst = get_fat(fs->curr_clust);
	ld	e,-24 (ix)
	ld	d,-23 (ix)
	ld	hl, #0x0008
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	ld	l,-16 (ix)
	ld	h,-15 (ix)
	push	hl
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	push	hl
	call	_get_fat
	pop	af
	pop	af
	ld	c,l
	ld	b,h
00109$:
;pff.c:894: if (clst <= 1) ABORT(FR_DISK_ERR);
	ld	a,#0x01
	cp	a, c
	ld	a,#0x00
	sbc	a, b
	ld	a,#0x00
	sbc	a, e
	ld	a,#0x00
	sbc	a, d
	jr	C,00111$
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x00
	ld	l,#0x01
	jp	00125$
00111$:
;pff.c:895: fs->curr_clust = clst;				/* Update current cluster */
	ld	l,-24 (ix)
	ld	h,-23 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
00113$:
;pff.c:897: sect = clust2sect(fs->curr_clust);		/* Get current sector */
	ld	l,-24 (ix)
	ld	h,-23 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	bc
	push	de
	call	_clust2sect
	pop	af
	pop	af
	ld	-18 (ix),l
	ld	-17 (ix),h
	ld	-16 (ix),e
	ld	-15 (ix),d
;pff.c:898: if (!sect) ABORT(FR_DISK_ERR);
	ld	a,d
	or	a, e
	or	a, h
	or	a,l
	jr	NZ,00115$
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x00
	ld	l,#0x01
	jp	00125$
00115$:
;pff.c:899: fs->dsect = sect + cs;
	ld	e,-4 (ix)
	ld	d,#0x00
	ld	hl,#0x0000
	ld	a,-18 (ix)
	add	a, e
	ld	e,a
	ld	a,-17 (ix)
	adc	a, d
	ld	d,a
	ld	a,-16 (ix)
	adc	a, l
	ld	b,a
	ld	a,-15 (ix)
	adc	a, h
	ld	c,a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),c
00117$:
;pff.c:883: remain = fs->fsize - fs->fptr;
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	h,(hl)
;pff.c:901: rcnt = 512 - (UINT)fs->fptr % 512;			/* Get partial sector data from sector buffer */
	ld	a,b
	and	a, #0x01
	ld	b,a
	xor	a, a
	sub	a, c
	ld	e,a
	ld	a,#0x02
	sbc	a, b
	ld	d,a
;pff.c:902: if (rcnt > btr) rcnt = btr;
	ld	a,6 (ix)
	sub	a, e
	ld	a,7 (ix)
	sbc	a, d
	jr	NC,00119$
	ld	e,6 (ix)
	ld	d,7 (ix)
00119$:
;pff.c:903: dr = disk_readp(!buff ? 0 : rbuff, fs->dsect, (UINT)fs->fptr % 512, rcnt);
	push	de
	push	bc
	ld	e,-6 (ix)
	ld	d,-5 (ix)
	ld	hl, #0x001A
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	pop	de
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	NZ,00127$
	ld	iy,#0x0000
	jr	00128$
00127$:
	pop	iy
	push	iy
00128$:
	push	de
	push	de
	push	bc
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	push	iy
	call	_disk_readp
	ld	iy,#10
	add	iy,sp
	ld	sp,iy
	ld	a,l
	pop	de
;pff.c:904: if (dr) ABORT(FR_DISK_ERR);
	or	a, a
	jr	Z,00121$
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x00
	ld	l,#0x01
	jr	00125$
00121$:
;pff.c:905: fs->fptr += rcnt; rbuff += rcnt;			/* Update pointers and counters */
	push	de
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x0018
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	de
	ld	h,e
	ld	l,d
	ld	bc,#0x0000
	ld	a,-4 (ix)
	add	a, h
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, l
	ld	-3 (ix),a
	ld	a,-2 (ix)
	adc	a, b
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, c
	ld	-1 (ix),a
	push	de
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x0018
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	de
	ld	a,-26 (ix)
	add	a, e
	ld	-26 (ix),a
	ld	a,-25 (ix)
	adc	a, d
	ld	-25 (ix),a
;pff.c:906: btr -= rcnt; *br += rcnt;
	ld	a,6 (ix)
	sub	a, e
	ld	6 (ix),a
	ld	a,7 (ix)
	sbc	a, d
	ld	7 (ix),a
	ld	l,-20 (ix)
	ld	h,-19 (ix)
	ld	a, (hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	add	hl,de
	ex	de,hl
	ld	l,-20 (ix)
	ld	h,-19 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
	jp	00122$
00124$:
;pff.c:909: return FR_OK;
	ld	l,#0x00
00125$:
	ld	sp, ix
	pop	ix
	ret
;pff.c:989: FRESULT pf_lseek (
;	---------------------------------
; Function pf_lseek
; ---------------------------------
_pf_lseek::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-30
	add	hl,sp
	ld	sp,hl
;pff.c:995: FATFS *fs = FatFs;
	ld	bc,(_FatFs)
;pff.c:998: if (!fs) return FR_NOT_ENABLED;		/* Check file system */
	ld	a,b
	or	a,c
	jr	NZ,00102$
	ld	l,#0x05
	jp	00121$
00102$:
;pff.c:999: if (!(fs->flag & FA_OPENED))		/* Check if opened */
	ld	hl,#0x0001
	add	hl,bc
	ld	-8 (ix),l
	ld	-7 (ix),h
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	rrca
	jr	C,00104$
;pff.c:1000: return FR_NOT_OPENED;
	ld	l,#0x04
	jp	00121$
00104$:
;pff.c:1002: if (ofs > fs->fsize) ofs = fs->fsize;	/* Clip offset with the file size */
	push	bc
	pop	iy
	ld	a,26 (iy)
	ld	-14 (ix),a
	ld	a,27 (iy)
	ld	-13 (ix),a
	ld	a,28 (iy)
	ld	-12 (ix),a
	ld	a,29 (iy)
	ld	-11 (ix),a
	ld	a,-14 (ix)
	sub	a, 4 (ix)
	ld	a,-13 (ix)
	sbc	a, 5 (ix)
	ld	a,-12 (ix)
	sbc	a, 6 (ix)
	ld	a,-11 (ix)
	sbc	a, 7 (ix)
	jr	NC,00106$
	ld	a,-14 (ix)
	ld	4 (ix),a
	ld	a,-13 (ix)
	ld	5 (ix),a
	ld	a,-12 (ix)
	ld	6 (ix),a
	ld	a,-11 (ix)
	ld	7 (ix),a
00106$:
;pff.c:1003: ifptr = fs->fptr;
	ld	hl,#0x0016
	add	hl,bc
	ld	-14 (ix),l
	ld	-13 (ix),h
	push	bc
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x000A
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:1004: fs->fptr = 0;
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;pff.c:1005: if (ofs > 0) {
	ld	a,7 (ix)
	or	a, 6 (ix)
	or	a, 5 (ix)
	or	a,4 (ix)
	jp	Z,00120$
;pff.c:1006: bcs = (DWORD)fs->csize * 512;	/* Cluster size (byte) */
	ld	hl,#0x0002
	add	hl,bc
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	l,(hl)
	ld	h,#0x00
	ld	de,#0x0000
	push	af
	ld	-30 (ix),l
	ld	-29 (ix),h
	ld	-28 (ix),e
	ld	-27 (ix),d
	pop	af
	ld	a,#0x09
00165$:
	sla	-30 (ix)
	rl	-29 (ix)
	rl	-28 (ix)
	rl	-27 (ix)
	dec	a
	jr	NZ,00165$
;pff.c:1011: clst = fs->curr_clust;
	ld	hl,#0x0022
	add	hl,bc
	ld	-10 (ix),l
	ld	-9 (ix),h
;pff.c:1007: if (ifptr > 0 &&
	ld	a,-19 (ix)
	or	a, -20 (ix)
	or	a, -21 (ix)
	or	a,-22 (ix)
	jp	Z,00108$
;pff.c:1008: (ofs - 1) / bcs >= (ifptr - 1) / bcs) {	/* When seek to same or following cluster, */
	ld	a,4 (ix)
	add	a,#0xFF
	ld	-18 (ix),a
	ld	a,5 (ix)
	adc	a,#0xFF
	ld	-17 (ix),a
	ld	a,6 (ix)
	adc	a,#0xFF
	ld	-16 (ix),a
	ld	a,7 (ix)
	adc	a,#0xFF
	ld	-15 (ix),a
	push	bc
	ld	l,-28 (ix)
	ld	h,-27 (ix)
	push	hl
	ld	l,-30 (ix)
	ld	h,-29 (ix)
	push	hl
	ld	l,-16 (ix)
	ld	h,-15 (ix)
	push	hl
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	push	hl
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	ld	-15 (ix),d
	ld	-16 (ix),e
	ld	-17 (ix),h
	ld	-18 (ix),l
	pop	bc
	ld	a,-22 (ix)
	add	a,#0xFF
	ld	-4 (ix),a
	ld	a,-21 (ix)
	adc	a,#0xFF
	ld	-3 (ix),a
	ld	a,-20 (ix)
	adc	a,#0xFF
	ld	-2 (ix),a
	ld	a,-19 (ix)
	adc	a,#0xFF
	ld	-1 (ix),a
	push	bc
	ld	l,-28 (ix)
	ld	h,-27 (ix)
	push	hl
	ld	l,-30 (ix)
	ld	h,-29 (ix)
	push	hl
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	push	hl
	call	__divulong
	pop	af
	pop	af
	pop	af
	pop	af
	pop	bc
	ld	a,-18 (ix)
	sub	a, l
	ld	a,-17 (ix)
	sbc	a, h
	ld	a,-16 (ix)
	sbc	a, e
	ld	a,-15 (ix)
	sbc	a, d
	jp	C,00108$
;pff.c:1009: fs->fptr = (ifptr - 1) & ~(bcs - 1);	/* start from the current cluster */
	ld	a,-30 (ix)
	add	a,#0xFF
	ld	-18 (ix),a
	ld	a,-29 (ix)
	adc	a,#0xFF
	ld	-17 (ix),a
	ld	a,-28 (ix)
	adc	a,#0xFF
	ld	-16 (ix),a
	ld	a,-27 (ix)
	adc	a,#0xFF
	ld	-15 (ix),a
	ld	a,-18 (ix)
	cpl
	ld	-18 (ix),a
	ld	a,-17 (ix)
	cpl
	ld	-17 (ix),a
	ld	a,-16 (ix)
	cpl
	ld	-16 (ix),a
	ld	a,-15 (ix)
	cpl
	ld	-15 (ix),a
	ld	a,-4 (ix)
	and	a, -18 (ix)
	ld	-4 (ix),a
	ld	a,-3 (ix)
	and	a, -17 (ix)
	ld	-3 (ix),a
	ld	a,-2 (ix)
	and	a, -16 (ix)
	ld	-2 (ix),a
	ld	a,-1 (ix)
	and	a, -15 (ix)
	ld	-1 (ix),a
	push	bc
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x001C
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:1010: ofs -= fs->fptr;
	ld	a,4 (ix)
	sub	a, -4 (ix)
	ld	4 (ix),a
	ld	a,5 (ix)
	sbc	a, -3 (ix)
	ld	5 (ix),a
	ld	a,6 (ix)
	sbc	a, -2 (ix)
	ld	6 (ix),a
	ld	a,7 (ix)
	sbc	a, -1 (ix)
	ld	7 (ix),a
;pff.c:1011: clst = fs->curr_clust;
	push	bc
	ld	e,-10 (ix)
	ld	d,-9 (ix)
	ld	hl, #0x0006
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	jr	00131$
00108$:
;pff.c:1013: clst = fs->org_clust;			/* start from the first cluster */
	push	bc
	pop	iy
	ld	a,30 (iy)
	ld	-26 (ix),a
	ld	a,31 (iy)
	ld	-25 (ix),a
	ld	a,32 (iy)
	ld	-24 (ix),a
	ld	a,33 (iy)
	ld	-23 (ix),a
;pff.c:1014: fs->curr_clust = clst;
	push	bc
	ld	e,-10 (ix)
	ld	d,-9 (ix)
	ld	hl, #0x0006
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:1016: while (ofs > bcs) {				/* Cluster following loop */
00131$:
	ld	-4 (ix),c
	ld	-3 (ix),b
00114$:
	ld	a,-30 (ix)
	sub	a, 4 (ix)
	ld	a,-29 (ix)
	sbc	a, 5 (ix)
	ld	a,-28 (ix)
	sbc	a, 6 (ix)
	ld	a,-27 (ix)
	sbc	a, 7 (ix)
	jp	NC,00116$
;pff.c:1017: clst = get_fat(clst);		/* Follow cluster chain */
	push	bc
	ld	l,-24 (ix)
	ld	h,-23 (ix)
	push	hl
	ld	l,-26 (ix)
	ld	h,-25 (ix)
	push	hl
	call	_get_fat
	pop	af
	pop	af
	pop	bc
	ld	-26 (ix),l
	ld	-25 (ix),h
	ld	-24 (ix),e
	ld	-23 (ix),d
;pff.c:1018: if (clst <= 1 || clst >= fs->n_fatent) ABORT(FR_DISK_ERR);
	ld	a,#0x01
	cp	a, -26 (ix)
	ld	a,#0x00
	sbc	a, -25 (ix)
	ld	a,#0x00
	sbc	a, -24 (ix)
	ld	a,#0x00
	sbc	a, -23 (ix)
	jr	NC,00111$
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	de, #0x0006
	add	hl, de
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	h,(hl)
	ld	l,a
	ld	a,-26 (ix)
	sub	a, d
	ld	a,-25 (ix)
	sbc	a, e
	ld	a,-24 (ix)
	sbc	a, h
	ld	a,-23 (ix)
	sbc	a, l
	jr	C,00112$
00111$:
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x00
	ld	l,#0x01
	jp	00121$
00112$:
;pff.c:1019: fs->curr_clust = clst;
	push	bc
	ld	e,-10 (ix)
	ld	d,-9 (ix)
	ld	hl, #0x0006
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:1020: fs->fptr += bcs;
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	ld	h,(hl)
	ld	l,a
	ld	a,d
	add	a, -30 (ix)
	ld	-18 (ix),a
	ld	a,e
	adc	a, -29 (ix)
	ld	-17 (ix),a
	ld	a,h
	adc	a, -28 (ix)
	ld	-16 (ix),a
	ld	a,l
	adc	a, -27 (ix)
	ld	-15 (ix),a
	push	bc
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x000E
	add	hl, sp
	ld	bc, #0x0004
	ldir
	pop	bc
;pff.c:1021: ofs -= bcs;
	ld	a,4 (ix)
	sub	a, -30 (ix)
	ld	4 (ix),a
	ld	a,5 (ix)
	sbc	a, -29 (ix)
	ld	5 (ix),a
	ld	a,6 (ix)
	sbc	a, -28 (ix)
	ld	6 (ix),a
	ld	a,7 (ix)
	sbc	a, -27 (ix)
	ld	7 (ix),a
	jp	00114$
00116$:
;pff.c:1023: fs->fptr += ofs;
	push	bc
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x001C
	add	hl, sp
	ex	de, hl
	ld	bc, #0x0004
	ldir
	pop	bc
	ld	a,-4 (ix)
	add	a, 4 (ix)
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, 5 (ix)
	ld	-3 (ix),a
	ld	a,-2 (ix)
	adc	a, 6 (ix)
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, 7 (ix)
	ld	-1 (ix),a
	push	bc
	ld	e,-14 (ix)
	ld	d,-13 (ix)
	ld	hl, #0x001C
	add	hl, sp
	ld	bc, #0x0004
	ldir
	ld	l,-24 (ix)
	ld	h,-23 (ix)
	push	hl
	ld	l,-26 (ix)
	ld	h,-25 (ix)
	push	hl
	call	_clust2sect
	pop	af
	pop	af
	pop	bc
	ld	-4 (ix),l
	ld	-3 (ix),h
	ld	-2 (ix),e
	ld	-1 (ix),d
;pff.c:1025: if (!sect) ABORT(FR_DISK_ERR);
	ld	a,d
	or	a, e
	or	a, h
	or	a,l
	jr	NZ,00118$
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),#0x00
	ld	l,#0x01
	jr	00121$
00118$:
;pff.c:1026: fs->dsect = sect + (fs->fptr / 512 & (fs->csize - 1));
	ld	hl,#0x0026
	add	hl,bc
	ld	-18 (ix),l
	ld	-17 (ix),h
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	ld	a,#0x09
00167$:
	srl	b
	rr	c
	rr	d
	rr	e
	dec	a
	jr	NZ,00167$
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	l,(hl)
	ld	h,#0x00
	dec	hl
	ld	-14 (ix),l
	ld	-13 (ix),h
	ld	a,h
	rla
	sbc	a, a
	ld	-12 (ix),a
	ld	-11 (ix),a
	ld	a,e
	and	a, -14 (ix)
	ld	l,a
	ld	a,d
	and	a, -13 (ix)
	ld	h,a
	ld	a,c
	and	a, -12 (ix)
	ld	e,a
	ld	a,b
	and	a, -11 (ix)
	ld	d,a
	ld	a,-4 (ix)
	add	a, l
	ld	c,a
	ld	a,-3 (ix)
	adc	a, h
	ld	b,a
	ld	a,-2 (ix)
	adc	a, e
	ld	e,a
	ld	a,-1 (ix)
	adc	a, d
	ld	d,a
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
00120$:
;pff.c:1029: return FR_OK;
	ld	l,#0x00
00121$:
	ld	sp, ix
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)

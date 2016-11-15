;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Thu Nov 10 14:41:07 2016
;--------------------------------------------------------
	.module widgets
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _init_widget
	.globl _text_hex
	.globl _text_char
	.globl _strlen
	.globl _malloc
	.globl _isInLayout
	.globl _widget_redraw
	.globl _widget_event
	.globl _new_spinner
	.globl _spinner_setMin
	.globl _spinner_setMax
	.globl _spinner_incValue
	.globl _spinner_decValue
	.globl _spinner_redraw
	.globl _new_checkbox
	.globl _checkbox_setValue
	.globl _checkbox_changeValue
	.globl _checkbox_redraw
	.globl _new_button
	.globl _button_redraw
	.globl _draw_label
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
;widgets.c:8: unsigned char isInLayout(T_Layout *layout, int x, int y) {
;	---------------------------------
; Function isInLayout
; ---------------------------------
_isInLayout::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;widgets.c:9: unsigned char lx = x >> 2;
	ld	l,6 (ix)
	ld	h,7 (ix)
	sra	h
	rr	l
	sra	h
	rr	l
	ld	-1 (ix),l
;widgets.c:10: unsigned char ly = y >> 3;
	ld	l,8 (ix)
	ld	h,9 (ix)
	sra	h
	rr	l
	sra	h
	rr	l
	sra	h
	rr	l
	ld	-2 (ix),l
;widgets.c:12: if (	lx >= layout->x &&
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	a,(de)
	ld	c,a
	ld	a,-1 (ix)
	sub	a, c
	jr	C,00102$
;widgets.c:13: lx < layout->x + layout->w &&
	ld	b,#0x00
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	add	hl,bc
	ld	b,-1 (ix)
	ld	c,#0x00
	ld	a,b
	sub	a, l
	ld	a,c
	sbc	a, h
	jp	PO, 00124$
	xor	a, #0x80
00124$:
	jp	P,00102$
;widgets.c:14: ly >= layout->y &&
	ld	l, e
	ld	h, d
	inc	hl
	ld	c,(hl)
	ld	a,-2 (ix)
	sub	a, c
	jr	C,00102$
;widgets.c:15: ly < layout->y + layout->h) {
	ld	b,#0x00
	ex	de,hl
	inc	hl
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	add	hl,bc
	ld	e,-2 (ix)
	ld	d,#0x00
	ld	a,e
	sub	a, l
	ld	a,d
	sbc	a, h
	jp	PO, 00125$
	xor	a, #0x80
00125$:
	jp	P,00102$
;widgets.c:16: return 1;
	ld	l,#0x01
	jr	00106$
00102$:
;widgets.c:18: return 0;
	ld	l,#0x00
00106$:
	ld	sp, ix
	pop	ix
	ret
;widgets.c:21: void widget_redraw(T_Widget *widget) {
;	---------------------------------
; Function widget_redraw
; ---------------------------------
_widget_redraw::
;widgets.c:23: if (widget != NULL)
	ld	iy,#2
	add	iy,sp
	ld	a,1 (iy)
	or	a,0 (iy)
	ret	Z
;widgets.c:24: switch(widget->type) {
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	e,(hl)
	ld	a,#0x02
	sub	a, e
	ret	C
	ld	d,#0x00
	ld	hl,#00118$
	add	hl,de
	add	hl,de
;widgets.c:25: case SPINNER:
	jp	(hl)
00118$:
	jr	00101$
	jr	00102$
	jr	00103$
00101$:
;widgets.c:26: spinner_redraw((T_Spinner *)widget);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_spinner_redraw
	pop	af
;widgets.c:27: break;
	ret
;widgets.c:28: case CHECKBOX:
00102$:
;widgets.c:29: checkbox_redraw((T_Checkbox *)widget);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_checkbox_redraw
	pop	af
;widgets.c:30: break;
	ret
;widgets.c:31: case BUTTON:
00103$:
;widgets.c:32: button_redraw((T_Button *)widget);
	pop	bc
	pop	hl
	push	hl
	push	bc
	push	hl
	call	_button_redraw
	pop	af
;widgets.c:36: }
	ret
;widgets.c:39: void widget_event(T_Widget *widget, E_Event event) {
;	---------------------------------
; Function widget_event
; ---------------------------------
_widget_event::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:41: if (widget != NULL) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00114$
;widgets.c:42: switch(widget->type) {
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	a,(bc)
	ld	h,a
	or	a, a
	jr	Z,00101$
	dec	h
	jr	Z,00107$
	jr	00109$
;widgets.c:43: case SPINNER:
00101$:
;widgets.c:45: spinner_incValue((T_Spinner *)widget);
	ld	l,4 (ix)
	ld	h,5 (ix)
;widgets.c:44: if (event == EVENT_LEFT_CLICK)
	ld	a,6 (ix)
	or	a, a
	jr	NZ,00105$
;widgets.c:45: spinner_incValue((T_Spinner *)widget);
	push	bc
	push	hl
	call	_spinner_incValue
	pop	af
	pop	bc
	jr	00109$
00105$:
;widgets.c:46: else if (event == EVENT_RIGHT_CLICK)
	ld	a,6 (ix)
	dec	a
	jr	NZ,00109$
;widgets.c:47: spinner_decValue((T_Spinner *)widget);
	push	bc
	push	hl
	call	_spinner_decValue
	pop	af
	pop	bc
;widgets.c:48: break;
	jr	00109$
;widgets.c:49: case CHECKBOX:
00107$:
;widgets.c:50: checkbox_changeValue((T_Checkbox *)widget);
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	bc
	push	hl
	call	_checkbox_changeValue
	pop	af
	pop	bc
;widgets.c:54: }
00109$:
;widgets.c:55: if (widget->callback != NULL)
	push	bc
	pop	iy
	ld	l,6 (iy)
	ld	h,7 (iy)
	ld	a,h
	or	a,l
	jr	Z,00114$
;widgets.c:56: widget->callback(widget);
	push	bc
	call	___sdcc_call_hl
	pop	af
00114$:
	pop	ix
	ret
;widgets.c:60: void init_widget(T_Widget *widget, unsigned char type) {
;	---------------------------------
; Function init_widget
; ---------------------------------
_init_widget::
;widgets.c:62: widget->type = type;
	pop	bc
	pop	de
	push	de
	push	bc
	ld	hl, #4+0
	add	hl, sp
	ld	a, (hl)
	ld	(de),a
;widgets.c:63: widget->layout.x = 0;
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x00
;widgets.c:64: widget->layout.y = 0;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	(hl),#0x00
;widgets.c:65: widget->layout.w = 2;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x02
;widgets.c:66: widget->layout.h = 1;
	ld	hl,#0x0004
	add	hl,de
	ld	(hl),#0x01
;widgets.c:67: widget->callback = NULL;
	ld	hl,#0x0006
	add	hl,de
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;widgets.c:68: widget->user_data = NULL;
	ld	hl,#0x0008
	add	hl,de
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;widgets.c:69: widget->dirty = 0;
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x00
	ret
;widgets.c:72: T_Spinner *new_spinner(unsigned char x, unsigned char y) {
;	---------------------------------
; Function new_spinner
; ---------------------------------
_new_spinner::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:74: T_Spinner *spinner = (T_Spinner *) malloc(sizeof(T_Spinner));
	ld	hl,#0x000D
	push	hl
	call	_malloc
	pop	af
	ex	de,hl
;widgets.c:76: init_widget(&(spinner->widget), SPINNER);
	push	de
	xor	a, a
	push	af
	inc	sp
	push	de
	call	_init_widget
	pop	af
	inc	sp
	pop	de
;widgets.c:77: spinner->widget.layout.x = x;
	ld	c, e
	ld	b, d
	inc	bc
	ld	a,4 (ix)
	ld	(bc),a
;widgets.c:78: spinner->widget.layout.y = y;
	ld	l, c
	ld	h, b
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;widgets.c:79: spinner->widget.layout.w = 2;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x02
;widgets.c:80: spinner->widget.layout.h = 1;
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x01
;widgets.c:82: spinner->min = 0;
	ld	hl,#0x000A
	add	hl,de
	ld	(hl),#0x00
;widgets.c:83: spinner->max = 255;
	ld	hl,#0x000B
	add	hl,de
	ld	(hl),#0xFF
;widgets.c:84: spinner->value = 0;
	ld	hl,#0x000C
	add	hl,de
	ld	(hl),#0x00
;widgets.c:86: return spinner;
	ex	de,hl
	pop	ix
	ret
;widgets.c:89: void spinner_setMin(T_Spinner *spinner, unsigned char min) {
;	---------------------------------
; Function spinner_setMin
; ---------------------------------
_spinner_setMin::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;widgets.c:91: if (spinner != NULL && min < spinner->max) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00106$
	ld	c,4 (ix)
	ld	b,5 (ix)
	push	bc
	pop	iy
	ld	h,11 (iy)
	ld	a,6 (ix)
	sub	a, h
	jr	NC,00106$
;widgets.c:92: spinner->min = min;
	ld	iy,#0x000A
	add	iy, bc
	ld	a,6 (ix)
	ld	0 (iy), a
;widgets.c:93: if (spinner->value < spinner->min) {
	ld	hl,#0x000C
	add	hl,bc
	ex	de,hl
	ld	a,(de)
	ld	-1 (ix),a
	ld	a, 0 (iy)
	ld	-2 (ix),a
	ld	a,-1 (ix)
	sub	a, 6 (ix)
	jr	NC,00102$
;widgets.c:94: spinner->value = spinner->min;
	ld	a,-2 (ix)
	ld	(de),a
00102$:
;widgets.c:96: spinner->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x01
00106$:
	ld	sp, ix
	pop	ix
	ret
;widgets.c:100: void spinner_setMax(T_Spinner *spinner, unsigned char max) {
;	---------------------------------
; Function spinner_setMax
; ---------------------------------
_spinner_setMax::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;widgets.c:102: if (spinner != NULL && max > spinner->min) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00106$
	ld	c,4 (ix)
	ld	b,5 (ix)
	push	bc
	pop	iy
	ld	a, 10 (iy)
	sub	a, 6 (ix)
	jr	NC,00106$
;widgets.c:103: spinner->max = max;
	ld	iy,#0x000B
	add	iy, bc
	ld	a,6 (ix)
	ld	0 (iy), a
;widgets.c:104: if (spinner->value > spinner->max) {
	ld	hl,#0x000C
	add	hl,bc
	ex	de,hl
	ld	a,(de)
	ld	-2 (ix),a
	ld	a, 0 (iy)
	ld	-1 (ix),a
	ld	a,6 (ix)
	sub	a, -2 (ix)
	jr	NC,00102$
;widgets.c:105: spinner->value = spinner->max;
	ld	a,-1 (ix)
	ld	(de),a
00102$:
;widgets.c:107: spinner->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x01
00106$:
	ld	sp, ix
	pop	ix
	ret
;widgets.c:111: void spinner_incValue(T_Spinner *spinner) {
;	---------------------------------
; Function spinner_incValue
; ---------------------------------
_spinner_incValue::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:113: if (spinner != NULL && spinner->value < spinner->max) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00104$
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	iy,#0x000C
	add	iy, de
	ld	c, 0 (iy)
	ld	l, e
	ld	h, d
	push	bc
	ld	bc, #0x000B
	add	hl, bc
	pop	bc
	ld	l,(hl)
	ld	a,c
	sub	a, l
	jr	NC,00104$
;widgets.c:114: spinner->value ++;
	inc	c
	ld	0 (iy), c
;widgets.c:115: spinner->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x01
00104$:
	pop	ix
	ret
;widgets.c:119: void spinner_decValue(T_Spinner *spinner) {
;	---------------------------------
; Function spinner_decValue
; ---------------------------------
_spinner_decValue::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:121: if (spinner != NULL && spinner->value > spinner->min) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00104$
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	iy,#0x000C
	add	iy, de
	ld	c, 0 (iy)
	ld	l, e
	ld	h, d
	push	bc
	ld	bc, #0x000A
	add	hl, bc
	pop	bc
	ld	a, (hl)
	sub	a, c
	jr	NC,00104$
;widgets.c:122: spinner->value --;
	dec	c
	ld	0 (iy), c
;widgets.c:123: spinner->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x01
00104$:
	pop	ix
	ret
;widgets.c:127: void spinner_redraw(T_Spinner *spinner) {
;	---------------------------------
; Function spinner_redraw
; ---------------------------------
_spinner_redraw::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:128: unsigned char *dst = SCRPTR(spinner->widget.layout.x, spinner->widget.layout.y);
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	l, c
	ld	h, b
	inc	hl
	ld	e,(hl)
	ld	d,#0x00
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl,de
	ex	de,hl
;widgets.c:130: spinner->widget.dirty = 0;
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x00
;widgets.c:131: text_hex(dst, spinner->value);
	push	bc
	pop	iy
	ld	h,12 (iy)
	push	hl
	inc	sp
	push	de
	call	_text_hex
	pop	af
	inc	sp
	pop	ix
	ret
;widgets.c:134: T_Checkbox *new_checkbox(unsigned char x, unsigned char y) {
;	---------------------------------
; Function new_checkbox
; ---------------------------------
_new_checkbox::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:135: T_Checkbox *checkbox = (T_Checkbox *) malloc(sizeof(T_Checkbox));
	ld	hl,#0x000B
	push	hl
	call	_malloc
	pop	af
	ex	de,hl
;widgets.c:137: init_widget(&(checkbox->widget), CHECKBOX);
	push	de
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	call	_init_widget
	pop	af
	inc	sp
	pop	de
;widgets.c:138: checkbox->widget.layout.x = x;
	ld	c, e
	ld	b, d
	inc	bc
	ld	a,4 (ix)
	ld	(bc),a
;widgets.c:139: checkbox->widget.layout.y = y;
	ld	l, c
	ld	h, b
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;widgets.c:140: checkbox->widget.layout.w = 2;
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl),#0x02
;widgets.c:141: checkbox->widget.layout.h = 1;
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x01
;widgets.c:143: checkbox->checked = 0;
	ld	hl,#0x000A
	add	hl,de
	ld	(hl),#0x00
;widgets.c:145: return checkbox;
	ex	de,hl
	pop	ix
	ret
;widgets.c:148: void checkbox_setValue(T_Checkbox *checkbox, unsigned char checked) {
;	---------------------------------
; Function checkbox_setValue
; ---------------------------------
_checkbox_setValue::
;widgets.c:149: if (checkbox != NULL) {
	ld	hl, #2+1
	add	hl, sp
	ld	a, (hl)
	dec	hl
	or	a,(hl)
	ret	Z
;widgets.c:150: checkbox->checked = checked ? -1 : 0;
	pop	de
	pop	bc
	push	bc
	push	de
	ld	hl,#0x000A
	add	hl,bc
	ld	iy,#4
	add	iy,sp
	ld	a,0 (iy)
	or	a, a
	jr	Z,00105$
	ld	a,#0xFF
	jr	00106$
00105$:
	ld	a,#0x00
00106$:
	ld	(hl),a
;widgets.c:151: checkbox->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x01
	ret
;widgets.c:155: void checkbox_changeValue(T_Checkbox *checkbox) {
;	---------------------------------
; Function checkbox_changeValue
; ---------------------------------
_checkbox_changeValue::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:156: if (checkbox != NULL) {
	ld	a,5 (ix)
	or	a,4 (ix)
	jr	Z,00103$
;widgets.c:157: checkbox->checked = !checkbox->checked;
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	iy,#0x000A
	add	iy, de
	ld	a, 0 (iy)
	sub	a,#0x01
	ld	a,#0x00
	rla
	ld	0 (iy), a
;widgets.c:158: checkbox->widget.dirty = 1;
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x01
00103$:
	pop	ix
	ret
;widgets.c:162: void checkbox_redraw(T_Checkbox *checkbox) {
;	---------------------------------
; Function checkbox_redraw
; ---------------------------------
_checkbox_redraw::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;widgets.c:163: unsigned char *dst = SCRPTR(checkbox->widget.layout.x, checkbox->widget.layout.y);
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	l, c
	ld	h, b
	inc	hl
	ld	e,(hl)
	ld	d,#0x00
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl,de
	ex	de,hl
;widgets.c:165: if (checkbox->checked) {
	push	bc
	pop	iy
	ld	l,10 (iy)
;widgets.c:166: *dst = 0xFC; *(dst+1) = 0x3F;
	push	de
	pop	iy
	inc	iy
;widgets.c:167: dst += 80;
	ld	a,e
	add	a, #0x50
	ld	-2 (ix),a
	ld	a,d
	adc	a, #0x00
	ld	-1 (ix),a
;widgets.c:165: if (checkbox->checked) {
	ld	a,l
	or	a, a
	jr	Z,00102$
;widgets.c:166: *dst = 0xFC; *(dst+1) = 0x3F;
	ld	a,#0xFC
	ld	(de),a
	ld	0 (iy), #0x3F
;widgets.c:167: dst += 80;
	pop	de
	push	de
;widgets.c:168: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:169: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:170: *dst = 0xCC; *(dst+1) = 0x33;
	ld	a,#0xCC
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x33
;widgets.c:171: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:172: *dst = 0xCC; *(dst+1) = 0x33;
	ld	a,#0xCC
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x33
;widgets.c:173: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:174: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:175: dst += 80;
	ld	hl,#0x0050
	add	hl,de
;widgets.c:176: *dst = 0xFC; *(dst+1) = 0x3F;
	ld	(hl),#0xFC
	inc	hl
	ld	(hl),#0x3F
	jr	00103$
00102$:
;widgets.c:178: *dst = 0xFC; *(dst+1) = 0x3F;
	ld	a,#0xFC
	ld	(de),a
	ld	0 (iy), #0x3F
;widgets.c:179: dst += 80;
	pop	de
	push	de
;widgets.c:180: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:181: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:182: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:183: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:184: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:185: dst += 80;
	ld	hl,#0x0050
	add	hl,de
	ex	de,hl
;widgets.c:186: *dst = 0x0C; *(dst+1) = 0x30;
	ld	a,#0x0C
	ld	(de),a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl),#0x30
;widgets.c:187: dst += 80;
	ld	hl,#0x0050
	add	hl,de
;widgets.c:188: *dst = 0xFC; *(dst+1) = 0x3F;
	ld	(hl),#0xFC
	inc	hl
	ld	(hl),#0x3F
00103$:
;widgets.c:190: checkbox->widget.dirty = 0;
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x00
	ld	sp, ix
	pop	ix
	ret
;widgets.c:193: T_Button *new_button(unsigned char x, unsigned char y, char *label) {
;	---------------------------------
; Function new_button
; ---------------------------------
_new_button::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;widgets.c:194: T_Button *button = (T_Button *) malloc(sizeof(T_Button));
	ld	hl,#0x000C
	push	hl
	call	_malloc
;widgets.c:195: char len = strlen(label);
	ex	(sp),hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_strlen
	pop	af
	pop	bc
	ld	-1 (ix),l
;widgets.c:197: init_widget(&(button->widget), BUTTON);
	push	bc
	ld	a,#0x02
	push	af
	inc	sp
	push	bc
	call	_init_widget
	pop	af
	inc	sp
	pop	bc
;widgets.c:198: button->widget.layout.x = x;
	ld	e, c
	ld	d, b
	inc	de
	ld	a,4 (ix)
	ld	(de),a
;widgets.c:199: button->widget.layout.y = y;
	ld	l, e
	ld	h, d
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;widgets.c:200: button->widget.layout.w = 2 + len;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	a,-1 (ix)
	add	a, #0x02
	ld	(hl),a
;widgets.c:201: button->widget.layout.h = 1;
	ex	de,hl
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x01
;widgets.c:203: button->label = (char *)malloc(len + 1);
	ld	hl,#0x000A
	add	hl,bc
	ld	e,-1 (ix)
	ld	a,-1 (ix)
	rla
	sbc	a, a
	ld	d,a
	inc	de
	push	hl
	push	bc
	push	de
	call	_malloc
	pop	af
	ex	de,hl
	pop	bc
	pop	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
;widgets.c:204: strcpy(button->label, label);
	push	bc
	ld	l,6 (ix)
	ld	h,7 (ix)
	xor	a, a
00103$:
	cp	a, (hl)
	ldi
	jr	NZ, 00103$
;widgets.c:206: return button;
	pop	hl
	inc	sp
	pop	ix
	ret
;widgets.c:209: void button_redraw(T_Button *button) {
;	---------------------------------
; Function button_redraw
; ---------------------------------
_button_redraw::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:210: unsigned char *dst = SCRPTR(button->widget.layout.x, button->widget.layout.y);
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	l, c
	ld	h, b
	inc	hl
	ld	e,(hl)
	ld	d,#0x00
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	pop	de
	add	hl,de
	ex	de,hl
;widgets.c:211: char *p = button->label;
	push	bc
	pop	iy
	ld	c,10 (iy)
	ld	b,11 (iy)
;widgets.c:214: text_char(dst++, '[');
	push	de
	pop	iy
	inc	de
	push	bc
	push	de
	ld	a,#0x5B
	push	af
	inc	sp
	push	iy
	call	_text_char
	pop	af
	inc	sp
	pop	de
	pop	bc
;widgets.c:215: while(c = *p++) text_char(dst++, c);
00101$:
	ld	a,(bc)
	inc	bc
	ld	h,a
	or	a, a
	jr	Z,00103$
	push	de
	pop	iy
	inc	de
	push	bc
	push	de
	push	hl
	inc	sp
	push	iy
	call	_text_char
	pop	af
	inc	sp
	pop	de
	pop	bc
	jr	00101$
00103$:
;widgets.c:216: text_char(dst++, ']');
	ld	a,#0x5D
	push	af
	inc	sp
	push	de
	call	_text_char
	pop	af
	inc	sp
	pop	ix
	ret
;widgets.c:219: void draw_label(unsigned char x, unsigned char y, char *text) {
;	---------------------------------
; Function draw_label
; ---------------------------------
_draw_label::
	push	ix
	ld	ix,#0
	add	ix,sp
;widgets.c:220: unsigned char *dst = SCRPTR(x, y);
	ld	e,4 (ix)
	ld	d,#0x00
	ld	l,5 (ix)
	ld	h,#0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl,de
	ld	e, l
	ld	d, h
;widgets.c:221: char *p = text;
	ld	c,6 (ix)
	ld	b,7 (ix)
;widgets.c:224: while(c = *p++) text_char(dst++, c);
00101$:
	ld	a,(bc)
	inc	bc
	ld	h,a
	or	a, a
	jr	Z,00104$
	push	de
	pop	iy
	inc	de
	push	bc
	push	de
	push	hl
	inc	sp
	push	iy
	call	_text_char
	pop	af
	inc	sp
	pop	de
	pop	bc
	jr	00101$
00104$:
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)

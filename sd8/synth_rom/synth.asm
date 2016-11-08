;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Tue Nov  8 14:23:14 2016
;--------------------------------------------------------
	.module synth
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _ei
	.globl _init_interrupt_table
	.globl _cls
	.globl _clock50KHz
	.globl _vbl
	.globl _refresh_mouse_buttons
	.globl _right_click_event
	.globl _left_click_event
	.globl _move_mouse
	.globl _init_ui
	.globl _ct1_clicked
	.globl _text_char
	.globl _draw_label
	.globl _new_checkbox
	.globl _new_spinner
	.globl _widget_event
	.globl _widget_redraw
	.globl _isInLayout
	.globl _ym2151_setCT1
	.globl _ym2151_write
	.globl _cur_y
	.globl _cur_x
	.globl _tick50Hz
	.globl _mouse_buttons
	.globl _mouse_y
	.globl _mouse_x
	.globl _widgets
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
_widgets::
	.ds 6
_refresh_mouse_buttons_prev_buttons_1_85:
	.ds 1
_refresh_mouse_buttons_click_timer_1_85:
	.ds 1
_refresh_mouse_buttons_initial_click_1_85:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_mouse_x::
	.ds 2
_mouse_y::
	.ds 2
_mouse_buttons::
	.ds 1
_tick50Hz::
	.ds 2
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
;synth.c:47: void ct1_clicked(T_Widget *widget) {
;	---------------------------------
; Function ct1_clicked
; ---------------------------------
_ct1_clicked::
;synth.c:48: ym2151_setCT1(((T_Checkbox *)widget)->checked ? 1 : 0);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x0008
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00103$
	ld	h,#0x01
	jr	00104$
00103$:
	ld	h,#0x00
00104$:
	push	hl
	inc	sp
	call	_ym2151_setCT1
	inc	sp
	ret
;synth.c:61: void init_ui() {
;	---------------------------------
; Function init_ui
; ---------------------------------
_init_ui::
;synth.c:64: draw_label(0, 0, "YMSoC v0.1");
	ld	hl,#___str_0
	push	hl
	ld	hl,#0x0000
	push	hl
	call	_draw_label
	pop	af
;synth.c:66: draw_label(0, 2, "CT1:");
	ld	hl, #___str_1
	ex	(sp),hl
	ld	hl,#0x0200
	push	hl
	call	_draw_label
	pop	af
;synth.c:67: widgets[W_LED] = (T_Widget *)new_checkbox(5, 2);
	ld	hl, #0x0205
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	(_widgets), de
;synth.c:68: widgets[W_LED]->callback = ct1_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_ct1_clicked)
	inc	hl
	ld	(hl),#>(_ct1_clicked)
;synth.c:70: draw_label(0, 4, "Value1:");
	ld	hl,#___str_2
	push	hl
	ld	hl,#0x0400
	push	hl
	call	_draw_label
	pop	af
;synth.c:71: widgets[SPINNER1] = (T_Widget *)new_spinner(10, 4);
	ld	hl, #0x040A
	ex	(sp),hl
	call	_new_spinner
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0002)), de
;synth.c:73: draw_label(0, 5, "Value2:");
	ld	hl,#___str_3
	push	hl
	ld	hl,#0x0500
	push	hl
	call	_draw_label
	pop	af
;synth.c:74: widgets[CHECKBOX1] = (T_Widget *)new_checkbox(10, 5);
	ld	hl, #0x050A
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0004)), de
;synth.c:77: for (i = 0; i < NB_WIDGETS; i++) {
	ld	d,#0x00
00102$:
;synth.c:78: widget_redraw(widgets[i]);
	ld	a,d
	ld	l,a
	rla
	sbc	a, a
	ld	h,a
	add	hl, hl
	ld	bc,#_widgets
	add	hl,bc
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	push	bc
	call	_widget_redraw
	pop	af
	pop	de
;synth.c:77: for (i = 0; i < NB_WIDGETS; i++) {
	inc	d
	ld	a,d
	xor	a, #0x80
	sub	a, #0x83
	jr	C,00102$
	ret
___str_0:
	.ascii "YMSoC v0.1"
	.db 0x00
___str_1:
	.ascii "CT1:"
	.db 0x00
___str_2:
	.ascii "Value1:"
	.db 0x00
___str_3:
	.ascii "Value2:"
	.db 0x00
;synth.c:86: void move_mouse() {
;	---------------------------------
; Function move_mouse
; ---------------------------------
_move_mouse::
;synth.c:89: mouse_x += (char)mouse_x_reg;
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
;synth.c:90: mouse_y -= (char)mouse_y_reg;
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
;synth.c:93: if(mouse_x < 0)   mouse_x = 0;
	ld	a,(#_mouse_x + 1)
	bit	7,a
	jr	Z,00102$
	ld	hl,#0x0000
	ld	(_mouse_x),hl
00102$:
;synth.c:94: if(mouse_x > 319) mouse_x = 319;
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
;synth.c:95: if(mouse_y < 0)   mouse_y = 0;
	ld	a,(#_mouse_y + 1)
	bit	7,a
	jr	Z,00106$
	ld	hl,#0x0000
	ld	(_mouse_y),hl
00106$:
;synth.c:96: if(mouse_y > 239)  mouse_y = 239;
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
;synth.c:99: *(unsigned char*)0x7efe = mouse_x;
	ld	a,(#_mouse_x + 0)
	ld	(#0x7EFE),a
;synth.c:100: *(unsigned char*)0x7eff = (mouse_x & 0x100) >> 8;
	ld	a,(#_mouse_x + 1)
	and	a, #0x01
	ld	d,a
	rlc	a
	sbc	a, a
	ld	hl,#0x7EFF
	ld	(hl),d
;synth.c:101: *(unsigned char*)0x7f00 = mouse_y;
	ld	a,(#_mouse_y + 0)
	ld	(#0x7F00),a
	ret
;synth.c:104: void left_click_event() {
;	---------------------------------
; Function left_click_event
; ---------------------------------
_left_click_event::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:107: for (i = 0; i < NB_WIDGETS; i++)
	ld	-1 (ix),#0x00
00106$:
;synth.c:108: if (isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
	ld	l,-1 (ix)
	ld	a,-1 (ix)
	rla
	sbc	a, a
	ld	h,a
	add	hl, hl
	ld	a,#<(_widgets)
	add	a, l
	ld	e,a
	ld	a,#>(_widgets)
	adc	a, h
	ld	d,a
	ld	l, e
	ld	h, d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	bc
	push	de
	ld	hl,(_mouse_y)
	push	hl
	ld	hl,(_mouse_x)
	push	hl
	push	bc
	call	_isInLayout
	pop	af
	pop	af
	pop	af
	ld	a,l
	pop	de
	or	a, a
	jr	Z,00107$
;synth.c:109: widget_event(widgets[i], EVENT_LEFT_CLICK);
	ld	l, e
	ld	h, d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	call	_widget_event
	pop	af
	inc	sp
;synth.c:110: if (widgets[i]->dirty)
	pop	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	l, e
	ld	h, d
	ld	bc, #0x0005
	add	hl, bc
	ld	a,(hl)
	or	a, a
	jr	Z,00107$
;synth.c:111: widget_redraw(widgets[i]);
	push	de
	call	_widget_redraw
	pop	af
00107$:
;synth.c:107: for (i = 0; i < NB_WIDGETS; i++)
	inc	-1 (ix)
	ld	a,-1 (ix)
	xor	a, #0x80
	sub	a, #0x83
	jr	C,00106$
	inc	sp
	pop	ix
	ret
;synth.c:115: void right_click_event() {
;	---------------------------------
; Function right_click_event
; ---------------------------------
_right_click_event::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:118: for (i = 0; i < NB_WIDGETS; i++)
	ld	-1 (ix),#0x00
00106$:
;synth.c:119: if (isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
	ld	l,-1 (ix)
	ld	a,-1 (ix)
	rla
	sbc	a, a
	ld	h,a
	add	hl, hl
	ld	a,#<(_widgets)
	add	a, l
	ld	e,a
	ld	a,#>(_widgets)
	adc	a, h
	ld	d,a
	ld	l, e
	ld	h, d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	bc
	push	de
	ld	hl,(_mouse_y)
	push	hl
	ld	hl,(_mouse_x)
	push	hl
	push	bc
	call	_isInLayout
	pop	af
	pop	af
	pop	af
	ld	a,l
	pop	de
	or	a, a
	jr	Z,00107$
;synth.c:120: widget_event(widgets[i], EVENT_RIGHT_CLICK);
	ld	l, e
	ld	h, d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	ld	a,#0x01
	push	af
	inc	sp
	push	bc
	call	_widget_event
	pop	af
	inc	sp
;synth.c:121: if (widgets[i]->dirty)
	pop	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	l, e
	ld	h, d
	ld	bc, #0x0005
	add	hl, bc
	ld	a,(hl)
	or	a, a
	jr	Z,00107$
;synth.c:122: widget_redraw(widgets[i]);
	push	de
	call	_widget_redraw
	pop	af
00107$:
;synth.c:118: for (i = 0; i < NB_WIDGETS; i++)
	inc	-1 (ix)
	ld	a,-1 (ix)
	xor	a, #0x80
	sub	a, #0x83
	jr	C,00106$
	inc	sp
	pop	ix
	ret
;synth.c:132: void refresh_mouse_buttons() {
;	---------------------------------
; Function refresh_mouse_buttons
; ---------------------------------
_refresh_mouse_buttons::
;synth.c:137: prev_buttons = mouse_buttons;
	ld	a,(#_mouse_buttons + 0)
	ld	(#_refresh_mouse_buttons_prev_buttons_1_85 + 0),a
;synth.c:138: mouse_buttons = (char)mouse_but_reg;
	in	a,(_mouse_but_reg)
	ld	(#_mouse_buttons + 0),a
;synth.c:140: if (!(prev_buttons & 1) && (mouse_buttons & 1)) {
	ld	a,(#_refresh_mouse_buttons_prev_buttons_1_85 + 0)
	and	a, #0x01
	ld	d,a
	ld	a,(#_mouse_buttons + 0)
	and	a, #0x01
	ld	e,a
	ld	a,d
	or	a,a
	jr	NZ,00128$
	or	a,e
	jr	Z,00128$
;synth.c:141: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
;synth.c:142: initial_click = 1;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_85 + 0
	ld	(hl), #0x01
;synth.c:143: left_click_event();		
	jp	_left_click_event
00128$:
;synth.c:145: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	b, (hl)
	inc	b
;synth.c:144: } else if ((prev_buttons & 1) && (mouse_buttons & 1)) {
	ld	a,d
	or	a, a
	jr	Z,00124$
	ld	a,e
	or	a, a
	jr	Z,00124$
;synth.c:145: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), b
;synth.c:146: if (initial_click && (click_timer == HOLD_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_85 + 0)
	or	a, a
	jr	Z,00105$
	ld	a,(#_refresh_mouse_buttons_click_timer_1_85 + 0)
	sub	a, #0x32
	jr	NZ,00105$
;synth.c:147: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_85 + 0
	ld	(hl), #0x00
;synth.c:148: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
	ret
00105$:
;synth.c:149: } else if (!initial_click && (click_timer == REPEAT_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_85 + 0)
	or	a, a
	ret	NZ
	ld	a,(#_refresh_mouse_buttons_click_timer_1_85 + 0)
	sub	a, #0x0A
	ret	NZ
;synth.c:150: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
;synth.c:151: left_click_event();
	jp	_left_click_event
00124$:
;synth.c:153: } else if (!(prev_buttons & 2) && (mouse_buttons & 2)) {
	ld	a,(#_refresh_mouse_buttons_prev_buttons_1_85 + 0)
	and	a, #0x02
	ld	e,a
	ld	a,(#_mouse_buttons + 0)
	and	a, #0x02
	ld	h,a
	ld	a,e
	or	a,a
	jr	NZ,00120$
	or	a,h
	jr	Z,00120$
;synth.c:154: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
;synth.c:155: initial_click = 1;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_85 + 0
	ld	(hl), #0x01
;synth.c:156: right_click_event();		
	jp	_right_click_event
00120$:
;synth.c:157: } else if ((prev_buttons & 2) && (mouse_buttons & 2)) {
	ld	a,e
	or	a, a
	jr	Z,00116$
	ld	a,h
	or	a, a
	jr	Z,00116$
;synth.c:158: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), b
;synth.c:159: if (initial_click && (click_timer == HOLD_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_85 + 0)
	or	a, a
	jr	Z,00112$
	ld	a,(#_refresh_mouse_buttons_click_timer_1_85 + 0)
	sub	a, #0x32
	jr	NZ,00112$
;synth.c:160: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_85 + 0
	ld	(hl), #0x00
;synth.c:161: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
	ret
00112$:
;synth.c:162: } else if (!initial_click && (click_timer == REPEAT_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_85 + 0)
	or	a, a
	ret	NZ
	ld	a,(#_refresh_mouse_buttons_click_timer_1_85 + 0)
	sub	a, #0x0A
	ret	NZ
;synth.c:163: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_85 + 0
	ld	(hl), #0x00
;synth.c:164: right_click_event();
	jp	_right_click_event
00116$:
;synth.c:167: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_85 + 0
	ld	(hl), #0x00
	ret
;synth.c:172: void vbl(void) __interrupt (0x30) {
;	---------------------------------
; Function vbl
; ---------------------------------
_vbl::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:174: move_mouse();
	call	_move_mouse
;synth.c:179: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:185: void clock50KHz(void) __interrupt (0x20) {
;	---------------------------------
; Function clock50KHz
; ---------------------------------
_clock50KHz::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:187: refresh_mouse_buttons();
	call	_refresh_mouse_buttons
;synth.c:188: tick50Hz ++;
	ld	iy,#_tick50Hz
	inc	0 (iy)
	jr	NZ,00103$
	ld	iy,#_tick50Hz
	inc	1 (iy)
00103$:
;synth.c:193: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:198: void putchar(char c) {
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;synth.c:199: unsigned char *dptr = (unsigned char*)(80 * (FONT_HEIGHT * cur_y) + cur_x);
	ld	iy,#_cur_y
	ld	l,0 (iy)
	ld	h,#0x00
	ld	c, l
	ld	b, h
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ex	de,hl
	ld	iy,#_cur_x
	ld	l,0 (iy)
	ld	h,#0x00
	add	hl,de
	inc	sp
	inc	sp
	push	hl
;synth.c:201: if(c < 32) {
	ld	a,4 (ix)
	xor	a, #0x80
	sub	a, #0xA0
	jr	NC,00108$
;synth.c:202: if(c == '\r') 
	ld	a,4 (ix)
	sub	a, #0x0D
	jr	NZ,00102$
;synth.c:203: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
00102$:
;synth.c:205: if(c == '\n') {
	ld	a,4 (ix)
	sub	a, #0x0A
	jr	NZ,00115$
;synth.c:206: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:207: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:209: if(cur_y >= 240 / FONT_HEIGHT)
	ld	a,(#_cur_y + 0)
	sub	a, #0x28
	jr	C,00115$
;synth.c:210: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
;synth.c:212: return;
	jr	00115$
00108$:
;synth.c:215: if(c < 0) return;
	bit	7, 4 (ix)
	jr	NZ,00115$
;synth.c:217: text_char(dptr, c);
	ld	a,4 (ix)
	push	af
	inc	sp
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_text_char
	pop	af
	inc	sp
;synth.c:219: cur_x++;
	ld	hl, #_cur_x+0
	inc	(hl)
;synth.c:220: if(cur_x >= 320 / FONT_WIDTH) {
	ld	a,(#_cur_x + 0)
	sub	a, #0x50
	jr	C,00115$
;synth.c:221: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:222: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:224: if(cur_y >= 240 / FONT_HEIGHT)
	ld	a,(#_cur_y + 0)
	sub	a, #0x28
	jr	C,00115$
;synth.c:225: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
00115$:
	ld	sp, ix
	pop	ix
	ret
;synth.c:229: void cls(void) {
;	---------------------------------
; Function cls
; ---------------------------------
_cls::
;synth.c:233: for(i = 0; i < 240; i++) {
	ld	hl,#0x0000
	ld	e,l
	ld	d,h
00102$:
;synth.c:234: memset(p, 0, 80);
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
;synth.c:235: p += 80;
	ld	bc,#0x0050
	add	hl,bc
;synth.c:233: for(i = 0; i < 240; i++) {
	inc	de
	ld	a,e
	sub	a, #0xF0
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00102$
;synth.c:237: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:238: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
	ret
;synth.c:247: void init_interrupt_table() {
;	---------------------------------
; Function init_interrupt_table
; ---------------------------------
_init_interrupt_table::
;synth.c:259: __endasm;
	ld hl,#0x8000
	ld a,h
	ld i,a
	ld iy,#_clock50KHz
	ld (#0x8020),iy
	ld iy,#_vbl
	ld (#0x8030),iy
	ret
;synth.c:262: void ei() {
;	---------------------------------
; Function ei
; ---------------------------------
_ei::
;synth.c:267: __endasm;
	im 2
	ei
	ret
;synth.c:270: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:273: init_interrupt_table();
	call	_init_interrupt_table
;synth.c:275: cls();
	call	_cls
;synth.c:278: for(i = 0; i < 8; i++) {
	ld	e,#0x00
00111$:
;synth.c:279: *(char*)(0x7f10+i) = cursor_data[i];
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
;synth.c:280: *(char*)(0x7f18+i) = cursor_mask[i];
	ld	hl,#0x7F18
	add	hl,bc
	ld	c, l
	ld	b, h
	ld	hl,#_cursor_mask
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	(bc),a
;synth.c:278: for(i = 0; i < 8; i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00111$
;synth.c:283: *(unsigned char*)0x7efd = 0x00;
	ld	hl,#0x7EFD
	ld	(hl),#0x00
;synth.c:285: *(unsigned char*)0x7efb = CURSOR_COLOR1;
	ld	l, #0xFB
	ld	(hl),#0xFF
;synth.c:286: *(unsigned char*)0x7efc = CURSOR_COLOR2;
	ld	l, #0xFC
	ld	(hl),#0xE0
;synth.c:289: *(unsigned char*)0x7f20 = BG_COLOR;
	ld	hl,#0x7F20
	ld	(hl),#0x4A
;synth.c:292: init_ui();
	call	_init_ui
;synth.c:295: ei();
	call	_ei
;synth.c:298: do {
00108$:
;synth.c:299: char c = keys;
	in	a,(_keys)
	ld	-1 (ix),a
;synth.c:302: if (c & 0x1) { 	// Space
	bit	0, -1 (ix)
	jr	Z,00103$
;synth.c:303: ym2151_write(0x20, 0xC0);	// L/R
	ld	hl,#0xC020
	push	hl
	call	_ym2151_write
;synth.c:305: ym2151_write(0x28 + ch, 0x00);
	ld	hl, #0x0028
	ex	(sp),hl
	call	_ym2151_write
;synth.c:306: ym2151_write(0x30 + ch, 0x00);
	ld	hl, #0x0030
	ex	(sp),hl
	call	_ym2151_write
;synth.c:307: ym2151_write(0x38 + ch, 0x00);
	ld	hl, #0x0038
	ex	(sp),hl
	call	_ym2151_write
;synth.c:308: ym2151_write(0x40 + ch, 0x00);
	ld	hl, #0x0040
	ex	(sp),hl
	call	_ym2151_write
;synth.c:309: ym2151_write(0x60 + ch, 0x00);
	ld	hl, #0x0060
	ex	(sp),hl
	call	_ym2151_write
;synth.c:310: ym2151_write(0x80 + ch, 0x00);
	ld	hl, #0x0080
	ex	(sp),hl
	call	_ym2151_write
;synth.c:311: ym2151_write(0xA0 + ch, 0x00);
	ld	hl, #0x00A0
	ex	(sp),hl
	call	_ym2151_write
;synth.c:312: ym2151_write(0xC0 + ch, 0x00);
	ld	hl, #0x00C0
	ex	(sp),hl
	call	_ym2151_write
;synth.c:313: ym2151_write(0xE0 + ch, 0x00);
	ld	hl, #0x00E0
	ex	(sp),hl
	call	_ym2151_write
	pop	af
00103$:
;synth.c:315: if (c & 0x2) {	// S
	bit	1, -1 (ix)
	jr	Z,00105$
;synth.c:316: ym2151_setCT1(1);
	ld	a,#0x01
	push	af
	inc	sp
	call	_ym2151_setCT1
	inc	sp
;synth.c:317: ym2151_write(0x08, 0x40);	// K_ON, MOD1, CH0
	ld	hl,#0x4008
	push	hl
	call	_ym2151_write
	pop	af
00105$:
;synth.c:320: if (c & 0x4) {	// C
	bit	2, -1 (ix)
	jr	Z,00108$
;synth.c:321: ym2151_write(0x08, 0x00);	// K_OFF, CH0
	ld	hl,#0x0008
	push	hl
	call	_ym2151_write
	pop	af
;synth.c:324: } while(1);
	jr	00108$
	inc	sp
	pop	ix
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__mouse_x:
	.dw #0x00A0
__xinit__mouse_y:
	.dw #0x0078
__xinit__mouse_buttons:
	.db #0x00	; 0
__xinit__tick50Hz:
	.dw #0x0000
__xinit__cur_x:
	.db #0x00	; 0
__xinit__cur_y:
	.db #0x00	; 0
	.area _CABS (ABS)

;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.5.0 #9253 (Mar 24 2016) (Linux)
; This file was generated Thu Nov 10 16:50:37 2016
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
	.globl _op_value_changed
	.globl _lfo_amplitude_changed
	.globl _lfo_modulation_clicked
	.globl _lfo_frequency_changed
	.globl _lfo_waveform_changed
	.globl _connection_changed
	.globl _reset_lfo_clicked
	.globl _channels_config_clicked
	.globl _key_config_clicked
	.globl _ct1_clicked
	.globl _text_char
	.globl _draw_label
	.globl _new_button
	.globl _new_checkbox
	.globl _spinner_setMax
	.globl _new_spinner
	.globl _widget_event
	.globl _widget_redraw
	.globl _isInLayout
	.globl _ym2151_setDecayLevelReleaseRate
	.globl _ym2151_setDetune2DecayRate2
	.globl _ym2151_setAMSEnableDecayRate1
	.globl _ym2151_setKeyScalingAttackRate
	.globl _ym2151_setTotalLevel
	.globl _ym2151_setDetune1PhaseMultiply
	.globl _ym2151_setConnections
	.globl _ym2151_setChannels
	.globl _ym2151_setKeyNote
	.globl _ym2151_setKeyState
	.globl _ym2151_resetLFO
	.globl _ym2151_setLFOAmplitude
	.globl _ym2151_setLFOModulation
	.globl _ym2151_setLFOFrequency
	.globl _ym2151_setLFOWaveform
	.globl _ym2151_setCT1
	.globl _ym2151_init
	.globl _malloc
	.globl _cur_y
	.globl _cur_x
	.globl _tick50Hz
	.globl _mouse_buttons
	.globl _mouse_y
	.globl _mouse_x
	.globl _key_config
	.globl _current_channel
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
	.ds 48
_refresh_mouse_buttons_prev_buttons_1_120:
	.ds 1
_refresh_mouse_buttons_click_timer_1_120:
	.ds 1
_refresh_mouse_buttons_initial_click_1_120:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_current_channel::
	.ds 2
_key_config::
	.ds 1
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
;synth.c:80: void ct1_clicked(T_Widget *widget) {
;	---------------------------------
; Function ct1_clicked
; ---------------------------------
_ct1_clicked::
;synth.c:81: ym2151_setCT1(((T_Checkbox *)widget)->checked ? 1 : 0);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000A
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
;synth.c:84: void key_config_clicked(T_Widget *widget) {
;	---------------------------------
; Function key_config_clicked
; ---------------------------------
_key_config_clicked::
	push	ix
;synth.c:85: key_config = YM_KEY_OFF;
	ld	hl,#_key_config + 0
	ld	(hl), #0x00
;synth.c:86: key_config |= ((T_Checkbox *)widgets[W_M1])->checked ? YM_KEY_MOD1 : 0x00;
	ld	hl, (#_widgets + 2)
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00103$
	ld	a,#0x40
	jr	00104$
00103$:
	ld	a,#0x00
00104$:
	ld	(#_key_config + 0),a
;synth.c:87: key_config |= ((T_Checkbox *)widgets[W_C1])->checked ? YM_KEY_CAR1 : 0x00;
	ld	hl, (#_widgets + 4)
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00105$
	ld	a,#0x20
	jr	00106$
00105$:
	ld	a,#0x00
00106$:
	ld	hl,#_key_config + 0
	or	a,(hl)
	ld	(#_key_config + 0),a
;synth.c:88: key_config |= ((T_Checkbox *)widgets[W_M2])->checked ? YM_KEY_MOD2 : 0x00;
	ld	hl, (#_widgets + 6)
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00107$
	ld	a,#0x10
	jr	00108$
00107$:
	ld	a,#0x00
00108$:
	ld	hl,#_key_config + 0
	or	a,(hl)
	ld	(#_key_config + 0),a
;synth.c:89: key_config |= ((T_Checkbox *)widgets[W_C2])->checked ? YM_KEY_CAR2 : 0x00;
	ld	hl, (#_widgets + 8)
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00109$
	ld	a,#0x08
	jr	00110$
00109$:
	ld	a,#0x00
00110$:
	ld	hl,#_key_config + 0
	or	a,(hl)
	ld	(#_key_config + 0),a
	pop	ix
	ret
;synth.c:92: void channels_config_clicked(T_Widget *widget) {
;	---------------------------------
; Function channels_config_clicked
; ---------------------------------
_channels_config_clicked::
	push	ix
;synth.c:95: channels_config |= ((T_Checkbox *)widgets[W_CH_L])->checked ? YM_LEFT : 0x00;
	ld	hl, (#_widgets + 10)
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00103$
	ld	d,#0x40
	jr	00104$
00103$:
	ld	d,#0x00
00104$:
;synth.c:96: channels_config |= ((T_Checkbox *)widgets[W_CH_R])->checked ? YM_RIGHT : 0x00;
	ld	hl, (#_widgets + 12)
	ld	bc, #0x000A
	add	hl, bc
	ld	a,(hl)
	or	a, a
	jr	Z,00105$
	ld	a,#0x80
	jr	00106$
00105$:
	ld	a,#0x00
00106$:
	or	a, d
	ld	d,a
;synth.c:98: ym2151_setChannels(current_channel, channels_config);
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setChannels
	pop	af
	pop	ix
	ret
;synth.c:101: void reset_lfo_clicked(T_Widget *widget) {
;	---------------------------------
; Function reset_lfo_clicked
; ---------------------------------
_reset_lfo_clicked::
;synth.c:102: ym2151_resetLFO();
	jp	_ym2151_resetLFO
;synth.c:105: void connection_changed(T_Widget *widget) {
;	---------------------------------
; Function connection_changed
; ---------------------------------
_connection_changed::
;synth.c:106: ym2151_setConnections(current_channel, ((T_Spinner *)widget)->value);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	push	de
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setConnections
	pop	af
	ret
;synth.c:109: void lfo_waveform_changed(T_Widget *widget) {
;	---------------------------------
; Function lfo_waveform_changed
; ---------------------------------
_lfo_waveform_changed::
;synth.c:110: ym2151_setLFOWaveform(((T_Spinner *)widget)->value);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000C
	add	hl, de
	ld	h,(hl)
	push	hl
	inc	sp
	call	_ym2151_setLFOWaveform
	inc	sp
	ret
;synth.c:113: void lfo_frequency_changed(T_Widget *widget) {
;	---------------------------------
; Function lfo_frequency_changed
; ---------------------------------
_lfo_frequency_changed::
;synth.c:114: ym2151_setLFOFrequency(((T_Spinner *)widget)->value);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000C
	add	hl, de
	ld	h,(hl)
	push	hl
	inc	sp
	call	_ym2151_setLFOFrequency
	inc	sp
	ret
;synth.c:117: void lfo_modulation_clicked(T_Widget *widget) {
;	---------------------------------
; Function lfo_modulation_clicked
; ---------------------------------
_lfo_modulation_clicked::
;synth.c:118: ym2151_setLFOModulation(((T_Checkbox *)widget)->checked ? YM_PHASE : YM_AMPLITUDE);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000A
	add	hl, de
	ld	a,(hl)
	or	a, a
	jr	Z,00103$
	ld	h,#0x80
	jr	00104$
00103$:
	ld	h,#0x00
00104$:
	push	hl
	inc	sp
	call	_ym2151_setLFOModulation
	inc	sp
	ret
;synth.c:121: void lfo_amplitude_changed(T_Widget *widget) {
;	---------------------------------
; Function lfo_amplitude_changed
; ---------------------------------
_lfo_amplitude_changed::
;synth.c:122: ym2151_setLFOAmplitude(((T_Spinner *)widget)->value);
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	de, #0x000C
	add	hl, de
	ld	h,(hl)
	push	hl
	inc	sp
	call	_ym2151_setLFOAmplitude
	inc	sp
	ret
;synth.c:125: void op_value_changed(T_Widget *widget) {
;	---------------------------------
; Function op_value_changed
; ---------------------------------
_op_value_changed::
	push	ix
	ld	ix,#0
	add	ix,sp
;synth.c:126: T_WData *data = (T_WData *)(widget->user_data);
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	de, #0x0008
	add	hl, de
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
;synth.c:131: switch(data->op) {
	ld	a,(bc)
	ld	e,a
	ld	a,#0x0A
	sub	a, e
	jp	C,00113$
	ld	d,#0x00
	ld	hl,#00119$
	add	hl,de
	add	hl,de
	add	hl,de
	jp	(hl)
00119$:
	jp	00101$
	jp	00102$
	jp	00103$
	jp	00104$
	jp	00105$
	jp	00106$
	jp	00107$
	jp	00108$
	jp	00109$
	jp	00110$
	jp	00111$
;synth.c:132: case 0:
00101$:
;synth.c:133: case 1:
00102$:
;synth.c:134: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS])->value;
	ld	hl, (#_widgets + 26)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:135: value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 1])->value;
	ld	hl, (#_widgets + 28)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	e,(hl)
;synth.c:136: ym2151_setDetune1PhaseMultiply(current_channel, data->dev, value1, value2); 
	ld	l, c
	ld	h, b
	inc	hl
	ld	c,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	ld	a,e
	push	af
	inc	sp
	push	de
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setDetune1PhaseMultiply
	pop	af
	pop	af
;synth.c:137: break;
	jp	00113$
;synth.c:138: case 2:
00103$:
;synth.c:139: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 2])->value;
	ld	hl, (#(_widgets + 0x001e) + 0)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:140: ym2151_setTotalLevel(current_channel, data->dev, value1);
	ld	l, c
	ld	h, b
	inc	hl
	ld	b,(hl)
	ld	a,(#_current_channel + 0)
	push	de
	inc	sp
	push	bc
	inc	sp
	push	af
	inc	sp
	call	_ym2151_setTotalLevel
	pop	af
	inc	sp
;synth.c:141: break;
	jp	00113$
;synth.c:142: case 3:
00104$:
;synth.c:143: case 4:
00105$:
;synth.c:144: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 3])->value;
	ld	hl, (#_widgets + 32)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:145: value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 4])->value;
	ld	hl, (#_widgets + 34)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	e,(hl)
;synth.c:146: ym2151_setKeyScalingAttackRate(current_channel, data->dev, value1, value2);
	ld	l, c
	ld	h, b
	inc	hl
	ld	c,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	ld	a,e
	push	af
	inc	sp
	push	de
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setKeyScalingAttackRate
	pop	af
	pop	af
;synth.c:147: break;
	jp	00113$
;synth.c:148: case 5:
00106$:
;synth.c:149: case 6:
00107$:
;synth.c:150: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 5])->value;
	ld	hl, (#_widgets + 36)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:151: value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 6])->value;
	ld	hl, (#_widgets + 38)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	e,(hl)
;synth.c:152: ym2151_setAMSEnableDecayRate1(current_channel, data->dev, value1, value2);
	ld	l, c
	ld	h, b
	inc	hl
	ld	c,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	ld	a,e
	push	af
	inc	sp
	push	de
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setAMSEnableDecayRate1
	pop	af
	pop	af
;synth.c:153: break;
	jr	00113$
;synth.c:154: case 7:
00108$:
;synth.c:155: case 8:
00109$:
;synth.c:156: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 7])->value;
	ld	hl, (#_widgets + 40)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:157: value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 8])->value;
	ld	hl, (#_widgets + 42)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	e,(hl)
;synth.c:158: ym2151_setDetune2DecayRate2(current_channel, data->dev, value1, value2);
	ld	l, c
	ld	h, b
	inc	hl
	ld	c,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	ld	a,e
	push	af
	inc	sp
	push	de
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setDetune2DecayRate2
	pop	af
	pop	af
;synth.c:159: break;
	jr	00113$
;synth.c:160: case 9:
00110$:
;synth.c:161: case 10:
00111$:
;synth.c:162: value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 9])->value;
	ld	hl, (#_widgets + 44)
	ld	de, #0x000C
	add	hl, de
	ld	d,(hl)
;synth.c:163: value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 10])->value;
	ld	hl, (#_widgets + 46)
	push	bc
	ld	bc, #0x000C
	add	hl, bc
	pop	bc
	ld	e,(hl)
;synth.c:164: ym2151_setDecayLevelReleaseRate(current_channel, data->dev, value1, value2);
	ld	l, c
	ld	h, b
	inc	hl
	ld	c,(hl)
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	ld	a,e
	push	af
	inc	sp
	push	de
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setDecayLevelReleaseRate
	pop	af
	pop	af
;synth.c:166: }
00113$:
	pop	ix
	ret
;synth.c:169: void init_ui() {
;	---------------------------------
; Function init_ui
; ---------------------------------
_init_ui::
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-75
	add	hl,sp
;synth.c:171: char op_lbl[NB_OP][6] = {"DT1:", "MUL:", "TL:", "KS:", "AR:", "AMS:", "D1R:", "DT2:", "D2R:", "D1L:", "RR:"};
	ld	sp, hl
	inc	hl
	inc	hl
	ld	(hl),#0x44
	ld	hl,#0x0002
	add	hl,sp
	ld	e,l
	ld	d,h
	inc	hl
	ld	(hl),#0x54
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	(hl),#0x31
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x3A
	ld	hl,#0x0004
	add	hl,de
	ld	(hl),#0x00
	ld	hl,#0x0005
	add	hl,de
	ld	(hl),#0x00
	ld	hl,#0x0002
	add	hl,sp
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	a,-6 (ix)
	add	a, #0x06
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4D
	ld	a,-6 (ix)
	add	a, #0x07
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x55
	ld	a,-6 (ix)
	add	a, #0x08
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4C
	ld	a,-6 (ix)
	add	a, #0x09
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x0A
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x0B
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x0C
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x54
	ld	a,-6 (ix)
	add	a, #0x0D
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4C
	ld	a,-6 (ix)
	add	a, #0x0E
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x0F
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x10
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x11
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x12
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4B
	ld	a,-6 (ix)
	add	a, #0x13
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x53
	ld	a,-6 (ix)
	add	a, #0x14
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x15
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x16
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x17
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x18
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x41
	ld	a,-6 (ix)
	add	a, #0x19
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x52
	ld	a,-6 (ix)
	add	a, #0x1A
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x1B
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x1C
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x1D
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x1E
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x41
	ld	a,-6 (ix)
	add	a, #0x1F
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4D
	ld	a,-6 (ix)
	add	a, #0x20
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x53
	ld	a,-6 (ix)
	add	a, #0x21
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x22
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x23
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x24
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x44
	ld	a,-6 (ix)
	add	a, #0x25
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x31
	ld	a,-6 (ix)
	add	a, #0x26
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x52
	ld	a,-6 (ix)
	add	a, #0x27
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x28
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x29
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x2A
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x44
	ld	a,-6 (ix)
	add	a, #0x2B
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x54
	ld	a,-6 (ix)
	add	a, #0x2C
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x32
	ld	a,-6 (ix)
	add	a, #0x2D
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x2E
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x2F
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x30
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x44
	ld	a,-6 (ix)
	add	a, #0x31
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x32
	ld	a,-6 (ix)
	add	a, #0x32
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x52
	ld	a,-6 (ix)
	add	a, #0x33
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x34
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x35
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x36
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x44
	ld	a,-6 (ix)
	add	a, #0x37
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x31
	ld	a,-6 (ix)
	add	a, #0x38
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x4C
	ld	a,-6 (ix)
	add	a, #0x39
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x3A
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x3B
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x3C
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x52
	ld	a,-6 (ix)
	add	a, #0x3D
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x52
	ld	a,-6 (ix)
	add	a, #0x3E
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x3A
	ld	a,-6 (ix)
	add	a, #0x3F
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x40
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
	ld	a,-6 (ix)
	add	a, #0x41
	ld	l,a
	ld	a,-5 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
;synth.c:173: memset(widgets, 0, sizeof(T_Widget *) * NB_WIDGETS);
	ld	hl,#_widgets
	ld	b, #0x30
00141$:
	ld	(hl), #0x00
	inc	hl
	djnz	00141$
;synth.c:175: draw_label(0, 0, "YMSoC v0.1");
	ld	hl,#___str_11
	push	hl
	ld	hl,#0x0000
	push	hl
	call	_draw_label
	pop	af
;synth.c:177: draw_label(0, 2, "CT1:");
	ld	hl, #___str_12
	ex	(sp),hl
	ld	hl,#0x0200
	push	hl
	call	_draw_label
	pop	af
;synth.c:178: widgets[W_LED] = (T_Widget *)new_checkbox(4, 2);
	ld	hl, #0x0204
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	(_widgets), de
;synth.c:179: widgets[W_LED]->callback = ct1_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_ct1_clicked)
	inc	hl
	ld	(hl),#>(_ct1_clicked)
;synth.c:181: draw_label(7, 1, "M1C1M2C2");
	ld	hl,#___str_13
	push	hl
	ld	hl,#0x0107
	push	hl
	call	_draw_label
	pop	af
;synth.c:182: widgets[W_M1] = (T_Widget *)new_checkbox(7, 2);
	ld	hl, #0x0207
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0002)), de
;synth.c:183: widgets[W_M1]->callback = key_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_key_config_clicked)
	inc	hl
	ld	(hl),#>(_key_config_clicked)
;synth.c:184: widgets[W_C1] = (T_Widget *)new_checkbox(9, 2);
	ld	hl,#0x0209
	push	hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0004)), de
;synth.c:185: widgets[W_C1]->callback = key_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_key_config_clicked)
	inc	hl
	ld	(hl),#>(_key_config_clicked)
;synth.c:186: widgets[W_M2] = (T_Widget *)new_checkbox(11, 2);
	ld	hl,#0x020B
	push	hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0006)), de
;synth.c:187: widgets[W_M2]->callback = key_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_key_config_clicked)
	inc	hl
	ld	(hl),#>(_key_config_clicked)
;synth.c:188: widgets[W_C2] = (T_Widget *)new_checkbox(13, 2);
	ld	hl,#0x020D
	push	hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0008)), de
;synth.c:189: widgets[W_C2]->callback = key_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_key_config_clicked)
	inc	hl
	ld	(hl),#>(_key_config_clicked)
;synth.c:191: draw_label(16, 2, "Channels:");
	ld	hl,#___str_14
	push	hl
	ld	hl,#0x0210
	push	hl
	call	_draw_label
	pop	af
;synth.c:192: draw_label(25, 1, "Le");
	ld	hl, #___str_15
	ex	(sp),hl
	ld	hl,#0x0119
	push	hl
	call	_draw_label
	pop	af
;synth.c:193: draw_label(27, 1, "Ri");
	ld	hl, #___str_16
	ex	(sp),hl
	ld	hl,#0x011B
	push	hl
	call	_draw_label
	pop	af
;synth.c:194: widgets[W_CH_L] = (T_Widget *)new_checkbox(25, 2);
	ld	hl, #0x0219
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x000a)), de
;synth.c:195: widgets[W_CH_L]->callback = channels_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_channels_config_clicked)
	inc	hl
	ld	(hl),#>(_channels_config_clicked)
;synth.c:196: widgets[W_CH_R] = (T_Widget *)new_checkbox(27, 2);
	ld	hl,#0x021B
	push	hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x000c)), de
;synth.c:197: widgets[W_CH_R]->callback = channels_config_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_channels_config_clicked)
	inc	hl
	ld	(hl),#>(_channels_config_clicked)
;synth.c:199: draw_label(30, 2, "Connection:");
	ld	hl,#___str_17
	push	hl
	ld	hl,#0x021E
	push	hl
	call	_draw_label
	pop	af
;synth.c:200: widgets[W_CONNECT] = (T_Widget *)new_spinner(41, 2);
	ld	hl, #0x0229
	ex	(sp),hl
	call	_new_spinner
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0010)), de
;synth.c:201: spinner_setMax((T_Spinner *)widgets[W_CONNECT], 7);
	ld	a,#0x07
	push	af
	inc	sp
	push	de
	call	_spinner_setMax
	pop	af
	inc	sp
;synth.c:202: widgets[W_CONNECT]->callback = connection_changed;
	ld	hl, #(_widgets + 0x0010) + 0
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	ld	a,-4 (ix)
	add	a, #0x06
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#<(_connection_changed)
	inc	hl
	ld	(hl),#>(_connection_changed)
;synth.c:205: widgets[W_RESET_LFO] = (T_Widget *)new_button(0, 4, "Reset LFO");
	ld	hl,#___str_18
	push	hl
	ld	hl,#0x0400
	push	hl
	call	_new_button
	pop	af
	pop	af
	ex	de,hl
	ld	((_widgets + 0x000e)), de
;synth.c:206: widgets[W_RESET_LFO]->callback = reset_lfo_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_reset_lfo_clicked)
	inc	hl
	ld	(hl),#>(_reset_lfo_clicked)
;synth.c:207: draw_label(0, 5, "LFO Waveform:"); 
	ld	hl,#___str_19
	push	hl
	ld	hl,#0x0500
	push	hl
	call	_draw_label
	pop	af
;synth.c:208: widgets[W_LFO_WF] = (T_Widget *)new_spinner(13, 5);
	ld	hl, #0x050D
	ex	(sp),hl
	call	_new_spinner
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0012)), de
;synth.c:209: spinner_setMax((T_Spinner *)widgets[W_LFO_WF], 3);
	ld	a,#0x03
	push	af
	inc	sp
	push	de
	call	_spinner_setMax
	pop	af
	inc	sp
;synth.c:210: widgets[W_LFO_WF]->callback = lfo_waveform_changed;
	ld	hl, #(_widgets + 0x0012) + 0
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	ld	a,-4 (ix)
	add	a, #0x06
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#<(_lfo_waveform_changed)
	inc	hl
	ld	(hl),#>(_lfo_waveform_changed)
;synth.c:211: draw_label(16, 5, "Frequency:"); 
	ld	hl,#___str_20
	push	hl
	ld	hl,#0x0510
	push	hl
	call	_draw_label
	pop	af
;synth.c:212: widgets[W_LFO_FREQ] = (T_Widget *)new_spinner(26, 5);
	ld	hl, #0x051A
	ex	(sp),hl
	call	_new_spinner
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0014)), de
;synth.c:213: widgets[W_LFO_FREQ]->callback = lfo_frequency_changed;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_lfo_frequency_changed)
	inc	hl
	ld	(hl),#>(_lfo_frequency_changed)
;synth.c:214: draw_label(0, 6, "LFO Modulation (FM/PM):");
	ld	hl,#___str_21
	push	hl
	ld	hl,#0x0600
	push	hl
	call	_draw_label
	pop	af
;synth.c:215: widgets[W_LFO_MOD] = (T_Widget *)new_checkbox(23, 6);
	ld	hl, #0x0617
	ex	(sp),hl
	call	_new_checkbox
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0016)), de
;synth.c:216: widgets[W_LFO_MOD]->callback = lfo_modulation_clicked;
	ld	hl,#0x0006
	add	hl,de
	ld	(hl),#<(_lfo_modulation_clicked)
	inc	hl
	ld	(hl),#>(_lfo_modulation_clicked)
;synth.c:217: draw_label(26, 6, "Amplitude:");
	ld	hl,#___str_22
	push	hl
	ld	hl,#0x061A
	push	hl
	call	_draw_label
	pop	af
;synth.c:218: widgets[W_LFO_AMPLITUDE] = (T_Widget *)new_spinner(36, 6);
	ld	hl, #0x0624
	ex	(sp),hl
	call	_new_spinner
	pop	af
	ex	de,hl
	ld	((_widgets + 0x0018)), de
;synth.c:219: spinner_setMax((T_Spinner *)widgets[W_LFO_AMPLITUDE], 127);
	ld	a,#0x7F
	push	af
	inc	sp
	push	de
	call	_spinner_setMax
	pop	af
	inc	sp
;synth.c:220: widgets[W_LFO_AMPLITUDE]->callback = lfo_amplitude_changed;
	ld	hl, #(_widgets + 0x0018) + 0
	ld	a,(hl)
	ld	-4 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-3 (ix),a
	ld	a,-4 (ix)
	add	a, #0x06
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#<(_lfo_amplitude_changed)
	inc	hl
	ld	(hl),#>(_lfo_amplitude_changed)
;synth.c:223: for (i = 0; i < NB_OP; i++) {
	ld	c,#0x00
	ld	de,#0x0000
00108$:
;synth.c:224: draw_label(0, 10 + i, op_lbl[i]);
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	add	hl,de
	ld	a,c
	add	a, #0x0A
	ld	b,a
	push	bc
	push	de
	push	hl
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_draw_label
	pop	af
	pop	af
	pop	de
	pop	bc
;synth.c:225: for (j = 0; j < NB_DEV; j++) {
	ld	-4 (ix),b
	ld	a,c
	add	a, #0x0D
	ld	-2 (ix),a
	ld	-7 (ix),#0x00
	ld	b,#0x00
00106$:
;synth.c:226: T_Widget *w = (T_Widget *)new_spinner(6 + j * 3, 10 + i);
	ld	a,b
	add	a, #0x06
	ld	-1 (ix),a
	push	bc
	push	de
	ld	h,-4 (ix)
	ld	l,-1 (ix)
	push	hl
	call	_new_spinner
	pop	af
	pop	de
	pop	bc
	inc	sp
	inc	sp
	push	hl
;synth.c:227: T_WData *wd = (T_WData *)malloc(sizeof(T_WData));
	push	bc
	push	de
	ld	hl,#0x0002
	push	hl
	call	_malloc
	pop	af
	pop	de
	pop	bc
;synth.c:228: wd->op = i;
	ld	(hl),c
;synth.c:229: wd->dev = YM_KEY_MOD1;
	push	hl
	pop	iy
	inc	iy
	ld	0 (iy), #0x40
;synth.c:230: w->user_data = wd;
	ld	iy,#0x0008
	push	bc
	ld	c,-75 (ix)
	ld	b,-74 (ix)
	add	iy, bc
	pop	bc
	ld	0 (iy),l
	ld	1 (iy),h
;synth.c:231: w->callback = op_value_changed;
	ld	a,-75 (ix)
	add	a, #0x06
	ld	l,a
	ld	a,-74 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#<(_op_value_changed)
	inc	hl
	ld	(hl),#>(_op_value_changed)
;synth.c:232: widgets[NB_CH_WIDGETS + i * NB_DEV + j] = w;	
	ld	a,-2 (ix)
	add	a, -7 (ix)
	ld	l,a
	rla
	sbc	a, a
	ld	h,a
	add	hl, hl
	ld	a,l
	add	a, #<(_widgets)
	ld	l,a
	ld	a,h
	adc	a, #>(_widgets)
	ld	h,a
	ld	a,-75 (ix)
	ld	(hl),a
	inc	hl
	ld	a,-74 (ix)
	ld	(hl),a
;synth.c:225: for (j = 0; j < NB_DEV; j++) {
	inc	b
	inc	b
	inc	b
	inc	-7 (ix)
	ld	a,-7 (ix)
	xor	a, #0x80
	sub	a, #0x81
	jr	C,00106$
;synth.c:223: for (i = 0; i < NB_OP; i++) {
	ld	hl,#0x0006
	add	hl,de
	ex	de,hl
	inc	c
	ld	a,c
	xor	a, #0x80
	sub	a, #0x8B
	jp	C,00108$
;synth.c:237: for (i = 0; i < NB_WIDGETS; i++) {
	ld	e,#0x00
00110$:
;synth.c:238: if (widgets[i])
	ld	a,e
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
	ld	a,b
	or	a,c
	jr	Z,00111$
;synth.c:239: widget_redraw(widgets[i]);
	push	de
	push	bc
	call	_widget_redraw
	pop	af
	pop	de
00111$:
;synth.c:237: for (i = 0; i < NB_WIDGETS; i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x98
	jr	C,00110$
	ld	sp, ix
	pop	ix
	ret
___str_11:
	.ascii "YMSoC v0.1"
	.db 0x00
___str_12:
	.ascii "CT1:"
	.db 0x00
___str_13:
	.ascii "M1C1M2C2"
	.db 0x00
___str_14:
	.ascii "Channels:"
	.db 0x00
___str_15:
	.ascii "Le"
	.db 0x00
___str_16:
	.ascii "Ri"
	.db 0x00
___str_17:
	.ascii "Connection:"
	.db 0x00
___str_18:
	.ascii "Reset LFO"
	.db 0x00
___str_19:
	.ascii "LFO Waveform:"
	.db 0x00
___str_20:
	.ascii "Frequency:"
	.db 0x00
___str_21:
	.ascii "LFO Modulation (FM/PM):"
	.db 0x00
___str_22:
	.ascii "Amplitude:"
	.db 0x00
;synth.c:247: void move_mouse() {
;	---------------------------------
; Function move_mouse
; ---------------------------------
_move_mouse::
;synth.c:250: mouse_x += (char)mouse_x_reg;
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
;synth.c:251: mouse_y -= (char)mouse_y_reg;
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
;synth.c:254: if(mouse_x < 0)   mouse_x = 0;
	ld	a,(#_mouse_x + 1)
	bit	7,a
	jr	Z,00102$
	ld	hl,#0x0000
	ld	(_mouse_x),hl
00102$:
;synth.c:255: if(mouse_x > 319) mouse_x = 319;
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
;synth.c:256: if(mouse_y < 0)   mouse_y = 0;
	ld	a,(#_mouse_y + 1)
	bit	7,a
	jr	Z,00106$
	ld	hl,#0x0000
	ld	(_mouse_y),hl
00106$:
;synth.c:257: if(mouse_y > 239)  mouse_y = 239;
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
;synth.c:260: *(unsigned char*)0x7efe = mouse_x;
	ld	a,(#_mouse_x + 0)
	ld	(#0x7EFE),a
;synth.c:261: *(unsigned char*)0x7eff = (mouse_x & 0x100) >> 8;
	ld	a,(#_mouse_x + 1)
	and	a, #0x01
	ld	d,a
	rlc	a
	sbc	a, a
	ld	hl,#0x7EFF
	ld	(hl),d
;synth.c:262: *(unsigned char*)0x7f00 = mouse_y;
	ld	a,(#_mouse_y + 0)
	ld	(#0x7F00),a
	ret
;synth.c:265: void left_click_event() {
;	---------------------------------
; Function left_click_event
; ---------------------------------
_left_click_event::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:268: for (i = 0; i < NB_WIDGETS; i++)
	ld	-1 (ix),#0x00
00107$:
;synth.c:269: if (widgets[i] && isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
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
	ld	a,b
	or	a,c
	jr	Z,00108$
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
	jr	Z,00108$
;synth.c:270: widget_event(widgets[i], EVENT_LEFT_CLICK);
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
;synth.c:271: if (widgets[i]->dirty)
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
	jr	Z,00108$
;synth.c:272: widget_redraw(widgets[i]);
	push	de
	call	_widget_redraw
	pop	af
00108$:
;synth.c:268: for (i = 0; i < NB_WIDGETS; i++)
	inc	-1 (ix)
	ld	a,-1 (ix)
	xor	a, #0x80
	sub	a, #0x98
	jr	C,00107$
	inc	sp
	pop	ix
	ret
;synth.c:276: void right_click_event() {
;	---------------------------------
; Function right_click_event
; ---------------------------------
_right_click_event::
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;synth.c:279: for (i = 0; i < NB_WIDGETS; i++)
	ld	-1 (ix),#0x00
00107$:
;synth.c:280: if (widgets[i] && isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
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
	ld	a,b
	or	a,c
	jr	Z,00108$
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
	jr	Z,00108$
;synth.c:281: widget_event(widgets[i], EVENT_RIGHT_CLICK);
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
;synth.c:282: if (widgets[i]->dirty)
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
	jr	Z,00108$
;synth.c:283: widget_redraw(widgets[i]);
	push	de
	call	_widget_redraw
	pop	af
00108$:
;synth.c:279: for (i = 0; i < NB_WIDGETS; i++)
	inc	-1 (ix)
	ld	a,-1 (ix)
	xor	a, #0x80
	sub	a, #0x98
	jr	C,00107$
	inc	sp
	pop	ix
	ret
;synth.c:293: void refresh_mouse_buttons() {
;	---------------------------------
; Function refresh_mouse_buttons
; ---------------------------------
_refresh_mouse_buttons::
;synth.c:298: prev_buttons = mouse_buttons;
	ld	a,(#_mouse_buttons + 0)
	ld	(#_refresh_mouse_buttons_prev_buttons_1_120 + 0),a
;synth.c:299: mouse_buttons = (char)mouse_but_reg;
	in	a,(_mouse_but_reg)
	ld	(#_mouse_buttons + 0),a
;synth.c:301: if (!(prev_buttons & 1) && (mouse_buttons & 1)) {
	ld	a,(#_refresh_mouse_buttons_prev_buttons_1_120 + 0)
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
;synth.c:302: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
;synth.c:303: initial_click = 1;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_120 + 0
	ld	(hl), #0x01
;synth.c:304: left_click_event();		
	jp	_left_click_event
00128$:
;synth.c:306: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	b, (hl)
	inc	b
;synth.c:305: } else if ((prev_buttons & 1) && (mouse_buttons & 1)) {
	ld	a,d
	or	a, a
	jr	Z,00124$
	ld	a,e
	or	a, a
	jr	Z,00124$
;synth.c:306: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), b
;synth.c:307: if (initial_click && (click_timer == HOLD_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_120 + 0)
	or	a, a
	jr	Z,00105$
	ld	a,(#_refresh_mouse_buttons_click_timer_1_120 + 0)
	sub	a, #0x32
	jr	NZ,00105$
;synth.c:308: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_120 + 0
	ld	(hl), #0x00
;synth.c:309: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
	ret
00105$:
;synth.c:310: } else if (!initial_click && (click_timer == REPEAT_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_120 + 0)
	or	a, a
	ret	NZ
	ld	a,(#_refresh_mouse_buttons_click_timer_1_120 + 0)
	sub	a, #0x0A
	ret	NZ
;synth.c:311: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
;synth.c:312: left_click_event();
	jp	_left_click_event
00124$:
;synth.c:314: } else if (!(prev_buttons & 2) && (mouse_buttons & 2)) {
	ld	a,(#_refresh_mouse_buttons_prev_buttons_1_120 + 0)
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
;synth.c:315: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
;synth.c:316: initial_click = 1;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_120 + 0
	ld	(hl), #0x01
;synth.c:317: right_click_event();		
	jp	_right_click_event
00120$:
;synth.c:318: } else if ((prev_buttons & 2) && (mouse_buttons & 2)) {
	ld	a,e
	or	a, a
	jr	Z,00116$
	ld	a,h
	or	a, a
	jr	Z,00116$
;synth.c:319: click_timer ++;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), b
;synth.c:320: if (initial_click && (click_timer == HOLD_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_120 + 0)
	or	a, a
	jr	Z,00112$
	ld	a,(#_refresh_mouse_buttons_click_timer_1_120 + 0)
	sub	a, #0x32
	jr	NZ,00112$
;synth.c:321: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_120 + 0
	ld	(hl), #0x00
;synth.c:322: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
	ret
00112$:
;synth.c:323: } else if (!initial_click && (click_timer == REPEAT_CLICK)) {
	ld	a,(#_refresh_mouse_buttons_initial_click_1_120 + 0)
	or	a, a
	ret	NZ
	ld	a,(#_refresh_mouse_buttons_click_timer_1_120 + 0)
	sub	a, #0x0A
	ret	NZ
;synth.c:324: click_timer = 0;
	ld	hl,#_refresh_mouse_buttons_click_timer_1_120 + 0
	ld	(hl), #0x00
;synth.c:325: right_click_event();
	jp	_right_click_event
00116$:
;synth.c:328: initial_click = 0;
	ld	hl,#_refresh_mouse_buttons_initial_click_1_120 + 0
	ld	(hl), #0x00
	ret
;synth.c:333: void vbl(void) __interrupt (0x30) {
;	---------------------------------
; Function vbl
; ---------------------------------
_vbl::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:335: move_mouse();
	call	_move_mouse
;synth.c:340: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:346: void clock50KHz(void) __interrupt (0x20) {
;	---------------------------------
; Function clock50KHz
; ---------------------------------
_clock50KHz::
	push	af
	push	bc
	push	de
	push	hl
	push	iy
;synth.c:348: refresh_mouse_buttons();
	call	_refresh_mouse_buttons
;synth.c:349: tick50Hz ++;
	ld	iy,#_tick50Hz
	inc	0 (iy)
	jr	NZ,00103$
	ld	iy,#_tick50Hz
	inc	1 (iy)
00103$:
;synth.c:354: __endasm;
	ei
	pop	iy
	pop	hl
	pop	de
	pop	bc
	pop	af
	reti
;synth.c:359: void putchar(char c) {
;	---------------------------------
; Function putchar
; ---------------------------------
_putchar::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;synth.c:360: unsigned char *dptr = (unsigned char*)(80 * (FONT_HEIGHT * cur_y) + cur_x);
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
;synth.c:362: if(c < 32) {
	ld	a,4 (ix)
	xor	a, #0x80
	sub	a, #0xA0
	jr	NC,00108$
;synth.c:363: if(c == '\r') 
	ld	a,4 (ix)
	sub	a, #0x0D
	jr	NZ,00102$
;synth.c:364: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
00102$:
;synth.c:366: if(c == '\n') {
	ld	a,4 (ix)
	sub	a, #0x0A
	jr	NZ,00115$
;synth.c:367: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:368: cur_x=0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:370: if(cur_y >= 240 / FONT_HEIGHT)
	ld	a,(#_cur_y + 0)
	sub	a, #0x28
	jr	C,00115$
;synth.c:371: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
;synth.c:373: return;
	jr	00115$
00108$:
;synth.c:376: if(c < 0) return;
	bit	7, 4 (ix)
	jr	NZ,00115$
;synth.c:378: text_char(dptr, c);
	ld	a,4 (ix)
	push	af
	inc	sp
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_text_char
	pop	af
	inc	sp
;synth.c:380: cur_x++;
	ld	hl, #_cur_x+0
	inc	(hl)
;synth.c:381: if(cur_x >= 320 / FONT_WIDTH) {
	ld	a,(#_cur_x + 0)
	sub	a, #0x50
	jr	C,00115$
;synth.c:382: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:383: cur_y++;
	ld	hl, #_cur_y+0
	inc	(hl)
;synth.c:385: if(cur_y >= 240 / FONT_HEIGHT)
	ld	a,(#_cur_y + 0)
	sub	a, #0x28
	jr	C,00115$
;synth.c:386: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
00115$:
	ld	sp, ix
	pop	ix
	ret
;synth.c:390: void cls(void) {
;	---------------------------------
; Function cls
; ---------------------------------
_cls::
;synth.c:394: for(i = 0; i < 240; i++) {
	ld	hl,#0x0000
	ld	e,l
	ld	d,h
00102$:
;synth.c:395: memset(p, 0, 80);
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
;synth.c:396: p += 80;
	ld	bc,#0x0050
	add	hl,bc
;synth.c:394: for(i = 0; i < 240; i++) {
	inc	de
	ld	a,e
	sub	a, #0xF0
	ld	a,d
	rla
	ccf
	rra
	sbc	a, #0x80
	jr	C,00102$
;synth.c:398: cur_x = 0;
	ld	hl,#_cur_x + 0
	ld	(hl), #0x00
;synth.c:399: cur_y = 0;
	ld	hl,#_cur_y + 0
	ld	(hl), #0x00
	ret
;synth.c:408: void init_interrupt_table() {
;	---------------------------------
; Function init_interrupt_table
; ---------------------------------
_init_interrupt_table::
;synth.c:420: __endasm;
	ld hl,#0x8000
	ld a,h
	ld i,a
	ld iy,#_clock50KHz
	ld (#0x8020),iy
	ld iy,#_vbl
	ld (#0x8030),iy
	ret
;synth.c:423: void ei() {
;	---------------------------------
; Function ei
; ---------------------------------
_ei::
;synth.c:428: __endasm;
	im 2
	ei
	ret
;synth.c:431: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
	dec	sp
;synth.c:433: char prev_keys, current_keys = 0;
	ld	-3 (ix),#0x00
;synth.c:435: init_interrupt_table();
	call	_init_interrupt_table
;synth.c:437: cls();
	call	_cls
;synth.c:440: for(i = 0; i < 8; i++) {
	ld	e,#0x00
00113$:
;synth.c:441: *(char*)(0x7f10+i) = cursor_data[i];
	ld	a,e
	ld	c,a
	rla
	sbc	a, a
	ld	b,a
	ld	iy,#0x7F10
	add	iy,bc
	ld	hl,#_cursor_data
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	0 (iy), a
;synth.c:442: *(char*)(0x7f18+i) = cursor_mask[i];
	ld	hl,#0x7F18
	add	hl,bc
	ld	c, l
	ld	b, h
	ld	hl,#_cursor_mask
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	ld	(bc),a
;synth.c:440: for(i = 0; i < 8; i++) {
	inc	e
	ld	a,e
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00113$
;synth.c:445: *(unsigned char*)0x7efd = 0x00;
	ld	hl,#0x7EFD
	ld	(hl),#0x00
;synth.c:447: *(unsigned char*)0x7efb = CURSOR_COLOR1;
	ld	l, #0xFB
	ld	(hl),#0xFF
;synth.c:448: *(unsigned char*)0x7efc = CURSOR_COLOR2;
	ld	l, #0xFC
	ld	(hl),#0xE0
;synth.c:451: *(unsigned char*)0x7f20 = BG_COLOR;
	ld	hl,#0x7F20
	ld	(hl),#0x4A
;synth.c:453: ym2151_init();
	call	_ym2151_init
;synth.c:456: init_ui();
	call	_init_ui
;synth.c:459: ei();
	call	_ei
;synth.c:462: do {
00110$:
;synth.c:465: prev_keys = current_keys;
	ld	c,-3 (ix)
;synth.c:466: current_keys = keys;
	in	a,(_keys)
	ld	-3 (ix),a
;synth.c:467: mask = 0x1;
;synth.c:468: for (i = 0; i < 8; i++) {
	ld	de,#0x0001
00115$:
;synth.c:469: if (!(prev_keys & mask) && (current_keys & mask)) { // key pressed
	ld	a,c
	and	a, e
	ld	-1 (ix),a
	ld	a,-3 (ix)
	and	a, e
	ld	-2 (ix),a
;synth.c:470: ym2151_setKeyNote(current_channel, 4, i);
	ld	hl,#_current_channel + 0
	ld	b, (hl)
;synth.c:469: if (!(prev_keys & mask) && (current_keys & mask)) { // key pressed
	ld	a,-1 (ix)
	or	a, a
	jr	NZ,00106$
	ld	a,-2 (ix)
	or	a, a
	jr	Z,00106$
;synth.c:470: ym2151_setKeyNote(current_channel, 4, i);
	push	bc
	push	de
	ld	e, #0x04
	push	de
	push	bc
	inc	sp
	call	_ym2151_setKeyNote
	pop	af
	inc	sp
	pop	de
	pop	bc
;synth.c:471: ym2151_setKeyState(current_channel, key_config);
	ld	hl,#_current_channel + 0
	ld	b, (hl)
	push	bc
	push	de
	ld	a,(_key_config)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setKeyState
	pop	af
	pop	de
	pop	bc
	jr	00107$
00106$:
;synth.c:472: } else if ((prev_keys & mask) && !(current_keys & mask)) { // key released
	ld	a,-1 (ix)
	or	a, a
	jr	Z,00107$
	ld	a,-2 (ix)
	or	a, a
	jr	NZ,00107$
;synth.c:473: ym2151_setKeyState(current_channel, YM_KEY_OFF);
	push	bc
	push	de
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_ym2151_setKeyState
	pop	af
	pop	de
	pop	bc
00107$:
;synth.c:475: mask <<= 1;
	sla	e
;synth.c:468: for (i = 0; i < 8; i++) {
	inc	d
	ld	a,d
	xor	a, #0x80
	sub	a, #0x88
	jr	C,00115$
;synth.c:478: } while(1);
	jr	00110$
	.area _CODE
	.area _INITIALIZER
__xinit__current_channel:
	.dw #0x0000
__xinit__key_config:
	.db #0x00	; 0
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

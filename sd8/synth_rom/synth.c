// synth.c
// Synthesizer for the SD8 SoC
// (c) 2016 Sebastien Delestaing

#include <stdio.h>
#include <string.h>
#include <stdlib.h>	// for abs()

#include "ym2151.h"
#include "widgets.h"
#include "text.h"

// $0000-$4AFF: VRAM
// $7EFB: CURSOR_COL_0
// $7EFC: CURSOR_COL_1
// $7EFD: CURSOR_HOT_POINT {4'hX,4'hY}
// $7EFE: CURSOR_X_LOW
// $7EFF: CURSOR_X_HIGH
// $7F00: CURSOR_Y
// $7F10-$7F17: CURSOR_DATA
// $7F18-$7F1F: CURSOR_MASK
// $7F20-$7F23: Palette

#define BG_COLOR 0x4A	// R:010 V:010 B:10

// I/O Ports Adresses
// PSG (YM2149)
__sfr __at 0x10 PsgAddrPort;
__sfr __at 0x11 PsgDataPort;

// Keyboard
// the key registers has two bits:
// 0 - <SPACE>
// 1 - S
// 2 - C
__sfr __at 0x20 keys;

// Mouse
__sfr __at 0x30 mouse_x_reg;
__sfr __at 0x31 mouse_y_reg;
__sfr __at 0x32 mouse_but_reg;

// FM (YM2151)
__sfr __at 0x40 FmgAddrPort;
__sfr __at 0x41 FmgDataPort;

enum {
	W_LED,
	W_M1,
	W_C1,
	W_M2,
	W_C2,
	W_CH_L,
	W_CH_R,
	W_RESET_LFO,
	W_CONNECT,
	W_LFO_WF,
	W_LFO_FREQ,
	W_LFO_MOD,
	W_LFO_AMPLITUDE,

	NB_CH_WIDGETS
};

#define NB_OP	11
#define NB_DEV	1
#define NB_OP_WIDGETS	(NB_DEV * NB_OP)
#define NB_WIDGETS	(NB_CH_WIDGETS + NB_OP_WIDGETS)

typedef struct {
	unsigned char op;
	unsigned char dev;
} T_WData;

T_Widget *widgets[NB_WIDGETS];

int current_channel = 0;
unsigned char key_config = YM_KEY_OFF;

void ct1_clicked(T_Widget *widget) {
	ym2151_setCT1(((T_Checkbox *)widget)->checked ? 1 : 0);
}

void key_config_clicked(T_Widget *widget) {
	key_config = YM_KEY_OFF;
	key_config |= ((T_Checkbox *)widgets[W_M1])->checked ? YM_KEY_MOD1 : 0x00;
	key_config |= ((T_Checkbox *)widgets[W_C1])->checked ? YM_KEY_CAR1 : 0x00;
	key_config |= ((T_Checkbox *)widgets[W_M2])->checked ? YM_KEY_MOD2 : 0x00;
	key_config |= ((T_Checkbox *)widgets[W_C2])->checked ? YM_KEY_CAR2 : 0x00;
}

void channels_config_clicked(T_Widget *widget) {
	unsigned char channels_config = 0;

	channels_config |= ((T_Checkbox *)widgets[W_CH_L])->checked ? YM_LEFT : 0x00;
	channels_config |= ((T_Checkbox *)widgets[W_CH_R])->checked ? YM_RIGHT : 0x00;
	
	ym2151_setChannels(current_channel, channels_config);
}

void reset_lfo_clicked(T_Widget *widget) {
	ym2151_resetLFO();
}

void connection_changed(T_Widget *widget) {
	ym2151_setConnections(current_channel, ((T_Spinner *)widget)->value);
}

void lfo_waveform_changed(T_Widget *widget) {
	ym2151_setLFOWaveform(((T_Spinner *)widget)->value);
}

void lfo_frequency_changed(T_Widget *widget) {
	ym2151_setLFOFrequency(((T_Spinner *)widget)->value);
}

void lfo_modulation_clicked(T_Widget *widget) {
	ym2151_setLFOModulation(((T_Checkbox *)widget)->checked ? YM_PHASE : YM_AMPLITUDE);
}

void lfo_amplitude_changed(T_Widget *widget) {
	ym2151_setLFOAmplitude(((T_Spinner *)widget)->value);
}

void op_value_changed(T_Widget *widget) {
	T_WData *data = (T_WData *)(widget->user_data);
	unsigned char value1, value2;

//	printf("op data(%x): %d, %d  \r", data, data->op, data->dev);

	switch(data->op) {
		case 0:
		case 1:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS])->value;
			value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 1])->value;
			ym2151_setDetune1PhaseMultiply(current_channel, data->dev, value1, value2); 
			break;
		case 2:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 2])->value;
			ym2151_setTotalLevel(current_channel, data->dev, value1);
			break;
		case 3:
		case 4:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 3])->value;
			value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 4])->value;
			ym2151_setKeyScalingAttackRate(current_channel, data->dev, value1, value2);
			break;
		case 5:
		case 6:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 5])->value;
			value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 6])->value;
			ym2151_setAMSEnableDecayRate1(current_channel, data->dev, value1, value2);
			break;
		case 7:
		case 8:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 7])->value;
			value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 8])->value;
			ym2151_setDetune2DecayRate2(current_channel, data->dev, value1, value2);
			break;
		case 9:
		case 10:
			value1 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 9])->value;
			value2 = ((T_Spinner *)widgets[NB_CH_WIDGETS + 10])->value;
			ym2151_setDecayLevelReleaseRate(current_channel, data->dev, value1, value2);
			break;
	}
}

void init_ui() {
	char i, j;
	char op_lbl[NB_OP][6] = {"DT1:", "MUL:", "TL:", "KS:", "AR:", "AMS:", "D1R:", "DT2:", "D2R:", "D1L:", "RR:"};

	memset(widgets, 0, sizeof(T_Widget *) * NB_WIDGETS);

	draw_label(0, 0, "YMSoC v0.1");

	draw_label(0, 2, "CT1:");
	widgets[W_LED] = (T_Widget *)new_checkbox(4, 2);
	widgets[W_LED]->callback = ct1_clicked;

	draw_label(7, 1, "M1C1M2C2");
	widgets[W_M1] = (T_Widget *)new_checkbox(7, 2);
	widgets[W_M1]->callback = key_config_clicked;
	widgets[W_C1] = (T_Widget *)new_checkbox(9, 2);
	widgets[W_C1]->callback = key_config_clicked;
	widgets[W_M2] = (T_Widget *)new_checkbox(11, 2);
	widgets[W_M2]->callback = key_config_clicked;
	widgets[W_C2] = (T_Widget *)new_checkbox(13, 2);
	widgets[W_C2]->callback = key_config_clicked;

	draw_label(16, 2, "Channels:");
	draw_label(25, 1, "Le");
	draw_label(27, 1, "Ri");
	widgets[W_CH_L] = (T_Widget *)new_checkbox(25, 2);
	widgets[W_CH_L]->callback = channels_config_clicked;
	widgets[W_CH_R] = (T_Widget *)new_checkbox(27, 2);
	widgets[W_CH_R]->callback = channels_config_clicked;

	draw_label(30, 2, "Connection:");
	widgets[W_CONNECT] = (T_Widget *)new_spinner(41, 2);
	spinner_setMax((T_Spinner *)widgets[W_CONNECT], 7);
	widgets[W_CONNECT]->callback = connection_changed;
  
	// LFO
	widgets[W_RESET_LFO] = (T_Widget *)new_button(0, 4, "Reset LFO");
	widgets[W_RESET_LFO]->callback = reset_lfo_clicked;
	draw_label(0, 5, "LFO Waveform:"); 
	widgets[W_LFO_WF] = (T_Widget *)new_spinner(13, 5);
	spinner_setMax((T_Spinner *)widgets[W_LFO_WF], 3);
	widgets[W_LFO_WF]->callback = lfo_waveform_changed;
	draw_label(16, 5, "Frequency:"); 
	widgets[W_LFO_FREQ] = (T_Widget *)new_spinner(26, 5);
	widgets[W_LFO_FREQ]->callback = lfo_frequency_changed;
	draw_label(0, 6, "LFO Modulation (FM/PM):");
	widgets[W_LFO_MOD] = (T_Widget *)new_checkbox(23, 6);
	widgets[W_LFO_MOD]->callback = lfo_modulation_clicked;
	draw_label(26, 6, "Amplitude:");
	widgets[W_LFO_AMPLITUDE] = (T_Widget *)new_spinner(36, 6);
	spinner_setMax((T_Spinner *)widgets[W_LFO_AMPLITUDE], 127);
	widgets[W_LFO_AMPLITUDE]->callback = lfo_amplitude_changed;

	// Operator Table
	for (i = 0; i < NB_OP; i++) {
		draw_label(0, 10 + i, op_lbl[i]);
		for (j = 0; j < NB_DEV; j++) {
			T_Widget *w = (T_Widget *)new_spinner(6 + j * 3, 10 + i);
			T_WData *wd = (T_WData *)malloc(sizeof(T_WData));
			wd->op = i;
			wd->dev = YM_KEY_MOD1;
			w->user_data = wd;
			w->callback = op_value_changed;
			widgets[NB_CH_WIDGETS + i * NB_DEV + j] = w;	
		}
	}

	// Draw the UI
	for (i = 0; i < NB_WIDGETS; i++) {
		if (widgets[i])
			widget_redraw(widgets[i]);
	}
}

// Mouse position global vars
int mouse_x = 160;
int mouse_y = 120;        

void move_mouse() {

	// update mouse pos
	mouse_x += (char)mouse_x_reg;
        mouse_y -= (char)mouse_y_reg;

        // limit mouse movement
        if(mouse_x < 0)   mouse_x = 0;
        if(mouse_x > 319) mouse_x = 319;
        if(mouse_y < 0)   mouse_y = 0;
        if(mouse_y > 239)  mouse_y = 239;

	// update sprite pos
	*(unsigned char*)0x7efe = mouse_x;
	*(unsigned char*)0x7eff = (mouse_x & 0x100) >> 8;
	*(unsigned char*)0x7f00 = mouse_y;
}

void left_click_event() {
	char i;

	for (i = 0; i < NB_WIDGETS; i++)
		if (widgets[i] && isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
			widget_event(widgets[i], EVENT_LEFT_CLICK);
			if (widgets[i]->dirty)
				widget_redraw(widgets[i]);
		}
}

void right_click_event() {
	char i;

	for (i = 0; i < NB_WIDGETS; i++)
		if (widgets[i] && isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
			widget_event(widgets[i], EVENT_RIGHT_CLICK);
			if (widgets[i]->dirty)
				widget_redraw(widgets[i]);
		}
}

//Mouse buttons global var
unsigned char mouse_buttons = 0;

#define HOLD_CLICK	50
#define REPEAT_CLICK	10

void refresh_mouse_buttons() {
	static unsigned char prev_buttons;
	static unsigned char click_timer;
	static unsigned char initial_click;

	prev_buttons = mouse_buttons;
	mouse_buttons = (char)mouse_but_reg;

	if (!(prev_buttons & 1) && (mouse_buttons & 1)) {
		click_timer = 0;
		initial_click = 1;
		left_click_event();		
	} else if ((prev_buttons & 1) && (mouse_buttons & 1)) {
		click_timer ++;
		if (initial_click && (click_timer == HOLD_CLICK)) {
			initial_click = 0;
			click_timer = 0;
		} else if (!initial_click && (click_timer == REPEAT_CLICK)) {
			click_timer = 0;
			left_click_event();
		}
	} else if (!(prev_buttons & 2) && (mouse_buttons & 2)) {
		click_timer = 0;
		initial_click = 1;
		right_click_event();		
	} else if ((prev_buttons & 2) && (mouse_buttons & 2)) {
		click_timer ++;
		if (initial_click && (click_timer == HOLD_CLICK)) {
			initial_click = 0;
			click_timer = 0;
		} else if (!initial_click && (click_timer == REPEAT_CLICK)) {
			click_timer = 0;
			right_click_event();
		}
	} else {
		initial_click = 0;
	}
}

// VBL
void vbl(void) __interrupt (0x30) {

	move_mouse();

	// ACK interrupt
	__asm
	ei    
	__endasm;
}

int tick50Hz = 0;

//50KHz interrupt (useful for sound replay) 
void clock50KHz(void) __interrupt (0x20) {

	refresh_mouse_buttons();
	tick50Hz ++;

	// ACK interrupt
	__asm
	ei    
	__endasm;
}

unsigned char cur_x=0, cur_y=0;

void putchar(char c) {
	unsigned char *dptr = (unsigned char*)(80 * (FONT_HEIGHT * cur_y) + cur_x);

	if(c < 32) {
		if(c == '\r') 
			cur_x=0;

		if(c == '\n') {
			cur_y++;
			cur_x=0;

			if(cur_y >= 240 / FONT_HEIGHT)
				cur_y = 0;
		}
		return;
	}

	if(c < 0) return;

	text_char(dptr, c);

	cur_x++;
	if(cur_x >= 320 / FONT_WIDTH) {
		cur_x = 0;
		cur_y++;

		if(cur_y >= 240 / FONT_HEIGHT)
			cur_y = 0;
	}
}

void cls(void) {
  int i;
  unsigned char *p = (unsigned char*)0;

  for(i = 0; i < 240; i++) {
    memset(p, 0, 80);
    p += 80;
  }
  cur_x = 0;
  cur_y = 0;
}

#define CURSOR_COLOR1 0xFF;    // white
#define CURSOR_COLOR2 0xE0;    // red

extern unsigned char cursor_data[];
extern unsigned char cursor_mask[];

void init_interrupt_table() {
	__asm
	// interrupt vector table start at 0x8000
	ld hl,#0x8000
	ld a,h
	ld i,a
	// clock50KHz is interrupt vector 0x20
	ld iy,#_clock50KHz
	ld (#0x8020),iy
	// VBL is interrupt vector 0x30
	ld iy,#_vbl
	ld (#0x8030),iy
	__endasm;
}

void ei() {
	// set interrupt mode 2,  and enable interrupts
	__asm
	im 2
	ei    
	__endasm;
}

void main() {
	char i;
	char prev_keys, current_keys = 0;

	init_interrupt_table();

	cls();

	// load cursor image into VGA controller
	for(i = 0; i < 8; i++) {
		*(char*)(0x7f10+i) = cursor_data[i];
		*(char*)(0x7f18+i) = cursor_mask[i];
	}
	// set cursor hotspot to pixel 0,0
	*(unsigned char*)0x7efd = 0x00;
	// set cursor colors
	*(unsigned char*)0x7efb = CURSOR_COLOR1;
	*(unsigned char*)0x7efc = CURSOR_COLOR2;

	// Set palette
	*(unsigned char*)0x7f20 = BG_COLOR;

	ym2151_init();

	// draw UI
	init_ui();

	// enable interrupts
	ei();

	// Enter main loop
	do {
		char mask;

		prev_keys = current_keys;
		current_keys = keys;
		mask = 0x1;
		for (i = 0; i < 8; i++) {
			if (!(prev_keys & mask) && (current_keys & mask)) { // key pressed
				ym2151_setKeyNote(current_channel, 4, i);
				ym2151_setKeyState(current_channel, key_config);
			} else if ((prev_keys & mask) && !(current_keys & mask)) { // key released
				ym2151_setKeyState(current_channel, YM_KEY_OFF);
			}
			mask <<= 1;
		}

	} while(1);

}

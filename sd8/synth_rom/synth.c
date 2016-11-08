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

void ct1_clicked(T_Widget *widget) {
	ym2151_setCT1(((T_Checkbox *)widget)->checked ? 1 : 0);
}

enum {
	W_LED,
	SPINNER1,
	CHECKBOX1,

	NB_WIDGETS
};

T_Widget *widgets[NB_WIDGETS];

void init_ui() {
	char i;

	draw_label(0, 0, "YMSoC v0.1");

	draw_label(0, 2, "CT1:");
	widgets[W_LED] = (T_Widget *)new_checkbox(5, 2);
	widgets[W_LED]->callback = ct1_clicked;
 
	draw_label(0, 4, "Value1:");
	widgets[SPINNER1] = (T_Widget *)new_spinner(10, 4);

	draw_label(0, 5, "Value2:");
	widgets[CHECKBOX1] = (T_Widget *)new_checkbox(10, 5);

	// Draw the UI
	for (i = 0; i < NB_WIDGETS; i++) {
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
		if (isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
			widget_event(widgets[i], EVENT_LEFT_CLICK);
			if (widgets[i]->dirty)
				widget_redraw(widgets[i]);
		}
}

void right_click_event() {
	char i;

	for (i = 0; i < NB_WIDGETS; i++)
		if (isInLayout(&(widgets[i]->layout), mouse_x, mouse_y)) {
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

	// draw UI
	init_ui();

	// enable interrupts
	ei();

	// Enter main loop
	do {
		char c = keys;
		char ch = 0;

		if (c & 0x1) { 	// Space
			ym2151_write(0x20, 0xC0);	// L/R
			// Setup
			ym2151_write(0x28 + ch, 0x00);
			ym2151_write(0x30 + ch, 0x00);
			ym2151_write(0x38 + ch, 0x00);
			ym2151_write(0x40 + ch, 0x00);
			ym2151_write(0x60 + ch, 0x00);
			ym2151_write(0x80 + ch, 0x00);
			ym2151_write(0xA0 + ch, 0x00);
			ym2151_write(0xC0 + ch, 0x00);
			ym2151_write(0xE0 + ch, 0x00);
		}
		if (c & 0x2) {	// S
			ym2151_setCT1(1);
			ym2151_write(0x08, 0x40);	// K_ON, MOD1, CH0

		}
		if (c & 0x4) {	// C
			ym2151_write(0x08, 0x00);	// K_OFF, CH0
		}

	} while(1);

}

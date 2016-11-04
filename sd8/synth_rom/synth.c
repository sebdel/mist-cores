// synth.c
// Synthesizer for the SD8 SoC
// (c) 2016 Sebastien Delestaing

#include <stdio.h>
#include <string.h>
#include <stdlib.h>	// for abs()
#include "pff.h"	// FAT file system 

// $0000-$4AFF: VRAM
// $7EFB: CURSOR_COL_0
// $7EFC: CURSOR_COL_1
// $7EFD: CURSOR_HOT_POINT {4'hX,4'hY}
// $7EFE: CURSOR_X_LOW
// $7EFF: CURSOR_X_HIGH
// $7F00: CURSOR_Y
// $7F10-$7F17: CURSOR_DATA
// $7F18-$7F1F: CURSOR_MASK

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


int mouse_x = 160;
int mouse_y = 120;        
unsigned char mouse_b = 0;

void move_mouse() {

	// update mouse pos
	mouse_x += (char)mouse_x_reg;
        mouse_y -= (char)mouse_y_reg;
	mouse_b = (char)mouse_but_reg;

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

// VBL
void vbl(void) __interrupt (0x30) {

    move_mouse();

  // re-enable interrupt
  __asm
    ei    
  __endasm;
}

//50KHz interrupt (useful for sound replay) 
void clock50KHz(void) __interrupt (0x20) {

  // re-enable interrupt
  __asm
    ei    
  __endasm;
}

extern unsigned char font[];

unsigned char cur_x=0, cur_y=0;

void putchar(char c) {
  unsigned char *p;
  unsigned char *dptr = (unsigned char*)(80*(8*cur_y) + 2*cur_x);
  char i;

  if(c < 32) {
    if(c == '\r') 
      cur_x=0;

    if(c == '\n') {
      cur_y++;
      cur_x=0;

      if(cur_y >= 30)
	cur_y = 0;
    }
    return;
  }

  if(c < 0) return;

  p = font+8*(unsigned char)(c-32);
  for(i=0;i<8;i++) {
    unsigned char l = *p++;

    *dptr = ( 	((l & 0x80) ? 0x03:0x00) |
		((l & 0x40) ? 0x0C:0x00) |
		((l & 0x20) ? 0x30:0x00) |
		((l & 0x10) ? 0xC0:0x00));
    *(dptr + 1) = (((l & 0x08) ? 0x03:0x00) |
		((l & 0x04) ? 0x0C:0x00) |
		((l & 0x02) ? 0x30:0x00) |
		((l & 0x01) ? 0xC0:0x00));
    dptr += 80;
  }

  cur_x++;
  if(cur_x >= 40) {
    cur_x = 0;
    cur_y++;

    if(cur_y >= 30)
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

// draw a pixel
void put_pixel(int x, unsigned char y, unsigned char color) {
  *((unsigned char*)(80*y+(x>>2))) = color;
}

void die (FRESULT rc) {
  printf("Fail rc=%u", rc);
  for (;;) ;
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

void ym2151_write(unsigned char reg, unsigned char value) {

	int i;

	for (i = 0; (FmgAddrPort & 0x80) && (i < 100); i++);
	FmgAddrPort = reg;
	FmgDataPort = value;
}

void main() {
	char i;

	init_interrupt_table();

	cls();

	printf("YM2151+YM2149 SoC ready.\r\nPress S or C...");

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

	// enable interrupts
	ei();

	// Enter main loop
	do {
		char c = keys;
		char ch = 0;

		if (c & 0x1) { 	// Space
			cls();
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
			ym2151_write(0x1B, 0xC0);
			ym2151_write(0x08, 0x40);	// K_ON, MOD1, CH0

		}
		if (c & 0x4) {	// C
			ym2151_write(0x1B, 0x00);
			ym2151_write(0x08, 0x00);	// K_OFF, CH0
		}

//		if (mouse_b & 1) 
//			printf ("left ");
//		if (mouse_b & 2) 
//			printf ("right ");
	} while(1);

}

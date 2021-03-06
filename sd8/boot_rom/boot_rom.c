// boot_rom.c
// Boot ROM for the SD8 SoC
// (c) 2016 Sebastien Delestaing

#include <stdio.h>
#include <string.h>
#include <stdlib.h>   // for abs()
#include "pff.h"

#define BUFFERS  8

#define FG_COLOR  0xFF
#define BG_COLOR  0x73
#define KEY_COLOR 0x18
#define BG_SHADOW 0x2A

const BYTE animation[] = "|/-\\";

// space for 8 sectors
DWORD frames = 0;
WORD rptr = 0xffff;
BYTE rsec = 0;

BYTE ym_buffer[BUFFERS][512];

#define CYCLE_SPEED 2
BYTE R = 254;
BYTE G = 0;
BYTE B = 0;
BYTE rgb_state = 0;

extern unsigned char curve[];
extern int curve_length;
short curve_index = 0;

// __sfr __at 0x00 Screen;
__sfr __at 0x10 PsgAddrPort;
__sfr __at 0x11 PsgDataPort;
// the key registers has two bits:
// 0 - <SPACE>
// 1 - S
// 2 - C
__sfr __at 0x20 keys;

__sfr __at 0x30 mouse_x_reg;
__sfr __at 0x31 mouse_y_reg;
__sfr __at 0x32 mouse_but_reg;

__sfr __at 0x40 FmgPsgAddrPort;
__sfr __at 0x41 FmgDataPort;

unsigned char level_a, level_b, level_c;

void cycle_colors() {

  *(unsigned char*)0x3f11 = R;
  *(unsigned char*)0x3f12 = G;
  *(unsigned char*)0x3f13 = B;

    switch (rgb_state) {
    case 0: // R->RG
        G += CYCLE_SPEED;
        if (G == 254)
            rgb_state = 1;
        break;
    case 1: // RG->G
        R -= CYCLE_SPEED;
        if (R == 0)
            rgb_state = 2;
        break;
    case 2: // G->GB
        B += CYCLE_SPEED;
        if (B == 254)
            rgb_state = 3;
        break;
    case 3: // GB->B
        G -= CYCLE_SPEED;
        if (G == 0)
            rgb_state = 4;
        break;
    case 4: // B->RB
        R += CYCLE_SPEED;
        if (R == 254)
            rgb_state = 5;
        break;
    case 5: // RB->R
        B -= CYCLE_SPEED;
        if (B == 0)
            rgb_state = 0;
        break;
    }
}

void play_music() {
    BYTE i, *p;

    // Play music
    if(frames) {
        frames--;

        // write all 14 psg sound registers
        p = ym_buffer[rsec] + rptr;

        // remember volumes for later use
        level_a = p[8] & 0x0f;
        level_b = p[9] & 0x0f;
        level_c = p[10] & 0x0f;

        // unrolled loop for min delay between register writes
        PsgAddrPort = 0; PsgDataPort = *p++;
        PsgAddrPort = 1; PsgDataPort = *p++;
        PsgAddrPort = 2; PsgDataPort = *p++;
        PsgAddrPort = 3; PsgDataPort = *p++;
        PsgAddrPort = 4; PsgDataPort = *p++;
        PsgAddrPort = 5; PsgDataPort = *p++;
        PsgAddrPort = 6; PsgDataPort = *p++;
        PsgAddrPort = 7; PsgDataPort = *p++;
        PsgAddrPort = 8; PsgDataPort = *p++;
        PsgAddrPort = 9; PsgDataPort = *p++;
        PsgAddrPort = 10; PsgDataPort = *p++;
        PsgAddrPort = 11; PsgDataPort = *p++;
        PsgAddrPort = 12; PsgDataPort = *p++;
        PsgAddrPort = 13;
        if(*p != 255) PsgDataPort = *p++;

        rptr += 16;

        // one whole sector processed?
        if(rptr == 512) {
            rsec++;
            rptr=0;

            if(rsec == BUFFERS)
                rsec = 0;
        }
    } else {
        // not playing? mute all channels
        level_a = 0;
        level_b = 0;
        level_c = 0;
        PsgAddrPort = 8;  PsgDataPort = 0;
        PsgAddrPort = 9;  PsgDataPort = 0;
        PsgAddrPort = 10; PsgDataPort = 0;
    }

}

void move_sprite() {

    *(unsigned char*)0x3efe = curve[curve_index];
    *(unsigned char*)0x3eff = curve[curve_index + 1];

    curve_index += 2;
    if (curve_index == curve_length)
        curve_index = 0;
}


// VBL
void vbl(void) __interrupt (0x30) {

    cycle_colors();
    move_sprite();

  // re-enable interrupt
  __asm
    ei    
  __endasm;
}

// YM replay is happening in the interrupt
void clock50KHz(void) __interrupt (0x20) {

    play_music();

  // re-enable interrupt
  __asm
    ei    
  __endasm;
}

extern unsigned char font[];

unsigned char cur_x=0, cur_y=0;
void putchar(char c) {
  unsigned char *p;
  unsigned char *dptr = (unsigned char*)(160*(8*cur_y) + 8*cur_x);
  char i, j;

  if(c < 32) {
    if(c == '\r') 
      cur_x=0;

    if(c == '\n') {
      cur_y++;
      cur_x=0;

      if(cur_y >= 12)
	cur_y = 0;
    }
    return;
  }

  if(c < 0) return;

  p = font+8*(unsigned char)(c-32);
  for(i=0;i<8;i++) {
    unsigned char l = *p++;
    for(j=0;j<8;j++) {
      *dptr++ = (l & 0x80) ? FG_COLOR:BG_COLOR;
      l <<= 1;
    }
    dptr += (160-8);
  }

  cur_x++;
  if(cur_x >= 20) {
    cur_x = 0;
    cur_y++;

    if(cur_y >= 12)
      cur_y = 0;
  }
}

void cls(void) {
  unsigned char i;
  unsigned char *p = (unsigned char*)0;

  for(i=0;i<100;i++) {
    memset(p, BG_COLOR, 160);
    p+=160;
  }
  cur_x = 0;
  cur_y = 0;
}

// draw a pixel
// At 160x100 pixel screen size a byte is sufficient to hold the x and
// y coordinates- Video memory begins at address 0 and is write only.
// The address space is shared with the ROM which is read only.
void put_pixel(unsigned char x, unsigned char y, unsigned char color) {
  *((unsigned char*)(160*y+x)) = color;
}

void die (FRESULT rc) {
  printf("Fail rc=%u", rc);
  for (;;) ;
}

// bresenham algorithm to draw a line
void draw_line(unsigned char x, unsigned char y, 
               unsigned char x2, unsigned char y2, 
               unsigned char color) {
  unsigned char longest, shortest, numerator, i;
  char dx1 = (x<x2)?1:-1;
  char dy1 = (y<y2)?1:-1;
  char dx2, dy2;
  
  longest = abs(x2 - x);
  shortest = abs(y2 - y);
  if(longest<shortest) {
    longest = abs(y2 - y);
    shortest = abs(x2 - x);
    dx2 = 0;            
    dy2 = dy1;
  } else {
    dx2 = dx1;
    dy2 = 0;
  }

  numerator = longest/2;
  for(i=0;i<=longest;i++) {
    put_pixel(x,y,color) ;
    if(numerator >= longest-shortest) {
      numerator += shortest ;
      numerator -= longest ;
      x += dx1;
      y += dy1;
    } else {
      numerator += shortest ;
      x += dx2;
      y += dy2;
    }
  }
}

extern unsigned char image[];

// splash is 64x45
#define SPLASH_W 64
#define SPLASH_H 45
void splash() {
    unsigned char *pimg = image;
    unsigned char *pscreen = (unsigned char*)0;
    int i;

    // center logo
    pscreen += (160 - SPLASH_W) >> 1;
    pscreen += ((100 - SPLASH_H) >> 1) * 160;

    // first 3 lines = logo
    for (i = 0; i < 3; i++) {
        memcpy (pscreen, pimg, SPLASH_W);
        pscreen += 160;
        pimg += SPLASH_W;
    }
    // following lines = logo + shadow
    for (; i < SPLASH_H; i++) {
        memcpy (pscreen, pimg, SPLASH_W);
        memset (pscreen + SPLASH_W, BG_SHADOW, 3);
        pscreen += 160;
        pimg += SPLASH_W;
    }
    // below logo = shadow
    pscreen += 3;
    for (; i < SPLASH_H + 3; i++) {
        memset (pscreen, BG_SHADOW, SPLASH_W);
        pscreen += 160;
    }

}

static unsigned char vu_meter[16] = {0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C,
                                     0x1C, 0x1C, 0x1C, 0x1C, 0xFC, 0xFC, 0xE0, 0xE0};

void display_level (char level, char line) {
    int i;
    unsigned char *ptr = 0 + line * 160;
    for (i = 0; i < 16; i++) {
        if (i < level) {
            *ptr++ = vu_meter[i];
            *ptr++ = vu_meter[i];            
        } else {
            *ptr++ = BG_COLOR;
            *ptr++ = BG_COLOR;
        }
        *ptr++;
    }
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
  FATFS fatfs;                    /* File system object */
  FRESULT rc;
  UINT bytes_read;
  BYTE wsec = 0;
  int mouse_x=80, mouse_y=50;
  int last_x = -1, last_y;
  char i;
    int prev_level_a;
    int prev_level_b;
    int prev_level_c;

   init_interrupt_table();

    // set BG color key and BG COLOR
  *(unsigned char*)0x3f10 = KEY_COLOR;
  *(unsigned char*)0x3f11 = 0x00;
  *(unsigned char*)0x3f12 = 0x00;
  *(unsigned char*)0x3f13 = 0x00;

    cls();
  splash();

  // wait for bit 0 to show up on key register
  while(!(keys & 1));

    level_a = prev_level_a = 0;
    level_b = prev_level_a = 0;
    level_c = prev_level_a = 0;

//  cls();

  // load cursor image into VGA controller
  for(i=0;i<8;i++) {
    *(char*)(0x3f00+i) = cursor_data[i];
    *(char*)(0x3f08+i) = cursor_mask[i];
  }

  // set cursor hotspot to pixel 1,0
  *(unsigned char*)0x3efd = 0x10;

  // cursor colors
  *(unsigned char*)0x3efb = CURSOR_COLOR1;
  *(unsigned char*)0x3efc = CURSOR_COLOR2;

    curve_index = 0;

  rc = pf_mount(&fatfs);
  if (rc) die(rc);

  ei();

  // open song.ym
//  printf("Opening SONG.YM...\n");
  rc = pf_open("SONG.YM");
  if(rc == FR_NO_FILE) {
    printf("File not found");
    for(;;);
  }
  if (rc) die(rc);

restart:

  // clear mouse registers by reading them
  // i = (char)mouse_x_reg;
  // i = (char)mouse_y_reg;

  // read file sector by sector
  do {
    // Wait while irq routine is playing and all sector buffers are
    // full This would be the place where we'd be doing the main
    // processing like running a game engine.

    while((wsec == rsec) && frames) {
        
    if (level_a != prev_level_a) {
        prev_level_a = level_a;
        display_level (level_a, 95);
    }
    if (level_b != prev_level_b) {
        prev_level_b = level_b;
        display_level (level_b, 97);
    }
    if (level_c != prev_level_c) {
        prev_level_c = level_c;
        display_level (level_c, 99);
    }
        #if 0        
        mouse_x += (char)mouse_x_reg;
        mouse_y -= (char)mouse_y_reg;

        // limit mouse movement
        if(mouse_x < 0)   mouse_x = 0;
        if(mouse_x > 159) mouse_x = 159;
        if(mouse_y < 0)   mouse_y = 0;
        if(mouse_y > 99)  mouse_y = 99;

        // set mouse cursor position
        *(unsigned char*)0x3efe = mouse_x;
        *(unsigned char*)0x3eff = mouse_y;
        #endif
        
    }

    rc = pf_read(ym_buffer[wsec], 512, &bytes_read);

    // No song info yet? Read and analyse header!
    if(!frames) {
      // check for file header
      if((ym_buffer[0][0] != 'Y')||(ym_buffer[0][1] != 'M')) {
	printf("No YM file!\n");
	for(;;);
      }
      
//      printf("YM version: %.4s\n", ym_buffer[0]);

      // we only support files that are not interleaved
      if(ym_buffer[0][19] & 1) {
	printf("No Interleave!\n");
	for(;;);
      }

      // we don't support digi drums
      if(ym_buffer[0][20] || ym_buffer[0][21]) {
	printf("No Digidrums!\n");
	for(;;);
      }

      // skip Song name, Author name and Song comment
      rptr = 34;
//      printf("%s\n", ym_buffer[0]+rptr);
      while(ym_buffer[0][rptr]) rptr++;  // song name
      rptr++;
//      printf("%s\n", ym_buffer[0]+rptr);
      while(ym_buffer[0][rptr]) rptr++;  // author name
      rptr++;
      while(ym_buffer[0][rptr]) rptr++;  // song comment
      rptr++;

      // extract frames
      frames = 256l*256l*256l*ym_buffer[0][12] + 256l*256l*ym_buffer[0][13] + 
	256l*ym_buffer[0][14] + ym_buffer[0][15];
//      printf("Frames: %ld\n", frames);
    }

    // circle through the sector buffers
    wsec++;
    if(wsec == BUFFERS)
      wsec = 0;

    // do some animation
//    printf("%c\r", animation[wsec&3]);

    // do this until all sectors are read
  } while((!rc) && (bytes_read == 512));

    // restart
    rc = pf_lseek ((DWORD)0);
    frames = 0;
    rptr = 0xffff;
    rsec = 0;

    goto restart;

  if (rc) die(rc);

  printf("done.\n");

  while(1);
}

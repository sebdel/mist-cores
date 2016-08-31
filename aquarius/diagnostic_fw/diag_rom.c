// diag_rom.c
// Diagnostic ROM for the Aquarius on MIST core
// (c) 2016 Sebastien Delestaing

#include <stdio.h>
#include <string.h>

__sfr __at 0xFF IoKBD;
__sfr __at 0xFE IoLED;

unsigned char cur_x=0, cur_y=1;
void putchar(char c) {
  unsigned char *dptr = (unsigned char*)(0x3000 + 80 * cur_y + cur_x);

  if(c < 32) {
    if(c == '\r') 
      cur_x=0;

    if(c == '\n') {
      cur_y++;
      cur_x=0;

      if(cur_y >= 25)
    	cur_y = 1;
    }
    return;
  }

  if(c < 0) return;

  *dptr = c;

  cur_x++;
  if(cur_x >= 40) {
    cur_x = 0;
    cur_y++;

    if(cur_y >= 25)
      cur_y = 1;
  }
}

void main() {
    char *scr = (char *)0x3000; // character buffer
    char *cscr = (char *)0x3400;    // color buffer

    IoLED = 0x01;

    // Border color = 0
    *scr = ' ';
    *cscr = 0x00;

    memset(scr, ' ', 40 * 25);
    memset(cscr + 40, 0x20, 40 * 24);
    printf("Aquarius on MiST Diagnostic v0.1\r\n");

    while(1) {
        unsigned char c = IoKBD;

        printf("KBD port: 0x%02x\r", c); 
    }
}


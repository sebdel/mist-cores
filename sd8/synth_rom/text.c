// text.c

#include "text.h"

extern unsigned char font[];

unsigned char hex[16] = {'0', '1', '2', '3', '4', '5', '6', '7',
			 '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

void text_char(unsigned char *dst, unsigned char c) {
        unsigned char *p = font + FONT_HEIGHT * (unsigned char)(c - 32);
        char i;

        for(i = 0; i < FONT_HEIGHT; i ++) {
                unsigned char l = *p++;

                *dst = (((l & 0x80) ? 0x03:0x00) |
                        ((l & 0x40) ? 0x0C:0x00) |
                        ((l & 0x20) ? 0x30:0x00) |
                        ((l & 0x10) ? 0xC0:0x00));
                dst += 80;
        }
}

void text_hex(unsigned char *dst, unsigned char value) {

        text_char(dst, hex[(value >> 4) & 0x0F]);
        text_char(dst+1, hex[value & 0xF]);
}

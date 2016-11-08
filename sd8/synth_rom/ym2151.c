// ym2151.c

#include "ym2151.h"

void _wait_busy() {
        int i;
	
	// Wait on BUSY bit
        for (i = 0; (FmgAddrPort & 0x80) && (i < 100); i++);
}

void ym2151_write(unsigned char reg, unsigned char value) {

	_wait_busy();

	FmgAddrPort = reg;
        FmgDataPort = value;
}

unsigned char ym2151_read(unsigned char reg) {
	_wait_busy();
	
	FmgAddrPort = reg;
	return FmgDataPort;
}

void ym2151_setCT1(unsigned char value) {
	unsigned char reg = ym2151_read(0x1B);
	
	ym2151_write(0x1B, value ? reg | 0x40 : reg & 0xBF);
}

void ym2151_setCT2(unsigned char value) {
	unsigned char reg = ym2151_read(0x1B);
	
	ym2151_write(0x1B, value ? reg | 0x80 : reg & 0x7F);
}

void ym2151_setLFOWaveform(E_YM_WAVEFORM wf) {
	unsigned char reg = ym2151_read(0x1B);

	ym2151_write(0x1B, (reg & 0xFC) | wf);
}

void ym2151_setLFOFrequency(unsigned char value) {
	ym2151_write(0x18, value);
}

void ym2151_setLFOModulation(E_YM_MODULATION mod) {
	unsigned char reg = ym2151_read(0x19);

	ym2151_write(0x19, (reg & 0x7F) | mod); 
}

void ym2151_setLFOAmplitude(unsigned char value) {
	unsigned char reg = ym2151_read(0x19);

	ym2151_write(0x19, (reg & 0x80) | (value & 0x7F)); 
}

void ym2151_resetLFO() {
	unsigned char reg = ym2151_read(0x01);

	ym2151_write(0x01, reg ^ 0x02);
}

void ym2151_setNoiseEnable(unsigned char value) {
	unsigned char reg = ym2151_read(0x0F);

	ym2151_write(0x0F, value ? reg | 0x80 : reg & 0x7F); 
}

void ym2151_setNoiseFrequency(unsigned char value) {
	unsigned char reg = ym2151_read(0x0F);

	ym2151_write(0x0F, (reg & 0xE0) | (value & 0x1F)); 
}

void ym2151_setKeyState(unsigned char channel, E_YM_KEY key) {
	ym2151_write(0x08, key | (channel & 0x07));
}

void ym2151_setChannels(E_YM_CHANNELS channels) {
	unsigned char reg = ym2151_read(0x20);

	ym2151_write(0x20, (reg & 0x3F) | channels);
}

void ym2151_setConnections(unsigned char connect) {
	unsigned char reg = ym2151_read(0x20);

	ym2151_write(0x20, (reg & 0xF8) | (connect & 0x07));
}

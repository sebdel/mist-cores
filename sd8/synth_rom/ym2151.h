// ym2151.h

// FM (YM2151)
__sfr __at 0x40 FmgAddrPort;
__sfr __at 0x41 FmgDataPort;

typedef enum {
	YM_SAW,		// 0
	YM_SQUARE,	// 1
	YM_TRIANGLE,	// 2
	YM_NOISE	// 3
} E_YM_WAVEFORM;

typedef enum {
	YM_AMPLITUDE 	= 0x00,
	YM_PHASE	= 0x80
} E_YM_MODULATION;

typedef enum {
	YM_KEY_OFF	= 0x00,
	YM_KEY_CAR2	= 0x08,
	YM_KEY_MOD2	= 0x10,
	YM_KEY_CAR1	= 0x20,
	YM_KEY_MOD1	= 0x40
} E_YM_KEY;

typedef enum {
	YM_LEFT		= 0x40,
	YM_RIGHT	= 0x80	
} E_YM_CHANNELS;

void ym2151_write(unsigned char reg, unsigned char value); 
unsigned char ym2151_read(unsigned char reg);

void ym2151_setCT1(unsigned char value);
void ym2151_setCT2(unsigned char value);
void ym2151_setLFOWaveform(E_YM_WAVEFORM wf);
void ym2151_setLFOFrequency(unsigned char value);
void ym2151_setLFOModulation(E_YM_MODULATION mod);
void ym2151_resetLFO();
void ym2151_setNoiseEnable(unsigned char value);
void ym2151_setNoiseFrequency(unsigned char value);
void ym2151_setKeyState(unsigned char channel, E_YM_KEY key);
void ym2151_setChannels(E_YM_CHANNELS channels);
void ym2151_setConnections(unsigned char connect);


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

struct s_ym2151_registers {
	unsigned char _0x01_;
	unsigned char _0x0F_;
	unsigned char _0x18_;
	unsigned char _0x19_;
	unsigned char _0x1B_;
	unsigned char _0x20_[8];
	unsigned char _0x38_[8];
};

void ym2151_init();
void ym2151_write(unsigned char reg, unsigned char value); 

void ym2151_setCT1(unsigned char value);
void ym2151_setCT2(unsigned char value);
void ym2151_setLFOWaveform(E_YM_WAVEFORM wf);
void ym2151_setLFOFrequency(unsigned char value);
void ym2151_setLFOModulation(E_YM_MODULATION mod);
void ym2151_setLFOAmplitude(unsigned char value);
void ym2151_resetLFO();
void ym2151_setNoiseEnable(unsigned char value);
void ym2151_setNoiseFrequency(unsigned char value);
void ym2151_setKeyState(unsigned char channel, E_YM_KEY key);
void ym2151_setKeyNote(unsigned char channel, unsigned char octave, unsigned char note);
void ym2151_setKeyFraction(unsigned char channel, unsigned char fraction);
void ym2151_setChannels(unsigned char channel, E_YM_CHANNELS channels);
void ym2151_setConnections(unsigned char channel, unsigned char connect);
void ym2151_setAmplitudeModulationSensitivity(unsigned char channel, unsigned char ams);
void ym2151_setPhaseModulationSensitivity(unsigned char channel, unsigned char pms);
void ym2151_setDetune1PhaseMultiply(unsigned char channel, E_YM_KEY key_config, unsigned char detune1, unsigned char phase_multiply);
void ym2151_setTotalLevel(unsigned char channel, E_YM_KEY key_config, unsigned char total_level);
void ym2151_setKeyScalingAttackRate(unsigned char channel, E_YM_KEY key_config, unsigned char key_scaling, unsigned char attack_rate);
void ym2151_setAMSEnableDecayRate1(unsigned char channel, E_YM_KEY key_config, unsigned char ams_enable, unsigned char decay_rate1);
void ym2151_setDetune2DecayRate2(unsigned char channel, E_YM_KEY key_config, unsigned char detune2, unsigned char decay_rate2);
void ym2151_setDecayLevelReleaseRate(unsigned char channel, E_YM_KEY key_config, unsigned char decay_level, unsigned char release_rate);


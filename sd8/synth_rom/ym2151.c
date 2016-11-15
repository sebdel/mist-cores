// ym2151.c

#include <string.h>

#include "ym2151.h"
#include "widgets.h"

struct s_ym2151_registers registers;

void dbg_print(unsigned char reg, unsigned char value, unsigned char i, unsigned char j) {
	unsigned char *dst = SCRPTR(0, 29);

	text_char(dst, 'R');
	text_hex(dst+1, reg);
	text_char(dst+3, '=');
	text_hex(dst+4, value);

	text_hex(dst+8, i);
	text_hex(dst+11, j);
}

unsigned char nb_bits(unsigned char quartet) {
	unsigned char nb[16] = {0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4};

	return nb[quartet & 0x0f];
}

unsigned char _wait_busy() {
        unsigned char i;
	
	// Wait on BUSY bit
        for (i = 0; (FmgDataPort & 0x80) && (i < 100); i++);

	return i;
}

void ym2151_init() {
	unsigned char i;

	memset(&registers, 0, sizeof(struct s_ym2151_registers));

	ym2151_write(0x01, registers._0x01_);
	ym2151_write(0x0F, registers._0x0F_);
	ym2151_write(0x18, registers._0x18_);
	ym2151_write(0x19, registers._0x19_);
	ym2151_write(0x1B, registers._0x1B_);

	for (i = 0; i < 8; i++) 
		ym2151_write(0x20 + i, registers._0x20_[i]);
}

void ym2151_write(unsigned char reg, unsigned char value) {

	unsigned char i, j;

	i = _wait_busy();
	FmgAddrPort = reg;
	FmgDataPort = value;
	
        j = _wait_busy();
	dbg_print(reg, value, i, j);

}

void ym2151_setCT1(unsigned char value) {
	registers._0x1B_ = value ? registers._0x1B_ | 0x40 : registers._0x1B_ & 0xBF;
 
	ym2151_write(0x1B, registers._0x1B_);
}

void ym2151_setCT2(unsigned char value) {
	registers._0x1B_ = value ? registers._0x1B_ | 0x80 : registers._0x1B_ & 0x7F;
 
	ym2151_write(0x1B, registers._0x1B_);
}

void ym2151_setLFOWaveform(E_YM_WAVEFORM wf) {
	registers._0x1B_ = (registers._0x1B_ & 0xFC) | wf;

	ym2151_write(0x1B, registers._0x1B_);
}

void ym2151_setLFOFrequency(unsigned char value) {
	registers._0x18_ = value;

	ym2151_write(0x18, registers._0x18_);
}

void ym2151_setLFOModulation(E_YM_MODULATION mod) {
	registers._0x19_ = (registers._0x19_ & 0x7F) | mod;

	ym2151_write(0x19, registers._0x19_); 
}

void ym2151_setLFOAmplitude(unsigned char value) {
	registers._0x19_ = (registers._0x19_ & 0x80) | (value & 0x7F);

	ym2151_write(0x19, registers._0x19_); 
}

void ym2151_resetLFO() {
	registers._0x01_ ^= 0x02;

	ym2151_write(0x01, registers._0x01_);
}

void ym2151_setNoiseEnable(unsigned char value) {
	registers._0x0F_ = value ? registers._0x0F_ | 0x80 : registers._0x0F_ & 0x7F; 

	ym2151_write(0x0F, registers._0x0F_); 
}

void ym2151_setNoiseFrequency(unsigned char value) {
	registers._0x0F_ = (registers._0x0F_ & 0xE0) | (value & 0x1F); 

	ym2151_write(0x0F, registers._0x0F_); 
}

void ym2151_setKeyState(unsigned char channel, E_YM_KEY key_config) {
	unsigned char kon_cmd = key_config | (channel & 0x07);	
	
	ym2151_write(0x08, kon_cmd);
}

void ym2151_setKeyNote(unsigned char channel, unsigned char octave, unsigned char note) {
	ym2151_write(0x28 + channel, ((octave << 4) & 0x70) | (note & 0x0F));
}

void ym2151_setKeyFraction(unsigned char channel, unsigned char fraction) {
	ym2151_write(0x30 + channel, (fraction << 2) & 0xFC);
}

void ym2151_setChannels(unsigned char channel, E_YM_CHANNELS channels) {
	registers._0x20_[channel] = (registers._0x20_[channel] & 0x3F) | channels; 

	ym2151_write(0x20 + channel, registers._0x20_[channel]);
}

void ym2151_setConnections(unsigned char channel, unsigned char connect) {
	registers._0x20_[channel] = (registers._0x20_[channel] & 0xF8) | (connect & 0x07); 

	ym2151_write(0x20 + channel, registers._0x20_[channel]);
}

void ym2151_setAmplitudeModulationSensitivity(unsigned char channel, unsigned char ams) {
	registers._0x38_[channel] = (registers._0x38_[channel] & 0xFC) | (ams & 0x03); 

	ym2151_write(0x38 + channel, registers._0x38_[channel]);
}

void ym2151_setPhaseModulationSensitivity(unsigned char channel, unsigned char pms) {
	registers._0x38_[channel] = (registers._0x38_[channel] & 0x8F) | (pms & 0x70); 

	ym2151_write(0x38 + channel, registers._0x38_[channel]);
}

void ym2151_setDetune1PhaseMultiply(unsigned char channel, E_YM_KEY key_config, unsigned char detune1, unsigned char phase_multiply) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0x40 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0x48 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0x50 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0x58 + channel, ((detune1 << 4) & 0x70) | (phase_multiply & 0x0F));
	}
}

void ym2151_setTotalLevel(unsigned char channel, E_YM_KEY key_config, unsigned char total_level) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0x60 + channel, total_level & 0x7F);
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0x68 + channel, total_level & 0x7F);
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0x70 + channel, total_level & 0x7F);
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0x78 + channel, total_level & 0x7F);
	}
}

void ym2151_setKeyScalingAttackRate(unsigned char channel, E_YM_KEY key_config, unsigned char key_scaling, unsigned char attack_rate) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0x80 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0x88 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0x90 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0x98 + channel, ((key_scaling << 6) & 0xC0) | (attack_rate & 0x1F));
	}
}

void ym2151_setAMSEnableDecayRate1(unsigned char channel, E_YM_KEY key_config, unsigned char ams_enable, unsigned char decay_rate1) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0xA0 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0xA8 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0xB0 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0xB8 + channel, (ams_enable ? 0x80 : 0x00) | (decay_rate1 & 0x1F));
	}
}

void ym2151_setDetune2DecayRate2(unsigned char channel, E_YM_KEY key_config, unsigned char detune2, unsigned char decay_rate2) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0xC0 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0xC8 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F)); 
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0xD0 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0xD8 + channel, ((detune2 << 6) & 0xC0) | (decay_rate2 & 0x0F));
	}
}

void ym2151_setDecayLevelReleaseRate(unsigned char channel, E_YM_KEY key_config, unsigned char decay_level, unsigned char release_rate) {

	if (key_config & YM_KEY_MOD1) {
		ym2151_write(0xE0 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	}
	if (key_config & YM_KEY_MOD2) {
		ym2151_write(0xE8 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	}
	if (key_config & YM_KEY_CAR1) {
		ym2151_write(0xF0 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	}
	if (key_config & YM_KEY_CAR2) {
		ym2151_write(0xF8 + channel, ((decay_level << 4) & 0xF0) | (release_rate & 0x0F));
	}
}


SDCC=sdcc
CPU=z80
CODE=synth
OBJ=$(CODE).rel ym2151.rel widgets.rel text.rel font.rel arrow_rom.rel 
ROM=synth.rom

all: $(ROM)

bin2c: bin2c.c

font.c: bin2c
	./bin2c ../art/4x6.bin font.c "const unsigned char font[]"

irqvec.rel: irqvec.s
	sdasz80 -o $@ $<

nmivec.rel: nmivec.s
	sdasz80 -o $@ $<

%.rel: %.c
	$(SDCC) -m$(CPU) -c $<

$(CODE).ihx: $(OBJ)
	$(SDCC) --data-loc 0x8100 -m$(CPU) $(OBJ)

%.hex: %.ihx
	cp $< $@

%.bin: %.hex
	srec_cat -multiple $< -intel -o $@ -binary

$(ROM): $(CODE).bin
	cp $< $@

disasm: $(CODE).bin
	z80dasm -a -t -g 0 $<

clean:
	rm -rf *~ *.asm *.ihx *.lk *.lst *.map *.noi *.rel *.sym *.part



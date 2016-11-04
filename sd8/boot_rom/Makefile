SDCC=sdcc
CPU=z80
CODE=boot_rom
TTY=/dev/ttyUSB0
OBJ=$(CODE).rel font.rel pff.rel mmc.rel image_rom.rel curve_rom.rel heart_rom.rel
ROM=sd8.rom

all: $(ROM)

bin2c: bin2c.c

font.part: font.fnt
	dd if=$< of=$@ bs=1 count=768 skip=256

font.c: font.part bin2c
	./bin2c font.part font.c "const unsigned char font[]"

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
	rm -rf *~ *.asm *.ihx *.lk *.lst *.map *.noi *.rel *.sym *.bin bin2c *.part



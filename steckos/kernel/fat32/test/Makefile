OUT_ADDRESS=0x200
DEFINES=-Dasmunit_char_out=0x200
KERNEL_ADDRESS=0x1000
CA65FLAGS=-I ../../../../asmunit -I ../../../asminc -I ../ $(DEFINES)
LIBS=../../../../asmunit/asmunit.a ../../debug/debug.a ../fat32.a
LDFLAGS=-C ../../../../asmunit/asmunit.cfg $(DEFINES)


.PHONY: all clean

all: test.fat32
clean:
	rm -f *.prg *.bin *.o *.dis *.log

%.o: %.s
	ca65 $(CA65FLAGS) $(@:.o=.s)

test.%.bin: test.%.o $(LIBS) $(<:test.%=%)
	#	ld65 $(LDFLAGS) $< ../$(<:test.%=%) $(LIBS) -o $@
	ld65 $(LDFLAGS) $< $(LIBS) -o $@

%.prg: %.o $(LIBS)
	ld65 $(LDFLAGS_PRG) $< $(LIBS_PRG) -o $@

%.dis: %.bin
	dcc6502 -o $(KERNEL_ADDRESS) -d -n -c $< > $@

%.dbg: %.bin
	py65mon -m 65c02 --output 0x0200 $< $(KERNEL_ADDRESS)

test.%: test.%.bin
	../../../../asmunit/asmunit_wrapper.sh $@.bin $(KERNEL_ADDRESS)

%: %.prg
	../../../xmodem.sh $<

%.emu: %.prg
	steckschwein-emu -rom ../../bios/bios.bin -sdcard ../../../steckos.img -upload $<
# !!! order counts !!! - kernel.o must be the first module which is linked to output file
OBJS=kernel.o 
OBJS+=io.o
OBJS+=uart.o
OBJS+=crc16_static.o
OBJS+=xmodem_upload.o
OBJS+=xmodem_upload_prg.o


OBJS+=wozmon.o
OBJS+=jumptable.o

ASM_INCLUDE=../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: kernel.bin loader.prg

clean:
	rm -f *.o *.bin *.map *.txt *.prg kernel_jumptable.inc version.inc

%.o: %.s $(ASM_INCLUDE)/*.inc version.inc
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

version.inc:
	echo -n ".byte \"`git rev-parse --short HEAD`\"" > version.inc

kernel.bin: version.inc $(OBJS) 
	ld65 -C steckschwein_kernel.cfg $(OBJS) -m kernel.map -Ln symbols.txt -o kernel.bin
	grep krn symbols.txt | egrep -v "(krn_tm|krn_ptr)" | sed "s/al 00//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" > kernel_jumptable.inc
	s=0 && for l in $$(cat kernel.map |grep fat32 -A 1|grep CODE |cut -d '=' -f3|cut -d ' ' -f1);do s=$$(($$s + 0x$$l));done && echo "fat32 size: $$s bytes"

loader.prg: kernel.bin loader.o
	ld65 -C steckschwein_prg.cfg -m loader.map loader.o -o loader.prg


transfer: loader.prg
	../../xmodem.sh loader.prg

test.bin: test.o
	cl65 --target none --config kernel.cfg test.asm -o test.bin

test:
	(cd test; make all)

emu: loader.prg
	steckschwein-emu -rom ../bios/bios.bin -sdcard ../../steckos.img -upload ../shell/shell.prg # loader.prg

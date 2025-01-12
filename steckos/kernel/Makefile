# !!! order counts !!! - kernel.o must be the first module which is linked to output file
OBJS=kernel.o 

OBJS+=uart.o
OBJS+=wozmon.o

OBJS+=jumptable.o

#OBJS+=textui.o
#OBJS+=ansi.o
#OBJS+=charset_6x8.o

ASM_INCLUDE=../asminc
LDFLAGS=-C steckschwein_kernel.cfg

# enable debug
#DEBUG += -DDEBUG_KERNEL
# debug rtc updates by kernel
#DEBUG += -DDEBUG_RTC
#DEBUG += -DV9958
#DEBUG += -DDEBUG_EXECV
#DEBUG += -DDEBUG_SPI
#DEBUG += -DDEBUG_AUTOMOUNT

.PHONY: all clean test
all: kernel.bin loader.prg

clean:
	rm -f *.o *.bin *.map *.txt kernel_jumptable.inc version.inc

%.o: %.asm $(ASM_INCLUDE)/*.inc version.inc
	ca65 --target none $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

version.inc:
	echo -n ".byte \"2.0ALPHA\"" > version.inc

	#echo -n ".byte \"`git rev-parse --short HEAD`\"" > version.inc

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

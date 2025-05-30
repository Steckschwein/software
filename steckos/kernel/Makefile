# !!! order counts !!! - kernel.o must be the first module which is linked to output file
OBJS=zeropage.o 
OBJS+=kernel.o 
OBJS+=io.o
OBJS+=via.o
OBJS+=uart.o
OBJS+=crc16_static.o
OBJS+=xmodem_upload.o
OBJS+=xmodem_upload_prg.o
OBJS+=vdp.o
OBJS+=console.o
OBJS+=spi.o
OBJS+=keyboard.o
OBJS+=sdcard.o
OBJS+=charset_6x8.o
OBJS+=wozmon.o
OBJS+=shell.o
OBJS+=fsutil.o
OBJS+=matcher.o
OBJS+=exec.o
OBJS+=jumptable.o

LIBS=fat32/fat32.a 
LIBS+=blklayer/blklayer.a
LIBS+=rtc/rtc.a

ASM_INCLUDE=../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: kernel.bin rom.bin kernel_jumptable 

clean:
	rm -f *.o *.bin *.map *.txt *.prg kernel_jumptable.inc version.inc
	(cd fat32 && make clean )
	(cd blklayer && make clean )	
	(cd rtc && make clean )

%.o: %.s $(ASM_INCLUDE)/*.inc version.inc
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

version.inc:
	echo -n ".byte \"`git rev-parse --short HEAD`\"" > version.inc

blklayer.a: 
	(cd blklayer && make )


fat32.a: 
	(cd fat32 && make )

rtc.a:
	(cd rtc && make )

kernel.bin: version.inc fat32.a rtc.a blklayer.a $(OBJS) 
	ld65 -C steckschwein_kernel.cfg $(OBJS) $(LIBS) -m kernel.map -Ln symbols.txt -o kernel.bin
#s=0 && for l in $$(cat kernel.map |grep fat32 -A 1|grep CODE |cut -d '=' -f3|cut -d ' ' -f1);do s=$$(($$s + 0x$$l));done && echo "fat32 size: $$s bytes"

kernel_jumptable: kernel.bin
	grep krn symbols.txt | egrep -v "(krn_tm|krn_ptr)" | sed "s/al 00//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" > kernel_jumptable.inc
	grep paramptr symbols.txt | sed "s/al 0000//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" >> kernel_jumptable.inc
	grep filenameptr symbols.txt | sed "s/al 0000//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" >> kernel_jumptable.inc
	grep dirptr symbols.txt | sed "s/al 0000//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" >> kernel_jumptable.inc
	grep retvec symbols.txt | sed "s/al 0000//" | awk -F' ' '{print $$2" = $$"$$1}'| sed -e "s/^\.//g" >> kernel_jumptable.inc


loader.prg: kernel.bin loader.o
	ld65 -C steckschwein_prg.cfg -m loader.map loader.o -o loader.prg


transfer: loader.prg
	../../xmodem.sh loader.prg

rom.bin: kernel.bin
	cat kernel.bin kernel.bin > rom.bin

test: all
	(cd test; make all)
	(cd fat32/test; make all)
	

emu: kernel.bin rom.bin
	../../../emulator/steckschwein-emu -rom rom.bin -log_writes rom 

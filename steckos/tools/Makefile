#CC65FLAGS=-I ../clib/include -I ../clib/ --cpu 65c02 --debug-info # --standard c89 #-Or
CA65FLAGS=-I ../asminc -I ../kernel --cpu 65c02
#LIBS=../lib/steckschwein.a
#LIBS=../kernel/zeropage.o
#CLIB=../clib/lib/steckschwein-clib.a
LDFLAGS=-C ../kernel/steckschwein_prg.cfg -m $<.map $(LIBS)

TOOLS=help.prg stat.prg

# c tools
#TOOLS+=\
#  banner.prg \
#  cat.prg \
#  date.prg\
#  crc7.prg \
  echo.prg\
  iobench.prg \
  keyboard.prg \
#  nvram.prg\
  od.prg\
  setdate.prg \
  uname.prg \
  fsinfo.prg \
	dirtest.prg \
	stecklnk.prg \
	flash_ah.prg

.PHONY: all clean

all: $(TOOLS)

clean:
	rm -f *.prg *.o *.map

%.o: %.c
	cc65 $(CC65FLAGS) $(<:.s=.c)
	ca65 $(CA65FLAGS) $(@:.o=.s)

%.o: %.s
	ca65 $(CA65FLAGS) $(@:.o=.s)

%.prg: %.o $(LIBS) $(CLIB)
	ld65 $< $(CLIB) $(LDFLAGS) -o $@

%.dis: %.prg
	dcc6502 -o 0x0ffe -d -n -c $< > $@

%: %.prg
	../../xmodem.sh $<

%.emu: %.prg
#	6502msx-emu -rom ../bios/bios.bin -sdcard ../../steckos.img -log_writes rom -upload $<
	6502msx-emu -rom ../bios/bios.bin -sdcard ../../steckos.img -log_writes rom -upload $<


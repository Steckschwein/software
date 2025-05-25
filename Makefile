MAKEFILE=Makefile
all: build

clean:
	(cd steckos; make clean)
	(cd asmunit; make clean)
	(cd doc; make clean)
	rm -f steckos.img

build:
	cd asmunit && make
	cd steckos && make

test: build
	(cd steckos; make test)

img: build
	./mkimg.sh

doc: build 
	util/asmdoc.py -d steckos/kernel/ --format md --title kernel -f doc/kernel.md --filespec="*.s"


emu: build img
	steckschwein-emu -rom steckos/kernel/rom.bin -sdcard steckos.img

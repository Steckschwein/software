MAKEFILE=Makefile
all: doc 

clean:
	rm -f *.md

doc:
	../util/asmdoc.py -d ../steckos/kernel/ --format md --title kernel -f kernel.md --filespec="*.s"

MAKEFILE=Makefile
all: build

clean:
	(cd tools && make clean)
	(cd kernel && make clean)

build:
	(cd kernel && make)
	(cd tools && make)

test: build
	(cd kernel && make test)


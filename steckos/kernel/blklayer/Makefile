OBJS=blklayer.o

ASM_INCLUDE=../../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: blklayer.a

clean:
	rm -f *.o *.a 

%.o: %.s $(ASM_INCLUDE)/*.inc 
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

blklayer.a: $(OBJS) 
	ar65 a blklayer.a $(OBJS)
	
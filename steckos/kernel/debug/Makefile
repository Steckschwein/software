OBJS=debug.o

ASM_INCLUDE=../../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: debug.a

clean:
	rm -f *.o *.a 

%.o: %.s $(ASM_INCLUDE)/*.inc 
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

%.a: $(OBJS) 
	ar65 a $@ $(OBJS)
	
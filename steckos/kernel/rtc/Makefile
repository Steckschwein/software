OBJS=rtc.o
OBJS+=rtc_irq.o 
OBJS+=rtc_nvram_write.o
OBJS+=rtc_util.o
LIBNAME=rtc.a


ASM_INCLUDE=../../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: $(LIBNAME)

clean:
	rm -f *.o *.a 

%.o: %.s $(ASM_INCLUDE)/*.inc 
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

$(LIBNAME): $(OBJS) 
	ar65 a $(LIBNAME) $(OBJS)
	
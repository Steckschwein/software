OBJS=fat32_core.o
OBJS+=fat32_cwd.o
OBJS+=fat32_dir.o
OBJS+=fat32_legacy.o
OBJS+=fat32_mount.o
OBJS+=fat32.o
OBJS+=fat32_seek.o
OBJS+=fat32_write_dir.o
OBJS+=fat32_write.o
OBJS+=fat_fread_vollgas.o

ASM_INCLUDE=../../asminc
LDFLAGS=-C steckschwein_kernel.cfg

.PHONY: all clean test
all: fat32.a

clean:
	rm -f *.o *.a 

%.o: %.s $(ASM_INCLUDE)/*.inc 
	ca65 --target none --cpu 65c02 $(DEFINES) $(DEBUG) $(OPT) -I $(ASM_INCLUDE) $<

fat32.a: $(OBJS) 
	ar65 a fat32.a $(OBJS)
	
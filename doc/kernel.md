# kernel

[console](#console) | [fat32](#fat32) | [io](#io) | [jumptable](#jumptable) | [kernel](#kernel) | [keyboard](#keyboard) | [sdcard](#sdcard) | [spi](#spi) | [uart](#uart) | [vdp](#vdp) | [xmodem_upload](#xmodem_upload) | [zeropage](#zeropage) | [zp_ext](#zp_ext) | 
***


## console
[console_chrout](#console_chrout) | [console_clear_screenbuf](#console_clear_screenbuf) | [console_cursor_down](#console_cursor_down) | [console_cursor_right](#console_cursor_right) | [console_get_pointer_from_cursor](#console_get_pointer_from_cursor) | [console_handle_control_char](#console_handle_control_char) | [console_init](#console_init) | [console_put_cursor](#console_put_cursor) | [console_putchar](#console_putchar) | [console_scroll](#console_scroll) | [console_set_screen_buffer](#console_set_screen_buffer) | [console_update_screen](#console_update_screen) | 

***



### <a name="console_chrout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L318">console_chrout</a>

#### Description
print character in A at current cursor position.\
handle ANSI ESC sequences



#### Parameters

In
: A - character to print







***


#### Example

    lda #'A'

    jsr console_chrout





### <a name="console_clear_screenbuf" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L127">console_clear_screenbuf</a>

#### Description
clear screenbuffer area pointed to by cursor_ptr



#### Parameters

In
: console_ptr - address of buffer







***





### <a name="console_cursor_down" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L273">console_cursor_down</a>

#### Description
move cursor down by 1 row, scroll screen buffer when reached row 24




***





### <a name="console_cursor_right" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L289">console_cursor_right</a>

#### Description
increase cursor x position. wrap around when x = 80.



#### Parameters

In
: crs_x - cursor x position<br />crs_y - cursor y position


Out
: crs_x - cursor x position<br />crs_y - cursor y position






***





### <a name="console_get_pointer_from_cursor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L167">console_get_pointer_from_cursor</a>

#### Description
calculate screen buffer address for cursor position in crs_x/crs_y



#### Parameters

In
: crs_x - cursor x position<br />crs_y - cursor y position







***





### <a name="console_handle_control_char" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L511">console_handle_control_char</a>

#### Description
handle control character in A.



#### Parameters

In
: A - control char<br />crs_x - cursor x position<br />crs_y - cursor y position







***





### <a name="console_init" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L20">console_init</a>

#### Description
init console




***





### <a name="console_put_cursor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L204">console_put_cursor</a>

#### Description
place cursor at position pointed to by crs_x/crs_y



#### Parameters

In
: crs_x - cursor x position<br />crs_y - cursor y position







***





### <a name="console_putchar" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L457">console_putchar</a>

#### Description
print character in A at current cursor position. handle CR/LF.



#### Parameters

In
: A - character to print<br />crs_x - cursor x position<br />crs_y - cursor y position







***





### <a name="console_scroll" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L576">console_scroll</a>

#### Description
scroll screen buffer up 1 row




***





### <a name="console_set_screen_buffer" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L57">console_set_screen_buffer</a>

#### Description
switch to screen buffer number in A



#### Parameters

In
: A - screen buffer number to switch to







***





### <a name="console_update_screen" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L95">console_update_screen</a>

#### Description
update vdp text screen memory with contents from console buffer




***






## fat32
[fat_chdir](#fat_chdir) | [fat_close](#fat_close) | [fat_fopen](#fat_fopen) | [fat_fread_byte](#fat_fread_byte) | [fat_fread_vollgas](#fat_fread_vollgas) | [fat_fseek](#fat_fseek) | [fat_get_root_and_pwd](#fat_get_root_and_pwd) | [fat_mkdir](#fat_mkdir) | [fat_mount](#fat_mount) | [fat_opendir](#fat_opendir) | [fat_read_direntry](#fat_read_direntry) | [fat_readdir](#fat_readdir) | [fat_rmdir](#fat_rmdir) | [fat_unlink](#fat_unlink) | [fat_update_direntry](#fat_update_direntry) | [fat_write_byte](#fat_write_byte) | 

***



### <a name="fat_chdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L64">fat_chdir</a>

#### Description
change current directory



#### Parameters

In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory (which is FD_INDEX_CURRENT_DIR)






***





### <a name="fat_close" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L221">fat_close</a>

#### Description
close file, update dir entry and free file descriptor quietly



#### Parameters

In
: X, index into fd_area of the opened file


Out
: C, 0 on success, 1 on error<br />A, error code






***





### <a name="fat_fopen" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L174">fat_fopen</a>

#### Description
open file



#### Parameters

In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path<br />Y, file mode constants O_RDONLY = $01, O_WRONLY = $02, O_RDWR = $03, O_CREAT = $10, O_TRUNC = $20, O_APPEND = $40, O_EXCL = $80


Out
: C, 0 on success, 1 on error<br />A, error code<br />X, index into fd_area of the opened file






***





### <a name="fat_fread_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L101">fat_fread_byte</a>

#### Description
read byte from file



#### Parameters

In
: X, offset into fd_area


Out
: C=0 on success and A=received byte, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached






***





### <a name="fat_fread_vollgas" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat_fread_vollgas.s#L26">fat_fread_vollgas</a>

#### Description
read the file denoted by given file descriptor (X) until EOF and store data at given address (A/Y)



#### Parameters

In
: X - offset into fd_area<br />A/Y - pointer to target address


Out
: C=0 on success, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached






***





### <a name="fat_fseek" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_seek.s#L24">fat_fseek</a>

#### Description
seek n bytes within file denoted by the given FD



#### Parameters

In
: X - offset into fd_area<br />A/Y - pointer to seek_struct - @see fat32.inc


Out
: C=0 on success (A=0), C=1 and A=<error code> or C=1 and A=0 (EOK) if EOF reached<br />






***





### <a name="fat_get_root_and_pwd" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_cwd.s#L33">fat_get_root_and_pwd</a>

#### Description
get current directory



#### Parameters

In
: A, low byte of address to write the current work directory string into<br />Y, high byte address to write the current work directory string into<br />X, size of result buffer pointet to by A/X


Out
: C, 0 on success, 1 on error<br />A, error code






***





### <a name="fat_mkdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L76">fat_mkdir</a>

#### Description
create directory denoted by given path in A/X



#### Parameters

In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code






***





### <a name="fat_mount" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_mount.s#L19">fat_mount</a>

#### Description
mount fat32 file system



#### Parameters


Out
: C, 0 on success, 1 on error<br />A, error code






***





### <a name="fat_opendir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L42">fat_opendir</a>

#### Description
open directory by given path starting from directory given as file descriptor



#### Parameters

In
: A/X - pointer to string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory






***





### <a name="fat_read_direntry" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L143">fat_read_direntry</a>

#### Description
readdir expects a pointer in A/Y to store the F32DirEntry structure representing the requested FAT32 directory entry for the given fd (X).



#### Parameters

In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached






***





### <a name="fat_readdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L81">fat_readdir</a>

#### Description
readdir expects a pointer in A/Y to store the next F32DirEntry structure representing the next FAT32 directory entry in the directory stream pointed of directory X.



#### Parameters

In
: X - file descriptor to fd_area of the directory<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached






***





### <a name="fat_rmdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L51">fat_rmdir</a>

#### Description
delete a directory entry denoted by given path in A/X



#### Parameters

In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code






***





### <a name="fat_unlink" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L544">fat_unlink</a>

#### Description
unlink (delete) a file denoted by given path in A/X



#### Parameters

In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise






***





### <a name="fat_update_direntry" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L246">fat_update_direntry</a>

#### Description
update direntry given as pointer (A/Y) to FAT32 directory entry structure for file fd (X).



#### Parameters

In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to direntry buffer with updated direntry data of type F32DirEntry


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached






***





### <a name="fat_write_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L57">fat_write_byte</a>

#### Description
write byte to file



#### Parameters

In
: A, byte to write<br />X, offset into fs area


Out
: C, 0 on success, 1 on error






***






## io
[hexout](#hexout) | [primm](#primm) | 

***



### <a name="hexout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L15">hexout</a>

#### Description
print value in A as 2 hex digits\
Output string on active output device



#### Parameters

In
: A - value to print<br />A, lowbyte  of string address<br />X, highbyte of string address







***





### <a name="primm" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L69">primm</a>

#### Description
print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm




***






## jumptable
[krn_chrin](#krn_chrin) | [krn_chrout](#krn_chrout) | [krn_primm](#krn_primm) | [krn_set_input](#krn_set_input) | [krn_set_output](#krn_set_output) | [krn_upload](#krn_upload) | 

***



### <a name="krn_chrin" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L11">krn_chrin</a>

#### Description
read character from current input device into A



#### Parameters


Out
: A - received character






***





### <a name="krn_chrout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L16">krn_chrout</a>

#### Description
print character in A to current output device



#### Parameters

In
: A - character to print







***





### <a name="krn_primm" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L21">krn_primm</a>

#### Description
print immediate




***





### <a name="krn_set_input" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L33">krn_set_input</a>

#### Description
set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



#### Parameters

In
: A - device id to be set







***





### <a name="krn_set_output" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L28">krn_set_output</a>

#### Description
set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



#### Parameters

In
: A - device id to be set







***





### <a name="krn_upload" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L51">krn_upload</a>

#### Description
start XMODEM upload




***






## kernel
[do_irq](#do_irq) | [do_nmi](#do_nmi) | [io_null](#io_null) | [set_input](#set_input) | [set_output](#set_output) | 

***



### <a name="do_irq" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L180">do_irq</a>

#### Description
system irq handler




***





### <a name="do_nmi" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L205">do_nmi</a>

#### Description
system nmi handler




***





### <a name="io_null" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L287">io_null</a>

#### Description
dummy routine to suppress output




***





### <a name="set_input" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L304">set_input</a>

#### Description
set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



#### Parameters

In
: A - device id to be set







***





### <a name="set_output" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L292">set_output</a>

#### Description
set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



#### Parameters

In
: A - device id to be set







***






## keyboard
[fetchkey](#fetchkey) | [getkey](#getkey) | 

***



### <a name="fetchkey" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L29">fetchkey</a>

#### Description
fetch byte from keyboard controller



#### Parameters


Out
: A, fetched key / error code<br />C, 1 - key was fetched, 0 - nothing fetched






***





### <a name="getkey" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L57">getkey</a>

#### Description
get byte from keyboard buffer



#### Parameters


Out
: A, fetched key<br />C, 1 - key was fetched, 0 - nothing fetched






***






## sdcard
[sd_busy_wait](#sd_busy_wait) | [sd_cmd](#sd_cmd) | [sd_deselect_card](#sd_deselect_card) | [sd_read_block](#sd_read_block) | [sd_select_card](#sd_select_card) | [sd_wait](#sd_wait) | [sd_write_block](#sd_write_block) | [sdcard_init](#sdcard_init) | 

***



### <a name="sd_busy_wait" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L356">sd_busy_wait</a>

#### Description
wait while sd card is busy



#### Parameters


Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y





***





### <a name="sd_cmd" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L190">sd_cmd</a>

#### Description
send command to sd card



#### Parameters

In
: A, command byte<br />sd_cmd_param, command parameters


Out
: A, SD Card R1 status byte


Clobbers
: A,X,Y





***





### <a name="sd_deselect_card" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L264">sd_deselect_card</a>

#### Description
Read block from SD Card



#### Parameters


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: X





***





### <a name="sd_read_block" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L243">sd_read_block</a>

#### Description
Read block from SD Card



#### Parameters

In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y





***





### <a name="sd_select_card" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L345">sd_select_card</a>

#### Description
select sd card, pull CS line to low with busy wait



#### Parameters


Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y





***





### <a name="sd_wait" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L319">sd_wait</a>

#### Description
wait for sd card data token



#### Parameters


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y





***





### <a name="sd_write_block" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L411">sd_write_block</a>

#### Description
Write block to SD Card



#### Parameters

In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y





***





### <a name="sdcard_init" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L28">sdcard_init</a>

#### Description
initialize sd card in SPI mode



#### Parameters


Out
: Z,1 on success, 0 on error<br />A, error code


Clobbers
: A,X,Y





***






## spi
[spi_deselect](#spi_deselect) | [spi_r_byte](#spi_r_byte) | [spi_rw_byte](#spi_rw_byte) | [spi_select_device](#spi_select_device) | 

***



### <a name="spi_deselect" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L21">spi_deselect</a>

#### Description
deselect all SPI devices




***





### <a name="spi_r_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L35">spi_r_byte</a>

#### Description
read byte via SPI



#### Parameters


Out
: A, received byte


Clobbers
: A,X





***





### <a name="spi_rw_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L71">spi_rw_byte</a>

#### Description
transmit byte via SPI



#### Parameters

In
: A, byte to transmit


Out
: A, received byte


Clobbers
: A,X,Y





***





### <a name="spi_select_device" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L102">spi_select_device</a>

#### Description
select spi device given in A. the method is aware of the current processor state, especially the interrupt flag



#### Parameters

In
: ; A, spi device, one of devices see spi.inc


Out
: Z = 1 spi for given device could be selected (not busy), Z=0 otherwise






***






## uart
[init_uart](#init_uart) | [uart_rx](#uart_rx) | [uart_tx](#uart_tx) | 

***



### <a name="init_uart" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L11">init_uart</a>

#### Description
init UART to 115200 baud, 8N1



#### Parameters

In
: -


Out
: -






***





### <a name="uart_rx" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L77">uart_rx</a>

#### Description
receive byte, no wait, set carry and store in A when received



#### Parameters

In
: -


Out
: A - received byte






***





### <a name="uart_tx" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L41">uart_tx</a>

#### Description
send byte in A



#### Parameters

In
: A - byte to be sent


Out
: 






***






## vdp
[vdp_bgcolor](#vdp_bgcolor) | [vdp_fill](#vdp_fill) | [vdp_fills](#vdp_fills) | [vdp_init_reg](#vdp_init_reg) | [vdp_memcpy](#vdp_memcpy) | [vdp_set_reg](#vdp_set_reg) | [vdp_text_blank](#vdp_text_blank) | [vdp_text_on](#vdp_text_on) | 

***



### <a name="vdp_bgcolor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L96">vdp_bgcolor</a>

#### Description




#### Parameters

In
: A - color







***





### <a name="vdp_fill" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L68">vdp_fill</a>

#### Description
fill vdp VRAM with given value page wise



#### Parameters

In
: A - byte to fill<br />X - amount of 256byte blocks (page counter)







***





### <a name="vdp_fills" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L84">vdp_fills</a>

#### Description
fill vdp VRAM with given value



#### Parameters

In
: A - value to write<br />X - amount of bytes







***





### <a name="vdp_init_reg" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L136">vdp_init_reg</a>

#### Description
setup video registers upon given table starting from register #R.X down to #R0



#### Parameters

In
: X - length of init table, corresponds to video register to start R#+X - e.g. X=10 start with R#10<br />A/Y - pointer to vdp init table







***





### <a name="vdp_memcpy" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L33">vdp_memcpy</a>

#### Description
copy data from host memory denoted by pointer (A/Y) to vdp VRAM (page wise). the VRAM address must be setup beforehand e.g. with macro vdp_vram_w <address>



#### Parameters

In
: X - amount of 256byte blocks (page counter)<br />A/Y - pointer to source data







***





### <a name="vdp_set_reg" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L101">vdp_set_reg</a>

#### Description
set value to vdp register



#### Parameters

In
: A - value<br />Y - register







***





### <a name="vdp_text_blank" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L54">vdp_text_blank</a>

#### Description
text mode blank screen and color vram




***





### <a name="vdp_text_on" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L113">vdp_text_on</a>

#### Description
text mode - 40x24/80x24 character mode, 2 colors



#### Parameters

In
: A - color settings (#R07)







***






## xmodem_upload
[b2ad](#b2ad) | [xmodem_upload_callback](#xmodem_upload_callback) | 

***



### <a name="b2ad" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//fsutil.s#L257">b2ad</a>

#### Description
output 8bit value as 2 digit decimal



#### Parameters

In
: A, value to output







***





### <a name="xmodem_upload_callback" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//xmodem_upload.s#L128">xmodem_upload_callback</a>

#### Description




#### Parameters

In
: A/X pointer to block receive callback - the receive callback is called with A - block number, X - offset to data in received block


Out
: C=0 on success, C=1 on any i/o or protocoll related error






***






## zeropage
[cmdptr](#cmdptr) | [console_ptr](#console_ptr) | [cursor_ptr](#cursor_ptr) | [dirptr](#dirptr) | [dumpvecs](#dumpvecs) | [filenameptr](#filenameptr) | [in_vector](#in_vector) | [out_vector](#out_vector) | [paramptr](#paramptr) | [pathptr](#pathptr) | [retvec](#retvec) | [scroll_src_ptr](#scroll_src_ptr) | [scroll_trg_ptr](#scroll_trg_ptr) | [sd_blkptr](#sd_blkptr) | [spi_sr](#spi_sr) | [startaddr](#startaddr) | [tmp_ptr](#tmp_ptr) | [vdp_ptr](#vdp_ptr) | [volatile_tmp](#volatile_tmp) | [volatile_tmp2](#volatile_tmp2) | 

***



### <a name="cmdptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L106">cmdptr</a>

#### Description
shell buffer pointer




***





### <a name="console_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L60">console_ptr</a>

#### Description
pointer to current screen buffer




***





### <a name="cursor_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L65">cursor_ptr</a>

#### Description
pointer to cursor position within screen buffer




***





### <a name="dirptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L133">dirptr</a>

#### Description
directory pointer




***





### <a name="dumpvecs" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L128">dumpvecs</a>

#### Description
shell dump command vectors (2 pointer)




***





### <a name="filenameptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L138">filenameptr</a>

#### Description
filename pointer




***





### <a name="in_vector" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L47">in_vector</a>

#### Description
vector pointing to standard input routine




***





### <a name="out_vector" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L42">out_vector</a>

#### Description
vector pointing to standard output routine




***





### <a name="paramptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L96">paramptr</a>

#### Description
shell parameter pointer




***





### <a name="pathptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L123">pathptr</a>

#### Description
path pointer




***





### <a name="retvec" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L91">retvec</a>

#### Description
shell return vector




***





### <a name="scroll_src_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L71">scroll_src_ptr</a>

#### Description
scroll source pointer




***





### <a name="scroll_trg_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L76">scroll_trg_ptr</a>

#### Description
scroll target pointer




***





### <a name="sd_blkptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L143">sd_blkptr</a>

#### Description
sd card block pointer




***





### <a name="spi_sr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L86">spi_sr</a>

#### Description
SPI shift register




***





### <a name="startaddr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L53">startaddr</a>

#### Description
startaddress for uploaded images




***





### <a name="tmp_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L148">tmp_ptr</a>

#### Description
temp volatile pointer for general usage




***





### <a name="vdp_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L81">vdp_ptr</a>

#### Description
vdp pointer




***





### <a name="volatile_tmp" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L112">volatile_tmp</a>

#### Description
volatile tmp location




***





### <a name="volatile_tmp2" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L117">volatile_tmp2</a>

#### Description
volatile tmp location 2




***






## zp_ext
[crs_x](#crs_x) | [crs_x_sav](#crs_x_sav) | [crs_y](#crs_y) | [crs_y_sav](#crs_y_sav) | [current_console](#current_console) | [keyboard_key](#keyboard_key) | [lba_addr](#lba_addr) | [screen_status](#screen_status) | [vdp_addr](#vdp_addr) | [vdp_addr_old](#vdp_addr_old) | 

***



### <a name="crs_x" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L186">crs_x</a>

#### Description
cursor x position




***





### <a name="crs_x_sav" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L195">crs_x_sav</a>

#### Description
cursor x position save location\
1 byte per console




***





### <a name="crs_y" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L190">crs_y</a>

#### Description
cursor y position




***





### <a name="crs_y_sav" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L201">crs_y_sav</a>

#### Description
cursor y position save location\
1 byte per console




***





### <a name="current_console" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L222">current_console</a>

#### Description
number of current virtual console




***





### <a name="keyboard_key" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L233">keyboard_key</a>

#### Description
value of last pressed key




***





### <a name="lba_addr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L176">lba_addr</a>

#### Description
LBA address for media block operations




***





### <a name="screen_status" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L217">screen_status</a>

#### Description
state of screen - bit 7 -> dirty




***





### <a name="vdp_addr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L207">vdp_addr</a>

#### Description
cursor position vdp address




***





### <a name="vdp_addr_old" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L212">vdp_addr_old</a>

#### Description
previous cursor position vdp address




***






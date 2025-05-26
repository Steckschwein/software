# kernel

[console](#console) | [fat32](#fat32) | [io](#io) | [jumptable](#jumptable) | [kernel](#kernel) | [keyboard](#keyboard) | [sdcard](#sdcard) | [spi](#spi) | [uart](#uart) | [vdp](#vdp) | [xmodem_upload](#xmodem_upload) | [zeropage](#zeropage) | [zp_ext](#zp_ext) | 
***


## console
[console_chrout](#console_chrout) | [console_clear_screenbuf](#console_clear_screenbuf) | [console_cursor_down](#console_cursor_down) | [console_cursor_right](#console_cursor_right) | [console_get_pointer_from_cursor](#console_get_pointer_from_cursor) | [console_handle_control_char](#console_handle_control_char) | [console_init](#console_init) | [console_put_cursor](#console_put_cursor) | [console_putchar](#console_putchar) | [console_scroll](#console_scroll) | [console_set_screen_buffer](#console_set_screen_buffer) | [console_update_screen](#console_update_screen) | 

***



### [console_chrout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L328){target="_blank"}

> print character in A at current cursor position. handle ANSI ESC sequences



In
: A - character to print



***


### [console_clear_screenbuf](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L137){target="_blank"}

> clear screenbuffer area pointed to by cursor_ptr



In
: console_ptr - address of buffer



***


### [console_cursor_down](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L283){target="_blank"}

> move cursor down by 1 row, scroll screen buffer when reached row 24





***


### [console_cursor_right](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L299){target="_blank"}

> increase cursor x position. wrap around when x = 80.



In
: crs_x - cursor x position<br />crs_y - cursor y position


Out
: crs_x - cursor x position<br />crs_y - cursor y position


***


### [console_get_pointer_from_cursor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L177){target="_blank"}

> calculate screen buffer address for cursor position in crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***


### [console_handle_control_char](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L518){target="_blank"}

> handle control character in A.



In
: A - control char<br />crs_x - cursor x position<br />crs_y - cursor y position



***


### [console_init](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L30){target="_blank"}

> init console





***


### [console_put_cursor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L214){target="_blank"}

> place cursor at position pointed to by crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***


### [console_putchar](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L464){target="_blank"}

> print character in A at current cursor position. handle CR/LF.



In
: A - character to print<br />crs_x - cursor x position<br />crs_y - cursor y position



***


### [console_scroll](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L583){target="_blank"}

> scroll screen buffer up 1 row





***


### [console_set_screen_buffer](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L67){target="_blank"}

> switch to screen buffer number in A



In
: A - screen buffer number to switch to



***


### [console_update_screen](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L105){target="_blank"}

> update vdp text screen memory with contents from console buffer





***


## fat32
[fat_chdir](#fat_chdir) | [fat_close](#fat_close) | [fat_fopen](#fat_fopen) | [fat_fread_byte](#fat_fread_byte) | [fat_fread_vollgas](#fat_fread_vollgas) | [fat_fseek](#fat_fseek) | [fat_get_root_and_pwd](#fat_get_root_and_pwd) | [fat_mkdir](#fat_mkdir) | [fat_mount](#fat_mount) | [fat_opendir](#fat_opendir) | [fat_read_direntry](#fat_read_direntry) | [fat_readdir](#fat_readdir) | [fat_rmdir](#fat_rmdir) | [fat_unlink](#fat_unlink) | [fat_update_direntry](#fat_update_direntry) | [fat_write_byte](#fat_write_byte) | 

***



### [fat_chdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L64){target="_blank"}

> change current directory



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory (which is FD_INDEX_CURRENT_DIR)


***


### [fat_close](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L221){target="_blank"}

> close file, update dir entry and free file descriptor quietly



In
: X, index into fd_area of the opened file


Out
: C, 0 on success, 1 on error<br />A, error code


***


### [fat_fopen](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L174){target="_blank"}

> open file



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path<br />Y, file mode constants O_RDONLY = $01, O_WRONLY = $02, O_RDWR = $03, O_CREAT = $10, O_TRUNC = $20, O_APPEND = $40, O_EXCL = $80


Out
: C, 0 on success, 1 on error<br />A, error code<br />X, index into fd_area of the opened file


***


### [fat_fread_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L101){target="_blank"}

> read byte from file



In
: X, offset into fd_area


Out
: C=0 on success and A=received byte, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached


***


### [fat_fread_vollgas](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat_fread_vollgas.s#L26){target="_blank"}

> read the file denoted by given file descriptor (X) until EOF and store data at given address (A/Y)



In
: X - offset into fd_area<br />A/Y - pointer to target address


Out
: C=0 on success, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached


***


### [fat_fseek](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_seek.s#L24){target="_blank"}

> seek n bytes within file denoted by the given FD



In
: X - offset into fd_area<br />A/Y - pointer to seek_struct - @see fat32.inc


Out
: C=0 on success (A=0), C=1 and A=<error code> or C=1 and A=0 (EOK) if EOF reached<br />


***


### [fat_get_root_and_pwd](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_cwd.s#L33){target="_blank"}

> get current directory



In
: A, low byte of address to write the current work directory string into<br />Y, high byte address to write the current work directory string into<br />X, size of result buffer pointet to by A/X


Out
: C, 0 on success, 1 on error<br />A, error code


***


### [fat_mkdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L76){target="_blank"}

> create directory denoted by given path in A/X



In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code


***


### [fat_mount](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_mount.s#L19){target="_blank"}

> mount fat32 file system




Out
: C, 0 on success, 1 on error<br />A, error code


***


### [fat_opendir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L42){target="_blank"}

> open directory by given path starting from directory given as file descriptor



In
: A/X - pointer to string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory


***


### [fat_read_direntry](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L143){target="_blank"}

> readdir expects a pointer in A/Y to store the F32DirEntry structure representing the requested FAT32 directory entry for the given fd (X).



In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### [fat_readdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L81){target="_blank"}

> readdir expects a pointer in A/Y to store the next F32DirEntry structure representing the next FAT32 directory entry in the directory stream pointed of directory X.



In
: X - file descriptor to fd_area of the directory<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### [fat_rmdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L51){target="_blank"}

> delete a directory entry denoted by given path in A/X



In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code


***


### [fat_unlink](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L544){target="_blank"}

> unlink (delete) a file denoted by given path in A/X



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise


***


### [fat_update_direntry](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L246){target="_blank"}

> update direntry given as pointer (A/Y) to FAT32 directory entry structure for file fd (X).



In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to direntry buffer with updated direntry data of type F32DirEntry


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### [fat_write_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L57){target="_blank"}

> write byte to file



In
: A, byte to write<br />X, offset into fs area


Out
: C, 0 on success, 1 on error


***


## io
[hexout](#hexout) | [primm](#primm) | 

***



### [hexout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L15){target="_blank"}

> print value in A as 2 hex digitsOutput string on active output device



In
: A - value to print<br />A, lowbyte  of string address<br />X, highbyte of string address



***


### [primm](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L69){target="_blank"}

> print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm





***


## jumptable
[krn_chrin](#krn_chrin) | [krn_chrout](#krn_chrout) | [krn_primm](#krn_primm) | [krn_set_input](#krn_set_input) | [krn_set_output](#krn_set_output) | [krn_upload](#krn_upload) | 

***



### [krn_chrin](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L11){target="_blank"}

> read character from current input device into A




Out
: A - received character


***


### [krn_chrout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L16){target="_blank"}

> print character in A to current output device



In
: A - character to print



***


### [krn_primm](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L21){target="_blank"}

> print immediate





***


### [krn_set_input](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L33){target="_blank"}

> set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### [krn_set_output](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L28){target="_blank"}

> set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### [krn_upload](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L51){target="_blank"}

> start XMODEM upload





***


## kernel
[do_irq](#do_irq) | [do_nmi](#do_nmi) | [io_null](#io_null) | [set_input](#set_input) | [set_output](#set_output) | 

***



### [do_irq](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L180){target="_blank"}

> system irq handler





***


### [do_nmi](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L205){target="_blank"}

> system nmi handler





***


### [io_null](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L287){target="_blank"}

> dummy routine to suppress output





***


### [set_input](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L304){target="_blank"}

> set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### [set_output](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L292){target="_blank"}

> set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


## keyboard
[fetchkey](#fetchkey) | [getkey](#getkey) | 

***



### [fetchkey](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L28){target="_blank"}

> fetch byte from keyboard controller




Out
: A, fetched key / error code<br />C, 1 - key was fetched, 0 - nothing fetched


***


### [getkey](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L56){target="_blank"}

> get byte from keyboard buffer




Out
: A, fetched key<br />C, 1 - key was fetched, 0 - nothing fetched


***


## sdcard
[sd_busy_wait](#sd_busy_wait) | [sd_cmd](#sd_cmd) | [sd_deselect_card](#sd_deselect_card) | [sd_read_block](#sd_read_block) | [sd_select_card](#sd_select_card) | [sd_wait](#sd_wait) | [sd_write_block](#sd_write_block) | [sdcard_init](#sdcard_init) | 

***



### [sd_busy_wait](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L356){target="_blank"}

> wait while sd card is busy




Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y

***


### [sd_cmd](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L190){target="_blank"}

> send command to sd card



In
: A, command byte<br />sd_cmd_param, command parameters


Out
: A, SD Card R1 status byte


Clobbers
: A,X,Y

***


### [sd_deselect_card](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L264){target="_blank"}

> Read block from SD Card




Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: X

***


### [sd_read_block](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L243){target="_blank"}

> Read block from SD Card



In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### [sd_select_card](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L345){target="_blank"}

> select sd card, pull CS line to low with busy wait




Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y

***


### [sd_wait](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L319){target="_blank"}

> wait for sd card data token




Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### [sd_write_block](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L411){target="_blank"}

> Write block to SD Card



In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### [sdcard_init](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L28){target="_blank"}

> initialize sd card in SPI mode




Out
: Z,1 on success, 0 on error<br />A, error code


Clobbers
: A,X,Y

***


## spi
[spi_deselect](#spi_deselect) | [spi_r_byte](#spi_r_byte) | [spi_rw_byte](#spi_rw_byte) | [spi_select_device](#spi_select_device) | 

***



### [spi_deselect](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L21){target="_blank"}

> deselect all SPI devices





***


### [spi_r_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L35){target="_blank"}

> read byte via SPI




Out
: A, received byte


Clobbers
: A,X

***


### [spi_rw_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L71){target="_blank"}

> transmit byte via SPI



In
: A, byte to transmit


Out
: A, received byte


Clobbers
: A,X,Y

***


### [spi_select_device](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L102){target="_blank"}

> select spi device given in A. the method is aware of the current processor state, especially the interrupt flag



In
: ; A, spi device, one of devices see spi.inc


Out
: Z = 1 spi for given device could be selected (not busy), Z=0 otherwise


***


## uart
[init_uart](#init_uart) | [uart_rx](#uart_rx) | [uart_tx](#uart_tx) | 

***



### [init_uart](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L11){target="_blank"}

> init UART to 115200 baud, 8N1



In
: -


Out
: -


***


### [uart_rx](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L77){target="_blank"}

> receive byte, no wait, set carry and store in A when received



In
: -


Out
: A - received byte


***


### [uart_tx](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L41){target="_blank"}

> send byte in A



In
: A - byte to be sent


Out
: 


***


## vdp
[vdp_bgcolor](#vdp_bgcolor) | [vdp_fill](#vdp_fill) | [vdp_fills](#vdp_fills) | [vdp_init_reg](#vdp_init_reg) | [vdp_memcpy](#vdp_memcpy) | [vdp_set_reg](#vdp_set_reg) | [vdp_text_blank](#vdp_text_blank) | [vdp_text_on](#vdp_text_on) | 

***



### [vdp_bgcolor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L96){target="_blank"}

> 



In
: A - color



***


### [vdp_fill](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L68){target="_blank"}

> fill vdp VRAM with given value page wise



In
: A - byte to fill<br />X - amount of 256byte blocks (page counter)



***


### [vdp_fills](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L84){target="_blank"}

> fill vdp VRAM with given value



In
: A - value to write<br />X - amount of bytes



***


### [vdp_init_reg](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L136){target="_blank"}

> setup video registers upon given table starting from register #R.X down to #R0



In
: X - length of init table, corresponds to video register to start R#+X - e.g. X=10 start with R#10<br />A/Y - pointer to vdp init table



***


### [vdp_memcpy](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L33){target="_blank"}

> copy data from host memory denoted by pointer (A/Y) to vdp VRAM (page wise). the VRAM address must be setup beforehand e.g. with macro vdp_vram_w <address>



In
: X - amount of 256byte blocks (page counter)<br />A/Y - pointer to source data



***


### [vdp_set_reg](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L101){target="_blank"}

> set value to vdp register



In
: A - value<br />Y - register



***


### [vdp_text_blank](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L54){target="_blank"}

> text mode blank screen and color vram





***


### [vdp_text_on](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L113){target="_blank"}

> text mode - 40x24/80x24 character mode, 2 colors



In
: A - color settings (#R07)



***


## xmodem_upload
[b2ad](#b2ad) | [xmodem_upload_callback](#xmodem_upload_callback) | 

***



### [b2ad](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//fsutil.s#L257){target="_blank"}

> output 8bit value as 2 digit decimal



In
: A, value to output



***


### [xmodem_upload_callback](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//xmodem_upload.s#L128){target="_blank"}

> 



In
: A/X pointer to block receive callback - the receive callback is called with A - block number, X - offset to data in received block


Out
: C=0 on success, C=1 on any i/o or protocoll related error


***


## zeropage
[cmdptr](#cmdptr) | [console_ptr](#console_ptr) | [cursor_ptr](#cursor_ptr) | [dirptr](#dirptr) | [dumpvecs](#dumpvecs) | [filenameptr](#filenameptr) | [in_vector](#in_vector) | [out_vector](#out_vector) | [paramptr](#paramptr) | [pathptr](#pathptr) | [retvec](#retvec) | [scroll_src_ptr](#scroll_src_ptr) | [scroll_trg_ptr](#scroll_trg_ptr) | [sd_blkptr](#sd_blkptr) | [spi_sr](#spi_sr) | [startaddr](#startaddr) | [tmp_ptr](#tmp_ptr) | [vdp_ptr](#vdp_ptr) | [volatile_tmp](#volatile_tmp) | [volatile_tmp2](#volatile_tmp2) | 

***



### [cmdptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L106){target="_blank"}

> shell buffer pointer





***


### [console_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L60){target="_blank"}

> pointer to current screen buffer





***


### [cursor_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L65){target="_blank"}

> pointer to cursor position within screen buffer





***


### [dirptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L133){target="_blank"}

> directory pointer





***


### [dumpvecs](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L128){target="_blank"}

> shell dump command vectors (2 pointer)





***


### [filenameptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L138){target="_blank"}

> filename pointer





***


### [in_vector](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L47){target="_blank"}

> vector pointing to standard input routine





***


### [out_vector](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L42){target="_blank"}

> vector pointing to standard output routine





***


### [paramptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L96){target="_blank"}

> shell parameter pointer





***


### [pathptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L123){target="_blank"}

> path pointer





***


### [retvec](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L91){target="_blank"}

> shell return vector





***


### [scroll_src_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L71){target="_blank"}

> scroll source pointer





***


### [scroll_trg_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L76){target="_blank"}

> scroll target pointer





***


### [sd_blkptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L143){target="_blank"}

> sd card block pointer





***


### [spi_sr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L86){target="_blank"}

> SPI shift register





***


### [startaddr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L53){target="_blank"}

> startaddress for uploaded images





***


### [tmp_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L148){target="_blank"}

> temp volatile pointer for general usage





***


### [vdp_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L81){target="_blank"}

> vdp pointer





***


### [volatile_tmp](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L112){target="_blank"}

> volatile tmp location





***


### [volatile_tmp2](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L117){target="_blank"}

> volatile tmp location 2





***


## zp_ext
[lba_addr](#lba_addr) | 

***



### [lba_addr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L176){target="_blank"}

> LBA address for media block operations





***


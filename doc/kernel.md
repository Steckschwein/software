# kernel

[console](#console) | [fat32](#fat32) | [io](#io) | [jumptable](#jumptable) | [kernel](#kernel) | [keyboard](#keyboard) | [sdcard](#sdcard) | [spi](#spi) | [uart](#uart) | [vdp](#vdp) | [xmodem_upload](#xmodem_upload) | [zeropage](#zeropage) | [zp_ext](#zp_ext) | 
***


## console
[console_chrout](#console_chrout) | [console_clear_screenbuf](#console_clear_screenbuf) | [console_cursor_down](#console_cursor_down) | [console_cursor_right](#console_cursor_right) | [console_get_pointer_from_cursor](#console_get_pointer_from_cursor) | [console_handle_control_char](#console_handle_control_char) | [console_init](#console_init) | [console_put_cursor](#console_put_cursor) | [console_putchar](#console_putchar) | [console_scroll](#console_scroll) | [console_set_screen_buffer](#console_set_screen_buffer) | [console_update_screen](#console_update_screen) | 

***



### <a name="console_chrout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L328">console_chrout</a>
### [console_chrout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L328){:target="_blank"}

> print character in A at current cursor position. handle ANSI ESC sequences



In
: A - character to print



***


### <a name="console_clear_screenbuf" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L137">console_clear_screenbuf</a>
### [console_clear_screenbuf](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L137){:target="_blank"}

> clear screenbuffer area pointed to by cursor_ptr



In
: console_ptr - address of buffer



***


### <a name="console_cursor_down" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L283">console_cursor_down</a>
### [console_cursor_down](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L283){:target="_blank"}

> move cursor down by 1 row, scroll screen buffer when reached row 24





***


### <a name="console_cursor_right" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L299">console_cursor_right</a>
### [console_cursor_right](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L299){:target="_blank"}

> increase cursor x position. wrap around when x = 80.



In
: crs_x - cursor x position<br />crs_y - cursor y position


Out
: crs_x - cursor x position<br />crs_y - cursor y position


***


### <a name="console_get_pointer_from_cursor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L177">console_get_pointer_from_cursor</a>
### [console_get_pointer_from_cursor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L177){:target="_blank"}

> calculate screen buffer address for cursor position in crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***


### <a name="console_handle_control_char" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L518">console_handle_control_char</a>
### [console_handle_control_char](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L518){:target="_blank"}

> handle control character in A.



In
: A - control char<br />crs_x - cursor x position<br />crs_y - cursor y position



***


### <a name="console_init" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L30">console_init</a>
### [console_init](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L30){:target="_blank"}

> init console





***


### <a name="console_put_cursor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L214">console_put_cursor</a>
### [console_put_cursor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L214){:target="_blank"}

> place cursor at position pointed to by crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***


### <a name="console_putchar" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L464">console_putchar</a>
### [console_putchar](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L464){:target="_blank"}

> print character in A at current cursor position. handle CR/LF.



In
: A - character to print<br />crs_x - cursor x position<br />crs_y - cursor y position



***


### <a name="console_scroll" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L583">console_scroll</a>
### [console_scroll](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L583){:target="_blank"}

> scroll screen buffer up 1 row





***


### <a name="console_set_screen_buffer" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L67">console_set_screen_buffer</a>
### [console_set_screen_buffer](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L67){:target="_blank"}

> switch to screen buffer number in A



In
: A - screen buffer number to switch to



***


### <a name="console_update_screen" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L105">console_update_screen</a>
### [console_update_screen](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//console.s#L105){:target="_blank"}

> update vdp text screen memory with contents from console buffer





***


## fat32
[fat_chdir](#fat_chdir) | [fat_close](#fat_close) | [fat_fopen](#fat_fopen) | [fat_fread_byte](#fat_fread_byte) | [fat_fread_vollgas](#fat_fread_vollgas) | [fat_fseek](#fat_fseek) | [fat_get_root_and_pwd](#fat_get_root_and_pwd) | [fat_mkdir](#fat_mkdir) | [fat_mount](#fat_mount) | [fat_opendir](#fat_opendir) | [fat_read_direntry](#fat_read_direntry) | [fat_readdir](#fat_readdir) | [fat_rmdir](#fat_rmdir) | [fat_unlink](#fat_unlink) | [fat_update_direntry](#fat_update_direntry) | [fat_write_byte](#fat_write_byte) | 

***



### <a name="fat_chdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L64">fat_chdir</a>
### [fat_chdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L64){:target="_blank"}

> change current directory



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory (which is FD_INDEX_CURRENT_DIR)


***


### <a name="fat_close" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L221">fat_close</a>
### [fat_close](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L221){:target="_blank"}

> close file, update dir entry and free file descriptor quietly



In
: X, index into fd_area of the opened file


Out
: C, 0 on success, 1 on error<br />A, error code


***


### <a name="fat_fopen" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L174">fat_fopen</a>
### [fat_fopen](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L174){:target="_blank"}

> open file



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path<br />Y, file mode constants O_RDONLY = $01, O_WRONLY = $02, O_RDWR = $03, O_CREAT = $10, O_TRUNC = $20, O_APPEND = $40, O_EXCL = $80


Out
: C, 0 on success, 1 on error<br />A, error code<br />X, index into fd_area of the opened file


***


### <a name="fat_fread_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L101">fat_fread_byte</a>
### [fat_fread_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32.s#L101){:target="_blank"}

> read byte from file



In
: X, offset into fd_area


Out
: C=0 on success and A=received byte, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached


***


### <a name="fat_fread_vollgas" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat_fread_vollgas.s#L26">fat_fread_vollgas</a>
### [fat_fread_vollgas](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat_fread_vollgas.s#L26){:target="_blank"}

> read the file denoted by given file descriptor (X) until EOF and store data at given address (A/Y)



In
: X - offset into fd_area<br />A/Y - pointer to target address


Out
: C=0 on success, C=1 on error and A=error code or C=1 and A=0 (EOK) if EOF is reached


***


### <a name="fat_fseek" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_seek.s#L24">fat_fseek</a>
### [fat_fseek](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_seek.s#L24){:target="_blank"}

> seek n bytes within file denoted by the given FD



In
: X - offset into fd_area<br />A/Y - pointer to seek_struct - @see fat32.inc


Out
: C=0 on success (A=0), C=1 and A=<error code> or C=1 and A=0 (EOK) if EOF reached<br />


***


### <a name="fat_get_root_and_pwd" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_cwd.s#L33">fat_get_root_and_pwd</a>
### [fat_get_root_and_pwd](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_cwd.s#L33){:target="_blank"}

> get current directory



In
: A, low byte of address to write the current work directory string into<br />Y, high byte address to write the current work directory string into<br />X, size of result buffer pointet to by A/X


Out
: C, 0 on success, 1 on error<br />A, error code


***


### <a name="fat_mkdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L76">fat_mkdir</a>
### [fat_mkdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L76){:target="_blank"}

> create directory denoted by given path in A/X



In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code


***


### <a name="fat_mount" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_mount.s#L19">fat_mount</a>
### [fat_mount](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_mount.s#L19){:target="_blank"}

> mount fat32 file system




Out
: C, 0 on success, 1 on error<br />A, error code


***


### <a name="fat_opendir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L42">fat_opendir</a>
### [fat_opendir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L42){:target="_blank"}

> open directory by given path starting from directory given as file descriptor



In
: A/X - pointer to string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise<br />X, index into fd_area of the opened directory


***


### <a name="fat_read_direntry" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L143">fat_read_direntry</a>
### [fat_read_direntry](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L143){:target="_blank"}

> readdir expects a pointer in A/Y to store the F32DirEntry structure representing the requested FAT32 directory entry for the given fd (X).



In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### <a name="fat_readdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L81">fat_readdir</a>
### [fat_readdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_dir.s#L81){:target="_blank"}

> readdir expects a pointer in A/Y to store the next F32DirEntry structure representing the next FAT32 directory entry in the directory stream pointed of directory X.



In
: X - file descriptor to fd_area of the directory<br />A/Y - pointer to target buffer which must be .sizeof(F32DirEntry)


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### <a name="fat_rmdir" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L51">fat_rmdir</a>
### [fat_rmdir](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L51){:target="_blank"}

> delete a directory entry denoted by given path in A/X



In
: A, low byte of pointer to directory string<br />X, high byte of pointer to directory string


Out
: C, 0 on success, 1 on error<br />A, error code


***


### <a name="fat_unlink" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L544">fat_unlink</a>
### [fat_unlink](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L544){:target="_blank"}

> unlink (delete) a file denoted by given path in A/X



In
: A, low byte of pointer to zero terminated string with the file path<br />X, high byte of pointer to zero terminated string with the file path


Out
: C, C=0 on success (A=0), C=1 and A=<error code> otherwise


***


### <a name="fat_update_direntry" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L246">fat_update_direntry</a>
### [fat_update_direntry](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write_dir.s#L246){:target="_blank"}

> update direntry given as pointer (A/Y) to FAT32 directory entry structure for file fd (X).



In
: X - file descriptor to fd_area of the file<br />A/Y - pointer to direntry buffer with updated direntry data of type F32DirEntry


Out
: C - C = 0 on success (A=0), C = 1 and A = <error code> otherwise. C=1/A=EOK if end of directory is reached


***


### <a name="fat_write_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L57">fat_write_byte</a>
### [fat_write_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel/fat32/fat32_write.s#L57){:target="_blank"}

> write byte to file



In
: A, byte to write<br />X, offset into fs area


Out
: C, 0 on success, 1 on error


***


## io
[hexout](#hexout) | [primm](#primm) | 

***



### <a name="hexout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L15">hexout</a>
### [hexout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L15){:target="_blank"}

> print value in A as 2 hex digitsOutput string on active output device



In
: A - value to print<br />A, lowbyte  of string address<br />X, highbyte of string address



***


### <a name="primm" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L69">primm</a>
### [primm](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//io.s#L69){:target="_blank"}

> print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm





***


## jumptable
[krn_chrin](#krn_chrin) | [krn_chrout](#krn_chrout) | [krn_primm](#krn_primm) | [krn_set_input](#krn_set_input) | [krn_set_output](#krn_set_output) | [krn_upload](#krn_upload) | 

***



### <a name="krn_chrin" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L11">krn_chrin</a>
### [krn_chrin](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L11){:target="_blank"}

> read character from current input device into A




Out
: A - received character


***


### <a name="krn_chrout" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L16">krn_chrout</a>
### [krn_chrout](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L16){:target="_blank"}

> print character in A to current output device



In
: A - character to print



***


### <a name="krn_primm" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L21">krn_primm</a>
### [krn_primm](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L21){:target="_blank"}

> print immediate





***


### <a name="krn_set_input" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L33">krn_set_input</a>
### [krn_set_input](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L33){:target="_blank"}

> set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### <a name="krn_set_output" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L28">krn_set_output</a>
### [krn_set_output](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L28){:target="_blank"}

> set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### <a name="krn_upload" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L51">krn_upload</a>
### [krn_upload](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//jumptable.s#L51){:target="_blank"}

> start XMODEM upload





***


## kernel
[do_irq](#do_irq) | [do_nmi](#do_nmi) | [io_null](#io_null) | [set_input](#set_input) | [set_output](#set_output) | 

***



### <a name="do_irq" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L180">do_irq</a>
### [do_irq](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L180){:target="_blank"}

> system irq handler





***


### <a name="do_nmi" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L205">do_nmi</a>
### [do_nmi](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L205){:target="_blank"}

> system nmi handler





***


### <a name="io_null" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L287">io_null</a>
### [io_null](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L287){:target="_blank"}

> dummy routine to suppress output





***


### <a name="set_input" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L304">set_input</a>
### [set_input](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L304){:target="_blank"}

> set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


### <a name="set_output" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L292">set_output</a>
### [set_output](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//kernel.s#L292){:target="_blank"}

> set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



In
: A - device id to be set



***


## keyboard
[fetchkey](#fetchkey) | [getkey](#getkey) | 

***



### <a name="fetchkey" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L28">fetchkey</a>
### [fetchkey](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L28){:target="_blank"}

> fetch byte from keyboard controller




Out
: A, fetched key / error code<br />C, 1 - key was fetched, 0 - nothing fetched


***


### <a name="getkey" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L56">getkey</a>
### [getkey](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//keyboard.s#L56){:target="_blank"}

> get byte from keyboard buffer




Out
: A, fetched key<br />C, 1 - key was fetched, 0 - nothing fetched


***


## sdcard
[sd_busy_wait](#sd_busy_wait) | [sd_cmd](#sd_cmd) | [sd_deselect_card](#sd_deselect_card) | [sd_read_block](#sd_read_block) | [sd_select_card](#sd_select_card) | [sd_wait](#sd_wait) | [sd_write_block](#sd_write_block) | [sdcard_init](#sdcard_init) | 

***



### <a name="sd_busy_wait" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L356">sd_busy_wait</a>
### [sd_busy_wait](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L356){:target="_blank"}

> wait while sd card is busy




Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y

***


### <a name="sd_cmd" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L190">sd_cmd</a>
### [sd_cmd](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L190){:target="_blank"}

> send command to sd card



In
: A, command byte<br />sd_cmd_param, command parameters


Out
: A, SD Card R1 status byte


Clobbers
: A,X,Y

***


### <a name="sd_deselect_card" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L264">sd_deselect_card</a>
### [sd_deselect_card](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L264){:target="_blank"}

> Read block from SD Card




Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: X

***


### <a name="sd_read_block" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L243">sd_read_block</a>
### [sd_read_block](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L243){:target="_blank"}

> Read block from SD Card



In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### <a name="sd_select_card" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L345">sd_select_card</a>
### [sd_select_card](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L345){:target="_blank"}

> select sd card, pull CS line to low with busy wait




Out
: C, C = 0 on success, C = 1 on error (timeout)


Clobbers
: A,X,Y

***


### <a name="sd_wait" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L319">sd_wait</a>
### [sd_wait](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L319){:target="_blank"}

> wait for sd card data token




Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### <a name="sd_write_block" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L411">sd_write_block</a>
### [sd_write_block](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L411){:target="_blank"}

> Write block to SD Card



In
: lba_addr, LBA address of block<br />sd_blkptr, target adress for the block data to be read


Out
: A, error code<br />C, 0 - success, 1 - error


Clobbers
: A,X,Y

***


### <a name="sdcard_init" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L28">sdcard_init</a>
### [sdcard_init](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//sdcard.s#L28){:target="_blank"}

> initialize sd card in SPI mode




Out
: Z,1 on success, 0 on error<br />A, error code


Clobbers
: A,X,Y

***


## spi
[spi_deselect](#spi_deselect) | [spi_r_byte](#spi_r_byte) | [spi_rw_byte](#spi_rw_byte) | [spi_select_device](#spi_select_device) | 

***



### <a name="spi_deselect" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L21">spi_deselect</a>
### [spi_deselect](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L21){:target="_blank"}

> deselect all SPI devices





***


### <a name="spi_r_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L35">spi_r_byte</a>
### [spi_r_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L35){:target="_blank"}

> read byte via SPI




Out
: A, received byte


Clobbers
: A,X

***


### <a name="spi_rw_byte" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L71">spi_rw_byte</a>
### [spi_rw_byte](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L71){:target="_blank"}

> transmit byte via SPI



In
: A, byte to transmit


Out
: A, received byte


Clobbers
: A,X,Y

***


### <a name="spi_select_device" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L102">spi_select_device</a>
### [spi_select_device](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//spi.s#L102){:target="_blank"}

> select spi device given in A. the method is aware of the current processor state, especially the interrupt flag



In
: ; A, spi device, one of devices see spi.inc


Out
: Z = 1 spi for given device could be selected (not busy), Z=0 otherwise


***


## uart
[init_uart](#init_uart) | [uart_rx](#uart_rx) | [uart_tx](#uart_tx) | 

***



### <a name="init_uart" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L11">init_uart</a>
### [init_uart](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L11){:target="_blank"}

> init UART to 115200 baud, 8N1



In
: -


Out
: -


***


### <a name="uart_rx" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L77">uart_rx</a>
### [uart_rx](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L77){:target="_blank"}

> receive byte, no wait, set carry and store in A when received



In
: -


Out
: A - received byte


***


### <a name="uart_tx" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L41">uart_tx</a>
### [uart_tx](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//uart.s#L41){:target="_blank"}

> send byte in A



In
: A - byte to be sent


Out
: 


***


## vdp
[vdp_bgcolor](#vdp_bgcolor) | [vdp_fill](#vdp_fill) | [vdp_fills](#vdp_fills) | [vdp_init_reg](#vdp_init_reg) | [vdp_memcpy](#vdp_memcpy) | [vdp_set_reg](#vdp_set_reg) | [vdp_text_blank](#vdp_text_blank) | [vdp_text_on](#vdp_text_on) | 

***



### <a name="vdp_bgcolor" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L96">vdp_bgcolor</a>
### [vdp_bgcolor](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L96){:target="_blank"}

> 



In
: A - color



***


### <a name="vdp_fill" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L68">vdp_fill</a>
### [vdp_fill](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L68){:target="_blank"}

> fill vdp VRAM with given value page wise



In
: A - byte to fill<br />X - amount of 256byte blocks (page counter)



***


### <a name="vdp_fills" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L84">vdp_fills</a>
### [vdp_fills](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L84){:target="_blank"}

> fill vdp VRAM with given value



In
: A - value to write<br />X - amount of bytes



***


### <a name="vdp_init_reg" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L136">vdp_init_reg</a>
### [vdp_init_reg](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L136){:target="_blank"}

> setup video registers upon given table starting from register #R.X down to #R0



In
: X - length of init table, corresponds to video register to start R#+X - e.g. X=10 start with R#10<br />A/Y - pointer to vdp init table



***


### <a name="vdp_memcpy" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L33">vdp_memcpy</a>
### [vdp_memcpy](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L33){:target="_blank"}

> copy data from host memory denoted by pointer (A/Y) to vdp VRAM (page wise). the VRAM address must be setup beforehand e.g. with macro vdp_vram_w <address>



In
: X - amount of 256byte blocks (page counter)<br />A/Y - pointer to source data



***


### <a name="vdp_set_reg" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L101">vdp_set_reg</a>
### [vdp_set_reg](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L101){:target="_blank"}

> set value to vdp register



In
: A - value<br />Y - register



***


### <a name="vdp_text_blank" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L54">vdp_text_blank</a>
### [vdp_text_blank](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L54){:target="_blank"}

> text mode blank screen and color vram





***


### <a name="vdp_text_on" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L113">vdp_text_on</a>
### [vdp_text_on](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//vdp.s#L113){:target="_blank"}

> text mode - 40x24/80x24 character mode, 2 colors



In
: A - color settings (#R07)



***


## xmodem_upload
[b2ad](#b2ad) | [xmodem_upload_callback](#xmodem_upload_callback) | 

***



### <a name="b2ad" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//fsutil.s#L257">b2ad</a>
### [b2ad](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//fsutil.s#L257){:target="_blank"}

> output 8bit value as 2 digit decimal



In
: A, value to output



***


### <a name="xmodem_upload_callback" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//xmodem_upload.s#L128">xmodem_upload_callback</a>
### [xmodem_upload_callback](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//xmodem_upload.s#L128){:target="_blank"}

> 



In
: A/X pointer to block receive callback - the receive callback is called with A - block number, X - offset to data in received block


Out
: C=0 on success, C=1 on any i/o or protocoll related error


***


## zeropage
[cmdptr](#cmdptr) | [console_ptr](#console_ptr) | [cursor_ptr](#cursor_ptr) | [dirptr](#dirptr) | [dumpvecs](#dumpvecs) | [filenameptr](#filenameptr) | [in_vector](#in_vector) | [out_vector](#out_vector) | [paramptr](#paramptr) | [pathptr](#pathptr) | [retvec](#retvec) | [scroll_src_ptr](#scroll_src_ptr) | [scroll_trg_ptr](#scroll_trg_ptr) | [sd_blkptr](#sd_blkptr) | [spi_sr](#spi_sr) | [startaddr](#startaddr) | [tmp_ptr](#tmp_ptr) | [vdp_ptr](#vdp_ptr) | [volatile_tmp](#volatile_tmp) | [volatile_tmp2](#volatile_tmp2) | 

***



### <a name="cmdptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L106">cmdptr</a>
### [cmdptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L106){:target="_blank"}

> shell buffer pointer





***


### <a name="console_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L60">console_ptr</a>
### [console_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L60){:target="_blank"}

> pointer to current screen buffer





***


### <a name="cursor_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L65">cursor_ptr</a>
### [cursor_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L65){:target="_blank"}

> pointer to cursor position within screen buffer





***


### <a name="dirptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L133">dirptr</a>
### [dirptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L133){:target="_blank"}

> directory pointer





***


### <a name="dumpvecs" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L128">dumpvecs</a>
### [dumpvecs](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L128){:target="_blank"}

> shell dump command vectors (2 pointer)





***


### <a name="filenameptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L138">filenameptr</a>
### [filenameptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L138){:target="_blank"}

> filename pointer





***


### <a name="in_vector" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L47">in_vector</a>
### [in_vector](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L47){:target="_blank"}

> vector pointing to standard input routine





***


### <a name="out_vector" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L42">out_vector</a>
### [out_vector](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L42){:target="_blank"}

> vector pointing to standard output routine





***


### <a name="paramptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L96">paramptr</a>
### [paramptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L96){:target="_blank"}

> shell parameter pointer





***


### <a name="pathptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L123">pathptr</a>
### [pathptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L123){:target="_blank"}

> path pointer





***


### <a name="retvec" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L91">retvec</a>
### [retvec](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L91){:target="_blank"}

> shell return vector





***


### <a name="scroll_src_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L71">scroll_src_ptr</a>
### [scroll_src_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L71){:target="_blank"}

> scroll source pointer





***


### <a name="scroll_trg_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L76">scroll_trg_ptr</a>
### [scroll_trg_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L76){:target="_blank"}

> scroll target pointer





***


### <a name="sd_blkptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L143">sd_blkptr</a>
### [sd_blkptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L143){:target="_blank"}

> sd card block pointer





***


### <a name="spi_sr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L86">spi_sr</a>
### [spi_sr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L86){:target="_blank"}

> SPI shift register





***


### <a name="startaddr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L53">startaddr</a>
### [startaddr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L53){:target="_blank"}

> startaddress for uploaded images





***


### <a name="tmp_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L148">tmp_ptr</a>
### [tmp_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L148){:target="_blank"}

> temp volatile pointer for general usage





***


### <a name="vdp_ptr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L81">vdp_ptr</a>
### [vdp_ptr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L81){:target="_blank"}

> vdp pointer





***


### <a name="volatile_tmp" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L112">volatile_tmp</a>
### [volatile_tmp](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L112){:target="_blank"}

> volatile tmp location





***


### <a name="volatile_tmp2" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L117">volatile_tmp2</a>
### [volatile_tmp2](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L117){:target="_blank"}

> volatile tmp location 2





***


## zp_ext
[lba_addr](#lba_addr) | 

***



### <a name="lba_addr" target="_blank" href="https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L176">lba_addr</a>
### [lba_addr](https://codeberg.org/Steckschwein/software/src/branch/main/steckos/kernel//zeropage.s#L176){:target="_blank"}

> LBA address for media block operations





***


---
title: "kernel"
categories:
  - software
---


# kernel

[console](#console) | [io](#io) | [jumptable](#jumptable) | [uart](#uart) | [vdp](#vdp) | [xmodem_upload](#xmodem_upload) | 
***


## console
[console_advance_cursor](#console_advance_cursor) | [console_clear_screenbuf](#console_clear_screenbuf) | [console_get_pointer_from_cursor](#console_get_pointer_from_cursor) | [console_init](#console_init) | [console_put_cursor](#console_put_cursor) | [console_putchar](#console_putchar) | [console_update_screen](#console_update_screen) | 

***


### <a name="console_advance_cursor" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L146">console_advance_cursor</a>

> increase cursor x position. wrap around when x = 80.



In
: crs_x - cursor x position<br />crs_y - cursor y position


Out
: crs_x - cursor x position<br />crs_y - cursor y position


***

### <a name="console_clear_screenbuf" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L90">console_clear_screenbuf</a>

> clear screenbuffer area pointed to by cursor_ptr



In
: cursor_ptr - address of buffer



***

### <a name="console_get_pointer_from_cursor" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L111">console_get_pointer_from_cursor</a>

> calculate screen buffer address for cursor position in crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***

### <a name="console_init" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L27">console_init</a>

> init console





***

### <a name="console_put_cursor" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L164">console_put_cursor</a>

> place cursor at position pointed to by crs_x/crs_y



In
: crs_x - cursor x position<br />crs_y - cursor y position



***

### <a name="console_putchar" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L234">console_putchar</a>

> print character in A at current cursor position. handle CR/LF.



In
: A - character to print<br />crs_x - cursor x position<br />crs_y - cursor y position



***

### <a name="console_update_screen" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//console.s#L58">console_update_screen</a>

> update vdp text screen memory with contents from console buffer





***


## io
[hexout](#hexout) | [primm](#primm) | 

***


### <a name="hexout" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//io.s#L12">hexout</a>

> print value in A as 2 hex digits



In
: A - value to print



***

### <a name="primm" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//io.s#L42">primm</a>

> print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm





***


## jumptable
[krn_chrin](#krn_chrin) | [krn_chrout](#krn_chrout) | [krn_primm](#krn_primm) | [krn_set_input](#krn_set_input) | [krn_set_output](#krn_set_output) | [krn_upload](#krn_upload) | 

***


### <a name="krn_chrin" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L7">krn_chrin</a>

> read character from current input device into A




Out
: A - received character


***

### <a name="krn_chrout" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L12">krn_chrout</a>

> print character in A to current output device



In
: A - character to print



***

### <a name="krn_primm" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L18">krn_primm</a>

> print immediate





***

### <a name="krn_set_input" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L27">krn_set_input</a>

> set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE





***

### <a name="krn_set_output" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L22">krn_set_output</a>

> set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE



In
: A - device id to be set



***

### <a name="krn_upload" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//jumptable.s#L31">krn_upload</a>

> start XMODEM upload





***


## uart
[init_uart](#init_uart) | [uart_rx](#uart_rx) | [uart_tx](#uart_tx) | 

***


### <a name="init_uart" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//uart.s#L34">init_uart</a>

> init UART to 115200 baud, 8N1



In
: -


Out
: -


***

### <a name="uart_rx" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//uart.s#L100">uart_rx</a>

> receive byte, no wait, set carry and store in A when received



In
: -


Out
: A - received byte


***

### <a name="uart_tx" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//uart.s#L64">uart_tx</a>

> send byte in A



In
: A - byte to be sent


Out
: 


***


## vdp
[vdp_bgcolor](#vdp_bgcolor) | [vdp_fill](#vdp_fill) | [vdp_fills](#vdp_fills) | [vdp_init_reg](#vdp_init_reg) | [vdp_memcpy](#vdp_memcpy) | [vdp_set_reg](#vdp_set_reg) | [vdp_text_blank](#vdp_text_blank) | [vdp_text_on](#vdp_text_on) | 

***


### <a name="vdp_bgcolor" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L96">vdp_bgcolor</a>

> 



In
: A - color



***

### <a name="vdp_fill" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L68">vdp_fill</a>

> fill vdp VRAM with given value page wise



In
: A - byte to fill<br />X - amount of 256byte blocks (page counter)



***

### <a name="vdp_fills" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L84">vdp_fills</a>

> fill vdp VRAM with given value



In
: A - value to write<br />X - amount of bytes



***

### <a name="vdp_init_reg" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L136">vdp_init_reg</a>

> setup video registers upon given table starting from register #R.X down to #R0



In
: X - length of init table, corresponds to video register to start R#+X - e.g. X=10 start with R#10<br />A/Y - pointer to vdp init table



***

### <a name="vdp_memcpy" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L33">vdp_memcpy</a>

> copy data from host memory denoted by pointer (A/Y) to vdp VRAM (page wise). the VRAM address must be setup beforehand e.g. with macro vdp_vram_w <address>



In
: X - amount of 256byte blocks (page counter)<br />A/Y - pointer to source data



***

### <a name="vdp_set_reg" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L101">vdp_set_reg</a>

> set value to vdp register



In
: A - value<br />Y - register



***

### <a name="vdp_text_blank" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L54">vdp_text_blank</a>

> text mode blank screen and color vram





***

### <a name="vdp_text_on" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//vdp.s#L113">vdp_text_on</a>

> text mode - 40x24/80x24 character mode, 2 colors



In
: A - color settings (#R07)



***


## xmodem_upload
[xmodem_upload_callback](#xmodem_upload_callback) | 

***


### <a name="xmodem_upload_callback" target="_blank" href="https://github.com/Steckschwein/software/tree/master/../steckos/kernel//xmodem_upload.s#L127">xmodem_upload_callback</a>

> 



In
: A/X pointer to block receive callback - the receive callback is called with A - block number, X - offset to data in received block


Out
: C=0 on success, C=1 on any i/o or protocoll related error


***


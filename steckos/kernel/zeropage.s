.exportzp out_vector, in_vector
.exportzp startaddr
.exportzp console_ptr, cursor_ptr
.exportzp scroll_src_ptr, scroll_trg_ptr 
.exportzp vdp_ptr
.exportzp spi_sr 
.exportzp retvec 
.exportzp paramptr
.exportzp cmdptr
.exportzp bufptr
.exportzp pathptr
.exportzp dumpvecs
.exportzp dirptr
.exportzp filenameptr
.exportzp sd_blkptr
.exportzp tmp_ptr
.exportzp volatile_tmp
.exportzp volatile_tmp2

.exportzp XAML;  Last "opened" location Low
.exportzp XAMH;  Last "opened" location High
.exportzp STL ;  Store address Low
.exportzp STH ;  Store address High
.exportzp L   ;  Hex value parsing Low
.exportzp H   ;  Hex value parsing High
.exportzp YSAV ;  Used to see if hex value is given
.exportzp MODE ;  $00=XAM, $7F=STOR, $AE=BLOCK XAM

.exportzp retryl
.exportzp retryh
.exportzp crc
.exportzp crch
.exportzp blkno
.exportzp protocol
.exportzp block_rx_cb

; @module: zeropage


.zeropage
; vectors for input/output routines
; @name: out_vector
; @desc: vector pointing to standard output routine
; @type: pointer
out_vector:       .res 2

; @name: in_vector
; @desc: vector pointing to standard input routine
; @type: pointer
in_vector:        .res 2

; startaddress for uploaded images
; @name: startaddr
; @desc: startaddress for uploaded images
; @type: pointer
startaddr:         .res 2

; console stuff
; 
; @name: console_ptr
; @desc: pointer to current screen buffer
; @type: pointer
console_ptr:      .res 2

; @name: cursor_ptr
; @desc: pointer to cursor position within screen buffer
; @type: pointer
cursor_ptr:       .res 2


; @name: scroll_src_ptr
; @desc: scroll source pointer
; @type: pointer
scroll_src_ptr:   .res 2

; @name: scroll_trg_ptr
; @desc: scroll target pointer
; @type: pointer
scroll_trg_ptr:   .res 2

; @name: vdp_ptr
; @desc: vdp pointer 
; @type: pointer
vdp_ptr:          .res 2

; @name: spi_sr
; @desc: SPI shift register
; @type: byte
spi_sr:           .res 1

; @name: retvec
; @desc: shell return vector
; @type: pointer
retvec:           .res 2

; @name: paramptr
; @desc: shell parameter pointer
; @type: pointer
paramptr:         .res 2

; @name: cmdptr
; @desc: shell command pointer
; @type: pointer
cmdptr:           .res 2

; @name: cmdptr
; @desc: shell buffer pointer
; @type: pointer
bufptr:           .res 2

; temp
; @name: volatile_tmp
; @desc: volatile tmp location
; @type: byte
volatile_tmp:     .res 1

; @name: volatile_tmp2
; @desc: volatile tmp location 2
; @type: byte
volatile_tmp2:    .res 1

; path ptr
; @name: pathptr
; @desc: path pointer
; @type: pointer
pathptr:          .res 2

; @name: dumpvecs
; @desc: shell dump command vectors (2 pointer)
; @type: pointer
dumpvecs:         .res 4

; @name: dirptr
; @desc: directory pointer
; @type: pointer
dirptr:           .res 2

; @name: filenameptr
; @desc: filename pointer
; @type: pointer
filenameptr:      .res 2

; @name: sd_blkptr
; @desc: sd card block pointer
; @type: pointer
sd_blkptr:        .res 2

; @name: tmp_ptr
; @desc: temp volatile pointer for general usage
; @type: pointer
tmp_ptr:          .res 2

; stuff for wozmon
XAML=             startaddr
XAMH=             startaddr+1
STL =             dumpvecs
STH =             dumpvecs+1
L   =             dumpvecs+2
H   =             dumpvecs+3
YSAV=             volatile_tmp
MODE=             volatile_tmp2



; xmodem upload
retryl=           dumpvecs    ; 16 bit retry
retryh=           dumpvecs+1
crc=              dumpvecs+2  ; CRC lo byte  (two byte variable)
crch=             dumpvecs+3  ; CRC hi byte
blkno=            volatile_tmp ; block number
protocol=         volatile_tmp2 ; 2nd counter
block_rx_cb=      tmp_ptr

; @module zp_ext
.segment "ZP_EXT"
; @name: lba_addr
; @desc: LBA address for media block operations
; @type: pointer
.export lba_addr
lba_addr:           .res 4

.export crs_x, crs_y, crs_x_sav, crs_y_sav
.export vdp_addr, vdp_addr_old
.export screen_status, current_console
.export ansi_index, ansi_param1, ansi_param2, ansi_state
; @name: crs_x
; @desc: cursor x position
; @type: byte
crs_x:          .res 1
; @name: crs_y
; @desc: cursor y position
; @type: byte
crs_y:          .res 1

; @name: crs_x_sav
; @desc: cursor x position save location
; @desc: 1 byte per console
; @type: byte
crs_x_sav:      .res 4

; @name: crs_y_sav
; @desc: cursor y position save location
; @desc: 1 byte per console
; @type: byte
crs_y_sav:      .res 4

; @name: vdp_addr
; @desc: cursor position vdp address
; @type: address
vdp_addr:       .res 2

; @name: vdp_addr_old
; @desc: previous cursor position vdp address
; @type: address
vdp_addr_old:   .res 2

; @name: screen_status
; @desc: state of screen - bit 7 -> dirty
; @type: byte
screen_status:  .res 1

; @name: current_console
; @desc: number of current virtual console
; @type: byte
current_console: .res 1

ansi_index:  .res 1
ansi_state:  .res 1
ansi_param1: .res 1
ansi_param2: .res 1

.export keyboard_key
; @name: keyboard_key
; @desc: value of last pressed key
; @type: byte
keyboard_key:  .res 1

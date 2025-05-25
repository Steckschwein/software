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
volatile_tmp:     .res 1
volatile_tmp2:    .res 1

; path ptr
pathptr:          .res 2

; shell dump command vectors
dumpvecs:         .res 4

; directory pointer
dirptr:           .res 2

; filename pointer
filenameptr:      .res 2

; sd card block pointer
sd_blkptr:        .res 2

; temp volatile pointer for general usage
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

.segment "ZP_EXT"
.export lba_addr
lba_addr:           .res 4




; vectors for input/output routines
.exportzp out_vector        = $d0
.exportzp in_vector         = $d2

; startaddress for uploaded images
.exportzp startaddr         = $d4

; console stuff
; pointer to current screen buffer
.exportzp console_ptr       = $d6
; pointer to cursor position within screen buffer
.exportzp cursor_ptr        = $d8
; scroll source pointer
.exportzp scroll_src_ptr    = $da 
; scroll target pointer
.exportzp scroll_trg_ptr    = $dc 
; vdp pointer 
.exportzp vdp_ptr           = $de

; SPI shift register
.exportzp spi_sr            = $e0

; stuff for wozmon
.exportzp XAML              = $e1  ;  Last "opened" location Low
.exportzp XAMH              = $e2  ;  Last "opened" location High
.exportzp STL               = $e3  ;  Store address Low
.exportzp STH               = $e4  ;  Store address High
.exportzp L                 = $e5  ;  Hex value parsing Low
.exportzp H                 = $e6  ;  Hex value parsing High
.exportzp YSAV              = $e7  ;  Used to see if hex value is given
.exportzp MODE              = $e8  ;  $00=XAM, $7F=STOR, $AE=BLOCK XAM

.exportzp retvec            = $e1
.exportzp paramptr          = $e3
.exportzp cmdptr            = $e5 
.exportzp msg_ptr           = $e7
.exportzp bufptr            = $e9

; xmodem upload
.exportzp blkno             = $e9  ; block number
.exportzp retryl            = $ea  ; 16 bit retry
.exportzp retryh            = $eb  ;
.exportzp protocol          = $ec  ; 2nd counter
.exportzp block_rx_cb       = $ed  ; callback
.exportzp crc               = $ef  ; CRC lo byte  (two byte variable)
.exportzp crch              = $f0  ; CRC hi byte

.exportzp pathptr           = $f1 
.exportzp dumpvecs          = $f3


.exportzp sd_blkptr         = $fc  ; sd card block pointer
; temp volatile pointer for general usage
.exportzp tmp_ptr           = $fe

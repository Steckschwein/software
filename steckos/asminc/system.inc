.ifndef _SYSTEM_INC_
  _SYSTEM_INC_ = 1


; @see system.s
IRQ_VDP       = 1<<7  ; irq from video chip
IRQ_VIA       = 1<<6  ; irq from VIA (6522)
IRQ_SND       = 1<<5  ; irq from sound card (ym3812)
IRQ_RTC       = 1<<4  ; irq from RTC
IRQ_UART      = 1<<3  ; irq from UART

IRQ_IO1       = 1<<1  ; i/o port 1 (card slot 1)
IRQ_IO0       = 1<<0  ; i/o port 0 (card slot 0)

; io devices
OUTPUT_DEVICE_NULL    = 0
INPUT_DEVICE_NULL     = 0
OUTPUT_DEVICE_UART    = 1
INPUT_DEVICE_UART     = 1
INPUT_DEVICE_CONSOLE  = 2
OUTPUT_DEVICE_CONSOLE = 2


;...
clockspeed  = 10  ; in Mhz

stack = $0100

ctrl_port   = $0230
slot0_ctrl = ctrl_port+0
slot1_ctrl = ctrl_port+1
slot2_ctrl = ctrl_port+2
slot3_ctrl = ctrl_port+3

slot0 = $0000
slot1 = $4000
slot2 = $8000
slot3 = $c000

SLOT_ROM = 1<<7 ; bit 7 denotes whether ROM (1) or RAM (0) chip is selected

CODE_LF  = $0a ; line feed
CODE_CR  = $0d ; carriage return

CODE_CURSOR_RIGHT   = $10
CODE_CURSOR_LEFT    = $11
CODE_CURSOR_UP      = $1e
CODE_CURSOR_DOWN    = $1f




; address constants of RAM addresses which can be used as buffers or kind of
; !!! ATTENTION: if used together with fat read/write be aware that this buffers are used and may override your data
BUFFER_0 = $0400
BUFFER_1 = BUFFER_0 + $0100
BUFFER_2 = BUFFER_1 + $0100
BUFFER_3 = BUFFER_2 + $0100

SYS_VECTOR_NMI = $fffa
SYS_VECTOR_RESET = $fffc
SYS_VECTOR_IRQ = $fffe

.struct save_status
SLOT0   .byte
SLOT1   .byte
SLOT2   .byte
SLOT3   .byte
ACC     .byte
XREG    .byte
YREG    .byte
SP      .byte
STATUS  .byte
PC      .word
.endstruct


.endif

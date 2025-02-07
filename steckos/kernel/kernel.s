; MIT License
;
; Copyright (c) 2025 Thomas Woinke, Marko Lauke, www.steckschwein.de
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
.ifdef DEBUG_KERNEL ; debug switch for this module
  debug_enabled=1
.endif


.include "system.inc"
; .include "zeropage.inc"
; .include "debug.inc"
.include "common.inc"

.include "vdp.inc"
SCREEN_DIRTY = $80

.import init_uart, uart_tx, uart_rx, primm, hexout, wozmon, xmodem_upload
.import init_vdp, vdp_bgcolor, vdp_memcpy
.import textui_init, textui_chrout, textui_update_screen
.export char_out, char_in, set_input, set_output, upload
.export out_vector, in_vector, startaddr
.export crs_x, crs_y

.exportzp xmodem_startaddress=startaddr
.exportzp vdp_ptr


.zeropage
out_vector:    .res 2
in_vector:     .res 2
startaddr:     .res 2
vdp_ptr:       .res 2
console_ptr:   .res 2

.bss
save_stat: .res   .sizeof(save_status)
atmp: .res 1
crs_x: .res 1
crs_y: .res 1
screen_status: .res 1

SCREEN_BUFFER_PAGE = 30
screen_buffer = $8000
screen_buffer_size = 80*24
screen_buffer_end = screen_buffer + screen_buffer_size

.code

do_reset:

    ; init stack pointer
    ldx #$ff
    txs

    lda #2 ; enable RAM at slot2
    sta slot2_ctrl


    jsr init_uart

    lda #INPUT_DEVICE_UART
    jsr set_input
    lda #OUTPUT_DEVICE_UART
    jsr set_output

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 
    
    jsr clear_screenbuf
   
    pla 
    sta slot2_ctrl

    sei 
    jsr init_vdp
    vdp_wait_l 
    
    SetVector screen_buffer, console_ptr

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 

    lda #'0'
    ldx #0
:
    sta screen_buffer,x
    inx 
    inc a 
    cmp #'z'+1


    
    bne :-

    pla 
    sta slot2_ctrl


    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status

    cli
    
    ldx #0
:
    lda message,x 
    beq @end 

    sta screen_buffer + $a0,x 

    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status

    inx
    bra :-
@end:


    jsr primm 
message:
    .byte CODE_LF, CODE_LF, "Steckschwein "
    .include "version.inc"
    .byte CODE_LF, CODE_LF
    .byte 0


    jmp upload

    ; jmp register_status

upload:
    lda #OUTPUT_DEVICE_NULL
    jsr set_output
    lda #INPUT_DEVICE_NULL
    jsr set_input

    jsr xmodem_upload
    bcc @run

    lda #INPUT_DEVICE_UART
    jsr set_input
    lda #OUTPUT_DEVICE_UART
    jsr set_output

    jsr primm 
    .byte "Upload error", CODE_LF, 0

    jmp do_reset




@run:
    ldx #$ff
    txs 

    lda #INPUT_DEVICE_UART
    jsr set_input
    lda #OUTPUT_DEVICE_UART
    jsr set_output

    jmp (startaddr)


char_out:
    jmp (out_vector)

char_in:
    jmp (in_vector)

do_irq:
    save 

    bit a_vreg
    bpl :+

    bit screen_status ; screen dirty bit set?
    bpl :+
    ; yes, write to vdp
    vdp_vram_w ADDRESS_TEXT_SCREEN
    
    lda slot2_ctrl
    pha 

    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 

    lda console_ptr
    ldy console_ptr+1
    ldx #8
    jsr vdp_memcpy
    
:

    pla
    sta slot2_ctrl

    lda screen_status
    and #!(SCREEN_DIRTY)
    sta screen_status

    restore 
    rti


do_nmi:
    rti

io_null:
    rts

; device in a
set_output:
    asl
    tax
    lda output_vectors,x
    sta out_vector
    lda output_vectors+1,x
    sta out_vector+1
    rts 

; device in a
set_input:
    asl 
    tax
    lda input_vectors,x
    sta in_vector
    lda input_vectors+1,x
    sta in_vector+1
    rts 

register_status:
    sta save_stat + save_status::ACC
    stx save_stat + save_status::XREG
    sty save_stat + save_status::YREG

    tsx
    stx save_stat + save_status::SP

    pla
    sta save_stat + save_status::STATUS
    pla
    sta save_stat + save_status::PC
    pla
    sta save_stat + save_status::PC+1


    ldx #3
:
    lda slot0_ctrl,x
    sta save_stat + save_status::SLOT0,x
    dex
    bpl :-

    jsr primm
    .byte CODE_LF, "PC   S0 S1 S2 S3 AC XR YR SP NV-BDIZC", CODE_LF,0

    lda save_stat + save_status::PC+1
    jsr hexout
    lda save_stat + save_status::PC
    jsr hexout

    lda #' '
    jsr char_out

    ldx #save_status::SLOT0
:
    lda save_stat,x
    jsr hexout

    lda #' '
    jsr char_out
    inx
    cpx #save_status::STATUS
    bne :-


    lda save_stat + save_status::STATUS
    sta atmp

    ldx #0
@next:
    asl atmp
    bcs @set
    lda #'0'
    bra @skip
@set:
    lda #'1'
@skip:
    jsr char_out
    inx
    cpx #8
    bne @next

    crlf


    jmp wozmon

clear_screenbuf:
    lda #' '
    ldx #0
:
    sta screen_buffer,x
    sta screen_buffer + $100,x
    sta screen_buffer + $200,x
    sta screen_buffer + $300,x
    sta screen_buffer + $400,x
    ; sta screen_buffer + $500,x
    ; sta screen_buffer + $600,x
    ; sta screen_buffer + $700,x
    
    inx 
    bne :-
    rts


.rodata
output_vectors:
.word io_null
.word uart_tx
.word $dead 
.word $dead 
input_vectors:
.word io_null
.word uart_rx
.word $0202 
.word $0303 





.segment "VECTORS"
; ----------------------------------------------------------------------------------------------
; Interrupt vectors
; ----------------------------------------------------------------------------------------------
; $FFFA/$FFFB NMI Vector
.word do_nmi
; $FFFC/$FFFD reset vector
.word do_reset
; $FFFE/$FFFF IRQ vector
.word do_irq

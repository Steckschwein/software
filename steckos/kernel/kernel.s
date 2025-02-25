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

;@module: kernel

.ifdef DEBUG_KERNEL ; debug switch for this module
  debug_enabled=1
.endif


.include "system.inc"
.include "console.inc"
; .include "zeropage.inc"
; .include "debug.inc"
.include "common.inc"

.include "vdp.inc"

.import init_via
.import init_uart, uart_tx, uart_rx, primm, hexout, wozmon, xmodem_upload
.import init_vdp, vdp_bgcolor, vdp_memcpy
.import console_init, console_update_screen, console_putchar, console_put_cursor, console_handle_control_char
.import keyboard_init, fetchkey, getkey

.export char_out, char_in, set_input, set_output, upload
.export out_vector, in_vector, startaddr
.import crs_x, crs_y
.exportzp xmodem_startaddress=startaddr


.zeropage
out_vector:    .res 2
in_vector:     .res 2
startaddr:     .res 2

.bss
save_stat:          .res .sizeof(save_status)
atmp:               .res 1





.code

do_reset:

    ; init stack pointer
    ldx #$ff
    txs

    lda #2 ; enable RAM at slot2
    sta slot2_ctrl

    jsr init_via

    jsr init_uart


    lda #INPUT_DEVICE_CONSOLE
    jsr set_input
    lda #OUTPUT_DEVICE_CONSOLE
    jsr set_output




    lda a_vreg
    jsr init_vdp
    vdp_wait_l 

    
    jsr console_init


    cli


    jsr primm 
    .byte "Steckschwein "
    .include "version.inc"
    .byte CODE_LF
    .byte CODE_LF
    .byte 0

    jsr keyboard_init
   

    lda #CODE_LF
    jsr char_out
    lda #CODE_LF
    jsr char_out



    ; sei 
@loop:
    lda #'0'
    ldx #0
:
    jsr char_out

    inx 
    inc a 
    cmp #'z'+1
    
    bne :-
    ; cli

    lda #CODE_LF
    jsr char_out

; :
;     jsr char_in 
;     bcc :-
;     jsr char_out
;     bra :-
    ; jmp upload

    jmp register_status

upload:
    lda #OUTPUT_DEVICE_NULL
    jsr set_output
    lda #INPUT_DEVICE_NULL
    jsr set_input

    jsr xmodem_upload
    bcc @run

    lda #INPUT_DEVICE_UART
    jsr set_input

    lda #OUTPUT_DEVICE_CONSOLE
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

; @name: do_irq
; @desc: system irq handler
do_irq:
    save 

    ; lda #Cyan<<4|Cyan
    ; jsr vdp_bgcolor

    bit a_vreg
    bpl @exit_isr

    jsr console_update_screen


    jsr fetchkey
    bcc @exit_isr

    jsr console_handle_control_char

@exit_isr:
    ; lda #VIDEO_COLOR 
    ; jsr vdp_bgcolor
    restore 
    rti

; @name: do_nmi
; @desc: system nmi handler
do_nmi:
    jmp register_status
    rti

; @name: io_null
; @desc: dummy routine to suppress output
io_null:
    rts

;@name: set_output
;@desc: set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
set_output:
    asl
    tax
    lda output_vectors,x
    sta out_vector
    lda output_vectors+1,x
    sta out_vector+1
    rts 

;@name: set_input
;@desc: set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
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




.rodata
output_vectors:
.word io_null
.word uart_tx
.word console_putchar
.word $dead
input_vectors:
.word io_null
.word uart_rx
.word getkey
.word $dead 





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

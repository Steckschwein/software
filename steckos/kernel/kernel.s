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

.export startaddr
.export input_vectors, output_vectors
.export upload

.import crs_x, crs_y
.import out_vector, in_vector
.import char_in, char_out, set_input, set_output
.exportzp xmodem_startaddress=startaddr


.zeropage
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



; @name: do_irq
; @desc: system irq handler
do_irq:
    save 

    ; lda #Cyan<<4|Cyan
    ; jsr vdp_bgcolor

    bit a_vreg
    bpl @handle_keyboard

    jsr console_update_screen

@handle_keyboard:
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

; @name: io_null
; @desc: dummy routine to suppress output
io_null:
    rts


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

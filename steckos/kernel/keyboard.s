.include "spi.inc"
.include "keyboard.inc"
.include "system.inc"
.include "common.inc"


.import spi_r_byte
.import spi_rw_byte
.import spi_deselect
.import spi_select_device
.import spi_replace_device
.import spi_set_device

.import primm, hexout, char_out
.import keyboard_key

.export keyboard_init, keyboard_getkey, keyboard_fetchkey


;@module: keyboard
.bss


.code
; Select Keyboard controller on SPI, read one byte
;	in: -
;	out:
;		C=1 key was fetched and A=<key code>, C=0 otherwise and A=<error / status code> e.g. #EBUSY
;@name: "fetchkey"
;@out: A, "fetched key / error code"
;@out:  C, "1 - key was fetched, 0 - nothing fetched"
;@desc: "fetch byte from keyboard controller"
keyboard_fetchkey:
    lda #spi_device_keyboard
    jsr spi_select_device
    bne exit

    phx

    jsr spi_r_byte
    jsr spi_deselect

    plx

    cmp #0
    beq exit

    sta keyboard_key
    sec
    rts


; get byte from keyboard buffer
;	in: -
;	out:
;		C=1 key was pressed and A=<key code>, C=0 otherwise
;@name: "getkey"
;@out: A, "fetched key"
;@out:  C, "1 - key was fetched, 0 - nothing fetched"
;@desc: "get byte from keyboard buffer"
keyboard_getkey:
    lda keyboard_key
    beq exit
    stz keyboard_key
    sec
    rts
exit:
    clc
    rts

;  requires nvram init beforehand
keyboard_init:
    jsr primm
    .byte "Keyboard init.", 0

    ldy #50
    jsr _delay_10ms

    ; stz init_step

    lda #spi_device_keyboard
    jsr spi_select_device
    bne @fail

    ; inc init_step
    lda #KBD_CMD_RESET
    jsr spi_rw_byte
    jsr _keyboard_cmd_status
    bne @fail

    jsr primm 
    .asciiz "OK"
    clc
    jmp spi_deselect
@fail:
    pha
    jsr primm
    .byte "FAIL (",0
    ; lda init_step
    ; jsr hexout
    ; lda #'/'
    jsr char_out
    pla
    jsr hexout
    jsr primm
    .byte ")", CODE_LF, 0
    sec
    jmp spi_deselect

_keyboard_cmd_status:
    lda #'.'
    jsr char_out

    ldy #100
:   dey
    bmi :+
    phy
    ldy #10
    jsr _delay_10ms
    lda #KBD_HOST_CMD_CMD_STATUS
    jsr spi_rw_byte
    ply
    cmp #KBD_HOST_CMD_STATUS_EOT
    bne :-
:   rts 

_delay_10ms:
:   sys_delay_ms 10
    dey 
    bne :-
    rts 

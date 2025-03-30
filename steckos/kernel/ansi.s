.include "vdp.inc"
.include "console.inc"
.include "common.inc"

.export ansi_chrout, ansi_state, ansi_index, ansi_param1, ansi_param2
.import console_putchar, console_put_cursor, console_clear_screenbuf
.import crs_x, crs_y



.bss
ansi_index:  .res 1
ansi_state:  .res 1
ansi_param1: .res 1
ansi_param2: .res 1


.code

ansi_chrout:
    bit ansi_state
    bmi @check_csi
    bvs @store_csi_byte
    cmp #ESCAPE
    bne @out
    pha
    lda #$80
    sta ansi_state
    pla
    rts
@check_csi:
    cmp #CSI
    beq @is_csi
    stz ansi_state
@out:
    jmp console_putchar
@is_csi:
    ; next bytes will be the ansi sequence
    pha
    lda #$40
    sta ansi_state
    stz ansi_index
    pla
    rts
@store_csi_byte:
    ; number? $30-$39
    cmp #'0'
    bcs :+
    stz ansi_state
    rts
:
    cmp #'9'+1
    bcc @store

    cmp #';'
    bne @cont
    inc ansi_index
    dec ansi_state
    rts
@cont:
    cmp #'J'
    bne :+
    lda #2
    cmp ansi_param1
    bne :+

    stz ansi_state
    jmp console_clear_screenbuf
:
    cmp #'A' ; cursor up
    bne :+
    lda crs_y
    sec
    sbc ansi_param1
    sta crs_y
    bra @seq_end
:
    cmp #'B' ; cursor up
    bne :+
    lda crs_y
    clc
    adc ansi_param1
    sta crs_y
    bra @seq_end
:
    cmp #'C' ; cursor right
    bne :+
    lda crs_x
    sec
    sbc ansi_param1
    sta crs_x
    bra @seq_end
:
    cmp #'D' ; cursor left
    bne :+
    lda crs_x
    clc
    adc ansi_param1
    sta crs_x
    bra @seq_end
:
    cmp #'H'
    bne :+

    lda ansi_param1
    sta crs_x
    lda ansi_param2
    sta crs_y
    bra @seq_end
:
    ; TODO
    ; Is alphanumeric?
    ; end sequence and execute requested action
@seq_end:
    stz ansi_state
    jmp console_put_cursor
    ;rts
@store:

    phx
    phy
    ldx ansi_index

    ; Convert digit in A to binary
    and #%11001111
    pha

    ; bit 0 of ansi_state set?
    ; no? multiply by 10, then store to ansi_param1
    ; yes? skip multiplication, and add to ansi_param1
    lda ansi_state
    ror
    bcc @skip

    ldy ansi_param1,x
    clc
    pla
    adc multable,y
    sta ansi_param1,x

    bra @end
@skip:
    pla
    sta ansi_param1,x
    inc ansi_state ; set bit 0 of ansi_state to indicate the first digit has been processed

@end:
    ply
    plx
    rts
multable:  .byte 0,10,20,30,40,50,60,70,80,90


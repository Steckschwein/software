; @module: io
.include "system.inc"

.import char_out
.export hexout, primm, strout

.importzp str_ptr


.code
; @name: hexout
; @desc: print value in A as 2 hex digits
; @in: A - value to print
hexout:
    pha
    pha

    lsr     ; msb first
    lsr
    lsr
    lsr
    ; https://twitter.com/adumont/status/1381857942467702785
    sed
    cmp #$0a
    adc #$30
    cld
    jsr char_out

    pla
    and #$0f    ;mask lsd for hex print

    sed
    cmp #$0a
    adc #$30
    cld
_out:
    jsr char_out

    pla
    rts

;@in: A, "lowbyte  of string address"
;@in:   X, "highbyte of string address"
;@desc: "Output string on active output device"
strout:
    sta str_ptr                ;init for output below
    stx str_ptr+1
    pha                                       ;save a, y to stack
    phy

    ldy #$00
@l1:
    lda (str_ptr),y
    beq @l2
    jsr char_out
    iny
    bne @l1

@l2:    
    ply                                       ;restore a, y
    pla
    rts


; @name: primm
; @desc: print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm
primm:
    pla               ; get low part of (string address-1)
    sta   str_ptr
    pla               ; get high part of (string address-1)
    sta   str_ptr+1
    bra   primm3
primm2:
    jsr   char_out        ; output a string char
primm3:
    inc   str_ptr         ; advance the string pointer
    bne   primm4
    inc   str_ptr+1
primm4:
    lda   (str_ptr)       ; get string char
    bne   primm2      ; output and continue if not NUL
    lda   str_ptr+1
    pha
    lda   str_ptr
    pha
    rts               ; proceed at code following the NUL
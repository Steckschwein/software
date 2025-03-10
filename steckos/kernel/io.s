; @module: io
.include "system.inc"

.import char_out
.export hexout, primm

.importzp tmp_ptr
DPL = tmp_ptr
DPH = tmp_ptr+1
; .zeropage
; DPL: .res 1
; DPH: .res 1

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

; @name: primm
; @desc: print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm
primm:
    pla               ; get low part of (string address-1)
    sta   DPL
    pla               ; get high part of (string address-1)
    sta   DPH
    bra   primm3
primm2:
    jsr   char_out        ; output a string char
primm3:
    inc   DPL         ; advance the string pointer
    bne   primm4
    inc   DPH
primm4:
    lda   (DPL)       ; get string char
    bne   primm2      ; output and continue if not NUL
    lda   DPH
    pha
    lda   DPL
    pha
    rts               ; proceed at code following the NUL
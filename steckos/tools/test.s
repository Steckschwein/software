.include "steckos.inc"

appstart $1000

.code
    lda #'A'
    jsr krn_chrout

    jmp (retvec)

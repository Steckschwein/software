.include "steckos.inc"

appstart $2000

.code
    sei
    lda #'A'
    jsr $ff03

foo:
    jmp foo

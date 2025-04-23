.include "steckos.inc"
.include "fcntl.inc"	; @see


appstart $1000

    lda (paramptr)	; empty string?
    bne @l_touch
    lda #$99
    bra @errmsg
@l_touch:
    lda paramptr
    ldx paramptr+1
    ldy #O_CREAT
    jsr krn_fopen
    bcs @errmsg

    jsr krn_close

@exit:
    jmp (retvec)

@errmsg:
    ;TODO FIXME maybe use oserror() from cc65 lib
    pha
    jsr krn_primm
    .asciiz "Error: "
    pla
    jsr krn_hexout
    jmp @exit

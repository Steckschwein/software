.include "errno.inc"
.include "fcntl.inc"  ; @see ca65 fcntl.inc
.include "steckos.inc"

appstart $1000

        lda (paramptr)  ; empty string?
        bne @l_cp
        lda #$99
        bra @errmsg
@l_cp:
        lda paramptr
        ldx paramptr+1
        ldy #O_RDONLY
        jsr krn_open
        bcs @errmsg
        stx fd1

@l0:    lda (paramptr)
        beq @l1
        cmp #' '
        beq @l1
        inc paramptr
        bne @l0
        lda #EINVAL
        bra @errmsg
@l1:
        lda paramptr
        ldx paramptr+1
        ldy #O_WRONLY
        jsr krn_open
        stp
        bcs @err_close_fd1
        stx fd2

        ;TODO check whether fd2 denotes the same file as fd1
@copy:
        ldx fd1
        jsr krn_fread_byte
        bcs @eof
        ldx fd2
        jsr krn_write_byte
        bcc @copy

@eof:   bne @err_close

        jsr krn_close

        ldx fd2
        jsr krn_close

        jsr krn_primm
        .byte $0a," cp ok",$00
@exit:
        jmp (retvec)

@err_args_close_fd1:
        lda #ENOENT
        bra @err_close_fd1
@err_close:
        pha
        ldx fd2
        jsr krn_close
        pla
@err_close_fd1:
        pha
        ldx fd1
        jsr krn_close
        pla
@errmsg:
        pha
        jsr krn_primm
        .asciiz "Error: "
        pla
        jsr krn_hexout
        jmp @exit

.bss
fd1:  .res 1
fd2:  .res 1

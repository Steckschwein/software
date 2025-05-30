.include "steckos.inc"
.include "fat32.inc"
.include "fcntl.inc"



; .autoimport
.bss
filename:	.res .sizeof(F32DirEntry::Name) + .sizeof(F32DirEntry::Ext) + 1
dirent:   .res .sizeof(F32DirEntry)
op:				.res 1
atr:			.res 1
appstart $1000
.code
    ldy #$00
@loop:
    lda (paramptr),y
    cmp #'+'
    beq param
    cmp #'-'
    beq param

    iny
    bne @loop

    bra get_filename

param:
    sta op
    iny

    lda (paramptr),y
    toupper
    
    ldx #$00
    cmp #'A'
    bne @l1
    ldx #DIR_Attr_Mask_Archive
@l1:	
    cmp #'H'
    bne @l2
    ldx #DIR_Attr_Mask_Hidden
@l2:	
    cmp #'R'
    bne @l3
    ldx #DIR_Attr_Mask_ReadOnly
@l3:	
    cmp #'S'
    bne @l4
    ldx #DIR_Attr_Mask_System
@l4:

    stx atr

    ; everything until <space> in the parameter string is the source file name
    iny
get_filename:
    ldx #$00
@loop:
    lda (paramptr),y
    beq attrib
    cmp #' '
    beq @skip
    sta filename,x
    inx
    stz filename,x
@skip:
    iny
    bra @loop

attrib:
    lda #<filename
    ldx #>filename
    ldy #O_WRONLY
    jsr krn_open
    bcs oerror

    lda #<dirent
    ldy #>dirent
    jsr krn_read_direntry
    bcs rerror

    phx

    lda atr
    ldx op
    ldy #F32DirEntry::Attr
    cpx #'+'
    bne @l1
    
    ora dirent,y
    
    bra @save
@l1:	
    cpx #'-'
    bne @view

    eor #$ff 				; make complement mask
    and dirent,y

@save:
    sta dirent,y
    plx

    lda #<dirent
    ldy #>dirent
    jsr krn_update_direntry
    bcs wrerror

    jsr krn_close

    bra out

@view:
    ldy #F32DirEntry::Name
@l2:
    lda (dirptr),y
    jsr krn_chrout
    iny
    cpy #F32DirEntry::Attr
    bne @l2

    lda #':'
    jsr krn_chrout

    jsr print_attribs
    bra out

oerror:
    jsr krn_hexout
    jsr krn_primm
    .asciiz "open error"
    bra out
rerror:
    jsr krn_hexout
    jsr krn_primm
    .asciiz "read error"
    bra out

wrerror:
    jsr krn_hexout
    jsr krn_close

    jsr krn_primm
    .asciiz " write error"
out:
    jmp (retvec)

print_attribs:
    ldy #F32DirEntry::Attr
    lda dirent,y

    ldx #3
@al:
    bit attr_tbl,x
    beq @skip
    pha
    lda attr_lbl,x
    jsr krn_chrout
    pla
    bra @next
@skip:
    pha
    lda #' '
    jsr krn_chrout
    pla
@next:
    dex
    bpl @al
    rts

; .data
attr_tbl:   .byte DIR_Attr_Mask_ReadOnly, DIR_Attr_Mask_Hidden,DIR_Attr_Mask_System,DIR_Attr_Mask_Archive
attr_lbl:   .byte 'R','H','S','A'



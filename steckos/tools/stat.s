.include "steckos.inc"
.include "fat32.inc"
.include "fcntl.inc"


.autoimport

.export char_out=krn_chrout
.export dirent

appstart $1000

main:
    lda (paramptr)
    beq @usage
    copypointer paramptr, filenameptr

    lda filenameptr
    ldx filenameptr+1
    ldy #O_RDONLY
    jsr krn_open
    bcs @open_fail

    lda #<dirent
    ldy #>dirent
    jsr krn_read_direntry
    jsr krn_close

    jsr dir_show_entry

@open_fail:
@exit:
    jmp (retvec)
@usage:
    jsr krn_primm
    .asciiz "usage: stat <filename>"
    bra @exit

dir_show_entry:

    jsr krn_primm
    .byte "Name: ",$00
    jsr print_filename

    jsr krn_primm
    .byte $0a, "Size: ",$00
    jsr print_filesize

    jsr krn_primm
    .byte $0a,"Cluster#1: ",$00

    jsr print_cluster_no

    jsr krn_primm
    .byte $0a, "Attribute: "
    .byte "--ADVSHR",$00
    
    jsr krn_primm
    .byte $0a,"           ",$00

    ldy #F32DirEntry::Attr
    lda dirent,y

    jsr bin2dual

    jsr krn_primm
    .byte $0a,"Created  : ",$00
    ldy #F32DirEntry::CrtDate
    jsr print_fat_date

    jsr space
    
    ldy #F32DirEntry::CrtTime +1
    jsr print_fat_time
    
    jsr krn_primm
    .byte $0a, "Modified : ",$00
    ldy #F32DirEntry::WrtDate
    jsr print_fat_date

    jsr space
    
    ldy #F32DirEntry::WrtTime +1
    jsr print_fat_time
    crlf

    rts

; A to 2 digit ASCII
;@name: "b2ad"
;@in: A, "value to output"
;@desc: "output 8bit value as 2 digit decimal"
b2ad:
    phx
    ldx #$00
@c10:	
    cmp #10
    bcc @out2
    sbc #10
    inx
    bra @c10
@out2:
    pha
    txa
    adc #$30
    jsr char_out
    pla
    clc
    adc #$30
    jsr char_out
    plx
    rts

dpb2ad:
    sta tmp3
    stx tmp1
    ldy #$00
    sty tmp2
nxtdig:
    ldx #$00
subem:
    lda tmp3
    sec
    sbc subtbl,y
    sta tmp3
    lda tmp1
    iny
    sbc subtbl,y
    bcc adback
    sta tmp1
    inx
    dey
    bra subem

adback:
    dey
    lda tmp3
    adc subtbl,y
    sta tmp3
    txa
    bne setlzf
    bit tmp2
    bmi cnvta
    bpl printspc
setlzf:
    ldx #$80
    stx tmp2

cnvta:
	ora #$30
    jsr char_out
    bra uptbl
printspc:
    lda #' '
    jsr char_out

uptbl:
    iny
    iny
    cpy #08
    bcc nxtdig
    lda tmp3
    ora #$30

	jmp char_out

;@name: "bin2dual"
;@in: A, "value to output"
;@desc: "output 8bit value as binary string"
bin2dual:
    pha
    phx
    ldx #$07
@l:
    rol
    bcc @skip
    pha
    lda #'1'
    bra @out
@skip:
    pha
    lda #'0'
@out:
    jsr krn_chrout
    pla
    dex
    bpl @l
    plx
    pla
    rts

print_filename:
    ldx #0
    ldy #F32DirEntry::Name
@name:
    lda dirent,y
    cmp #' '
    beq @ext

    tolower
    jsr char_out
    inx
    iny
    cpy #F32DirEntry::Ext
    bne @name

@ext:
    ldy #F32DirEntry::Ext
    lda dirent,y
    cmp #' '
    beq @spcloop

    lda #'.'
    jsr char_out
    inx

    ldy #F32DirEntry::Ext
@foo:
    lda dirent,y

    tolower
    jsr char_out
    inx
    iny
    cpy #F32DirEntry::Ext + 3
    bne @foo

@spcloop:
    cpx #12
    bcs @done
    jsr space
    inx
    bne @spcloop

@done:
    rts

print_fat_time:
    lda dirent,y
    tax
    lsr
    lsr
    lsr

    jsr b2ad

    lda #':'
    jsr char_out

    txa
    and #%00000111
    sta tmp1
    dey
    lda dirent,y

    ldx #5
@loop:
    lsr tmp1
    ror

    dex
    bne @loop

    jsr b2ad

    lda #':'
    jsr char_out

    lda dirent,y
    and #%00011111

    jsr b2ad

    rts

print_fat_date:
    lda dirent,y
    and #%00011111
    jsr b2ad

    lda #'.'
    jsr char_out

    ; month
    iny
    lda dirent,y
    lsr
    tax
    dey
    lda dirent,y
    ror
    lsr
    lsr
    lsr
    lsr

    jsr b2ad

    lda #'.'
    jsr char_out

    txa
    clc
    adc #80   	; add begin of msdos epoch (1980)
    cmp #100
    bcc @l6		; greater than 100 (post-2000)
    sec 		; yes, substract 100
    sbc #100
@l6:
    jsr b2ad ; there we go
    rts

print_filesize:
    phy
    clc
    ldy #F32DirEntry::FileSize+3
    lda dirent,y
    ldy #F32DirEntry::FileSize+2
    adc dirent,y
    beq :+
    lda #<bigfile_marker_txt
    ldx #>bigfile_marker_txt

    jsr krn_strout
    ply
    rts
:
    ldy #F32DirEntry::FileSize+1
    lda dirent,y
    tax
    dey
    lda dirent,y
    jsr dpb2ad
    ply
    rts

print_cluster_no:
    ldy #F32DirEntry::FstClusHI+1
    lda dirent,y
    jsr krn_hexout
    dey
    lda dirent,y
    jsr krn_hexout

    ldy #F32DirEntry::FstClusLO+1
    lda dirent,y
    jsr krn_hexout
    dey
    lda dirent,y
    jsr krn_hexout
    rts

space:
    lda #' '
    jmp char_out
    ; rts

subtbl:		
    .word 10000
    .word 1000
    .word 100
    .word 10

.bss
dirent:           .res .sizeof(F32DirEntry)
tmp1: .res 1
tmp2: .res 1
tmp3: .res 1

.data

bigfile_marker_txt:
.asciiz ">64k "
.include "fat32.inc"
.include "common.inc"


.export print_filename, print_fat_date, print_fat_time, print_filesize, print_attribs, print_cluster_no, space

.autoimport

.code
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

    jsr strout
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

print_attribs:
    ldy #F32DirEntry::Attr
    lda dirent,y

    ldx #3
@al:
    bit attr_tbl,x
    beq @skip
    pha
    lda attr_lbl,x
    jsr char_out
    pla
    bra @next
@skip:
    pha
    jsr space
    pla
@next:
    dex
    bpl @al
    rts

print_cluster_no:
    ldy #F32DirEntry::FstClusHI+1
    lda dirent,y
    jsr hexout
    dey
    lda dirent,y
    jsr hexout

    ldy #F32DirEntry::FstClusLO+1
    lda dirent,y
    jsr hexout
    dey
    lda dirent,y
    jsr hexout
    rts

space:
    lda #' '
    jsr char_out
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
.rodata
attr_tbl:   .byte DIR_Attr_Mask_ReadOnly, DIR_Attr_Mask_Hidden,DIR_Attr_Mask_System,DIR_Attr_Mask_Archive
attr_lbl:   .byte 'R','H','S','A'
bigfile_marker_txt:
.asciiz ">64k "
subtbl:		
    .word 10000
    .word 1000
    .word 100
    .word 10


.bss
tmp1: .res 1
tmp2: .res 1
tmp3: .res 1

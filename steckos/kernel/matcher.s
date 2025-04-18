.include  "fat32.inc"
.include  "errno.inc"
.include  "zeropage.inc"

.export string_fat_mask_matcher
.export string_fat_mask

.importzp volatile_tmp, volatile_tmp2, filenameptr, dirptr, paramptr


; .segment "ZEROPAGE_LIB": zeropage
;   s_tmp1: .res 1
;   s_tmp2: .res 1

s_tmp1 = volatile_tmp
s_tmp2 = volatile_tmp2

.code
;   match input name[.[ext]] (8.3 filename) against 11 byte dir entry <name><ext>
;   note:
;     *.*  - matches any file or directory with extension
;     *  - matches any file or directory without extension
; req:
;   requires a previous call to string_fat_mask to build the fat mask upon user input
; in:
;   dirptr - pointer to dir entry (F32DirEntry)
; out:
;   C=1 on match, C=0 otherwise
string_fat_mask_matcher:
    ldy #.sizeof(F32DirEntry::Name) + .sizeof(F32DirEntry::Ext) - 1
__dmm:
    lda (paramptr),y
    cmp #'?'
    beq __dmm_next
    cmp (dirptr), y
    bne __dmm_neq
__dmm_next:
    dey
    bpl __dmm
    rts ;exit, C=1 here from cmp above
__dmm_neq:
    clc
    rts

; build 11 byte fat file name (8.3) as used within dir entries
; in:
;   A/Y - pointer to result address where the fat file name mask should be stored
;   filenameptr pointer to input string to convert to fat file name mask
; out:
;   C=1 if input was too large (>255 byte), C=0 otherwise
;   Z=1 if input was empty string, Z=0 otherwise
string_fat_mask:
    sta paramptr
    sty paramptr+1
    ; jsr string_trim        ; trim input
    ; bcs __tfm_exit          ; C=1, overflow
    ; beq __tfm_exit          ; Z=1, empty input

    stz s_tmp1
    ldy #0
__tfn_mask_input:
    sty s_tmp2
    ldy s_tmp1
    lda (filenameptr), y
    beq __tfn_mask_fill_blank
    inc s_tmp1
    cmp #'.'
    bne __tfn_mask_qm
    ldy s_tmp2
    beq __tfn_mask_char_l2    ; first position, we capture the "."
    cpy #8              ; reached from here from first fill (the name) ?
    beq __tfn_mask_input
    cpy #1              ; 2nd position?
    bne __tfn_mask_fill_blank  ; no, fill section
    cmp  (paramptr)        ; otherwise check whether we already captured a "." as first char
    beq __tfn_mask_char_l2
__tfn_mask_fill_blank:
    lda #' '
    bra __tfn_mask_fill
__tfn_mask_qm:
    cmp #'?'
    bne __tfn_mask_star
    sec                ; save only 1 char in fill
    bra __tfn_mask_fill_l1
__tfn_mask_star:
    cmp #'*'
    bne __tfn_mask_char
    lda #'?'
__tfn_mask_fill:
    clc
__tfn_mask_fill_l1:
    ldy s_tmp2
__tfn_mask_fill_l2:
    sta (paramptr), y
    iny
    bcs __tfn_mask_input      ; C=1, then go on next char
    cpy #8
    beq __tfn_mask_input    ; go on with extension
    cpy #8+3
    bne __tfn_mask_fill_l2
    clc
__tfm_exit:
    rts
__tfn_mask_char:
    cmp #'a' ; Is lowercase?
    bcc __tfn_mask_char_l1
    cmp #'z'+1
    bcs __tfn_mask_char_l1
    and #$DF
__tfn_mask_char_l1:
    ldy s_tmp2
__tfn_mask_char_l2:
    sta (paramptr), y
    iny
    cpy #8+3
    bne __tfn_mask_input
    clc
    rts

; trim string, remove leading and trailing white space
; in:
;  filenameptr with input string to trim
; out:
;  the trimmed string at filenameptr
;  Z=0 and A=length of string, Z=1 if string was trimmed to empty string (A=0)
;  C=1 on string overflow, means input >255 byte
string_trim:
      stz s_tmp1
      stz s_tmp2
@l_1:
      ldy  s_tmp1
      inc  s_tmp1
      lda  (filenameptr),  y
      beq  @l_2
      cmp  #' '+1
      bcc  @l_1          ; skip all chars within 0..32
@l_2: ldy  s_tmp2
      sta  (filenameptr), y
      cmp  #0          ; was end of string?
      beq  @l_st_ex
      inc  s_tmp2
      bne  @l_1
      sec
      rts
@l_st_ex:
      clc        ;
      tya        ; length to A
      rts

; in:
;  A - char to check whether it is legal to build a fat file name or extension
; out:
;  C=0 on success, C=1 otherwise which means input char is invalid
string_illegalchar:
      ldx #(__illegalchars_end - __illegalchars) -1          ; x to length(blacklist)-1
__illegalchar_l1:
      cmp __illegalchars, x
      beq __illegalchar_ex
      dex
      bpl __illegalchar_l1
      clc
      rts
__illegalchar_ex:
      lda #EINVAL
      sec
      rts
__illegalchars:
      .byte "?*+,/:;<=>\[\|",'"',127
__illegalchars_end:


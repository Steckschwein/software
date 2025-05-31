; @module: vdp
.include "vdp.inc"



.export vdp_init, vdp_bgcolor, vdp_fill, vdp_text_on, vdp_memcpy
.export vdp_nopslide_2m, vdp_nopslide_8m, vdp_nopslide_end

.import charset_6x8
.importzp vdp_ptr

.code

m_vdp_nopslide

;@name: vdp_init
;@desc: init vdp, set text mode 2, blank screen, load charset into vram
vdp_init:
    lda #VIDEO_COLOR
    jsr vdp_text_on

    jsr vdp_text_blank

    vdp_vram_w ADDRESS_TEXT_PATTERN
    lda #<charset_6x8
    ldy #>charset_6x8
    ldx #$08                    ;load charset
    ; jmp vdp_memcpy
    ; fall through to vdp_memcpy

;@name: vdp_memcpy
;@desc: copy data from host memory denoted by pointer (A/Y) to vdp VRAM (page wise). the VRAM address must be setup beforehand e.g. with macro vdp_vram_w <address>
;@in: X - amount of 256byte blocks (page counter)
;@in: A/Y - pointer to source data
vdp_memcpy:
    sta vdp_ptr
    sty vdp_ptr+1
    ldy #0
:   
    vdp_wait_l 10 ;3 + 5 + 2 + 1 opcode fetch =10 cl for inner loop, +10 cl outer loop
    lda (vdp_ptr),y ;5
    sta a_vram    ;1
    iny         ;2
    bne :-
    inc vdp_ptr+1  ;5
    dex         ;2
    bne :-
    vdp_wait_l 6
    rts


;@name: vdp_text_blank
;@desc: text mode blank screen and color vram
vdp_text_blank:
    vdp_vram_w ADDRESS_TEXT_SCREEN
    ldx #8
    lda #' '
    jsr vdp_fill
    ldx #72 ; 26.5*80 = 2120 => 2120 - 2048 = 72 bytes left to clear
    jsr vdp_fills
    vdp_vram_w ADDRESS_TEXT_COLOR
    lda #0
    ldx #2
    ; jmp vdp_fill

;@name: vdp_fill
;@desc: fill vdp VRAM with given value page wise
;@in: A - byte to fill
;@in: X - amount of 256byte blocks (page counter)
vdp_fill:
    ldy #0
@1:  
    vdp_wait_l 4
    iny         ;2
    sta a_vram
    bne @1       ;3
    dex
    bne @1
    vdp_wait_l 6
    rts

;@name: vdp_fills
;@desc: fill vdp VRAM with given value
;@in: A - value to write
;@in: X - amount of bytes
vdp_fills:
@0: vdp_wait_l 6  ;3 + 2 + 1 opcode fetch
    dex        ;2
    sta a_vram    ;4
    bne  @0      ;3
    vdp_wait_l 6
    rts

;@name: vdp_bgcolor
;@in: A - color
vdp_bgcolor:
    ldy #v_reg7

;@name: vdp_set_reg
;@desc: set value to vdp register
;@in: A - value
;@in: Y - register
vdp_set_reg:
    vdp_wait_s 6 ; 6cl already wasted by jsr
    sta a_vreg
    vdp_wait_s
    sty a_vreg
    rts


;@name: vdp_text_on
;@desc: text mode - 40x24/80x24 character mode, 2 colors
;@in: A - color settings (#R07)
vdp_text_on:
    php
    sei

    pha ; push color

    lda #<vdp_text_init_bytes
    ldy #>vdp_text_init_bytes
    ldx #(vdp_text_init_bytes_end-vdp_text_init_bytes-1)
    jsr vdp_init_reg


    pla
    jsr vdp_bgcolor


    plp
    rts


;@name: vdp_init_reg
;@desc: setup video registers upon given table starting from register #R.X down to #R0
;@in: X - length of init table, corresponds to video register to start R#+X - e.g. X=10 start with R#10
;@in: A/Y - pointer to vdp init table
vdp_init_reg:
    php
    sei

    sta vdp_ptr
    sty vdp_ptr+1
    txa       ; x length of init table
    tay
    ora #$80  ; bit 7 = 1 => register write
    tax
@l:   
    vdp_wait_s 7
    lda (vdp_ptr),y ; 5c
    sta a_vreg
    vdp_wait_s
    stx a_vreg
    dex        ;2c
    dey        ;2c
    vdp_wait_l 

    bpl @l     ;3c

    vdp_sreg 0, v_reg23  ; reset vertical scroll
    vdp_sreg v_reg25_wait | v_reg25_cmd, v_reg25  ; enable V9958 /WAIT pin, enable CMD on lower screen modes

    plp
    rts

.rodata
vdp_text_init_bytes:
    .byte v_reg0_m4 ; R#0
    .byte v_reg1_16k|v_reg1_display_on|v_reg1_spr_size|v_reg1_m1|v_reg1_int ; #R01
    .byte >(ADDRESS_TEXT_SCREEN>>2) | $03                       ; name table - value * $1000 (v9958)    R#02
    .byte >(ADDRESS_TEXT_COLOR<<2) | $07                        ; color table - value * $1000 (v9958)
    .byte >(ADDRESS_TEXT_PATTERN>>3)                            ; pattern table (charset) - value * $800    --> offset in VRAM
    .byte 0  ; not used
    .byte 0  ; not used
    .byte Gray<<4|Black                                         ; blink color to inverse text / off phase #R07 
    .byte v_reg8_VR  | v_reg8_SPD                               ; VR - 64k VRAM TODO FIXME aware of max vram (bios) - #R08
    .byte v_reg9_nt                                             ; #R9, set bit to 1 for PAL
    .byte <.HIWORD(ADDRESS_TEXT_COLOR<<2)                       ;#R10
    .byte 0
    .byte Black<<4|Light_Green                                       ; blink color to inverse text / on phase #R12
    .byte %00100010                                             ; blink frequency high nibble -> time to show color from #R07   #R13
                                                                ;                  low nibble -> time to show color from #R12 
    .byte <.HIWORD(ADDRESS_TEXT_SCREEN<<2)
vdp_text_init_bytes_end:
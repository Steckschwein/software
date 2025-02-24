.include "vdp.inc"
.include "console.inc"
.include "common.inc"

.export console_init, console_update_screen, console_putchar, console_put_cursor
.export crs_x, crs_y
.import vdp_memcpy

.zeropage
console_ptr:   .res 2
cursor_ptr:    .res 2

.bss 
crs_x:          .res 1
crs_y:          .res 1


vdp_addr:       .res 2
vdp_addr_old:   .res 2

vdp_cursor_val: .res 1
screen_status:  .res 1

.code
console_init:

    SetVector screen_buffer, console_ptr
    copypointer console_ptr, cursor_ptr

    stz crs_x
    stz crs_y
    stz vdp_addr_old
    stz vdp_addr_old+1
    

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 
    
    jsr console_clear_screenbuf
   
    pla 
    sta slot2_ctrl

    copypointer console_ptr, cursor_ptr

    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status

    rts

console_update_screen:
    bit screen_status ; screen dirty bit set?
    bpl @exit

    ; yes, write to vdp
    vdp_vram_w ADDRESS_TEXT_SCREEN
    
    lda slot2_ctrl
    pha 

    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 

    lda console_ptr
    ldy console_ptr+1
    ldx #8
    jsr vdp_memcpy
    
    pla
    sta slot2_ctrl

    ; clear dirty bit
    lda screen_status
    and #!(SCREEN_DIRTY)
    sta screen_status

@exit:
    jmp console_put_cursor
    ; rts 


console_clear_screenbuf:
 
    lda #' '
    ldx #8
@loop:
    ldy #0
:

    sta (cursor_ptr),y
    iny 
    bne :-

    inc cursor_ptr+1

    dex 
    bne @loop

    rts

console_get_pointer_from_cursor:
    save 
    copypointer console_ptr, cursor_ptr

    ldy crs_y
    beq @add_x
:
    clc 
    lda #COLS 
    adc cursor_ptr
    sta cursor_ptr

    lda #0
    adc cursor_ptr+1
    sta cursor_ptr+1

    dey 
    bne :-
@add_x:
    clc 
    lda crs_x
    adc cursor_ptr
    sta cursor_ptr

    lda #0
    adc cursor_ptr+1
    sta cursor_ptr+1 

    restore
    rts

console_advance_cursor:
    lda crs_y
    lda crs_x
    inc a
    sta crs_x 
    cmp #COLS 
    bne :+
    inc crs_y
    stz crs_x
:
    rts

console_put_cursor:

    lda vdp_addr_old
    sta a_vreg
    vdp_wait_s
    lda vdp_addr_old+1
    sta a_vreg 

    vdp_wait_l 6
    stz a_vram



    lda crs_y
    asl
    tax
    lda multab+1,x 
    sta vdp_addr+1
    lda multab,x 
    sta vdp_addr

    ; add x position
    lda crs_x
    clc 
    adc vdp_addr
    sta vdp_addr
    lda #0
    adc vdp_addr+1
    sta vdp_addr+1

    ; get bit offset 
    lda vdp_addr
    and #%00000111
    tax 
    lda bitval,x
    sta vdp_cursor_val

    ; divide by 8 to get the byte offset
    lsr vdp_addr+1
    ror vdp_addr
    lsr vdp_addr+1
    ror vdp_addr
    lsr vdp_addr+1
    ror vdp_addr

    clc
    lda #<ADDRESS_TEXT_COLOR
    adc vdp_addr
    sta vdp_addr 
    lda #>ADDRESS_TEXT_COLOR
    adc vdp_addr+1
    sta vdp_addr+1

    lda vdp_addr
    sta vdp_addr_old
    sta a_vreg
    vdp_wait_s
    lda vdp_addr+1
    ora #WRITE_ADDRESS
    and #%01111111
    sta vdp_addr_old+1
    sta a_vreg 

    vdp_wait_l 6
    lda vdp_cursor_val
    sta a_vram

    rts

console_putchar:

    ; handle line feed character
    ; just increase cursor y position
    cmp #CODE_LF
    bne :+
    inc crs_y
    stz crs_x
    rts
:

    ; handle carriage return character
    ; just reset cursor x position
    cmp #CODE_CR 
    bne :+
    stz crs_x
    rts
: 

    pha 
    phx

    jsr console_get_pointer_from_cursor
    
    ldx slot2_ctrl
    phx

    ldx #SCREEN_BUFFER_PAGE
    stx slot2_ctrl 

    
    sta (cursor_ptr)

    plx 
    stx slot2_ctrl  

    jsr console_advance_cursor

    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status

    plx
    pla 
    rts

.rodata 
multab:
    .word 0*80
    .word 1*80
    .word 2*80
    .word 3*80
    .word 4*80
    .word 5*80
    .word 6*80
    .word 7*80
    .word 8*80
    .word 9*80
    .word 10*80
    .word 11*80
    .word 12*80
    .word 13*80
    .word 14*80
    .word 15*80
    .word 16*80
    .word 17*80
    .word 18*80
    .word 19*80
    .word 20*80
    .word 21*80
    .word 22*80
    .word 23*80
    .word 24*80
    .word 25*80
    .word 26*80
bitval:
    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

    

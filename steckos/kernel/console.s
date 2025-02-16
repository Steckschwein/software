.include "vdp.inc"
.include "console.inc"
.include "common.inc"

.export console_init, console_update_screen, console_putchar
.import vdp_memcpy

.zeropage
console_ptr:   .res 2
cursor_ptr:    .res 2

.bss 
crs_x: .res 1
crs_y: .res 1
screen_status: .res 1

.code
console_init:

    SetVector screen_buffer, console_ptr
    copypointer console_ptr, cursor_ptr

    stz crs_x
    stz crs_y

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
    rts 


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

console_putchar:
    pha 
    phx
      
    ldx slot2_ctrl
    phx

    ldx #SCREEN_BUFFER_PAGE
    stx slot2_ctrl 
    
    sta (cursor_ptr)

    plx 
    stx slot2_ctrl  
    
    inc16 cursor_ptr

    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status

    plx 
    pla
    rts

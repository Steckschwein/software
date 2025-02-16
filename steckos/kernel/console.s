.include "vdp.inc"
.include "console.inc"
.include "common.inc"

.export console_init, console_update_screen, console_putchar

.import screen_status
.import vdp_memcpy

.zeropage
console_ptr:   .res 2
cursor_ptr:    .res 2


.code
console_init:

    SetVector screen_buffer, console_ptr
    copypointer console_ptr, cursor_ptr

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 
    
    jsr console_clear_screenbuf
   
    pla 
    sta slot2_ctrl

    rts

console_update_screen:
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

    lda screen_status
    and #!(SCREEN_DIRTY)
    sta screen_status

    rts 


console_clear_screenbuf:
    lda #' '
    ldx #0
:
    sta screen_buffer,x
    sta screen_buffer + $100,x
    sta screen_buffer + $200,x
    sta screen_buffer + $300,x
    sta screen_buffer + $400,x
    sta screen_buffer + $500,x
    sta screen_buffer + $600,x
    sta screen_buffer + $700,x
    
    inx 
    bne :-
    rts

console_putchar:
      
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

    rts

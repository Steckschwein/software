.include "vdp.inc"
.include "console.inc"
.include "common.inc"

; @module: console

.export console_init, console_update_screen, console_putchar, console_put_cursor, console_handle_control_char, console_clear_screenbuf, console_chrout
.export crs_x, crs_y
.import vdp_memcpy, key

.importzp console_ptr, cursor_ptr, scroll_src_ptr, scroll_trg_ptr


.bss 
; .segment "ZP_EXT"
crs_x:          .res 1
crs_y:          .res 1
crs_x_sav:      .res 4
crs_y_sav:      .res 4
vdp_addr:       .res 2
vdp_addr_old:   .res 2
screen_status:  .res 1
current_console: .res 1
ansi_index:  .res 1
ansi_state:  .res 1
ansi_param1: .res 1
ansi_param2: .res 1

.code
;@name: console_init
;@desc: init console
console_init:
    stz crs_x
    stz crs_y
    stz vdp_addr_old
    stz vdp_addr_old+1

    ldx #2
:
    stz crs_x_sav,x
    stz crs_y_sav,x
    dex 
    bpl :-   
    

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 

    lda #1
    jsr console_set_screen_buffer
    jsr console_clear_screenbuf
    lda #0
    jsr console_set_screen_buffer
    jsr console_clear_screenbuf


    pla 
    sta slot2_ctrl

    copypointer console_ptr, cursor_ptr


    rts

;@name: console_set_screen_buffer
;@desc: switch to screen buffer number in A
;@in: A - screen buffer number to switch to
console_set_screen_buffer:
    asl 
    tax

    ldy current_console
    lda crs_x
    sta crs_x_sav,y 

    lda crs_y
    sta crs_y_sav,y 

    
    lda screen_buffer_list,x 
    sta console_ptr
    lda screen_buffer_list+1,x 
    sta console_ptr+1

    lda crs_x_sav,x 
    sta crs_x 
    lda crs_y_sav,x
    sta crs_y

    copypointer console_ptr, cursor_ptr

    stx current_console

    ; fall through to console_set_screen_dirty
    
console_set_screen_dirty:
    lda screen_status
    ora #SCREEN_DIRTY
    sta screen_status
    rts


;@name: console_update_screen
;@desc: update vdp text screen memory with contents from console buffer
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
    ldx #SCREEN_BUFFER_SIZE
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

;@name: console_clear_screenbuf
;@desc: clear screenbuffer area pointed to by cursor_ptr
;@in: console_ptr - address of buffer 
console_clear_screenbuf:
    copypointer console_ptr, scroll_trg_ptr

    lda slot2_ctrl
    pha
    lda #SCREEN_BUFFER_PAGE
    sta slot2_ctrl 
    
    lda #' '
    ldx #SCREEN_BUFFER_SIZE

@loop:
    ldy #0
:

    sta (scroll_trg_ptr),y
    iny 
    bne :-

    inc scroll_trg_ptr+1

    dex 
    bpl @loop


    pla
    sta slot2_ctrl
    


    stz crs_x
    stz crs_y
    jsr console_put_cursor

    ; jmp console_set_screen_dirty
    rts

;@name: console_get_pointer_from_cursor
;@desc: calculate screen buffer address for cursor position in crs_x/crs_y
;@in: crs_x - cursor x position
;@in: crs_y - cursor y position
console_get_pointer_from_cursor:
    save 

    lda crs_y
    asl
    tax 

    clc 
    lda multab,x 
    adc console_ptr
    sta cursor_ptr

    lda multab+1,x 
    adc console_ptr+1
    sta cursor_ptr+1

    ; add x position
    clc 
    lda crs_x
    beq @exit
    adc cursor_ptr
    sta cursor_ptr

    lda #0
    adc cursor_ptr+1
    sta cursor_ptr+1 

@exit:
    restore
    rts



;@name: console_put_cursor
;@desc: place cursor at position pointed to by crs_x/crs_y
;@in: crs_x - cursor x position
;@in: crs_y - cursor y position
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

    ; get bit offset, part 1 
    lda vdp_addr
    and #%00000111
    tax 

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
    ; get bit offset, part 2
    lda bitval,x
    sta a_vram

    rts

;@name: console_cursor_down
;@desc: move cursor down by 1 row, scroll screen buffer when reached row 24
console_cursor_down:
    pha
    lda crs_y
    cmp #ROWS-1
    bne :+
    
    jsr console_scroll
    bra @exit
:
    inc crs_y
@exit:
    pla
    rts

;@name: console_cursor_right
;@desc: increase cursor x position. wrap around when x = 80.
;@in: crs_x - cursor x position
;@in: crs_y - cursor y position
;@out: crs_x - cursor x position
;@out: crs_y - cursor y position
console_cursor_right:
    lda crs_x
    inc a
    sta crs_x 
    cmp #COLS 
    bne :+
    jsr console_cursor_down
    stz crs_x
:
    rts

console_cursor_left:
    lda crs_x
    beq :+
    dec crs_x
    bra @exit
:
    lda #COLS-1
    sta crs_x 
    dec crs_y
@exit:
    rts

;@name: console_chrout
;@desc: print character in A at current cursor position.
;@desc: handle ANSI ESC sequences
;@example: lda #'A'
;@example: jsr console_chrout
;@in: A - character to print
console_chrout:
    bit ansi_state
    bmi @check_csi
    bvs @store_csi_byte
    cmp #ESCAPE
    bne @out
    pha
    lda #$80
    sta ansi_state
    pla
    rts
@check_csi:
    cmp #CSI
    beq @is_csi
    stz ansi_state
@out:
    jmp console_putchar
@is_csi:
    ; next bytes will be the ansi sequence
    pha
    lda #$40
    sta ansi_state
    stz ansi_index
    pla
    rts
@store_csi_byte:
    ; number? $30-$39
    cmp #'0'
    bcs :+
    stz ansi_state
    rts
:
    cmp #'9'+1
    bcc @store

    cmp #';'
    bne @cont
    inc ansi_index
    dec ansi_state
    rts
@cont:
    cmp #'J'
    bne :+
    lda #2
    cmp ansi_param1
    bne :+

    stz ansi_state
    jmp console_clear_screenbuf
:
    cmp #'A' ; cursor up
    bne :+
    lda crs_y
    sec
    sbc ansi_param1
    sta crs_y
    bra @seq_end
:
    cmp #'B' ; cursor up
    bne :+
    lda crs_y
    clc
    adc ansi_param1
    sta crs_y
    bra @seq_end
:
    cmp #'C' ; cursor right
    bne :+
    lda crs_x
    sec
    sbc ansi_param1
    sta crs_x
    bra @seq_end
:
    cmp #'D' ; cursor left
    bne :+
    lda crs_x
    clc
    adc ansi_param1
    sta crs_x
    bra @seq_end
:
    cmp #'H'
    bne :+

    lda ansi_param1
    sta crs_x
    lda ansi_param2
    sta crs_y
    bra @seq_end
:
    ; TODO
    ; Is alphanumeric?
    ; end sequence and execute requested action
@seq_end:
    stz ansi_state
    jmp console_put_cursor
    ;rts
@store:

    phx
    phy
    ldx ansi_index

    ; Convert digit in A to binary
    and #%11001111
    pha

    ; bit 0 of ansi_state set?
    ; no? multiply by 10, then store to ansi_param1
    ; yes? skip multiplication, and add to ansi_param1
    lda ansi_state
    ror
    bcc @skip

    ldy ansi_param1,x
    clc
    pla
    adc mult_by_ten,y
    sta ansi_param1,x

    bra @end
@skip:
    pla
    sta ansi_param1,x
    inc ansi_state ; set bit 0 of ansi_state to indicate the first digit has been processed

@end:
    ply
    plx
    rts


;@name: console_putchar
;@desc: print character in A at current cursor position. handle CR/LF.
;@in: A - character to print
;@in: crs_x - cursor x position
;@in: crs_y - cursor y position
console_putchar:
    ; handle line feed character
    ; just increase cursor y position
    cmp #CODE_LF
    bne :+
    jsr console_cursor_down
    stz crs_x
    rts
:

    cmp #CODE_CR 
    bne :+
    stz crs_x
    rts
: 
    cmp #KEY_BACKSPACE
    bne :+
    jsr console_cursor_left
    lda #' '
    jmp console_update_char
:
    jsr console_update_char
    jmp console_cursor_right
    ; rts

console_update_char:
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


    jsr console_set_screen_dirty

    plx
    pla 
    rts 

;@name: console_handle_control_char
;@desc: handle control character in A.
;@in: A - control char
;@in: crs_x - cursor x position
;@in: crs_y - cursor y position
console_handle_control_char:
    cmp #CODE_CURSOR_DOWN
    bne :+
    jsr console_cursor_down

    bra @exit
:   
    cmp #CODE_CURSOR_UP
    bne :+
    ldx crs_y
    cpx #0
    beq @exit
    dex 
    stx crs_y
    bra @exit
:
    cmp #CODE_CURSOR_LEFT
    bne :+
    jsr console_cursor_left
    bra @exit

:
    cmp #CODE_CURSOR_RIGHT
    bne :+
    jsr console_cursor_right
    bra @exit
:

    cmp #KEY_FN1
    bne :+
    lda #0
    jsr console_set_screen_buffer
    bra @exit
:
    cmp #KEY_FN2
    bne :+
    lda #1
    jsr console_set_screen_buffer
    bra @exit
:
;     cmp #KEY_FN3
;     bne :+
;     lda #2
;     jsr console_set_screen_buffer
;     bra @exit
; :
;     cmp #KEY_FN4
;     bne :+
;     lda #3
;     jsr console_set_screen_buffer
;     bra @exit
; :

    rts
@exit:
    lda #0
    stz key
    clc
    rts

;@name: console_scroll
;@desc: scroll screen buffer up 1 row
console_scroll:
    save
    ; setup pointers
    ; target pointer start at console_ptr
    copypointer console_ptr, scroll_trg_ptr
    
    ; source pointer starts at console_ptr plus one line
    clc
    lda scroll_trg_ptr
    adc #COLS
    sta scroll_src_ptr 

    lda scroll_trg_ptr+1
    adc #0 
    sta scroll_src_ptr+1

    ldx slot2_ctrl
    phx

    ldx #SCREEN_BUFFER_PAGE
    stx slot2_ctrl 

    ldx #SCREEN_BUFFER_SIZE
@scroll_row:
    ldy #0
@loop:
    lda (scroll_src_ptr),y 
    sta (scroll_trg_ptr),y 
    iny
    bne @loop

    inc scroll_src_ptr+1
    inc scroll_trg_ptr+1
    
    dex
    bne @scroll_row

    
    plx 
    stx slot2_ctrl  
    

    jsr console_set_screen_dirty

    restore
    rts

.rodata 
multab:
    .repeat 24, i 
        .word i * COLS 
    .endrepeat

mult_by_ten:  
    .byte 0,10,20,30,40,50,60,70,80,90

bitval:
    .byte %10000000
    .byte %01000000
    .byte %00100000
    .byte %00010000
    .byte %00001000
    .byte %00000100
    .byte %00000010
    .byte %00000001

screen_buffer_list:
    .word screen_buffer0
    .word screen_buffer1
    .word screen_buffer2
    .word screen_buffer3

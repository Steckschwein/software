; MIT License
;
; Copyright (c) 2025 Thomas Woinke, Marko Lauke, www.steckschwein.de
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
.ifdef DEBUG_KERNEL ; debug switch for this module
  debug_enabled=1
.endif


.include "kernel.inc"

.export char_out, char_in, set_input, set_output
.export out_vector, in_vector
.import init_uart, uart_tx, uart_rx, primm, wozmon

OUTPUT_DEVICE_UART = 1
INPUT_DEVICE_UART = 1

.zeropage
out_vector:     .res 2
in_vector:     .res 2


.code

do_reset:

    ; init stack pointer
    ldx #$ff
    txs

    jsr init_uart

    lda #INPUT_DEVICE_UART
    jsr set_input
    lda #OUTPUT_DEVICE_UART
    jsr set_output


    
    jsr primm 
    .byte CODE_LF, CODE_LF, "Steckschwein!!", CODE_LF, 0

    jmp wozmon



char_out:
    jmp (out_vector)

char_in:
    jmp (in_vector)

do_irq:
    rti


do_nmi:
    rti

; device in a
set_output:
    asl
    tax
    lda output_vectors,x
    sta out_vector
    inx
    lda output_vectors,x
    sta out_vector+1
    rts 

; device in a
set_input:
    asl 
    tax
    lda input_vectors,x
    sta in_vector
    ; inx
    lda input_vectors+1,x
    sta in_vector+1
    rts 



; .rodata


output_vectors:
.word $dead 
.word uart_tx
.word $dead 
.word $dead 
input_vectors:
.word $0101
.word uart_rx
.word $0202 
.word $0303 





.segment "VECTORS"
; ----------------------------------------------------------------------------------------------
; Interrupt vectors
; ----------------------------------------------------------------------------------------------
; $FFFA/$FFFB NMI Vector
.word do_nmi
; $FFFC/$FFFD reset vector
.word do_reset
; $FFFE/$FFFF IRQ vector
.word do_irq

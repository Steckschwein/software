; @module: io
.include "system.inc"

.import output_vectors, input_vectors
.export hexout, primm, char_in, char_out
.export set_input, set_output, in_vector, out_vector

.zeropage
out_vector:    .res 2
in_vector:     .res 2
DPL: .res 1
DPH: .res 1

.code
char_out:
    jmp (out_vector)

char_in:
    jmp (in_vector)



;@name: set_output
;@desc: set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
set_output:
    asl
    tax
    lda output_vectors,x
    sta out_vector
    lda output_vectors+1,x
    sta out_vector+1
    rts 

;@name: set_input
;@desc: set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
set_input:
    asl 
    tax
    lda input_vectors,x
    sta in_vector
    lda input_vectors+1,x
    sta in_vector+1
    rts 


; @name: hexout
; @desc: print value in A as 2 hex digits
; @in: A - value to print
hexout:
    pha
    pha

    lsr     ; msb first
    lsr
    lsr
    lsr
    ; https://twitter.com/adumont/status/1381857942467702785
    sed
    cmp #$0a
    adc #$30
    cld
    jsr char_out

    pla
    and #$0f    ;mask lsd for hex print

    sed
    cmp #$0a
    adc #$30
    cld
_out:
    jsr char_out

    pla
    rts
; @name: primm
; @desc: print string inlined after call to primm terminated by null byte - see http://6502.org/source/io/primm.htm
primm:
   pla               ; get low part of (string address-1)
   sta   DPL
   pla               ; get high part of (string address-1)
   sta   DPH
   bra   primm3
primm2:
   jsr   char_out        ; output a string char
primm3:
   inc   DPL         ; advance the string pointer
   bne   primm4
   inc   DPH
primm4:
   lda   (DPL)       ; get string char
   bne   primm2      ; output and continue if not NUL
   lda   DPH
   pha
   lda   DPL
   pha
   rts               ; proceed at code following the NUL


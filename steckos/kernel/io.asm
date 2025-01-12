.include "kernel.inc"

.import char_out
.export hexout, primm

.zeropage
DPL: .res 1
DPH: .res 1

.code
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

primm:
   pla                  ; Get the low part of "return" address (data start address)
   sta     DPL
   pla
   sta     DPH             ; Get the high part of "return" address (data start address)
   ; Note: actually we're pointing one short
PSINB:
   ldy     #1
   lda     (DPL),y         ; Get the next string character
   inc     DPL             ; update the pointer
   bne     PSICHO          ; if not, we're pointing to next character
   inc     DPH             ; account for page crossing
PSICHO:
   ora     #0              ; Set flags according to contents of Accumulator
   beq     PSIX1           ; don't print the final NULL
   jsr     char_out         ; write it out
   bra     PSINB           ; back around
PSIX1:
   inc     DPL             ;
   bne     PSIX2           ;
   inc     DPH             ; account for page crossing
PSIX2:
   jmp     (DPL)           ; return to byte following final NULL
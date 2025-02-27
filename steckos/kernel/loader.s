.include "common.inc"
.include "system.inc"
.include "appstart.inc"

.import 	__KERNEL_START__



; system attribute has to be set on file system
.zeropage
p_src:    .res 2
p_tgt:    .res 2

.code 
   appstart $1000
   
   lda #31 ; enable RAM at slot3
   sta slot3_ctrl

   sei ; no irq if we upload from kernel to avoid clash
   ; copy kernel code to kernel_start
   lda #>payload
   sta p_src+1
   stz p_src

   lda #>__KERNEL_START__
   sta p_tgt+1
   stz p_tgt

   ldy #0
loop:
   lda (p_src),y
   sta (p_tgt),y
   iny
   bne loop
   inc p_src+1
   inc p_tgt+1
   lda p_src+1
   cmp #>payload_end
   bne loop
   ; jump to reset vector
   jmp ($fffc)

.data
payload:
.incbin "kernel.bin"
payload_end:

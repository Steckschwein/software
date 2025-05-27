.ifndef _BLKLAYER_INC_
  _BLKLAYER_INC_ = 1

BLKL_WRITE_PENDING = 1<<7

.struct _blkl_state
  blk_lba .dword
  blk_ptr .word
  tmp_lba .dword
  tmp_ptr .word
  status  .byte
.endstruct

; Z=1 if equal, Z=0 otherwise and branch to given label
;
.macro _blkl_cmp32_x op1, op2, _label
   lda op1+0, x
   cmp op2+0
   bne _label
   lda op1+1, x
   cmp op2+1
   bne _label
   lda op1+2, x
   cmp op2+2
   bne _label
   lda op1+3, x
   cmp op2+3
   bne _label
.endmacro

.macro _blkl_cmp16_x op1, op2, _label
  lda op1+0, x
  cmp op2+0
  bne _label
  lda op1+1, x
  cmp op2+1
  bne _label
.endmacro

.macro _block_loaded _label
  _blkl_cmp32_x blklayer_store+_blkl_state::blk_lba, lba_addr, _label
  _blkl_cmp16_x blklayer_store+_blkl_state::blk_ptr, sd_blkptr, _label
.endmacro

.endif  ; _BLKLAYER_INC_

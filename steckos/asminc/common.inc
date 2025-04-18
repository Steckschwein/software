.ifndef _COMMON_INC_
  _COMMON_INC_ = 1

.macro SetVector word, addr
      lda #<word
      sta addr
      lda #>word
      sta addr+1
.endmacro

.macro add16to32 _a32, _a16, _res
    clc
    lda _a32+0
    adc _a16+0
    sta _res+0
    lda _a32+1
    adc _a16+1
    sta _res+1
    lda _a32+2
    adc #0
    sta _res+2
    lda _a32+3
    adc #0
    sta _res+3
.endmacro

.macro nops _n
  .repeat _n
    nop
  .endrep
.endmacro

.macro inc16 _w
   .local @exit
   inc _w
  bne @exit
  inc _w+1
@exit:
.endmacro

.macro _add_n _val1, _val2, _res, _bytes
    clc
    .repeat _bytes, i
        lda _val1+i
        adc _val2+i
        sta _res+i
    .endrepeat
.endmacro

.macro _add_n_x _val1, _val2, _res, _bytes
    clc
    .repeat _bytes, i
        lda _val1+i,x
        adc _val2+i,x
        sta _res+i,x
    .endrepeat
.endmacro

.macro add32 _val1, _val2, _res
    _add_n _val1, _val2, _res, 4
.endmacro

.macro add16 _val1, _val2, _res
    _add_n _val1, _val2, _res, 2
.endmacro

.macro add32_x _val1, _val2, _res
    _add_n_x _val1, _val2, _res, 4
.endmacro

.macro _sub_n _val1, _val2, _res, _bytes
    sec
    .repeat _bytes, i
        lda _val1+i
        sbc _val2+i
        sta _res+i
    .endrepeat
.endmacro

.macro sub32 _val1, _val2, _res
    _sub_n _val1, _val2, _res, 4
.endmacro
.macro sub16 _val1, _val2, _res
    _sub_n _val1, _val2, _res, 2
.endmacro

.macro _inc32_x val
      .local @lbl
      inc val+0,x
      bne @lbl
      inc val+1,x
      bne @lbl
      inc val+2,x
      bne @lbl
      inc val+3,x
@lbl:
.endmacro

.macro _inc32 val
    .local @l1
    inc val + 0
    bne @l1
    inc val + 1
    bne @l1
    inc val + 2
    bne @l1
    inc val + 3
@l1:
.endmacro

; Decrement the 32 bit value at memory location val by one.
;   A = ??, X & Y are unchanged.
.macro _dec32 val
    .local @l2,@l1,@l0
    lda val+0
    bne @l0
    lda val+1
    bne @l1
    lda val+2
    bne @l2
    dec val+3
@l2:  dec val+2
@l1:  dec val+1
@l0:  dec val+0
.endmacro

; Decrement the 24bit value at memory location val by one.
;   A = ??, X & Y are unchanged.
.macro _dec24 val
  .local @l1,@l0
      lda val+0
      bne @l0
      lda val+1
      bne @l1
      dec val+2
@l1:  dec val+1
@l0:  dec val+0
.endmacro

; Z=1 if equal, Z=0 otherwise and branch to given label
;
.macro _cmp32_x _s, _t, _lbl
   lda _s+0, x
   cmp _t+0, x
   bne _lbl
   lda _s+1, x
   cmp _t+1, x
   bne _lbl
   lda _s+2, x
   cmp _t+2, x
   bne _lbl
   lda _s+3, x
   cmp _t+3, x
   bne _lbl
.endmacro

.macro m_memcpy src, dest, n
   .local @l
   .assert n<=$80, error, "n must not > $80"
   .assert n<=$80, warn, "m_memcpy for n <= 2 does not save any space. are you sure you?"
   ldy #n-1
@l:
   lda src,y
   sta dest,y
   dey
   bpl @l
.endmacro

.macro m_memcpy2ptr src, ptr, n
    .local @l
    .assert n<=$80, error, "n must not > $80"
    ldy #n-1
@l:  lda src,y
    sta (ptr),y
    dey
    bpl @l
.endmacro

.macro m_memset dest, value, n
    .local @l
    .assert n<=$80, error, "n must not > $80"
    ldy #n-1
    lda #value
@l: sta dest,y
    dey
    bpl @l
.endmacro

.macro m_memclr dest, n
    .assert n<=$80, error, "n must not > $80"
    .local @l
    ldx #n-1
@l: stz dest,x
    dex
    bpl @l

.endmacro

.macro pushn addr, n
  .repeat n, i
    lda addr+i
    pha
  .endrepeat
.endmacro

.macro popn addr, n
  .repeat n, i
    pla
    lda addr+(n-i)
  .endrepeat
.endmacro

.macro saveptr ptr
  lda ptr
  pha
  lda ptr+1
  pha
.endmacro

.macro restoreptr ptr
  pla
  sta ptr+1
  pla
  sta ptr
.endmacro

.macro set_irq irq, irq_save
    copypointer $fffe, irq_save
    SetVector irq, $fffe
.endmacro

.macro restore_irq irq_save
    copypointer irq_save, $fffe
.endmacro

.macro copypointer fromptr, toptr
  .repeat 2, i
    lda fromptr+i
    sta toptr  +i
  .endrepeat
.endmacro

.macro save
  pha
  phy
  phx
.endmacro

.macro restore
  plx
  ply
  pla
.endmacro

.macro keyin
   .local @l
@l:
   jsr krn_getkey
   bcc @l
.endmacro

; swap nibbles of byte in A
;http://6502.org/source/general/SWN.html
.macro swap
  ASL  A
  ADC  #$80
  ROL  A
  ASL  A
  ADC  #$80
  ROL  A
.endmacro

.macro set_bit bit, location
  lda #bit
  ora location
  sta location
.endmacro

.macro clear_bit bit, location
  lda #bit
  eor #$ff
  and location
  sta location
.endmacro

.macro dec16 word
      lda word  ; 2cl
      bne :+    ;2/3cl
      dec word+1 ; 3cl
:     dec word  ; 3cl
.endmacro

.macro cmp16 op1, op2, _label
  lda op1+0
  cmp op2+0
  bne _label
  lda op1+1
  cmp op2+1
  bne _label
.endmacro

.macro cmp32 op1, op2, _label
  cmp16 op1+0, op2+0, _label  ; compare little endian - low byte first, propably the high bytes are changing rarely. e.g. cmp32 lba address
  cmp16 op1+2, op2+2, _label
.endmacro

; compare 32 bit - branch if equal
.macro cmp32eq op1, op2, _eq_label
    lda op1+0
    cmp op2+0
    bne :+
    lda op1+1
    cmp op2+1
    bne :+
    lda op1+2
    cmp op2+2
    bne :+
    lda op1+3
    cmp op2+3
    beq _eq_label
:
.endmacro

.macro cmp32ge op1, op2, _label
    lda op1+3
    cmp op2+3
    bcc @lt
    lda op1+2
    cmp op2+2
    bcc @lt
    lda op1+1
    cmp op2+1
    bcc @lt
    lda op1+0
    cmp op2+0
    bcs _label
    ;otherwise op1 < op2
@lt:
.endmacro

.macro printstring text
    print text
.endmacro

.macro print text
    jsr primm
    .byte text, 0
.endmacro

.macro println text
    jsr primm
    .byte text, CODE_LF, 0
.endmacro

.macro Copy src, trgt, len
		ldx #len

:   lda src,x
		sta trgt,x
		dex
		bpl :-
.endmacro

.macro toupper
	cmp #$60 ; Is lowercase?
	bcc :+
	and	#$DF
:
.endmacro

.macro tolower
  cmp #'A'
  bcc :+
  cmp #'Z'+1
  bcs :+
	ora #$20
:
.endmacro


.macro crlf
  lda #CODE_LF		;\n already does the carriage return
  jsr char_out
.endmacro

.macro sys_delay_ms millis
	sys_delay_us (millis * 1000)
.endmacro

.macro sys_delay_us micros
      .local @l1,@l2,@l3
      .assert (micros * clockspeed) >= 0, error, "micros to small!"
      .assert (>.HIWORD(micros * clockspeed)) = 0, error, "micros to large!"
      php
      pha
      phx
      phy
      lda #1+<.HIWORD(micros * clockspeed / 5)
@l1:  ldx #1+>(micros * clockspeed / 5)
@l2:  ldy #1+<(micros * clockspeed / 5) ; ~5cl inner loop
@l3:  dey
      bne @l3
      dex
      bne @l2
      dec
      bne @l1
      ply
      plx
      pla
      plp
.endmacro
.endif  ; _COMMON_INC_

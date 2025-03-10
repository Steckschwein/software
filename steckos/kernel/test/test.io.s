	.include "asmunit.inc" 	; test api
	
  .zeropage 
  tmp_ptr: .res 2
  .export tmp_ptr
  
	.import asmunit_chrout
  ; .export char_out=asmunit_chrout

  ; uut
	.import hexout, primm

.code

	test "hexout"

  lda #$55
  jsr hexout
	
  assertOut "55"
  assertA $55


  lda #0
  jsr hexout
	
  assertOut "00"
  assertA 0

  lda #$ff
  jsr hexout
	
  assertOut "FF"
  assertA $ff

  test "primm"

  lda #0
  jsr primm 
  .asciiz "Hello World!"

  assertOut "Hello World!"

	brk

.data

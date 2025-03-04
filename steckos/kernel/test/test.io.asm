	.include "asmunit.inc" 	; test api
	
	.import hexout, primm

	.import asmunit_chrout
	.export char=asmunit_chrout
	
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
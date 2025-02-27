.ifndef __DEBUG_INC
	__DEBUG_INC=1

.import _debugout, _debugout8, _debugout16, _debugout32
.import _debugout32p
.import _debugdump,_debugdumpptr
.import _debugdirentry

.macro dbg
   sei     ; disable interrupt to avoid further isr during debug
   stp		 ; break to debugger (emulator)
.endmacro

.macro debugdirentry
.if .defined(debug_enabled)
	jsr _debugdirentry
	.byte 0
.endif
.endmacro

.macro debug msg
.if .defined(debug_enabled)
		jsr	_debugout
		.asciiz msg
.endif
.endmacro

.macro debug8 msg, ptr
.if .defined(debug_enabled)
		jsr	_debugout8
		.word ptr
		.asciiz msg
.endif
.endmacro

.macro debug16 msg, ptr
.if .defined(debug_enabled)
		jsr	_debugout16
		.word ptr
		.asciiz msg
.endif
.endmacro

.macro debug32 msg, addr
.if .defined(debug_enabled)
		jsr	_debugout32
		.word addr
		.asciiz msg
.endif
.endmacro

.macro debugdump msg, addr
.if .defined(debug_enabled)
		jsr _debugdump
		.word addr
		.asciiz msg
.endif
.endmacro

.macro debugdumpptr msg, ptr
.if .defined(debug_enabled)
    jsr _debugdumpptr
		.word ptr
		.asciiz msg
.endif
.endmacro

.endif

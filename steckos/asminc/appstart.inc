
.ifndef _APPSTART_INC_
		_APPSTART_INC_ = 1
  
.macro appstart addr
  .pushseg
  .segment "LOADADDR"
  .if .paramcount >0						; app start address defined within source code
		.export __APP_START__=addr;
		.addr addr
  .else
		.export __APP_START__=$1000	  ; app start address defaults to $1000
		.addr *+2
  .endif
  .popseg
.endmacro

.endif ; _APPSTART_INC_

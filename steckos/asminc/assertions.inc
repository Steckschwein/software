.ifndef _ASSERTIONS_INC_
  _ASSERTIONS_INC_ = 1

.ifdef __ASSERTIONS
.macro assertA_le value
  php
  cmp #value+1
  bcc :+
  stp
: plp
.endmacro

.macro assertX_le
  php
  cpx #value+1
  bcc :+
  stp
: plp
.endmacro

.macro assertY_le
  php
  cpy #value+1
  bcc :+
  stp
: plp
.endmacro


.macro assertA_eq value
  php
  cmp #value
  bne :+
  stp
: plp
.endmacro

.endif

.endif  ; _ASSERTIONS_INC__

;
; bits are set per default (pull-up) and cleaned if fire or direction is pressed
;
JOY_PORT1         = 1<<7
JOY_PORT2         = !JOY_PORT1

JOY_UP            = 1<<0  ;000f rldu
JOY_DOWN          = 1<<1
JOY_LEFT          = 1<<2
JOY_RIGHT         = 1<<3
JOY_FIRE          = 1<<4

.macro joy_off
  lda #uart_mcr_out1
  ora uart1+uart_mcr
  sta uart1+uart_mcr
.endmacro

.macro joy_on ; joysticks on
  jsr joystick_on
.endmacro

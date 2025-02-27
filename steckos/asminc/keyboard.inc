.ifndef _KEYBOARD_INC_
  _KEYBOARD_INC_ = 1

KEY_ENCODED			= $80

KEY_LF            = $0a
KEY_CR            = $0d
KEY_RETURN        = $0d
KEY_BACKSPACE     = $08
KEY_TAB           = $09


KEY_CTRL_C        = $03

KEY_CRSR_UP       = $1e  ;1 11 10
KEY_CRSR_DOWN     = $1f  ;1 11 11
KEY_CRSR_RIGHT    = $10  ;1 00 00
KEY_CRSR_LEFT     = $11  ;1 00 01

KEY_PGUP          = $4b
KEY_PGDOWN        = $4e
KEY_POS1          = $4a
KEY_END           = $4d



KEY_ESCAPE        = 27

KEY_FN1           = $f1
KEY_FN2           = $f2
KEY_FN3           = $f3
KEY_FN4           = $f4
KEY_FN5           = $f5
KEY_FN6           = $f6
KEY_FN7           = $f7
KEY_FN8           = $f8
KEY_FN9           = $f9
KEY_FN10          = $fa
KEY_FN11          = $fb
KEY_FN12          = $fc


KBD_CMD_LEDS      = $ed
KBD_CMD_TYPEMATIC = $f3
KBD_CMD_RESET     = $ff

KBD_RET_ACK       = $fa

KBD_HOST_CMD_PENDING    = $ff
KBD_HOST_CMD_STATUS_EOT = $aa
KBD_HOST_CMD_KBD_STATUS = $01
KBD_HOST_CMD_CMD_STATUS = $02

.endif
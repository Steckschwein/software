.ifndef _CONSOLE_INC_
  _CONSOLE_INC_ = 1

SCREEN_BUFFER_PAGE = 30
SCREEN_BUFFER_SIZE = 8 ; buffer size in memory pages
SCREEN_DIRTY = $80

screen_buffer_size = 80*24

screen_buffer0 = $8000
screen_buffer1 = screen_buffer0 + $1000
screen_buffer2 = screen_buffer1 + $1000
screen_buffer3 = screen_buffer2 + $1000


KEY_LF            = $0a
KEY_CR            = $0d
KEY_RETURN        = $0d
KEY_BACKSPACE     = $08
KEY_TAB           = $09

KEY_FN1           = $f1
KEY_FN2           = $f2
KEY_FN3           = $f3
KEY_FN4           = $f4


ESCAPE = 27
CSI	 = '['

.endif ; _CONSOLE_INC_
SCREEN_BUFFER_PAGE = 30
SCREEN_BUFFER_SIZE = 8 ; buffer size in memory pages
SCREEN_DIRTY = $80

screen_buffer_size = 80*24

screen_buffer0 = $8000
screen_buffer1 = screen_buffer0 + screen_buffer_size

KEY_LF            = $0a
KEY_CR            = $0d
KEY_RETURN        = $0d
KEY_BACKSPACE     = $08
KEY_TAB           = $09

KEY_FN1           = $f1
KEY_FN2           = $f2
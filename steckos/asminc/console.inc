SCREEN_BUFFER_PAGE = 30
SCREEN_DIRTY = $80

screen_buffer = $8000
screen_buffer_size = 80*24
screen_buffer_end = screen_buffer + screen_buffer_size
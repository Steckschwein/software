.ifndef _ROM_INC_
	_ROM_INC_=1

ROM_ERROR_SECTOR_ERASE = 1
ROM_ERROR_TOGGLE_TIMEOUT = 2

.struct rom_write_t ; corresponds to flash_block from flash.h
  address  .dword   ; 32 bit rom address
  len      .byte    ; size of data to write, limited to one page (256 byte)
  p_data   .addr    ; pointer to data block
.endstruct

.endif

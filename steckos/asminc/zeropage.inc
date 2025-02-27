.ifndef _ZEROPAGE_INC_
  _ZEROPAGE_INC_=1

location_cmdptr    = $e0
location_paramptr  = $e2

; have to use fixed zp locations to avoid ehbasic clashes
location_vdp_ptr   = $e4
location_vdp_tmp   = $e6

; FAT32
location_filenameptr   = $e7  ; 2 byte
location_dirptr        = $e9  ; 2 byte

; SDCARD/storage block pointer
location_sdblock_ptr    = $eb

; spi shift register location
location_spi_sr            = $ed
location___volatile_ptr    = $ee
location___volatile_tmp    = $f0

; flags/signals (like ctrl-c, etc)
location_flags             = $f1


.globalzp spi_sr
.globalzp vdp_ptr, vdp_tmp
.globalzp __volatile_ptr
.globalzp __volatile_tmp

.globalzp filenameptr, dirptr
.globalzp sd_blkptr

.globalzp cmdptr
.globalzp paramptr
.globalzp flags

; lower memory after i/o

.global retvec
.global user_isr

.global lba_addr
.global blocks
.global sys_irr
.global key

.global crs_x
.global crs_y

.global video_mode


.endif

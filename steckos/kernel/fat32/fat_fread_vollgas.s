;@module: fat32

.ifdef DEBUG_FAT32_VOLLGAS ; debug switch for this module
  debug_enabled=1
.endif

; .include "zeropage.inc"
.include "common.inc"
.include "fat32.inc"
.include "errno.inc"  ; from ca65 api
.include "fcntl.inc"  ; from ca65 api
.include "stdio.inc"  ; from ca65 api

.include "debug.inc"

.import fat_fread_byte, __fat_add_seekpos, __fat_prepare_block_access
.importzp volatile_tmp


.export fat_fread_vollgas
p_data = volatile_tmp


.code

;@name: fat_fread_vollgas
;@desc: read the file denoted by given file descriptor (X) until EOF and store data at given address (A/Y)
;@in: X - offset into fd_area
;@in: A/Y - pointer to target address
;@out: C=0 on success, C=1 on error and A="error code" or C=1 and A=0 (EOK) if EOF is reached
fat_fread_vollgas:
          _is_file_open   ; otherwise rts C=1 and A=#EINVAL
          _is_file_dir    ; otherwise rts C=1 and A=#EISDIR

          sta p_data
          sty p_data+1

          jsr @read_end_of_block_or_file
          debug16 "frv 0", p_data
          bcs @l_exit

          lda fd_area + F32_fd::FileSize + 1,x
          and #$80
          ora fd_area + F32_fd::FileSize + 2,x
          ora fd_area + F32_fd::FileSize + 3,x
          bne @l_err_range                      ; file too big >32k

          ; (filesize - seek pos) / $200 (block size) gives amount of blocks to read
          sec
          lda fd_area + F32_fd::FileSize + 1,x
          sbc fd_area + F32_fd::SeekPos + 1,x
          lsr
          tay
          debug16 "frv bs", p_data

@l_read_blocks:
          beq @read_bytes  ; zero blocks - read remaining bytes and exit
          phy

          lda p_data
          ldy p_data+1
          clc
          jsr __fat_prepare_block_access

          inc p_data+1  ; +512 byte (sd_blocksize)
          inc p_data+1

          lda #<sd_blocksize
          ldy #>sd_blocksize
          jsr __fat_add_seekpos

          ply
          dey
          bra @l_read_blocks

; at beginning we need to read until we are block aligned
; and after blocks where read we read the remaining bytes until eof
@read_end_of_block_or_file:
          lda fd_area+F32_fd::SeekPos+1,x     ; read until we are block aligned (multiple of $200)
          and #$01
          ora fd_area+F32_fd::SeekPos+0,x
          beq @l_exit_ok

@read_bytes:
          jsr fat_fread_byte                  ; ... or end of file is reached
          bcs @l_exit

          sta (p_data)
          inc p_data
          bne @read_end_of_block_or_file
          inc p_data+1
          bne @read_end_of_block_or_file
@l_err_range:
          lda #ERANGE
          sec
@l_exit:  debug16 "f rd vs <", p_data
          rts
@l_exit_ok:
          clc
          rts


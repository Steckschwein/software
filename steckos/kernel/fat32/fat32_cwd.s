.ifdef DEBUG_UTIL    ; enable debug for this module
  debug_enabled=1
.endif
.setcpu "65c02"
.include "fat32.inc"
.include "common.inc"
.include "zeropage.inc"
.include "errno.inc"
.include "debug.inc"


.export fat_get_root_and_pwd

.importzp filenameptr, dirptr;, sd_blkptr
.importzp tmp_ptr
.import __fat_readdir_next
.import __fat_readdir
.import __fat_open_path
.import __fat_clone_fd
.import __fat_free_fd

__volatile_ptr = tmp_ptr

.code
;@module: fat32

;in:
;  A/Y - address to write the current work directory string into
;  X  - size of result buffer/string
;out:
;  C - C=0 on success (A=0), C=1 and A=error code otherwise

;@name: "fat_get_root_and_pwd"
;@in: A, "low byte of address to write the current work directory string into"
;@in: Y, "high byte address to write the current work directory string into"
;@in: X, "size of result buffer pointet to by A/X"
;@out: C, "0 on success, 1 on error"
;@out: A, "error code"
;@desc: "get current directory"
fat_get_root_and_pwd:

              php
              sei

              sta __volatile_ptr
              sty __volatile_ptr+1
              stx volumeID+VolumeID::fat_tmp_0

              ldy #FD_INDEX_CURRENT_DIR
              ldx #FD_INDEX_TEMP_FILE
              jsr __fat_clone_fd                    ; start from current directory, clone the cwd fd

              lda #0
              jsr put_char                          ; \0 terminated end of buffer

@l_rd_dir:    lda #'/'                              ; put the / char to result string
              jsr put_char
              ldx #FD_INDEX_TEMP_FILE               ; if root, exit to inverse the path string
              lda fd_area+F32_fd::StartCluster+3,x  ; check whether start cluster is the root dir cluster nr (0x00000000)
              ora fd_area+F32_fd::StartCluster+2,x
              ora fd_area+F32_fd::StartCluster+1,x
              ora fd_area+F32_fd::StartCluster+0,x
              beq @l_path_trim
              m_memcpy fd_area+FD_INDEX_TEMP_FILE+F32_fd::StartCluster, __fat_cwd_cluster, 4  ; save the cluster from the fd of the "current" dir which is stored in FD_INDEX_TEMP_FILE (see clone above)
              lda #<l_dot_dot
              ldx #>l_dot_dot
              ldy #FD_INDEX_TEMP_FILE               ; call __fat_open_path function with ".."
              jsr __fat_open_path
              bcs @l_exit
              jsr __fat_readdir                     ; open path success the fd points to the parent directory
              bra :+
@l_find_next: jsr __fat_readdir_next
:             bcs @l_exit_read
              ldy #F32DirEntry::FstClusLO+0
              lda __fat_cwd_cluster+0
              cmp (dirptr),y
              bne @l_find_next
              iny
              lda __fat_cwd_cluster+1
              cmp (dirptr),y
              bne @l_find_next
              ldy #F32DirEntry::FstClusHI+0
              lda __fat_cwd_cluster+2
              cmp (dirptr),y
              bne @l_find_next
              iny
              lda __fat_cwd_cluster+3
              cmp (dirptr),y
              bne @l_find_next
              clc
@l_exit_read: jsr __fat_free_fd                     ; free fd immediately
              bcs @l_exit                           ; not found
              jsr fat_name_string                   ; found, dirptr points to the entry and we can simply extract the name - fat_name_string formats and appends the dir entry name:attr
              bra @l_rd_dir                         ; go on with bottom up walk until root is reached

@l_path_trim: jsr path_trim                         ; the dir entry names are captured bottom up along the path and stored in the given buffer (A/Y) starting from the end. just need to trim the whitespaces at the beginning
              plp
              clc
              rts

@l_exit:      plp
              sec
              rts
l_dot_dot:
              .asciiz ".."


path_trim:
              ldy #0
:             phy
              ldy volumeID+VolumeID::fat_tmp_0
              lda (__volatile_ptr),y
              ply
              sta (__volatile_ptr),y
              cmp #0
              beq @l_exit
              inc volumeID+VolumeID::fat_tmp_0
              iny
              bne :-
@l_exit:      rts


; fat name to string (by reference)
; in:
;   dirptr         - pointer to directory entry (F32DirEntry)
;   __volatile_ptr - pointer to result string
;   __string_ix    - length or offset in result string denoted by __volatile_ptr
fat_name_string:
              ldy #.sizeof(F32DirEntry::Name) + .sizeof(F32DirEntry::Ext)
@l_next:
              dey
              lda (dirptr),y
              cmp #' '
              beq @l_next
              cpy #.sizeof(F32DirEntry::Name)
              bne :+
              pha
              lda #'.'
              jsr put_char
              pla
:             jsr put_char
              bne @l_next
              rts
put_char:     phy
              ldy volumeID+VolumeID::fat_tmp_0
              beq @l_exit
              dey
              sty volumeID+VolumeID::fat_tmp_0
              sta (__volatile_ptr),y
@l_exit:      ply
              rts

.bss
  __fat_cwd_cluster:  .res 4
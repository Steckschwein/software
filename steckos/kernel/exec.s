; enable debug for this module
.ifdef DEBUG_EXECV
  debug_enabled=1
.endif

.include "common.inc"
.include "errno.inc"
.include "fat32.inc"
.include "fcntl.inc"  ; from ca65 api


.import fat_fopen, fat_close, fat_fread_byte, fat_fread_vollgas
.importzp filenameptr, startaddr

.import char_out, hexout
.export execv

.code
; in:
;   A/X - pointer to string with the file path
; out:
;   executes program with given path (A/X), C=1 and A=<error code> on error
execv:
      ldy #O_RDONLY
      jsr fat_fopen       ; A/X - pointer to filename
      bcc :+
      rts


:     jsr fat_fread_byte  ; start address low
      bcs @l_exit_close
      sta startaddr
      jsr fat_fread_byte  ; start address high
      bcs @l_exit_close
      sta startaddr+1

      tay
      lda startaddr
      jsr fat_fread_vollgas

      pha
      jsr fat_close
      pla
      cmp #EOK
      beq @l_exec_run
      sec
      rts
@l_exit_close:
      jmp fat_close     ; close after read to free fd, regardless of error

@l_exec_run:
      ; we came here using jsr, but will not rts.
      ; get return address from stack to prevent stack corruption
      pla
      pla
      
      jmp (startaddr)

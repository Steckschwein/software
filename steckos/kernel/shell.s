.include "keyboard.inc"
.include "fcntl.inc"
.include "fat32.inc"
.include "common.inc"


entries_short    = 5*24
entries_long     = 23

opts_long       = (1 << 0)
opts_paging     = (1 << 1)
opts_cluster    = (1 << 2)
opts_attribs    = (1 << 3)
opts_crtdate    = (1 << 4)

dump_line_length = $10

BUF_SIZE    = 80 ;TODO maybe too small?
cwdbuf_size = 25
prompt  = '>'

.import upload
.import primm, char_out, char_in, hexout, strout
.import fat_fread_byte, fat_fopen, fat_rmdir, fat_mkdir, fat_unlink, fat_chdir, fat_readdir, fat_opendir, fat_close, fat_close_all, fat_write_byte, fat_get_root_and_pwd
.import print_filename, print_fat_date, print_fat_time, print_filesize, print_attribs, print_cluster_no, space
.import string_fat_mask, string_fat_mask_matcher

.import sd_read_block

.importzp sd_blkptr
.import lba_addr
.import crs_x

.import execv

; .export char_out                = fat_chrout
.export dirent
.export shell_init



.importzp retvec
.importzp paramptr
.importzp filenameptr
.importzp cmdptr
.importzp tmp_ptr
.importzp bufptr
.importzp pathptr
.importzp dumpvecs
dumpend = dumpvecs
dumpvec = dumpvecs+2

.code
;---------------------------------------------------------------------------------------------------------
; init shell
;  - print welcome message
;---------------------------------------------------------------------------------------------------------

shell_init:


exit_from_prg:
        cld
        jsr fat_close_all   ; make sure all fd's are closed
        ; jsr fat_textui_init

        ldx #BUF_SIZE
:       stz tmpbuf,x
        dex
        bpl :-

        SetVector exit_from_prg, retvec
        SetVector buf, bufptr
        SetVector buf, paramptr ; set param to empty buffer
        SetVector PATH, pathptr
mainloop:
        crlf
        lda #'['
        jsr char_out

        ; output current path
        lda #<cwdbuf
        ldy #>cwdbuf
        ldx #cwdbuf_size
        jsr fat_get_root_and_pwd
        bcs @nocwd

        lda #<cwdbuf
        ldx #>cwdbuf
        jsr strout

        bra @prompt
@nocwd:
        lda #'?'
        jsr char_out
@prompt:
        lda #']'
        jsr char_out

        lda #prompt
        jsr char_out

        lda crs_x

        ; reset input buffer
        ldy #0
        jsr terminate


  ; put input into buffer until return is pressed
inputloop:
:       
        jsr char_in
        bcc :-


        ; special key?
        ; check in lookup table
        ldx #0
:
        cmp key_code_tbl,x
        beq @found
        inx
        cpx #key_code_tbl_end - key_code_tbl
        bne :-
        bra @notfound
@found:
        txa
        asl
        tax
        jmp (key_addr_tbl,x)

@notfound:
        ; prevent overflow of input buffer
        cpy #BUF_SIZE
        beq inputloop

        sta (bufptr),y
        iny
line_end:
        jsr char_out
        jsr terminate
key_fn5:
key_fn6:
key_fn7:
key_fn8:
key_fn9:
key_fn10:
key_fn11:

        bra inputloop


backspace:
        cpy #$00
        beq inputloop
        dey
        lda #KEY_BACKSPACE
        bra line_end

escape:
        ; jsr fat_getkey
        jsr char_in
        jsr printbuf
        bra inputloop

key_fn12:
        jmp mode_toggle
key_fn1:
        lda #<cmd_help
        ldx #>cmd_help
        bra inject_cmd

key_fn2:
        lda #<cmd_lsdir
        ldx #>cmd_lsdir
        bra inject_cmd

key_fn3:
        lda #<cmd_basic
        ldx #>cmd_basic
        bra inject_cmd

key_fn4:
        jmp upload


inject_cmd:
        sta paramptr
        stx paramptr+1
        ldy #0
:
        lda (paramptr),y
        beq parse
        sta (bufptr),y
        jsr char_out
        iny
        bne :-
key_crs_up:
key_crs_down:
key_tab:
        ; lda #<dirent
        ; ldy #>dirent
        ; ldx #FD_INDEX_CURRENT_DIR
        ; jsr fat_readdir

        ; jsr print_filename

        bra inputloop

terminate:
        lda #0
        sta (bufptr),y
        rts

parse:
        copypointer bufptr, cmdptr


        ; find begin of command word
@l1:
        lda (cmdptr)  ; skip non alphanumeric stuff
        bne @l2
        jmp mainloop
@l2:
        cmp #' '
        bne @l3
        inc cmdptr
        bra @l1
@l3:
        copypointer cmdptr, paramptr

        ; find begin of parameter (everything behind the command word, separated by space)
        ; first, fast forward until space or abort if null (no parameters then)
@l4:
        lda (paramptr)
        beq @l7
        cmp #' '
        beq @l5
        inc paramptr
        bra @l4
@l5:
  ; space found.. fast forward until non space or null
@l6:
        lda (paramptr)
        beq @l7
        cmp #$20
        bne @l7
        inc paramptr
        bra @l6
@l7:
        SetVector buf, bufptr

        jsr terminate

compare:
      ; compare
        ldx #$00
@l1:
        ldy #$00
@l2:
        lda (cmdptr),y

        ; if not, there is a terminating null
        bne @l3

        cmp cmdlist,x
        beq cmdfound

        ; command string in buffer is terminated with $20 if there are cmd line arguments

@l3:
        cmp #$20
        bne @l4

        cmp cmdlist,x
        bne cmdfound

@l4:
        ; make lowercase
        tolower

        cmp cmdlist,x
        bne @l5  ; difference. this isnt the command were looking for

        iny
        inx

        bra @l2

        ; next cmdlist entry
@l5:
        inx
        lda cmdlist,x
        bne @l5
        inx
        inx
        inx

        lda cmdlist,x
        cmp #$ff
        beq try_exec
        bra @l1

cmdfound:
        inx
        jmp (cmdlist,x) ; 65c02 FTW!!

try_exec:
        lda (bufptr)
        beq @l1

        jmp exec
@l1:
        jmp mainloop

printbuf:
        ldy #$01
        sty crs_x
        ; jsr fat_textui_update_crs_ptr

        ldy #$00
@l1:
        lda (bufptr),y
        beq @l2
        sta buf,y
        jsr char_out
        iny
        bra @l1
@l2:
        rts


errmsg:
        cmp #$15
        bcs @l_unknown
        asl
        tax
        lda errors,x
        sta tmp_ptr
        lda errors+1,x
        sta tmp_ptr+1
        ldy #0
:
        lda (tmp_ptr),y
        beq @l_exit
        jsr char_out
        iny
        bne :-
@l_unknown:
        pha
        lda #<unknown_error_msg
        ldx #>unknown_error_msg
        jsr strout
        pla
        jsr hexout
@l_exit:
        crlf
        jmp mainloop

mode_toggle:
;         lda video_mode
;         eor #VIDEO_MODE_80_COLS
;         jsr hexout
;         jsr fat_textui_setmode
        jmp mainloop
cmd_cd:
        lda paramptr
        ldx paramptr+1
        jsr fat_chdir
        bcc @l2
        jmp errmsg
@l2:
        jmp mainloop


cmd_rm:
        lda (paramptr)
        beq @exit

        lda paramptr
        ldx paramptr+1

        jsr fat_unlink
        bcc @exit
        jsr errmsg
@exit:
        jmp mainloop
cmd_mkdir:
        lda (paramptr)
        beq @exit

        lda paramptr
        ldx paramptr+1

        jsr fat_mkdir
        bcc @exit
        jsr errmsg
@exit:
        jmp mainloop

cmd_rmdir:
        lda (paramptr)
        beq @exit

        lda paramptr
        ldx paramptr+1

        jsr fat_rmdir
        bcc @exit
        jsr errmsg
@exit:
        jmp mainloop

cmd_pwd:
        lda #<cwdbuf
        ldx #>cwdbuf
        jsr strout
        jmp mainloop

exec:
        lda cmdptr
        ldx cmdptr+1    ; cmdline in a/x

        ; try to chdir
        jsr fat_chdir
        bcs @resolve_path ; branch taken if chdir successful
        jmp mainloop

@resolve_path:
        crlf
        stz tmp2
@try_path:
        ldx #0
        ldy tmp2
@cp_path:
        lda (pathptr), y
        beq @check_path
        cmp #':'
        beq @cp_next
        sta tmpbuf,x
        inx
        iny
        bne @cp_path
        lda #1
        jmp errmsg
@check_path:    ;PATH end reached and nothing to prefix
        cpy tmp2
        bne @cp_next_piece  ;end of path, no iny
        lda #1    ;nothing found, "Invalid command"
        jmp errmsg
@cp_next:
        iny
@cp_next_piece:
        sty tmp2        ;safe PATH offset, 4 next try
        stz tmp1
        ldy #0
@cp_loop:
        lda (cmdptr),y
        beq @l3
        cmp #'.'
        bne @cp_loop_1
        stx tmp1
@cp_loop_1:
        cmp #' '    ;end of program name?
        beq @l3
        sta tmpbuf,x
        iny
        inx
        bne @cp_loop
@l3:
        lda tmp1
        bne @l4
        ldy #0
@l5:
        lda PRGEXT,y
        beq @l4
        sta tmpbuf,x
        inx
        iny
        bne  @l5
@l4:
        stz tmpbuf,x

        lda #<tmpbuf
        ldx #>tmpbuf    ; cmdline in a/x
        jsr execv   ; return C=1 and A with errorcode
        bra @try_path   ; try another path

cmd_go:
        ldy #0
        ldx #1
        jsr hex2dumpvec
        bcs @usage

        jmp (dumpend)
@usage:
        lda #<go_usage_txt
        ldx #>go_usage_txt
        jsr strout
@end:
        jmp mainloop

cmd_bank:
        ldy #0
        lda (paramptr),y
        beq @status

        ldx #1
        jsr hex2dumpvec
        bcs @usage

        lda dumpend+1
        tax
        lda dumpend
        sta ctrl_port,x

        bra @status
@usage:
        lda #<bank_usage_txt
        ldx #>bank_usage_txt
        jsr strout
        bra @end
@status:

        ldx #0
@next:
        crlf

        txa
        jsr hexout
        lda #':'
        jsr char_out
        jsr space
        lda ctrl_port,x
        jsr hexout
        inx
        cpx #4
        bne @next
@end:
        jmp mainloop


cmd_ms:
        ldy #0
        ldx #1
        jsr hex2dumpvec
        bcs @usage

@again:
        crlf
        lda dumpend+1
        jsr hexout

        lda dumpend
        jsr hexout

        lda #':'
        jsr char_out
        jsr space

@skip:
        iny
        lda (paramptr),y
        beq @end
        cmp #' '
        beq @skip

        jsr atoi
        asl
        asl
        asl
        asl
        sta tmp1

        iny
        lda (paramptr),y
        jsr atoi
        ora tmp1

        jsr hexout
        sta (dumpend)

        inc16 dumpend
        bra @again

@usage:
        lda #<ms_usage_txt
        ldx #>ms_usage_txt
        jsr strout
@end:
        jmp mainloop



cmd_bd:
        ldx #3
@clearloop:
        stz dumpvecs,x
        dex
        bpl @clearloop

        ldy #0
        ldx #3
        jsr hex2dumpvec
        bcs @usage

        ldx #3
@copyloop:
        lda dumpvecs,x
        sta lba_addr,x
        dex
        bpl @copyloop

        lda #$10
        sta dumpvec+1
        stz dumpvec

        lda #$11
        sta dumpend
        copypointer dumpvec, sd_blkptr

        jsr sd_read_block
        bcs @err
        jsr dump_start
        jmp mainloop
@err:
        jmp errmsg
@usage:
        lda #<bd_usage_txt
        ldx #>bd_usage_txt
        jsr strout
        jmp mainloop
cmd_pd:
        ldy #0
        ldx #1
        stz dumpend
        jsr hex2dumpvec

        lda dumpend + 1
        sta dumpvec + 1

        lda dumpend
        bne :+
        lda dumpvec +1
        sta dumpend
:
        stz dumpvec

        crlf
@start:
        jsr dump_start
        jmp mainloop
@error:
        lda #<pd_usage_txt
        ldx #>pd_usage_txt
        jsr strout
        jmp mainloop


dump_start:
        crlf
        lda #<pd_header
        ldx #>pd_header
        jsr strout

        ldx #256 / dump_line_length
@output_line:
        crlf

        lda dumpvec+1
        jsr hexout
        lda dumpvec
        jsr hexout

        lda #':'
        jsr char_out
        jsr space

        ldy #$00
@out_hexbyte:
        lda (dumpvec),y
        jsr hexout
        jsr space
        iny
        cpy #dump_line_length
        bne @out_hexbyte

        jsr space

        ldy #$00
@out_char:
        lda (dumpvec),y
        cmp #$19 ; printable character?
        bcs :+   ;
        lda #'.' ; no, just print '.'
:                ; yes, print it
        jsr char_out
        iny
        cpy #dump_line_length
        bne @out_char

        ; update dumpvec
        clc
        tya
        adc dumpvec
        sta dumpvec

        dex
        bne @output_line

        lda dumpvec+1
        cmp dumpend
        beq @end

        lda #<press_key_msg
        ldx #>press_key_msg
        jsr strout

        ; keyin
:
        jsr char_in
        bcc :-

        cmp #KEY_CTRL_C
        beq @end
        cmp #KEY_ESCAPE
        beq @end

        inc dumpvec+1
        jmp dump_start
@end:
        rts


cmd_loadmem:
        ldy #0
        ldx #0

        jsr get_filename

        ldx #1
        jsr hex2dumpvec
        bcs @usage

        lda #<filenamebuf
        ldx #>filenamebuf
        ldy #O_RDONLY
        jsr fat_fopen     ; X contains fd
        bcs @err    ; not found or other error, dont care...
        ldy #0
:
        jsr fat_fread_byte
        bcs @eof
        sta (dumpend)
        inc16 dumpend
        bne :-
@eof:
        jsr fat_close
@end:
        jmp mainloop
@err:
        crlf
        jmp errmsg
@usage:
        lda #<load_usage_txt
        ldx #>load_usage_txt
        jsr strout
        jmp mainloop

cmd_savemem:
        ldx #3
        ldy #0

        jsr hex2dumpvec
        bcs @usage

        iny
        lda (paramptr),y
        beq @usage

        jsr get_filename

        lda #<filenamebuf
        ldx #>filenamebuf
        ldy #O_WRONLY
        jsr fat_fopen
        bcs @err


        inc16 dumpend
:
        lda (dumpvec)
        jsr fat_write_byte
        bcs @err

        inc16 dumpvec

        lda dumpvec
        cmp dumpend
        bne :-
        lda dumpvec+1
        cmp dumpend+1
        bne :-

        jsr fat_close

        jmp mainloop
@err:
        jmp errmsg
@usage:
        lda #<save_usage_txt
        ldx #>save_usage_txt
        jsr strout
        jmp mainloop

cmd_cls:
        jsr primm
        .byte 27,"[2J ",0
        jmp mainloop

get_filename:
        ldx #0
@read_filename:
        lda (paramptr),y
        beq @read_filename_done
        cmp #' '
        beq @read_filename_done

        sta filenamebuf,x
        iny
        inx
        bne @read_filename

@read_filename_done:
        stz filenamebuf,x
        rts


hex2dumpvec:
@next_byte:
        lda (paramptr),y
        beq @err
        cmp #' '
        bne :+
        iny
        bra @next_byte
:
        jsr atoi
        asl
        asl
        asl
        asl
        sta dumpvecs,x

        iny
        lda (paramptr),y
        beq @err

        jsr atoi
        ora dumpvecs,x
        sta dumpvecs,x

        iny
        dex
        bpl @next_byte
@end:
        clc
        rts
@err:
        sec
        rts


dir_show_entry:
        phx
        lda options
        and #opts_long
        beq :+
        jsr dir_show_entry_long
        bra @end
:
        jsr dir_show_entry_short
@end:
        plx
        rts

dir_show_entry_short:
        dec cnt
        bne @l1
        crlf
        lda #5
        sta cnt
@l1:
        ldy #F32DirEntry::Attr
        lda dirent,y

        bit #DIR_Attr_Mask_Dir
        beq :+
        lda #'['
        jsr char_out
        bra @print
:
        jsr space

@print:
        jsr print_filename

        ldy #F32DirEntry::Attr
        lda dirent,y

        bit #DIR_Attr_Mask_Dir
        beq :+
        lda #']'
        jsr char_out
        bra @pad
:

        jsr space
@pad:
        jsr space
        rts

dir_show_entry_long:
        pha
        crlf
        jsr print_filename

        jsr space

        lda options
        and #opts_cluster
        beq :+
        jsr print_cluster_no
:

        lda options
        and #opts_attribs
        beq :+
        jsr space
        jsr print_attribs
:

        ldy #F32DirEntry::Attr
        lda dirent,y

        bit #DIR_Attr_Mask_Dir
        beq @l
        lda #<dir_marker_txt
        ldx #>dir_marker_txt
        jsr strout
        bra @date       ; no point displaying directory size as its always zeros
                        ; just print some spaces and skip to date display
@l:
        jsr space

        jsr print_filesize

        jsr space

@date:
        lda #opts_crtdate
        and options
        bne :+
        ldy #F32DirEntry::WrtDate
        bra @x
:
        ldy #F32DirEntry::CrtDate
@x:
        jsr print_fat_date

        jsr space

        lda #opts_crtdate
        and options
        bne :+
        ldy #F32DirEntry::WrtTime+1
        bra @y
:
        ldy #F32DirEntry::CrtTime+1
@y:

        jsr print_fat_time

        pla
        rts

setopt:
        ora options
        sta options
        rts

setmask:
        and dir_attrib_mask
        sta dir_attrib_mask
        rts





usage:
        lda #<ls_usage_txt
        ldx #>ls_usage_txt
        jmp strout

cmd_dir:
        lda #opts_long
        sta options
        bra dir
cmd_ls:
        stz options
dir:
        crlf
        SetVector pattern, filenameptr

        lda #DIR_Attr_Mask_Volume|DIR_Attr_Mask_Hidden
        sta dir_attrib_mask

        lda #6
        sta cnt

        lda #entries_short
        sta pagecnt
        sta entries_per_page


        ldy #0
@parseloop:
        lda (paramptr),y
        bne :+
        jmp @readdir
:
        cmp #' '
        beq @set_filenameptr
        cmp #'-'
        beq @option
        bne @set_filenameptr

@next_opt:
        iny
        bne @parseloop
        bra @set_filenameptr

@option:
        iny
        lda (paramptr),y
        beq @parseloop
        cmp #' '
        beq @next_opt

        cmp #'?'
        bne :+
        jsr usage
        jmp @exit
:
        cmp #'l'
        bne :+
        lda #opts_long
        jsr setopt

        lda #entries_long
        sta pagecnt
        sta entries_per_page
:
        ; show all files (remove hidden bit from mask)
        cmp #'h'
        bne :+
        lda #<~DIR_Attr_Mask_Hidden
        jsr setmask
        bra @option
:
        ; show volume id (remove volid bit from mask)
        cmp #'v'
        bne :+
        lda #<~DIR_Attr_Mask_Volume
        jsr setmask
        bra @option
:
        cmp #'c'
        bne :+
        lda #opts_cluster
        jsr setopt
        bra @option
:
        cmp #'d'
        bne :+
        lda #opts_crtdate
        jsr setopt
        bra @option
:
        cmp #'p'
        bne :+
        lda #opts_paging
        jsr setopt
        bra @option
:
        cmp #'a'
        bne :+
        lda #opts_attribs
        jsr setopt
:
        bra @option

@set_filenameptr:
        iny
        lda (paramptr),y
        beq @readdir
        dey

        copypointer paramptr, filenameptr

        tya
        clc
        adc filenameptr
        sta filenameptr

@readdir:
        lda #<fat_dirname_mask
        ldy #>fat_dirname_mask
        jsr string_fat_mask

        lda #<cwdbuf
        ldx #>cwdbuf
        jsr fat_opendir
        bcs @error


@read_next:
        lda #<dirent
        ldy #>dirent
        jsr fat_readdir
        rol
        cmp #1
        beq @end


        ldy #F32DirEntry::Attr
        lda dirent,y
        bit dir_attrib_mask ; Hidden attribute set, skip
        bne @read_next


        jsr string_fat_mask_matcher
        bcc @read_next


        jsr dir_show_entry

        lda options
        and #opts_paging
        beq @read_next
        dec pagecnt
        bne @read_next

        phx
        lda #<press_key_msg
        ldx #>press_key_msg
        jsr strout
        plx

        ; keyin
:
        jsr char_in
        bcc :-
        cmp #13 ; enter pages line by line
        beq @lx

        cmp #KEY_ESCAPE
        beq @end
        ; check ctrl c
        ; bit flags
        ; bmi @end

        lda entries_per_page
        sta pagecnt
        bra @read_next
@lx:
        lda #1
        sta pagecnt
        bra @read_next

@error:
        jsr fat_close
        jmp errmsg

@end:
        jsr fat_close
@exit:
        jmp mainloop


cmd_path:
        lda #<PATH
        ldx #>PATH
        jsr strout
        jmp mainloop

atoi:
        cmp #'9'+1
        bcc @l1   ; 0-9?
        ; must be hex digit
        adc #$08
        and #$0f
        rts

@l1:
        sec
        sbc #$30
        rts

.rodata
PATH:           .asciiz "./:/steckos/:/progs/"
PRGEXT:         .asciiz ".PRG"
pd_header:      .asciiz "####   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F  0123457890ABCDEF"
pattern:        .asciiz "*.*"
press_key_msg:  .byte $0a, $0d,"-- press a key-- ",$00
dir_marker_txt: .asciiz " <DIR> "


msg_EOK:        .asciiz "No error"
msg_ENOENT:     .asciiz "No such file or directory"
msg_ENOMEM:     .asciiz "Out of memory"
msg_EACCES:     .asciiz "Permission denied"
msg_ENODEV:     .asciiz "No such device"
msg_EMFILE:     .asciiz "Too many open files"
msg_EBUSY:      .asciiz "Device or resource busy"
msg_EINVAL:     .asciiz "Invalid argument (0x07)"
msg_ENOSPC:     .asciiz "No space left on device (0x08)"
msg_EEXIST:     .asciiz "File exists"
msg_EAGAIN:     .asciiz "Try again (0x0a)"
msg_EIO:        .asciiz "I/O error"
msg_EINTR:      .asciiz "Interrupted system call"
msg_ENOSYS:     .asciiz "Function not implemented"
msg_ESPIPE:     .asciiz "Illegal seek"
msg_ERANGE:     .asciiz "Range error"
msg_EBADF:      .asciiz "Bad file number"
msg_ENOEXEC:    .asciiz "Exec format error"
msg_EISDIR:     .asciiz "Is a directory"
msg_ENOTDIR:    .asciiz "Not a directory"
msg_ENOTEMPTY:  .asciiz "Directory not empty"

errors:
.addr msg_EOK
.addr msg_ENOENT
.addr msg_ENOMEM
.addr msg_EACCES
.addr msg_ENODEV
.addr msg_EMFILE
.addr msg_EBUSY
.addr msg_EINVAL
.addr msg_ENOSPC
.addr msg_EEXIST
.addr msg_EAGAIN
.addr msg_EIO
.addr msg_EINTR
.addr msg_ENOSYS
.addr msg_ESPIPE
.addr msg_ERANGE
.addr msg_EBADF
.addr msg_ENOEXEC
.addr msg_EISDIR
.addr msg_ENOTDIR
.addr msg_ENOTEMPTY
bank_usage_txt:
        .byte $0a, $0d,"usage: bank <slot> <bank>", $0a, $0d,0
go_usage_txt:
        .byte $0a, $0d,"usage: go <addr>", $0a, $0d,0
ms_usage_txt:
        .byte $0a, $0d,"usage: ms <addr> <byte> [<byte>...]", $0a, $0d,0
bd_usage_txt:
        .byte $0a, $0d,"usage: bd <block-no> (4 bytes, 8 hex digits) ", $0a, $0d,0
pd_usage_txt:
        .byte $0a, $0d,"usage: pd <pageaddr>", $0a, $0d,0
load_usage_txt:
        .byte $0a, $0d, "usage: load <file> <addr>", $0a, $0d, 0
save_usage_txt:
        .byte $0a, $0d,"usage: save <from> >to> <filename>",$0a, $0d, $00
ls_usage_txt:
.byte "Usage: ls [OPTION]... [FILE]...",$0a, $0d
.byte "options:",$0a,$0d
.byte "   -a   show file attributes",$0a,$0d
.byte "   -c   show number of first cluster",$0a,$0d
.byte "   -d   show creation date",$0a,$0d
.byte "   -h   show hidden files",$0a,$0d
.byte "   -l   use a long listing format",$0a,$0d
.byte "   -p   paginate output",$0a,$0d
.byte "   -v   show volume ID ",$0a,$0d
.byte "   -?   show this useful message",$0a,$0d
.byte 0

unknown_error_msg:
        .asciiz "unknown error "


cmdlist:
.byte "cd",0
.word cmd_cd

.byte "rm",0
.word cmd_rm

.byte "ls",0
.word cmd_ls

cmd_lsdir:
.byte "dir",0
.word cmd_dir

.byte "mkdir",0
.word cmd_mkdir

.byte "rmdir",0
.word cmd_rmdir

.byte "pwd",0
.word cmd_pwd

.byte "up",0
.word upload

.byte "pd",0
.word cmd_pd

.byte "bd",0
.word cmd_bd

.byte "ms",0
.word cmd_ms

.byte "bank",0
.word cmd_bank

.byte "go",0
.word cmd_go

.byte "load",0
.word cmd_loadmem

.byte "save",0
.word cmd_savemem

.byte "cls",0
.word cmd_cls

.byte "path",0
.word cmd_path
; End of list
.byte $ff
cmd_help:
.byte "help",0
cmd_basic:
.byte "basic.prg",0

key_code_tbl:
        .byte KEY_RETURN
        .byte KEY_BACKSPACE
        .byte KEY_ESCAPE
        .byte KEY_CRSR_UP
        .byte KEY_CRSR_DOWN
        .byte KEY_TAB
        .byte KEY_FN1
        .byte KEY_FN2
        .byte KEY_FN3
        .byte KEY_FN4
        .byte KEY_FN5
        .byte KEY_FN6
        .byte KEY_FN7
        .byte KEY_FN8
        .byte KEY_FN9
        .byte KEY_FN10
        .byte KEY_FN11
        .byte KEY_FN12
key_code_tbl_end:

key_addr_tbl:
        .word parse
        .word backspace
        .word escape
        .word key_crs_up
        .word key_crs_down
        .word key_tab
        .word key_fn1
        .word key_fn2
        .word key_fn3
        .word key_fn4
        .word key_fn5
        .word key_fn6
        .word key_fn7
        .word key_fn8
        .word key_fn9
        .word key_fn10
        .word key_fn11
        .word key_fn12

; .segment "ZP_EXT"
.bss
buf:              .res BUF_SIZE
tmpbuf:           .res BUF_SIZE
cwdbuf:           .res cwdbuf_size
dirent:           .res .sizeof(F32DirEntry)
filenamebuf:      .res 12
fat_dirname_mask: .res 8+3 ;8.3 fat mask <name><ext>
tmp1:             .res 1
tmp2:             .res 1
options:          .res 1
dir_attrib_mask:  .res 1
pagecnt:          .res 1
entries_per_page: .res 1
cnt:              .res 1
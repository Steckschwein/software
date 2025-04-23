;@module: jumptable
.importzp out_vector, in_vector
.import char_in, char_out, primm, set_input, set_output, xmodem_upload, strout, hexout
.import upload
.import fat_open, fat_fopen, fat_close, fat_unlink, fat_read_direntry, fat_fread_byte, fat_write_byte, fat_update_direntry
.export krn_chrin, krn_chrout, krn_primm, krn_strout, krn_hexout, krn_set_input, krn_set_output, krn_upload
.export krn_close, krn_open, krn_fopen, krn_unlink, krn_read_direntry, krn_write_byte, krn_fread_byte, krn_update_direntry


.segment "JUMPTABLE"    ; "kernel" jumptable
;@name: krn_chrin
;@desc: read character from current input device into A
;@out: A - received character
krn_chrin:        jmp char_in

;@name: krn_chrout
;@desc: print character in A to current output device
;@in: A - character to print
krn_chrout:       jmp char_out

;@name: krn_primm
;@desc: print immediate
krn_primm:        jmp primm

krn_strout:       jmp strout
krn_hexout:       jmp hexout

;@name: krn_set_output
;@desc: set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
krn_set_output:   jmp set_output

;@name: krn_set_input
;@desc: set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
krn_set_input:    jmp set_input


krn_open:         jmp fat_open
krn_fopen:        jmp fat_fopen
krn_close:        jmp fat_close
krn_read_direntry:    jmp fat_read_direntry
krn_update_direntry:  jmp fat_update_direntry

krn_fread_byte:   jmp fat_fread_byte
krn_write_byte:   jmp fat_write_byte

krn_unlink:       jmp fat_unlink


;@name: krn_upload
;@desc: start XMODEM upload
krn_upload:       jmp upload

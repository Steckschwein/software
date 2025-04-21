;@module: jumptable
.importzp out_vector, in_vector
.import char_in, char_out, primm, set_input, set_output, xmodem_upload
.import upload
.export krn_chrin, krn_chrout, krn_primm, krn_set_input, krn_set_output, krn_upload


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

;@name: krn_set_output
;@desc: set current output device to one of: OUTPUT_DEVICE_NULL, OUTPUT_DEVICE_UART, OUTPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
krn_set_output:   jmp set_output

;@name: krn_set_input
;@desc: set current output device to one of: INPUT_DEVICE_NULL, INPUT_DEVICE_UART, INPUT_DEVICE_CONSOLE 
;@in: A - device id to be set
krn_set_input:    jmp set_input

;@name: krn_upload
;@desc: start XMODEM upload
krn_upload:       jmp upload


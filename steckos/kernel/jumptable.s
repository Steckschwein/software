.segment "JUMPTABLE"    ; "kernel" jumptable
.importzp out_vector, in_vector
.import primm, set_input, set_output, xmodem_upload
.import upload
.export krn_chrin, krn_chrout, krn_primm, krn_set_input, krn_set_output, krn_upload
krn_chrin:        jmp (out_vector)
krn_chrout:       jmp (in_vector)
krn_primm:        jmp primm
krn_set_output:   jmp set_output
krn_set_input:    jmp set_input
krn_upload:       jmp upload


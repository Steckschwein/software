.segment "JUMPTABLE"    ; "kernel" jumptable
.import out_vector, in_vector
.import primm, set_input, set_output

krn_chrin:        jmp (out_vector)
krn_chrout:       jmp (in_vector)
krn_primm:        jmp primm
krn_set_output:   jmp set_output
krn_set_input:    jmp set_input

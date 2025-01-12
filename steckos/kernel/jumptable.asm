.segment "JUMPTABLE"    ; "kernel" jumptable
.import out_vector, in_vector


.export krn_chrin
krn_chrin:        jmp (out_vector)

.export krn_chrout
krn_chrout:       jmp (in_vector)

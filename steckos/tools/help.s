.include "steckos.inc"

appstart $1000

.code
    jsr krn_primm
    .byte "ls                 - list directory contents",$0a,$0d
    .byte "cd <dir>           - change dir",$0a,$0d
    .byte "stat <file>        - show file stats",$0a,$0d
    .byte "attrib +-a <file>  - set file attribs",$0a,$0d
    .byte "rm <file>          - remove file",$0a,$0d
    .byte "mkdir <dir>        - create dir",$0a,$0d
    .byte "rmdir <dir>        - remove dir",$0a,$0d
    .byte "pwd                - show current dir",$0a,$0d
    .byte "date               - show date",$0a,$0d
    .byte "rename <from> <to> - rename file",$0a,$0d
    .byte "up                 - serial upload",$0a,$0d
    .byte "fsinfo             - filesystem info",$0a,$0d
    .byte "nvram              - manage nvram",$0a,$0d
    .byte "setdate            - set rtc date",$0a,$0d
    .byte "pd <page>          - dump memory page, pd 04 for $0400", $0a, $0d 
    .byte "ms <addr> <bytes>  - set memory",$0a, $0d
    .byte "bd <blocknr>       - sd block dump",$0a, $0d 
    .byte "go <addr>          - execute code at <addr>", $0a, $0d 
    .byte "load <file> <addr> - load file to memory address", $0a, $0d
    .byte $00

    jmp (retvec)
    
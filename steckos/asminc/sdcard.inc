.ifndef _SDCARD_INC_
  _SDCARD_INC_ = 1

;----------------------------------------------------------------------------------------------
; SD Card commands
;----------------------------------------------------------------------------------------------
cmd0 	= $40       ; GO_IDLE_STATE
cmd1 	= $40 + 1 	; SEND_OP_COND
cmd8 	= $40 + 8   ; SEND_IF_COND
cmd12	= $40 + 12  ; STOP_TRANSMISSION
cmd16	= $40 + 16 	; SET_BLOCKLEN
cmd17	= $40 + 17	; READ_SINGLE_BLOCK
cmd18	= $40 + 18	; READ_MULTIPLE_BLOCK
cmd24	= $40 + 24	; WRITE_BLOCK
cmd25	= $40 + 25	; WRITE_MULTIPLE_BLOCK
cmd55	= $40 + 55	; APP_CMD
cmd58	= $40 + 58	; READ_OCR
acmd41	= $40 + 41	; APP_SEND_OP_COND
acmd23	= $40 + 23	; SET_WR_BLOCK_ERASE_COUNT - Define number of blocks to pre-erase with next multi-block write command.

.struct sdcard_cmd 
  param   .byte 4 
  chksum  .byte 1
.endstruct

sd_data_token = $fe
; SD CArd command parameter/result buffer
; sd_cmd_param 		= $02a0
; sd_cmd_chksum		= sd_cmd_param+4

sd_cmd_response_retries = $30
sd_data_token_retries = $3f ; increase, card specific and must be larger for "huge" cards

; sd card R1 response status bits
sd_card_status_idle             = %00000001
sd_card_status_erase_reset      = %00000010
sd_card_status_illegal_command  = %00000100
sd_card_status_crc_error        = %00001000
sd_card_status_erase_seq_error  = %00010000
sd_card_status_address_error    = %00100000
sd_card_status_parameter_error  = %01000000

sd_card_error_timeout_busy = $c0
sd_card_error_timeout = $c1
sd_card_error_timeout_command = $c2


.endif
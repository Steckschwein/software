;----------------------------------------------------------------------------
; time struct with date set to 1970-01-01
.struct time_t
		  tm_sec	.byte		  ;0-59
		  tm_min	.byte		  ;0-59
		  tm_hour	.byte		  ;0-23
		  tm_mday	.byte		  ;1-31
		  tm_mon	.byte		  ;0-11 0-jan, 11-dec
		  tm_year	.word     ;years since 1900
		  tm_wday	.byte		  ;
 ;		 tm_yday
  ;		tm_isdst
.endstruct

;----------------------------------------------------------------------------
; last known timestamp with date set to 1970-01-01
rtc_systime_t = $02a0

; read rtc
rtc_read = 0
rtc_write = $80

rtc_reg_alm_mask  = 1<<7
rtc_reg_alm0_s = $07
rtc_reg_alm0_m = $08
rtc_reg_alm0_h = $09
rtc_reg_alm0_d = $0a

rtc_reg_ctrl    = $0f
rtc_reg_status  = $10
rtc_ctrl_wp     = 1<<6  ; write protect
rtc_ctrl_aie0   = 1<<0  ; alarm 0 interrupt enable

rtc_status_irq0 = 1<<0  ; alarm 0 interrupt request

.if .VERSION = (2*$100+17*$10+0)
.global				 _clock_gettime
;------------------------------------------------------------------------------
; Struct timespec - must match the struct defined in time.h
.struct timespec
		  tv_sec  .dword
		  tv_nsec .dword
.endstruct
.endif

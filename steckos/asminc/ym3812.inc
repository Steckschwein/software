.ifndef _YM3812_INC_
	_YM3812_INC_=1

.include "system.inc"

OPL_CLK = 3580000 ;Hz

OPL_VOLUME_MAX=0
OPL_VOLUME_MIN=$3f

OPL_INTERVAL_US_TIMER1 = 80   ; µs intervall at 3.58Mhz
OPL_INTERVAL_US_TIMER2 = 320  ; µs intervall at 3.58Mhz

opl_stat = $0240		; status register
opl_sel  = opl_stat		; register select
opl_data = opl_stat + 1	; data register (write only)

; master clock frequency is 3.58Mhz (~280/285ns) - from VDP Pin 8 which is 1/6 VDP frequency ~21.48Mhz
opl2_master_clock_freq = 3500000
opl2_wait_cycles_reg 	= 12 ; 12 * 280/285 = 3360/3428ns
opl2_wait_cycles_data 	= 84 ; 84 * 280 = 23520/24000ns

opl2_reg_delay_time = 	1000000000/opl2_master_clock_freq * opl2_wait_cycles_reg ; ns (3.3µs)
opl2_data_delay_time = 	1000000000/opl2_master_clock_freq * opl2_wait_cycles_data ; ns (23µs)

opl2_delay_register_cnt	= ((opl2_reg_delay_time / (1000/clockspeed)) -12) / 2
opl2_delay_data_cnt		= (((opl2_data_delay_time - opl2_reg_delay_time) / (1000/clockspeed)) -12) / 2 ; calculate cycles and div 2 (NOP)

opl2_s_irq		= 1<<7	; timer irq
opl2_s_irq_t1	= 1<<6	; ... irq cause of t1
opl2_s_irq_t2	= 1<<5	; ... irq cause of t2

opl2_reg_test = 1
opl2_reg_t1	= 2
opl2_reg_t2	= 3
opl2_reg_ctrl = 4

; wave forms
WS_SIN=       $00   ;
WS_HALF_SIN=  $01   ;
WS_ABS_SIN=   $02
WS_PULSE_SIN= $03

;--------------------------------------------------------------------------------------------------------------
; For some of the parameters, there is one register per output channel. For those
; parameters, channel number can be used as an offset into the map. For many
; parameters, there is one register per operator. However, there are holes in the
; address map so that in this case, the operator number CANNOT be used as an
; offset. The operator offsets for those registers are (in hex form):
;--------------------------------------------------------------------------------------------------------------
opl2_op1 	= $00
opl2_op2 	= $01
opl2_op3 	= $02
opl2_op4 	= $03
opl2_op5 	= $04
opl2_op6 	= $05
opl2_op7 	= $08
opl2_op8 	= $09
opl2_op9 	= $0A
opl2_op10 	= $0B
opl2_op11 	= $0C
opl2_op12 	= $0D
opl2_op13 	= $10
opl2_op14 	= $11
opl2_op15 	= $12
opl2_op16 	= $13
opl2_op17 	= $14
opl2_op18 	= $15
;--------------------------------------------------------------------------------------------------------------
opl2_chan0_op1	= opl2_op1
opl2_chan0_op2	= opl2_op4

opl2_chan1_op1	= opl2_op2
opl2_chan1_op2	= opl2_op5

opl2_chan2_op1	= opl2_op3
opl2_chan2_op2	= opl2_op6

opl2_chan3_op1	= opl2_op7
opl2_chan3_op2	= opl2_op10

opl2_chan4_op1	= opl2_op8
opl2_chan4_op2	= opl2_op11

opl2_chan5_op1	= opl2_op9
opl2_chan5_op2	= opl2_op12

opl2_chan6_op1	= opl2_op13
opl2_chan6_op2	= opl2_op16

opl2_chan7_op1	= opl2_op14
opl2_chan7_op2	= opl2_op17

opl2_chan8_op1	= opl2_op15
opl2_chan8_op2	= opl2_op18
;--------------------------------------------------------------------------------------------------------------


.macro opl_reg reg, val
		ldx #reg
		lda #val
		jsr opl2_reg_write
.endmacro

.macro oplSetRegVal reg, val
	lda #reg
	sta opl_stat
	; http://www.shipbrook.net/jeff/sb.html
	; The AdLib manual gives the wait times in microseconds: three point three (3.3) microseconds for the address, and twenty-three (23) microseconds for the data.
	; 3.300 ns / 0.25ns = 13.2 cycles / 2 = 6.6 NOPs

	.repeat opl2_reg_delay
		nop
	.endrepeat

	lda #val
	sta opl_data
	; 23.000 ns / 0.25ns = 92 cycles / 92 = 46 NOPs
	ldy #opl2_data_delay
:
	dey
	bne :-

.endmacro

.macro oplSetReg reg
	pha
	lda #reg
	sta opl_stat
	; http://www.shipbrook.net/jeff/sb.html
	; The AdLib manual gives the wait times in microseconds: three point three (3.3) microseconds for the address, and twenty-three (23) microseconds for the data.
	; 3.300 ns / 0.25ns = 13.2 cycles / 2 = 6.6 NOPs

	.repeat opl2_reg_delay
		nop
	.endrepeat
	pla
	sta opl_data
	; 23.000 ns / 0.25ns = 92 cycles / 92 = 46 NOPs
	; !for .i,1,46 {
	; 	nop
	; }
	ldy #opl2_data_delay
:
	dey
	bne :-
.endmacro

.endif

; @module: uart
.include "system.inc"
.include "uart.inc"
.export  init_uart, uart_tx, uart_rx, uart_rx_nowait


.code


;----------------------------------------------------------------------------------------------
;@name: init_uart
;@desc: init UART to 115200 baud, 8N1
;@in: - 
;@out: -
;----------------------------------------------------------------------------------------------
init_uart:
    lda #lcr_DLAB       ; enable divisor latch access bit in order to write divisor
    sta uart1+uart_lcr

		; 115200 baud
		lda #1
		sta uart1+uart_dll
		stz uart1+uart_dlh

		; 8N1
		lda #%00000011
		sta uart1+uart_lcr

		; Enable FIFO, reset tx/rx FIFO
		lda #fcr_FIFO_enable | fcr_reset_receiver_FIFO | fcr_reset_transmit_FIFO
		sta uart1+uart_fcr

		stz uart1+uart_ier
		stz uart1+uart_mcr	; reset DTR, RTS

		rts

;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; @name: uart_tx
; @desc: send byte in A
; @in: A - byte to be sent
; @out:
;----------------------------------------------------------------------------------------------
uart_tx:
		pha

		lda #lsr_THRE
@l:
		bit uart1+uart_lsr
		beq @l

		pla

		sta uart1+uart_rxtx

		rts
;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; @name: uart_rx
; @desc: receive byte, wait until received, store in A
; @in: - 
; @out: A - received byte
;----------------------------------------------------------------------------------------------
uart_rx:
		lda #lsr_DR
@l:
		bit uart1+uart_lsr
		beq @l
		lda uart1+uart_rxtx
		rts
;----------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------
; @name: uart_rx
; @desc: receive byte, no wait, set carry and store in A when received
; @in: - 
; @out: A - received byte
;----------------------------------------------------------------------------------------------
uart_rx_nowait:
		lda #lsr_DR
		bit uart1+uart_lsr
		beq @l
		lda uart1+uart_rxtx
		sec
		rts
@l:
		clc
		rts
;----------------------------------------------------------------------------------------------

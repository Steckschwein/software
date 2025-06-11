; @module: uart
.include "system.inc"
.include "uart.inc"
.export  uart_init, uart_tx, uart_rx, uart_rx_nowait


.code


;----------------------------------------------------------------------------------------------
;@name: init_uart
;@desc: init UART to 115200 baud, 8N1
;@in: - 
;@out: -
;----------------------------------------------------------------------------------------------
uart_init:
    lda #lcr_DLAB       ; enable divisor latch access bit in order to write divisor
    sta uart1+uart_lcr

		; 115200 baud
		lda #1
		sta uart1+uart_dll
		stz uart1+uart_dlh

		; 8N1
		lda #lcr_WLS0 | lcr_WLS1
		sta uart1+uart_lcr

		; Enable FIFO, reset tx/rx FIFO, set FIFO trigger level to 14 bytes
		lda #fcr_FIFO_enable | fcr_reset_receiver_FIFO | fcr_reset_transmit_FIFO | 1<<6 | 1<<7
		sta uart1+uart_fcr

		; disable interrupts
		stz uart1+uart_ier

		; reset DTR, set RTS, enable auto flow control
		lda #mcr_RTS | mcr_AFE
		sta uart1+uart_mcr	

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

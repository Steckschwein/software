.code
.export init_via
.include "via.inc"
.include "spi.inc"

;----------------------------------------------------------------------------------------------
; init VIA1
;----------------------------------------------------------------------------------------------
init_via:

		; disable VIA1 interrupts
		lda #%01111111			 ; bit 7 "0", to clear all int sources
		sta via1ier

		;Port A directions
		lda #%11000000 		; via port A - set PA7,6 to output (joystick port select), PA1-5 to input (directions)
		sta via1ddra

		; init shift register and port b for SPI use
		; SR shift in, External clock on CB1
		lda #%00001100
		sta via1acr

		; Port b bit 6 and 5 input for sdcard and write protect detection, rest all outputs
		lda #%10011111
		sta via1ddrb

		; SPICLK low, MOSI low, SPI_SS HI
		lda #spi_device_deselect
		sta via1portb

		rts
;----------------------------------------------------------------------------------------------

;@module: spi

.ifdef DEBUG_SPI; enable debug for this module
	debug_enabled=1
.endif

.include "via.inc"
.include "spi.inc"
.include "errno.inc"

.zeropage
spi_sr: .res 1

.export spi_rw_byte
.export spi_deselect
.export spi_r_byte
.export spi_select_device

.code
;@name: "spi_deselect"
;@desc: "deselect all SPI devices"
spi_deselect:
		pha
		lda #spi_device_deselect
		sta via1portb
		pla
		rts

;----------------------------------------------------------------------------------------------
; Receive byte VIA SPI
; Received byte in A at exit, Z, N flags set accordingly to A
; Destructive: A,X
;----------------------------------------------------------------------------------------------
;@name: "spi_r_byte"
;@out: A, "received byte"
;@clobbers: A,X
;@desc: "read byte via SPI"
spi_r_byte:
		lda via1portb ; Port laden
		AND #$fe	  ; Takt ausschalten, MOSI set to '1' - we send $ff byte
		TAX			  ; aufheben
		INC

		STA via1portb ; Takt An 1
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 2
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 3
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 4
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 5
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 6
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 7
		STX via1portb ; Takt aus
		STA via1portb ; Takt An 8
		STX via1portb ; Takt aus

		lda via1sr
		rts


;----------------------------------------------------------------------------------------------
; Transmit byte VIA SPI
; Byte to transmit in A, received byte in A at exit
; Destructive: A,X,Y
;----------------------------------------------------------------------------------------------
;@name: "spi_rw_byte"
;@in: A, "byte to transmit"
;@out: A, "received byte"
;@clobbers: A,X,Y
;@desc: "transmit byte via SPI"
spi_rw_byte:
    sta spi_sr    ; zu transferierendes byte im akku retten

    ldx #$08

    lda via1portb   ; Port laden
    and #$fe        ; SPICLK loeschen

    asl             ; Nach links schieben, damit das bit nachher an der richtigen stelle steht
    tay             ; bunkern

@l: rol spi_sr
    tya             ; portinhalt
    ror             ; datenbit reinschieben

    sta via1portb   ; ab in den port
    inc via1portb   ; takt an
    sta via1portb   ; takt aus

    dex
    bne @l          ; schon acht mal?

    lda via1sr      ; Schieberegister auslesen
    rts


;@name: spi_select_device
;@in; A, "spi device, one of devices see spi.inc"
;@out: Z = 1 spi for given device could be selected (not busy), Z=0 otherwise
;@desc: select spi device given in A. the method is aware of the current processor state, especially the interrupt flag
spi_select_device:
    php
    sei ;critical section start
    pha

    ; check busy and select within sei => !ATTENTION! is busy check and spi device select must be "atomic", otherwise the spi state may change in between
    lda via1portb
    and #spi_device_deselect
    cmp #spi_device_deselect
    bne @l_exit    ;busy, leave section, device could not be selected

    pla
    sta via1portb

    plp
    lda #EOK  ;exit ok
    rts

@l_exit:
    pla
    plp          ;restore P (interrupt flag)
    lda #EBUSY
    rts
    
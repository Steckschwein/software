.ifndef _VIA_INC_
  _VIA_INC_=1

; VIA address and registers
via1		  = $0210
via1porta	= via1+1
via1portb	= via1
via1ddrb	 = via1+2
via1ddra	 = via1+3
via1t1cl	 = via1+4
via1t1ch	 = via1+5
via1t2cl	 = via1+8
via1t2ch	 = via1+9
via1sr		= via1 + $0a
via1acr	  = via1 + $0b
via1pcr	  = via1 + $0c
via1ifr	  = via1 + $0d
via1ier	  = via1 + $0e

SDCARD_WRITE_PROTECT  = 1<<5
SDCARD_DETECT			= 1<<6

.endif
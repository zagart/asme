PORTA	equ 0x05
PORTB	equ 0x06

	code

PROCESSOR	PIC16F877
	errorlevel	-302
	__config	_WDT_OFF
	#include	<p16f877.inc>

	org	0x000
	movlw	0x20
	movwf	STATUS
	movlw	0xFF
	tris	PORTB
	movlw	0x30
	tris	PORTA
	clrw
	movwf	PCLATH
	movlw	0x07
	movwf	ADCON1
	banksel	ADCON0
	clrf	PORTA
	clrf	PORTB

	clrw
	tris PORTA
	movlw 0xff
	tris PORTB
	movwf PORTA
Check
	btfsc PORTB,0
	goto Fire
	goto PayOff
PayOff
	clrf PORTA
	goto Check
Fire
	clrw
	movwf PORTA
	bsf PORTA,0
	goto Check
	END

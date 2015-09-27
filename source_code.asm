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
	
	clrf PORTA
	comf PORTA
	bcf PORTA, 4
	bcf PORTA, 5
	bsf 0x1F,7
Check
	clrf 0x1E
	movlw 0x07
	movwf 0x1D
	btfss PORTB,0
	goto Etc
	goto Mode		
Mode
	btfsc PORTB,2
	goto modeSelect
	incf 0x1E,1
	decfsz 0x1D,1
	goto Mode
	goto Err	 
Err
	bsf PORTA,5
	clrf 0x1E
	goto Check

modeSelect


Etc
	btfss 0x1F,7
	goto Check
	bcf 0x1F,7
	nop
	nop
	nop
	clrf PORTA
	goto Check

	END

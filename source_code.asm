PORTA	equ 0x05
PORTB	equ 0x06
curMode	equ 0x1C

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
	btfsc PORTB,1
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
firstCheck
	decfsz 0x1E,1
	goto secondCheck
	goto firstMode
secondCheck
	decfsz 0x1E,1
	goto thirdCheck
	goto secondMode
thirdCheck
	decfsz 0x1E,1
	goto fourthCheck
	goto thirdMode
fourthCheck
	decfsz 0x1E,1
	goto fifthCheck
	goto fourthMode
fifthCheck
	decfsz 0x1E,1
	goto sixCheck
	goto fifthMode
sixCheck
	goto sixMode

firstMode
	clrw
	movlw 0x01
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	bcf PORTA,5
	bsf PORTA,0
	nop
	goto firstMode
secondMode
	clrw
	movlw 0x02
	movwf curMode
	bcf PORTA,5
	nop
	goto secondMode
thirdMode
	clrw
	movlw 0x03
	movwf curMode
	bcf PORTA,5
	nop
	goto thirdMode
fourthMode
	clrw
	movlw 0x04
	movwf curMode
	bcf PORTA,5
	nop
	goto fourthMode
fifthMode
	clrw
	movlw 0x05
	movwf curMode
	bcf PORTA,5
	nop
	goto fifthMode
sixMode
	clrw
	movlw 0x06
	movwf curMode
	bcf PORTA,5
	nop
	goto sixMode

switchOff
	btfss PORTB,2
	goto modeReturn
	clrf PORTA
	goto switchOff

modeReturn
firstReturn
	decfsz curMode,1
	goto secondReturn
	goto firstMode
secondReturn
	decfsz curMode,1
	goto thirdReturn
	goto secondMode
thirdReturn
	decfsz curMode,1
	goto fourthReturn
	goto thirdMode
fourthReturn
	decfsz curMode,1
	goto fifthReturn
	goto fourthMode
fifthReturn
	decfsz curMode,1
	goto sixReturn
	goto fifthMode
sixReturn
	goto sixMode

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

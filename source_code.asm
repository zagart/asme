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
	clrf curMode
	movlw 0x07
	movwf 0x1D
	btfsc 0x1F,7
	goto Etc
	btfss PORTB,0
	goto Check
	goto Mode
		
Mode
	clrf 0x1C
	btfsc PORTB,1
	goto modeSelect
	btfsc PORTB,0
	goto Inc
	goto Mode 
Inc
	incf 0x1E,1
	decfsz 0x1D,1
	goto Mode
	goto Err	 
Err
	bsf PORTA,5
	clrf 0x1E
	goto Check

modeSelect
incf 0x1E,1
decfsz 0x1E,1
goto firstCheck
goto Err

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
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x01
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	clrf PORTA
	bsf PORTA,3
	nop
	clrf PORTA
	bsf PORTA,2
	nop
	clrf PORTA
	bsf PORTA,1
	nop
	clrf PORTA
	bsf PORTA,0
	nop
	goto secondMode
	goto firstMode

secondMode
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x02
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	nop
	clrf PORTA
	bsf PORTA,0
	nop
	clrf PORTA
	bsf PORTA,1
	nop
	clrf PORTA
	bsf PORTA,2
	nop
	clrf PORTA
	bsf PORTA,3
	nop
	btfsc PORTB,3
	goto thirdMode
	goto secondMode
thirdMode
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x03
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	nop
	nop
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,1
	nop
	nop
	clrf PORTA
	bsf PORTA,2
	bsf PORTA,3
	btfsc PORTB,3
	goto fourthMode
	goto thirdMode
fourthMode
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x04
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	nop
	nop
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,3
	nop
	nop
	clrf PORTA
	bsf PORTA,1
	bsf PORTA,2
	btfsc PORTB,3
	goto fifthMode
	goto fourthMode
fifthMode
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x05
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	nop
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	nop
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	nop
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	nop
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	btfsc PORTB,3
	goto sixMode
	goto fifthMode
sixMode
	btfsc PORTB,4
	goto Exit
	bcf PORTA,5
	clrw
	movlw 0x06
	movwf curMode
	btfsc PORTB,2
	goto switchOff
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	nop
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	nop
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	nop
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	nop
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	btfsc PORTB,3
	goto firstMode
	goto sixMode

Exit
clrf PORTA
goto Mode

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
	clrf PORTA
	goto Check

	END

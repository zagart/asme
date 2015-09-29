PORTA	equ 0x05
PORTB	equ 0x06
button	equ 0x1A
curMode	equ 0x1B
mode	equ 0x1C
temp	equ 0x1D

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
	movlw	0x308
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
	call Delay
	clrf PORTA
	clrf mode
	clrf curMode
	clrf button
		
codeEnter
	clrf mode
	clrf temp
	btfsc PORTB,0
	bsf mode,2	
	btfsc PORTB,1
	bsf mode,1
	btfsc PORTB,2
	bsf mode,0
	btfsc PORTB,3
	goto modeSelect
	goto codeEnter	 

modeSelect
	call errorCheck
	clrf temp
firstSearch
	decfsz mode,1
	goto secondSearch
	goto firstMode
secondSearch
	decfsz mode,1
	goto thirdSearch
	goto secondMode
thirdSearch
	decfsz mode,1
	goto fourthSearch
	goto thirdMode
fourthSearch
	decfsz mode,1
	goto fifthSearch
	goto fourthMode
fifthSearch
	decfsz mode,1
	goto sixSearch
	goto fifthMode
sixSearch
	goto sixMode

firstMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x01
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	clrf PORTA
	bsf PORTA,3
	call Delay
	clrf PORTA
	bsf PORTA,2
	call Delay
	clrf PORTA
	bsf PORTA,1
	call Delay
	clrf PORTA
	bsf PORTA,0
	call Delay
	btfsc PORTB,5
	goto secondMode
	goto firstMode

secondMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x02
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	call Delay
	clrf PORTA
	bsf PORTA,0
	call Delay
	clrf PORTA
	bsf PORTA,1
	call Delay
	clrf PORTA
	bsf PORTA,2
	call Delay
	clrf PORTA
	bsf PORTA,3
	call Delay
	btfsc PORTB,5
	goto thirdMode
	goto secondMode
thirdMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x03
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	call Delay
	call Delay
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,1
	call Delay
	call Delay
	clrf PORTA
	bsf PORTA,2
	bsf PORTA,3
	btfsc PORTB,5
	goto fourthMode
	goto thirdMode
fourthMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x04
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	call Delay
	call Delay
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,3
	call Delay
	call Delay
	clrf PORTA
	bsf PORTA,1
	bsf PORTA,2
	btfsc PORTB,5
	goto fifthMode
	goto fourthMode
fifthMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x05
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	call Delay
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	btfsc PORTB,5
	goto sixMode
	goto fifthMode
sixMode
	btfss PORTB,5
	call doPressed
	btfsc PORTB,5
	bsf temp,0
	bcf PORTA,5
	clrw
	movlw 0x06
	movwf curMode
	btfsc PORTB,4
	goto switchOff
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	call Delay
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	call Delay
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	btfsc PORTB,5
	goto firstMode
	goto sixMode

Exit
clrf PORTA
goto codeEnter

switchOff
	btfss PORTB,4
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

errorCheck
	clrf temp
	btfsc mode,0
	bsf temp,0
	btfsc mode,1
	bsf temp,1
	btfsc mode,2
	bsf temp,2
	incf temp
	decfsz temp,1
	goto Next
	goto Err
Next
	decf temp
	decf temp
	decf temp
	decf temp
	decf temp
	decf temp
	decfsz temp,1
	return
	goto Err

Err
	bsf PORTA,5
	clrf temp
	goto codeEnter

Iteration
	
	return

doPressed
	btfsc temp,0
	goto Exit
	return

Delay
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	return

	END

PORTA	equ 0x05
PORTB	equ 0x06
button	equ 0x1A
curMode	equ 0x1B
mode	equ 0x1C
temp	equ 0x1D
speed	equ 0x1E
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
	clrf speed
	clrw
	tris PORTA
	movlw 0xff
	tris PORTB	
	clrf PORTA
	comf PORTA
	bcf PORTA, 4
	bcf PORTA, 5
	call Delay
	call Delay
	call Delay
	clrf PORTA
	clrf mode
	clrf curMode
	clrf button		
codeEnter
	bsf speed,0
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
checkSwitchOff
	btfsc PORTB,4
	goto switchOff
	return
checkIteration
	btfsc PORTB,5
	bsf temp,0
	return
checkReset
	btfss PORTB,5
	call doPressed
	return
Status
	call checkSwitchOff
	call checkIteration
	call checkReset
	return
firstMode
	bcf PORTA,5
	clrw
	movlw 0x01
	movwf curMode
	call Status
	clrf PORTA
	bsf PORTA,3
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,2
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,1
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,0
	call Delay
	call Status
	btfsc PORTB,5
	goto secondMode
	goto firstMode
secondMode
	bcf PORTA,5
	clrw
	movlw 0x02
	movwf curMode
	call Status
	clrf PORTA
	bsf PORTA,0
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,1
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,2
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,3
	call Delay
	call Status
	btfsc PORTB,5
	goto thirdMode
	goto secondMode
thirdMode
	bcf PORTA,5
	clrw
	movlw 0x03
	movwf curMode
	call Status
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,1
	call Delay
	call Status
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	call Delay
	call Status
	btfsc PORTB,5
	goto fourthMode
	goto thirdMode
fourthMode
	bcf PORTA,5
	clrw
	movlw 0x04
	movwf curMode
	clrf PORTA
	bsf PORTA,0
	bsf PORTA,3
	call Delay
	call Status
	call Delay
	call Status
	clrf PORTA
	bsf PORTA,1
	bsf PORTA,2
	call Delay
	call Status
	call Delay
	call Status
	btfsc PORTB,5
	goto fifthMode
	goto fourthMode
fifthMode
	bcf PORTA,5
	clrw
	movlw 0x05
	movwf curMode
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	call Delay
	call Status
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	btfsc PORTB,5
	goto sixMode
	goto fifthMode
sixMode
	bcf PORTA,5
	clrw
	movlw 0x06
	movwf curMode
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bcf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bsf PORTA,0
	bcf PORTA,1
	bsf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bsf PORTA,0
	bsf PORTA,1
	bcf PORTA,2
	bsf PORTA,3
	call Delay
	call Status
	bsf PORTA,0
	bsf PORTA,1
	bsf PORTA,2
	bcf PORTA,3
	call Delay
	call Status
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
	goto nextErr
	goto Err
nextErr
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
doPressed
	btfsc temp,0
	goto Exit
	return
Delay
	btfsc speed,0
	goto highSpeed
	goto slowSpeed
highSpeed
	call nopRepository
	return
slowSpeed
	call nopRepository
	call nopRepository
	call nopRepository
	call nopRepository
	return
nopRepository
	nop
	nop
	nop
	nop
	nop
	return
	END

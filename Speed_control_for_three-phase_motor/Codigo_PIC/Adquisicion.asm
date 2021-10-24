
Adquisicion_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;Adquisicion.mbas,37 :: 		sub procedure interrupt                   ' Interrupt service routine
;Adquisicion.mbas,38 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt2
;Adquisicion.mbas,39 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,40 :: 		velocidad=receive
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	CLRF       _velocidad+1
L_Adquisicion_interrupt2:
;Adquisicion.mbas,43 :: 		if INTCON.INTF = 1 then            ' External interupt (RB0 pin) ?
	BTFSS      INTCON+0, 1
	GOTO       L_Adquisicion_interrupt5
;Adquisicion.mbas,45 :: 		inc(vueltas)
	INCF       _vueltas+0, 1
;Adquisicion.mbas,56 :: 		Clearbit(INTCON,INTF)
	BCF        INTCON+0, 1
;Adquisicion.mbas,57 :: 		Setbit(INTCON,INTE)
	BSF        INTCON+0, 4
L_Adquisicion_interrupt5:
;Adquisicion.mbas,58 :: 		end if
L_Adquisicion_interrupt16:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of Adquisicion_interrupt

_main:
;Adquisicion.mbas,69 :: 		main:
;Adquisicion.mbas,70 :: 		OSCCON = 0X75
	MOVLW      117
	MOVWF      OSCCON+0
;Adquisicion.mbas,71 :: 		OPTION_REG=%01000111
	MOVLW      71
	MOVWF      OPTION_REG+0
;Adquisicion.mbas,72 :: 		INTCON = %11000000       ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      192
	MOVWF      INTCON+0
;Adquisicion.mbas,73 :: 		PIE1 = %00100000
	MOVLW      32
	MOVWF      PIE1+0
;Adquisicion.mbas,76 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;Adquisicion.mbas,77 :: 		ANSELH = %00000000           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	CLRF       ANSELH+0
;Adquisicion.mbas,80 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;Adquisicion.mbas,81 :: 		trisb  = %00000001           ' Configuracion IN/OUT PORTB
	MOVLW      1
	MOVWF      TRISB+0
;Adquisicion.mbas,82 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,85 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,86 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,89 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,91 :: 		n=0
	CLRF       _n+0
	CLRF       _n+1
;Adquisicion.mbas,92 :: 		automatico=0
	CLRF       _automatico+0
;Adquisicion.mbas,93 :: 		salto = 1
	MOVLW      1
	MOVWF      _salto+0
;Adquisicion.mbas,94 :: 		Frecuencia = 0
	CLRF       _Frecuencia+0
	CLRF       _Frecuencia+1
;Adquisicion.mbas,95 :: 		operacion =0
	CLRF       _operacion+0
;Adquisicion.mbas,96 :: 		count = 0
	CLRF       _count+0
	CLRF       _count+1
;Adquisicion.mbas,97 :: 		tiempo = 0
	CLRF       R0+0
	CALL       _Byte2Double+0
	MOVF       R0+0, 0
	MOVWF      _tiempo+0
	MOVF       R0+1, 0
	MOVWF      _tiempo+1
	MOVF       R0+2, 0
	MOVWF      _tiempo+2
	MOVF       R0+3, 0
	MOVWF      _tiempo+3
;Adquisicion.mbas,98 :: 		vueltas=0
	CLRF       _vueltas+0
;Adquisicion.mbas,100 :: 		while true
L__main9:
;Adquisicion.mbas,107 :: 		velocidadhz = velocidad * 113
	MOVF       _velocidad+0, 0
	MOVWF      R0+0
	MOVF       _velocidad+1, 0
	MOVWF      R0+1
	MOVLW      113
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _velocidadhz+0
	MOVF       R0+1, 0
	MOVWF      _velocidadhz+1
;Adquisicion.mbas,108 :: 		PORTA = lo(velocidadhz)
	MOVF       _velocidadhz+0, 0
	MOVWF      PORTA+0
;Adquisicion.mbas,109 :: 		alto_adc= hi(velocidadhz)
	MOVF       _velocidadhz+1, 0
	MOVWF      _alto_adc+0
;Adquisicion.mbas,110 :: 		PORTB.5 = alto_adc.0
	BTFSC      _alto_adc+0, 0
	GOTO       L__main17
	BCF        PORTB+0, 5
	GOTO       L__main18
L__main17:
	BSF        PORTB+0, 5
L__main18:
;Adquisicion.mbas,111 :: 		PORTB.4 = alto_adc.1
	BTFSC      _alto_adc+0, 1
	GOTO       L__main19
	BCF        PORTB+0, 4
	GOTO       L__main20
L__main19:
	BSF        PORTB+0, 4
L__main20:
;Adquisicion.mbas,113 :: 		vueltas = 0
	CLRF       _vueltas+0
;Adquisicion.mbas,115 :: 		INTCON.INTE=1
	BSF        INTCON+0, 4
;Adquisicion.mbas,116 :: 		delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main13:
	DECFSZ     R13+0, 1
	GOTO       L__main13
	DECFSZ     R12+0, 1
	GOTO       L__main13
	DECFSZ     R11+0, 1
	GOTO       L__main13
;Adquisicion.mbas,117 :: 		delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main14:
	DECFSZ     R13+0, 1
	GOTO       L__main14
	DECFSZ     R12+0, 1
	GOTO       L__main14
	DECFSZ     R11+0, 1
	GOTO       L__main14
;Adquisicion.mbas,118 :: 		delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main15:
	DECFSZ     R13+0, 1
	GOTO       L__main15
	DECFSZ     R12+0, 1
	GOTO       L__main15
	DECFSZ     R11+0, 1
	GOTO       L__main15
;Adquisicion.mbas,120 :: 		INTCON.INTE= 0
	BCF        INTCON+0, 4
;Adquisicion.mbas,122 :: 		UART1_Write(0x66)
	MOVLW      102
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Adquisicion.mbas,123 :: 		byteToStr(vueltas, txt)
	MOVF       _vueltas+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,124 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,143 :: 		adc_pot = 0
	CLRF       _adc_pot+0
	GOTO       L__main9
;Adquisicion.mbas,144 :: 		wend
	GOTO       $+0
; end of _main

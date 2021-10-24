
_main:
;Adquisicion.mbas,51 :: 		main:
;Adquisicion.mbas,61 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;Adquisicion.mbas,62 :: 		ANSELH = %00000010           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      2
	MOVWF      ANSELH+0
;Adquisicion.mbas,65 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;Adquisicion.mbas,66 :: 		trisb  = %00101000           ' Configuracion IN/OUT PORTB
	MOVLW      40
	MOVWF      TRISB+0
;Adquisicion.mbas,67 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,70 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,71 :: 		PORTB  = %00000000           ' Inicializacion PORTA
	CLRF       PORTB+0
;Adquisicion.mbas,72 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,75 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,78 :: 		humedad = ADC_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _humedad+0
;Adquisicion.mbas,79 :: 		pot = ADC_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot+0
;Adquisicion.mbas,80 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,82 :: 		while true
L__main2:
;Adquisicion.mbas,84 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main7
;Adquisicion.mbas,85 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,87 :: 		if receive= "0" then '' m - me envian modo manual
	MOVF       R0+0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L__main10
;Adquisicion.mbas,88 :: 		porta.3=1  'enciende led
	BSF        PORTA+0, 3
;Adquisicion.mbas,89 :: 		portb.0=0  'prende rele
	BCF        PORTB+0, 0
	GOTO       L__main11
;Adquisicion.mbas,90 :: 		else
L__main10:
;Adquisicion.mbas,91 :: 		porta.3=0   'apaga led
	BCF        PORTA+0, 3
;Adquisicion.mbas,92 :: 		portb.0=1   'apaga rele
	BSF        PORTB+0, 0
;Adquisicion.mbas,93 :: 		end if
L__main11:
L__main7:
;Adquisicion.mbas,95 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,96 :: 		prom1=0
	CLRF       _prom1+0
	CLRF       _prom1+1
;Adquisicion.mbas,97 :: 		while n<100
L__main13:
	MOVLW      100
	SUBWF      _n+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main14
;Adquisicion.mbas,98 :: 		humedad = ADC_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _humedad+0
;Adquisicion.mbas,99 :: 		pot = ADC_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot+0
;Adquisicion.mbas,100 :: 		prom1=prom1+humedad
	MOVF       _humedad+0, 0
	ADDWF      _prom1+0, 1
	BTFSC      STATUS+0, 0
	INCF       _prom1+1, 1
;Adquisicion.mbas,101 :: 		n=n+1
	INCF       _n+0, 1
	GOTO       L__main13
L__main14:
;Adquisicion.mbas,103 :: 		prom1=prom1/100
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _prom1+0, 0
	MOVWF      R0+0
	MOVF       _prom1+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _prom1+0
	MOVF       R0+1, 0
	MOVWF      _prom1+1
;Adquisicion.mbas,105 :: 		if portb.5=1 then
	BTFSS      PORTB+0, 5
	GOTO       L__main18
;Adquisicion.mbas,106 :: 		pozo=0
	CLRF       _pozo+0
	GOTO       L__main19
;Adquisicion.mbas,107 :: 		else
L__main18:
;Adquisicion.mbas,108 :: 		pozo=100
	MOVLW      100
	MOVWF      _pozo+0
;Adquisicion.mbas,109 :: 		end if
L__main19:
;Adquisicion.mbas,112 :: 		UART1_Write_text("h")
	MOVLW      104
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,113 :: 		ByteToStr(prom1,txt)
	MOVF       _prom1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,114 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,115 :: 		UART1_Write_text("p")
	MOVLW      112
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,116 :: 		ByteToStr(pozo,txt)
	MOVF       _pozo+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,117 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,121 :: 		porta.1=1
	BSF        PORTA+0, 1
;Adquisicion.mbas,122 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__main20:
	DECFSZ     R13+0, 1
	GOTO       L__main20
	DECFSZ     R12+0, 1
	GOTO       L__main20
	DECFSZ     R11+0, 1
	GOTO       L__main20
	NOP
	NOP
;Adquisicion.mbas,123 :: 		porta.1=0
	BCF        PORTA+0, 1
;Adquisicion.mbas,124 :: 		delay_ms(250)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L__main21:
	DECFSZ     R13+0, 1
	GOTO       L__main21
	DECFSZ     R12+0, 1
	GOTO       L__main21
	DECFSZ     R11+0, 1
	GOTO       L__main21
	NOP
	NOP
	GOTO       L__main2
;Adquisicion.mbas,125 :: 		wend
	GOTO       $+0
; end of _main

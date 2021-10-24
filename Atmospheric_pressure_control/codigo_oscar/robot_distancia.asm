
_main:
;robot_distancia.mbas,31 :: 		main:
;robot_distancia.mbas,41 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;robot_distancia.mbas,42 :: 		ANSELH = %00010000           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      16
	MOVWF      ANSELH+0
;robot_distancia.mbas,45 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;robot_distancia.mbas,46 :: 		trisb  = %00000001           ' Configuracion IN/OUT PORTB
	MOVLW      1
	MOVWF      TRISB+0
;robot_distancia.mbas,47 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;robot_distancia.mbas,50 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;robot_distancia.mbas,51 :: 		PORTB  = %00000000           ' Inicializacion PORTA
	CLRF       PORTB+0
;robot_distancia.mbas,52 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;robot_distancia.mbas,55 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;robot_distancia.mbas,58 :: 		pot = ADC_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot+0
;robot_distancia.mbas,59 :: 		presion = ADC_Read(12)+pot
	MOVLW      12
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       _pot+0, 0
	ADDWF      R0+0, 0
	MOVWF      _presion+0
;robot_distancia.mbas,60 :: 		n=0
	CLRF       _n+0
;robot_distancia.mbas,62 :: 		while true
L__main2:
;robot_distancia.mbas,64 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main7
;robot_distancia.mbas,65 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;robot_distancia.mbas,67 :: 		if receive= "0" then '' m - me envian modo manual
	MOVF       R0+0, 0
	XORLW      48
	BTFSS      STATUS+0, 2
	GOTO       L__main10
;robot_distancia.mbas,68 :: 		porta.3=1  'enciende led
	BSF        PORTA+0, 3
;robot_distancia.mbas,69 :: 		portb.3=1  'prende rele
	BSF        PORTB+0, 3
	GOTO       L__main11
;robot_distancia.mbas,70 :: 		else
L__main10:
;robot_distancia.mbas,71 :: 		porta.3=0   'apaga led
	BCF        PORTA+0, 3
;robot_distancia.mbas,72 :: 		portb.3=0   'apaga rele
	BCF        PORTB+0, 3
;robot_distancia.mbas,73 :: 		end if
L__main11:
L__main7:
;robot_distancia.mbas,75 :: 		n=0
	CLRF       _n+0
;robot_distancia.mbas,76 :: 		prom1=0
	CLRF       _prom1+0
	CLRF       _prom1+1
;robot_distancia.mbas,77 :: 		while n<100
L__main13:
	MOVLW      100
	SUBWF      _n+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main14
;robot_distancia.mbas,78 :: 		pot = ADC_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot+0
;robot_distancia.mbas,79 :: 		presion = ADC_Read(12)
	MOVLW      12
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _presion+0
;robot_distancia.mbas,80 :: 		prom1=prom1+presion
	MOVF       R0+0, 0
	ADDWF      _prom1+0, 1
	BTFSC      STATUS+0, 0
	INCF       _prom1+1, 1
;robot_distancia.mbas,81 :: 		n=n+1
	INCF       _n+0, 1
	GOTO       L__main13
L__main14:
;robot_distancia.mbas,83 :: 		prom1=prom1/100
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
;robot_distancia.mbas,86 :: 		UART1_Write_text("p")
	MOVLW      112
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;robot_distancia.mbas,87 :: 		ByteToStr(prom1,txt)
	MOVF       _prom1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;robot_distancia.mbas,88 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;robot_distancia.mbas,92 :: 		porta.1=1
	BSF        PORTA+0, 1
;robot_distancia.mbas,93 :: 		delay_ms(100)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L__main17:
	DECFSZ     R13+0, 1
	GOTO       L__main17
	DECFSZ     R12+0, 1
	GOTO       L__main17
	DECFSZ     R11+0, 1
	GOTO       L__main17
	NOP
;robot_distancia.mbas,94 :: 		porta.1=0
	BCF        PORTA+0, 1
;robot_distancia.mbas,95 :: 		delay_ms(100)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L__main18:
	DECFSZ     R13+0, 1
	GOTO       L__main18
	DECFSZ     R12+0, 1
	GOTO       L__main18
	DECFSZ     R11+0, 1
	GOTO       L__main18
	NOP
	GOTO       L__main2
;robot_distancia.mbas,96 :: 		wend
	GOTO       $+0
; end of _main

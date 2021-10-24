
Adquisicion_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;Adquisicion.mbas,44 :: 		sub procedure interrupt                   ' Interrupt service routine
;Adquisicion.mbas,45 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt2
;Adquisicion.mbas,46 :: 		porta.2=1
	BSF        PORTA+0, 2
;Adquisicion.mbas,47 :: 		delay_ms(300)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_Adquisicion_interrupt4:
	DECFSZ     R13+0, 1
	GOTO       L_Adquisicion_interrupt4
	DECFSZ     R12+0, 1
	GOTO       L_Adquisicion_interrupt4
	DECFSZ     R11+0, 1
	GOTO       L_Adquisicion_interrupt4
;Adquisicion.mbas,48 :: 		porta.2=0
	BCF        PORTA+0, 2
;Adquisicion.mbas,49 :: 		delay_ms(300)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      134
	MOVWF      R12+0
	MOVLW      153
	MOVWF      R13+0
L_Adquisicion_interrupt5:
	DECFSZ     R13+0, 1
	GOTO       L_Adquisicion_interrupt5
	DECFSZ     R12+0, 1
	GOTO       L_Adquisicion_interrupt5
	DECFSZ     R11+0, 1
	GOTO       L_Adquisicion_interrupt5
;Adquisicion.mbas,50 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,51 :: 		velocidad=receive
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	CLRF       _velocidad+1
L_Adquisicion_interrupt2:
;Adquisicion.mbas,69 :: 		end if
L_Adquisicion_interrupt22:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of Adquisicion_interrupt

_main:
;Adquisicion.mbas,73 :: 		main:
;Adquisicion.mbas,74 :: 		OPTION_REG=%10000000
	MOVLW      128
	MOVWF      OPTION_REG+0
;Adquisicion.mbas,75 :: 		INTCON = %11000000       ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      192
	MOVWF      INTCON+0
;Adquisicion.mbas,80 :: 		PIE1 = %00100000         ' enable Timer1 interrupt
	MOVLW      32
	MOVWF      PIE1+0
;Adquisicion.mbas,83 :: 		ANSEL =  %00000111           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      7
	MOVWF      ANSEL+0
;Adquisicion.mbas,84 :: 		ANSELH = %00000000           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	CLRF       ANSELH+0
;Adquisicion.mbas,87 :: 		trisa  = %00000111           ' Configuracion IN/OUT PORTA
	MOVLW      7
	MOVWF      TRISA+0
;Adquisicion.mbas,88 :: 		trisb  = %00000000           ' Configuracion IN/OUT PORTB
	CLRF       TRISB+0
;Adquisicion.mbas,89 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,92 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,93 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,96 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,98 :: 		PWM1_Init(1000)                    ' Initialize PWM1 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Adquisicion.mbas,99 :: 		PWM2_Init(1000)                    ' Initialize PWM2 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Adquisicion.mbas,101 :: 		PWM1_Start()                       ' start PWM1
	CALL       _PWM1_Start+0
;Adquisicion.mbas,102 :: 		PWM2_Start()                       ' start PWM2
	CALL       _PWM2_Start+0
;Adquisicion.mbas,103 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,104 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,106 :: 		while true
L__main8:
;Adquisicion.mbas,107 :: 		velocidad=ADC_read(0)>>2
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	MOVF       R0+1, 0
	MOVWF      _velocidad+1
	RRF        _velocidad+1, 1
	RRF        _velocidad+0, 1
	BCF        _velocidad+1, 7
	RRF        _velocidad+1, 1
	RRF        _velocidad+0, 1
	BCF        _velocidad+1, 7
;Adquisicion.mbas,111 :: 		PORTB.0 = 1'; ' DRIVEA = 1 (LEFT drive on, RIGHT drive on, TOP drive off )
	BSF        PORTB+0, 0
;Adquisicion.mbas,112 :: 		PORTB.1 = 0'; ' DRIVEB = 0 (BOTTOM drive off )
	BCF        PORTB+0, 1
;Adquisicion.mbas,113 :: 		Delay_ms(5)';
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L__main12:
	DECFSZ     R13+0, 1
	GOTO       L__main12
	DECFSZ     R12+0, 1
	GOTO       L__main12
;Adquisicion.mbas,115 :: 		x_coord128 = ADC_read(1) / 10';
	MOVLW      1
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _x_coord128+0
	MOVF       R0+1, 0
	MOVWF      _x_coord128+1
;Adquisicion.mbas,118 :: 		porta=velocidad
	MOVF       _velocidad+0, 0
	MOVWF      PORTA+0
;Adquisicion.mbas,120 :: 		if  x_coord128 > 5 then
	MOVF       R0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       R0+0, 0
	SUBLW      5
L__main23:
	BTFSC      STATUS+0, 0
	GOTO       L__main14
;Adquisicion.mbas,121 :: 		if  x_coord128 > 40 then    '35 + 5
	MOVF       _x_coord128+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVF       _x_coord128+0, 0
	SUBLW      40
L__main24:
	BTFSC      STATUS+0, 0
	GOTO       L__main17
;Adquisicion.mbas,122 :: 		portb.1=1
	BSF        PORTB+0, 1
;Adquisicion.mbas,123 :: 		velocidad=(x_coord128-40)*3
	MOVLW      40
	SUBWF      _x_coord128+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _x_coord128+1, 0
	MOVWF      R0+1
	MOVLW      3
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	MOVF       R0+1, 0
	MOVWF      _velocidad+1
;Adquisicion.mbas,124 :: 		PWM1_Set_Duty(velocidad)
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,125 :: 		portb.2=1
	BSF        PORTB+0, 2
;Adquisicion.mbas,126 :: 		PWM2_Set_Duty(velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
	GOTO       L__main18
;Adquisicion.mbas,127 :: 		else
L__main17:
;Adquisicion.mbas,128 :: 		if  x_coord128 < 36 then    '35-5
	MOVLW      0
	SUBWF      _x_coord128+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVLW      36
	SUBWF      _x_coord128+0, 0
L__main25:
	BTFSC      STATUS+0, 0
	GOTO       L__main20
;Adquisicion.mbas,129 :: 		portb.1=0
	BCF        PORTB+0, 1
;Adquisicion.mbas,130 :: 		velocidad=(36-x_coord128)*3
	MOVF       _x_coord128+0, 0
	SUBLW      36
	MOVWF      R0+0
	MOVF       _x_coord128+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      3
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	MOVF       R0+1, 0
	MOVWF      _velocidad+1
;Adquisicion.mbas,131 :: 		PWM1_Set_Duty(velocidad)
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,132 :: 		portb.2=0
	BCF        PORTB+0, 2
;Adquisicion.mbas,133 :: 		PWM2_Set_Duty(velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
	GOTO       L__main21
;Adquisicion.mbas,134 :: 		else
L__main20:
;Adquisicion.mbas,135 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,136 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,137 :: 		end if
L__main21:
;Adquisicion.mbas,138 :: 		end if
L__main18:
	GOTO       L__main15
;Adquisicion.mbas,139 :: 		else
L__main14:
;Adquisicion.mbas,140 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,141 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,142 :: 		end if
L__main15:
;Adquisicion.mbas,144 :: 		UART1_Write_text("*")
	MOVLW      42
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,145 :: 		WordToStr(x_coord128, txt)
	MOVF       _x_coord128+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       _x_coord128+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;Adquisicion.mbas,146 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	GOTO       L__main8
;Adquisicion.mbas,147 :: 		wend
	GOTO       $+0
; end of _main

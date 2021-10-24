
Adquisicion_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;Adquisicion.mbas,30 :: 		sub procedure interrupt                   ' Interrupt service routine
;Adquisicion.mbas,31 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt2
;Adquisicion.mbas,32 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,34 :: 		case 1
	MOVF       _salto+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt7
;Adquisicion.mbas,35 :: 		if receive = 0xA0 then
	MOVF       _receive+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt9
;Adquisicion.mbas,36 :: 		salto =2
	MOVLW      2
	MOVWF      _salto+0
	GOTO       L_Adquisicion_interrupt10
;Adquisicion.mbas,37 :: 		else
L_Adquisicion_interrupt9:
;Adquisicion.mbas,38 :: 		salto =1
	MOVLW      1
	MOVWF      _salto+0
;Adquisicion.mbas,39 :: 		end if
L_Adquisicion_interrupt10:
	GOTO       L_Adquisicion_interrupt4
L_Adquisicion_interrupt7:
;Adquisicion.mbas,40 :: 		case 2
	MOVF       _salto+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt13
;Adquisicion.mbas,41 :: 		salto =3
	MOVLW      3
	MOVWF      _salto+0
;Adquisicion.mbas,42 :: 		velocidad= (receive*254)/9
	MOVF       _receive+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVLW      254
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      9
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	MOVF       R0+1, 0
	MOVWF      _velocidad+1
;Adquisicion.mbas,44 :: 		recivio = 1
	MOVLW      1
	MOVWF      _recivio+0
	GOTO       L_Adquisicion_interrupt4
L_Adquisicion_interrupt13:
;Adquisicion.mbas,45 :: 		case 3
	MOVF       _salto+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt16
;Adquisicion.mbas,46 :: 		salto =1
	MOVLW      1
	MOVWF      _salto+0
;Adquisicion.mbas,47 :: 		automatico = receive   ' automatico = 1 y no automatico = 0
	MOVF       _receive+0, 0
	MOVWF      _automatico+0
	GOTO       L_Adquisicion_interrupt4
L_Adquisicion_interrupt16:
L_Adquisicion_interrupt4:
;Adquisicion.mbas,49 :: 		end select
L_Adquisicion_interrupt2:
;Adquisicion.mbas,50 :: 		end if
L_Adquisicion_interrupt45:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of Adquisicion_interrupt

_main:
;Adquisicion.mbas,54 :: 		main:
;Adquisicion.mbas,55 :: 		OPTION_REG=%10000000
	MOVLW      128
	MOVWF      OPTION_REG+0
;Adquisicion.mbas,56 :: 		INTCON = %11000000       ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      192
	MOVWF      INTCON+0
;Adquisicion.mbas,61 :: 		PIE1 = %00100000         ' enable Timer1 interrupt
	MOVLW      32
	MOVWF      PIE1+0
;Adquisicion.mbas,64 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;Adquisicion.mbas,65 :: 		ANSELH = %00001010           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      10
	MOVWF      ANSELH+0
;Adquisicion.mbas,68 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;Adquisicion.mbas,69 :: 		trisb  = %00011000           ' Configuracion IN/OUT PORTB
	MOVLW      24
	MOVWF      TRISB+0
;Adquisicion.mbas,70 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,73 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,74 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,77 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,79 :: 		PWM1_Init(1000)                    ' Initialize PWM1 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Adquisicion.mbas,80 :: 		PWM2_Init(1000)                    ' Initialize PWM2 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Adquisicion.mbas,82 :: 		PWM1_Start()                       ' start PWM1
	CALL       _PWM1_Start+0
;Adquisicion.mbas,83 :: 		PWM2_Start()                       ' start PWM2
	CALL       _PWM2_Start+0
;Adquisicion.mbas,84 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,85 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,87 :: 		LDR1 = ADC_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _LDR1+0
;Adquisicion.mbas,88 :: 		LDR2 = ADC_Read(11)
	MOVLW      11
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _LDR2+0
;Adquisicion.mbas,89 :: 		prom=(LDR1+LDR2)/2 + 10
	MOVF       _LDR1+0, 0
	MOVWF      R2+0
	CLRF       R2+1
	MOVF       R0+0, 0
	ADDWF      R2+0, 0
	MOVWF      _prom+0
	MOVF       R2+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _prom+1
	RRF        _prom+1, 1
	RRF        _prom+0, 1
	BCF        _prom+1, 7
	MOVLW      10
	ADDWF      _prom+0, 1
	BTFSC      STATUS+0, 0
	INCF       _prom+1, 1
;Adquisicion.mbas,90 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,91 :: 		automatico=0
	CLRF       _automatico+0
;Adquisicion.mbas,92 :: 		salto = 1
	MOVLW      1
	MOVWF      _salto+0
;Adquisicion.mbas,93 :: 		while true
L__main19:
;Adquisicion.mbas,94 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,95 :: 		while (n<40)
L__main24:
	MOVLW      40
	SUBWF      _n+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main25
;Adquisicion.mbas,96 :: 		if automatico = 0 then
	MOVF       _automatico+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main29
;Adquisicion.mbas,97 :: 		velocidad=ADC_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
	MOVF       R0+1, 0
	MOVWF      _velocidad+1
L__main29:
;Adquisicion.mbas,99 :: 		LDR1 = ADC_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _LDR1+0
;Adquisicion.mbas,100 :: 		delay_us(5)
	NOP
	NOP
	NOP
	NOP
	NOP
;Adquisicion.mbas,101 :: 		LDR2 = ADC_Read(11)
	MOVLW      11
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _LDR2+0
;Adquisicion.mbas,102 :: 		delay_us(5)
	NOP
	NOP
	NOP
	NOP
	NOP
;Adquisicion.mbas,103 :: 		mldr1=mldr1+LDR1
	MOVF       _LDR1+0, 0
	ADDWF      _mldr1+0, 1
	BTFSC      STATUS+0, 0
	INCF       _mldr1+1, 1
;Adquisicion.mbas,104 :: 		mldr2=mldr2+LDR2
	MOVF       _LDR2+0, 0
	ADDWF      _mldr2+0, 1
	BTFSC      STATUS+0, 0
	INCF       _mldr2+1, 1
;Adquisicion.mbas,105 :: 		n=n+1
	INCF       _n+0, 1
	GOTO       L__main24
L__main25:
;Adquisicion.mbas,108 :: 		if recivio= 1 then
	MOVF       _recivio+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main34
;Adquisicion.mbas,109 :: 		PWM1_Set_Duty(velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,110 :: 		PWM2_Set_Duty(velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,111 :: 		recivio=0
	CLRF       _recivio+0
L__main34:
;Adquisicion.mbas,114 :: 		mldr1=mldr1/40
	MOVLW      40
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _mldr1+0, 0
	MOVWF      R0+0
	MOVF       _mldr1+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _mldr1+0
	MOVF       R0+1, 0
	MOVWF      _mldr1+1
;Adquisicion.mbas,115 :: 		mldr2=mldr2/40
	MOVLW      40
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _mldr2+0, 0
	MOVWF      R0+0
	MOVF       _mldr2+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _mldr2+0
	MOVF       R0+1, 0
	MOVWF      _mldr2+1
;Adquisicion.mbas,117 :: 		if (mldr1>prom)or (mldr2>prom) then
	MOVF       _mldr1+1, 0
	SUBWF      _prom+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main46
	MOVF       _mldr1+0, 0
	SUBWF      _prom+0, 0
L__main46:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R3+0
	MOVF       R0+1, 0
	SUBWF      _prom+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main47
	MOVF       R0+0, 0
	SUBWF      _prom+0, 0
L__main47:
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R2+0
	MOVF       R2+0, 0
	IORWF      R3+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L__main37
;Adquisicion.mbas,118 :: 		if (mldr1 > mldr2) then
	MOVF       _mldr1+1, 0
	SUBWF      _mldr2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVF       _mldr1+0, 0
	SUBWF      _mldr2+0, 0
L__main48:
	BTFSC      STATUS+0, 0
	GOTO       L__main40
;Adquisicion.mbas,119 :: 		portb.1=0
	BCF        PORTB+0, 1
;Adquisicion.mbas,120 :: 		PWM1_Set_Duty(Velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,121 :: 		portb.2=1
	BSF        PORTB+0, 2
;Adquisicion.mbas,122 :: 		PWM2_Set_Duty(Velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
	GOTO       L__main41
;Adquisicion.mbas,123 :: 		else
L__main40:
;Adquisicion.mbas,124 :: 		portb.1=1
	BSF        PORTB+0, 1
;Adquisicion.mbas,125 :: 		PWM1_Set_Duty(Velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,126 :: 		portb.2=0
	BCF        PORTB+0, 2
;Adquisicion.mbas,127 :: 		PWM2_Set_Duty(Velocidad)
	MOVF       _velocidad+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,128 :: 		end if
L__main41:
	GOTO       L__main38
;Adquisicion.mbas,129 :: 		else
L__main37:
;Adquisicion.mbas,130 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,131 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,132 :: 		end if
L__main38:
;Adquisicion.mbas,134 :: 		inc(cont)
	INCF       _cont+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cont+1, 1
;Adquisicion.mbas,135 :: 		if (cont > 200) then
	MOVF       _cont+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVF       _cont+0, 0
	SUBLW      200
L__main49:
	BTFSC      STATUS+0, 0
	GOTO       L__main43
;Adquisicion.mbas,136 :: 		UART1_Write_text("s")
	MOVLW      115
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,137 :: 		ByteToStr(mldr1, txt)
	MOVF       _mldr1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,138 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,139 :: 		UART1_Write_text("w")
	MOVLW      119
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,140 :: 		ByteToStr(mldr2, txt)
	MOVF       _mldr2+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,141 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,142 :: 		porta.1 = porta.1 xor 1
	MOVLW      2
	XORWF      PORTA+0, 1
;Adquisicion.mbas,143 :: 		cont =0
	CLRF       _cont+0
	CLRF       _cont+1
L__main43:
;Adquisicion.mbas,144 :: 		end if
	GOTO       L__main19
;Adquisicion.mbas,182 :: 		wend
	GOTO       $+0
; end of _main

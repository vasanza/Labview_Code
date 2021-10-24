
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
;Adquisicion.mbas,32 :: 		porta.2=1
	BSF        PORTA+0, 2
;Adquisicion.mbas,33 :: 		delay_ms(300)
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
;Adquisicion.mbas,34 :: 		porta.2=0
	BCF        PORTA+0, 2
;Adquisicion.mbas,35 :: 		delay_ms(300)
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
;Adquisicion.mbas,36 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,37 :: 		velocidad=receive
	MOVF       R0+0, 0
	MOVWF      _velocidad+0
L_Adquisicion_interrupt2:
;Adquisicion.mbas,55 :: 		end if
L_Adquisicion_interrupt19:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of Adquisicion_interrupt

_main:
;Adquisicion.mbas,59 :: 		main:
;Adquisicion.mbas,60 :: 		OPTION_REG=%10000000
	MOVLW      128
	MOVWF      OPTION_REG+0
;Adquisicion.mbas,61 :: 		INTCON = %11000000       ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      192
	MOVWF      INTCON+0
;Adquisicion.mbas,66 :: 		PIE1 = %00100000         ' enable Timer1 interrupt
	MOVLW      32
	MOVWF      PIE1+0
;Adquisicion.mbas,69 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;Adquisicion.mbas,70 :: 		ANSELH = %00001010           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      10
	MOVWF      ANSELH+0
;Adquisicion.mbas,73 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;Adquisicion.mbas,74 :: 		trisb  = %00011000           ' Configuracion IN/OUT PORTB
	MOVLW      24
	MOVWF      TRISB+0
;Adquisicion.mbas,75 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,78 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,79 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,82 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,84 :: 		PWM1_Init(1000)                    ' Initialize PWM1 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Adquisicion.mbas,85 :: 		PWM2_Init(1000)                    ' Initialize PWM2 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      249
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Adquisicion.mbas,87 :: 		PWM1_Start()                       ' start PWM1
	CALL       _PWM1_Start+0
;Adquisicion.mbas,88 :: 		PWM2_Start()                       ' start PWM2
	CALL       _PWM2_Start+0
;Adquisicion.mbas,89 :: 		PWM1_Set_Duty(0)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,90 :: 		PWM2_Set_Duty(0)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,92 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,93 :: 		automatico=0
	CLRF       _automatico+0
;Adquisicion.mbas,94 :: 		salto = 1
	MOVLW      1
	MOVWF      _salto+0
;Adquisicion.mbas,95 :: 		while true
L__main8:
;Adquisicion.mbas,96 :: 		n=0
	CLRF       _n+0
;Adquisicion.mbas,98 :: 		while (n<40)
L__main13:
	MOVLW      40
	SUBWF      _n+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main14
;Adquisicion.mbas,102 :: 		tempin = ADC_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempin+0
;Adquisicion.mbas,103 :: 		delay_us(5)
	NOP
	NOP
	NOP
	NOP
	NOP
;Adquisicion.mbas,104 :: 		tempout = ADC_Read(11)
	MOVLW      11
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempout+0
;Adquisicion.mbas,105 :: 		delay_us(5)
	NOP
	NOP
	NOP
	NOP
	NOP
;Adquisicion.mbas,106 :: 		mtempin=mtempin+tempin
	MOVF       _tempin+0, 0
	ADDWF      _mtempin+0, 1
	BTFSC      STATUS+0, 0
	INCF       _mtempin+1, 1
;Adquisicion.mbas,107 :: 		mtempout=mtempout+tempout
	MOVF       _tempout+0, 0
	ADDWF      _mtempout+0, 1
	BTFSC      STATUS+0, 0
	INCF       _mtempout+1, 1
;Adquisicion.mbas,108 :: 		n=n+1
	INCF       _n+0, 1
	GOTO       L__main13
L__main14:
;Adquisicion.mbas,111 :: 		mtempin=(mtempin/40)*100/230
	MOVLW      40
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _mtempin+0, 0
	MOVWF      R0+0
	MOVF       _mtempin+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      230
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _mtempin+0
	MOVF       R0+1, 0
	MOVWF      _mtempin+1
;Adquisicion.mbas,112 :: 		mtempout=(mtempout/40)*100/230
	MOVLW      40
	MOVWF      R4+0
	CLRF       R4+1
	MOVF       _mtempout+0, 0
	MOVWF      R0+0
	MOVF       _mtempout+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_U+0
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      230
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _mtempout+0
	MOVF       R0+1, 0
	MOVWF      _mtempout+1
;Adquisicion.mbas,119 :: 		portb.1=1
	BSF        PORTB+0, 1
;Adquisicion.mbas,120 :: 		PWM1_Set_Duty(Velocidad*28)
	MOVF       _velocidad+0, 0
	MOVWF      R0+0
	MOVLW      28
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,122 :: 		portb.2=1
	BSF        PORTB+0, 2
;Adquisicion.mbas,123 :: 		PWM2_Set_Duty(Velocidad*28)
	MOVF       _velocidad+0, 0
	MOVWF      R0+0
	MOVLW      28
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;Adquisicion.mbas,125 :: 		UART1_Write_text("i")
	MOVLW      105
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,126 :: 		ByteToStr(mtempin, txt)
	MOVF       _mtempin+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,127 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,128 :: 		UART1_Write_text("o")
	MOVLW      111
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,129 :: 		ByteToStr(mtempout, txt)
	MOVF       _mtempout+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,130 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,131 :: 		porta.1 = porta.1 xor 1
	MOVLW      2
	XORWF      PORTA+0, 1
	GOTO       L__main8
;Adquisicion.mbas,132 :: 		wend
	GOTO       $+0
; end of _main


Adquisicion_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;Adquisicion.mbas,31 :: 		sub procedure interrupt                   ' Interrupt service routine
;Adquisicion.mbas,35 :: 		if INTCON.INTF = 1 then            ' External interupt (RB0 pin) ?
	BTFSS      INTCON+0, 1
	GOTO       L_Adquisicion_interrupt2
;Adquisicion.mbas,36 :: 		count = count+1
	INCF       _count+0, 1
	BTFSC      STATUS+0, 2
	INCF       _count+1, 1
;Adquisicion.mbas,37 :: 		if inicio=1 then
	MOVF       _inicio+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Adquisicion_interrupt5
;Adquisicion.mbas,38 :: 		T1CON = $31
	MOVLW      49
	MOVWF      T1CON+0
;Adquisicion.mbas,39 :: 		inicio=0
	CLRF       _inicio+0
L_Adquisicion_interrupt5:
;Adquisicion.mbas,41 :: 		INTCON.INTF = 0
	BCF        INTCON+0, 1
L_Adquisicion_interrupt2:
;Adquisicion.mbas,43 :: 		if  PIR1.TMR1IF = 1 then
	BTFSS      PIR1+0, 0
	GOTO       L_Adquisicion_interrupt8
;Adquisicion.mbas,44 :: 		TMR1H = $0B
	MOVLW      11
	MOVWF      TMR1H+0
;Adquisicion.mbas,45 :: 		TMR1L = $DB
	MOVLW      219
	MOVWF      TMR1L+0
;Adquisicion.mbas,46 :: 		Frecuencia = count*2
	MOVF       _count+0, 0
	MOVWF      _Frecuencia+0
	MOVF       _count+1, 0
	MOVWF      _Frecuencia+1
	RLF        _Frecuencia+0, 1
	RLF        _Frecuencia+1, 1
	BCF        _Frecuencia+0, 0
;Adquisicion.mbas,47 :: 		count =0
	CLRF       _count+0
	CLRF       _count+1
;Adquisicion.mbas,48 :: 		flanco=1
	MOVLW      1
	MOVWF      _flanco+0
;Adquisicion.mbas,49 :: 		PIR1.TMR1IF = 0            ' clear TMR1IF
	BCF        PIR1+0, 0
L_Adquisicion_interrupt8:
;Adquisicion.mbas,51 :: 		end if
L_Adquisicion_interrupt27:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of Adquisicion_interrupt

_main:
;Adquisicion.mbas,55 :: 		main:
;Adquisicion.mbas,56 :: 		OPTION_REG=%11000000
	MOVLW      192
	MOVWF      OPTION_REG+0
;Adquisicion.mbas,57 :: 		INTCON = %11010000       ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      208
	MOVWF      INTCON+0
;Adquisicion.mbas,58 :: 		T1CON = $30
	MOVLW      48
	MOVWF      T1CON+0
;Adquisicion.mbas,59 :: 		PIR1.TMR1IF = 0            ' clear TMR1IF
	BCF        PIR1+0, 0
;Adquisicion.mbas,60 :: 		TMR1H = $0B                ' initialize Timer1 register
	MOVLW      11
	MOVWF      TMR1H+0
;Adquisicion.mbas,61 :: 		TMR1L = $DB
	MOVLW      219
	MOVWF      TMR1L+0
;Adquisicion.mbas,62 :: 		PIE1.TMR1IE  = 1         ' enable Timer1 interrupt
	BSF        PIE1+0, 0
;Adquisicion.mbas,65 :: 		ANSEL =  %00000001           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	MOVLW      1
	MOVWF      ANSEL+0
;Adquisicion.mbas,66 :: 		ANSELH = %00000000           'REGISTRO CONFIG. O DIGITAL, 1 ANALOGICO
	CLRF       ANSELH+0
;Adquisicion.mbas,69 :: 		trisa  = %00000001           ' Configuracion IN/OUT PORTA
	MOVLW      1
	MOVWF      TRISA+0
;Adquisicion.mbas,70 :: 		trisb  = %00000001           ' Configuracion IN/OUT PORTB
	MOVLW      1
	MOVWF      TRISB+0
;Adquisicion.mbas,71 :: 		trisc  = %10000000           ' Configuracion IN/OUT PORTC
	MOVLW      128
	MOVWF      TRISC+0
;Adquisicion.mbas,74 :: 		PORTA  = %00000000           ' Inicializacion PORTA
	CLRF       PORTA+0
;Adquisicion.mbas,75 :: 		PORTC  = %00000000           ' Inicializacion PORTC
	CLRF       PORTC+0
;Adquisicion.mbas,78 :: 		Uart1_Init(9600)                 ' Initialize USART module
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Adquisicion.mbas,80 :: 		PWM1_Init(5000)                    ' Initialize PWM1 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;Adquisicion.mbas,81 :: 		PWM2_Init(5000)                    ' Initialize PWM2 module at 5KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;Adquisicion.mbas,83 :: 		PWM1_Start()                       ' start PWM1
	CALL       _PWM1_Start+0
;Adquisicion.mbas,84 :: 		PWM2_Start()                       ' start PWM2
	CALL       _PWM2_Start+0
;Adquisicion.mbas,85 :: 		inicio=1
	MOVLW      1
	MOVWF      _inicio+0
;Adquisicion.mbas,86 :: 		modo=2 ''modo manual
	MOVLW      2
	MOVWF      _modo+0
;Adquisicion.mbas,88 :: 		while true
L__main12:
;Adquisicion.mbas,89 :: 		if (UART1_Data_Ready() = 1) then
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main17
;Adquisicion.mbas,90 :: 		receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _receive+0
;Adquisicion.mbas,95 :: 		if receive= 109 then '' m - me envian modo manual
	MOVF       R0+0, 0
	XORLW      109
	BTFSS      STATUS+0, 2
	GOTO       L__main20
;Adquisicion.mbas,96 :: 		analogico = Adc_Read(0)>>2
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _analogico+0
	MOVF       R0+1, 0
	MOVWF      _analogico+1
	RRF        _analogico+1, 1
	RRF        _analogico+0, 1
	BCF        _analogico+1, 7
	RRF        _analogico+1, 1
	RRF        _analogico+0, 1
	BCF        _analogico+1, 7
;Adquisicion.mbas,97 :: 		delay_ms(5)
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L__main22:
	DECFSZ     R13+0, 1
	GOTO       L__main22
	DECFSZ     R12+0, 1
	GOTO       L__main22
;Adquisicion.mbas,98 :: 		Velocidad=analogico
	MOVF       _analogico+0, 0
	MOVWF      _Velocidad+0
	GOTO       L__main21
;Adquisicion.mbas,100 :: 		else
L__main20:
;Adquisicion.mbas,101 :: 		Velocidad=(receive - 48)*28.33
	MOVLW      48
	SUBWF      _receive+0, 0
	MOVWF      R0+0
	CALL       _Byte2Double+0
	MOVLW      215
	MOVWF      R4+0
	MOVLW      163
	MOVWF      R4+1
	MOVLW      98
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _Double2Byte+0
	MOVF       R0+0, 0
	MOVWF      _Velocidad+0
;Adquisicion.mbas,102 :: 		end if
L__main21:
L__main17:
;Adquisicion.mbas,114 :: 		if Velocidad >=250 then
	MOVLW      250
	SUBWF      _Velocidad+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main24
;Adquisicion.mbas,115 :: 		PWM1_Stop()
	CALL       _PWM1_Stop+0
	GOTO       L__main25
;Adquisicion.mbas,116 :: 		else
L__main24:
;Adquisicion.mbas,117 :: 		PWM1_Start()
	CALL       _PWM1_Start+0
;Adquisicion.mbas,118 :: 		end if
L__main25:
;Adquisicion.mbas,119 :: 		PWM1_Set_Duty(Velocidad)
	MOVF       _Velocidad+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;Adquisicion.mbas,120 :: 		PORTA=255-Velocidad
	MOVF       _Velocidad+0, 0
	SUBLW      255
	MOVWF      PORTA+0
;Adquisicion.mbas,121 :: 		ByteToStr(Frecuencia,tx_f)
	MOVF       _Frecuencia+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _tx_f+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,122 :: 		ByteToStr(255-Velocidad,tx_v)
	MOVF       _Velocidad+0, 0
	SUBLW      255
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _tx_v+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;Adquisicion.mbas,123 :: 		UART1_Write(116)''t
	MOVLW      116
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Adquisicion.mbas,124 :: 		UART1_Write_Text(tx_v)
	MOVLW      _tx_v+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,125 :: 		UART1_Write(102)''f
	MOVLW      102
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Adquisicion.mbas,126 :: 		UART1_Write_Text(tx_f)
	MOVLW      _tx_f+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;Adquisicion.mbas,127 :: 		UART1_Write(10)
	MOVLW      10
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Adquisicion.mbas,128 :: 		UART1_Write(13)
	MOVLW      13
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Adquisicion.mbas,129 :: 		delay_ms(50)
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L__main26:
	DECFSZ     R13+0, 1
	GOTO       L__main26
	DECFSZ     R12+0, 1
	GOTO       L__main26
	NOP
	GOTO       L__main12
;Adquisicion.mbas,132 :: 		wend
	GOTO       $+0
; end of _main

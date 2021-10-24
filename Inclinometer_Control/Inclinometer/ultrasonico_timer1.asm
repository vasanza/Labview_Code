
ultrasonico_timer1_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;ultrasonico_timer1.mbas,52 :: 		sub procedure interrupt
;ultrasonico_timer1.mbas,54 :: 		if TestBit(PIR1,TMR1IF)=1 then
	CLRF       R1+0
	BTFSS      PIR1+0, 0
	GOTO       L_ultrasonico_timer1_interrupt4
	MOVLW      1
	MOVWF      R1+0
L_ultrasonico_timer1_interrupt4:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt2
;ultrasonico_timer1.mbas,55 :: 		if Paso=0 then
	MOVF       _Paso+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt6
;ultrasonico_timer1.mbas,56 :: 		MaskPort= (salidas and n_servo)
	MOVF       _n_servo+0, 0
	ANDWF      _Salidas+0, 0
	MOVWF      _MaskPort+0
	MOVF       _Salidas+1, 0
	ANDWF      _n_servo+1, 0
	MOVWF      _MaskPort+1
;ultrasonico_timer1.mbas,57 :: 		PORTB.5 = MaskPort.0
	BTFSC      _MaskPort+0, 0
	GOTO       L_ultrasonico_timer1_interrupt47
	BCF        PORTB+0, 5
	GOTO       L_ultrasonico_timer1_interrupt48
L_ultrasonico_timer1_interrupt47:
	BSF        PORTB+0, 5
L_ultrasonico_timer1_interrupt48:
;ultrasonico_timer1.mbas,58 :: 		PORTB.0 = MaskPort.1
	BTFSC      _MaskPort+0, 1
	GOTO       L_ultrasonico_timer1_interrupt49
	BCF        PORTB+0, 0
	GOTO       L_ultrasonico_timer1_interrupt50
L_ultrasonico_timer1_interrupt49:
	BSF        PORTB+0, 0
L_ultrasonico_timer1_interrupt50:
;ultrasonico_timer1.mbas,59 :: 		Paso=1
	MOVLW      1
	MOVWF      _Paso+0
;ultrasonico_timer1.mbas,63 :: 		TMR1L=0x1F
	MOVLW      31
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,64 :: 		TMR1H=0XFF
	MOVLW      255
	MOVWF      TMR1H+0
	GOTO       L_ultrasonico_timer1_interrupt7
;ultrasonico_timer1.mbas,66 :: 		else    '65086 1.8ms
L_ultrasonico_timer1_interrupt6:
;ultrasonico_timer1.mbas,68 :: 		if Paso=1 then
	MOVF       _Paso+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt9
;ultrasonico_timer1.mbas,70 :: 		temp_var= 65276 + Servo[index]
	MOVF       _Index+0, 0
	ADDLW      _Servo+0
	MOVWF      4
	MOVF       INDF+0, 0
	ADDLW      252
	MOVWF      _temp_var+0
	MOVLW      254
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _temp_var+1
;ultrasonico_timer1.mbas,71 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,72 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,73 :: 		Paso=2
	MOVLW      2
	MOVWF      _Paso+0
	GOTO       L_ultrasonico_timer1_interrupt10
;ultrasonico_timer1.mbas,74 :: 		else
L_ultrasonico_timer1_interrupt9:
;ultrasonico_timer1.mbas,75 :: 		PORTB.5=0
	BCF        PORTB+0, 5
;ultrasonico_timer1.mbas,76 :: 		PORTB.0=0
	BCF        PORTB+0, 0
;ultrasonico_timer1.mbas,78 :: 		temp_var= 65530 - Servo[index]
	MOVF       _Index+0, 0
	ADDLW      _Servo+0
	MOVWF      4
	MOVF       INDF+0, 0
	SUBLW      250
	MOVWF      _temp_var+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      255
	MOVWF      _temp_var+1
;ultrasonico_timer1.mbas,79 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,80 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,81 :: 		inc(index)
	INCF       _Index+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Index+1, 1
;ultrasonico_timer1.mbas,82 :: 		n_servo=n_servo<<1
	MOVF       _n_servo+0, 0
	MOVWF      R1+0
	MOVF       _n_servo+1, 0
	MOVWF      R1+1
	RLF        R1+0, 1
	RLF        R1+1, 1
	BCF        R1+0, 0
	MOVF       R1+0, 0
	MOVWF      _n_servo+0
	MOVF       R1+1, 0
	MOVWF      _n_servo+1
;ultrasonico_timer1.mbas,83 :: 		if n_servo=0x0400 then
	MOVF       R1+1, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt51
	MOVLW      0
	XORWF      R1+0, 0
L_ultrasonico_timer1_interrupt51:
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt12
;ultrasonico_timer1.mbas,84 :: 		n_servo=1
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;ultrasonico_timer1.mbas,85 :: 		Index=0
	CLRF       _Index+0
	CLRF       _Index+1
L_ultrasonico_timer1_interrupt12:
;ultrasonico_timer1.mbas,87 :: 		paso=0
	CLRF       _Paso+0
;ultrasonico_timer1.mbas,88 :: 		end if
L_ultrasonico_timer1_interrupt10:
;ultrasonico_timer1.mbas,89 :: 		end if
L_ultrasonico_timer1_interrupt7:
;ultrasonico_timer1.mbas,90 :: 		ClearBit(PIR1,TMR1IF)
	BCF        PIR1+0, 0
L_ultrasonico_timer1_interrupt2:
;ultrasonico_timer1.mbas,93 :: 		if( PIR1.RCIF = 1 )then
	BTFSS      PIR1+0, 5
	GOTO       L_ultrasonico_timer1_interrupt15
;ultrasonico_timer1.mbas,94 :: 		usart_receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _usart_receive+0
;ultrasonico_timer1.mbas,96 :: 		case 1
	MOVF       _viajero_uart+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt20
;ultrasonico_timer1.mbas,97 :: 		if 0xb7 = usart_receive then
	MOVLW      183
	XORWF      _usart_receive+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt22
;ultrasonico_timer1.mbas,98 :: 		viajero_uart = 2
	MOVLW      2
	MOVWF      _viajero_uart+0
	GOTO       L_ultrasonico_timer1_interrupt23
;ultrasonico_timer1.mbas,100 :: 		else
L_ultrasonico_timer1_interrupt22:
;ultrasonico_timer1.mbas,101 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;ultrasonico_timer1.mbas,102 :: 		end if
L_ultrasonico_timer1_interrupt23:
	GOTO       L_ultrasonico_timer1_interrupt17
L_ultrasonico_timer1_interrupt20:
;ultrasonico_timer1.mbas,103 :: 		case 2
	MOVF       _viajero_uart+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt26
;ultrasonico_timer1.mbas,104 :: 		Servo[0] = usart_receive
	MOVF       _usart_receive+0, 0
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,105 :: 		viajero_uart = 3
	MOVLW      3
	MOVWF      _viajero_uart+0
	GOTO       L_ultrasonico_timer1_interrupt17
L_ultrasonico_timer1_interrupt26:
;ultrasonico_timer1.mbas,106 :: 		case 3
	MOVF       _viajero_uart+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt29
;ultrasonico_timer1.mbas,107 :: 		Servo[1] = usart_receive
	MOVF       _usart_receive+0, 0
	MOVWF      _Servo+1
;ultrasonico_timer1.mbas,108 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
	GOTO       L_ultrasonico_timer1_interrupt17
L_ultrasonico_timer1_interrupt29:
L_ultrasonico_timer1_interrupt17:
;ultrasonico_timer1.mbas,110 :: 		ClearBit(PIR1,RCIF)   ' Si el dato a llegado limpio la bandera de recepcion
	BCF        PIR1+0, 5
;ultrasonico_timer1.mbas,111 :: 		SetBit(PIE1,RCIE)     ' Habilitar nuevamente la interrupcion por USART
	BSF        PIE1+0, 5
L_ultrasonico_timer1_interrupt15:
;ultrasonico_timer1.mbas,112 :: 		end if
L_ultrasonico_timer1_interrupt46:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of ultrasonico_timer1_interrupt

ultrasonico_timer1_led:
;ultrasonico_timer1.mbas,115 :: 		sub procedure led
;ultrasonico_timer1.mbas,116 :: 		porta = 0x00
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,117 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led31:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led31
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led31
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led31
	NOP
	NOP
;ultrasonico_timer1.mbas,118 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,119 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led32:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led32
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led32
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led32
	NOP
	NOP
;ultrasonico_timer1.mbas,120 :: 		porta = 0x00
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,121 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led33:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led33
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led33
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led33
	NOP
	NOP
;ultrasonico_timer1.mbas,122 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,123 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led34:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led34
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led34
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led34
	NOP
	NOP
;ultrasonico_timer1.mbas,124 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of ultrasonico_timer1_led

_main:
;ultrasonico_timer1.mbas,127 :: 		main:
;ultrasonico_timer1.mbas,128 :: 		OSCCON = %01110101
	MOVLW      117
	MOVWF      OSCCON+0
;ultrasonico_timer1.mbas,129 :: 		OPTION_REG=%01000101
	MOVLW      69
	MOVWF      OPTION_REG+0
;ultrasonico_timer1.mbas,130 :: 		INTCON = %11000000
	MOVLW      192
	MOVWF      INTCON+0
;ultrasonico_timer1.mbas,131 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;ultrasonico_timer1.mbas,133 :: 		TRISA= %00000001
	MOVLW      1
	MOVWF      TRISA+0
;ultrasonico_timer1.mbas,134 :: 		TRISB= %00011000
	MOVLW      24
	MOVWF      TRISB+0
;ultrasonico_timer1.mbas,135 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;ultrasonico_timer1.mbas,137 :: 		ANSEL= %00000001
	MOVLW      1
	MOVWF      ANSEL+0
;ultrasonico_timer1.mbas,138 :: 		ANSELH= %00001010
	MOVLW      10
	MOVWF      ANSELH+0
;ultrasonico_timer1.mbas,141 :: 		Servo[0] = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,142 :: 		Servo[1] = 0x80
	MOVLW      128
	MOVWF      _Servo+1
;ultrasonico_timer1.mbas,143 :: 		T1CON = %00110001
	MOVLW      49
	MOVWF      T1CON+0
;ultrasonico_timer1.mbas,144 :: 		PIE1 = PIE1 OR %00000001
	BSF        PIE1+0, 0
;ultrasonico_timer1.mbas,145 :: 		TMR1L = 0xFF
	MOVLW      255
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,146 :: 		TMR1H = 0xFF
	MOVLW      255
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,147 :: 		paso = 0
	CLRF       _Paso+0
;ultrasonico_timer1.mbas,148 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;ultrasonico_timer1.mbas,149 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;ultrasonico_timer1.mbas,154 :: 		PIE1 = PIE1 or %00100000
	BSF        PIE1+0, 5
;ultrasonico_timer1.mbas,155 :: 		PIR1 = %00000000
	CLRF       PIR1+0
;ultrasonico_timer1.mbas,156 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;ultrasonico_timer1.mbas,159 :: 		PORTA= %00000000
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,160 :: 		PORTB= %00000000
	CLRF       PORTB+0
;ultrasonico_timer1.mbas,161 :: 		PORTC= %00000000
	CLRF       PORTC+0
;ultrasonico_timer1.mbas,163 :: 		TMR0 = 0X00
	CLRF       TMR0+0
;ultrasonico_timer1.mbas,164 :: 		intensidad=5
	MOVLW      5
	MOVWF      _intensidad+0
;ultrasonico_timer1.mbas,165 :: 		muestras=0
	CLRF       _muestras+0
;ultrasonico_timer1.mbas,166 :: 		temp_ac=0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;ultrasonico_timer1.mbas,167 :: 		temp_prom=0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;ultrasonico_timer1.mbas,168 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;ultrasonico_timer1.mbas,170 :: 		led()
	CALL       ultrasonico_timer1_led+0
;ultrasonico_timer1.mbas,172 :: 		while true
L__main37:
;ultrasonico_timer1.mbas,173 :: 		temp_ac = 0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;ultrasonico_timer1.mbas,174 :: 		temp_prom = 0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;ultrasonico_timer1.mbas,175 :: 		temperatura_2 = 0
	CLRF       _temperatura_2+0
	CLRF       _temperatura_2+1
;ultrasonico_timer1.mbas,176 :: 		temperatura_3 = 0
	CLRF       _temperatura_3+0
	CLRF       _temperatura_3+1
;ultrasonico_timer1.mbas,177 :: 		for muestras=1 to 64
	MOVLW      1
	MOVWF      _muestras+0
L__main41:
	MOVF       _muestras+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L__main44
;ultrasonico_timer1.mbas,178 :: 		analogico = Adc_Read(11)
	MOVLW      11
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _analogico+0
	MOVF       R0+1, 0
	MOVWF      _analogico+1
;ultrasonico_timer1.mbas,179 :: 		temperatura_1 = Adc_Read(9)
	MOVLW      9
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _temperatura_1+0
	MOVF       R0+1, 0
	MOVWF      _temperatura_1+1
;ultrasonico_timer1.mbas,180 :: 		temperatura_2 = temperatura_2 + temperatura_1
	MOVF       R0+0, 0
	ADDWF      _temperatura_2+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temperatura_2+1, 1
;ultrasonico_timer1.mbas,181 :: 		temp_ac = temp_ac + analogico
	MOVF       _analogico+0, 0
	ADDWF      _temp_ac+0, 1
	MOVF       _analogico+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_ac+1, 1
;ultrasonico_timer1.mbas,182 :: 		next muestras
	MOVF       _muestras+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__main44
	INCF       _muestras+0, 1
	GOTO       L__main41
L__main44:
;ultrasonico_timer1.mbas,183 :: 		temperatura_3 = (temperatura_2/64)
	MOVLW      6
	MOVWF      R0+0
	MOVF       _temperatura_2+0, 0
	MOVWF      R4+0
	MOVF       _temperatura_2+1, 0
	MOVWF      R4+1
	MOVF       R0+0, 0
L__main52:
	BTFSC      STATUS+0, 2
	GOTO       L__main53
	RRF        R4+1, 1
	RRF        R4+0, 1
	BCF        R4+1, 7
	ADDLW      255
	GOTO       L__main52
L__main53:
	MOVF       R4+0, 0
	MOVWF      _temperatura_3+0
	MOVF       R4+1, 0
	MOVWF      _temperatura_3+1
;ultrasonico_timer1.mbas,184 :: 		temp_prom = (temp_ac/64)
	MOVLW      6
	MOVWF      R0+0
	MOVF       _temp_ac+0, 0
	MOVWF      _temp_prom+0
	MOVF       _temp_ac+1, 0
	MOVWF      _temp_prom+1
	MOVF       R0+0, 0
L__main54:
	BTFSC      STATUS+0, 2
	GOTO       L__main55
	RRF        _temp_prom+1, 1
	RRF        _temp_prom+0, 1
	BCF        _temp_prom+1, 7
	ADDLW      255
	GOTO       L__main54
L__main55:
;ultrasonico_timer1.mbas,185 :: 		temperatura_3 = (temperatura_3)/2.3
	MOVF       R4+0, 0
	MOVWF      R0+0
	MOVF       R4+1, 0
	MOVWF      R0+1
	CALL       _Word2Double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      51
	MOVWF      R4+1
	MOVLW      19
	MOVWF      R4+2
	MOVLW      128
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _Double2Word+0
	MOVF       R0+0, 0
	MOVWF      _temperatura_3+0
	MOVF       R0+1, 0
	MOVWF      _temperatura_3+1
;ultrasonico_timer1.mbas,187 :: 		UART1_Write_text("p")
	MOVLW      112
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ultrasonico_timer1.mbas,188 :: 		WordToStr(temp_prom>>2,txt)
	MOVF       _temp_prom+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       _temp_prom+1, 0
	MOVWF      FARG_WordToStr_input+1
	RRF        FARG_WordToStr_input+1, 1
	RRF        FARG_WordToStr_input+0, 1
	BCF        FARG_WordToStr_input+1, 7
	RRF        FARG_WordToStr_input+1, 1
	RRF        FARG_WordToStr_input+0, 1
	BCF        FARG_WordToStr_input+1, 7
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;ultrasonico_timer1.mbas,189 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ultrasonico_timer1.mbas,191 :: 		UART1_Write_text("t")
	MOVLW      116
	MOVWF      _main_Local_Text+0
	CLRF       _main_Local_Text+1
	MOVLW      _main_Local_Text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ultrasonico_timer1.mbas,192 :: 		WordToStr(temperatura_3,txt)
	MOVF       _temperatura_3+0, 0
	MOVWF      FARG_WordToStr_input+0
	MOVF       _temperatura_3+1, 0
	MOVWF      FARG_WordToStr_input+1
	MOVLW      _txt+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;ultrasonico_timer1.mbas,193 :: 		UART1_Write_text(txt)
	MOVLW      _txt+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;ultrasonico_timer1.mbas,194 :: 		Delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main45:
	DECFSZ     R13+0, 1
	GOTO       L__main45
	DECFSZ     R12+0, 1
	GOTO       L__main45
	DECFSZ     R11+0, 1
	GOTO       L__main45
	GOTO       L__main37
;ultrasonico_timer1.mbas,195 :: 		wend
	GOTO       $+0
; end of _main

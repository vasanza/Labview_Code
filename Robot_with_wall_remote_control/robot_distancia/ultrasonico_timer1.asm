
ultrasonico_timer1_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ultrasonico_timer1.mbas,34 :: 		sub procedure interrupt
;ultrasonico_timer1.mbas,36 :: 		if TestBit(PIR1,TMR1IF)=1 then
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
;ultrasonico_timer1.mbas,37 :: 		if Paso=0 then
	MOVF       _Paso+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt6
;ultrasonico_timer1.mbas,38 :: 		MaskPort= (salidas and n_servo)
	MOVF       _n_servo+0, 0
	ANDWF      _Salidas+0, 0
	MOVWF      _MaskPort+0
	MOVF       _Salidas+1, 0
	ANDWF      _n_servo+1, 0
	MOVWF      _MaskPort+1
;ultrasonico_timer1.mbas,39 :: 		PORTB.4 = MaskPort.0
	BTFSC      _MaskPort+0, 0
	GOTO       L_ultrasonico_timer1_interrupt84
	BCF        PORTB+0, 4
	GOTO       L_ultrasonico_timer1_interrupt85
L_ultrasonico_timer1_interrupt84:
	BSF        PORTB+0, 4
L_ultrasonico_timer1_interrupt85:
;ultrasonico_timer1.mbas,41 :: 		Paso=1
	MOVLW      1
	MOVWF      _Paso+0
;ultrasonico_timer1.mbas,42 :: 		TMR1L=0x6A
	MOVLW      106
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,43 :: 		TMR1H=0XFF
	MOVLW      255
	MOVWF      TMR1H+0
	GOTO       L_ultrasonico_timer1_interrupt7
;ultrasonico_timer1.mbas,44 :: 		else    '65086 1.8ms
L_ultrasonico_timer1_interrupt6:
;ultrasonico_timer1.mbas,46 :: 		if Paso=1 then  '65276
	MOVF       _Paso+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt9
;ultrasonico_timer1.mbas,47 :: 		temp_var= 65148 + Servo + (Servo/2)
	MOVF       _Servo+0, 0
	ADDLW      124
	MOVWF      _temp_var+0
	MOVLW      254
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _temp_var+1
	MOVF       _Servo+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	ADDWF      _temp_var+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_var+1, 1
;ultrasonico_timer1.mbas,48 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,49 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,50 :: 		Paso=2
	MOVLW      2
	MOVWF      _Paso+0
	GOTO       L_ultrasonico_timer1_interrupt10
;ultrasonico_timer1.mbas,51 :: 		else
L_ultrasonico_timer1_interrupt9:
;ultrasonico_timer1.mbas,52 :: 		PORTB.4=0     '65276
	BCF        PORTB+0, 4
;ultrasonico_timer1.mbas,53 :: 		temp_var= 65530 - Servo - (Servo/2)
	MOVF       _Servo+0, 0
	SUBLW      250
	MOVWF      _temp_var+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      255
	MOVWF      _temp_var+1
	MOVF       _Servo+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	SUBWF      _temp_var+0, 1
	BTFSS      STATUS+0, 0
	DECF       _temp_var+1, 1
	MOVF       R0+1, 0
	SUBWF      _temp_var+1, 1
;ultrasonico_timer1.mbas,54 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,55 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,56 :: 		n_servo=n_servo<<1
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
;ultrasonico_timer1.mbas,57 :: 		if n_servo=0x0200 then
	MOVF       R1+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt86
	MOVLW      0
	XORWF      R1+0, 0
L_ultrasonico_timer1_interrupt86:
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt12
;ultrasonico_timer1.mbas,58 :: 		n_servo=1
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
L_ultrasonico_timer1_interrupt12:
;ultrasonico_timer1.mbas,60 :: 		paso=0
	CLRF       _Paso+0
;ultrasonico_timer1.mbas,61 :: 		end if
L_ultrasonico_timer1_interrupt10:
;ultrasonico_timer1.mbas,62 :: 		end if
L_ultrasonico_timer1_interrupt7:
;ultrasonico_timer1.mbas,63 :: 		ClearBit(PIR1,TMR1IF)
	BCF        PIR1+0, 0
L_ultrasonico_timer1_interrupt2:
;ultrasonico_timer1.mbas,69 :: 		if TestBit(PIR1,RCIF) = 1 then
	CLRF       R1+0
	BTFSS      PIR1+0, 5
	GOTO       L_ultrasonico_timer1_interrupt17
	MOVLW      1
	MOVWF      R1+0
L_ultrasonico_timer1_interrupt17:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt15
;ultrasonico_timer1.mbas,70 :: 		received_byte = Uart1_Read
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _received_byte+0
;ultrasonico_timer1.mbas,72 :: 		case 1
	MOVF       _viajero_usart+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt21
;ultrasonico_timer1.mbas,73 :: 		if 0xB7 = received_byte then
	MOVLW      183
	XORWF      _received_byte+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt23
;ultrasonico_timer1.mbas,74 :: 		viajero_usart = 2
	MOVLW      2
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt24
;ultrasonico_timer1.mbas,75 :: 		else
L_ultrasonico_timer1_interrupt23:
;ultrasonico_timer1.mbas,76 :: 		viajero_usart = 1
	MOVLW      1
	MOVWF      _viajero_usart+0
;ultrasonico_timer1.mbas,77 :: 		termino=0
	CLRF       _termino+0
;ultrasonico_timer1.mbas,78 :: 		end if
L_ultrasonico_timer1_interrupt24:
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt21:
;ultrasonico_timer1.mbas,79 :: 		case 2
	MOVF       _viajero_usart+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt27
;ultrasonico_timer1.mbas,80 :: 		angulo= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _angulo+0
;ultrasonico_timer1.mbas,81 :: 		viajero_usart= 3
	MOVLW      3
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt27:
;ultrasonico_timer1.mbas,82 :: 		case 3
	MOVF       _viajero_usart+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt30
;ultrasonico_timer1.mbas,83 :: 		velocidad_1= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _velocidad_1+0
;ultrasonico_timer1.mbas,84 :: 		viajero_usart= 4
	MOVLW      4
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt30:
;ultrasonico_timer1.mbas,85 :: 		case 4
	MOVF       _viajero_usart+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt33
;ultrasonico_timer1.mbas,86 :: 		direccion_1= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _direccion_1+0
;ultrasonico_timer1.mbas,87 :: 		viajero_usart= 5
	MOVLW      5
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt33:
;ultrasonico_timer1.mbas,88 :: 		case 5
	MOVF       _viajero_usart+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt36
;ultrasonico_timer1.mbas,89 :: 		velocidad_2= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _velocidad_2+0
;ultrasonico_timer1.mbas,90 :: 		viajero_usart= 6
	MOVLW      6
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt36:
;ultrasonico_timer1.mbas,91 :: 		case 6
	MOVF       _viajero_usart+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt39
;ultrasonico_timer1.mbas,92 :: 		direccion_2= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _direccion_2+0
;ultrasonico_timer1.mbas,93 :: 		termino = 1
	MOVLW      1
	MOVWF      _termino+0
;ultrasonico_timer1.mbas,94 :: 		viajero_usart= 1
	MOVLW      1
	MOVWF      _viajero_usart+0
	GOTO       L_ultrasonico_timer1_interrupt18
L_ultrasonico_timer1_interrupt39:
L_ultrasonico_timer1_interrupt18:
;ultrasonico_timer1.mbas,96 :: 		ClearBit(PIR1,RCIF)
	BCF        PIR1+0, 5
L_ultrasonico_timer1_interrupt15:
;ultrasonico_timer1.mbas,99 :: 		if INTCON.INTF = 1 then            ' External interupt (RB0 pin)
	BTFSS      INTCON+0, 1
	GOTO       L_ultrasonico_timer1_interrupt41
;ultrasonico_timer1.mbas,100 :: 		if flanco=1 then
	MOVF       _flanco+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_interrupt44
;ultrasonico_timer1.mbas,101 :: 		TMR0 = 0x00
	CLRF       TMR0+0
;ultrasonico_timer1.mbas,102 :: 		OPTION_REG.INTEDG=0
	BCF        OPTION_REG+0, 6
;ultrasonico_timer1.mbas,103 :: 		flanco = 0
	CLRF       _flanco+0
	GOTO       L_ultrasonico_timer1_interrupt45
;ultrasonico_timer1.mbas,104 :: 		else
L_ultrasonico_timer1_interrupt44:
;ultrasonico_timer1.mbas,105 :: 		OPTION_REG.INTEDG=1
	BSF        OPTION_REG+0, 6
;ultrasonico_timer1.mbas,106 :: 		Tiempo = TMR0
	MOVF       TMR0+0, 0
	MOVWF      _Tiempo+0
	CLRF       _Tiempo+1
;ultrasonico_timer1.mbas,107 :: 		TMR0 = 0x00
	CLRF       TMR0+0
;ultrasonico_timer1.mbas,108 :: 		flanco=1
	MOVLW      1
	MOVWF      _flanco+0
;ultrasonico_timer1.mbas,109 :: 		end if
L_ultrasonico_timer1_interrupt45:
;ultrasonico_timer1.mbas,110 :: 		Clearbit(INTCON,INTF)
	BCF        INTCON+0, 1
L_ultrasonico_timer1_interrupt41:
;ultrasonico_timer1.mbas,111 :: 		end if
L_ultrasonico_timer1_interrupt83:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of ultrasonico_timer1_interrupt

ultrasonico_timer1_srf05_pulso:

;ultrasonico_timer1.mbas,114 :: 		sub procedure srf05_pulso
;ultrasonico_timer1.mbas,115 :: 		portc.5=1
	BSF        PORTC+0, 5
;ultrasonico_timer1.mbas,116 :: 		delay_us(50)
	MOVLW      33
	MOVWF      R13+0
L_ultrasonico_timer1_srf05_pulso47:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_srf05_pulso47
;ultrasonico_timer1.mbas,117 :: 		portc.5=0
	BCF        PORTC+0, 5
;ultrasonico_timer1.mbas,118 :: 		delay_ms(40)
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_ultrasonico_timer1_srf05_pulso48:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_srf05_pulso48
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_srf05_pulso48
	NOP
;ultrasonico_timer1.mbas,119 :: 		distancia = Tiempo*128
	MOVLW      7
	MOVWF      R2+0
	MOVF       _Tiempo+0, 0
	MOVWF      R0+0
	MOVF       _Tiempo+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L_ultrasonico_timer1_srf05_pulso87:
	BTFSC      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_srf05_pulso88
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L_ultrasonico_timer1_srf05_pulso87
L_ultrasonico_timer1_srf05_pulso88:
	MOVF       R0+0, 0
	MOVWF      _distancia+0
	MOVF       R0+1, 0
	MOVWF      _distancia+1
;ultrasonico_timer1.mbas,120 :: 		distancia = distancia/116
	MOVLW      116
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _distancia+0
	MOVF       R0+1, 0
	MOVWF      _distancia+1
	RETURN
; end of ultrasonico_timer1_srf05_pulso

ultrasonico_timer1_led:

;ultrasonico_timer1.mbas,123 :: 		sub procedure led
;ultrasonico_timer1.mbas,124 :: 		porta = 0x00
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,125 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led50:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led50
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led50
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led50
	NOP
	NOP
;ultrasonico_timer1.mbas,126 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,127 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led51:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led51
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led51
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led51
	NOP
	NOP
;ultrasonico_timer1.mbas,128 :: 		porta = 0x00
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,129 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led52:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led52
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led52
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led52
	NOP
	NOP
;ultrasonico_timer1.mbas,130 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,131 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_ultrasonico_timer1_led53:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_led53
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_led53
	DECFSZ     R11+0, 1
	GOTO       L_ultrasonico_timer1_led53
	NOP
	NOP
;ultrasonico_timer1.mbas,132 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of ultrasonico_timer1_led

ultrasonico_timer1_rotar_servo:

;ultrasonico_timer1.mbas,135 :: 		sub procedure rotar_servo
;ultrasonico_timer1.mbas,136 :: 		for i=1 to 255
	MOVLW      1
	MOVWF      _i+0
L_ultrasonico_timer1_rotar_servo56:
;ultrasonico_timer1.mbas,137 :: 		Servo = i
	MOVF       _i+0, 0
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,138 :: 		srf05_pulso
	CALL       ultrasonico_timer1_srf05_pulso+0
;ultrasonico_timer1.mbas,139 :: 		if distancia < distancia_v then
	MOVF       _distancia_v+1, 0
	SUBWF      _distancia+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_rotar_servo89
	MOVF       _distancia_v+0, 0
	SUBWF      _distancia+0, 0
L_ultrasonico_timer1_rotar_servo89:
	BTFSC      STATUS+0, 0
	GOTO       L_ultrasonico_timer1_rotar_servo61
;ultrasonico_timer1.mbas,140 :: 		PWM1_Set_Duty(0x00)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;ultrasonico_timer1.mbas,141 :: 		PWM2_Set_Duty(0x00)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;ultrasonico_timer1.mbas,142 :: 		porta = 0x0f
	MOVLW      15
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,143 :: 		delay_ms(1)
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_ultrasonico_timer1_rotar_servo63:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo63
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo63
	NOP
	NOP
L_ultrasonico_timer1_rotar_servo61:
;ultrasonico_timer1.mbas,145 :: 		porta = 0xf0
	MOVLW      240
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,146 :: 		next i
	MOVF       _i+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_rotar_servo59
	INCF       _i+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo56
L_ultrasonico_timer1_rotar_servo59:
;ultrasonico_timer1.mbas,148 :: 		for i=1 to 255
	MOVLW      1
	MOVWF      _i+0
L_ultrasonico_timer1_rotar_servo65:
;ultrasonico_timer1.mbas,149 :: 		Servo = 255-i
	MOVF       _i+0, 0
	SUBLW      255
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,150 :: 		srf05_pulso
	CALL       ultrasonico_timer1_srf05_pulso+0
;ultrasonico_timer1.mbas,151 :: 		if distancia < distancia_v then
	MOVF       _distancia_v+1, 0
	SUBWF      _distancia+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_rotar_servo90
	MOVF       _distancia_v+0, 0
	SUBWF      _distancia+0, 0
L_ultrasonico_timer1_rotar_servo90:
	BTFSC      STATUS+0, 0
	GOTO       L_ultrasonico_timer1_rotar_servo70
;ultrasonico_timer1.mbas,152 :: 		PWM1_Set_Duty(0x00)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;ultrasonico_timer1.mbas,153 :: 		PWM2_Set_Duty(0x00)
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;ultrasonico_timer1.mbas,154 :: 		porta = 0x0f
	MOVLW      15
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,155 :: 		delay_ms(1)
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_ultrasonico_timer1_rotar_servo72:
	DECFSZ     R13+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo72
	DECFSZ     R12+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo72
	NOP
	NOP
L_ultrasonico_timer1_rotar_servo70:
;ultrasonico_timer1.mbas,157 :: 		porta = 0xf0
	MOVLW      240
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,158 :: 		next i
	MOVF       _i+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_ultrasonico_timer1_rotar_servo68
	INCF       _i+0, 1
	GOTO       L_ultrasonico_timer1_rotar_servo65
L_ultrasonico_timer1_rotar_servo68:
	RETURN
; end of ultrasonico_timer1_rotar_servo

_main:

;ultrasonico_timer1.mbas,162 :: 		main:
;ultrasonico_timer1.mbas,163 :: 		OSCCON = %01110101
	MOVLW      117
	MOVWF      OSCCON+0
;ultrasonico_timer1.mbas,164 :: 		OPTION_REG=%10000000      ' Desabilito resistores pull up y  asigno prescaler to TMR0 (128)
	MOVLW      128
	MOVWF      OPTION_REG+0
;ultrasonico_timer1.mbas,165 :: 		INTCON = %11000000        ' Enable external interrupts bit(7) and bit(6) de permiso q no se controlan con INTCON
	MOVLW      192
	MOVWF      INTCON+0
;ultrasonico_timer1.mbas,166 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;ultrasonico_timer1.mbas,168 :: 		TRISA= %00000000
	CLRF       TRISA+0
;ultrasonico_timer1.mbas,169 :: 		TRISB= %00000001
	MOVLW      1
	MOVWF      TRISB+0
;ultrasonico_timer1.mbas,170 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;ultrasonico_timer1.mbas,172 :: 		ANSEL= %00000000
	CLRF       ANSEL+0
;ultrasonico_timer1.mbas,173 :: 		ANSELH= %00000000
	CLRF       ANSELH+0
;ultrasonico_timer1.mbas,176 :: 		Servo = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,177 :: 		T1CON = %00110001
	MOVLW      49
	MOVWF      T1CON+0
;ultrasonico_timer1.mbas,178 :: 		PIE1 = PIE1 OR %00000001
	BSF        PIE1+0, 0
;ultrasonico_timer1.mbas,179 :: 		TMR1L = 0xFF
	MOVLW      255
	MOVWF      TMR1L+0
;ultrasonico_timer1.mbas,180 :: 		TMR1H = 0xFF
	MOVLW      255
	MOVWF      TMR1H+0
;ultrasonico_timer1.mbas,181 :: 		paso = 0
	CLRF       _Paso+0
;ultrasonico_timer1.mbas,182 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;ultrasonico_timer1.mbas,183 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;ultrasonico_timer1.mbas,186 :: 		OPTION_REG = OPTION_REG or %01000110   ' interrupcion rb0
	MOVLW      70
	IORWF      OPTION_REG+0, 1
;ultrasonico_timer1.mbas,187 :: 		INTCON = INTCON or %00010000
	BSF        INTCON+0, 4
;ultrasonico_timer1.mbas,188 :: 		flanco = 1
	MOVLW      1
	MOVWF      _flanco+0
;ultrasonico_timer1.mbas,189 :: 		Tiempo = 0
	CLRF       _Tiempo+0
	CLRF       _Tiempo+1
;ultrasonico_timer1.mbas,192 :: 		PIE1 = PIE1 or %00100000
	BSF        PIE1+0, 5
;ultrasonico_timer1.mbas,193 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;ultrasonico_timer1.mbas,194 :: 		viajero_usart = 1
	MOVLW      1
	MOVWF      _viajero_usart+0
;ultrasonico_timer1.mbas,197 :: 		PORTA= %00000000
	CLRF       PORTA+0
;ultrasonico_timer1.mbas,198 :: 		PORTB= %00000000
	CLRF       PORTB+0
;ultrasonico_timer1.mbas,199 :: 		PORTC= %00000000
	CLRF       PORTC+0
;ultrasonico_timer1.mbas,201 :: 		PWM1_Init(5000)
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;ultrasonico_timer1.mbas,202 :: 		PWM2_Init(5000)
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;ultrasonico_timer1.mbas,203 :: 		PWM1_Start()
	CALL       _PWM1_Start+0
;ultrasonico_timer1.mbas,204 :: 		PWM2_Start()
	CALL       _PWM2_Start+0
;ultrasonico_timer1.mbas,206 :: 		velocidad_2= 0x00
	CLRF       _velocidad_2+0
;ultrasonico_timer1.mbas,207 :: 		velocidad_1= 0x00
	CLRF       _velocidad_1+0
;ultrasonico_timer1.mbas,208 :: 		Servo = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,210 :: 		inicio_usart = 0xb7
	MOVLW      183
	MOVWF      _inicio_usart+0
;ultrasonico_timer1.mbas,211 :: 		ide_usart = 0XB7
	MOVLW      183
	MOVWF      _ide_usart+0
;ultrasonico_timer1.mbas,212 :: 		termino = 0
	CLRF       _termino+0
;ultrasonico_timer1.mbas,215 :: 		PWM1_Set_Duty(velocidad_1)
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;ultrasonico_timer1.mbas,216 :: 		PWM2_Set_Duty(velocidad_2)
	MOVF       _velocidad_2+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;ultrasonico_timer1.mbas,219 :: 		ClearBit(PORTB,1) ' adelante
	BCF        PORTB+0, 1
;ultrasonico_timer1.mbas,221 :: 		ClearBit(PORTB,2) ' adelante
	BCF        PORTB+0, 2
;ultrasonico_timer1.mbas,223 :: 		led()
	CALL       ultrasonico_timer1_led+0
;ultrasonico_timer1.mbas,225 :: 		while true
L__main75:
;ultrasonico_timer1.mbas,226 :: 		srf05_pulso()
	CALL       ultrasonico_timer1_srf05_pulso+0
;ultrasonico_timer1.mbas,227 :: 		if termino = 1 then
	MOVF       _termino+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main80
;ultrasonico_timer1.mbas,228 :: 		Servo = angulo
	MOVF       _angulo+0, 0
	MOVWF      _Servo+0
;ultrasonico_timer1.mbas,229 :: 		PWM1_Set_Duty(velocidad_1)
	MOVF       _velocidad_1+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;ultrasonico_timer1.mbas,230 :: 		portb.1 = direccion_1.0
	BTFSC      _direccion_1+0, 0
	GOTO       L__main91
	BCF        PORTB+0, 1
	GOTO       L__main92
L__main91:
	BSF        PORTB+0, 1
L__main92:
;ultrasonico_timer1.mbas,231 :: 		PWM2_Set_Duty(velocidad_2)
	MOVF       _velocidad_2+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;ultrasonico_timer1.mbas,232 :: 		portb.2 = direccion_2.0
	BTFSC      _direccion_2+0, 0
	GOTO       L__main93
	BCF        PORTB+0, 2
	GOTO       L__main94
L__main93:
	BSF        PORTB+0, 2
L__main94:
;ultrasonico_timer1.mbas,233 :: 		termino = 0
	CLRF       _termino+0
L__main80:
;ultrasonico_timer1.mbas,236 :: 		UART1_Write(ide_usart)
	MOVF       _ide_usart+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;ultrasonico_timer1.mbas,237 :: 		UART1_Write(lo(distancia))
	MOVF       _distancia+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;ultrasonico_timer1.mbas,239 :: 		delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main82:
	DECFSZ     R13+0, 1
	GOTO       L__main82
	DECFSZ     R12+0, 1
	GOTO       L__main82
	DECFSZ     R11+0, 1
	GOTO       L__main82
;ultrasonico_timer1.mbas,240 :: 		PORTA = distancia
	MOVF       _distancia+0, 0
	MOVWF      PORTA+0
;ultrasonico_timer1.mbas,241 :: 		wend
	GOTO       L__main75
	GOTO       $+0
; end of _main

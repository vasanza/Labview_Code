
robot_distancia_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;robot_distancia.mbas,37 :: 		sub procedure interrupt
;robot_distancia.mbas,39 :: 		if TestBit(INTCON,T0IF)=1 then
	CLRF       R1+0
	BTFSS      INTCON+0, 2
	GOTO       L_robot_distancia_interrupt4
	MOVLW      1
	MOVWF      R1+0
L_robot_distancia_interrupt4:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt2
;robot_distancia.mbas,40 :: 		if Paso=0 then
	MOVF       _Paso+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt6
;robot_distancia.mbas,41 :: 		MaskPort= (salidas and n_servo)
	MOVF       _n_servo+0, 0
	ANDWF      _Salidas+0, 0
	MOVWF      _MaskPort+0
	MOVF       _Salidas+1, 0
	ANDWF      _n_servo+1, 0
	MOVWF      _MaskPort+1
;robot_distancia.mbas,42 :: 		PORTB.5 = MaskPort.0
	BTFSC      _MaskPort+0, 0
	GOTO       L_robot_distancia_interrupt85
	BCF        PORTB+0, 5
	GOTO       L_robot_distancia_interrupt86
L_robot_distancia_interrupt85:
	BSF        PORTB+0, 5
L_robot_distancia_interrupt86:
;robot_distancia.mbas,43 :: 		Paso=1
	MOVLW      1
	MOVWF      _Paso+0
;robot_distancia.mbas,44 :: 		TMR0=0xda
	MOVLW      218
	MOVWF      TMR0+0
	GOTO       L_robot_distancia_interrupt7
;robot_distancia.mbas,45 :: 		else
L_robot_distancia_interrupt6:
;robot_distancia.mbas,46 :: 		if Paso=1 then
	MOVF       _Paso+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt9
;robot_distancia.mbas,47 :: 		TMR0=(255-(Servo-2))
	MOVLW      2
	SUBWF      _Servo+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;robot_distancia.mbas,48 :: 		Paso=2
	MOVLW      2
	MOVWF      _Paso+0
	GOTO       L_robot_distancia_interrupt10
;robot_distancia.mbas,49 :: 		else
L_robot_distancia_interrupt9:
;robot_distancia.mbas,50 :: 		PORTB.5=0
	BCF        PORTB+0, 5
;robot_distancia.mbas,51 :: 		TMR0=(Servo-2)
	MOVLW      2
	SUBWF      _Servo+0, 0
	MOVWF      TMR0+0
;robot_distancia.mbas,52 :: 		n_servo=n_servo<<1
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
;robot_distancia.mbas,53 :: 		if n_servo=0x0200 then
	MOVF       R1+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt87
	MOVLW      0
	XORWF      R1+0, 0
L_robot_distancia_interrupt87:
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt12
;robot_distancia.mbas,54 :: 		n_servo=1
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
L_robot_distancia_interrupt12:
;robot_distancia.mbas,56 :: 		paso=0
	CLRF       _Paso+0
;robot_distancia.mbas,57 :: 		end if
L_robot_distancia_interrupt10:
;robot_distancia.mbas,58 :: 		end if
L_robot_distancia_interrupt7:
;robot_distancia.mbas,59 :: 		ClearBit(INTCON,T0IF)
	BCF        INTCON+0, 2
L_robot_distancia_interrupt2:
;robot_distancia.mbas,65 :: 		if TestBit(PIR1,RCIF) = 1 then
	CLRF       R1+0
	BTFSS      PIR1+0, 5
	GOTO       L_robot_distancia_interrupt17
	MOVLW      1
	MOVWF      R1+0
L_robot_distancia_interrupt17:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt15
;robot_distancia.mbas,66 :: 		received_byte = Uart1_Read
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _received_byte+0
;robot_distancia.mbas,68 :: 		case 1
	MOVF       _viajero_usart+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt21
;robot_distancia.mbas,69 :: 		if 0xAA = received_byte then
	MOVLW      170
	XORWF      _received_byte+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt23
;robot_distancia.mbas,70 :: 		viajero_usart = 2
	MOVLW      2
	MOVWF      _viajero_usart+0
	GOTO       L_robot_distancia_interrupt24
;robot_distancia.mbas,71 :: 		else
L_robot_distancia_interrupt23:
;robot_distancia.mbas,72 :: 		viajero_usart = 1
	MOVLW      1
	MOVWF      _viajero_usart+0
;robot_distancia.mbas,73 :: 		termino=0
	CLRF       _termino+0
;robot_distancia.mbas,74 :: 		end if
L_robot_distancia_interrupt24:
	GOTO       L_robot_distancia_interrupt18
L_robot_distancia_interrupt21:
;robot_distancia.mbas,75 :: 		case 2
	MOVF       _viajero_usart+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt27
;robot_distancia.mbas,76 :: 		if 0xCC = received_byte then
	MOVLW      204
	XORWF      _received_byte+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt29
;robot_distancia.mbas,77 :: 		viajero_usart = 3
	MOVLW      3
	MOVWF      _viajero_usart+0
	GOTO       L_robot_distancia_interrupt30
;robot_distancia.mbas,78 :: 		else
L_robot_distancia_interrupt29:
;robot_distancia.mbas,79 :: 		viajero_usart = 1
	MOVLW      1
	MOVWF      _viajero_usart+0
;robot_distancia.mbas,80 :: 		termino= 0
	CLRF       _termino+0
;robot_distancia.mbas,81 :: 		end if
L_robot_distancia_interrupt30:
	GOTO       L_robot_distancia_interrupt18
L_robot_distancia_interrupt27:
;robot_distancia.mbas,82 :: 		case 3
	MOVF       _viajero_usart+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt33
;robot_distancia.mbas,83 :: 		index_usart= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _index_usart+0
;robot_distancia.mbas,84 :: 		viajero_usart= 4
	MOVLW      4
	MOVWF      _viajero_usart+0
	GOTO       L_robot_distancia_interrupt18
L_robot_distancia_interrupt33:
;robot_distancia.mbas,85 :: 		case 4
	MOVF       _viajero_usart+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt36
;robot_distancia.mbas,86 :: 		pos_usart= received_byte
	MOVF       _received_byte+0, 0
	MOVWF      _pos_usart+0
;robot_distancia.mbas,87 :: 		viajero_usart= 5
	MOVLW      5
	MOVWF      _viajero_usart+0
	GOTO       L_robot_distancia_interrupt18
L_robot_distancia_interrupt36:
;robot_distancia.mbas,88 :: 		case 5
	MOVF       _viajero_usart+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt39
;robot_distancia.mbas,89 :: 		if 0xDD = received_byte then
	MOVLW      221
	XORWF      _received_byte+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt41
;robot_distancia.mbas,90 :: 		termino=1
	MOVLW      1
	MOVWF      _termino+0
L_robot_distancia_interrupt41:
;robot_distancia.mbas,92 :: 		viajero_usart = 1
	MOVLW      1
	MOVWF      _viajero_usart+0
	GOTO       L_robot_distancia_interrupt18
L_robot_distancia_interrupt39:
L_robot_distancia_interrupt18:
;robot_distancia.mbas,94 :: 		ClearBit(PIR1,RCIF)
	BCF        PIR1+0, 5
L_robot_distancia_interrupt15:
;robot_distancia.mbas,99 :: 		if INTCON.INTF = 1 then            ' External interupt (RB0 pin)
	BTFSS      INTCON+0, 1
	GOTO       L_robot_distancia_interrupt44
;robot_distancia.mbas,100 :: 		if flanco=1 then
	MOVF       _flanco+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_interrupt47
;robot_distancia.mbas,101 :: 		TMR1L = 0x00
	CLRF       TMR1L+0
;robot_distancia.mbas,102 :: 		TMR1H = 0x00
	CLRF       TMR1H+0
;robot_distancia.mbas,103 :: 		T1CON.TMR1ON=1
	BSF        T1CON+0, 0
;robot_distancia.mbas,104 :: 		OPTION_REG.INTEDG=0
	BCF        OPTION_REG+0, 6
;robot_distancia.mbas,105 :: 		flanco = 0
	CLRF       _flanco+0
	GOTO       L_robot_distancia_interrupt48
;robot_distancia.mbas,106 :: 		else
L_robot_distancia_interrupt47:
;robot_distancia.mbas,107 :: 		T1CON.TMR1ON=0
	BCF        T1CON+0, 0
;robot_distancia.mbas,108 :: 		OPTION_REG.INTEDG=1
	BSF        OPTION_REG+0, 6
;robot_distancia.mbas,109 :: 		Tiempo = TMR1L + TMR1H
	MOVF       TMR1L+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       TMR1H+0, 0
	ADDWF      R0+0, 0
	MOVWF      _Tiempo+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _Tiempo+1
;robot_distancia.mbas,110 :: 		TMR1L = 0x00
	CLRF       TMR1L+0
;robot_distancia.mbas,111 :: 		TMR1H = 0x00
	CLRF       TMR1H+0
;robot_distancia.mbas,112 :: 		flanco=1
	MOVLW      1
	MOVWF      _flanco+0
;robot_distancia.mbas,113 :: 		end if
L_robot_distancia_interrupt48:
;robot_distancia.mbas,114 :: 		Clearbit(INTCON,INTF)
	BCF        INTCON+0, 1
L_robot_distancia_interrupt44:
;robot_distancia.mbas,115 :: 		end if
L_robot_distancia_interrupt84:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of robot_distancia_interrupt

robot_distancia_srf05_pulso:

;robot_distancia.mbas,120 :: 		sub procedure srf05_pulso
;robot_distancia.mbas,122 :: 		portc.5=1
	BSF        PORTC+0, 5
;robot_distancia.mbas,123 :: 		delay_us(50)
	MOVLW      33
	MOVWF      R13+0
L_robot_distancia_srf05_pulso50:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_srf05_pulso50
;robot_distancia.mbas,124 :: 		portc.5=0
	BCF        PORTC+0, 5
;robot_distancia.mbas,125 :: 		delay_ms(50)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_robot_distancia_srf05_pulso51:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_srf05_pulso51
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_srf05_pulso51
	NOP
	NOP
;robot_distancia.mbas,127 :: 		distancia = Tiempo*15
	MOVF       _Tiempo+0, 0
	MOVWF      R0+0
	MOVF       _Tiempo+1, 0
	MOVWF      R0+1
	MOVLW      15
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _distancia+0
	MOVF       R0+1, 0
	MOVWF      _distancia+1
;robot_distancia.mbas,128 :: 		distancia = distancia/28
	MOVLW      28
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _distancia+0
	MOVF       R0+1, 0
	MOVWF      _distancia+1
	RETURN
; end of robot_distancia_srf05_pulso

robot_distancia_led:

;robot_distancia.mbas,131 :: 		sub procedure led
;robot_distancia.mbas,132 :: 		porta = 0x00
	CLRF       PORTA+0
;robot_distancia.mbas,133 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_robot_distancia_led53:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_led53
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_led53
	DECFSZ     R11+0, 1
	GOTO       L_robot_distancia_led53
	NOP
	NOP
;robot_distancia.mbas,134 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;robot_distancia.mbas,135 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_robot_distancia_led54:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_led54
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_led54
	DECFSZ     R11+0, 1
	GOTO       L_robot_distancia_led54
	NOP
	NOP
;robot_distancia.mbas,136 :: 		porta = 0x00
	CLRF       PORTA+0
;robot_distancia.mbas,137 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_robot_distancia_led55:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_led55
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_led55
	DECFSZ     R11+0, 1
	GOTO       L_robot_distancia_led55
	NOP
	NOP
;robot_distancia.mbas,138 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;robot_distancia.mbas,139 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_robot_distancia_led56:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_led56
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_led56
	DECFSZ     R11+0, 1
	GOTO       L_robot_distancia_led56
	NOP
	NOP
;robot_distancia.mbas,140 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of robot_distancia_led

robot_distancia_rotar_servo:

;robot_distancia.mbas,143 :: 		sub procedure rotar_servo
;robot_distancia.mbas,144 :: 		for i=20 to 255
	MOVLW      20
	MOVWF      _i+0
L_robot_distancia_rotar_servo59:
;robot_distancia.mbas,145 :: 		Servo = i
	MOVF       _i+0, 0
	MOVWF      _Servo+0
;robot_distancia.mbas,147 :: 		srf05_pulso
	CALL       robot_distancia_srf05_pulso+0
;robot_distancia.mbas,148 :: 		if distancia < Index then
	MOVF       _Index+1, 0
	SUBWF      _distancia+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_rotar_servo88
	MOVF       _Index+0, 0
	SUBWF      _distancia+0, 0
L_robot_distancia_rotar_servo88:
	BTFSC      STATUS+0, 0
	GOTO       L_robot_distancia_rotar_servo64
;robot_distancia.mbas,149 :: 		porta = 0x0f
	MOVLW      15
	MOVWF      PORTA+0
;robot_distancia.mbas,150 :: 		delay_ms(10)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_robot_distancia_rotar_servo66:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_rotar_servo66
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_rotar_servo66
	NOP
L_robot_distancia_rotar_servo64:
;robot_distancia.mbas,153 :: 		porta = 0xf0
	MOVLW      240
	MOVWF      PORTA+0
;robot_distancia.mbas,154 :: 		next i
	MOVF       _i+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_robot_distancia_rotar_servo62
	INCF       _i+0, 1
	GOTO       L_robot_distancia_rotar_servo59
L_robot_distancia_rotar_servo62:
;robot_distancia.mbas,155 :: 		SetBit(PORTA,0)
	BSF        PORTA+0, 0
;robot_distancia.mbas,156 :: 		for i=20 to 255
	MOVLW      20
	MOVWF      _i+0
L_robot_distancia_rotar_servo68:
;robot_distancia.mbas,157 :: 		Servo = 275-i
	MOVF       _i+0, 0
	SUBLW      19
	MOVWF      _Servo+0
;robot_distancia.mbas,159 :: 		srf05_pulso
	CALL       robot_distancia_srf05_pulso+0
;robot_distancia.mbas,160 :: 		if distancia < Index then
	MOVF       _Index+1, 0
	SUBWF      _distancia+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_robot_distancia_rotar_servo89
	MOVF       _Index+0, 0
	SUBWF      _distancia+0, 0
L_robot_distancia_rotar_servo89:
	BTFSC      STATUS+0, 0
	GOTO       L_robot_distancia_rotar_servo73
;robot_distancia.mbas,161 :: 		porta = 0x0f
	MOVLW      15
	MOVWF      PORTA+0
;robot_distancia.mbas,162 :: 		delay_ms(10)
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_robot_distancia_rotar_servo75:
	DECFSZ     R13+0, 1
	GOTO       L_robot_distancia_rotar_servo75
	DECFSZ     R12+0, 1
	GOTO       L_robot_distancia_rotar_servo75
	NOP
L_robot_distancia_rotar_servo73:
;robot_distancia.mbas,164 :: 		porta = 0xf0
	MOVLW      240
	MOVWF      PORTA+0
;robot_distancia.mbas,166 :: 		next i
	MOVF       _i+0, 0
	XORLW      255
	BTFSC      STATUS+0, 2
	GOTO       L_robot_distancia_rotar_servo71
	INCF       _i+0, 1
	GOTO       L_robot_distancia_rotar_servo68
L_robot_distancia_rotar_servo71:
;robot_distancia.mbas,167 :: 		ClearBit(PORTA,0)
	BCF        PORTA+0, 0
	RETURN
; end of robot_distancia_rotar_servo

_main:

;robot_distancia.mbas,170 :: 		main:
;robot_distancia.mbas,172 :: 		OPTION_REG = %10000000
	MOVLW      128
	MOVWF      OPTION_REG+0
;robot_distancia.mbas,173 :: 		INTCON = %11000000
	MOVLW      192
	MOVWF      INTCON+0
;robot_distancia.mbas,174 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;robot_distancia.mbas,176 :: 		TRISA= %00000000
	CLRF       TRISA+0
;robot_distancia.mbas,177 :: 		TRISB= %00000001
	MOVLW      1
	MOVWF      TRISB+0
;robot_distancia.mbas,178 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;robot_distancia.mbas,180 :: 		ANSEL= %00000000
	CLRF       ANSEL+0
;robot_distancia.mbas,181 :: 		ANSELH= %00000000
	CLRF       ANSELH+0
;robot_distancia.mbas,184 :: 		OPTION_REG = OPTION_REG or %00000011   ' prescalador 128
	MOVLW      3
	IORWF      OPTION_REG+0, 1
;robot_distancia.mbas,185 :: 		INTCON = INTCON or %00100000
	BSF        INTCON+0, 5
;robot_distancia.mbas,186 :: 		TMR0 = 0xda
	MOVLW      218
	MOVWF      TMR0+0
;robot_distancia.mbas,187 :: 		paso = 0
	CLRF       _Paso+0
;robot_distancia.mbas,188 :: 		Servo = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;robot_distancia.mbas,189 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;robot_distancia.mbas,190 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;robot_distancia.mbas,193 :: 		OPTION_REG = OPTION_REG or %01000000   ' interrupcion rb0
	BSF        OPTION_REG+0, 6
;robot_distancia.mbas,194 :: 		INTCON = INTCON or %00010000
	BSF        INTCON+0, 4
;robot_distancia.mbas,195 :: 		T1CON= %00110001
	MOVLW      49
	MOVWF      T1CON+0
;robot_distancia.mbas,196 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;robot_distancia.mbas,197 :: 		flanco = 1
	MOVLW      1
	MOVWF      _flanco+0
;robot_distancia.mbas,198 :: 		Tiempo = 0
	CLRF       _Tiempo+0
	CLRF       _Tiempo+1
;robot_distancia.mbas,199 :: 		TMR1L = 0X00
	CLRF       TMR1L+0
;robot_distancia.mbas,200 :: 		TMR1H = 0X00
	CLRF       TMR1H+0
;robot_distancia.mbas,204 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;robot_distancia.mbas,207 :: 		PORTA= %00000000
	CLRF       PORTA+0
;robot_distancia.mbas,208 :: 		PORTB= %00000000
	CLRF       PORTB+0
;robot_distancia.mbas,209 :: 		PORTC= %00000000
	CLRF       PORTC+0
;robot_distancia.mbas,211 :: 		PWM1_Init(5000)
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;robot_distancia.mbas,212 :: 		PWM2_Init(5000)
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      99
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;robot_distancia.mbas,213 :: 		PWM1_Start()
	CALL       _PWM1_Start+0
;robot_distancia.mbas,214 :: 		PWM2_Start()
	CALL       _PWM2_Start+0
;robot_distancia.mbas,216 :: 		PWM1_Set_Duty(0XFF)
	MOVLW      255
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;robot_distancia.mbas,217 :: 		PWM2_Set_Duty(0XFF)
	MOVLW      255
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;robot_distancia.mbas,220 :: 		ClearBit(PORTB,1) ' adelante
	BCF        PORTB+0, 1
;robot_distancia.mbas,222 :: 		ClearBit(PORTB,2) ' adelante
	BCF        PORTB+0, 2
;robot_distancia.mbas,224 :: 		led()
	CALL       robot_distancia_led+0
;robot_distancia.mbas,225 :: 		Index = 0x0014
	MOVLW      20
	MOVWF      _Index+0
	CLRF       _Index+1
;robot_distancia.mbas,226 :: 		while true
L__main78:
;robot_distancia.mbas,228 :: 		srf05_pulso()
	CALL       robot_distancia_srf05_pulso+0
;robot_distancia.mbas,229 :: 		delay_ms(50)
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L__main82:
	DECFSZ     R13+0, 1
	GOTO       L__main82
	DECFSZ     R12+0, 1
	GOTO       L__main82
	NOP
	NOP
;robot_distancia.mbas,230 :: 		PORTA = distancia
	MOVF       _distancia+0, 0
	MOVWF      PORTA+0
;robot_distancia.mbas,236 :: 		delay_ms(100)
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L__main83:
	DECFSZ     R13+0, 1
	GOTO       L__main83
	DECFSZ     R12+0, 1
	GOTO       L__main83
	DECFSZ     R11+0, 1
	GOTO       L__main83
	NOP
;robot_distancia.mbas,237 :: 		wend
	GOTO       L__main78
	GOTO       $+0
; end of _main


motor_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;motor.mbas,50 :: 		sub procedure interrupt
;motor.mbas,52 :: 		if TestBit(PIR1,TMR1IF)=1 then
	CLRF       R1+0
	BTFSS      PIR1+0, 0
	GOTO       L_motor_interrupt4
	MOVLW      1
	MOVWF      R1+0
L_motor_interrupt4:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt2
;motor.mbas,53 :: 		if Paso=0 then
	MOVF       _Paso+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt6
;motor.mbas,54 :: 		MaskPort= (salidas and n_servo)
	MOVF       _n_servo+0, 0
	ANDWF      _Salidas+0, 0
	MOVWF      _MaskPort+0
	MOVF       _Salidas+1, 0
	ANDWF      _n_servo+1, 0
	MOVWF      _MaskPort+1
;motor.mbas,55 :: 		PORTC.0 = MaskPort.0
	BTFSC      _MaskPort+0, 0
	GOTO       L_motor_interrupt45
	BCF        PORTC+0, 0
	GOTO       L_motor_interrupt46
L_motor_interrupt45:
	BSF        PORTC+0, 0
L_motor_interrupt46:
;motor.mbas,57 :: 		Paso=1
	MOVLW      1
	MOVWF      _Paso+0
;motor.mbas,61 :: 		TMR1L=0x1F
	MOVLW      31
	MOVWF      TMR1L+0
;motor.mbas,62 :: 		TMR1H=0XFF
	MOVLW      255
	MOVWF      TMR1H+0
	GOTO       L_motor_interrupt7
;motor.mbas,64 :: 		else    '65086 1.8ms
L_motor_interrupt6:
;motor.mbas,66 :: 		if Paso=1 then
	MOVF       _Paso+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt9
;motor.mbas,68 :: 		temp_var= 65276 + Servo
	MOVF       _Servo+0, 0
	ADDLW      252
	MOVWF      _temp_var+0
	MOVLW      254
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _temp_var+1
;motor.mbas,69 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;motor.mbas,70 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;motor.mbas,71 :: 		Paso=2
	MOVLW      2
	MOVWF      _Paso+0
	GOTO       L_motor_interrupt10
;motor.mbas,72 :: 		else
L_motor_interrupt9:
;motor.mbas,73 :: 		PORTC.0=0
	BCF        PORTC+0, 0
;motor.mbas,75 :: 		temp_var= 65530 - Servo
	MOVF       _Servo+0, 0
	SUBLW      250
	MOVWF      _temp_var+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      255
	MOVWF      _temp_var+1
;motor.mbas,76 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;motor.mbas,77 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;motor.mbas,78 :: 		n_servo=n_servo<<1
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
;motor.mbas,79 :: 		if n_servo=0x0400 then
	MOVF       R1+1, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt47
	MOVLW      0
	XORWF      R1+0, 0
L_motor_interrupt47:
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt12
;motor.mbas,80 :: 		n_servo=1
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
L_motor_interrupt12:
;motor.mbas,82 :: 		paso=0
	CLRF       _Paso+0
;motor.mbas,83 :: 		end if
L_motor_interrupt10:
;motor.mbas,84 :: 		end if
L_motor_interrupt7:
;motor.mbas,85 :: 		ClearBit(PIR1,TMR1IF)
	BCF        PIR1+0, 0
L_motor_interrupt2:
;motor.mbas,88 :: 		if( PIR1.RCIF = 1 )then
	BTFSS      PIR1+0, 5
	GOTO       L_motor_interrupt15
;motor.mbas,89 :: 		usart_receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _usart_receive+0
;motor.mbas,91 :: 		case 1
	MOVF       _viajero_uart+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt20
;motor.mbas,92 :: 		if 0xb7 = usart_receive then
	MOVLW      183
	XORWF      _usart_receive+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt22
;motor.mbas,93 :: 		viajero_uart = 2
	MOVLW      2
	MOVWF      _viajero_uart+0
	GOTO       L_motor_interrupt23
;motor.mbas,95 :: 		else
L_motor_interrupt22:
;motor.mbas,96 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;motor.mbas,97 :: 		end if
L_motor_interrupt23:
	GOTO       L_motor_interrupt17
L_motor_interrupt20:
;motor.mbas,98 :: 		case 2
	MOVF       _viajero_uart+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_motor_interrupt26
;motor.mbas,99 :: 		Servo = usart_receive
	MOVF       _usart_receive+0, 0
	MOVWF      _Servo+0
;motor.mbas,100 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
	GOTO       L_motor_interrupt17
L_motor_interrupt26:
L_motor_interrupt17:
;motor.mbas,102 :: 		ClearBit(PIR1,RCIF)   ' Si el dato a llegado limpio la bandera de recepcion
	BCF        PIR1+0, 5
;motor.mbas,103 :: 		SetBit(PIE1,RCIE)     ' Habilitar nuevamente la interrupcion por USART
	BSF        PIE1+0, 5
L_motor_interrupt15:
;motor.mbas,104 :: 		end if
L_motor_interrupt44:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of motor_interrupt

motor_led:

;motor.mbas,107 :: 		sub procedure led
;motor.mbas,108 :: 		porta = 0x00
	CLRF       PORTA+0
;motor.mbas,109 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_motor_led28:
	DECFSZ     R13+0, 1
	GOTO       L_motor_led28
	DECFSZ     R12+0, 1
	GOTO       L_motor_led28
	DECFSZ     R11+0, 1
	GOTO       L_motor_led28
	NOP
	NOP
;motor.mbas,110 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;motor.mbas,111 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_motor_led29:
	DECFSZ     R13+0, 1
	GOTO       L_motor_led29
	DECFSZ     R12+0, 1
	GOTO       L_motor_led29
	DECFSZ     R11+0, 1
	GOTO       L_motor_led29
	NOP
	NOP
;motor.mbas,112 :: 		porta = 0x00
	CLRF       PORTA+0
;motor.mbas,113 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_motor_led30:
	DECFSZ     R13+0, 1
	GOTO       L_motor_led30
	DECFSZ     R12+0, 1
	GOTO       L_motor_led30
	DECFSZ     R11+0, 1
	GOTO       L_motor_led30
	NOP
	NOP
;motor.mbas,114 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;motor.mbas,115 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_motor_led31:
	DECFSZ     R13+0, 1
	GOTO       L_motor_led31
	DECFSZ     R12+0, 1
	GOTO       L_motor_led31
	DECFSZ     R11+0, 1
	GOTO       L_motor_led31
	NOP
	NOP
;motor.mbas,116 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of motor_led

_main:

;motor.mbas,119 :: 		main:
;motor.mbas,120 :: 		OSCCON = %01110101
	MOVLW      117
	MOVWF      OSCCON+0
;motor.mbas,121 :: 		OPTION_REG=%01000101
	MOVLW      69
	MOVWF      OPTION_REG+0
;motor.mbas,122 :: 		INTCON = %11000000
	MOVLW      192
	MOVWF      INTCON+0
;motor.mbas,123 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;motor.mbas,125 :: 		TRISA= %00000011
	MOVLW      3
	MOVWF      TRISA+0
;motor.mbas,126 :: 		TRISB= %00000000
	CLRF       TRISB+0
;motor.mbas,127 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;motor.mbas,129 :: 		ANSEL= %00000011
	MOVLW      3
	MOVWF      ANSEL+0
;motor.mbas,130 :: 		ANSELH= %00000000
	CLRF       ANSELH+0
;motor.mbas,133 :: 		Servo = 0xff
	MOVLW      255
	MOVWF      _Servo+0
;motor.mbas,134 :: 		T1CON = %00110001
	MOVLW      49
	MOVWF      T1CON+0
;motor.mbas,135 :: 		PIE1 = PIE1 OR %00000001
	BSF        PIE1+0, 0
;motor.mbas,136 :: 		TMR1L = 0xFF
	MOVLW      255
	MOVWF      TMR1L+0
;motor.mbas,137 :: 		TMR1H = 0xFF
	MOVLW      255
	MOVWF      TMR1H+0
;motor.mbas,138 :: 		paso = 0
	CLRF       _Paso+0
;motor.mbas,139 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;motor.mbas,140 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;motor.mbas,145 :: 		PIE1 = PIE1 or %00100000
	BSF        PIE1+0, 5
;motor.mbas,146 :: 		PIR1 = %00000000
	CLRF       PIR1+0
;motor.mbas,147 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;motor.mbas,150 :: 		PORTA= %00000000
	CLRF       PORTA+0
;motor.mbas,151 :: 		PORTB= %00000000
	CLRF       PORTB+0
;motor.mbas,152 :: 		PORTC= %00000000
	CLRF       PORTC+0
;motor.mbas,154 :: 		TMR0 = 0X00
	CLRF       TMR0+0
;motor.mbas,155 :: 		intensidad=5
	MOVLW      5
	MOVWF      _intensidad+0
;motor.mbas,156 :: 		muestras=0
	CLRF       _muestras+0
;motor.mbas,157 :: 		temp_ac=0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;motor.mbas,158 :: 		temp_prom=0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;motor.mbas,159 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;motor.mbas,161 :: 		led()
	CALL       motor_led+0
;motor.mbas,163 :: 		while true
L__main34:
;motor.mbas,164 :: 		temp_ac = 0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;motor.mbas,165 :: 		temp_prom = 0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;motor.mbas,166 :: 		adxl_analogico = 0
	CLRF       _adxl_analogico+0
	CLRF       _adxl_analogico+1
;motor.mbas,167 :: 		adxl_analogico = 0
	CLRF       _adxl_analogico+0
	CLRF       _adxl_analogico+1
;motor.mbas,168 :: 		for muestras=1 to 64
	MOVLW      1
	MOVWF      _muestras+0
L__main39:
;motor.mbas,169 :: 		analogico = Adc_Read(0)
	CLRF       FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _analogico+0
	MOVF       R0+1, 0
	MOVWF      _analogico+1
;motor.mbas,170 :: 		temp_adxl_analogico = Adc_Read(1)
	MOVLW      1
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_adxl_analogico+0
	MOVF       R0+1, 0
	MOVWF      _temp_adxl_analogico+1
;motor.mbas,171 :: 		temp_ac = temp_ac + analogico
	MOVF       _analogico+0, 0
	ADDWF      _temp_ac+0, 1
	MOVF       _analogico+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_ac+1, 1
;motor.mbas,172 :: 		adxl_analogico = adxl_analogico + temp_adxl_analogico
	MOVF       R0+0, 0
	ADDWF      _adxl_analogico+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adxl_analogico+1, 1
;motor.mbas,173 :: 		next muestras
	MOVF       _muestras+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__main42
	INCF       _muestras+0, 1
	GOTO       L__main39
L__main42:
;motor.mbas,174 :: 		temp_prom = (temp_ac/64)
	MOVLW      6
	MOVWF      R0+0
	MOVF       _temp_ac+0, 0
	MOVWF      _temp_prom+0
	MOVF       _temp_ac+1, 0
	MOVWF      _temp_prom+1
	MOVF       R0+0, 0
L__main48:
	BTFSC      STATUS+0, 2
	GOTO       L__main49
	RRF        _temp_prom+1, 1
	RRF        _temp_prom+0, 1
	BCF        _temp_prom+1, 7
	ADDLW      255
	GOTO       L__main48
L__main49:
;motor.mbas,175 :: 		adxl_analogico = (adxl_analogico/64)
	MOVLW      6
	MOVWF      R0+0
	MOVF       _adxl_analogico+0, 0
	MOVWF      R3+0
	MOVF       _adxl_analogico+1, 0
	MOVWF      R3+1
	MOVF       R0+0, 0
L__main50:
	BTFSC      STATUS+0, 2
	GOTO       L__main51
	RRF        R3+1, 1
	RRF        R3+0, 1
	BCF        R3+1, 7
	ADDLW      255
	GOTO       L__main50
L__main51:
	MOVF       R3+0, 0
	MOVWF      _adxl_analogico+0
	MOVF       R3+1, 0
	MOVWF      _adxl_analogico+1
;motor.mbas,177 :: 		portb = adxl_analogico>>2
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;motor.mbas,178 :: 		UART1_Write(adxl_analogico>>2)
	MOVF       R0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;motor.mbas,179 :: 		Delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main43:
	DECFSZ     R13+0, 1
	GOTO       L__main43
	DECFSZ     R12+0, 1
	GOTO       L__main43
	DECFSZ     R11+0, 1
	GOTO       L__main43
;motor.mbas,180 :: 		wend
	GOTO       L__main34
	GOTO       $+0
; end of _main

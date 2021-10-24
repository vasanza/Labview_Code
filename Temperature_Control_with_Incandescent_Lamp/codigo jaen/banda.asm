
banda_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0
;banda.mbas,49 :: 		sub procedure interrupt
;banda.mbas,51 :: 		if TestBit(PIR1,TMR1IF)=1 then
	CLRF       R1+0
	BTFSS      PIR1+0, 0
	GOTO       L_banda_interrupt4
	MOVLW      1
	MOVWF      R1+0
L_banda_interrupt4:
	MOVF       R1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt2
;banda.mbas,52 :: 		if Paso=0 then
	MOVF       _Paso+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt6
;banda.mbas,53 :: 		MaskPort= (salidas and n_servo)
	MOVF       _n_servo+0, 0
	ANDWF      _Salidas+0, 0
	MOVWF      _MaskPort+0
	MOVF       _Salidas+1, 0
	ANDWF      _n_servo+1, 0
	MOVWF      _MaskPort+1
;banda.mbas,54 :: 		PORTB.3 = MaskPort.0
	BTFSC      _MaskPort+0, 0
	GOTO       L_banda_interrupt54
	BCF        PORTB+0, 3
	GOTO       L_banda_interrupt55
L_banda_interrupt54:
	BSF        PORTB+0, 3
L_banda_interrupt55:
;banda.mbas,55 :: 		Paso=1
	MOVLW      1
	MOVWF      _Paso+0
;banda.mbas,56 :: 		TMR1L=0x6A
	MOVLW      106
	MOVWF      TMR1L+0
;banda.mbas,57 :: 		TMR1H=0XFF
	MOVLW      255
	MOVWF      TMR1H+0
	GOTO       L_banda_interrupt7
;banda.mbas,58 :: 		else    '65086 1.8ms
L_banda_interrupt6:
;banda.mbas,60 :: 		if Paso=1 then
	MOVF       _Paso+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt9
;banda.mbas,61 :: 		temp_var= 65148 + Servo + (Servo/2)
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
;banda.mbas,62 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;banda.mbas,63 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;banda.mbas,64 :: 		Paso=2
	MOVLW      2
	MOVWF      _Paso+0
	GOTO       L_banda_interrupt10
;banda.mbas,65 :: 		else
L_banda_interrupt9:
;banda.mbas,66 :: 		PORTB.3=0
	BCF        PORTB+0, 3
;banda.mbas,67 :: 		temp_var= 65530 - Servo - (Servo/2)
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
;banda.mbas,68 :: 		TMR1L= lo(temp_var)
	MOVF       _temp_var+0, 0
	MOVWF      TMR1L+0
;banda.mbas,69 :: 		TMR1H= hi(temp_var)
	MOVF       _temp_var+1, 0
	MOVWF      TMR1H+0
;banda.mbas,70 :: 		n_servo=n_servo<<1
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
;banda.mbas,71 :: 		if n_servo=0x0200 then
	MOVF       R1+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt56
	MOVLW      0
	XORWF      R1+0, 0
L_banda_interrupt56:
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt12
;banda.mbas,72 :: 		n_servo=1
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
L_banda_interrupt12:
;banda.mbas,74 :: 		paso=0
	CLRF       _Paso+0
;banda.mbas,75 :: 		end if
L_banda_interrupt10:
;banda.mbas,76 :: 		end if
L_banda_interrupt7:
;banda.mbas,77 :: 		ClearBit(PIR1,TMR1IF)
	BCF        PIR1+0, 0
L_banda_interrupt2:
;banda.mbas,80 :: 		if( PIR1.RCIF = 1 )then
	BTFSS      PIR1+0, 5
	GOTO       L_banda_interrupt15
;banda.mbas,81 :: 		usart_receive = UART1_Read()
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      _usart_receive+0
;banda.mbas,83 :: 		case 1
	MOVF       _viajero_uart+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt20
;banda.mbas,84 :: 		if 0xb7 = usart_receive then
	MOVLW      183
	XORWF      _usart_receive+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt22
;banda.mbas,85 :: 		viajero_uart = 2
	MOVLW      2
	MOVWF      _viajero_uart+0
;banda.mbas,86 :: 		porta = usart_receive
	MOVF       _usart_receive+0, 0
	MOVWF      PORTA+0
	GOTO       L_banda_interrupt23
;banda.mbas,87 :: 		else
L_banda_interrupt22:
;banda.mbas,88 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;banda.mbas,89 :: 		end if
L_banda_interrupt23:
	GOTO       L_banda_interrupt17
L_banda_interrupt20:
;banda.mbas,90 :: 		case 2
	MOVF       _viajero_uart+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_banda_interrupt26
;banda.mbas,91 :: 		intensidad = usart_receive
	MOVF       _usart_receive+0, 0
	MOVWF      _intensidad+0
;banda.mbas,92 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
	GOTO       L_banda_interrupt17
L_banda_interrupt26:
L_banda_interrupt17:
;banda.mbas,94 :: 		ClearBit(PIR1,RCIF)   ' Si el dato a llegado limpio la bandera de recepcion
	BCF        PIR1+0, 5
;banda.mbas,95 :: 		SetBit(PIE1,RCIE)     ' Habilitar nuevamente la interrupcion por USART
	BSF        PIE1+0, 5
L_banda_interrupt15:
;banda.mbas,98 :: 		if(INTCON.INTF=1)then
	BTFSS      INTCON+0, 1
	GOTO       L_banda_interrupt28
;banda.mbas,99 :: 		if(intensidad <> 0)then
	MOVF       _intensidad+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_banda_interrupt31
;banda.mbas,100 :: 		PORTB.5=0
	BCF        PORTB+0, 5
;banda.mbas,101 :: 		Tmr0 = intensidad
	MOVF       _intensidad+0, 0
	MOVWF      TMR0+0
;banda.mbas,102 :: 		Setbit(INTCON,T0IE)
	BSF        INTCON+0, 5
	GOTO       L_banda_interrupt32
;banda.mbas,103 :: 		else
L_banda_interrupt31:
;banda.mbas,104 :: 		PORTB.5=0
	BCF        PORTB+0, 5
;banda.mbas,105 :: 		end if
L_banda_interrupt32:
;banda.mbas,106 :: 		Clearbit(INTCON,INTF)
	BCF        INTCON+0, 1
;banda.mbas,107 :: 		Setbit(INTCON,INTE)
	BSF        INTCON+0, 4
L_banda_interrupt28:
;banda.mbas,110 :: 		if(INTCON.T0IF =1)then
	BTFSS      INTCON+0, 2
	GOTO       L_banda_interrupt34
;banda.mbas,111 :: 		PORTB.5=1
	BSF        PORTB+0, 5
;banda.mbas,112 :: 		Clearbit(INTCON,T0IF)
	BCF        INTCON+0, 2
;banda.mbas,113 :: 		Clearbit(INTCON,T0IE)
	BCF        INTCON+0, 5
L_banda_interrupt34:
;banda.mbas,114 :: 		end if
L_banda_interrupt53:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of banda_interrupt

banda_led:
;banda.mbas,119 :: 		sub procedure led
;banda.mbas,120 :: 		porta = 0x00
	CLRF       PORTA+0
;banda.mbas,121 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_led37:
	DECFSZ     R13+0, 1
	GOTO       L_banda_led37
	DECFSZ     R12+0, 1
	GOTO       L_banda_led37
	DECFSZ     R11+0, 1
	GOTO       L_banda_led37
	NOP
	NOP
;banda.mbas,122 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;banda.mbas,123 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_led38:
	DECFSZ     R13+0, 1
	GOTO       L_banda_led38
	DECFSZ     R12+0, 1
	GOTO       L_banda_led38
	DECFSZ     R11+0, 1
	GOTO       L_banda_led38
	NOP
	NOP
;banda.mbas,124 :: 		porta = 0x00
	CLRF       PORTA+0
;banda.mbas,125 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_led39:
	DECFSZ     R13+0, 1
	GOTO       L_banda_led39
	DECFSZ     R12+0, 1
	GOTO       L_banda_led39
	DECFSZ     R11+0, 1
	GOTO       L_banda_led39
	NOP
	NOP
;banda.mbas,126 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;banda.mbas,127 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_led40:
	DECFSZ     R13+0, 1
	GOTO       L_banda_led40
	DECFSZ     R12+0, 1
	GOTO       L_banda_led40
	DECFSZ     R11+0, 1
	GOTO       L_banda_led40
	NOP
	NOP
;banda.mbas,128 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of banda_led

_main:
;banda.mbas,131 :: 		main:
;banda.mbas,132 :: 		OSCCON = %01110101
	MOVLW      117
	MOVWF      OSCCON+0
;banda.mbas,133 :: 		OPTION_REG=%11000101
	MOVLW      197
	MOVWF      OPTION_REG+0
;banda.mbas,134 :: 		INTCON = %11010000
	MOVLW      208
	MOVWF      INTCON+0
;banda.mbas,135 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;banda.mbas,137 :: 		TRISA= %00000000
	CLRF       TRISA+0
;banda.mbas,138 :: 		TRISB= %00010001
	MOVLW      17
	MOVWF      TRISB+0
;banda.mbas,139 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;banda.mbas,141 :: 		ANSEL= %00000000
	CLRF       ANSEL+0
;banda.mbas,142 :: 		ANSELH= %00001000
	MOVLW      8
	MOVWF      ANSELH+0
;banda.mbas,145 :: 		Servo = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;banda.mbas,146 :: 		T1CON = %00110001
	MOVLW      49
	MOVWF      T1CON+0
;banda.mbas,147 :: 		PIE1 = PIE1 OR %00000001
	BSF        PIE1+0, 0
;banda.mbas,148 :: 		TMR1L = 0xFF
	MOVLW      255
	MOVWF      TMR1L+0
;banda.mbas,149 :: 		TMR1H = 0xFF
	MOVLW      255
	MOVWF      TMR1H+0
;banda.mbas,150 :: 		paso = 0
	CLRF       _Paso+0
;banda.mbas,151 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;banda.mbas,152 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;banda.mbas,157 :: 		PIE1 = PIE1 or %00100000
	BSF        PIE1+0, 5
;banda.mbas,158 :: 		PIR1 = %00000000
	CLRF       PIR1+0
;banda.mbas,159 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;banda.mbas,162 :: 		PORTA= %00000000
	CLRF       PORTA+0
;banda.mbas,163 :: 		PORTB= %00000000
	CLRF       PORTB+0
;banda.mbas,164 :: 		PORTC= %00000000
	CLRF       PORTC+0
;banda.mbas,166 :: 		TMR0 = 0X00
	CLRF       TMR0+0
;banda.mbas,168 :: 		Servo = 0x00
	CLRF       _Servo+0
;banda.mbas,175 :: 		intensidad=5
	MOVLW      5
	MOVWF      _intensidad+0
;banda.mbas,176 :: 		muestras=0
	CLRF       _muestras+0
;banda.mbas,177 :: 		temp_ac=0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;banda.mbas,178 :: 		temp_prom=0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;banda.mbas,179 :: 		viajero_uart = 1
	MOVLW      1
	MOVWF      _viajero_uart+0
;banda.mbas,181 :: 		led()
	CALL       banda_led+0
;banda.mbas,183 :: 		while true
L__main43:
;banda.mbas,189 :: 		for muestras=1 to 64
	MOVLW      1
	MOVWF      _muestras+0
L__main47:
	MOVF       _muestras+0, 0
	SUBLW      64
	BTFSS      STATUS+0, 0
	GOTO       L__main50
;banda.mbas,190 :: 		analogico = Adc_Read(11)
	MOVLW      11
	MOVWF      FARG_Adc_Read_channel+0
	CALL       _Adc_Read+0
	MOVF       R0+0, 0
	MOVWF      _analogico+0
;banda.mbas,191 :: 		temperatura=analogico '*100/230) ''
	MOVF       R0+0, 0
	MOVWF      _temperatura+0
	CLRF       _temperatura+1
;banda.mbas,192 :: 		Delay_ms(2)
	MOVLW      6
	MOVWF      R12+0
	MOVLW      48
	MOVWF      R13+0
L__main51:
	DECFSZ     R13+0, 1
	GOTO       L__main51
	DECFSZ     R12+0, 1
	GOTO       L__main51
	NOP
;banda.mbas,193 :: 		temp_ac= temp_ac + temperatura
	MOVF       _temperatura+0, 0
	ADDWF      _temp_ac+0, 1
	MOVF       _temperatura+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_ac+1, 1
;banda.mbas,194 :: 		next muestras
	MOVF       _muestras+0, 0
	XORLW      64
	BTFSC      STATUS+0, 2
	GOTO       L__main50
	INCF       _muestras+0, 1
	GOTO       L__main47
L__main50:
;banda.mbas,195 :: 		temp_prom = (temp_ac /64)
	MOVLW      6
	MOVWF      R0+0
	MOVF       _temp_ac+0, 0
	MOVWF      _temp_prom+0
	MOVF       _temp_ac+1, 0
	MOVWF      _temp_prom+1
	MOVF       R0+0, 0
L__main57:
	BTFSC      STATUS+0, 2
	GOTO       L__main58
	RRF        _temp_prom+1, 1
	RRF        _temp_prom+0, 1
	BCF        _temp_prom+1, 7
	ADDLW      255
	GOTO       L__main57
L__main58:
;banda.mbas,197 :: 		Uart1_Write(0xb7)
	MOVLW      183
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;banda.mbas,199 :: 		Uart1_Write(lo(temp_prom))
	MOVF       _temp_prom+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;banda.mbas,202 :: 		muestras=0
	CLRF       _muestras+0
;banda.mbas,203 :: 		temp_ac=0
	CLRF       _temp_ac+0
	CLRF       _temp_ac+1
;banda.mbas,204 :: 		temp_prom=0
	CLRF       _temp_prom+0
	CLRF       _temp_prom+1
;banda.mbas,205 :: 		Delay_ms(200)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L__main52:
	DECFSZ     R13+0, 1
	GOTO       L__main52
	DECFSZ     R12+0, 1
	GOTO       L__main52
	DECFSZ     R11+0, 1
	GOTO       L__main52
	GOTO       L__main43
;banda.mbas,206 :: 		wend
	GOTO       $+0
; end of _main

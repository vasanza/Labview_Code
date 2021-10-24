
banda_32trasnportadora_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;banda trasnportadora.mbas,47 :: 		sub procedure interrupt
L_banda_32trasnportadora_interrupt13:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of banda_32trasnportadora_interrupt

banda_32trasnportadora_led:

;banda trasnportadora.mbas,120 :: 		sub procedure led
;banda trasnportadora.mbas,121 :: 		porta = 0x00
	CLRF       PORTA+0
;banda trasnportadora.mbas,122 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_32trasnportadora_led2:
	DECFSZ     R13+0, 1
	GOTO       L_banda_32trasnportadora_led2
	DECFSZ     R12+0, 1
	GOTO       L_banda_32trasnportadora_led2
	DECFSZ     R11+0, 1
	GOTO       L_banda_32trasnportadora_led2
	NOP
	NOP
;banda trasnportadora.mbas,123 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;banda trasnportadora.mbas,124 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_32trasnportadora_led3:
	DECFSZ     R13+0, 1
	GOTO       L_banda_32trasnportadora_led3
	DECFSZ     R12+0, 1
	GOTO       L_banda_32trasnportadora_led3
	DECFSZ     R11+0, 1
	GOTO       L_banda_32trasnportadora_led3
	NOP
	NOP
;banda trasnportadora.mbas,125 :: 		porta = 0x00
	CLRF       PORTA+0
;banda trasnportadora.mbas,126 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_32trasnportadora_led4:
	DECFSZ     R13+0, 1
	GOTO       L_banda_32trasnportadora_led4
	DECFSZ     R12+0, 1
	GOTO       L_banda_32trasnportadora_led4
	DECFSZ     R11+0, 1
	GOTO       L_banda_32trasnportadora_led4
	NOP
	NOP
;banda trasnportadora.mbas,127 :: 		porta = 0xff
	MOVLW      255
	MOVWF      PORTA+0
;banda trasnportadora.mbas,128 :: 		delay_ms(250)
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_banda_32trasnportadora_led5:
	DECFSZ     R13+0, 1
	GOTO       L_banda_32trasnportadora_led5
	DECFSZ     R12+0, 1
	GOTO       L_banda_32trasnportadora_led5
	DECFSZ     R11+0, 1
	GOTO       L_banda_32trasnportadora_led5
	NOP
	NOP
;banda trasnportadora.mbas,129 :: 		porta = 0x00
	CLRF       PORTA+0
	RETURN
; end of banda_32trasnportadora_led

_main:

;banda trasnportadora.mbas,132 :: 		main:
;banda trasnportadora.mbas,133 :: 		OSCCON = %01110101
	MOVLW      117
	MOVWF      OSCCON+0
;banda trasnportadora.mbas,134 :: 		OPTION_REG=%11000101
	MOVLW      197
	MOVWF      OPTION_REG+0
;banda trasnportadora.mbas,135 :: 		INTCON = %11010000
	MOVLW      208
	MOVWF      INTCON+0
;banda trasnportadora.mbas,136 :: 		PIE1 = %00000000
	CLRF       PIE1+0
;banda trasnportadora.mbas,138 :: 		TRISA= %00000000
	CLRF       TRISA+0
;banda trasnportadora.mbas,139 :: 		TRISB= %00000001
	MOVLW      1
	MOVWF      TRISB+0
;banda trasnportadora.mbas,140 :: 		TRISC= %10000000
	MOVLW      128
	MOVWF      TRISC+0
;banda trasnportadora.mbas,142 :: 		ANSEL= %00000000
	CLRF       ANSEL+0
;banda trasnportadora.mbas,143 :: 		ANSELH= %00000010
	MOVLW      2
	MOVWF      ANSELH+0
;banda trasnportadora.mbas,146 :: 		Servo = 0x80
	MOVLW      128
	MOVWF      _Servo+0
;banda trasnportadora.mbas,147 :: 		T1CON = %00110001
	MOVLW      49
	MOVWF      T1CON+0
;banda trasnportadora.mbas,148 :: 		PIE1 = PIE1 OR %00000001
	BSF        PIE1+0, 0
;banda trasnportadora.mbas,149 :: 		TMR1L = 0xFF
	MOVLW      255
	MOVWF      TMR1L+0
;banda trasnportadora.mbas,150 :: 		TMR1H = 0xFF
	MOVLW      255
	MOVWF      TMR1H+0
;banda trasnportadora.mbas,151 :: 		paso = 0
	CLRF       _Paso+0
;banda trasnportadora.mbas,152 :: 		Salidas = 0xffff
	MOVLW      255
	MOVWF      _Salidas+0
	MOVLW      255
	MOVWF      _Salidas+1
;banda trasnportadora.mbas,153 :: 		n_servo = 0x0001
	MOVLW      1
	MOVWF      _n_servo+0
	CLRF       _n_servo+1
;banda trasnportadora.mbas,158 :: 		PIE1 = PIE1 or %00100000
	BSF        PIE1+0, 5
;banda trasnportadora.mbas,159 :: 		PIR1 = %00000000
	CLRF       PIR1+0
;banda trasnportadora.mbas,160 :: 		UART1_Init(9600)
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;banda trasnportadora.mbas,163 :: 		PORTA= %00000000
	CLRF       PORTA+0
;banda trasnportadora.mbas,164 :: 		PORTB= %00000000
	CLRF       PORTB+0
;banda trasnportadora.mbas,165 :: 		PORTC= %00000000
	CLRF       PORTC+0
;banda trasnportadora.mbas,167 :: 		Servo = 0xFF
	MOVLW      255
	MOVWF      _Servo+0
;banda trasnportadora.mbas,174 :: 		intensidad=1
	MOVLW      1
	MOVWF      _intensidad+0
;banda trasnportadora.mbas,175 :: 		muestras=0
	CLRF       _muestras+0
;banda trasnportadora.mbas,176 :: 		temp_ac=0
	CLRF       _temp_ac+0
;banda trasnportadora.mbas,177 :: 		temp_prom=0
	CLRF       _temp_prom+0
;banda trasnportadora.mbas,179 :: 		led()
	CALL       banda_32trasnportadora_led+0
;banda trasnportadora.mbas,181 :: 		while true
L__main8:
;banda trasnportadora.mbas,182 :: 		portb = 0x00
	CLRF       PORTB+0
;banda trasnportadora.mbas,199 :: 		Delay_ms(500)
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L__main12:
	DECFSZ     R13+0, 1
	GOTO       L__main12
	DECFSZ     R12+0, 1
	GOTO       L__main12
	DECFSZ     R11+0, 1
	GOTO       L__main12
	NOP
	NOP
;banda trasnportadora.mbas,200 :: 		wend
	GOTO       L__main8
	GOTO       $+0
; end of _main

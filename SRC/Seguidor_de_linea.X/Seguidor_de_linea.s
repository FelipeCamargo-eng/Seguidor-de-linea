;:**************************
  ;   ,-,--.   ,.---.      .-._        .=-.-.  _,.----.                  *
  ; ,-.'-  \ ,-.' , -  `. /==/ \  .-. /==/_ /.' .' -   \                 *
  ;/==/_ ,.'/==/,  ,  - \ |==|, \/ /, /==|, |/==/  ,  ,-'                 *
 ;\==\  \  |==|   .=.     |==|-  \|  ||==|  ||==|-   |  .                 *
  ;\==\ -\ |==|_ : ;=:  - |==| ,  | -||==|- ||==|_   `-' \                *
 ; _\==\ ,\|==| , '='     |==| -   _ ||==| ,||==|   _  , |                *
;/==/\/ _ |\==\ -    ,_ /|==|  /\ , ||==|- |\==\.       /                *
;\==\ - , / '.='. -   .' /==/, | |- |/==/. / `-.`._.-'                 *
 ;`--`---'    `--`--''   `--`./  `--``--`-`                              *
; ************************
; Description *                                                          *
; *                                                                      *
; Nombre de archivo: Seguidor linea Sonic                                *
; Fecha: 12/03/2021*                                                     *
; Versión de archivo: XC, PIC-as 2.31 *                                  *
; *                                                                      *
; Autor: Alejandro Tuberquia 2420182022 y Felipe Camargo 2420182012 *    *
; Universidad de Ibagué                                                  *
; *                                                                      *
; FDISPOSITIVO: P16F877A *                                               *
; **********************+***

PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS:
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
 
      ;Asignar ENTRADAS
    BSF TRISB, 0     ; PortB0  ENTRADA S1
    BSF TRISB, 1     ; PortB1  ENTRADA S2R
    BSF TRISB, 2     ; PortB2  ENTRADA S3L
    BSF TRISB, 3     ; PortB3  ENTRADA S4R
    BSF TRISB, 4     ; PortB0  ENTRADA S5L 
    ; Asignar SALIDAS
    BCF TRISC, 0     ; PortC1  SALIDA M1F
    BCF TRISC, 1     ; PortC2  SALIDA M2F
    BCF TRISC, 2     ; PortC3  SALIDA M1R
    BCF TRISC, 3     ; PortC4  SALIDA M2R
    BCF TRISC, 4     ; PortC5  SALIDA LED1R
    BCF TRISC, 5     ; PortC6  SALIDA LED2L
    BCF TRISC, 6     ; PortC7  SALIDA lED-STOP
   
   
    ;CLRF PORTC 
     BCF   STATUS, 5
MAIN:
    
    ;REGRESO A BANCO 0
    ;BCF   STATUS, 5  ; Banco 0
    MOVF PORTB, 0 
    MOVWF 0x20
    
    ;R21=S1
    
    MOVF 0x20,0
    ANDLW 0b00000001
    MOVWF 0x21    
    MOVF  0x21,0
    ANDLW 0b00000001
    MOVWF 0x21

    ;R22=!S1
    
    MOVF 0x20,0
    ANDLW 0b00000001
    MOVWF 0x22
    COMF  0X22,1         ;(NEGACION)
    MOVF  0x22,0
    ANDLW 0b00000001
    MOVWF 0x22
    
    ;R23=S2R
    
    MOVF 0x20,0
    ANDLW 0b00000010
    MOVWF 0x23
    RRF   0x23,1
    MOVF  0x23,0
    ANDLW 0b00000001
    MOVWF 0x23
    
    ;R24=!S2R
    
    MOVF 0x20,0
    ANDLW 0b00000010
    MOVWF 0x24
    RRF   0x24,1
    COMF  0X24,1         ;(NEGACION)
    MOVF  0x24,0
    ANDLW 0b00000001
    MOVWF 0x24

    ;R25=S3L
    
    MOVF 0x20,0
    ANDLW 0b00000100
    MOVWF 0x25
    RRF   0x25,1
    RRF   0x25,1
    MOVF  0x25,0
    ANDLW 0b00000001
    MOVWF 0x25
    
    ;R26=!S3L
    
    MOVF 0x20,0
    ANDLW 0b00000100
    MOVWF 0x26    
    RRF   0x26,1
    RRF   0x26,1
    COMF  0x26,0         ;(NEGACION)
    MOVF  0x26
    ANDLW 0b00000001
    MOVWF 0x26
    
    ;R27=S4R
    MOVF 0x20,0
    ANDLW 0b00001000
    MOVWF 0x27
    RRF   0x27,1
    RRF   0x27,1
    RRF   0x27,1    
    MOVF  0x27,0
    ANDLW 0b00000001
    MOVWF 0x27
    
    ;R28=!S4R
    
    MOVF 0x20,0
    ANDLW 0b00001000
    MOVWF 0x28
    RRF   0x28,1
    RRF   0x28,1
    RRF   0x28,1    
    COMF  0X28,1         ;(NEGACION)
    MOVF  0x28,0
    ANDLW 0b00000001
    MOVWF 0x28

    ;R29=S5L
    
    MOVF 0x20,0
    ANDLW 0b00010000
    MOVWF 0x29
    RRF   0x29,1
    RRF   0x29,1
    RRF   0x29,1
    RRF   0x29,1
    MOVF  0x29,0
    ANDLW 0b00000001
    MOVWF 0x29

    ;R30=!S5L
    
    MOVF 0x20,0
    ANDLW 0b00010000
    MOVWF 0x30
    RRF   0x30,1
    RRF   0x30,1
    RRF   0x30,1
    RRF   0x30,1
    COMF  0X30,1         ;(NEGACION)
    MOVF  0x30,0
    ANDLW 0b00000001
    MOVWF 0x30
    
    ;Primera Funcion karnaugh 1(MOTOR1 FORWARD)F=[(S1*!S2R)+(!S3L*S5L)+(S3L*!S4R)]
    
    ;R31 MULTIPLICACION ENTRE S1 Y !S2R( S1*!S2R)
    
    MOVF  0x21,0
    ANDWF 0x24,0
    MOVWF 0x31         ;(RESPUESTA)
    
    ;R32 MULTIPLICACION ENTRE !S3L Y S5L (!S3L*S5L)
    
    MOVF  0x26,0
    ANDWF 0x29,0
    MOVWF 0x32         ;(RESPUESTA)
    
    ;R33 MULTIPLICACION ENTRE S3L Y !S4R (S3L*!S4R)
    
    MOVF  0x25,0
    ANDWF 0x28,0
    MOVWF 0x33         ;(RESPUESTA)
    
    ;R34 SUMATORIA ENTRE R31,R32 Y R33 
    
    MOVF  0x31,0 
    IORWF 0x32,0
    IORWF 0x33,0 
    MOVWF 0x34          ;(RESPUESTA)*SALIDA FUNCION 1(MOTOR1 FORWARD)*
    
    
    ;Segunda  Funcion karnaugh 2(MOTOR2 FORWARD) F=[(S4R*!S5L)+(!S1*S2R)+(S1*!S3L)]
    
    ;R35 MULTIPLICACION ENTRE S4R Y !S5L (S4R*!S5L)
    
    MOVF  0x27,0
    ANDWF 0x30,0
    MOVWF 0x35         ;(RESPUESTA)
    
    ;R36 MULTIPLICACION ENTRE !S1 Y S2R (!S1*S2R)
    
    MOVF  0x22,0
    ANDWF 0x23,0
    MOVWF 0x36         ;(RESPUESTA)
    
    ;R37 MULTIPLICACION ENTRE S1 Y !S3L (S1*!S3L)
    
    MOVF  0x21,0
    ANDWF 0x26,0
    MOVWF 0x37         ;(RESPUESTA)
    
    ;R38 SUMATORIA ENTRE R35,R36 Y R37 
    
    MOVF  0x35,0 
    IORWF 0x36,0
    IORWF 0x37,0 
    MOVWF 0x38          ;(RESPUESTA)*SALIDA FUNCION 2(MOTOR2 FORWARD)*
    
    
    ;Tercera  Funcion karnaugh 3(MOTOR 1 reverse) F=[(!S3L*S4R)+(!S1*!S2R*!S3L*!S4R*!S5L)]
    
    ;R39 MULTIPLICACION ENTRE !S3L Y S4R (!S3L*S4R)
    
    MOVF  0x26,0
    ANDWF 0x27,0
    MOVWF 0x39         ;(RESPUESTA)
    
    ;R40 MULTIPLICACION ENTRE !S1,!S2R,!S3L,!S4R Y !S5L (S1*!S2R*!S3L*!S4R*!S5L)
    
    MOVF  0x22,0
    ANDWF 0x24,0
    ANDWF 0x26,0
    ANDWF 0x28,0
    ANDWF 0x30,0
    MOVWF 0x40          ;(RESPUESTA)
    
    ;R41 SUMATORIA ENTRE R39 Y R40
    
    MOVF  0x39,0 
    IORWF 0x40,0 
    MOVWF 0x41          ;(RESPUESTA)*SALIDA FUNCION 3(MOTOR1 REVERSE)*
    
    
    ;Cuarta   Funcion karnaugh 4(MOTOR 2 reverse) F=[(!S1*S5L)+(!S1*!S2R*!S3L*!S4R)]
   
    ;R42 MULTIPLICACION ENTRE !S1 Y S5L (!S1*S5L)
    
    MOVF  0x22,0
    ANDWF 0x29,0
    MOVWF 0x42         ;(RESPUESTA)
    
    ;R43 MULTIPLICACION ENTRE !S1,!S2R,!S3L,!S4R Y !S5L (S1*!S2R*!S3L*!S4R*!S5L)
    
    MOVF  0x22,0
    ANDWF 0x24,0
    ANDWF 0x26,0
    ANDWF 0x28,0
    MOVWF 0x43         ;(RESPUESTA)
    
    ;R44 SUMATORIA ENTRE R42 Y R43
    
    MOVF  0x42,0 
    IORWF 0x43,0 
    MOVWF 0x44          ;(RESPUESTA)*SALIDA FUNCION 4(MOTOR2 REVERSE)*
    
    
    ;Quinta    Funcion  karnaugh 5(LED 1 RIGHT) F=[(S4R*!S5L)+(S2R*!S3L)]
    
    ;R45 MULTIPLICACION ENTRE S2R Y !S3L (S2R*!S3L)
    
    MOVF  0x23,0
    ANDWF 0x26,0
    MOVWF 0x45         ;(RESPUESTA)
    
    ;R46 SUMATORIA ENTRE R35 Y R45
    
    MOVF  0x35,0 
    IORWF 0x45,0 
    MOVWF 0x46          ;(RESPUESTA)*SALIDA FUNCION 5(LED1 RIGHT)*
    
    
    ;Sexta    Funcion  karnaugh 6(LED 2 LETF) F=[(!S3L*S5L)+(S3L*!S4R)]
    
    ;R47 SUMATORIA ENTRE R32 Y R33
    
    MOVF  0x32,0 
    IORWF 0x33,0 
    MOVWF 0x47          ;(RESPUESTA)*SALIDA FUNCION 6(LED2 LEFT)*
    
    
    ;Septima   Funcion  karnaugh 7(LED-STOP) F=[(!S1*!S2R*!S3L*!S4R*!S5L)+(S4R*S5L)
    
    ;R48 MULTIPLICACION ENTRE S4R Y S5L (S4R*S5L)
    
    MOVF  0x27,0
    ANDWF 0x29,0
    MOVWF 0x48         ;(RESPUESTA)
    
    ;R49 SUMATORIA ENTRE R40 Y R48
    
    MOVF  0x40,0 
    IORWF 0x48,0 
    MOVWF 0x49          ;(RESPUESTA)*SALIDA FUNCION 7(LED-STOP)*

;*********SALIDAS ********************************
    
   ; CLRF   PORTC
    M1:
    BTFSC 0x34,0 
    GOTO ONM1 
   GOTO OFFM1
	ONM1:		;*SALIDA FUNCION 1(MOTOR1 FORWARD)*
    BSF PORTC,0
  GOTO M2
   
     OFFM1:
    BCF PORTC,0 
    GOTO M2
    M2:
      BTFSC 0x38,0  
	GOTO ONM2
	GOTO OFFM2
	ONM2:				;*SALIDA FUNCION 2(MOTOR2 FORWARD)*
   BSF PORTC,1	
    GOTO M1R
    OFFM2: 
            BCF PORTC,1
	GOTO M1R
	M1R:
	BTFSC 0x41,0 
	GOTO ONM1R
	GOTO OFFM1R
	ONM1R:					;*SALIDA FUNCION 3(MOTOR1 REVERSE)*
    BSF PORTC,2
    GOTO M2R
    OFFM1R:
    BCF PORTC,2
    GOTO M2R 
    M2R: 
    BTFSC 0x44,0 
    GOTO ONM2R
    GOTO OFFM2R   ;*SALIDA FUNCION 4(MOTOR2 REVERSE)*
    ONM2R:				    
    BSF PORTC,3
    GOTO LED1R 
    OFFM2R:
    BCF PORTC,3
    GOTO LED1R
    LED1R:
    BTFSC 0x46,0  
    GOTO ONLED1R
    GOTO OFFLED1R
    ONLED1R:			;*SALIDA FUNCION 5(LED1 RIGHT)*
    BSF PORTC,4
    GOTO LED2L ;MAIN
    OFFLED1R:
    BCF PORTC,4
    GOTO LED2L
    
    LED2L:
    BTFSC 0x47,0 
    GOTO ONLED2L
    GOTO OFFLED2L
    ONLED2L:		    ;*SALIDA FUNCION 6(LED2 LEFT)*
    BSF PORTC,5
    GOTO LEDSTOP
    OFFLED2L:
    BCF PORTC,5
    GOTO LEDSTOP
    LEDSTOP:
    BTFSC 0x49,0
	GOTO ONLEDSTOP
	GOTO OFFLEDSTOP
	ONLEDSTOP:			;*SALIDA FUNCION 7(LED-STOP)*
    BSF PORTC,6	
    GOTO MAIN
    OFFLEDSTOP:
    BCF PORTC,6
    GOTO MAIN
    
    
END resetVec


#include <P18F4620.inc>
            
            config OSC = INTIO67
            config WDT = OFF
            config LVP = OFF
            config BOREN = OFF

            ORG     0x0000
Result      EQU     0x20
Input_A     EQU     0x21

START:

            MOVLW   0x0F            ; Load W with 0x0F
            MOVWF   ADCON1          ; Make ADCON1 to be all digital

            MOVLW   0xFF            ; Load W with 0xFF
            MOVWF   TRISA           ; Set PORT A as all inputs

            MOVLW   0x00            ; Load W with 0x00
            MOVWF   TRISB           ; Set PORT B as all outputs

            MOVLW   0x00            ; Load W with 0x00
            MOVWF   TRISE           ; Set PORT E as all outputs

MAIN_LOOP:

            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            COMF    Input_A, 0      ; Complement data at Input_A and store to W

            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB
            
            BZ      ZERO
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            GOTO    MAIN_LOOP       ; Loop forever
ZERO:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            GOTO    MAIN_LOOP       ; Loop forever
            END
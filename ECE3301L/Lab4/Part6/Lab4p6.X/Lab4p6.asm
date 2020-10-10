#include <P18F4620.inc>
            
            config OSC = INTIO67
            config WDT = OFF
            config LVP = OFF
            config BOREN = OFF

            ORG     0x0000
Result      EQU     0x20
Input_A     EQU     0x21
Input_C     EQU     0x22

START:

            MOVLW   0x0F            ; Load W with 0x0F
            MOVWF   ADCON1          ; Make ADCON1 to be all digital

            MOVLW   0xFF            ; Load W with 0xFF
            MOVWF   TRISA           ; Set PORT A as all inputs

            MOVLW   0x00            ; Load W with 0x00
            MOVWF   TRISB           ; Set PORT B as all outputs

            MOVLW   0xFF            ; Load W with 0xFF
            MOVWF   TRISC           ; Set PORT C as all inputs

            MOVLW   0x00            ; Load W with 0x00
            MOVWF   TRISE           ; Set PORT E as all outputs

MAIN_LOOP:

            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            MOVF    PORTC, W        ; Read from PORT C and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_C         ; Move from W to Input_C (0x22)

            MOVLW   0x0A            ; Load W with 0x0A
            CPFSLT  Input_A         ; Compare Input_A against W and skip next line
                                    ; if Input_A < W = 0x0A = 10 i.e. valid
            GOTO    INVALIDBCD      ; invalid BCD (>= 10) => INVALIDBCD
            XORWF   WREG, W         ;   valid BCD ( < 10) => clear WREG
            GOTO    ADD_A           ; jump to ADD_A
INVALIDBCD: MOVLW   0x06            ; invalid BCD, pad 6
ADD_A:      ADDWF   Input_A, W      ; add A to W

            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB

            BZ      ZERO
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            GOTO    MAIN_LOOP       ; Loop forever
ZERO:
            BSF     PORTE, 0        ; Zero,     set   bit 0 of PORTE
            GOTO    MAIN_LOOP       ; Loop forever
            END
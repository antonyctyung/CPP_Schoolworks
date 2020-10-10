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
            MOVWF   TRISC           ; Set PORT C as all inputs

            MOVLW   0x00            ; Load W with 0x00
            MOVWF   TRISB           ; Set PORT B as all outputs
            MOVWF   TRISE           ; Set PORT E as all outputs

            MOVLW   0x07            ; Load W with 0x07
            MOVWF   TRISD           ; Set PORT D as input for lowest 3 bits

MAIN_LOOP:
            ; Test cases
            BTFSC   PORTD,2         ; Test if PORTD bit 2 is set
            GOTO    CASE1XX         ; PORTD bit 2 is set => CASE1XX
CASE0XX:    BTFSC   PORTD,1         ; Test if PORTD bit 1 is set
            GOTO    CASE01X         ; PORTD bit 1 is set => CASE01X
CASE00X:    BTFSS   PORTD,0         ; Test if PORTD bit 0 is clear
CASE000:    GOTO    TASK_COMP       ; PORTD input 000    => COMP
CASE001:    GOTO    TASK_ADD        ; PORTD input 001    => ADD
CASE01X:    BTFSS   PORTD,0         ; Test if PORTD bit 0 is clear
CASE010:    GOTO    TASK_AND        ; PORTD input 010    => AND
CASE011:    GOTO    TASK_XOR        ; PORTD input 001    => XOR
CASE1XX:    BTFSC   PORTD,1         ; Test if PORTD bit 1 is set
CASE11X:    GOTO    MAIN_LOOP       ; PORTD input 11X    => start of loop
CASE10X:    BTFSS   PORTD,0         ; Test if PORTD bit 0 is clear
CASE100:    GOTO    TASK_BCD        ; PORTD input 100    => TASK_BCD
            GOTO    MAIN_LOOP       ; Default case       => start of loop

TASK_COMP:                          ; PORTD lowest 3 bits = 000
            BCF     PORTD, 5        ; Clear PORTD bit 5
            BCF     PORTD, 4        ; Clear PORTD bit 4
            BCF     PORTD, 3        ; Clear PORTD bit 3
            CALL    SUBROUTINE_COMP ; Call subroutine to perform operations
            GOTO    MAIN_LOOP       ; Back to main loop

TASK_ADD:                           ; PORTD lowest 3 bits = 001
            BCF     PORTD, 5        ; Clear PORTD bit 5
            BCF     PORTD, 4        ; Clear PORTD bit 4
            BSF     PORTD, 3        ; Set   PORTD bit 3
            CALL    SUBROUTINE_ADD  ; Call subroutine to perform operations
            GOTO    MAIN_LOOP       ; Back to main loop

TASK_AND:                           ; PORTD lowest 3 bits = 010
            BCF     PORTD, 5        ; Clear PORTD bit 5
            BSF     PORTD, 4        ; Set   PORTD bit 4
            BCF     PORTD, 3        ; Clear PORTD bit 3
            CALL    SUBROUTINE_AND  ; Call subroutine to perform operations
            GOTO    MAIN_LOOP       ; Back to main loop

TASK_XOR:                           ; PORTD lowest 3 bits = 011
            BCF     PORTD, 5        ; Clear PORTD bit 5
            BSF     PORTD, 4        ; Set   PORTD bit 4
            BSF     PORTD, 3        ; Set   PORTD bit 3
            CALL    SUBROUTINE_XOR  ; Call subroutine to perform operations
            GOTO    MAIN_LOOP       ; Back to main loop

TASK_BCD:                           ; PORTD lowest 3 bits = 100
            BSF     PORTD, 5        ; Set   PORTD bit 5
            BCF     PORTD, 4        ; Clear PORTD bit 4
            BCF     PORTD, 3        ; Clear PORTD bit 3
            CALL    SUBROUTINE_BCD  ; Call subroutine to perform operations
            GOTO    MAIN_LOOP       ; Back to main loop

SUBROUTINE_COMP:                    ; PORTD lowest 3 bits = 000
            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            COMF    Input_A, 0      ; Complement data at Input_A and store to W
            
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB

            BZ      ZERO0
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            RETURN

ZERO0:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            RETURN


SUBROUTINE_ADD:                     ; PORTD lowest 3 bits = 001
            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            MOVF    PORTC, W        ; Read from PORT C and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_C         ; Move from W to Input_C (0x22)

            ADDWF   Input_A, W      ; Add data in Input_A with W and store at W
            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB

            BZ      ZERO1
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            RETURN
ZERO1:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            RETURN

SUBROUTINE_AND:                     ; PORTD lowest 3 bits = 010
            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            MOVF    PORTC, W        ; Read from PORT C and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_C         ; Move from W to Input_C (0x22)

            ANDWF   Input_A, W      ; AND data in Input_A with W and store at W
            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB

            BZ      ZERO2
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            RETURN
ZERO2:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            RETURN

SUBROUTINE_XOR:                     ; PORTD lowest 3 bits = 011
            MOVF    PORTA, W        ; Read from PORT A and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_A         ; Move from W to Input_A (0x21)

            MOVF    PORTC, W        ; Read from PORT C and move it into W
            ANDLW   0x0F            ; Mask with 0x0F
            MOVWF   Input_C         ; Move from W to Input_C (0x22)

            XORWF   Input_A, W      ; XOR data in Input_A with W and store at W

            MOVWF   Result          ; Move from W to Result  (0x20)
            MOVFF   Result, PORTB   ; Move from Result (0x20) to PORTB

            BZ      ZERO3
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            RETURN
ZERO3:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            RETURN
	    
SUBROUTINE_BCD:                     ; PORTD lowest 3 bits = 100
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

            BZ      ZERO4
            BCF     PORTE, 0        ; Not zero, clear bit 0 of PORTE
            RETURN

ZERO4:
            BSF     PORTE, 0        ; Zero,     set bit 0 of PORTE
            RETURN

            END
INCLUDE <P18F4620.INC>
SUM	EQU	0x50
	ORG	0x100
	
	; A7 - A7 = A7 + (-A7) = 1010 0111 + ( -1010 0111 ) 
	;		       = 1010 0111 + 0101 1001 = A7 + 59 = 00
			; f p  D
			; 1 1111 111	carry
	MOVLW	0xA7	;   1010 0111	minuend
	ADDLW	0x59	;  +0101 1001	subtrahend
			; ------------
	MOVWF	SUM	; = 0000 0000	difference
			;   N
	; N  = 0		   = 0
	; OV = Cf XOR Cp = 1 XOR 1 = 0
	; Z  = 1 (zero result)	   = 1
	; DC = 1		   = 1
	; C  = Cf		   = 1
	; STATUS = 000(N)(OV)(Z)(DC)(C) = 0000 0111
	NOP		
	
	; 6E + 3A = 0110 1110 + 0011 1010 = A8
			; f p  D
			; 0 1111 110	carry
	MOVLW	0x6E	;   0110 1110	augend
	ADDLW	0x3A	; + 0011 1010	addend
			; ------------
	MOVWF	SUM	; = 1010 1000	sum
			;   N
	; N  = 1		   = 1
	; OV = Cf XOR Cp = 0 XOR 1 = 1
	; Z  = 0 (non-zero result) = 0
	; DC = 1		   = 1
	; C  = Cf		   = 0
	; STATUS = 000(N)(OV)(Z)(DC)(C) = 0001 1010
	NOP
	END
		.text
		.equ HEX1, 0xFF200020
		.equ HEX2, 0xFF200030	
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM

HEX_clear_ASM:
		LDR R1, =HEX1
		LDR R2, =HEX2		
		LDR R3, [R1]
		LDR R4, [R2]
		
		TST R0, #0x01
		ANDNE R3, R3, #0xFFFFFF00
		TST R0, #0x02
		ANDNE R3, R3, #0xFFFF00FF	
		TST R0, #0x04
		ANDNE R3, R3, #0xFF00FFFF
		TST R0, #0x08
		ANDNE R3, R3, #0x00FFFFFF

		TST R0, #0x10
		ANDNE R4, R4, #0xFFFFFF00
		TST R0, #0x20
		ANDNE R4, R4, #0xFFFF00FF

		STR R3, [R1]
		STR R4, [R2] 

		BX LR

HEX_flood_ASM:
		LDR R1, =HEX1
		LDR R2, =HEX2
		
		LDR R5, [R1]
		TST R0, #0x01
		ORRNE R5, R5, #0x000000FF
		TST R0, #0x02
		ORRNE R5, R5, #0x0000FF00
		TST R0, #0x04
		ORRNE R5, R5, #0x00FF0000
		TST R0, #0x08
		ORRNE R5, R5, #0xFF000000

		LDR R6, [R2]
		TST R0, #0x10
		ORRNE R6, R6, #0x000000FF
		TST R0, #0x20
		ORRNE R6, R6, #0x0000FF00

		STR R5, [R1]
		STR R6, [R2] 

		BX LR

HEX_write_ASM:					//we know that R0 holds a hot-one encoding of which HEX display, R1 holds the character value
		MOV R10, R0
		MOV R9, R1
		PUSH {R1-R8,LR}
		BL HEX_clear_ASM		//we have to clear the display we have before doing anything on it
		POP {R1-R8,R14}
		MOV R0, R10
		
		PUSH {R1-R8,LR}
		LDR R1, =HEX1		//put location of the HEX3-0 register into R0
		MOV R3, #0				//this is our counter for which hex counts
		B DISPLAY_0

// We start comparing at 48 for the write subroutine 
// in order to account for the ASCII offset

DISPLAY_0:
		CMP R9, #48
		BNE DISPLAY_1
		MOV R5, #0x3F
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_1:	
		CMP R9, #49
		BNE DISPLAY_2
		MOV R5, #0x06
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_2:	
		CMP R9, #50
		BNE DISPLAY_3
		MOV R5, #0x5B
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_3:	
		CMP R9, #51
		BNE DISPLAY_4
		MOV R5, #0x4F
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_4:	
		CMP R9, #52
		BNE DISPLAY_5
		MOV R5, #0x66
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_5:	
		CMP R9, #53
		BNE DISPLAY_6
		MOV R5, #0x6D
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_6:	
		CMP R9, #54
		BNE DISPLAY_7
		MOV R5, #0x7D
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_7:	
		CMP R9, #55
		BNE DISPLAY_8
		MOV R5, #0x07
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_8:	
		CMP R9, #56
		BNE DISPLAY_9
		MOV R5, #0x7F
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_9:	
		CMP R9, #57
		BNE DISPLAY_A
		MOV R5, #0x6F
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_A:	
		CMP R9, #58
		BNE DISPLAY_B
		MOV R5, #0x77
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_B:	
		CMP R9, #59
		BNE DISPLAY_C
		MOV R5, #0x7C
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_C:	
		CMP R9, #60
		BNE DISPLAY_D
		MOV R5, #0x39
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_D:	
		CMP R9, #61
		BNE DISPLAY_E
		MOV R5, #0x5E
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_E:	
		CMP R9, #62
		BNE DISPLAY_F
		MOV R5, #0x79
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_F:	
		CMP R9, #63
		BNE DISPLAY_OFF
		MOV R5, #0x71
		MOV R8, R5
		B HEX_write_LOOP

DISPLAY_OFF:
		MOV R5, #0
		MOV R8, R5
		B HEX_write_LOOP
		
HEX_write_LOOP:
		CMP R3, #6				
		BEQ HEX_write_CORRECT	

		AND R4, R0, #1			
		CMP R4, #1				
		BEQ HEX_write_CORRECT	
							
		ASR R0, R0, #1		
		ADD R3, R3, #1			
		B HEX_write_LOOP		
		
HEX_write_CORRECT:
		CMP R3, #3				
		SUBGT R3, R3, #4		
		LDRGT R1, =HEX2	
		LDR R2, [R1]
		MOV R5, R8				
		B HEX_write_LOOP2		

HEX_write_LOOP2:
		CMP R3, #0				
		BEQ HEX_write_DONE	
		LSL R5, R5, #8			
		SUB R3, R3, #1			
		B HEX_write_LOOP2

HEX_write_DONE:
		ORR R2, R2, R5			
		STR R2, [R1]		
		POP {R1-R8,LR}
		BX LR
		.end

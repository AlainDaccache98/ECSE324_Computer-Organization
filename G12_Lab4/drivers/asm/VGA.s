	.text
	
	.equ VGA_PIXEL_BUF_BASE, 0xC8000000
	.equ VGA_CHAR_BUF_BASE, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM

// Each pixel has location: address base + (x,y)offset
VGA_clear_pixelbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_PIXEL_BUF_BASE		// base address
	MOV R0, #0

PIXEL_LOOPX:						// iterate column by column
	MOV R1, #0
	ADD R4, R3, R0, LSL #1			 // we LSL by 1 because address for x starts after the first bit

PIXEL_LOOPY:						// iterate row by row
	ADD R5, R4, R1, LSL #10			// we LSL by 10 because address for y starts at 10th bit position
	
	STRH R2, [R5]
	
	ADD R1, R1, #1
	CMP R1, #240				
	BLT PIXEL_LOOPY					// still in same column
	
	ADD R0, R0, #1
	CMP R0, #320		
	BLT PIXEL_LOOPX					// go to next row

	POP {R4-R5}
	BX LR

VGA_clear_charbuff_ASM:
	PUSH {R4-R5}	
	MOV R2, #0
	LDR R3, =VGA_CHAR_BUF_BASE
	MOV R0, #0

CHAR_LOOPX:
	MOV R1, #0
	ADD R4, R3, R0, LSL #1 

CHAR_LOOPY:				
	ADD R5, R4, R1, LSL #7 
							
	STRH R2, [R5]
	
	ADD R1, R1, #1
	CMP R1, #60
	BLT CHAR_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #80
	BLT CHAR_LOOPX

	POP {R4-R5}
	BX LR

VGA_write_byte_ASM:					//R0, R1, R2 are x, y and char

	PUSH {R3-R7}
	CMP R0, #79
	BXGT LR
	CMP R1, #59
	BXGT LR
	
	LDR R3, =VGA_CHAR_BUF_BASE
	ADD R3, R3, R0
	LSL R1, R1, #7


	ADD R3, R3, R1					//R3 contains the address where we want to inject stuff
	LSR R4, R2, #4					//get most significant hex in R4					
	LSL R6, R4, #4					//get least significant hex in R5
	SUB R5, R2, R6					//the least significant hex in R5
	
	CMP R4, #9
	ADDGT R4, R4, #7
	CMP R5, #9	
	ADDGT R5, R5, #7
	ADD R4, R4, #48
	ADD R5, R5, #48
	
	STRB R4, [R3]
	ADD R3, R3, #1
	STRB R5, [R3]
	POP {R3-R7}
	BX LR
	
VGA_write_char_ASM:

	LDR R3, =79  
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #59
	BXGT LR
	
	LDR R3, =VGA_CHAR_BUF_BASE		//we create pointer to addre of vga char buff base
	ADD R3, R3, R0					//shift the x, y by correct amount, to add to base addre
	ADD R3, R3, R1, LSL #7			//so we can write to the correct mem address/grid position
	STRB R2, [R3]					//we store as a byte
	BX LR

VGA_draw_point_ASM:

	LDR R3, =319  //these lines below check that were still in the grid!! Otherwise we branch out
	CMP R0, #0
	BXLT LR
	CMP R1, #0
	BXLT LR
	CMP R0, R3
	BXGT LR
	CMP R1, #239
	BXGT LR
	
	LDR R3, =VGA_PIXEL_BUF_BASE // we load address/create pointer
	ADD R3, R3, R0, LSL #1		//add x, y position into address, to get correct grid
	ADD R3, R3, R1, LSL #10		//then we store the data/pixel color as half word into the right/current grid position
	STRH R2, [R3]
	BX LR

HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	//      0     1     2     3     4     5     6     7     8     9     A     B     C     D     E     F  // 

	.end
	

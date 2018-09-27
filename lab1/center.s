					.text
					.global _start

_start: 
					MOV R1, #0							// Register to increment (the logarithm) in the LOOP_LOGARITHM branch, to eventually store in R5
					LDR R2, N
					LDR R4, =RESULT_CURRENTSUM 			// Current sum
					LDR R5, =RESULT_LOGARITHM			// Holds the address of the result_logarithm
					LDR R6, N							// Number of entries for LOOP_LOGARITHM (need a copy of N to iterate, and another to keep dividing it by 2 until we reach 1
					LDR R7, =RESULT_AVERAGE				// Holds the average
					MOV R8, #0							// Register to add the sum of the numbers to later store in R4
					MOV R9, #0							// Register to hold the value of the average to later store in R7
					ADD R3, R4, #16						// Pointer

LOOP_LOGARITHM:
					SUBS R2, R2, #1
					BEQ LOOP_ADDITION
					LSR R6, R6, #1						// Divide by 2
					ADD R1, R1, #1
					CMP R6, #1
					BEQ INTER1
					B LOOP_LOGARITHM
					
INTER1:				STR R1, [R5]
					LDR R2, N							// Resetting the register that holds N to use it as a counter for LOOP_ADDITION branch
					MOV R0, #0
					B LOOP_ADDITION

LOOP_ADDITION: 
					SUBS R2, R2, #1
					BLT INTER2
					LDR R8, [R3]
					ADD R0, R0, R8
					ADD R3, R3, #4
					B LOOP_ADDITION

INTER2:				STR R0, [R4]
					B AVERAGE

AVERAGE: 
					LDR R11, [R4]
					LDR R12, [R5]
					LSR R10, R11, R12
					STR R10, [R7]
					B INTER3

INTER3:				LDR R2, N
					MOV R3, #0
					LDR R4, =RESULT_CURRENTSUM
					ADD R3, R4, #16
					B LOOP_SUBTRACTION

LOOP_SUBTRACTION:	SUBS R2, R2, #1
					BLT END				
					LDR R9, [R3]
					SUB R9, R9, R10
					STR R9, [R3]
					ADD R3, R3, #4
					B LOOP_SUBTRACTION
					 
END:				
					//LDR R4, =RESULT_CURRENTSUM
					//ADD R3, R4, #16
					//LDR R0, [R3]
					//ADD R3, R3, #28
					//LDR R1, [R3]
					B END								// infinite loop!					
					
RESULT_CURRENTSUM:  .word   0
RESULT_AVERAGE:     .word   0
RESULT_LOGARITHM:	.word   0
N:					.word	8							// Number of entries in the list
NUMBERS: 			.word	9, 5, 3, 6, 5, 4, 8, 8 					        // the list data

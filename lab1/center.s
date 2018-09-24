					.text
					.global _start

_start: 
					LDR R1, =RESULT_CENTERED
					LDR R2, N
					ADD R3, R1, #8						// Pointer
					LDR R4, #0 							// Current sum
					LDR R5, #0							// Log of the number of entries
					LDR R6, N							// Number of entries for LOOP_LOGARITHM (need a copy of N to iterate, and another to keep dividing it by 2 until we reach 1
					LDR R7, #0							// Holds the average

LOOP_LOGARITHM:
					SUBS R2, R2, #1
					LSR R6, R6, #1						// Divide by 2
					ADD R5, R5, #1
					CMP R6, #1
					BEQ LOOP_ADDITION
					B LOOP_LOGARITHM
					
LOOP_ADDITION: 
					LDR R2, N
					SUBS R2, R2, #1
					BEQ AVERAGE
					ADD R4, R4, [R3]
					ADD R3, R3, #4
					B LOOP_ADDITION

AVERAGE: 
					LSR R7, R4, R5
					 
END:				B END								// infinite loop!					
					
					
					


RESULT_CENTERED: 	.word 	0, 0, 0, 0, 0, 0, 0 		// Result of the centered signal 
N:					.word	4							// Number of entries in the list
NUMBERS: 			.word	4, 5, 3, 6 					// the list data

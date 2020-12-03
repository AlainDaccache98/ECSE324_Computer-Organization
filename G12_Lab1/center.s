					.text
					.global _start

_start: 
					MOV R1, #0							// Register to increment (the logarithm) in the LOOP_LOGARITHM branch, to eventually store in R5
					LDR R2, N							// R2 stores the number of elements
					LDR R4, =RESULT_CURRENTSUM 			// R4 holds the address of RESULT_CURRENTUSUM
					LDR R5, =RESULT_LOGARITHM			// R5 holds the address of the RESULT_LOGARITHM
					LDR R6, N							// Number of entries for LOOP_LOGARITHM (need a copy of N to iterate, and another to keep dividing it by 2 until we reach 1)
					LDR R7, =RESULT_AVERAGE				// Holds the average
					MOV R8, #0							// Register to add the sum of the numbers to later store in R4
					MOV R9, #0							// Register to hold the value of the average to later store in R7
					ADD R3, R4, #16						// R3 points to the first number

LOOP_LOGARITHM:
					SUBS R2, R2, #1						// Decrement the counter
					BEQ LOOP_ADDITION					// If counter is 0, logarithm 
					LSR R6, R6, #1						// Divide the number of elements by 2
					ADD R1, R1, #1						// R1 is incremented. NB: counts the number of times we are dividing the number of elements by 2 until we reach 1 (i.e. log)
					CMP R6, #1							// Did the number of elements reach 1?
					BEQ INTER1							// If yes, then go to next step (add the numbers)
					B LOOP_LOGARITHM					// If no, then we can still divide, so branch back to LOOP_LOGARITHM
					
INTER1:				STR R1, [R5]						// Storing the logarithm in R1
					LDR R2, N							// Resetting the register that holds N to use it as a counter for LOOP_ADDITION branch
					MOV R0, #0							// 
					B LOOP_ADDITION						// Branching to loop addition

LOOP_ADDITION: 
					SUBS R2, R2, #1						// Decrement the counter
					BLT INTER2							// If R2 = 0, go to the next step i.e. compute average
					LDR R8, [R3]						// R8 stores the current number to add to the current sum
					ADD R0, R0, R8						// Add the content of R8 in the current sum
					ADD R3, R3, #4						// Point to the next number
					B LOOP_ADDITION						// Branch back to LOOP_ADDITION

INTER2:				STR R0, [R4]						// Store the sum of the numbers in R4
					B AVERAGE							// Branch to AVERAGE

AVERAGE: 
					LDR R11, [R4]						// R11 stores the sum of the numbers
					LDR R12, [R5]						// R12 stores the logarithm of the number of elements
					LSR R10, R11, R12					// Right shift R11 (the sum) by R12 (the logarithm) and store in R10 
					STR R10, [R7]						// Store R10 in the address pointed to by R7
					B INTER3							// Branching to INTER3

INTER3:				LDR R2, N							// Resetting R2 to use in the next loop
					MOV R3, #0							// Resetting R3 to point to the first element
					LDR R4, =RESULT_CURRENTSUM			
					ADD R3, R4, #16
					B LOOP_SUBTRACTION					// Branch to LOOP_SUBTRACTION

LOOP_SUBTRACTION:	SUBS R2, R2, #1						// Decrement counter
					BLT END								// If R2 = 0, branch to END
					LDR R9, [R3]						// Load the current element pointed to by R3 into R9
					SUB R9, R9, R10						// Subtract R10 (the average) from R9 (the current element)
					STR R9, [R3]						// Store it in the address pointed to by R3 i.e. in place
					ADD R3, R3, #4						// Point to the next number
					B LOOP_SUBTRACTION					// Branch back to LOOP_SUBTRACTION
					 
END:				
					B END								// infinite loop!					
					
RESULT_CURRENTSUM:  .word   0
RESULT_AVERAGE:     .word   0
RESULT_LOGARITHM:	.word   0
N:					.word	8							// Number of entries in the list
NUMBERS: 			.word	9, 5, 3, 6, 5, 4, 8, 8 					// the list data

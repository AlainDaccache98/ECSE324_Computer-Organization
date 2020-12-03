			.text
			.global _start

_start:
			LDR R1, =RESULT_STDDEV	// R1 points to the standard deviation result location
			LDR R2, =RESULT_MIN		// R2 points to the minimum number result location
			LDR R3, =RESULT_MAX		// R3 points to the maximum number result location
			LDR R4, N 				// R4 holds the number of elements in the list
			ADD R5, R1, #16 		// R5 points to the first number
			LDR R6, [R5] 	    	// R6 holds the first number in the list. Assume that it's the current max
			LDR R7, [R5]        	// R7 holds the first number in the list. Assume that it's the current min

LOOP_MAX:	SUBS R4, R4, #1			// Decrement the loop counter
			BEQ INTER				// go to the INTER section if counter has reached 0
			ADD R5, R5, #4			// R5 points to the next number in the list
			LDR R0, [R5]			// R0 holds the next number in the list
			CMP R6, R0				// Check if it is greater than the maximum
			BGE LOOP_MAX			// If no, branch back to the loop
			MOV R6, R0				// If yes, update the current max
			B LOOP_MAX 				// Branch back to the loop
			
INTER:	 	STR R6, [R3]			// Storing the maximum number result in the corresponding memory location 
			LDR R4, N				// Resetting the counter to the number of elements
			ADD R5, R1, #16			// Resetting R5 to point to the first number

LOOP_MIN:	SUBS R4, R4, #1			// Decrement the loop counter
			BEQ CALC				// go to the CALC section if counter has reached 0
			ADD R5, R5, #4			// R5 points to the next number in the list
			LDR R0, [R5]			// R0 holds the next number in the list
			CMP R7, R0				// Compare contents in R7 to those in R0
			BLE LOOP_MIN			// If R7 is less than R0, branch back to the loop
			MOV R7, R0				// Else, update the current min
			B LOOP_MIN
			
			STR R7, [R2]			// store the minimum number result to the corresponding memory location


CALC:		SUBS R8, R6, R7    	 	// subtract the min from the max and store in register 8		
			LSR R8, R8, #2			// Shift right by 2 bits

DONE:		STR R8, [R1]			// store the standard deviation result to the correpsonding memory location 

END:		B END					// infinite loop!

RESULT_STDDEV: 		.word 	0 		// Result of the range-rule operation 
RESULT_MIN:			.word 	0		// Result of the minimum value in the list
RESULT_MAX:			.word 	0		// Result of the maximum value in the list
N:					.word	7		// Number of entries in the list
NUMBERS: 			.word	4, 5, 3, 6 // the list data
					.word	1, 8, 2

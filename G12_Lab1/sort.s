				.text
				.global _start

_start:
				LDR R0, =N				// R0 stores the location of the number of elements		
				MOV R1, #0				// sorted = false
										// R2 is a pointer, intialized in the main loop to reset it to the first element for the next iteration
										// R3 and R4 will store the two elements of the list of compare
										// R5 is a counter intialized in the main loop to reset it for the next iteration
				MOV R6, #0				// R6 will act as a temporary storage space for the swap operation
				B MAIN_LOOP				// Branching to the outer loop

MAIN_LOOP:		MOV R2, #0
				ADD R2, R0, #4			// R2 points to the first element in the list of numbers
				LDR R5, [R0]		    // R5 acts as a counter for the loop
				CMP R1, #0				// Is sorted = false?
				BEQ SWITCH				// If yes, then branch to SWITCH
				B END					// If no, then it is sorted and we are done

SWITCH: 		MOV R1, #1				// sorted = true
				B SUB_LOOP				// Branching to the inner loop

SUB_LOOP:		SUBS R5, R5, #1			// increment the counter
				BEQ MAIN_LOOP			// branching back the the outer loop
				LDR R3, [R2]			// Load the content of the location pointed to by R2 i.e. A[i-1]
				ADD R2, R2, #4			// Increment R2 so it points to the next number
				LDR R4, [R2]			// Load the content of the next number relative to R3 i.e. A[i]
				CMP R3, R4				// Is A[i-1] > A[i]?
				BGT SWAP				// If yes, then swap elements
				B SUB_LOOP				// If no, then branch back to SUB_LOOP

SWAP:			MOV R6, R3			// temporarily store R3 in R6 to remember its value when moving R4 into R3
				MOV R3, R4				// R3 = R4
				MOV R4, R6				// R4 = R6 (previous R3)
				MOV R6, #0				// clear R6
				SUB R2, R2, #4			// pointing to the previous element to store the lesser number in it
				STR R3, [R2]
				ADD R2, R2, #4
				STR R4, [R2]
				MOV R1, #0				// sorted = false
				B SUB_LOOP				// branch back to the sub loop

END:			B END

N:				.word	4
NUMBERS:		.word	4, 1, 3, 2

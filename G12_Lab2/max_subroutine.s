			.text
			.global _start

_start: 
			LDR R0, N  	// R0 is given the value of the numvber of elements in the list
			LDR R1, =NUMBERS 			// R1 point to the list NUMBERS
			LDR R2, [R1]		// Loadd the first element in NUMBERS assuming it is the current max
			BL FIND_MAX			// Go to FIND_MAX loop 
			STR R2, RESULT		// Storing the max in R0
			POP {LR}		// popping the values bacl to the registers


STOP:
			B STOP
			
FIND_MAX:
			PUSH {LR}		// pushing the changes on the stack 
LOOP:
			SUBS R0, R0, #1		// decrement the loop counter
			BEQ END			// exit the subroutine once counter reaches 
			ADD R1, R1, #4 		// R0 points to next number in the list 
			LDR R3, [R1] 		// R3 holds the next number in the list
			CMP R2, R3 			// check if it is greater than the maximum
			BGE LOOP 			// if no, branch back to the loop
			MOV R2, R3 			// if yes, update the current max
			B LOOP			// branch back to the loop

END: 		
			BX LR			// PC points to the instruction after the call


N:					.word	7		// Number of entries in the list
NUMBERS: 			.word	4, 5, 3, 6 // the list data
					.word	1, 9, 2
RESULT:				.word 	0

					.end
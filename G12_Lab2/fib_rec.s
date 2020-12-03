.text
			.global _start
		
_start:
			LDR R1, N 			//R0 is the pointer to the number
			PUSH {R4, LR} 		//Pushing R6 b/c will manipulate its value and then need to restore it
			BL FIBONACCI
			POP {R4, LR}
			B END

FIBONACCI:	
			CMP R1, #2			// if (R1 < 2)
			BLT BASE			// Base Case
			
			SUB R1, R1, #2 		//Doing this to get Fib(n-2)
			PUSH {LR} 			//Store value of LR when fibonacci was first called by main program to be able to do (n-2) after. Fib(n-2) in R0
			BL FIBONACCI 		//Perform Fib(n-2)
			POP {LR} 			//Restore LR to same value as when fibonacci was first called by main program to be able to return to main program
			
			ADD R1, R1, #1 		//Doing this to get Fib(n-1)
			PUSH {R0, LR} 		//Store Fib(n-2) on stack because R0 will later be used for Fib(n-1)
			BL FIBONACCI 		//Peform Fib(n-1)
			POP {R4, LR} 		//Restore LR to same value as when fibonacci was first called by main program to be able to return to main program
			
			ADD R0, R4, R0 		// One iteration of the fibonacci sum i.e. fib(n-2) + fib(n-1)
			ADD R1, R1, #1 		//Restore value of R1
			BX LR

BASE:		MOV R0, #1 			//Initialize fibonacci sum to first element of fibo array (1)
			BX LR 				//Return to caller

END:		B END

N:			.word 6
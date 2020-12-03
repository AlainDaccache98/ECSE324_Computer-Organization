	.text
	.equ L_FIFO, 0xFF203048					// left fifo
	.equ R_FIFO, 0xFF20304C					// right fifo 
	.equ FIFO, 0xFF203044
	.global audio_write_ASM

audio_write_ASM:
			
			
			PUSH {R4-R12} 					//saves the state of the system
			LDR R1, = L_FIFO 				//loads the address of the data register for the left fifo
			LDR R2, = R_FIFO 				//loads the address of the data register for the right fifo
			LDR R3, = FIFO 					//loads the address of the data register for the fifospace

			LDRB R4, [R3,#2] 				//loads the value of WSRC onto R4
			LDRB R5, [R3, #3] 				//loads the value of WSLC onto R5

			CMP R4, #0 						//checks to see if the fifos are full
			MOVEQ R0, #0 					// if yes, the subroutine returns 0 and branches back
			POPEQ {R4-R12}
			BXEQ LR
			CMP R5, #0
			MOVEQ R0, #0
			POPEQ {R4-R12}
			BXEQ LR
			STR R0, [R1] 					// If the fifos are not full 
			STR R0, [R2]					// store values in them if not full

			MOV R0, #1 						// the subroutine returns 1 if fifos not full
			POP {R4-R12}					// update system state
			BX LR

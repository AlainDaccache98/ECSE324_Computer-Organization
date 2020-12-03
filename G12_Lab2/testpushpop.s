			.text
			.global _start

_start:
			MOV R0, #0
			MOV R1, #1
			MOV R2, #2
			//SUB SP, SP, #4
			STR R0, [SP]
			SUB SP, SP, #4
			STR R1, [SP]
			SUB SP, SP, #4
			STR R2, [SP]
			LDR R0, [SP]
			ADD SP, SP, #4
			LDR R1, [SP]
			ADD SP, SP, #4
			LDR R2, [SP]
			ADD SP, SP, #4

END: B END
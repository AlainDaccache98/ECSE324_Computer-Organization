	.text
	.global read_PS2_data_ASM

read_PS2_data_ASM:
	MOV R1, #0x8000	//16th bit
	LDR R3, =0xFF200100
	LDR R4, [R3]
	MOV R5, #0xFF	//last byte
	TST R4, R1
	MOVEQ R0, #0
	BXEQ LR
	AND R6, R4, R5	//and data with FF to get last 8 bits
	STRB R6, [R0]	//store data at char pointer
	MOV R0, #1	//return 1 to denote valid data
	BX LR

	.end
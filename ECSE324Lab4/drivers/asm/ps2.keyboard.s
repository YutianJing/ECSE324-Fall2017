.text
			.equ PS2DATA_BASE, 0xFF200100
			.equ PS2CONTROL_BASE, 0xFF201024
			.global read_PS2_data_ASM


//check the RVALID bit. if valid, then the data from the same register should be stored at the address in the char pointer argument, 
//subroutine return 1 to denote valid data
//if that bit is not set, then subroutine return 0



//RVALID = 15BIT


read_PS2_data_ASM:

		LDR R2, =PS2DATA_BASE
		LDR R3, [R2]

		MOV R4, #32768  //only left with rvalid bit
		TST R4, R3		
		BEQ DONE



		//RVALID = 1
		LDR R1, =PS2DATA_BASE
		LDRB R5, [R1]
		STRB R5, [R0]				// store data in the char pointer 
		MOV R0, #1					// return 1
		BX LR

DONE: 
		MOV R0, #0		
		BX LR


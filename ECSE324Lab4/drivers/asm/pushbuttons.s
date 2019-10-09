			.text
			.equ PUSH_DATA, 0xFF200050
			.equ PUSH_MASK, 0xFF200058
			.equ PUSH_EDGE, 0xFF20005C
			.global read_PB_data_ASM
			.global PB_data_is_pressed_ASM
			.global read_PB_edgecap_ASM
			.global PB_edgecap_is_pressed_ASM
			.global PB_clear_edgecap_ASM
			.global enable_PB_INT_ASM
			.global disable_PB_INT_ASM


read_PB_data_ASM:					
			LDR R0, =PUSH_DATA		// load the memory address 
			LDR R0, [R0]			// get the value and put it into R0
			BX LR					

PB_data_is_pressed_ASM:				// check if the indicated buttons are pressed
	
			LDR R1, =PUSH_DATA		
			LDR R1, [R1]			// get the value and put it into R1
			AND R3, R1, R0			//CHECK IF PRESSED
			CMP R3, R0
			MOVEQ R0, #1			// if no, return false
			MOVNE R0, #0			// if yes, return true
			BX LR 					

read_PB_edgecap_ASM:				// return a binary string, where the final 4 bits hold the edgecap bits
	
			LDR R1, =PUSH_EDGE	
			LDR R1, [R1]		
			AND R0, R0, #0xF		//GET RID OF UNCESSERY BIT
			BX LR 	

PB_edgecap_is_pressed_ASM:			// check if the indicated buttons are pressed. If yes, return 1. Otherwise, return 0.

			LDR R1, =PUSH_EDGE		// load the memory address where the value is stored
			LDR R1, [R1]			// get the value and put it into R1
			AND R3, R1, R0			//CHECK IF PRESSED
			CMP R3, R0
			MOVEQ R0, #1			// if no, return false
	   		MOVNE R0, #0			// if yes, return true
			BX LR 				

PB_clear_edgecap_ASM:			
									
			LDR R3, =PUSH_EDGE		// load the memory address	
			MOV R4, #0x7
			STR R4, [R3]			// RESET
			BX LR 					

enable_PB_INT_ASM:					// enable the inerrupt

			LDR R1, =PUSH_MASK		// load the memory address
			AND R3, R0, #0xF
			STR R3, [R1]
			BX LR 					

disable_PB_INT_ASM:					// disable interrupt

			LDR R1, =PUSH_MASK		// load the target memory address
			LDR R2, [R1]
			BIC R2, R2, R0
			STR R3, [R1]			// store the input value in R1
			BX LR 				

.end

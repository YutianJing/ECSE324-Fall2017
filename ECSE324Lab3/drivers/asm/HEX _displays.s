			.text
			.equ HEX0TO3_BASE, 0xFF200020
			.equ HEX4TO5_BASE, 0xFF200030
			.global HEX_clear_ASM, HEX_flood_ASM, HEX_write_ASM


HEX_write_ASM:						//  display the hex display for corresponding input
			LDR R2, =number			// hold address of first number 
			LDRB R2, [R2, R1]		
			LDR R3, =HEX0TO3_BASE
			LDR R4, =HEX4TO5_BASE
			//MOV R5, #0
			MOV R6, #1
			MOV R7, #0
			B LOOP

LOOP:
			CMP R7, #6			//compare the couner with 6
			BXEQ LR
			TST R6, R0			//test bit R0 and R6
			BEQ SKIP			//if the answer = 0 go to skip, 
			CMP R7, #3
			BGT SKIP2
			STRB R2, [R3, R7]	//store bit in hex address.
			LSL R6, R6, #1
			ADD R7, R7, #1
			B LOOP

SKIP:
			LSL R6, R6, #1
			ADD R7, R7, #1
			B LOOP

SKIP2:
			SUB R8, R7, #4
			STRB R2, [R4, R8]
			LSL R6, R6, #1
			ADD R7, R7, #1
			B LOOP







HEX_flood_ASM:		// all hex display segments light up
			MOV R2, #0b01111111
			MOV R10, #0
			LDR R4, =HEX0TO3_BASE
			MOV R7, #0
			MOV R5, #1
			LDR R6, =HEX4TO5_BASE

LOOOP:
			CMP R7, #6
			BXEQ LR
			TST R5, R0
			BEQ SKIIP
			CMP R7, #3
			BGT SKIIP2
			
			//LDRB R9, [R4, R7]
			//AND R9, R9, R2
			//ORR R9, R9, R2
			
			STRB R2, [R4, R7]
			LSL R5, R5, #1
			ADD R7, R7, #1

			B LOOOP

SKIIP:
			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOP

SKIIP2:		
			LSR R9, R0, #4
			CMP R9, #0b0011
			BEQ SKIIP3
			
			STRB R10, [R6, R10]
			SUB R8, R7, #4
			//LDRB R9, [R6, R7]
			//AND R9, R9, R2
			//ORR R9, R9, R2
			STRB R2, [R6, R8]

			SUB R8, R7, #3
			STRB R10, [R6, R8]

			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOP

SKIIP3:
			SUB R8, R7, #4
			//LDRB R9, [R6, R7]
			//AND R9, R9, R2
			//ORR R9, R9, R2
			STRB R2, [R6, R8]

			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOP



HEX_clear_ASM:		//all segment light out
			MOV R2, #0b00000000
			LDR R3, =LIGHTS
			LDR R4, =HEX0TO3_BASE
			MOV R7, #0
			MOV R5, #1
			LDR R6, =HEX4TO5_BASE

LOOOOP:
			CMP R7, #6
			BXEQ LR
			TST R0, R5
			BEQ SKIIIP
			CMP R7, #4
			BGE SKIIIP2

			STRB R2, [R4, R7]
			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOOP

SKIIIP:			
			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOOP

SKIIIP2:		
			SUB R8, R7, #4

			STRB R2, [R6, R8]
			LSL R5, R5, #1
			ADD R7, R7, #1
			B LOOOOP

END:		BX LR

ZEROS:		.byte 0
ONES:		.byte 127
number:		.byte 63, 6, 91, 79
				// 00111111	00000110 01011011 01001111
				//	   0        1        2        3

			.byte 102, 109, 125, 7
				// 01100110	01101101 01111101 00000111
				//	   4	    5        6        7

			.byte 127, 103, 119, 124
				// 01111111	01100111 01110111 01111100
				//	   8	    9        A        b

			.byte 57, 94, 121, 113, 0

				// 00111001 01011110 01111001 01110001
				//	   C	    d        E        F
			.end

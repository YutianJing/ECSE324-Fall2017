			.text
			.equ PIXELBUFF_BASE, 0xC8000000
			.equ CHARBUFF_BASE, 0xC9000000
			.global VGA_clear_charbuff_ASM
			.global VGA_clear_pixelbuff_ASM
			.global VGA_write_char_ASM
			.global VGA_write_byte_ASM
			.global VGA_draw_point_ASM



VGA_clear_charbuff_ASM:

		MOV R0, #60     //Y COUNTER
		MOV R1, #79	   //X COUNTER
		MOV R5, R1	  //TO RESET Y COUNTER
		LDR R2, =CHARBUFF_BASE
		MOV R3, #0
		
OUTERLOOP1:
		SUB R0, R0, #1
		CMP R0, #0	
		BLT CLEARDONE
		MOV R1, #79		//RESET X

		
INNERLOOP1:

		CMP R1, #0
		BLT OUTERLOOP1		//DONE WITH X, BACK TO NEW OUTTERLOOP
		
		MOV R4, R0		//GET Y COUNTER
		LSL R4, #7		//ADD 0000000
		ORR R4, R4, R2
		ORR R4, R4, R1		// ADD IN X COUNTER
			
		STRB R3, [R4]
		SUB R1, R1, #1		//DECRESE X COUNTER
		B INNERLOOP1
		

CLEARDONE:
		BX LR


VGA_clear_pixelbuff_ASM:

		MOV R0, #300  	 //X COUNTER
		ADD R0, R0, #19

		MOV R1, #240	//Y COUNTER
		MOV R5, R1		//TO RESET Y COUNTER
		LDR R2, =PIXELBUFF_BASE
		MOV R3, #0

OUTERLOOP:

		SUB R1, R1, #1		//SUB Y COUNTER
		CMP R1, #0	
		BLT PIXDONE
		MOV R0, #300		//RESET X
		ADD R0, R0, #19

		
INNERLOOP:
		CMP R0, #0
		BLT OUTERLOOP		//DONE WITH X, BACK TO NEW OUTTERLOOP
		
		MOV R4, R1			//COPY Y COUNTER
		LSL R4, R4, #10		//ADD 000000000 0

		MOV R6, R0		//X COUNTER COPY FOR SHIFTING
		LSL R6, #1		//LEFT SHIFT
		ORR R4, R4, R6		// ADD THE X COUNTER
		ORR R4, R4, R2

		STRH R3, [R4]
		SUB R0, R0, #1		//DECRESE Y COUNTER
		B INNERLOOP

PIXDONE:
		BX LR

VGA_write_char_ASM:
// WILL store the value of third input at address calculated by the first two
//will check the coord
//r0 = x r1 =y r2 = ASCII

		LDR R5, =CHARBUFF_BASE

		CMP R0, #79		//CHECK RANGE
		BGT CHARWRITEDONE
		CMP R0, #0
		BLT CHARWRITEDONE
		CMP R1, #59
		BGT CHARWRITEDONE

		CMP R1, #0
		BLT CHARWRITEDONE


		MOV R4, R1
		LSL R4, R4, #7		//ADD 0000000 2^7
		ORR R4, R4, R0
		ORR R4, R4, R5			//GET THE ADDRESS
		STRB R2, [R4]


CHARWRITEDONE:

		BX LR




VGA_write_byte_ASM:

//R0 = X; R1=Y; R2 = BYTE TO BE WRITE



		LDR R5, =CHARBUFF_BASE

		CMP R0, #79		//CHECK RANGE
		BGT BYTEWRITEDONE
		CMP R0, #0
		BLT BYTEWRITEDONE
		CMP R1, #59
		BGT BYTEWRITEDONE

		CMP R1, #0
		BLT BYTEWRITEDONE


// store first four bits in memory location indicated by input

		MOV R3, R2		// copy input into another register
		LSR R3, #4		// remove rightmost bits from input
		CMP R3, #10		// check if the hex digit is a letter or number
		ADDGE R3, R3, #55	// ASCII letter
		ADDLT R3, R3, #48	// ASCII number
		MOV R4, R1		// take y value
		LSL R4, R4, #7		
		ORR R4, R4, R5		// get base address in there
		ORR R4, R4, R0 		// add in the x counter
		STRB R3, [R4]	// store the input value to the address	



		ADD R0, R0, #1	// increment x address by 1 to go to next grid spot
		CMP R0, #79		// check if the x counter has reached the right side of the screen
		MOVGT R0, #0	// if yes, send x back to 0 (left side)
		ADDGT R1, #1	// if yes, increment y by 1
		CMP R1, #59		// check if the y counter has reached the bottom of the screen
		MOVGT R1, #0		// if yes, send y back to 0 (top)




// store second four bits in memory location indicated by x and y

		MOV R3, #0xF	// get 1s in the last 4 bits
		AND R2, R3		// keep last four bits of input
		CMP R2, #10

		ADDGE R2, R2, #55	// ASCII letter
		ADDLT R2, R2, #48	// ASCII number

		MOV R4, R1		// take y value
		LSL R4, #7
		ORR R4, R4, R5		// get base address in there
		ORR R4, R4, R0 		// add in the x counter
		STRB R2, [R4]	// store the input value to the address

BYTEWRITEDONE:

		BX LR

VGA_draw_point_ASM:


		LDR R5, =PIXELBUFF_BASE

		
		MOV R3, #300  	 //X COUNTER
		ADD R3, R3, #19
		CMP R0, R3				// check that x is within the allowed range
		BGT DRAWDONE

		CMP R0, #0 
		BLT DRAWDONE

		CMP R1, #239			// check that y is within the allowed range
		BGT DRAWDONE

		CMP R1, #0
		BLT DRAWDONE


		MOV R4, R1			// take y value
		LSL R4, R4, #10
		ORR R4, R4, R5			// get base address in there
		MOV R6, R0 			// make a copy of the x counter
		LSL R6, #1			// shift one digit left
		ORR R4, R4, R6 			// add in the x counter
		STRH R2, [R4]		// store the input value to the address		// TODO: check that STRB is ok


DRAWDONE:

	
		BX LR				// leave







		


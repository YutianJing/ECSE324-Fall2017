			.text
			.global _start
_start:

		LDR R2, =N
		LDR R1, [R2]		// R1 = NUMBER OF ELEMENT
		ADD R0, R2, #4		// R0 POINTS TO THE FIRST LOCATION
		MOV R4, R0		// CURRENT POINTER
		MOV R5, R1
WHILE: 
		//MOV R6, #0		// BOOLEAN SORTED = FALSE
		CMP R6, #0
		BEQ LOOPSTART

LOOPSTART: 

		CMP R1, #1
		BLE END			// IF R1<=1, END


		SUB R5, R5, #1		// N-1 COMPARISON LAST ONE DOESN’T NEED
		CMP R5, #0
		BEQ ENDINNER		// IF R5=0, END INNER LOOP AND START A NEW LOOP

		//MOV R6, #1		// BOOLEAN SORTED = TRUE

		LDR R7, [R4]		// FIRST ELE
		LDR R8, [R4, #4]	// SECOND ELE
		CMP R7, R8
		BLE NOSWAP		// IF R7<=R8 NO NEED TO SWAP, BEGIN NEW INNER LOOP

	

		
		LDR R7, [R4]		// FIRST ELE
		MOV R3, R7
		LDR R8, [R4, #4]	// SECOND ELE
		STR R8, [R4]
		STR R3, [R4, #4]
		ADD R4, R4, #4
		MOV R6, #0
		B LOOPSTART

NOSWAP:		
		
		STR R7, [R4]
		STR R8, [R4, #4]
		ADD R4, R4, #4		// POINTER TO NEXT ELE
		B LOOPSTART		// RESET LOOP

ENDINNER:
 		//CMP R6, #0		// CHECK BOOLEAN
		//BEQ END			// LEAVE	
		LDR R5, [R2]	
		MOV R4, R0		// RESET POINTER
		SUB R1, R1, #1		// RESET COUNTER
		CMP R1, #1
		BLE END			// IF R1<=1, END
		
		B LOOPSTART		// NEW ITERATION

END: 		B END

RESULT:		.word 0			// memory assigned for result location
N:		.word 8			// number of entries in the list
NUMBERS:	.word 4, 5, 3, 6	// the list data
		.word 1, 8, 2, 7

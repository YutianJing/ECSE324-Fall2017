			.text
			.global _start
 
_start:
			LDR R4, =RESULT			// R4 points to the result location
			LDR R2, [R4, #4]		// R2 holds the number of elements in the list
			ADD R3, R4, #8			// R3 points to the first number
			LDR R0, [R3]			// R0 holds the first number in the list
			
			LDR LR, [SP, #-4]!		//SAVE RETURN ADDRESS
			BL SUBROUTINE
			STR R0, [R4]			//RETURN VALUE IS IN R0

			B END



SUBROUTINE:		
			SUBS R2, R2, #1			// decrement the loop counter
			BXEQ LR
			ADD R3, R3, #4			// R3 points to next number in the list
			LDR R1, [R3]			// R1 holds the next number in the list
			CMP R0, R1				// check if it is greater than the maximum
			BGE SUBROUTINE				// if no, branch back to the loop
			MOV R0, R1
			B SUBROUTINE			// end loop if counter has reached 0

//MAXIMUM:
			//BX LR



END:		B END					// infinite loop!
		
RESULT:		.word 0					// memory assigned for result location
N:			.word 7					// number of entries in the list
NUMBERS:	.word 4, 5, 3, 6 		// the list data
			.word 1, 8, 2

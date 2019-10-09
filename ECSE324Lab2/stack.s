		.text
		.global _start
 
_start:
			LDR R4, =RESULT			// R4 points to the result location
			//LDR R2, [R4, #4]		// R2 holds the number of elements in the list
			//ADD R3, R4, #8			// R3 points to the first number
			//LDR R0, [R3]			// R0 holds the first number in the list
			LDR	R0, [R4, #8]
			LDR R1, [R4, #12]
			LDR R2, [R4, #16]
			
//PUSH
			STR R2, [SP, #-4]!
			STR R1, [SP, #-4]!
			STR R0, [SP, #-4]!
//POP

			LDR R0,[SP],#4   //POP R0
			LDR R1,[SP],#4 
			LDR R2,[SP],#4 







END:		B END					// infinite loop!
		
RESULT:		.word 0					// memory assigned for result location
N:			.word 3					// number of entries in the list
NUMBERS:	.word 4, 5, 3 		// the list data
			

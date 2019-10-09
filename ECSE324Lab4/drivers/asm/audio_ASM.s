.text
			.equ FIFOSPACE_BASE, 0xFF203044
			.equ LEFTDATA_BASE, 0xFF203048
			.equ RIGHTDATA_BASE, 0xFF20304C
			.global audio_ASM






//subroutine should take one integer argument and write it to both left&right FIFO only if have space
// return 1 if data was written and 0 otherwise


audio_ASM:


			LDR R1, =FIFOSPACE_BASE		//LOAD THE ADDRESS
			LDR R2, [R1]

			AND R3, R2, #0xFF000000		//LEFT ONLY WSLC
			LSR R3, R3, #24
			CMP R3, #0				// if wslc value not equal to 0; return 1
			MOVEQ R0, #0			
			BEQ END					//if =0, return r0 = 0

		

			AND R4, R2, #0x00FF0000		//LEFT ONLY WSRC
			LSR R4, R4, #16
			CMP R4, #0
			MOVEQ R0, #0
			BEQ END


			//WRITE DATA IF HAVE SPACE

			LDR R5, =LEFTDATA_BASE
			LDR R6, =RIGHTDATA_BASE
			
			STR R0, [R5]
			STR R0, [R6]
			MOV R0, #1

END:		
			BX LR

			
			
			
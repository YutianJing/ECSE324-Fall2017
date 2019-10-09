		.text
		.global _start


_start:
		LDR R4, =RESULT     //R4 point to the result position\
		LDR R1, N		// the value of Nth fib\
		MOV R0, #0		//initialize the result and the final result \


		PUSH {R0, R1, LR}  //push parameter to be passed to the subroutine and LR\
		BL FIB    			//call sub\
		POP {R0,R1,LR}	//pop parameter back

		STR R0, [R4]  //store final result\
		B END


FIB: 
		PUSH {R0-R2}    // callee-save the register \
		MOV R0, #0     // initializing R0
		CMP R1, #2   
		BLT SMALL   //if smaller than 2, return 1 else, fib(n) = fib(n-1)+fib(n-2)\


		SUB R1, R1, #1    //R1 = N-1\
		PUSH {R0, R1, LR}   //push on the stack\
		BL FIB    //recursive call\
		POP {R0,R1,LR}  
		MOV R2, R0   //load fib(n-1) to R2\


		SUB R1, R1, #1  //R1 = N-1-1 = N-2\
		PUSH {R0, R1, LR}  //push on the stack\
		BL FIB   //recursive call
		POP {R0,R1,LR}  
  						

		ADD R0, R0, R2  //SUM
		B DONE



SMALL: 
		MOV R0, #1
		B DONE



DONE:

		STR R0, [SP,#12]  //store the value of R0 on the stack, replacing the original R0\
		POP {R0-R2}  //clear everything on the stack\
		BX LR  // return  to link register\

END: 
		B END

RESULT: 	.word 0
N:             .word 5

			.text
			.equ TIMER0_BASE, 0xFFC08000
			.equ TIMER1_BASE, 0xFFC09000
			.equ TIMER2_BASE, 0xFFD00000
 			.equ TIMER3_BASE, 0xFFD01000
			.global HPS_TIM_config_ASM, HPS_TIM_read_INT_ASM, HPS_TIM_clear_INT_ASM


HPS_TIM_config_ASM: 
			
			LDR R3, [R0]
			//AND R3, R3, #15		// R3 & 1111 to make sure R3 get rid of random number before one-hot string 
			MOV R1, #1			//COUNTER
			
			LDR R2, =TIMER0_BASE

  			TST R1, R3
			BEQ DONE1
			
			LDR R4, [R2,#0x08]		//DISABLE BEFORE WRITE ANY CONFIG
			AND R4, R4, #0x06		//---110 disable Ebit but keep others the same
			STR R4, [R2,#0x08]

			LDR R4, [R0,#0x04]		//CONF TIME-OUT
			STR R4, [R2]
			
			LDR R4, [R0,#8]		//M BI--LD_EN
			LSL R4, R4, #1
			LDR R5, [R0,#12]		//I BIT\
			LSL R5, R5, #2
			LDR R6, [R0,#16]

			ORR R4, R4, R5			
			ORR R4, R4, R6			//GET M I E
			
			STR R4, [R2,#0x08]		// I M E BIT
			

DONE1:		 

			LSL R1, R1, #1 
			LDR R2, =TIMER1_BASE

			TST R1, R3
			BEQ DONE2
				

			LDR R4,[R2,#0x08]		//DISABLE BEFORE WRITE ANY CONFIG
			AND R4, R4, #0x06		//---110 disable Ebit but keep others the same
			STR R4, [R2,#0x08]

			LDR R4, [R0,#0x04]		//CONF TIME-OUT
			STR R4, [R2]
			
			LDR R4, [R0,#8]		//M BI--LD_EN
			LSL R4, R4, #1
			LDR R5, [R0,#12]		//I BIT\
			LSL R5, R5, #2
			LDR R6, [R0,#16]

			ORR R4, R4, R5			
			ORR R4, R4, R6			//GET M I E
			
			STR R4, [R2,#0x08]		// I M E BIT


DONE2: 


			LSL R1, R1, #1 
			LDR R2, =TIMER2_BASE

			TST R1, R3
			BEQ DONE3
			
			LDR R4, [R0, #4]
			
			LDR R4,[R2,#0x08]		//DISABLE BEFORE WRITE ANY CONFIG
			AND R4, R4, #0x06		//---110 disable Ebit but keep others the same
			STR R4, [R2,#0x08]

			LDR R4, [R0,#0x04]		//CONF TIME-OUT
			LSR R4, R4, #2
			STR R4, [R2]
			
			LDR R4, [R0,#8]		//M BI--LD_EN
			LSL R4, R4, #1
			LDR R5, [R0,#12]		//I BIT\
			LSL R5, R5, #2
			LDR R6, [R0,#16]

			ORR R4, R4, R5			
			ORR R4, R4, R6			//GET M I E
			
			STR R4, [R2,#0x08]		// I M E BIT

DONE3:		

			LSL R1, R1, #1 
			LDR R2, =TIMER3_BASE

			TST R1, R3
			BEQ DONE4
			

			LDR R4,[R2,#0x08]		//DISABLE BEFORE WRITE ANY CONFIG
			AND R4, R4, #0x06		//---110 disable Ebit but keep others the same
			STR R4, [R2,#0x08]

			LDR R4, [R0,#0x04]		//CONF TIME-OUT
			LSR R4, R4, #2
			STR R4, [R2]
			
			LDR R4, [R0,#8]		//M BI--LD_EN
			LSL R4, R4, #1
			LDR R5, [R0,#12]		//I BIT\
			LSL R5, R5, #2
			LDR R6, [R0,#16]

			ORR R4, R4, R5			
			ORR R4, R4, R6			//GET M I E
			
			STR R4, [R2,#0x08]		// I M E BIT

DONE4: 
			BX LR

HPS_TIM_read_INT_ASM:

			//LDR R3, [R0]
			//AND R3, R3, #15		// R3 & 1111 to make sure R3 get rid of random number before one-hot string 
			MOV R1, #1			//COUNTER

			LDR R2, =TIMER0_BASE

  			TST R1, R0
			BEQ DONE5
			LDR R0, [R2, #0x10]			//Load S-bit
			
			
DONE5:		LSL R1, R1, #1 
			LDR R2, =TIMER1_BASE

			TST R1, R0
			BEQ DONE6
			LDR R0, [R2, #0x10]


DONE6:		LSL R1, R1, #1 
			LDR R2, =TIMER2_BASE

			TST R1, R0
			BEQ DONE7
			LDR R0, [R2, #0x10]


DONE7:
			LSL R1, R1, #1 
			LDR R2, =TIMER3_BASE

			TST R1, R0
			BEQ READDONE
			LDR R0, [R2, #0x10]

READDONE:
			BX LR

HPS_TIM_clear_INT_ASM:

			//AND R3, R3, #15		// R3 & 1111 to make sure R3 get rid of random number before one-hot string 
			MOV R1, #1			//COUNTER
			LDR R2, =TIMER0_BASE


  			TST R1, R0
			BEQ DONEA
			LDR R4, [R2, #0xC]		//Reading F bit clears everything... 
			

DONEA:		 

			LSL R1, R1, #1 
			LDR R2, =TIMER1_BASE

			TST R1, R0
			BEQ DONEB
			LDR R4, [R2, #0xC]		//Reading F bit clears everything... 

			

DONEB:		LSL R1, R1, #1 
			LDR R2, =TIMER2_BASE

			TST R1, R0
			BEQ DONEC
			LDR R4, [R2, #0xC]		//Reading F bit clears everything... 


DONEC: 
			LSL R1, R1, #1 
			LDR R2, =TIMER3_BASE

			TST R1, R0
			BEQ DONED
			LDR R4, [R2, #0xC]		//Reading F bit clears everything... 


DONED: 
			BX LR
	


			.end

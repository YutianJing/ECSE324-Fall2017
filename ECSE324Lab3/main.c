#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/int_setup.h"

//Pushbutton
int main() {

			HEX_write_ASM(HEX4, 8);
			HEX_write_ASM(HEX5, 8);
			//if (1) {
			HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 );
			//}
	while(1){
			
			int m = read_slider_switches_ASM();
			
				write_LEDs_ASM( m );
			
			if (m == 0) {
			HEX_write_ASM(HEX4, 8);
			HEX_write_ASM(HEX5, 8);
			}
			
			if (m == 512) {
				//HEX_flood_ASM( HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5 );
				HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5 );
			}
			if ( PB_data_is_pressed_ASM(PB0) ) {
				HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 );
				HEX_write_ASM(HEX0, m);
			}
			if ( PB_data_is_pressed_ASM(PB1) ) {
				HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 );
				HEX_write_ASM(HEX1, m);
			}
			if ( PB_data_is_pressed_ASM(PB2) ) {
				HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 );
				HEX_write_ASM(HEX2, m);
			}
			if ( PB_data_is_pressed_ASM(PB3) ) {
				HEX_clear_ASM( HEX0 | HEX1 | HEX2 | HEX3 );
				HEX_write_ASM(HEX3, m);
			}
	}
			return 0;
}








/*
//Sample0-15
		int main(){
		int count0 = 0, count1 = 0, count2 = 0,count3 = 0;

		HPS_TIM_config_t hps_tim;

		hps_tim.tim = TIM0|TIM1|TIM2|TIM3;
		hps_tim.timeout = 1000000;
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 1;
		hps_tim.enable = 1;
	
		HPS_TIM_config_ASM(&hps_tim); //Config timer 1
	
		while(1) {
			if (HPS_TIM_read_ASM(TIM0)) {
				HPS_TIM_clear_INT_ASM(TIM0);
				if(++count0 == 16) 
					count0 = 0;
				HEX_write_ASM(HEX0, count0);
			}
			if (HPS_TIM_read_ASM(TIM1)) {
				HPS_TIM_clear_INT_ASM(TIM1);
				if(++ count1 == 16)
					count1 = 0;
				HEX_write_ASM(HEX1, count1);
			}
			if (HPS_TIM_read_ASM(TIM2)) {
				HPS_TIM_clear_INT_ASM(TIM2);
				if(++count2 ==16)
					count2 = 0;
				HEX_write_ASM(HEX2, count2);
			}

			if (HPS_TIM_read_ASM(TIM3)) {
				HPS_TIM_clear_INT_ASM(TIM3);
				if(++count3==16)
					count3 = 0;
				HEX_write_ASM(HEX3, count3);
			}
		}
		return 0;
}
*/






/*
//Stopwatch
int main(){
		//Initialize second timer parameters
		HPS_TIM_config_t hps_tim_pb;
		hps_tim_pb.tim = TIM1;
		hps_tim_pb.timeout = 1000;
		hps_tim_pb.LD_en = 1;
		hps_tim_pb.INT_en = 0;
		hps_tim_pb.enable = 1;

		HPS_TIM_config_ASM(&hps_tim_pb); //configure timer for display

		HPS_TIM_config_t hps_tim;
		hps_tim.tim = TIM0;
		hps_tim.timeout = 1000000;
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 0;
		hps_tim.enable = 1;

		HPS_TIM_config_ASM(&hps_tim); //Config timer for  pushbutton
		
		int push_buttons = 0;
		int ms = 0;
		int sec = 0;
		int min = 0;
	
		int time = 0; 
	
		while(1) {
			if (HPS_TIM_read_INT_ASM(TIM0) && time) {
				HPS_TIM_clear_INT_ASM(TIM0);
				ms += 10; //Timer is for 10 milliseconds
	
				//range for each time
				if (ms >= 1000) {
					ms -= 1000;
					sec++;	
					if (sec >= 60) {
						sec -= 60;
						min++;
						if (min >= 60) {
							min = 0;
						}
					}
				}
				//convert input to char
				HEX_write_ASM(HEX0, ((ms % 100) / 10));		
				HEX_write_ASM(HEX1, (ms / 100));
				HEX_write_ASM(HEX2, (sec % 10));
				HEX_write_ASM(HEX3, (sec / 10));
				HEX_write_ASM(HEX4, (min % 10));
				HEX_write_ASM(HEX5, (min / 10));
			}

			if (HPS_TIM_read_INT_ASM(TIM1)) { //Timer to read push buttons
				HPS_TIM_clear_INT_ASM(TIM1);

				if (PB_edgecap_is_pressed_ASM(PB0)&&(time==0)) { //Start timer
					time = 1;

				PB_clear_edgecap_ASM(PB0);
				} if (PB_edgecap_is_pressed_ASM(PB1)&&(time==1)) { //Stop timer
					time = 0;

				PB_clear_edgecap_ASM(PB1);

				} if (PB_edgecap_is_pressed_ASM(PB2)) { //Reset timer
					ms = 0;
					sec = 0;
					min = 0;
					time = 0; //Stop timer
					PB_clear_edgecap_ASM(PB1);
					//Set every number to 0
					HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);

				}
			}//PB_clear_edgecap_ASM(PB2);
		}	return 0;
}*/








/*
//Interrupt
int main(){
		int_setup(2, (int []) {73, 199}); //Enable interupts for push buttons and hps timer 
		enable_PB_INT_ASM(PB0 | PB1 | PB2);	//Enable interrupts pushbuttons
		
//Initialize timer parameters
		
		HPS_TIM_config_t hps_tim;
		hps_tim.tim = TIM0;
		hps_tim.timeout = 1000000;
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 0;
		hps_tim.enable = 1;
		HPS_TIM_config_ASM(&hps_tim); //Config timer
					int ms = 0;
					int sec = 0;
					int min = 0;
					int time = 0; 
		
		while(1) {

			if (pb_int_flag != 0) { //Check if pb interrupt occurs
				if ((pb_int_flag & 1) && (!time )) { //Start timer
					time = 1;

				} if ((pb_int_flag & 2) && (time)) { //Stop timer
					time = 0;
				}

					if (pb_int_flag & 4) { //Reset timer
					ms = 0;
					sec = 0;
					min = 0;
					time = 1; 
					
					HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 0);
					}
				pb_int_flag = 0;
				}

			if(hps_tim0_int_flag){

					hps_tim0_int_flag = 0;
	
				if (time) {
					ms += 10; //Timer is for 10 milliseconds
					// check he range for each time
					if (ms >= 1000) {
						ms -= 1000;
						sec++;	
						if (sec >= 60) {
							sec -= 60;
							min++;
							if (min >= 60) {
								min = 0;
						}
					}
				}
			}
				//convert input to char
				HEX_write_ASM(HEX0, ((ms % 100) / 10));		
				HEX_write_ASM(HEX1, (ms / 100));
				HEX_write_ASM(HEX2, (sec % 10));
				HEX_write_ASM(HEX3, (sec / 10));
				HEX_write_ASM(HEX4, (min % 10));
				HEX_write_ASM(HEX5, (min / 10));
			}
		}
	return 0;
}*/


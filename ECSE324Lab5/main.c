
#include "./drivers/inc/vga.h"
	#include "./drivers/inc/ISRs.h"
	#include "./drivers/inc/LEDs.h"
	#include "./drivers/inc/audio.h"
	#include "./drivers/inc/HPS_TIM.h"
	#include "./drivers/inc/int_setup.h"
	#include "./drivers/inc/wavetable.h"
	#include "./drivers/inc/pushbuttons.h"
	#include "./drivers/inc/ps2_keyboard.h"
	#include "./drivers/inc/HEX_displays.h"
	#include "./drivers/inc/slider_switches.h"
	



		int amp = 5;				//initial volume

//Method calculating the signal
	int signal(float f, int t) {
		int temp = (int)(f*t);
		float index = temp % 48000;
		int indexLeftOfDecimal = (int)index;
		float decimals = index - indexLeftOfDecimal;
		float interpolated = (1-decimals)*sine[indexLeftOfDecimal] + (decimals)*sine[indexLeftOfDecimal+1];
	

		return interpolated;
	}


		int arr[320];				//store the previous vga-drawed points
		int arrr[320];				//stroe the to-be-drawed points

//save 48000 samples for each frequency;
		int noteC1[48000];
		int noteD1[48000];
		int noteE1[48000];
		int noteF1[48000];
		int noteG1[48000];
		int noteA1[48000];
		int noteB1[48000];
		int noteCC1[48000];

		void makewave(){
			int t=0;	
			while (t<48000){
				noteC1[t]=signal(130.813,t);
				noteD1[t]=signal(146.832,t);
				noteE1[t]=signal(164.814,t);
				noteF1[t]=signal(174.614,t);
				noteG1[t]=signal(195.998,t);
				noteA1[t]=signal(220.000,t);
				noteB1[t]=signal(246.942,t);
				noteCC1[t]=signal(261.626,t);
				t++;
			}t=0;
		}
	


int main(){
		int_setup(3, (int []) {199, 200, 201});

		VGA_clear_pixelbuff_ASM();				//clear the screen at first

//Initialize audio timer parameters
		HPS_TIM_config_t hps_tim;
		hps_tim.tim = TIM0;
		hps_tim.timeout = 20;
		hps_tim.LD_en = 1;
		hps_tim.INT_en = 1;
		hps_tim.enable = 1;

		HPS_TIM_config_ASM(&hps_tim);		//Config timer

//keyboard timer
		HPS_TIM_config_t hps_tim1;
		hps_tim1.tim = TIM1;
		hps_tim1.timeout = 1000;
		//hps_tim1.timeout = 50000;
		hps_tim1.LD_en = 1;
		hps_tim1.INT_en = 1;
		hps_tim1.enable = 1;

		HPS_TIM_config_ASM(&hps_tim1);		//Config timer

//VGA timer
		HPS_TIM_config_t hps_tim2;
		hps_tim2.tim = TIM2;
		hps_tim2.timeout = 100000;
		//hps_tim2.timeout = 50000;
		hps_tim2.LD_en = 1;
		hps_tim2.INT_en = 1;
		hps_tim2.enable = 1;

		HPS_TIM_config_ASM(&hps_tim2);		//Config timer

		makewave();

		char* data;				// PS/2 port input address
		float f = 0;			//unused

		int t0 = 0;				//8 counters for stop points of each audio signal
		int t1 = 0;
		int t2 = 0;
		int t3 = 0;
		int t4 = 0;
		int t5 = 0;
		int t6 = 0;
		int t7 = 0;
		
		int i = 0;				//counter for saving the to-be-drawed points in array on vga
		int j;					//counter for acturally drawing points on vga
		int flag = 0;			//flag for readyness of complete 320 points
		int fflag = 0;			//some hard code here

		int s = 0;				//initialize signal value

		int noteC =0;			//flag for 8 different frequencies
		int noteD =0;
		int noteE =0;
		int noteF =0;
		int noteG =0;
		int noteA =0;
		int noteB =0;
		int noteCC =0;


while(1){
	if(hps_tim1_int_flag){					//keyboard timer flag
		hps_tim1_int_flag = 0;				//reset timer flag

		int in = *data;						//assigning the input

		if(read_ps2_data_ASM(data)){		//check if keyboard interrupt occurs

			if(in != 0xF0){					//if nothing is released


			if(amp >= 12){					//setting the volume boundries
				amp = 12;
			}
			if(amp <= 0){
				amp = 0;
			}



				 in = *data;

				 if( in == 0x1C){			//check which key is pressed and set corresponding flag to 1
					//f = 130.813;
				 	noteC=1;
				 }if( in == 0x1B){
					//f = 146.832;
					noteD=1;
				}if( in == 0x23){
					//f = 164.814;
					noteE=1;
				}if( in == 0x2B){
					//f = 174.614;
					noteF=1;
				}if( in == 0x3B){
					//f = 195.998;
					noteG=1;
				}if( in == 0x42){
					//f = 220.000;
					noteA=1;
				}if( in == 0x4B){
					//f = 246.942;
					noteB=1;
				}if( in == 0x4C){
					//f = 261.626;
					noteCC=1;
				}if( in == 0x3A){
					//M
					amp = amp+2;
				}if( in == 0x31){
					//N
					amp = amp-2;
				}
			}

			if(in == 0xF0){					//if any key is released

				read_ps2_data_ASM(data);	//reassigning the input to pass in the second breakcode
				in = *data;

 				if( in == 0x1C){			//check which key is released
					//f = 130.813;
					noteC=0;

				}if( in == 0x1B){
					//f = 146.832;
					noteD=0;

				}if( in == 0x23){
					//f = 164.814;
					noteE=0;

				}if( in == 0x2B){
					//f = 174.614;
					noteF=0;

				}if( in == 0x3B){
					//f = 195.998;
					noteG=0;

				}if( in == 0x42){
					//f = 220.000;
					noteA=0;

				}if( in == 0x4B){
					//f = 246.942;
					noteB=0;

				}if( in == 0x4C){
					//f = 261.626;
					noteCC=0;

				}
			}
		}
	}

	if(hps_tim0_int_flag){					//audio timer
			hps_tim0_int_flag = 0;			//reset flag

		if(noteC){							//add signal corresponding to the pressed keys
				s += amp * noteC1[t0];

		}if(noteD){
				s += amp * noteD1[t1];

		}if(noteE){
				s += amp * noteE1[t2];

		}if(noteF){
				s += amp * noteF1[t3];

		}if(noteG){
				s += amp * noteG1[t4];

		}if(noteA){
				s += amp * noteA1[t5];

		}if(noteB){
				s += amp * noteB1[t6];

		}if(noteCC){
				s += amp * noteCC1[t7];

		}

			if(audio_write_data_ASM(s,s)){	//write audio decoder
				t0++;
				t1++;
				t2++;
				t3++;
				t4++;
				t5++;
				t6++;
				t7++;
				if(!flag){					//some hard code here
					if(fflag){
						fflag = 0;
						i--;
					}
					else{
						arrr[i] = 120 + (s)/800000;				//save the signal 320 by 320 for vga

						if(arrr[i]==119&&arrr[i-1]<=119){		//some hard code here
							fflag = 1;
						}
					}
					i++;										//increment the vga points array counter
				}

				if(i>=319){										//if contineous 320 points are ready set flag to 1
					i = 0;
					flag = 1;

				}
			}

			if(t0>=(int)48000/130.813){		//reset the audio counters in different array places to avoid audio discontinuity
				t0=0;
			}
			if(t1>=(int)48000/146.832){
				t1=0;
			}
			if(t2>=(int)48000/164.814){
				t2=0;
			}
			if(t3>=(int)48000/174.614){
				t3=0;
			}
			if(t4>=(int)48000/195.998){
				t4=0;
			}
			if(t5>=(int)48000/220.000){
				t5=0;
			}
			if(t6>=(int)48000/246.942){
				t6=0;
			}
			if(t7>=(int)48000/261.626){
				t7=0;
			}


				s=0;						//reset signal
	}

	if(hps_tim2_int_flag){					//vga timer
		hps_tim2_int_flag = 0;				//reset flag
		
		if(flag){							//draw vga
			for(j=0; j<320; j++){
				//if(fflag && !counter){
				//	j = j - 1;
				//	fflag=0;
				//}
				VGA_draw_point_ASM(j, arr[j], 0x0);			//clearing the previously drawed points
				VGA_draw_point_ASM(j, arrr[j], 0x2E8B57);		//draw actural points
				arr[j] = arrr[j];							//define previous points
			}
			flag = 0;										//reset flag
		}


	}

}
	return 0;
}



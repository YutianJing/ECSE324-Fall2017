#include <stdio.h>
	
	#include "./drivers/inc/pushbuttons.h"
	#include "./drivers/inc/slider_switches.h"
	#include "./drivers/inc/VGA.h"
	#include "./drivers/inc/ps2_keyboard.h"
	#include "./drivers/inc/audio_ASM.h"


/*
	void test_char() {
		int x, y;
		char c = 0;

		for (y = 0; y <= 59; y++) {
			for (x = 0; x <= 79; x++) {
				VGA_write_char_ASM(x, y, c++);
			}
		}
	}
	void test_byte(){
		int x, y;
		char c = 0;

		for (y = 0; y <= 59; y++) {
			for (x = 0; x <= 79; x +=3) {
				VGA_write_byte_ASM(x, y, c++);
			}
		}
	}

	void test_pixel(){
		int x, y;
		unsigned short colour = 0;

		for(y=0; y<=239; y++) {
			for(x=0; x<=319; x++) {
				VGA_draw_point_ASM(x, y, colour++);
			}
		}
	}

	int main(){
		while(1){

		if(read_slider_switches_ASM()!=0 && PB_data_is_pressed_ASM(PB0) ){
			test_byte();
		}
		if(read_slider_switches_ASM()==0 && PB_data_is_pressed_ASM(PB0)){
			test_char();
		}
		if(PB_data_is_pressed_ASM(PB1)){
			test_pixel();
		}
		if(PB_data_is_pressed_ASM(PB2)){
			VGA_clear_charbuff_ASM();
		}
		if(PB_data_is_pressed_ASM(PB3)){
			VGA_clear_pixelbuff_ASM();
		}
		}return 0;
	}


*/




/*
int main (){
	int x = 0;
	int y = 0;
	char c;

		while(1){
			if(read_PS2_data_ASM(&c) == 1){
				VGA_write_byte_ASM(x, y, c);
				x=x+3;
				if ( x > 79 ) {
					x = 0;
					y=y+1;
				}
			
				if ( y > 59 ) {
					y=0;
				}
			}
		}
}

*/





int main(){
		// sampling ratge is 48000 samples/sec
		//frequency = 100Hz

		//for each period, 480 samples
		// for every 240 sample, write a "1"
		// after 240 samples, write a "0"
	int data = 0x00FFFFFF;
	int x = 0; //counter


	while(1){

		if(audio_ASM(data)){	
			x++;
// if counter is smaller than 240, write '1'
// the other half, write '0'

//x reach 240, change data
			if(x > 239){
			//audio_ASM(0);
				x = 0;
				if(data == 0){
					data = 0x00FFFFFF;
				}else{
					data = 0;	
				}
			}
		}
	}
}


	


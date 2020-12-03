#include <stdio.h>
#include "./drivers/inc/vga.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"
void test_char(){
	int x,y;
	char c = 0;

	for(y=0 ; y<=59 ; y++)
		for(x=0 ; x<=79 ; x++)
			VGA_write_char_ASM(x,y,c++);
}

void test_byte(){
	int x,y;
	char c = 0;

	for(y=0 ; y<=59 ; y++)
		for(x=0 ; x<=79 ; x+=3)
			VGA_write_byte_ASM(x,y,c++);
}


void test_pixel(){
	int x,y;
	unsigned short colour = 0;

	for(y=0 ; y<=239 ; y++)
		for(x=0 ; x<=319 ; x++)
			VGA_draw_point_ASM(x,y,colour++);
}

int main(){
	//this is for Part 1
	/*
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();
	while(1){
		if(read_PB_data_ASM()==1){
			if(read_slider_switches_ASM()>0){
				test_byte();
			}
			else if(read_slider_switches_ASM()==0){
				test_char();
			}
		}
		else if(read_PB_data_ASM()==2){
			test_pixel();
		}
		else if(read_PB_data_ASM()==4){
			VGA_clear_charbuff_ASM();
		}
		else if(read_PB_data_ASM()==8){
			VGA_clear_pixelbuff_ASM();
		}
	}	
	
	
	// This is  Part 2
	char value;
	int x = 0;
	int y = 0;
	int max_x = 78;
	int max_y = 59;

	VGA_clear_charbuff_ASM();
	
	while(1) {
		if (read_PS2_data_ASM(&value)) {
			VGA_write_byte_ASM(x, y, value);
			x += 3;
			if (x > max_x) {
				x = 0;
				y += 1;
				if (y > max_y) {
					y = 0;
					VGA_clear_charbuff_ASM();
				}
			}			
		}
	}
*/
	// This is Part 3
	
	int i,x;				// i keeps track of the number of samples
							// x 
	int hi = 0x00FFFFFF; 	//hi signal
	int lo = 0;				//lo signal
	x = hi; 				//we initially want to assert the hi signal
	while(1){
		for(i=0 ; i < 240;){		 // we want to reach 100Hz, that's why we need that many samples
									//
			if(audio_write_ASM(x))
				i++;
		}
		if(x==hi){ 				//the if blocks switch the signal from hi to lo and vicer versa
			x=lo;
		}
		else if(x==lo){
			x=hi;
		}
	}
	
	return 0;
}

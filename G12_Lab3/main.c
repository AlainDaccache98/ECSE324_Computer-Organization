#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/int_setup.h"

int main() {
	//Part 1
	/*
	HEX_flood_ASM(HEX4);
	HEX_flood_ASM(HEX5);
	int ascii_offset = 48;

	while(1){
		write_LEDs_ASM(read_slider_switches_ASM());
		if(read_slider_switches_ASM() & 0x200){
			HEX_clear_ASM(HEX0);
			HEX_clear_ASM(HEX1);
			HEX_clear_ASM(HEX2);
			HEX_clear_ASM(HEX3);
			//HEX_clear_ASM(HEX4);
			//HEX_clear_ASM(HEX5);
		}
		else{

			int pushbutton = (read_PB_data_ASM());
			HEX_write_ASM(pushbutton, read_slider_switches_ASM()+ ascii_offset);//write the value on display
		}
	}

	//Part 2
	

	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim); //Config timer 1

	//This timer is for the pushbutton polling
	HPS_TIM_config_t hps_tim_pb;
	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 5000;
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 1;
	hps_tim_pb.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_pb); //config timer 2
	//declare our init
	int milliseconds = 0;
	int seconds = 0;
	int minutes = 0;
	int timerstart = 0;

	while (1) {
		//when timer for the timer seconds flags
		if (HPS_TIM_read_INT_ASM(TIM0) && timerstart) {
			HPS_TIM_clear_INT_ASM(TIM0);
			milliseconds += 10; //Timer is for 10 milliseconds

			//When milliseconds reach 1000, we increment seconds and reset milliseconds 
			if (milliseconds >= 1000) {
				milliseconds -= 1000;
				seconds++;
				//when seconds reach 60, we increment minutes and reset
				if (seconds >= 60) {
					seconds -= 60;
					minutes++;
					//we dont have hours
					if (minutes >= 60) {
						minutes = 0;
					}
				}
			}

			//Display values on HEX displays based on ASCII values
			HEX_write_ASM(HEX0, ((milliseconds % 100) / 10) + 48);
			HEX_write_ASM(HEX1, (milliseconds / 100) + 48);
			HEX_write_ASM(HEX2, (seconds % 10) + 48);
			HEX_write_ASM(HEX3, (seconds / 10) + 48);
			HEX_write_ASM(HEX4, (minutes % 10) + 48);
			HEX_write_ASM(HEX5, (minutes / 10) + 48);
		}

		
		//for the pushbuttons polling
		if (HPS_TIM_read_INT_ASM(TIM1)) {
			HPS_TIM_clear_INT_ASM(TIM1);
			int pb = 0xF & read_PB_data_ASM();
			//Start timer
			if ((pb & 1) && (!timerstart)) {
				timerstart = 1;		//setting timestart to 1 to start the reading process
			}
			//Stop timer
			else if ((pb & 2) && (timerstart)) {
				timerstart = 0;		//setting timestart to 0 to pause the reading and displaying process
			}
			//Reset timer
			else if (pb & 4) {
				milliseconds = 0;
				seconds = 0;
				minutes = 0;
				timerstart = 0;
				//making sure everything is set to 0 with ASCII offset
				HEX_write_ASM(HEX0, 48);
				HEX_write_ASM(HEX1, 48);
				HEX_write_ASM(HEX2, 48);
				HEX_write_ASM(HEX3, 48);
				HEX_write_ASM(HEX4, 48);
				HEX_write_ASM(HEX5, 48);
			}
		}
	}
*/	
	
	// Part 3 Interrupt
	
int_setup(2, (int[]) {73, 199 });
	enable_PB_INT_ASM(PB0 | PB1 | PB2);
	
	int count = 0;
	HPS_TIM_config_t hps_tim;
	//only need one timer
	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);
	int timerstart=0;
	int milliseconds = 0;
	int seconds = 0;
	int minutes = 0;
	
	while (1) {
		//each 10 ms, we increment, we only go when the subroutine flag is active
		if (hps_tim0_int_flag && timerstart) {
			hps_tim0_int_flag = 0;
			milliseconds += 10; 

			//When milliseconds reach 1000, we increment seconds and reset milliseconds 
			if (milliseconds >= 1000) {
				milliseconds -= 1000;
				seconds++;
				//increment seconds, until we reach 60, then increment minutes and reset
				if (seconds >= 60) {
					seconds -= 60;
					minutes++;
					//reset minutes since we have no hours
					if (minutes >= 60) {
						minutes = 0;
					}
				}
			}

			//Display values on HEX displays based on ASCII values
			HEX_write_ASM(HEX0, ((milliseconds % 100) / 10) + 48);
			HEX_write_ASM(HEX1, (milliseconds / 100) + 48);
			HEX_write_ASM(HEX2, (seconds % 10) + 48);
			HEX_write_ASM(HEX3, (seconds / 10) + 48);
			HEX_write_ASM(HEX4, (minutes % 10) + 48);
			HEX_write_ASM(HEX5, (minutes / 10) + 48);
		}
		//if pushbutton flag active, then the ISR is active
		if (pb_int_flag != 0){
			if(pb_int_flag == 1)
				timerstart=1;
			else if(pb_int_flag == 2)
				timerstart = 0;
			else if(pb_int_flag == 4 & timerstart==0){
				milliseconds = 0;
				seconds = 0;
				minutes = 0;
				HEX_write_ASM(HEX0, 48);
				HEX_write_ASM(HEX1, 48);
				HEX_write_ASM(HEX2, 48);
				HEX_write_ASM(HEX3, 48);
				HEX_write_ASM(HEX4, 48);
				HEX_write_ASM(HEX5, 48);
			}
			pb_int_flag = 0;
		}
	}
	
	return 0;
}



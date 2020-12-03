#include <stdlib.h>

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

int i = 0;
//base colour we start off with
short colour = 255;
//an integer array that takes the keys that the user entered
int notes-played[8] = {};
//a char array that displays the notes played 
char display_notes[8] = {};
//array holding the frequencies, index matched to the keys pressed
float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};

void displayNotesPlayed(int xPos, char notes){
	int i = 0;
	VGA_write_char_ASM(xPos,59,notes);
}
// Get the sample based on the frequency and the "index"
// Returns double: signal
double getSample(float f, int t) {
	double signal = 0.0;
	int index = ((int)f*t)%48000;
	float delta = (f*t)-index;
	if(delta = 0){
		signal = sine[index];
	}else{
		signal = (1.0 - delta) * sine[index] + delta * sine[index + 1];
	}
	return signal;
}

//This generates the signal from the samples
double makeSignal(int* note_played, int t){
	int index;
	double sample_sum = 0.0;
	
	//cycle through the notes the user entered
	for(index = 0;index<8;index++){
		//check if user entered a note, if so, add it
		if(notes_played[i] == 1){
			sample_sum += getSample(frequencies[i],t);
		}
	}
	return sample_sum;
}

void drawWords(){

	VGA_write_char_ASM(70, 59, 'V');
	VGA_write_char_ASM(71, 59, 'O');
	VGA_write_char_ASM(72, 59, 'L');
	VGA_write_char_ASM(73, 59, 'U');
	VGA_write_char_ASM(74, 59, 'M');
	VGA_write_char_ASM(75, 59, 'E');
	VGA_write_char_ASM(76, 59, ':');

}
int x;
int main() {
	// Setup timer
	VGA_clear_pixelbuff_ASM();
	int_setup(1, (int []){199});
	HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0; //microsecond timer
	hps_tim.timeout = 20; //1/48000 = 20.8 microseconds
	hps_tim.LD_en = 1; // initial count value
	hps_tim.INT_en = 1; //enabling the interrupt
	hps_tim.enable = 1; //enable bit to 1

	HPS_TIM_config_ASM(&hps_tim);
	
	//These two variables act as flags
	//keyReleased checks if a key is not pressed
	//keyPressed checks if a key is pressed 	
	char keyPressed = 1;
	// counter for signal
	int t = 0;
	// to store the previous set of drawn points for quicker clearing
	double old_wave[320] = { 0 };
	//double valToDraw = 0;

	char key_value;

	char amplitude = 1;
	double signalSum = 0.0;
	drawWords();            // drawing words from initial method
	while(1) {
			if(read_slider_switches_ASM()!=0){
				//we check keys
				if(read_ps2_data_ASM(&key_value)){
					switch(key_value){
						case 0x1C:
						if(key_pressed == 1){
							notes_played[0] = 1;
							di[0] = 'C';
							//colour += 500;
							//keyPressed = 0; //tester
						}else{
							notes_played[0] = 0;
							key_pressed = 1;
							display_notes[0] = ' ';
						}break;
						case 0x1B:
						if(key_pressed == 1){
							notes_played[1] = 1;
							display_notes[1] = 'D';
				
						}else{
							notes_played[1] = 0;
							key_pressed = 1;
							display_notes[1] = ' ';
						}break;
						case 0x23:
						if(key_pressed == 1){
							notes_played[2] = 1;
							display_notes[2] = 'E';
							
						}else{
							notes_played[2] = 0;
							key_pressed = 1;
							display_notes[2] = ' ';
						}break;
						case 0x2B:
						if(key_pressed == 1){
							notes_played[3] = 1;
							display_notes[3] = 'F';
							
						}else{
							notes_played[3] = 0;
							key_pressed = 1;
							display_notes[3] = ' ';
						}break;
						case 0x3B:
						if(key_pressed == 1){
							notes_played[4] = 1;
							display_notes[4] = 'G';
							
						}else{
							notes_played[4] = 0;
							key_pressed = 1;
							display_notes[4] = ' ';
						}break;
						case 0x42:
						if(key_pressed == 1){
							notes_played[5] = 1;
							display_notes[5] = 'A';
							
						}else{
							notes_played[5] = 0;
							key_pressed = 1;
							display_notes[5] = ' ';
						}break;
						case 0x4B:
						if(key_pressed == 1){
							notes_played[6] = 1;
							display_notes[6] = 'B';
							
						}else{
							notes_played[6] = 0;
							key_pressed = 1;
							display_notes[6] = ' ';
						}break;
						case 0x4C:
						if(key_pressed == 1){
							notes_played[7] = 1;
							display_notes[7] = 'C';
							
						}else{
							notes_played[7] = 0;
							key_pressed = 1;
							display_notes[7] = ' ';
						}break;
						case 0xF0:
							key_pressed = 0;
							break;
						case 0x43: //increase sound with key 'I'
						if(key_pressed ==1){
							if(amplitude <10){
								amplitude++;
							}
						}break;
						case 0x2D: //Decrease sound with key 'R'
						if(key_pressed == 1){
							if(amplitude !=0){
								amplitude--;
							}
						}
						default:
							key_pressed = 0;
					}
				}
			}
			signalSum = makeSignal(notes_played, t); //generate the signal at this t based on what keys were pressed

			signalSum = amplitude * signalSum; // volume control

			// Every 20 microseconds this flag goes high
			if(hps_tim0_int_flag == 1) {
				hps_tim0_int_flag = 0;
				audio_write_data_ASM(signalSum, signalSum);
				t++;
			}

			int drawIndex = 0;
			double valToDraw = 0;
			// To reduce the number of drawing operations
			if((t%10 == 0)){
				//draw volume number in bottom right
				if(amplitude == 10){
					VGA_write_byte_ASM(78, 59, 16);
				} else {
					//volume = 0-9
					VGA_write_byte_ASM(78, 59, amplitude);
				}

				drawIndex = (t/10)%320;
				//clear drawn points
				VGA_draw_point_ASM(drawIndex, old_wave[drawIndex], 0);
				//120 centers the signal on the screen, 500000 is abitrary to make it fit
				valToDraw = 120 + signalSum/500000;
				//add new points to history array
				old_wave[drawIndex] = valToDraw;
				//draw new points
				VGA_draw_point_ASM(drawIndex, valToDraw, colour);
			}
			
			// Reset the signal
			signalSum = 0;
			// Reset the counter
			if(t==48000){
				t=0;
			}
		
	}

	return 0;
}

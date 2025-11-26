/*
 * main.c
 *
 *  Created on: 26 nov. 2025
 *      Author: Yanis
 */


#include "system.h"
#include "io.h"
#include <stdio.h>



int main(){

	while(1){
		alt_u32 register_value = IORD(IP_TELEM_AVALON_0_BASE, 0);

		// Perform calculations on the register value
		// For example, let's assume we want to double the value
		alt_u32 result = (register_value * 7)/40000;

		// Print the result using printf
		printf("distance: %u\n", result);
		usleep(1000000);

	}


    return 0;
}

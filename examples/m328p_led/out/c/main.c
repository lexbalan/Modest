// out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"








static animation_AnimationState astate;

int16_t main()
{
	m328p_portB->dir = 0xFF;
	bsp_initTC1_PWM();

	bsp_tc1PWM_PB1(0);
	bsp_tc1PWM_PB2(0);

	//animation.startt(&astate)

	while (true) {
		//avr.portB.out = 0xFF
		//delay.ms(1000)

		//avr.portB.out = 0x00
		//delay.ms(1000)


		animation_step((animation_AnimationState *)&astate);
		delay_ms(10);
	}

	return 0;
}


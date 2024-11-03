// Blink example for Arduino Nano (ATMega328p)
// FCPU=16MHz
// LED connected to PORTB

import "avr/delay" as delay
import "avr/m328p" as avr

import "led" as led
import "animation"

import "bsp"


var astate: animation.AnimationState


public func main() -> Int16 {
	avr.portB.dir = 0xFF
	bsp.initTC1_PWM()

	bsp.tc1PWM_PB1(0)
	bsp.tc1PWM_PB2(0)

	//animation.startt(&astate)

	while true {
		//avr.portB.out = 0xFF
		//delay.ms(1000)

		//avr.portB.out = 0x00
		//delay.ms(1000)


		animation.step(&astate)
		delay.ms(10)
	}

	return 0
}


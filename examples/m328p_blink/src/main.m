// Blink example for Arduino Nano (ATMega328p)
// FCPU=16MHz
// LED connected to PORTB

import "avr/delay" as delay
import "avr/m328p" as avr


public func main () -> Int16 {
	avr.portB.dir = 0xff

	while true {
		avr.portB.out = 0xff
		delay.ms(1000)

		avr.portB.out = 0x00
		delay.ms(1000)
	}

	return 0
}


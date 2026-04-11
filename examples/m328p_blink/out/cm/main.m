private import "builtin"
private import "avr/delay"
private import "avr/m328p"

import "avr/delay" as delay
import "avr/m328p" as avr


public func main () -> Int16 {
	portB.dir = 0xFF

	while true {
		portB.out = 0xFF
		ms(1000)

		portB.out = 0x00
		ms(1000)
	}

	return 0
}



import "avr/delay"
import "avr/m328p"
public func main() -> Int16 {
	m328p.portB.dir = 0xFF

	while true {
		m328p.portB.out = 0xFF
		delay.ms(1000)

		m328p.portB.out = 0x00
		delay.ms(1000)
	}

	return 0
}


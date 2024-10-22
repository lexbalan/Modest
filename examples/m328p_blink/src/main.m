// Blink example for Arduino Nano (ATMega328p)
// FCPU=16MHz
// LED connected to PORTB

type IO8 Nat8
type IO16 Nat16

@packed
type GPIO record {
	in: IO8
	dir: IO8
	out: IO8
}

const sfrOffset = 0x20

public const portB = unsafe *GPIO (sfrOffset + 0x03)
public const portC = unsafe *GPIO (sfrOffset + 0x06)
public const portD = unsafe *GPIO (sfrOffset + 0x09)



// delay not calibrated
// just for example
var delay_counter: Nat32
func delay_ms(ms: Nat32) -> Unit {
	var t: Nat32 = ms
	while t > 0 {
		delay_counter = 0
		while delay_counter < 400 {
			++delay_counter
		}
		t = t - 1
	}
}


public func main() -> Int16 {
	portB.dir = 0xFF

	while true {
		portB.out = 0xFF
		delay_ms(1000)

		portB.out = 0x00
		delay_ms(1000)
	}

	return 0
}


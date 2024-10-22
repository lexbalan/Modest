

type IO8 Nat8
type IO16 Nat16


type GPIO record {
	in: IO8
	dir: IO8
	out: IO8
}
const sfrOffset = 0x20
var delay_counter: Nat32
func delay_ms(ms: Nat32) -> Unit {
	var t: Nat32 = ms
	while t > 0 {
		delay_counter = 0
		while delay_counter < 400 {
			delay_counter = delay_counter + 1
		}
		t = t - 1
	}
}
public const portB = *GPIO (sfrOffset + 0x03)
public const portC = *GPIO (sfrOffset + 0x06)
public const portD = *GPIO (sfrOffset + 0x09)
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


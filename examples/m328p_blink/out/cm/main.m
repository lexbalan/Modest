
import "delay"

type IO8 Nat8
type IO16 Nat16


type GPIO record {
	in: IO8
	dir: IO8
	out: IO8
}
const sfrOffset = 0x20
public const portB = *GPIO (sfrOffset + 0x03)
public const portC = *GPIO (sfrOffset + 0x06)
public const portD = *GPIO (sfrOffset + 0x09)
public func main() -> Int16 {
	portB.dir = 0xFF

	while true {
		portB.out = 0xFF
		delay.ms(1000)

		portB.out = 0x00
		delay.ms(1000)
	}

	return 0
}


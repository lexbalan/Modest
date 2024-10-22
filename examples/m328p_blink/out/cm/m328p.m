
include "avr"
const sfrOffset = 0x20


public type GPIO record {
	in: IO8
	dir: IO8
	out: IO8
}
public const portB = *GPIO (sfrOffset + 0x03)
public const portC = *GPIO (sfrOffset + 0x06)
public const portD = *GPIO (sfrOffset + 0x09)


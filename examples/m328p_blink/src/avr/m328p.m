// avr/m328p

include "avr"


public type GPIO = @public @packed record {
	in: IO8
	dir: IO8
	out: IO8
}


const sfrOffset = Nat16 0x20

public const portB = unsafe *GPIO Word16 (sfrOffset + Nat16 0x03)
public const portC = unsafe *GPIO Word16 (sfrOffset + Nat16 0x06)
public const portD = unsafe *GPIO Word16 (sfrOffset + Nat16 0x09)


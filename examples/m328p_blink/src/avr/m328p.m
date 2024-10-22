
include "avr"

@packed
public type GPIO record {
	in: IO8
	dir: IO8
	out: IO8
}

private const sfrOffset = 0x20

public const portB = unsafe *GPIO (sfrOffset + 0x03)
public const portC = unsafe *GPIO (sfrOffset + 0x06)
public const portD = unsafe *GPIO (sfrOffset + 0x09)


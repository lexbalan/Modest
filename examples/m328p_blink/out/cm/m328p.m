
include "avr"


public type GPIO record {
	public in: IO8
	public dir: IO8
	public out: IO8
}
const sfrOffset = 0x20
public const portB = *GPIO (sfrOffset + 0x03)
public const portC = *GPIO (sfrOffset + 0x06)
public const portD = *GPIO (sfrOffset + 0x09)



include "avr"


public type GPIO = @packed record {
	public in: IO8
	public dir: IO8
	public out: IO8
}

private const sfrOffset = 0x20

public const portB = unsafe *GPIO (sfrOffset + 0x03)
public const portC = unsafe *GPIO (sfrOffset + 0x06)
public const portD = unsafe *GPIO (sfrOffset + 0x09)


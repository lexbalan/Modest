// avr/m328p

pragma unsafe

include "avr"


public type GPIO = @public @layout("packed") {
	in: IO8
	dir: IO8
	out: IO8
}


// должен быть public изза того что константы ниже зависят от него но зависимости не подтягиваются
// TODO: fixit!
public const sfrOffset = Nat16 0x20

public const portB = unsafe * @volatile GPIO Word16 (sfrOffset + Nat16 0x03)
public const portC = unsafe * @volatile GPIO Word16 (sfrOffset + Nat16 0x06)
public const portD = unsafe * @volatile GPIO Word16 (sfrOffset + Nat16 0x09)


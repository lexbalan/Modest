private import "builtin"
include "avr"



public type GPIO = @public @layout {
	in: IO8
	dir: IO8
	out: IO8
}


// должен быть public изза того что константы ниже зависят от него но зависимости не подтягиваются
// TODO: fixit!
public const sfrOffset = Nat16 0x20

public const portB: *GPIO = unsafe *GPIO unsafe Word16 (sfrOffset + unsafe Nat16 0x03)
public const portC: *GPIO = unsafe *GPIO unsafe Word16 (sfrOffset + unsafe Nat16 0x06)
public const portD: *GPIO = unsafe *GPIO unsafe Word16 (sfrOffset + unsafe Nat16 0x09)


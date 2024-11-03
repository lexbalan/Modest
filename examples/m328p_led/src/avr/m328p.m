
include "avr"

@packed
public type GPIO record {
	public in: IO8
	public dir: IO8
	public out: IO8
}


@packed
public type TC1 record {
	public cr1a: Word8
	public cr1b: Word8
	public cr1c: Word8
	public reserved0: Word8
	public cnt1: Nat16  // 0x84-0x85
	public icr1: Nat16  // 0x86-0x87
	public ocr1a: Nat16 // 0x88-0x89
	public ocr1b: Nat16 // 0x8A-0x8B
	//public timsk1: Word8 // 0x6F
	//public tifr1: Word8 // 0x36
}

public const cr1a_WGM10 = 0
public const cr1a_WGM11 = 1
public const cr1a_COM1B0 = 4
public const cr1a_COM1B1 = 5
public const cr1a_COM1A0 = 6
public const cr1a_COM1A1 = 7

public const cr1b_CS10 = 0
public const cr1b_CS11 = 1
public const cr1b_CS12 = 2
public const cr1b_WGM12 = 3
public const cr1b_WGM13 = 4
public const cr1b_ICES1 = 6
public const cr1b_ICNC1 = 7


public const portB = unsafe *GPIO (sfrOffset + 0x03)
public const portC = unsafe *GPIO (sfrOffset + 0x06)
public const portD = unsafe *GPIO (sfrOffset + 0x09)

// BUG! 0 +
public const tc1 = unsafe *TC1 (0 + 0x80)



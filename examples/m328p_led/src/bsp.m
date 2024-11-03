
include "avr/m328p"


// TC1 (16bit) OC1A=PB1=`ARDUINO_D9, OC1B=PB2=`ARDUINO_D10

public func initTC1_PWM() {
	// 10bit fast pwm (up to 0x03FF)
	let a = (Word8 1 << cr1a_WGM10) or (Word8 1 << cr1a_WGM11)
	tc1.cr1a = a or (Word8 1 << cr1a_COM1A1) or (Word8 1 << cr1a_COM1B1)
	tc1.cr1b = (Word8 1 << cr1b_CS10) or (Word8 1 << cr1b_WGM12) // no clk div
}

public func tc1PWM_PB1(x: Nat16) {
	tc1.ocr1a = x / 2
}

public func tc1PWM_PB2(x: Nat16) {
	tc1.ocr1b = x / 2
}


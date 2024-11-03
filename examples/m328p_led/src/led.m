
include "libc/stdio"

import "bsp"

const divider = 256

public type LedController record {
	run: Bool    // разрешение на работу

	brightness: Nat32
	target_brightness: Nat32

	step: Int32  // brightness step

	// когда stepNo == stepEnd еонтроллер чилит
	stepNo: Nat32
	stepEnd: Nat32
}


public func init() {
	//bsp.initTC1_PWM()

	//bsp.tc1PWM_PB1(8)
	//bsp.tc1PWM_PB2(8)
}

public func isFree(led: *LedController) -> Bool {
	return led.stepNo == led.stepEnd
}


// Выставляет яркость (принимает в миллиЯркости)
func ledSet(brightness: Nat32) -> Unit {
	let b = brightness / divider
	//ledPwmSet(b)
	////printf("PWM = %d\n", b)

	// PB2 = RED
	bsp.tc1PWM_PB2(unsafe Nat16 b)
}


// Сбрасывает лед в исходное состояние и на 0 яркость
public func reset(led: *LedController) {
	*led = {}
	ledSet(0)
}


// a = current brightness
// b = target brightness
func calcStep(a: Nat32, b: Nat32, time: Nat32) -> Int32 {
	let diff = Int32 b - Int32 a
	let stepp = diff / Int32 time
	return stepp  // error step!
}


public func start(led: *LedController, brightness: Nat8, time: Nat32) {
	led.stepNo = 0
	led.stepEnd = time
	led.step = calcStep(led.brightness, (Nat32 brightness * divider), time)
	led.run = true

	//printf("start:\n")
	//printf("brightness = %d\n", brightness)
	//printf("step = %d\n", led.step)
	//printf("stepEnd = %d\n", led.stepEnd)
}


public func step(led: *LedController) {
	if not led.run {
		return
	}

	if led.stepNo == led.stepEnd {
		led.run = false
		return
	}

	let brightness = Nat32 (Int32 led.brightness + led.step)
	led.brightness = brightness

	//printf("[%d]", led.stepNo)
	ledSet(brightness)

	++led.stepNo
}



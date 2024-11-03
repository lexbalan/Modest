
include "libc/stdio"
import "led" as led


type Color record {
	red: Nat8
	green: Nat8
	blue: Nat8
}

type AnimationPoint record {
	brightness: Nat8
	time: Nat32  // In ms; 0=instant
}

type Animation record {
	len: Nat32  // number of points
	points: *[]AnimationPoint
}

public type AnimationState record {
	run: Bool
	animation: *Animation
	cpoint: Nat32
	stopSig: Bool
}


var led0: led.LedController


var animation0_points = [4]AnimationPoint [
	{brightness=120, time=200}
	{brightness=120, time=200}
	{brightness=80, time=200}
	{brightness=0, time=200}
]

var animation0 = Animation {
	len = lengthof(animation0_points)
	points = &animation0_points
}



public func isBusy(astate: *AnimationState) -> Bool {
	return astate.run
}


public func stop(astate: *AnimationState) -> Unit {
	printf("STOP\n")
	astate.stopSig = true
}


public func startt(astate: *AnimationState) -> Unit {
	start(astate, &animation0)
}


public func start(astate: *AnimationState, a: *Animation) -> Unit {
	astate.cpoint = 0
	astate.animation = a
	astate.run = true
}


public func step(astate: *AnimationState) -> Unit {
	if not astate.run {
		return
	}

	let animation = astate.animation
	if animation == nil {
		return
	}

	// Если выработали все точки - заканчиваем
	if astate.cpoint > animation.len or astate.stopSig {
		astate.animation = nil
		astate.run = false
		return
	}

	// Если мы здесь значит анимация должна выполняться
	// Смотрим если лед пришел в предыдущую точку то даем след задание

	if led.isFree(&led0) {
		let p = &astate.animation.points[astate.cpoint]
		++astate.cpoint
		led.start(&led0, p.brightness, p.time)
	}

	led.step(&led0)
}



// delay not calibrated
// just for example


public func ms(x: Nat32) -> Unit {
	var t = x
	while t > 0 {
		var delayCounter = Nat32 0
		while delayCounter < 400 {
			++delayCounter
		}
		t = t - 1
	}
}


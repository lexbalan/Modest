// delay not calibrated
// just for example

var delayCounter: Nat32


public func ms(x: Nat32) -> Unit {
	var t = x
	while t > 0 {
		delayCounter = 0
		while delayCounter < 400 {
			++delayCounter
		}
		t = t - 1
	}
}



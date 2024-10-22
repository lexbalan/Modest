
var delayCounter: Nat32
public func ms(x: Nat32) -> Unit {
	var t: Nat32 = x
	while t > 0 {
		delayCounter = 0
		while delayCounter < 400 {
			delayCounter = delayCounter + 1
		}
		t = t - 1
	}
}


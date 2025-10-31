
var delayCounter: Nat32 = Nat32 0
public func ms(x: Nat32) -> Unit {
	var t: Nat32 = x
	while t > 0 {
		delayCounter = Nat32 0
		while delayCounter < 380 {
			delayCounter = delayCounter + 1
		}
		t = t - 1
	}
}


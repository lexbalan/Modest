// delay not calibrated
// just for example

@attribute("value:volatile")
var delayCounter = Nat32 0

public func ms(x: Nat32) -> Unit {
	var t = x
	while t > 0 {
		delayCounter = Nat32 0
		while delayCounter < 380 {
			++delayCounter
		}
		t = t - 1
	}
}

// delay not calibrated
// just for example

var delayCounter: @volatile Nat32 =  0

public func ms (x: Nat32) -> Unit {
	var t: @volatile Nat32 = x
	while t > 0 {
		var delayCounter: @volatile Nat32 =  0
		while delayCounter < 380 {
			++delayCounter
		}
		--t
	}
}


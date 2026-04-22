// tests/0/clockchain/main.m

include "libc/ctypes64"
include "libc/stdio"


type CallbackData = {}
type ClockCallback = (clock: *Clock) -> Unit
type Clock = {
	next: *Clock
	counter: Nat32
	expired: Bool
	callbackData: *CallbackData
	callback: *ClockCallback
}


var clockchain: *Clock


func tickClock (self: *Clock) -> Unit {
	if self.counter > 0 {
		--self.counter
		self.expired = self.counter == 0
	}
}

func taskClock (self: *Clock) -> Unit {
	if self.expired {
		if self.callback != nil {
			self.callback(self)
		}
		self.expired = self.counter == 0
	}
}

func addClock (clock: *Clock) -> Unit {
	if clockchain == nil {
		clockchain = clock
	} else {
		var c = clockchain
		while c.next != nil {
			c = c.next
		}
		c.next = clock
		clock.next = nil
	}
}

func foreachClockInChain (clockchain: *Clock, handler: *(self: *Clock) -> Unit) -> Unit {
	var c = clockchain
	if c != nil {
		while c.next != nil {
			handler(c)
			c = c.next
		}
	}
}

func tickClockchain (clockchain: *Clock) -> Unit {
	foreachClockInChain(clockchain, &tickClock)
}

func taskClockchain (clockchain: *Clock) -> Unit {
	foreachClockInChain(clockchain, &taskClock)
}


public func main () -> Int {
	//var clocks = [new Clock {}, new Clock {}, new Clock {}]  // <<-- not works!

	var clocks: [3]*Clock

	clocks[0] = new Clock {}
	clocks[1] = new Clock {}
	clocks[2] = new Clock {}

	addClock(clocks[0])
	addClock(clocks[1])
	addClock(clocks[2])

	var i = Nat32 10000
	while i > 0 {
		tickClockchain(clockchain)

		if i % 10 == 0 {
			taskClockchain(clockchain)
		}

		--i
	}

	return 0
}

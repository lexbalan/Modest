// tests/0/clockchain/main.m

include "libc/ctypes64"
include "libc/stdio"


type CallbackData = {}
type ClockCallback = (clock: *Clock, data: *CallbackData) -> Unit
type Clock = {
	identifier: *Str8
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
			self.callback(self, self.callbackData)
		}
		self.expired = false
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
	var c: *Clock = clockchain
	while c != nil {
		handler(c)
		c = c.next
	}
}

func tickClockchain (clockchain: *Clock) -> Unit {
	foreachClockInChain(clockchain, &tickClock)
}

func taskClockchain (clockchain: *Clock) -> Unit {
	foreachClockInChain(clockchain, &taskClock)
}


func clockCallback: ClockCallback {
	printf("Clock %s expired.\n", clock.identifier)
}


func main () -> Int {
	var clocks = [
		new Clock {identifier="clock1", counter=100, callback=&clockCallback}
		new Clock {identifier="clock2", counter=200, callback=&clockCallback}
		new Clock {identifier="clock3", counter=500, callback=&clockCallback}
	]

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


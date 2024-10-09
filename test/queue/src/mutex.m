
let stateOpen = false
let stateClose = true

public type Mutex record {
	state: @volatile @atomic Bool
}


func __enable_irq() {}
func __disable_irq() {}


public func init(x: *Mutex) {
	release(x)
}


// попытка захвата мьютекса
public func acquire(x: *Mutex) -> Bool {
	// отпустили, вырубаем прерывания
	__disable_irq()

	if x.state == stateClose {
		__enable_irq()
		return false
	}

	x.state = stateClose

	__enable_irq()

	return true
}


// отпускаем мьютекс
public func release(x: *Mutex) {
	x.state = stateOpen
}


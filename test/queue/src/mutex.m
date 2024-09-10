
let stateOpen = false
let stateClose = true

export type Mutex record {
	state: @volatile @atomic Bool
}


func __enable_irq() {}
func __disable_irq() {}


export func init(x: *Mutex) {
	release(x)
}


// попытка захвата мьютекса
export func acquire(x: *Mutex) -> Bool {
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
export func release(x: *Mutex) {
	x.state = stateOpen
}


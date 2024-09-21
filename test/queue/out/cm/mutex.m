
let stateOpen = false
let stateClose = true
func __enable_irq() -> Unit {}
func __disable_irq() -> Unit {}

export type Mutex record {
	state: Bool
}
export func init(x: *Mutex) -> Unit {
	release(x)
}
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
export func release(x: *Mutex) -> Unit {
	x.state = stateOpen
}


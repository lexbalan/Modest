
include "libc/ctypes64"
include "libc/ctypes"
include "libc/stdio"
import "lightfood/delay"
import "fsm"
let flashlightStateOff = 0
let flashlightStateOn = 1
let flashlightStateBeacon = 2
var cnt: Nat8
var fsm: FSM = {
	name = "Flash"
	state = 0
	nexstate = 0
	substate = fsm.substateEntering
	states = [
		{
			name = "Off"
			entry = &off_entry
			loop = &off_loop
			exit = &off_exit
		}

		{
			name = "On"
			entry = &on_entry
			loop = &on_loop
			exit = &on_exit
		}

		{
			name = "Beacon"
			entry = &beacon_entry
			loop = &beacon_loop
			exit = &beacon_exit
		}
	]
}
func off_entry(x: *FSM) -> Unit {
	Unit x
	//printf("off_entry\n")
}
func off_loop(x: *FSM) -> Unit {
	printf("off_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOn)
	}
}
func off_exit(x: *FSM) -> Unit {
	Unit x
	//printf("off_exit\n")
}
func on_entry(x: *FSM) -> Unit {
	Unit x
	//printf("on_entry\n")
}
func on_loop(x: *FSM) -> Unit {
	printf("on_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateBeacon)
	}
}
func on_exit(x: *FSM) -> Unit {
	Unit x
	//printf("on_exit\n")
}
func beacon_entry(x: *FSM) -> Unit {
	let from_name = fsm.state_no_name(x, x.state)
	printf("beacon_entry from %s\n", from_name)
}
func beacon_loop(x: *FSM) -> Unit {
	printf("beacon_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOff)
	}
}
func beacon_exit(x: *FSM) -> Unit {
	let to_name = fsm.state_no_name(x, x.nexstate)
	printf("beacon_exit to %s\n", to_name)
}
func main() -> Int {

	while true {
		fsm.run(&fsm)
		delay.ms(500)
	}

	return 0
}


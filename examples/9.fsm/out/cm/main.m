import "lightfood/delay"
import "fsm"
include "ctypes64"
include "stdio"


// This is flashlight final state machine example
// (just for compiler test and language demonstration)
import "lightfood/delay" as delay
import "fsm" as fsm

// This is flashlight final state machine example
// (just for compiler test and language demonstration)


const flashlightStateOff = 0
const flashlightStateOn = 1
const flashlightStateBeacon = 2


var cnt: Nat8


//
// State Off
//

func off_entry (x: *FSM) -> Unit {
	Unit x
	//printf("off_entry\n")
}


func off_loop (x: *FSM) -> Unit {
	printf("off_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOn)
	}
}


func off_exit (x: *FSM) -> Unit {
	Unit x
	//printf("off_exit\n")
}


//
// State On
//

func on_entry (x: *FSM) -> Unit {
	Unit x
	//printf("on_entry\n")
}


func on_loop (x: *FSM) -> Unit {
	printf("on_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateBeacon)
	}
}


func on_exit (x: *FSM) -> Unit {
	Unit x
	//printf("on_exit\n")
}


//
// State Beacon
//

func beacon_entry (x: *FSM) -> Unit {
	let from_name: *Str8 = fsm.state_no_name(x, x.state)
	printf("beacon_entry from %s\n", from_name)
}


func beacon_loop (x: *FSM) -> Unit {
	printf("beacon_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOff)
	}
}


func beacon_exit (x: *FSM) -> Unit {
	let to_name: *Str8 = fsm.state_no_name(x, x.nexstate)
	printf("beacon_exit to %s\n", to_name)
}



var fsm0: FSM = {
	name = "Flash"
	state = 0
	nexstate = 0
	substate = fsm.substateEntering
	states = States [
		StateDesc {
			name = "Off"
			entry = &off_entry
			loop = &off_loop
			exit = &off_exit
		}

		StateDesc {
			name = "On"
			entry = &on_entry
			loop = &on_loop
			exit = &on_exit
		}

		StateDesc {
			name = "Beacon"
			entry = &beacon_entry
			loop = &beacon_loop
			exit = &beacon_exit
		}
	]
}



public func main () -> Int {
	while true {
		fsm.run(&fsm0)
		delay.ms(500)
	}

	return 0
}


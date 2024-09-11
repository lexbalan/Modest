// examples/fsm/src/main.cm

// This is flashlight final state machine example
// (just for compiler test and language demonstration)

include "libc/ctypes64"
include "libc/ctypes"
include "libc/stdio"

include "lightfood/delay"

import "fsm"

//@attribute("c_no_print")
//import "lightfood/main"
//@attribute("c_no_print")

//$pragma c_include "./ff_main.h"
//$pragma c_include "./ff_delay.h"



let flashlightStateOff = 0
let flashlightStateOn = 1
let flashlightStateBeacon = 2


var cnt: Nat8


//
// State Off
//

func off_entry(fsm: *fsm.FSM) {
	Unit fsm  // ignore argument
	//printf("off_entry\n")
}


func off_loop(fsm: *fsm.FSM) {
	Unit fsm

	printf("off_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(fsm, flashlightStateOn)
	}
}


func off_exit(fsm: *fsm.FSM) {
	Unit fsm  // ignore argument
	//printf("off_exit\n")
}


//
// State On
//

func on_entry(fsm: *fsm.FSM) {
	Unit fsm  // ignore argument
	//printf("on_entry\n")
}


func on_loop(fsm: *fsm.FSM) {
	Unit fsm  // ignore argument
	printf("on_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(fsm, flashlightStateBeacon)
	}
}


func on_exit(fsm: *fsm.FSM) {
	Unit fsm  // ignore argument
	//printf("on_exit\n")
}


//
// State Beacon
//

func beacon_entry(fsm: *fsm.FSM) {
	let from_name = fsm.state_no_name(fsm, fsm.state)
	printf("beacon_entry from %s\n", from_name)
}


func beacon_loop(fsm: *fsm.FSM) {
	printf("beacon_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(fsm, flashlightStateOff)
	}
}


func beacon_exit(fsm: *fsm.FSM) {
	let to_name = fsm.state_no_name(fsm, fsm.nexstate)
	printf("beacon_exit to %s\n", to_name)
}



var fsm: fsm.FSM = {
	name = "Flash"
	state = 0
	nexstate = 0
	substate = fsmSubstateEntering
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



func main() -> Int {

	while true {
		fsm.run(&fsm)
		delay_ms(500)
	}

	return 0
}


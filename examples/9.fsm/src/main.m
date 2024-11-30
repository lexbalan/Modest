// examples/fsm/src/main.m

// This is flashlight final state machine example
// (just for compiler test and language demonstration)

include "libc/ctypes64"
include "libc/stdio"

import "lightfood/delay"
import "fsm"

//@attribute("c_no_print")
//import "lightfood/main"
//@attribute("c_no_print")

//$pragma c_include "./ff_main.h"
$pragma c_include "./delay.h"



const flashlightStateOff = 0
const flashlightStateOn = 1
const flashlightStateBeacon = 2


var cnt: Nat8


//
// State Off
//

func off_entry(x: *fsm.FSM) {
	Unit x  // ignore argument
	//printf("off_entry\n")
}


func off_loop(x: *fsm.FSM) {
	printf("off_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOn)
	}
}


func off_exit(x: *fsm.FSM) {
	Unit x  // ignore argument
	//printf("off_exit\n")
}


//
// State On
//

func on_entry(x: *fsm.FSM) {
	Unit x  // ignore argument
	//printf("on_entry\n")
}


func on_loop(x: *fsm.FSM) {
	printf("on_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateBeacon)
	}
}


func on_exit(x: *fsm.FSM) {
	Unit x  // ignore argument
	//printf("on_exit\n")
}


//
// State Beacon
//

func beacon_entry(x: *fsm.FSM) {
	let from_name = fsm.state_no_name(x, x.state)
	printf("beacon_entry from %s\n", from_name)
}


func beacon_loop(x: *fsm.FSM) {
	printf("beacon_loop\n")
	if cnt < 10 {
		cnt = cnt + 1
	} else {
		cnt = 0
		fsm.switch(x, flashlightStateOff)
	}
}


func beacon_exit(x: *fsm.FSM) {
	let to_name = fsm.state_no_name(x, x.nexstate)
	printf("beacon_exit to %s\n", to_name)
}



var fsm: fsm.FSM = {
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



public func main() -> Int {

	while true {
		fsm.run(&fsm)
		delay.ms(500)
	}

	return 0
}


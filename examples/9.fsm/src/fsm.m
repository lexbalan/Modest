// examples/fsm/fsm.cm

import "libc/stdio"

import "./fsm"


let verbose = true


let nameMaxLength = 8
let maxStates = 16


export type FSM_Proc *(fsm: *FSM) -> Unit

export type FSM_StateDesc record {
	name: [nameMaxLength]Char8
	entry: FSM_Proc
	loop: FSM_Proc
	exit: FSM_Proc
}


let fsmSubstateEntering = 0
let fsmSubstateLoop = 1
let fsmSubstateLeaving = 2

export type UInt32 Nat32

export type FSM record {
	name: [nameMaxLength]Char8
	state: UInt32
	nexstate: UInt32
	substate: UInt32
	states: [maxStates]FSM_StateDesc
}



export func state_no_name(fsm: *FSM, state_no: Nat32) -> *Str8 {
	return &fsm.states[state_no].name
}


export func switch(fsm: *FSM, state: Nat32) {
	fsm.nexstate = state
	fsm.substate = fsmSubstateLeaving
}


export func run(fsm: *FSM) {
	printf("fsm::run()\n")

	if fsm.substate == fsmSubstateEntering {
		let nexstate = fsm.nexstate
		let state = &fsm.states[nexstate]

		if verbose {
			printf("enter %s\n", &state.name)
		}

		if state.entry != nil {
			state.entry(fsm)
		}

		fsm.state = nexstate
		fsm.substate = fsmSubstateLoop

	} else if fsm.substate == fsmSubstateLoop {
		let state = &fsm.states[fsm.state]

		if state.loop != nil {
			state.loop(fsm)
		}

	} else if fsm.substate == fsmSubstateLeaving {
		let state = &fsm.states[fsm.state]

		if verbose {
			printf("exit %s\n", &state.name)
		}

		if state.exit != nil {
			state.exit(fsm)
		}

		fsm.substate = fsmSubstateEntering
	}
}



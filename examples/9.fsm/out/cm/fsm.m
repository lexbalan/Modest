
include "libc/stdio"
let verbose = true
public const nameMaxLength = 8

public type UInt32 Nat32

public type FSM_StateDesc record {
	name: [nameMaxLength]Char8
	entry: FSM_Proc
	loop: FSM_Proc
	exit: FSM_Proc
}
public const maxStates = 16

public type FSM record {
	name: [nameMaxLength]Char8
	state: UInt32
	nexstate: UInt32
	substate: UInt32
	states: [maxStates]FSM_StateDesc
}


public type FSM_Proc *(fsm: *FSM) -> Unit
public const substateEntering = 0
public const substateLoop = 1
public const substateLeaving = 2
public func state_no_name(fsm: *FSM, state_no: Nat32) -> *Str8 {
	return &fsm.states[state_no].name
}
public func switch(fsm: *FSM, state: Nat32) -> Unit {
	fsm.nexstate = state
	fsm.substate = substateLeaving
}
public func run(fsm: *FSM) -> Unit {
	printf("fsm::run()\n")

	if fsm.substate == substateEntering {
		let nexstate = fsm.nexstate
		let state = &fsm.states[nexstate]

		if verbose {
			printf("enter %s\n", &state.name)
		}

		if state.entry != nil {
			state.entry(fsm)
		}

		fsm.state = nexstate
		fsm.substate = substateLoop

	} else if fsm.substate == substateLoop {
		let state = &fsm.states[fsm.state]

		if state.loop != nil {
			state.loop(fsm)
		}

	} else if fsm.substate == substateLeaving {
		let state = &fsm.states[fsm.state]

		if verbose {
			printf("exit %s\n", &state.name)
		}

		if state.exit != nil {
			state.exit(fsm)
		}

		fsm.substate = substateEntering
	}
}


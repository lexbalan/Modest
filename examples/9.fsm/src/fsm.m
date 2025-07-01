// examples/fsm/fsm.cm

include "libc/stdio"


const verbose = true

// Вынужден добавлять public тк иначе не идет в хедер к структуре
// Короче, проблема зависимостей тяжело зависла в воздухе
public const nameMaxLength = 8
public const maxStates = 16


public type Handler = (x: *FSM) -> Unit

public type StateDesc = record {
	public name: [nameMaxLength]Char8
	public entry: *Handler
	public loop: *Handler
	public exit: *Handler
}


public const substateEntering = 0
public const substateLoop = 1
public const substateLeaving = 2


public type FSM = record {
	public name: [nameMaxLength]Char8
	public state: Nat32
	public nexstate: Nat32
	public substate: Nat32
	public states: [maxStates]StateDesc
}


public func state_no_name(fsm: *FSM, state_no: Nat32) -> *Str8 {
	return &fsm.states[state_no].name
}


public func switch (fsm: *FSM, state: Nat32) -> Unit {
	fsm.nexstate = state
	fsm.substate = substateLeaving
}


public func run (fsm: *FSM) -> Unit {
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



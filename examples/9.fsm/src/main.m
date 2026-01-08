// examples/fsm/src/main.m

include "libc/ctypes64"
include "libc/stdio"

import "fsm"


var fsm0: fsm.FSM


var state0 = fsm.StateDesc {id="state0", nstages=4, handler=&routine0}
var state1 = fsm.StateDesc {id="state1", nstages=4, handler=&routine1}
var state2 = fsm.StateDesc {id="state2", nstages=4, handler=&routine2}


func routine0 (state: fsm.ComplexState, payload: Ptr) -> fsm.ComplexState {
	if state.stage == fsm.StageId 0 {
		return fsm.cmdNextStage(&fsm0)
	} else if state.stage == fsm.StageId 1 {
		return fsm.cmdNextStageLimited(&fsm0, t=2000)
	} else if state.stage == fsm.StageId 2 {
		// just stay
	} else if state.stage == fsm.StageId 3 {
		return fsm.cmdSwitchState(&fsm0, &state1)
	}
	return state
}


func routine1 (state: fsm.ComplexState, payload: Ptr) -> fsm.ComplexState {
	if state.stage == fsm.StageId 0 {
		return fsm.cmdNextStage(&fsm0)
	} else if state.stage == fsm.StageId 1 {
		return fsm.cmdNextStageLimited(&fsm0, t=2000)
	} else if state.stage == fsm.StageId 2 {
		// just stay
	} else if state.stage == fsm.StageId 3 {
		return fsm.cmdSwitchState(&fsm0, &state2)
	}
	return state
}


func routine2 (state: fsm.ComplexState, payload: Ptr) -> fsm.ComplexState {
	if state.stage == fsm.StageId 0 {
		return fsm.cmdNextStage(&fsm0)
	} else if state.stage == fsm.StageId 1 {
		return fsm.cmdNextStageLimited(&fsm0, t=2000)
	} else if state.stage == fsm.StageId 2 {
		// just stay
	} else if state.stage == fsm.StageId 3 {
		return fsm.cmdSwitchState(&fsm0, &state0)
	}
	return state
}


var timecnt: Nat32


public func main () -> Int {
	fsm.init(&fsm0, id="FSM_0", initState=&state0, payload=nil)

	while true {
		if timecnt > 55555 {
			timecnt = 0
			fsm.task_1ms(&fsm0)
		} else {
			++timecnt
		}

		fsm.task(&fsm0)
	}

	return 0
}


// examples/fsm/fsm.cm
/*
 * FSM
 */

include "libc/assert"
include "libc/stdio"


public type StateServiceRoutine = (state: ComplexState, payload: *Unit) -> ComplexState

// State descriptor
public type StateDesc = record {
    id: *Str8
    nstages: Nat16
    handler: *StateServiceRoutine
}

public type StageId = @brand Word16
public const stageIdDefault = StageId 0

public type ComplexState = @public record {
	state: *StateDesc
	stage: StageId
}

public type FSM = record {
    id: *Str8
	anyPre: *StateServiceRoutine
	anyPost: *StateServiceRoutine
	state: ComplexState
	next_state: ComplexState
	payload: *Unit

	limit: Nat32

	timer: Nat32
	timer_expired: Bool
}


public func init (self: *FSM, id: *Str8, initState: *StateDesc, payload: *Unit) -> Unit {
    self.id = id
	self.state = {state=initState, stage=stageIdDefault}
	self.next_state = {state=initState, stage=stageIdDefault}
    self.payload = payload
	self.anyPre = nil
	self.anyPost = nil
	self.timer = 0
	self.timer_expired = false
}


// Обработчик смены состояния
func handlex (self: *FSM) -> Unit {
	if self.state == self.next_state {
		return
	}
	// Обрабатываем заказ на смену состояния
	let state = self.state
	let next_state = self.next_state
	printf("[%s] #%s_%u -> #%s_%u\n", self.id, state.state.id, state.stage, next_state.state.id, next_state.stage)
	self.state = self.next_state
}


public func task (self: *FSM) -> Unit {

	if self.timer_expired {
		// Clear timer & Switch to next stage
		self.timer_expired = false
		self.next_state = cmdNextStage(self)
		let top = Nat32 0
		printf("[%s] fsm timeout (%u) occured, switch_to_stage(%d)\n", self.id, top, self.next_state.stage)
	}

	handlex(self)

	// Limited stage time handling
	if self.limit != 0 {
	 	self.timer = self.limit
		self.limit = 0
	}

	// Any state Pre routine
	if self.anyPre != nil {
		self.next_state = self.anyPre(self.state, self.payload)
		handlex(self)
	}

	// Usual routine
    let handler = self.state.state.handler
	self.next_state = handler(self.state, self.payload)

	// Any state Post routine
	if self.anyPost != nil {
		handlex(self)
		self.next_state = self.anyPost(self.state, self.payload)
	}
}


public func task_1ms (self: *FSM) -> Unit {
	if self.timer > 0 {
		--self.timer
		if self.timer == 0 {
			self.timer_expired = true
		}
	}
}




public func cmdSwitchState (self: *FSM, state: *StateDesc) -> ComplexState {
	self.timer = 0
    return ComplexState {state=state, stage=stageIdDefault}
}


public func cmdSwitchStage (self: *FSM, stage: Word16) -> ComplexState {
	self.timer = 0
	var newState = self.state
	newState.stage = StageId stage
	return newState
}


public func cmdNextStage (self: *FSM) -> ComplexState {
	self.timer = 0
	let state: ComplexState = self.state
	let nextStageIndex = Nat16(state.stage) + 1
	//assert(nextStageIndex < state.state.nstages)
	var newState = state
	newState.stage = StageId nextStageIndex
	return newState
}


public func cmdNextStageLimited (self: *FSM, t: Nat32) -> ComplexState {
	self.timer = 0
	self.limit = t
	let state: ComplexState = self.state
	let nextStageIndex = Nat16(state.stage) + 1
	//assert(nextStageIndex < state.state.nstages)
	var newState = state
	newState.stage = StageId nextStageIndex
	return newState
}


public func cmdPrevStage (self: *FSM) -> ComplexState {
	self.timer = 0
	let state: ComplexState = self.state
	let prevStageIndex = Nat16(state.stage) - 1
	//assert(prevStageIndex < state.state.nstages)
	var newState = state
	newState.stage = StageId prevStageIndex
	return newState
}


public func getComplexState (fsm: FSM) -> ComplexState {
	return fsm.state
}


public func getState (fsm: FSM) -> *StateDesc {
	return fsm.state.state
}


public func getStage (fsm: FSM) -> StageId {
	return fsm.state.stage
}


public func setAnyPre (self: *FSM, anyPre: *StateServiceRoutine) -> Unit {
	self.anyPre = anyPre
}


public func setAnyPost (self: *FSM, anyPost: *StateServiceRoutine) -> Unit {
	self.anyPost = anyPost
}


public func getCurrentStateName (fsm: *FSM) -> *Str8 {
	if fsm.state.state == nil {
		return "<null>"
	}
	return fsm.state.state.id
}


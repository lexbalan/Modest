include "assert"
include "stdio"



public type StageId = @brand Word16

public type ComplexState = @public record {
	state: *StateDesc
	stage: StageId
}

public type StateServiceRoutine = (state: ComplexState, payload: Ptr) -> ComplexState


public type StateDesc = record {
	id: *Str8
	nstages: Nat16
	handler: *StateServiceRoutine
}


public type FSM = record {
	id: *Str8
	state: ComplexState
	next_state: ComplexState
	payload: Ptr

	timer: Nat32
	timer_expired: Bool
}


public func init (self: *FSM, id: *Str8, initState: *StateDesc, payload: Ptr) -> Unit {
	self.id = id
	self.state = {state = initState, stage = StageId 0}
	self.next_state = {state = initState, stage = StageId 0}
	self.payload = payload
	self.timer = 0
	self.timer_expired = false
}




public func task (self: *FSM) -> Unit {
	// Сработал таймер-ограничитель времени нахождения в стадии?
	if self.timer_expired {
		// Clear timer & Switch to next stage
		self.timer_expired = false
		self.next_state = cmdNextStage(self)
		let top = Nat32 0
		printf("[%s] fsm timeout (%u) occured, switch_to_stage(%d)\n", *Str8 self.id, Nat32 top, StageId self.next_state.stage)
	}

	// Есть запрос на смену состояния?
	if self.next_state != self.state {
		let state: ComplexState = self.state
		let next_state: ComplexState = self.next_state
		printf("[%s] #%s_%u -> #%s_%u\n", *Str8 self.id, *Str8 state.state.id, StageId state.stage, *Str8 next_state.state.id, StageId next_state.stage)
		self.state = self.next_state
	}

	// Usual routine
	let handler: *StateServiceRoutine = self.state.state.handler
	self.next_state = handler(self.state, self.payload)
}


public func tick (self: *FSM) -> Unit {
	if self.timer > 0 {
		self.timer = self.timer - 1
		if self.timer == 0 {
			self.timer_expired = true
		}
	}
}




public func cmdSwitchState (self: *FSM, state: *StateDesc) -> ComplexState {
	self.timer = 0
	self.timer_expired = false
	return ComplexState {state = state, stage = StageId 0}
}


public func cmdSwitchStage (self: *FSM, stage: Word16) -> ComplexState {
	self.timer = 0
	self.timer_expired = false
	var newState: ComplexState = self.state
	newState.stage = StageId stage
	return newState
}


public func cmdNextStage (self: *FSM) -> ComplexState {
	self.timer = 0
	self.timer_expired = false
	let state: ComplexState = self.state
	let nextStageIndex: Nat16 = Nat16 (state.stage) + 1
	//assert(nextStageIndex < state.state.nstages)
	var newState: ComplexState = state
	newState.stage = StageId nextStageIndex
	return newState
}


public func cmdNextStageLimited (self: *FSM, t: Nat32) -> ComplexState {
	self.timer = t
	let state: ComplexState = self.state
	let nextStageIndex: Nat16 = Nat16 (state.stage) + 1
	//assert(nextStageIndex < state.state.nstages)
	var newState: ComplexState = state
	newState.stage = StageId nextStageIndex
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


public func getStateName (fsm: *FSM) -> *Str8 {
	if fsm.state.state == nil {
		return "<null>"
	}
	return fsm.state.state.id
}


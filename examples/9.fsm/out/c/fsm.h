
#ifndef FSM_H
#define FSM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <assert.h>
#include <stdio.h>



struct fsm_ComplexState;
typedef struct fsm_ComplexState fsm_ComplexState;

typedef fsm_ComplexState fsm_StateServiceRoutine(fsm_ComplexState state, void *payload);
struct fsm_StateDesc {
	char *id;
	uint16_t nstages;
	fsm_StateServiceRoutine *handler;
};
typedef struct fsm_StateDesc fsm_StateDesc;

typedef uint16_t fsm_StageId;
#define FSM_STAGE_ID_DEFAULT  ((fsm_StageId)0)

struct fsm_ComplexState {
	fsm_StateDesc *state;
	fsm_StageId stage;
};

struct fsm_FSM {
	char *id;
	fsm_StateServiceRoutine *anyPre;
	fsm_StateServiceRoutine *anyPost;
	fsm_ComplexState state;
	fsm_ComplexState next_state;
	void *payload;

	uint32_t limit;

	uint32_t timer;
	bool timer_expired;
};
typedef struct fsm_FSM fsm_FSM;
void fsm_init(fsm_FSM *self, char *id, fsm_StateDesc *initState, void *payload);
void fsm_task(fsm_FSM *self);
void fsm_task_1ms(fsm_FSM *self);
fsm_ComplexState fsm_cmdSwitchState(fsm_FSM *self, fsm_StateDesc *state);
fsm_ComplexState fsm_cmdSwitchStage(fsm_FSM *self, uint16_t stage);
fsm_ComplexState fsm_cmdNextStage(fsm_FSM *self);
fsm_ComplexState fsm_cmdNextStageLimited(fsm_FSM *self, uint32_t t);
fsm_ComplexState fsm_cmdPrevStage(fsm_FSM *self);
fsm_ComplexState fsm_getComplexState(fsm_FSM fsm);
fsm_StateDesc *fsm_getState(fsm_FSM fsm);
fsm_StageId fsm_getStage(fsm_FSM fsm);
void fsm_setAnyPre(fsm_FSM *self, fsm_StateServiceRoutine *anyPre);
void fsm_setAnyPost(fsm_FSM *self, fsm_StateServiceRoutine *anyPost);
char *fsm_getCurrentStateName(fsm_FSM *fsm);

#endif /* FSM_H */

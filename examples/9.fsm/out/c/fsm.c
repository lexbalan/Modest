// ./out/c/fsm.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "fsm.h"



#define nameMaxLength  8
#define maxStates  16
#define verbose  true
#define fsmSubstateEntering  0
#define fsmSubstateLoop  1
#define fsmSubstateLeaving  2


char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no)
{
	return (char *)&fsm->states[state_no].name;
}

void fsm_switch(fsm_FSM *fsm, uint32_t state)
{
	fsm->nexstate = state;
	fsm->substate = fsmSubstateLeaving;
}

void fsm_run(fsm_FSM *fsm)
{
	printf("fsm::run()\n");

	if (fsm->substate == fsmSubstateEntering) {
		const fsm_UInt32 nexstate = fsm->nexstate;
		fsm_FSM_StateDesc *const state = &fsm->states[nexstate];

		if (verbose) {
			printf("enter %s\n", (char *)&state->name);
		}

		if (state->entry != NULL) {
			((void (*) (fsm_FSM *fsm))state->entry)((fsm_FSM *)fsm);
		}

		fsm->state = nexstate;
		fsm->substate = fsmSubstateLoop;

	} else if (fsm->substate == fsmSubstateLoop) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			((void (*) (fsm_FSM *fsm))state->loop)((fsm_FSM *)fsm);
		}

	} else if (fsm->substate == fsmSubstateLeaving) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (verbose) {
			printf("exit %s\n", (char *)&state->name);
		}

		if (state->exit != NULL) {
			((void (*) (fsm_FSM *fsm))state->exit)((fsm_FSM *)fsm);
		}

		fsm->substate = fsmSubstateEntering;
	}
}


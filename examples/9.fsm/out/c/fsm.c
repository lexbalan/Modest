// ./out/c/fsm.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "fsm.h"



#define fsm_verbose  true



char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no)
{
	return (char *)&fsm->states[state_no].name;
}

void fsm_switch(fsm_FSM *fsm, uint32_t state)
{
	fsm->nexstate = state;
	fsm->substate = fsm_substateLeaving;
}

void fsm_run(fsm_FSM *fsm)
{
	printf("fsm::run()\n");

	if (fsm->substate == fsm_substateEntering) {
		const fsm_UInt32 nexstate = fsm->nexstate;
		fsm_FSM_StateDesc *const state = &fsm->states[nexstate];

		if (fsm_verbose) {
			printf("enter %s\n", (char *)&state->name);
		}

		if (state->entry != NULL) {
			((void (*) (fsm_FSM *x))state->entry)((fsm_FSM *)fsm);
		}

		fsm->state = nexstate;
		fsm->substate = fsm_substateLoop;

	} else if (fsm->substate == fsm_substateLoop) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			((void (*) (fsm_FSM *x))state->loop)((fsm_FSM *)fsm);
		}

	} else if (fsm->substate == fsm_substateLeaving) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (fsm_verbose) {
			printf("exit %s\n", (char *)&state->name);
		}

		if (state->exit != NULL) {
			((void (*) (fsm_FSM *x))state->exit)((fsm_FSM *)fsm);
		}

		fsm->substate = fsm_substateEntering;
	}
}


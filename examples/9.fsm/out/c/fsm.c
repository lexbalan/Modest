// ./out/c/fsm.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "fsm.h"



#define verbose  true


char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no)
{
	return (char *)&fsm->states[state_no].name;
}

void fsm_switch(fsm_FSM *fsm, uint32_t state)
{
	fsm->nexstate = state;
	fsm->substate = substateLeaving;
}

void fsm_run(fsm_FSM *fsm)
{
	printf("fsm::run()\n");

	if (fsm->substate == substateEntering) {
		const fsm_UInt32 nexstate = fsm->nexstate;
		fsm_FSM_StateDesc *const state = &fsm->states[nexstate];

		if (verbose) {
			printf("enter %s\n", (char *)&state->name);
		}

		if (state->entry != NULL) {
			((void (*) (fsm_FSM *fsm))state->entry)((fsm_FSM *)fsm);
		}

		fsm->state = nexstate;
		fsm->substate = substateLoop;

	} else if (fsm->substate == substateLoop) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			((void (*) (fsm_FSM *fsm))state->loop)((fsm_FSM *)fsm);
		}

	} else if (fsm->substate == substateLeaving) {
		fsm_FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (verbose) {
			printf("exit %s\n", (char *)&state->name);
		}

		if (state->exit != NULL) {
			((void (*) (fsm_FSM *fsm))state->exit)((fsm_FSM *)fsm);
		}

		fsm->substate = substateEntering;
	}
}


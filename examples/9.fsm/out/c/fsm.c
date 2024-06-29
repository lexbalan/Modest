// examples/fsm/fsm.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
/* forward type declaration */
/* anon recs */



#include "./fsm.h"


#define fsmVerbose  true


char *fsm_state_no_name(FSM *fsm, uint32_t state_no)
{
	return (char *)&fsm->states[state_no].name;
}


void fsm_switch(FSM *fsm, uint32_t state)
{
	fsm->nexstate = state;
	fsm->substate = fsmSubstateLeaving;
}


void fsm_run(FSM *fsm)
{
	printf("fsm_run()\n");

	if (fsm->substate == fsmSubstateEntering) {
		const UInt32 nexstate = fsm->nexstate;
		FSM_StateDesc *const state = &fsm->states[nexstate];

		if (fsmVerbose) {
			printf("enter %s\n", (char *)&state->name);
		}

		if (state->entry != NULL) {
			((void (*) (FSM *fsm))state->entry)((FSM *)fsm);
		}

		fsm->state = nexstate;
		fsm->substate = fsmSubstateLoop;

	} else if (fsm->substate == fsmSubstateLoop) {
		FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			((void (*) (FSM *fsm))state->loop)((FSM *)fsm);
		}

	} else if (fsm->substate == fsmSubstateLeaving) {
		FSM_StateDesc *const state = &fsm->states[fsm->state];

		if (fsmVerbose) {
			printf("exit %s\n", (char *)&state->name);
		}

		if (state->exit != NULL) {
			((void (*) (FSM *fsm))state->exit)((FSM *)fsm);
		}

		fsm->substate = fsmSubstateEntering;
	}
}


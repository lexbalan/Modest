
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "fsm.h"


#define verbose  true

// Вынужден добавлять export тк иначе не идет в хедер к структуре
// Короче, проблема зависимостей тяжело зависла в воздухе













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
		const uint32_t nexstate = fsm->nexstate;
		fsm_StateDesc *const state = &fsm->states[nexstate];

		if (verbose) {
			printf("enter %s\n", &state->name);
		}

		if (state->entry != NULL) {
			state->entry(fsm);
		}

		fsm->state = nexstate;
		fsm->substate = fsm_substateLoop;

	} else if (fsm->substate == fsm_substateLoop) {
		fsm_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			state->loop(fsm);
		}

	} else if (fsm->substate == fsm_substateLeaving) {
		fsm_StateDesc *const state = &fsm->states[fsm->state];

		if (verbose) {
			printf("exit %s\n", &state->name);
		}

		if (state->exit != NULL) {
			state->exit(fsm);
		}

		fsm->substate = fsm_substateEntering;
	}
}


// ./out/c/fsm.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "fsm.h"



#define verbose  true
// Вынужден добавлять export тк иначе не идет в хедер к структуре
// Короче, проблема зависимостей тяжело зависла в воздухе


char(*(*fsm_state_no_name(FSM *fsm, uint32_t state_no)))[]
{
	return &fsm->states[state_no].name;
}


void fsm_switch(FSM *fsm, uint32_t state)
{
	fsm->nexstate = state;
	fsm->substate = fsm_substateLeaving;
}


void fsm_run(FSM *fsm)
{
	printf("fsm::run()\n");

	if (fsm->substate == fsm_substateEntering) {
		uint32_t nexstate = fsm->nexstate;
		StateDesc *state = &fsm->states[nexstate];

		if (verbose) {
			printf("enter %s\n", &state->name);
		}

		if (state->entry != NULL) {
			((void(*)(FSM *x))state->entry)(fsm);
		}

		fsm->state = nexstate;
		fsm->substate = fsm_substateLoop;

	} else if (fsm->substate == fsm_substateLoop) {
		StateDesc *state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			((void(*)(FSM *x))state->loop)(fsm);
		}

	} else if (fsm->substate == fsm_substateLeaving) {
		StateDesc *state = &fsm->states[fsm->state];

		if (verbose) {
			printf("exit %s\n", &state->name);
		}

		if (state->exit != NULL) {
			((void(*)(FSM *x))state->exit)(fsm);
		}

		fsm->substate = fsm_substateEntering;
	}
}


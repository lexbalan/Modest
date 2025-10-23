// examples/fsm/fsm.cm

#include "fsm.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define VERBOSE  true

// Вынужден добавлять public тк иначе не идет в хедер к структуре
// Короче, проблема зависимостей тяжело зависла в воздухе

char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no) {
	return (char *)&fsm->states[state_no].name;
}


void fsm_switch(fsm_FSM *fsm, uint32_t state) {
	fsm->nexstate = state;
	fsm->substate = FSM_SUBSTATE_LEAVING;
}


void fsm_run(fsm_FSM *fsm) {
	printf("fsm::run()\n");

	if (fsm->substate == FSM_SUBSTATE_ENTERING) {
		const uint32_t nexstate = fsm->nexstate;
		fsm_StateDesc *const state = &fsm->states[nexstate];

		if (VERBOSE) {
			printf("enter %s\n", (char *)&state->name);
		}

		if (state->entry != NULL) {
			state->entry(fsm);
		}

		fsm->state = nexstate;
		fsm->substate = FSM_SUBSTATE_LOOP;
	} else if (fsm->substate == FSM_SUBSTATE_LOOP) {
		fsm_StateDesc *const state = &fsm->states[fsm->state];

		if (state->loop != NULL) {
			state->loop(fsm);
		}
	} else if (fsm->substate == FSM_SUBSTATE_LEAVING) {
		fsm_StateDesc *const state = &fsm->states[fsm->state];

		if (VERBOSE) {
			printf("exit %s\n", (char *)&state->name);
		}

		if (state->exit != NULL) {
			state->exit(fsm);
		}

		fsm->substate = FSM_SUBSTATE_ENTERING;
	}
}



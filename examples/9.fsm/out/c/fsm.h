
#ifndef FSM_H
#define FSM_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdio.h>


#define fsm_nameMaxLength  8
#define fsm_maxStates  16
struct FSM;
typedef struct FSM FSM;

typedef void(*Handler)(FSM *x);
struct StateDesc {
	char name[fsm_nameMaxLength];
	Handler entry;
	Handler loop;
	Handler exit;
};
typedef struct StateDesc StateDesc;
#define fsm_substateEntering  0
#define fsm_substateLoop  1
#define fsm_substateLeaving  2
struct FSM {
	char name[fsm_nameMaxLength];
	uint32_t state;
	uint32_t nexstate;
	uint32_t substate;
	StateDesc states[fsm_maxStates];
};
char(*(*fsm_state_no_name(FSM *fsm, uint32_t state_no)))[];
void fsm_switch(FSM *fsm, uint32_t state);
void fsm_run(FSM *fsm);

#endif /* FSM_H */

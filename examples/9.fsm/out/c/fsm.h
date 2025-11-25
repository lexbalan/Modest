
#ifndef FSM_H
#define FSM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

#define FSM_NAME_MAX_LENGTH  8
#define FSM_MAX_STATES  16


struct fsm_FSM;
typedef struct fsm_FSM fsm_FSM;
typedef void fsm_Handler(fsm_FSM *x);

struct fsm_StateDesc {
	char name[FSM_NAME_MAX_LENGTH];
	fsm_Handler *entry;
	fsm_Handler *loop;
	fsm_Handler *exit;
};
typedef struct fsm_StateDesc fsm_StateDesc;

typedef fsm_StateDesc fsm_States[FSM_MAX_STATES];

#define FSM_SUBSTATE_ENTERING  0
#define FSM_SUBSTATE_LOOP  1
#define FSM_SUBSTATE_LEAVING  2

struct fsm_FSM {
	char name[FSM_NAME_MAX_LENGTH];
	uint32_t state;
	uint32_t nexstate;
	uint32_t substate;
	fsm_States states;
};
char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no);
void fsm_switch(fsm_FSM *fsm, uint32_t state);
void fsm_run(fsm_FSM *fsm);

#endif /* FSM_H */


#ifndef FSM_H
#define FSM_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>


typedef struct fsm_FSM_StateDesc fsm_FSM_StateDesc; //
typedef struct fsm_FSM fsm_FSM; //
#define fsm_nameMaxLength  8

typedef uint32_t fsm_UInt32;

struct fsm_FSM_StateDesc {
	char name[fsm_nameMaxLength];
	fsm_FSM_Proc entry;
	fsm_FSM_Proc loop;
	fsm_FSM_Proc exit;
};
#define fsm_maxStates  16

struct fsm_FSM {
	char name[fsm_nameMaxLength];
	fsm_UInt32 state;
	fsm_UInt32 nexstate;
	fsm_UInt32 substate;
	fsm_FSM_StateDesc states[fsm_maxStates];
};


typedef void * fsm_FSM_Proc;
#define fsm_substateEntering  0
#define fsm_substateLoop  1
#define fsm_substateLeaving  2
char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no);
void fsm_switch(fsm_FSM *fsm, uint32_t state);
void fsm_run(fsm_FSM *fsm);

#endif /* FSM_H */

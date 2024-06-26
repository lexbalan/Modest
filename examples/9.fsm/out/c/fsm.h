// examples/fsm/fsm.cm

#ifndef FSM_H
#define FSM_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef struct FSM_StateDesc FSM_StateDesc;
typedef struct FSM FSM;


#define fsmNameMaxLength  8
#define fsmMaxStates  16


struct FSM;
typedef struct FSM FSM;

typedef void * FSM_Proc;

struct FSM_StateDesc {
	char name[fsmNameMaxLength];
	FSM_Proc entry;
	FSM_Proc loop;
	FSM_Proc exit;
};


#define fsmSubstateEntering  0
#define fsmSubstateLoop  1
#define fsmSubstateLeaving  2

typedef uint32_t UInt32;

struct FSM {
	char name[fsmNameMaxLength];
	UInt32 state;
	UInt32 nexstate;
	UInt32 substate;
	FSM_StateDesc states[fsmMaxStates];
};


char *fsm_state_no_name(FSM *fsm, uint32_t state_no);
void fsm_switch(FSM *fsm, uint32_t state);
void fsm_run(FSM *fsm);

#endif /* FSM_H */

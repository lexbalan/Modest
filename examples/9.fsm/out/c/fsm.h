// examples/fsm/fsm.cm

#ifndef FSM_H
#define FSM_H

#include <string.h>
#include <stdint.h>
#include <stdbool.h>



#define fsmNameLength  8
#define fsmMaxStates  16


struct FSM;
typedef struct FSM FSM;

typedef void * FSM_Proc;

typedef struct {
} FSM_Empty;

typedef struct {
    char name[fsmNameLength];
    FSM_Proc entry;
    FSM_Proc loop;
    FSM_Proc exit;
} FSM_StateDesc;


#define fsmSubstateEntering  0
#define fsmSubstateLoop  1
#define fsmSubstateLeaving  2

typedef uint32_t UInt32;

struct FSM {
    char name[fsmNameLength];
    UInt32 state;
    UInt32 nexstate;
    UInt32 substate;
    FSM_StateDesc states[fsmMaxStates];
};


char *fsm_state_no_name(FSM *fsm, uint32_t state_no);
void fsm_switch(FSM *fsm, uint32_t state);
void fsm_run(FSM *fsm);

#endif  /* FSM_H */

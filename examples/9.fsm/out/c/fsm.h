
#ifndef FSM_H
#define FSM_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

#define fsm_nameMaxLength  8
#define fsm_maxStates  16


struct fsm_FSM;
typedef struct fsm_FSM fsm_FSM;
typedef void(*fsm_Handler)(fsm_FSM *x);

struct fsm_StateDesc {char name[fsm_nameMaxLength]; fsm_Handler entry; fsm_Handler loop; fsm_Handler exit;
};
typedef struct fsm_StateDesc fsm_StateDesc;

#define fsm_substateEntering  0
#define fsm_substateLoop  1
#define fsm_substateLeaving  2

struct fsm_FSM {char name[fsm_nameMaxLength]; uint32_t state; uint32_t nexstate; uint32_t substate; fsm_StateDesc states[fsm_maxStates];
};

char *fsm_state_no_name(fsm_FSM *fsm, uint32_t state_no);

void fsm_switch(fsm_FSM *fsm, uint32_t state);

void fsm_run(fsm_FSM *fsm);

#endif /* FSM_H */

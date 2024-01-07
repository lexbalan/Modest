
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

// examples/fsm/fsm.cm

#include "./fsm.h"


#define fsmVerbose  true

#define fsmSubstateEntering  0
#define fsmSubstateLoop  1
#define fsmSubstateLeaving  2


char *fsm_state_no_name(FSM *fsm, uint32_t state_no)
{
    return (char *)(char *)&fsm->states[state_no].name;
}


void fsm_switch(FSM *fsm, uint32_t state)
{
    fsm->nexstate = state;
    fsm->substate = fsmSubstateLeaving;
}


void fsm_run(FSM *fsm)
{
    if (fsm->substate == fsmSubstateEntering) {
        const UInt32 nexstate = fsm->nexstate;
        FSM_StateDesc *const s = &fsm->states[nexstate];

        if (fsmVerbose) {
            printf("enter %s\n", s->name);
        }

        if (s->entry != NULL) {
            ((void(*)(FSM *fsm))s->entry)((FSM *)fsm);
        }

        fsm->state = nexstate;
        fsm->substate = fsmSubstateLoop;

    } else if (fsm->substate == fsmSubstateLoop) {
        FSM_StateDesc *const s = &fsm->states[fsm->state];

        if (s->loop != NULL) {
            ((void(*)(FSM *fsm))s->loop)((FSM *)fsm);
        }

    } else if (fsm->substate == fsmSubstateLeaving) {
        FSM_StateDesc *const s = &fsm->states[fsm->state];

        if (fsmVerbose) {
            printf("exit %s\n", s->name);
        }

        if (s->exit != NULL) {
            ((void(*)(FSM *fsm))s->exit)((FSM *)fsm);
        }

        fsm->substate = fsmSubstateEntering;
    }
}


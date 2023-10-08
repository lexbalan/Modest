
#include <stdio.h>
#include "./ff.h"
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/fsm/main.cm

// This is flashlight final state machine example
// (just for compiler test and language demonstration)

#include "./fsm.h"




#define flashlightStateOff  0
#define flashlightStateOn  1
#define flashlightStateBeacon  2


uint8_t cnt;


//
// State Off
//

void off_entry(FSM *fsm)
{
    (void)fsm;
    //printf("off_entry\n")
}


void off_loop(FSM *fsm)
{
    (void)fsm;

    printf("off_loop\n");
    if (cnt < 10) {
        cnt = cnt + 1;
    } else {
        cnt = 0;
        fsm_switch((FSM *)fsm, flashlightStateOn);
    }
}


void off_exit(FSM *fsm)
{
    (void)fsm;
    //printf("off_exit\n")
}


//
// State On
//

void on_entry(FSM *fsm)
{
    (void)fsm;
    //printf("on_entry\n")
}


void on_loop(FSM *fsm)
{
    (void)fsm;
    printf("on_loop\n");
    if (cnt < 10) {
        cnt = cnt + 1;
    } else {
        cnt = 0;
        fsm_switch((FSM *)fsm, flashlightStateBeacon);
    }
}


void on_exit(FSM *fsm)
{
    (void)fsm;
    //printf("on_exit\n")
}


//
// State Beacon
//

void beacon_entry(FSM *fsm)
{
    uint8_t *const from_name = fsm_state_no_name((FSM *)fsm, fsm->state);
    printf("beacon_entry from %s\n", from_name);
}


void beacon_loop(FSM *fsm)
{
    printf("beacon_loop\n");
    if (cnt < 10) {
        cnt = cnt + 1;
    } else {
        cnt = 0;
        fsm_switch((FSM *)fsm, flashlightStateOff);
    }
}


void beacon_exit(FSM *fsm)
{
    uint8_t *const to_name = fsm_state_no_name((FSM *)fsm, fsm->nexstate);
    printf("beacon_exit to %s\n", to_name);
}



// FIXIT: если не приводить явно to FSM_StateDesc
FSM fsm = (FSM){
    .name = {70U, 108U, 97U, 115U, 104U, 0U},
    .state = 0,
    .nexstate = 0,
    .substate = fsmSubstateEntering,
    .states = {
        (FSM_StateDesc){
            .name = {79U, 102U, 102U, 0U},
            .entry = &off_entry,
            .loop = &off_loop,
            .exit = &off_exit
        },

        (FSM_StateDesc){
            .name = {79U, 110U, 0U},
            .entry = &on_entry,
            .loop = &on_loop,
            .exit = &on_exit
        },

        (FSM_StateDesc){
            .name = {66U, 101U, 97U, 99U, 111U, 110U, 0U},
            .entry = &beacon_entry,
            .loop = &beacon_loop,
            .exit = &beacon_exit
        }

    }
};



int main(void)
{

    while (true) {
        fsm_run((FSM *)&fsm);
        delay(500000);
    }

    return 0;
}


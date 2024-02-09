// examples/fsm/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./ff.h"

// This is flashlight final state machine example
// (just for compiler test and language demonstration)



#include "./fsm.h"




#define flashlightStateOff  0
#define flashlightStateOn  1
#define flashlightStateBeacon  2


static uint8_t cnt;


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
        fsm_switch(fsm, flashlightStateOn);
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
        fsm_switch(fsm, flashlightStateBeacon);
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
    char *const from_name = fsm_state_no_name(fsm, fsm->state);
    printf("beacon_entry from %s\n", from_name);
}


void beacon_loop(FSM *fsm)
{
    printf("beacon_loop\n");
    if (cnt < 10) {
        cnt = cnt + 1;
    } else {
        cnt = 0;
        fsm_switch(fsm, flashlightStateOff);
    }
}


void beacon_exit(FSM *fsm)
{
    char *const to_name = fsm_state_no_name(fsm, fsm->nexstate);
    printf("beacon_exit to %s\n", to_name);
}



static FSM fsm = {
    .name = {'F', 'l', 'a', 's', 'h', '\0', '\0', '\0'},
    .state = 0,
    .nexstate = 0,
    .substate = fsmSubstateEntering,
    .states = {
        {

            .name = {'O', 'f', 'f', '\0', '\0', '\0', '\0', '\0'},
            .entry = &off_entry,
            .loop = &off_loop,
            .exit = &off_exit
        },

        {
            .name = {'O', 'n', '\0', '\0', '\0', '\0', '\0', '\0'},
            .entry = &on_entry,
            .loop = &on_loop,
            .exit = &on_exit
        },

        {
            .name = {'B', 'e', 'a', 'c', 'o', 'n', '\0', '\0'},
            .entry = &beacon_entry,
            .loop = &beacon_loop,
            .exit = &beacon_exit
        }, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

    }
};



int main()
{

    while (true) {
        fsm_run(&fsm);
        delay(500000);
    }

    return 0;
}


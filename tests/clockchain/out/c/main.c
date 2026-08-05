
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
struct callback_data {uint8_t __placeholder;};
struct clock;
typedef void ClockCallback(struct clock *clock, struct callback_data *data);
struct clock {
	char *identifier;
	struct clock *next;
	uint32_t counter;
	bool expired;
	struct callback_data *callbackData;
	ClockCallback *callback;
};
static struct clock *clockchain;

static void tickClock(struct clock *self) {
	if (self->counter > 0) {
		--self->counter;
		self->expired = self->counter == 0;
	}
}

static void taskClock(struct clock *self) {
	if (self->expired) {
		if (self->callback != NULL) {
			self->callback(self, self->callbackData);
		}
		self->expired = false;
	}
}

static void addClock(struct clock *clock) {
	if (clockchain == NULL) {
		clockchain = clock;
	} else {
		struct clock *c = clockchain;
		while (c->next != NULL) {
			c = c->next;
		}
		c->next = clock;
		clock->next = NULL;
	}
}

static void foreachClockInChain(struct clock *clockchain, void (*handler)(struct clock *self)) {
	struct clock *c = clockchain;
	while (c != NULL) {
		handler(c);
		c = c->next;
	}
}

static void tickClockchain(struct clock *clockchain) {
	foreachClockInChain(clockchain, &tickClock);
}

static void taskClockchain(struct clock *clockchain) {
	foreachClockInChain(clockchain, &taskClock);
}

static void clockCallback(struct clock *clock, struct callback_data *data) {
	printf("Clock %s expired.\n", clock->identifier);
}

int main(void) {
	struct clock *clocks[3];
	__builtin_memcpy(&clocks, &(struct clock *[3]){
		(struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){.identifier = "clock1", .counter = 100, .callback = &clockCallback}, sizeof(struct clock)),
		(struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){.identifier = "clock2", .counter = 200, .callback = &clockCallback}, sizeof(struct clock)),
		(struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){.identifier = "clock3", .counter = 500, .callback = &clockCallback}, sizeof(struct clock))
	}, sizeof(struct clock *[3]));
	addClock(clocks[0]);
	addClock(clocks[1]);
	addClock(clocks[2]);
	uint32_t i = 10000;
	while (i > 0) {
		tickClockchain(clockchain);
		if (i % 10 == 0) {
			taskClockchain(clockchain);
		}
		--i;
	}
	return 0;
}



#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
struct callback_data {uint8_t __placeholder;};
struct clock;
typedef void ClockCallback(struct clock *clock);
struct clock {
	struct clock *next;
	uint32_t counter;
	bool expired;
	struct callback_data *callbackData;
	ClockCallback *callback;
};
static struct clock *clockchain;

static void tickClock(struct clock *self) {
	if (self->counter > 0U) {
		self->counter = self->counter - 1U;
		self->expired = self->counter == 0U;
	}
}

static void taskClock(struct clock *self) {
	if (self->expired) {
		if (self->callback != NULL) {
			self->callback(self);
		}
		self->expired = self->counter == 0U;
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
	if (c != NULL) {
		while (c->next != NULL) {
			handler(c);
			c = c->next;
		}
	}
}

static void tickClockchain(struct clock *clockchain) {
	foreachClockInChain(clockchain, &tickClock);
}

static void taskClockchain(struct clock *clockchain) {
	foreachClockInChain(clockchain, &taskClock);
}

int main(void) {
	struct clock *clocks[3];
	clocks[0] = (struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){0}, sizeof(struct clock));
	clocks[1] = (struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){0}, sizeof(struct clock));
	clocks[2] = (struct clock *)__builtin_memcpy(malloc(sizeof(struct clock)), &(struct clock){0}, sizeof(struct clock));
	addClock(clocks[0]);
	addClock(clocks[1]);
	addClock(clocks[2]);
	uint32_t i = 10000U;
	while (i > 0U) {
		tickClockchain(clockchain);
		if (i % 10U == 0U) {
			taskClockchain(clockchain);
		}
		i = i - 1U;
	}
	return 0;
}


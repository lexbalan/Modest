// ./out/c/mutex.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "mutex.h"



#define stateOpen  false
#define stateClose  true
void __enable_irq();
void __disable_irq();

void __enable_irq()
{
}

void __disable_irq()
{
}

void mutex_init(mutex_Mutex *x)
{
	mutex_release((mutex_Mutex *)x);
}

bool mutex_acquire(mutex_Mutex *x)
{
	// отпустили, вырубаем прерывания
	__disable_irq();

	if (x->state == stateClose) {
		__enable_irq();
		return false;
	}

	x->state = stateClose;

	__enable_irq();

	return true;
}

void mutex_release(mutex_Mutex *x)
{
	x->state = stateOpen;
}


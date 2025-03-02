
#ifndef MUTEX_H
#define MUTEX_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


typedef struct mutex_Mutex mutex_Mutex; //

struct mutex_Mutex {
	bool state;
};
void mutex_init(mutex_Mutex *x);
bool mutex_acquire(mutex_Mutex *x);
void mutex_release(mutex_Mutex *x);

#endif /* MUTEX_H */

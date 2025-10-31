// tests/threads/src/main.m
// valgrind --leak-check=full ./easy.run

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

#include "main.h"


static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static uint32_t global_counter;

static void *thread0(void *param)
{
	printf("Hello from thread 0\n");

	while (global_counter < 32) {
		// increment global counter
		pthread_mutex_lock(&mutex);
		global_counter = global_counter + 1;
		pthread_mutex_unlock(&mutex);

		usleep(500000);
	}

	pthread_exit(NULL);
	return NULL;
}

static void *thread1(void *param)
{
	printf("Hello from thread 1\n");

	uint32_t global_counter_value = 0;
	uint32_t global_counter_prev = 0;

	while (global_counter_value < 32) {
		// fast read global counter
		pthread_mutex_lock(&mutex);
		global_counter_value = global_counter;
		pthread_mutex_unlock(&mutex);

		if (global_counter_prev != global_counter_value) {
			global_counter_prev = global_counter_value;
			printf("global_counter = %d\n", global_counter_value);
		}
	}

	pthread_exit(NULL);
	return NULL;
}

int main()
{
	printf("Hello threads!\n");

	int32_t rc;

	pthread_t pthread0;
	pthread_t pthread1;

	rc = pthread_create(&pthread0, NULL, &thread0, NULL);
	rc = pthread_create(&pthread1, NULL, &thread1, NULL);

	//pthread.detach(pthread0)
	void *rc0;
	void *rc1;
	rc = pthread_join(pthread0, &rc0);
	rc = pthread_join(pthread1, &rc1);

	pthread_exit(NULL);

	return 0;
}



#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>



static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static uint32_t global_counter;

static void *thread0(void *param) {
	printf("Hello from thread 0\n");

	while (global_counter < 32) {
		// increment global counter
		mutex_lock(&mutex);
		global_counter = global_counter + 1;
		mutex_unlock(&mutex);

		usleep(500000);
	}

	exit(NULL);
	return NULL;
}


static void *thread1(void *param) {
	printf("Hello from thread 1\n");

	uint32_t global_counter_value = 0;
	uint32_t global_counter_prev = 0;

	while (global_counter_value < 32) {
		// fast read global counter
		mutex_lock(&mutex);
		global_counter_value = global_counter;
		mutex_unlock(&mutex);

		if (global_counter_prev != global_counter_value) {
			global_counter_prev = global_counter_value;
			printf("global_counter = %d\n", global_counter_value);
		}
	}

	exit(NULL);
	return NULL;
}


int main(void) {
	printf("Hello threads!\n");

	int32_t rc;

	pthread_t pthread0;
	pthread_t pthread1;

	rc = create(&pthread0, NULL, &thread0, NULL);
	rc = create(&pthread1, NULL, &thread1, NULL);

	//pthread.detach(pthread0)
	void *rc0;
	void *rc1;
	rc = join(pthread0, &rc0);
	rc = join(pthread1, &rc1);

	exit(NULL);

	return 0;
}



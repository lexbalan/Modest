import "misc/pthread"
include "ctypes64"
include "stdio"
include "unistd"
// tests/threads/src/main.m
// valgrind --leak-check=full ./easy.run
import "misc/pthread" as pthread

var mutex = pthread.mutexInitializer


var global_counter: Nat32


func thread0 (param: Ptr) -> Ptr {
	printf("Hello from thread 0\n")

	while global_counter < 32 {
		// increment global counter
		pthread.mutex_lock(&mutex)
		global_counter = global_counter + 1
		pthread.mutex_unlock(&mutex)

		usleep(500000)
	}

	pthread.exit(nil)
	return nil
}


func thread1 (param: Ptr) -> Ptr {
	printf("Hello from thread 1\n")

	var global_counter_value: Nat32 = 0
	var global_counter_prev: Nat32 = 0

	while global_counter_value < 32 {
		// fast read global counter
		pthread.mutex_lock(&mutex)
		global_counter_value = global_counter
		pthread.mutex_unlock(&mutex)

		if global_counter_prev != global_counter_value {
			global_counter_prev = global_counter_value
			printf("global_counter = %d\n", global_counter_value)
		}
	}

	pthread.exit(nil)
	return nil
}


public func main () -> Int {
	printf("Hello threads!\n")

	var rc: Int32

	var pthread0
	var pthread1

	rc = pthread.create(&pthread0, nil, &thread0, nil)
	rc = pthread.create(&pthread1, nil, &thread1, nil)

	//pthread.detach(pthread0)
	var rc0
	var rc1
	rc = pthread.join(pthread0, &rc0)
	rc = pthread.join(pthread1, &rc1)

	pthread.exit(nil)

	return 0
}


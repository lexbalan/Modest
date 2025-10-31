
@c_include "stdio.h"
@c_include "unistd.h"
@c_include "pthread.h"


var mutex: pthread.PThreadMutexT = pthread.pthreadMutexInitializer


var global_counter: Nat32


func thread0(param: Ptr) -> Ptr {
	stdio.printf("Hello from thread 0\n")

	while global_counter < 32 {

		// increment global counter
		pthread.pthread_mutex_lock(&mutex)
		global_counter = global_counter + 1
		pthread.pthread_mutex_unlock(&mutex)

		unistd.usleep(500000)
	}

	pthread.pthread_exit(nil)
	return nil
}


func thread1(param: Ptr) -> Ptr {
	stdio.printf("Hello from thread 1\n")

	var global_counter_value: Nat32 = 0
	var global_counter_prev: Nat32 = 0

	while global_counter_value < 32 {
		// fast read global counter
		pthread.pthread_mutex_lock(&mutex)
		global_counter_value = global_counter
		pthread.pthread_mutex_unlock(&mutex)

		if global_counter_prev != global_counter_value {
			global_counter_prev = global_counter_value
			stdio.printf("global_counter = %d\n", global_counter_value)
		}
	}

	pthread.pthread_exit(nil)
	return nil
}


public func main() -> ctypes64.Int {
	stdio.printf("Hello threads!\n")

	var rc: Int32

	var pthread0: pthread.PThreadT
	var pthread1: pthread.PThreadT

	rc = pthread.pthread_create(&pthread0, nil, &thread0, nil)
	rc = pthread.pthread_create(&pthread1, nil, &thread1, nil)

	//pthread_detach(pthread0)
	var rc0: Ptr
	var rc1: Ptr
	rc = pthread.pthread_join(pthread0, &rc0)
	rc = pthread.pthread_join(pthread1, &rc1)

	pthread.pthread_exit(nil)

	return 0
}


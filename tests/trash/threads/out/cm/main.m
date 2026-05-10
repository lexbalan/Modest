private import "builtin"
private import "misc/pthread"
include "ctypes64"
include "stdio"
include "unistd"

import "misc/pthread" as pthread


var mutex = mutexInitializer


var global_counter: Nat32


func thread0 (param: Ptr) -> Ptr {
	printf("Hello from thread 0\n")

	while global_counter < 32 {
		mutex_lock(&mutex)
		global_counter = global_counter + 1
		mutex_unlock(&mutex)

		usleep(500000)
	}

	exit(nil)
	return nil
}


func thread1 (param: Ptr) -> Ptr {
	printf("Hello from thread 1\n")

	var global_counter_value: Nat32 = 0
	var global_counter_prev: Nat32 = 0

	while global_counter_value < 32 {
		mutex_lock(&mutex)
		global_counter_value = global_counter
		mutex_unlock(&mutex)

		if global_counter_prev != global_counter_value {
			global_counter_prev = global_counter_value
			printf("global_counter = %d\n", global_counter_value)
		}
	}

	exit(nil)
	return nil
}


@nonstatic
func main () -> Int {
	printf("Hello threads!\n")

	var rc: Int32

	var pthread0
	var pthread1

	rc = create(&pthread0, nil, &thread0, nil)
	rc = create(&pthread1, nil, &thread1, nil)
	var rc0
	var rc1
	rc = join(pthread0, &rc0)
	rc = join(pthread1, &rc1)

	exit(nil)

	return 0
}


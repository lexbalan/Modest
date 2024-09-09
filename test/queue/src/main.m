// test/pre0/src/main.cm

include "console"
include "inttypes"

import "queue"


var queue: queue.Queue


@nodecorate
export func main() -> Int {
	init()


	return 0
}


func init() {
	printf("init!\n")
}



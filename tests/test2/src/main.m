include "libc/stdio"
include "libc/stdlib"
include "libc/string"

import "lightfood/datetime"



public func main () -> Int32 {
	//printf("test2\n")
	j
	let dt = datetime.dateTimeNow()
	var dateTimeStr: [32]Char8
	datetime.sprintDateTime(&dateTimeStr)
	printf("datetime = '%s'\n", &dateTimeStr)
	printf("dayOfYear = %u\n", datetime.dayOfYear())
	printf("dayOfWeek = %u\n", datetime.dayOfWeek())

	return 0
}



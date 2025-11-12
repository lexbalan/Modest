import "lightfood/datetime"
include "stdio"
include "stdlib"
include "string"

import "lightfood/datetime" as datetime



public func main () -> Int32 {
	//printf("test2\n")

	let dt: DateTime = datetime.dateTimeNow()
	var dateTimeStr: [32]Char8
	datetime.sprintDateTime(&dateTimeStr)
	printf("datetime = '%s'\n", &dateTimeStr)
	printf("dayOfYear = %u\n", datetime.dayOfYear())
	printf("dayOfWeek = %u\n", datetime.dayOfWeek())

	return 0
}


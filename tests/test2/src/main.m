include "libc/stdio"
include "libc/stdlib"
include "libc/string"

import "lightfood/datetime"



public func main () -> Int32 {
	printf("test2\n")

	let dt = datetime.dateTimeNow()

	printf("dateTimeNow = {\n")
	printf("	date = {\n")
	printf("		year = %d\n", dt.date.year)
	printf("		month = %d\n", dt.date.month)
	printf("		day = %d\n", dt.date.day)
	printf("	}\n")
	printf("	time = {\n")
	printf("		hour = %d\n", dt.time.hour)
	printf("		minute = %d\n", dt.time.minute)
	printf("		second = %d\n", dt.time.second)
	printf("	}\n")
	printf("}\n")


	var dateTimeStr: [32]Char8
	datetime.sprintDateTime(&dateTimeStr)
	printf("dt = '%s'\n", &dateTimeStr)


	return 0
}



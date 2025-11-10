import "lightfood/datetime"
include "stdio"
include "stdlib"
include "string"

import "lightfood/datetime" as datetime



public func main () -> Int32 {
	printf("test2\n")

	let dt: DateTime = datetime.dateTimeNow()

	printf("dateTimeNow = {\n")
	printf("\tdate = {\n")
	printf("\t\tyear = %d\n", dt.date.year)
	printf("\t\tmonth = %d\n", dt.date.month)
	printf("\t\tday = %d\n", dt.date.day)
	printf("\t}\n")
	printf("\ttime = {\n")
	printf("\t\thour = %d\n", dt.time.hour)
	printf("\t\tminute = %d\n", dt.time.minute)
	printf("\t\tsecond = %d\n", dt.time.second)
	printf("\t}\n")
	printf("}\n")


	var dateTimeStr: [32]Char8
	datetime.sprintDateTime(&dateTimeStr)
	printf("dt = '%s'\n", &dateTimeStr)


	return 0
}


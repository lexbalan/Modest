include "libc/stdio"
include "libc/stdlib"
include "libc/string"

// import comment
import "lightfood/datetime"

// this is a standalone comment

// this is the main function
// and it is its comment
public func main () -> Int32 {
	//printf("test2\n")
	let dt = datetime.dateTimeNow()
	var dateTimeStr: [32]Char8
	datetime.sprintDateTime(&dateTimeStr)
	printf("datetime = '%s'\n", &dateTimeStr)
	printf("dayOfYear = %u\n", datetime.dayOfYear())
	printf("dayOfWeek = %u\n", datetime.dayOfWeek())

	return 0
}



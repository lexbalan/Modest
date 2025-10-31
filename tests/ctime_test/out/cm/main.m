
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
@c_include "time.h"
include "libc/time"
@c_include "unistd.h"
include "libc/unistd"
import "lightfood/datetime"
public func main() -> Int {
	printf("ctime test\n")

	let seconds = time(nil)
	printf("Hours since January 1, 1970 = %ld\n", seconds / 3600)

	var y2k: StructTM
	var tm: *StructTM
	var sec: Double

	y2k.tm_hour = 0y2k.tm_min = 0y2k.tm_sec = 0
	y2k.tm_year = 100y2k.tm_mon = 0y2k.tm_mday = 1

	//timer = clock()
	var timer: TimeT
	time(&timer)

	sec = difftime(timer, mktime(&y2k))
	printf("%.f seconds since January 1, 2000 in the current timezone\n", sec)


	/*var t: TimeT
	t = time(nil)
	printf("t = %i\n", t)

	var t2: TimeT
	time(&t2)
	printf("t2 = %i\n", t2)*/


	var time2: TimeT
	time(&time2)
	//time2 = time(nil)   // segfail
	tm = localtime(&time2)
	//tm = gmtime(&time2)

	printf("tm.year = %i\n", tm.tm_year + 1900)
	printf("tm.month = %i\n", tm.tm_mon + 1)
	printf("tm.mday = %i\n", tm.tm_mday)
	printf("tm.wday = %i\n", tm.tm_wday)
	printf("tm.hour = %i\n", tm.tm_hour)
	printf("tm.min = %i\n", tm.tm_min)
	printf("tm.sec = %i\n", tm.tm_sec)

	printf("")

	let now = datetime.dateTimeNow()
	printf("now.year = %i\n", now.year)
	printf("now.month = %i\n", now.month)
	printf("now.day = %i\n", now.day)
	printf("now.hour = %i\n", now.hour)
	printf("now.minute = %i\n", now.minute)
	printf("now.second = %i\n", now.second)

	return 0
}


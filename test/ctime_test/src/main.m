// test/ctime_test/src/main.cm

include "libc/ctypes64"
include "libc/stdio"
include "libc/time"
include "libc/unistd"


func main() -> Int {
	printf("ctime test\n")

	let seconds = time(nil)
	printf("Hours since January 1, 1970 = %ld\n", seconds/3600)

	var timer: TimeT
	var y2k: Struct_tm
	var tm: *Struct_tm
	var sec: Double

	y2k.tm_hour = 0;   y2k.tm_min = 0; y2k.tm_sec = 0;
	y2k.tm_year = 100; y2k.tm_mon = 0; y2k.tm_mday = 1;

	//timer = clock()
	time(&timer)

	sec = difftime(timer, mktime(&y2k))

	printf("%.f seconds since January 1, 2000 in the current timezone\n", sec)

	tm = gmtime(&timer)

	printf("tm.year = %i\n", tm.tm_year + 1900)
	printf("tm.month = %i\n", tm.tm_mon + 1)
	printf("tm.mday = %i\n", tm.tm_mday)
	printf("tm.wday = %i\n", tm.tm_wday)
	printf("tm.hour = %i\n", tm.tm_hour)
	printf("tm.min = %i\n", tm.tm_min)
	printf("tm.sec = %i\n", tm.tm_sec)

	return 0
}


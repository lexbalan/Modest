// libc/time.m

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "time.h"


include "libc/ctypes64"

export {
	/* time in seconds since 1970 */
	@property("type.id.c", "time_t")
	type TimeT Int32

	@property("type.id.c", "clock_t")
	type ClockT UnsignedLong


	@property("type.id.c", "struct tm")
	type StructTM record {
		tm_sec: Int	   // Seconds [0-60]
		tm_min: Int	   // Minutes [0-59]
		tm_hour: Int   // Hours	[0-23]
		tm_mday: Int   // Day of month [1-31]
		tm_mon: Int	   // Month	[0-11]
		tm_year: Int   // Year (from 1900)
		tm_wday: Int   // Day of week [0-6]
		tm_yday: Int   // Day in year [0-365]
		tm_isdst: Int  // DST  [-1/0/1]

	//$if __USE_MISC == 1
		tm_gmtoff: LongInt	 // Seconds east of UTC
		tm_zone: *ConstChar	// Timezone abbreviation
	//$else
	//	__tm_gmtoff: LongInt   // Seconds east of UTC
	//	__tm_zone: *ConstChar  // Timezone abbreviation
	//$endif
	}


	// Clock program
	func clock() -> ClockT

	// Return difference between two times
	func difftime(end: TimeT, beginning: TimeT) -> Double

	// Convert tm structure to time_t
	func mktime(timeptr: *StructTM) -> TimeT

	// Get current time
	@unused_result
	func time(timer: *TimeT) -> TimeT

	// Convert tm structure to string
	func asctime(timeptr: *StructTM) -> *Char

	// Convert time_t value to string
	func ctime(timer: *TimeT) -> *Char

	// Convert time_t to tm as UTC time
	func gmtime(timer: *TimeT) -> *StructTM

	// Convert time_t to tm as local time
	func localtime(timer: *TimeT) -> *StructTM

	// Format time as string
	func strftime(ptr: *Char, maxsize: SizeT, format: *ConstChar, timeptr: *StructTM) -> SizeT


	func localtime_s(timer: *TimeT, tmptr: *StructTM) -> *StructTM // (since C11)
	func localtime_r(timer: *TimeT, tmptr: *StructTM) -> *StructTM // (since C23)
}


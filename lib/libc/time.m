// libc/time.m

pragma do_not_include
pragma module_nodecorate
pragma c_include "time.h"

include "libc/ctypes64"


/* time in seconds since 1970 */
@alias("c", "time_t")
public type TimeT = Int32

@alias("c", "clock_t")
public type ClockT = UnsignedLong


@alias("c", "struct tm")
public type StructTM = @public record {
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
	tm_zone: *ConstChar  // Timezone abbreviation
//$else
//	__tm_gmtoff: LongInt   // Seconds east of UTC
//	__tm_zone: *ConstChar  // Timezone abbreviation
//$endif
}

// Clock program
public func clock () -> ClockT

// Return difference between two times
public func difftime (end: TimeT, beginning: TimeT) -> Double

// Convert tm structure to time_t
public func mktime (timeptr: *StructTM) -> TimeT

// Get current time
public func time (timer: *TimeT) -> @unused TimeT

// Convert tm structure to string
public func asctime (timeptr: *StructTM) -> *Char

// Convert time_t value to string
public func ctime (timer: *TimeT) -> *Char

// Convert time_t to tm as UTC time
public func gmtime (timer: *TimeT) -> *StructTM

// Convert time_t to tm as local time
public func localtime (timer: *TimeT) -> *StructTM

// Format time as string
public func strftime (ptr: *Char, maxsize: SizeT, format: *ConstChar, timeptr: *StructTM) -> SizeT


public func localtime_s (timer: *TimeT, tmptr: *StructTM) -> *StructTM  // (since C11)
public func localtime_r (timer: *TimeT, tmptr: *StructTM) -> *StructTM  // (since C23)



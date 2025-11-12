
include "libc/time"
include "libc/string"
include "libc/stdio"



public type Date = @public record {
	year: Nat32
	month: Nat8
	day: Nat8
}

public type Time = @public record {
	hour: Nat8
	minute: Nat8
	second: Nat8
}


public type DateTime = @public record {
	date: Date
	time: Time
}


func localTimeNow () -> StructTM {
	var t: TimeT
	time(&t)
	var tm: StructTM
    let tm2 = localtime_r(&t, &tm)
	return tm
}


public func timeNow () -> Time {
	let tm = localTimeNow()
	return Time {
		hour = unsafe Nat8 tm.tm_hour
		minute = unsafe Nat8 tm.tm_min
		second = unsafe Nat8 tm.tm_sec
	}
}


const baseYear = 1900

public func dateNow () -> Date {
	let tm = localTimeNow()
	return Date {
		year = unsafe Nat32 tm.tm_year + baseYear
		month = unsafe Nat8 tm.tm_mon + 1
		day = unsafe Nat8 tm.tm_mday
	}
}


public func dateTimeNow () -> DateTime {
	let tm = localTimeNow()
	return DateTime {
		date = {
			year = unsafe Nat32 tm.tm_year + baseYear
			month = unsafe Nat8 tm.tm_mon + 1
			day = unsafe Nat8 tm.tm_mday
		}
		time = {
			hour = unsafe Nat8 tm.tm_hour
			minute = unsafe Nat8 tm.tm_min
			second = unsafe Nat8 tm.tm_sec
		}
	}
}


public func dayOfYear () -> Nat32 {
	let tm = localTimeNow()
	return unsafe Nat32 tm.tm_yday + 1
}


public func dayOfWeek () -> Nat8 {
	let tm = localTimeNow()
	let cwday = unsafe Nat8 tm.tm_wday
	if cwday > 0 {
		return cwday - 1
	}
	return 7
}




public func sprintDate (s: *[]Char8) -> Int32 {
	let dt = dateTimeNow()
	return sprintf(
		s
		"%d-%02d-%02d"
		dt.date.year
		dt.date.month
		dt.date.day
	)
}


public func sprintTime (s: *[]Char8) -> Int32 {
	let dt = dateTimeNow()
	return sprintf(
		s
		"%02d:%02d:%02d"
		dt.time.hour
		dt.time.minute
		dt.time.second
	)
}


public func sprintDateTime (s: *[]Char8) -> @unused Int32 {
	let delimiter = Char8 ' '
	let x0 = sprintDate(&s[0:])
	s[x0] = delimiter
	let x1 = sprintTime(&s[x0+1:])
	s[x0 + 1 + x1] = '\0'
	return x0 + 1 + x1
}



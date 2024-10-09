
include "libc/time"


public type Date record {
	year: Nat32
	month: Nat8
	day: Nat8
}

public type Time record {
	hour: Nat8
	minute: Nat8
	second: Nat8
}


public type DateTime record {
	year: Nat32
	month: Nat8
	day: Nat8
	hour: Nat8
	minute: Nat8
	second: Nat8
}


func localTimeNow() -> *StructTM {
	var t: TimeT
	time(&t)
	var tm: StructTM
    let tm = localtime_r(&t, &tm)
	return tm
}


public func timeNow() -> Time {
	let tm = localTimeNow()
	return Time {
		hour = unsafe Nat8 tm.tm_hour
		minute = unsafe Nat8 tm.tm_min
		second = unsafe Nat8 tm.tm_sec
	}
}


public func dateNow() -> Date {
	let tm = localTimeNow()
	return Date {
		year = unsafe Nat32 tm.tm_year + 1900
		month = unsafe Nat8 tm.tm_mon + 1
		day = unsafe Nat8 tm.tm_mday
	}
}


public func dateTimeNow() -> DateTime {
	let tm = localTimeNow()
	return DateTime {
		year = unsafe Nat32 tm.tm_year + 1900
		month = unsafe Nat8 tm.tm_mon + 1
		day = unsafe Nat8 tm.tm_mday
		//
		hour = unsafe Nat8 tm.tm_hour
		minute = unsafe Nat8 tm.tm_min
		second = unsafe Nat8 tm.tm_sec
	}
}


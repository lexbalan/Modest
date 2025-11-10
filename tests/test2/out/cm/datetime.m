include "time"
include "string"
include "stdio"




public type Date = @public record {
	public year: Nat32
	public month: Nat8
	public day: Nat8
}

public type Time = @public record {
	public hour: Nat8
	public minute: Nat8
	public second: Nat8
}


public type DateTime = @public record {
	public date: Date
	public time: Time
}


func localTimeNow () -> StructTM {
	var t: TimeT
	time(&t)
	var tm: StructTM
	let tm2: *StructTM = localtime_r(&t, &tm)
	return tm
}


public func timeNow () -> Time {
	let tm: StructTM = localTimeNow()
	return Time {
		hour = unsafe Nat8 tm.tm_hour
		minute = unsafe Nat8 tm.tm_min
		second = unsafe Nat8 tm.tm_sec
	}
}


public func dateNow () -> Date {
	let tm: StructTM = localTimeNow()
	return Date {
		year = unsafe Nat32 tm.tm_year + 1900
		month = unsafe Nat8 tm.tm_mon + 1
		day = unsafe Nat8 tm.tm_mday
	}
}


public func dateTimeNow () -> DateTime {
	let tm: StructTM = localTimeNow()
	return DateTime {
		date = {
			year = unsafe Nat32 tm.tm_year + 1900
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
	let tm: StructTM = localTimeNow()
	return unsafe Nat32 tm.tm_yday
}


public func dayOfWeek () -> Nat8 {
	let tm: StructTM = localTimeNow()
	return unsafe Nat8 tm.tm_wday
}




public func sprintDate (s: *[]Char8) -> Int32 {
	let dt: DateTime = dateTimeNow()
	return sprintf(s, "%d-%02d-%02d"
		dt.date.year
		dt.date.month
		dt.date.day
	)
}


public func sprintTime (s: *[]Char8) -> Int32 {
	let dt: DateTime = dateTimeNow()
	return sprintf(s, "%02d:%02d:%02d"
		dt.time.hour
		dt.time.minute
		dt.time.second
	)
}


public func sprintDateTime (s: *[]Char8) -> Int32 {
	let delimiter = Char8 " "
	let x0: Int32 = sprintDate(&s[0:])
	s[x0] = delimiter
	let x1: Int32 = sprintTime(&s[x0 + 1:])
	s[x0 + 1 + x1] = "\x0"
	return x0 + 1 + x1
}


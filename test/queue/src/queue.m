
include "console"
include "inttypes"


// BUG: Queue зависит от bufSize но он
export let bufSize = 8

export type Queue record {
	data: [bufSize]Byte
	head: Int32
	tail: Int32
}


export func isEmpty(q: *Queue) -> Bool {
	return true
}

export func put(q: *Queue, b: Byte) -> Bool {
	return false
}

export func get(q: *Queue) -> Byte {
	return 0
}


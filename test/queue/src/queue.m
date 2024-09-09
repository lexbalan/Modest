
include "console"
include "inttypes"


// BUG: Queue зависит от bufSize но он
export let bufSize = 4

export type Queue record {
	data: [bufSize]Byte
	p: Int32  // put index
	g: Int32  // get index
}


export func isEmpty(q: *Queue) -> Bool {
	return q.g == q.p
}

export func put(q: *Queue, b: Byte) -> Bool {
	// пишем в p
	// !если он не налезет на g в результате

	// получим индекс куда хвост должен прийти
	let np = next(q.p)

	// И если он будет налазить на голову - выходим
	if np == q.g {
		// Если добавить то хвост наедет на голову, так нельзя
		return false
	}

	printf("put %d to %d\n", Int32 b, q.p)
	q.data[q.p] = b
	q.p = np
	return true
}


// you need check isEmpty(&queue) before get call
export func get(q: *Queue) -> Byte {
	let ng = next(q.g)
	let x = q.data[q.g]
	q.g = ng
	return x
}


@inline
func next(x: Int32) -> Int32 {
	if x < bufSize - 1 {
		return x + 1
	}
	return 0
}

@inline
func prev(x: Int32) -> Int32 {
	if x > 1 {
		return x - 1
	}
	return bufSize
}




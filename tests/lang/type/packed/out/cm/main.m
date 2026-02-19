

type PackedHeader = @layout {
	magic: Nat8
	version: Nat8
	length: Nat16
}

type PackedData = @layout {
	flags: Nat8
	id: Nat32
	value: Nat64
}

type PackedNested = @layout {
	header: PackedHeader
	payload: Nat32
}

var hdr: PackedHeader = {magic = 255, version = 1, length = 64}

func makeHeader (magic: Nat8, ver: Nat8, len: Nat16) -> PackedHeader {
	return {magic = magic, version = ver, length = len}
}

func readMagic (h: *PackedHeader) -> Nat8 {
	return h.magic
}

public func main () -> Int32 {
	var h: PackedHeader = makeHeader(171, 2, 128)
	var m: Nat8 = readMagic(&h)
	var d: PackedData = {flags = 1, id = 42, value = 1000}
	return 0
}


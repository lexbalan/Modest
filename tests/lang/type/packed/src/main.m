// test: packed record types

type PackedHeader = @packed {
	magic: Nat8
	version: Nat8
	length: Nat16
}

type PackedData = @packed {
	flags: Nat8
	id: Nat32
	value: Nat64
}

type PackedNested = @packed {
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
	var h = makeHeader(171, 2, 128)
	var m = readMagic(&h)
	var d: PackedData = {flags = 1, id = 42, value = 1000}
	return 0
}

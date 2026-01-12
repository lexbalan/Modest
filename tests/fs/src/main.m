// examples/0.endianness/src/main.m

module "fs/main"

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/assert"


const blockSize = 4096
const nblocks = 1024

type Block = record {data: [blockSize]Word8}
var disk: [nblocks]Block

func dread (n: Nat32, block: *Block) -> @unused Int {
	//assert(n < nblocks)
	*block = disk[n]
	return 0
}

func dwrite (n: Nat32, block: *Block) -> @unused Int {
	//assert(n < nblocks)
	disk[n] = *block
	return 0
}


const fblocks = 16


@alignment(blockSize)
type Inode = record {
	typ: Word32
	size: Nat32
	blocks: [fblocks]Nat32
}



func inodeRead (n: Nat32, inode: *Inode) -> @unused Int {
	dread(n, unsafe *Block inode)
	return 0
}

func bwrite (inode: *Inode, nblock: Nat32, block: *Block) -> Int {
	//
	return 0
}

func bread (inode: *Inode, nblock: Nat32, block: *Block) -> Int {
	//
	return 0
}


var super: Super

public func main () -> Int {
	var inode: Inode
	inodeRead(1, &inode)

	return 0
}


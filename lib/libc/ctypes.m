// libc/ctypes.m

$pragma do_not_include
$pragma module_nodecorate

//import "./system"

/*$if (systemWidth == 32)
import "./ctypes32"
$elseif (systemWidth == 64)
import "./ctypes64"
$else
@error("C types not implemented")
$endif*/

include "./ctypes64"

export {
	@property("type.id.c", "socklen_t")
	type SocklenT Nat32

	@property("type.id.c", "size_t")
	type SizeT UnsignedLongInt

	@property("type.id.c", "ssize_t")
	type SSizeT LongInt

	@property("type.id.c", "intptr_t")
	type IntptrT Nat64

	@property("type.id.c", "ptrdiff_t")
	type PtrdiffT Ptr

	@property("type.id.c", "off_t")
	type OffT Int64


	@property("type.id.c", "useconds_t")
	type USecondsT Nat32

	@property("type.id.c", "pid_t")
	type PidT Int32

	@property("type.id.c", "uid_t")
	type UidT Nat32

	@property("type.id.c", "gid_t")
	type GidT Nat32
}


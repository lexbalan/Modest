// libc/ctypes.hm

$pragma do_not_include

//import "./system"

/*$if (systemWidth == 32)
import "./ctypes32"
$elseif (systemWidth == 64)
import "./ctypes64"
$else
@error("C types not implemented")
$endif*/

include "./ctypes64"

@property("type.id.c", "socklen_t")
export type SocklenT Nat32

@property("type.id.c", "size_t")
export type SizeT UnsignedLongInt

@property("type.id.c", "ssize_t")
export type SSizeT LongInt

@property("type.id.c", "intptr_t")
export type IntptrT Nat64

@property("type.id.c", "ptrdiff_t")
export type PtrdiffT Ptr

@property("type.id.c", "off_t")
export type OffT Int64


@property("type.id.c", "useconds_t")
export type USecondsT Nat32

@property("type.id.c", "pid_t")
export type PidT Int32

@property("type.id.c", "uid_t")
export type UidT Nat32

@property("type.id.c", "gid_t")
export type GidT Nat32



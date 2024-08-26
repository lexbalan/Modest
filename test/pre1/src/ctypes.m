// libc/ctypes.hm

$pragma not_included
$pragma c_no_print

//import "./system"

//$if (systemWidth == 32)
//import "./ctypes32"
//$elseif (systemWidth == 64)
include "./ctypes64"
//$else
//@error("C types not implemented")
//$endif


@property("type.c_alias", "socklen_t")
type SocklenT Nat32

@property("type.c_alias", "size_t")
type SizeT UnsignedLongInt

@property("type.c_alias", "ssize_t")
type SSizeT LongInt

@property("type.c_alias", "intptr_t")
type IntptrT Nat64

@property("type.c_alias", "ptrdiff_t")
type PtrdiffT Ptr

@property("type.c_alias", "off_t")
type OffT Int64


@property("type.c_alias", "useconds_t")
type USecondsT Nat32

@property("type.c_alias", "pid_t")
type PidT Int32

@property("type.c_alias", "uid_t")
type UidT Nat32

@property("type.c_alias", "gid_t")
type GidT Nat32



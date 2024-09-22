// libc/ctypes32.m

$pragma do_not_include
$pragma module_nodecorate

export {
@property("type.id.c", "char *")
type Str Str8

@property("type.id.c", "char")
type Char Char8

@property("type.id.c", "const char")
type ConstChar Char

@property("type.id.c", "signed char")
type SignedChar Int8

@property("type.id.c", "unsigned char")
type UnsignedChar Nat8


@property("type.id.c", "short")
type Short Int16

@property("type.id.c", "unsigned short")
type UnsignedShort Nat16


@property("type.id.c", "int")
type Int Int32

@property("type.id.c", "unsigned int")
type UnsignedInt Nat32

@property("type.id.c", "long int")
type LongInt Int32

@property("type.id.c", "unsigned long int")
type UnsignedLongInt Nat32


@property("type.id.c", "long")
type Long Int32

@property("type.id.c", "unsigned long")
type UnsignedLong Nat32

@property("type.id.c", "long long")
type LongLong Int64

@property("type.id.c", "unsigned long long")
type UnsignedLongLong Nat64

@property("type.id.c", "long long int")
type LongLongInt Int64

@property("type.id.c", "unsigned long long int")
type UnsignedLongLongInt Nat64


@property("type.id.c", "float")
type Float Float64

@property("type.id.c", "double")
type Double Float64

@property("type.id.c", "long double")
type LongDouble Float64
}



export {
	@property("type.id.c", "socklen_t")
	type SocklenT Nat32

	@property("type.id.c", "size_t")
	type SizeT UnsignedLongInt

	@property("type.id.c", "ssize_t")
	type SSizeT LongInt

	@property("type.id.c", "intptr_t")
	type IntptrT Nat32

	@property("type.id.c", "ptrdiff_t")
	type PtrdiffT Ptr

	@property("type.id.c", "off_t")
	type OffT Int32


	@property("type.id.c", "useconds_t")
	type USecondsT Nat32

	@property("type.id.c", "pid_t")
	type PidT Int32

	@property("type.id.c", "uid_t")
	type UidT Nat32

	@property("type.id.c", "gid_t")
	type GidT Nat32
}



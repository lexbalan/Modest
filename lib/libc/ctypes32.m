// libc/ctypes32.m

$pragma do_not_include
$pragma module_nodecorate


@property("id.c", "char *")
public type Str Str8

@property("id.c", "char")
public type Char Char8

@property("id.c", "const char")
public type ConstChar Char

@property("id.c", "signed char")
public type SignedChar Int8

@property("id.c", "unsigned char")
public type UnsignedChar Nat8


@property("id.c", "short")
public type Short Int16

@property("id.c", "unsigned short")
public type UnsignedShort Nat16


@property("id.c", "int")
public type Int Int32

@property("id.c", "unsigned int")
public type UnsignedInt Nat32

@property("id.c", "long int")
public type LongInt Int32

@property("id.c", "unsigned long int")
public type UnsignedLongInt Nat32


@property("id.c", "long")
public type Long Int32

@property("id.c", "unsigned long")
public type UnsignedLong Nat32

@property("id.c", "long long")
public type LongLong Int64

@property("id.c", "unsigned long long")
public type UnsignedLongLong Nat64

@property("id.c", "long long int")
public type LongLongInt Int64

@property("id.c", "unsigned long long int")
public type UnsignedLongLongInt Nat64


@property("id.c", "float")
public type Float Float64

@property("id.c", "double")
public type Double Float64

@property("id.c", "long double")
public type LongDouble Float64



@property("id.c", "size_t")
public type SizeT UnsignedLongInt

@property("id.c", "ssize_t")
public type SSizeT LongInt

@property("id.c", "intptr_t")
public type IntPtrT Nat32

@property("id.c", "ptrdiff_t")
public type PtrDiffT Ptr

@property("id.c", "off_t")
public type OffT Int32


@property("id.c", "useconds_t")
public type USecondsT Nat32

@property("id.c", "pid_t")
public type PIDT Int32

@property("id.c", "uid_t")
public type UIDT Nat32

@property("id.c", "gid_t")
public type GIDT Nat32




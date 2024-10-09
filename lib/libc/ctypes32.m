// libc/ctypes32.m

$pragma do_not_include
$pragma module_nodecorate


@property("type.id.c", "char *")
public type Str Str8

@property("type.id.c", "char")
public type Char Char8

@property("type.id.c", "const char")
public type ConstChar Char

@property("type.id.c", "signed char")
public type SignedChar Int8

@property("type.id.c", "unsigned char")
public type UnsignedChar Nat8


@property("type.id.c", "short")
public type Short Int16

@property("type.id.c", "unsigned short")
public type UnsignedShort Nat16


@property("type.id.c", "int")
public type Int Int32

@property("type.id.c", "unsigned int")
public type UnsignedInt Nat32

@property("type.id.c", "long int")
public type LongInt Int32

@property("type.id.c", "unsigned long int")
public type UnsignedLongInt Nat32


@property("type.id.c", "long")
public type Long Int32

@property("type.id.c", "unsigned long")
public type UnsignedLong Nat32

@property("type.id.c", "long long")
public type LongLong Int64

@property("type.id.c", "unsigned long long")
public type UnsignedLongLong Nat64

@property("type.id.c", "long long int")
public type LongLongInt Int64

@property("type.id.c", "unsigned long long int")
public type UnsignedLongLongInt Nat64


@property("type.id.c", "float")
public type Float Float64

@property("type.id.c", "double")
public type Double Float64

@property("type.id.c", "long double")
public type LongDouble Float64



@property("type.id.c", "size_t")
public type SizeT UnsignedLongInt

@property("type.id.c", "ssize_t")
public type SSizeT LongInt

@property("type.id.c", "intptr_t")
public type IntPtrT Nat32

@property("type.id.c", "ptrdiff_t")
public type PtrDiffT Ptr

@property("type.id.c", "off_t")
public type OffT Int32


@property("type.id.c", "useconds_t")
public type USecondsT Nat32

@property("type.id.c", "pid_t")
public type PIDT Int32

@property("type.id.c", "uid_t")
public type UIDT Nat32

@property("type.id.c", "gid_t")
public type GIDT Nat32




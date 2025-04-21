// libc/ctypes64.hm

$pragma do_not_include
$pragma c_no_print

@property("id.c", "char *")
type Str Str8

@property("id.c", "char")
type Char Char8

@property("id.c", "const char")
type ConstChar Char

@property("id.c", "signed char")
type SignedChar Int8

@property("id.c", "unsigned char")
type UnsignedChar Nat8


@property("id.c", "short")
type Short Int16

@property("id.c", "unsigned short")
type UnsignedShort Nat16


@property("id.c", "int")
type Int Int32

@property("id.c", "unsigned int")
type UnsignedInt Nat32

@property("id.c", "long int")
type LongInt Int64

@property("id.c", "unsigned long int")
type UnsignedLongInt Nat64


@property("id.c", "long")
type Long Int64

@property("id.c", "unsigned long")
type UnsignedLong Nat64

@property("id.c", "long long")
type LongLong Int64

@property("id.c", "unsigned long long")
type UnsignedLongLong Nat64

@property("id.c", "long long int")
type LongLongInt Int64

@property("id.c", "unsigned long long int")
type UnsignedLongLongInt Nat64


@property("id.c", "float")
type Float Float64

@property("id.c", "double")
type Double Float64

@property("id.c", "long double")
type LongDouble Float64



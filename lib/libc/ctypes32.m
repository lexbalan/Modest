// libc/ctypes32.hm

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


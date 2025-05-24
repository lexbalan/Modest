// libc/ctypes64.hm

pragma do_not_include
pragma c_no_print

@set("id.c", "char *")
type Str Str8

@set("id.c", "char")
type Char Char8

@set("id.c", "const char")
type ConstChar Char

@set("id.c", "signed char")
type SignedChar Int8

@set("id.c", "unsigned char")
type UnsignedChar Nat8


@set("id.c", "short")
type Short Int16

@set("id.c", "unsigned short")
type UnsignedShort Nat16


@set("id.c", "int")
type Int Int32

@set("id.c", "unsigned int")
type UnsignedInt Nat32

@set("id.c", "long int")
type LongInt Int64

@set("id.c", "unsigned long int")
type UnsignedLongInt Nat64


@set("id.c", "long")
type Long Int64

@set("id.c", "unsigned long")
type UnsignedLong Nat64

@set("id.c", "long long")
type LongLong Int64

@set("id.c", "unsigned long long")
type UnsignedLongLong Nat64

@set("id.c", "long long int")
type LongLongInt Int64

@set("id.c", "unsigned long long int")
type UnsignedLongLongInt Nat64


@set("id.c", "float")
type Float Float64

@set("id.c", "double")
type Double Float64

@set("id.c", "long double")
type LongDouble Float64



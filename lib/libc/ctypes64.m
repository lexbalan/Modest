// libc/ctypes64.hm

$pragma do_not_include


@property("type.id.c", "char *")
export type Str Str8

@property("type.id.c", "char")
export type Char Char8

@property("type.id.c", "const char")
export type ConstChar Char

@property("type.id.c", "signed char")
export type SignedChar Int8

@property("type.id.c", "unsigned char")
export type UnsignedChar Nat8


@property("type.id.c", "short")
export type Short Int16

@property("type.id.c", "unsigned short")
export type UnsignedShort Nat16


@property("type.id.c", "int")
export type Int Int32

@property("type.id.c", "unsigned int")
export type UnsignedInt Nat32

@property("type.id.c", "long int")
export type LongInt Int64

@property("type.id.c", "unsigned long int")
export type UnsignedLongInt Nat64


@property("type.id.c", "long")
export type Long Int64

@property("type.id.c", "unsigned long")
export type UnsignedLong Nat64

@property("type.id.c", "long long")
export type LongLong Int64

@property("type.id.c", "unsigned long long")
export type UnsignedLongLong Nat64

@property("type.id.c", "long long int")
export type LongLongInt Int64

@property("type.id.c", "unsigned long long int")
export type UnsignedLongLongInt Nat64


@property("type.id.c", "float")
export type Float Float64

@property("type.id.c", "double")
export type Double Float64

@property("type.id.c", "long double")
export type LongDouble Float64



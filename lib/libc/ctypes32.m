// libc/ctypes32.m

pragma do_not_include
pragma module_nodecorate


@set("id.c", "char *")
public type Str = Str8

@set("id.c", "char")
public type Char = Char8

@set("id.c", "const char")
public type ConstChar = Char

@set("id.c", "signed char")
public type SignedChar = Int8

@set("id.c", "unsigned char")
public type UnsignedChar = Nat8


@set("id.c", "short")
public type Short = Int16

@set("id.c", "unsigned short")
public type UnsignedShort = Nat16


@set("id.c", "int")
public type Int = Int32

@set("id.c", "unsigned int")
public type UnsignedInt = Nat32

@set("id.c", "long int")
public type LongInt = Int32

@set("id.c", "unsigned long int")
public type UnsignedLongInt = Nat32


@set("id.c", "long")
public type Long = Int32

@set("id.c", "unsigned long")
public type UnsignedLong = Nat32

@set("id.c", "long long")
public type LongLong = Int64

@set("id.c", "unsigned long long")
public type UnsignedLongLong = Nat64

@set("id.c", "long long int")
public type LongLongInt = Int64

@set("id.c", "unsigned long long int")
public type UnsignedLongLongInt Nat64


@set("id.c", "float")
public type Float = Float64

@set("id.c", "double")
public type Double = Float64

@set("id.c", "long double")
public type LongDouble = Float64



@set("id.c", "size_t")
public type SizeT = UnsignedLongInt

@set("id.c", "ssize_t")
public type SSizeT = LongInt

@set("id.c", "intptr_t")
public type IntPtrT = Nat32

@set("id.c", "ptrdiff_t")
public type PtrDiffT = Ptr

@set("id.c", "off_t")
public type OffT = Int32


@set("id.c", "useconds_t")
public type USecondsT = Nat32

@set("id.c", "pid_t")
public type PIDT = Int32

@set("id.c", "uid_t")
public type UIDT = Nat32

@set("id.c", "gid_t")
public type GIDT = Nat32



// libc/ctypes64.m

pragma do_not_include
pragma module_nodecorate


@alias("c", "char *")
public type Str = Str8

@alias("c", "char")
public type Char = Char8

@alias("c", "const char")
public type ConstChar = Char

@alias("c", "signed char")
public type SignedChar = Int8

@alias("c", "unsigned char")
public type UnsignedChar = Nat8


@alias("c", "short")
public type Short = Int16

@alias("c", "unsigned short")
public type UnsignedShort = Nat16


@alias("c", "int")
public type Int = Int32

@alias("c", "unsigned int")
public type UnsignedInt = Nat32

@alias("c", "long int")
public type LongInt = Int64

@alias("c", "unsigned long int")
public type UnsignedLongInt = Nat64


@alias("c", "long")
public type Long = Int64

@alias("c", "unsigned long")
public type UnsignedLong = Nat64

@alias("c", "long long")
public type LongLong = Int64

@alias("c", "unsigned long long")
public type UnsignedLongLong = Nat64

@alias("c", "long long int")
public type LongLongInt = Int64

@alias("c", "unsigned long long int")
public type UnsignedLongLongInt = Nat64


@alias("c", "float")
public type Float = Float64

@alias("c", "double")
public type Double = Float64

@alias("c", "long double")
public type LongDouble = Float64



@alias("c", "size_t")
public type SizeT = UnsignedLongInt

@alias("c", "ssize_t")
public type SSizeT = LongInt

@alias("c", "intptr_t")
public type IntPtrT = Nat64

@alias("c", "ptrdiff_t")
public type PtrDiffT = Ptr

@alias("c", "off_t")
public type OffT = Int64


@alias("c", "useconds_t")
public type USecondsT = Nat32

@alias("c", "pid_t")
public type PIDT = Int32

@alias("c", "uid_t")
public type UIDT = Nat32

@alias("c", "gid_t")
public type GIDT = Nat32



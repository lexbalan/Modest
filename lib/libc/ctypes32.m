// libc/ctypes32.m

pragma do_not_include
pragma module_nodecorate


@calias("char *")
public type Str = Str8

@calias("char")
public type Char = Char8

@calias("const char")
public type ConstChar = Char

@calias("signed char")
public type SignedChar = Int8

@calias("unsigned char")
public type UnsignedChar = Nat8


@calias("short")
public type Short = Int16

@calias("unsigned short")
public type UnsignedShort = Nat16


@calias("int")
public type Int = Int32

@calias("unsigned int")
public type UnsignedInt = Nat32

@calias("long int")
public type LongInt = Int32

@calias("unsigned long int")
public type UnsignedLongInt = Nat32


@calias("long")
public type Long = Int32

@calias("unsigned long")
public type UnsignedLong = Nat32

@calias("long long")
public type LongLong = Int64

@calias("unsigned long long")
public type UnsignedLongLong = Nat64

@calias("long long int")
public type LongLongInt = Int64

@calias("unsigned long long int")
public type UnsignedLongLongInt Nat64


@calias("float")
public type Float = Float64

@calias("double")
public type Double = Float64

@calias("long double")
public type LongDouble = Float64



@calias("size_t")
public type SizeT = UnsignedLongInt

@calias("ssize_t")
public type SSizeT = LongInt

@calias("intptr_t")
public type IntPtrT = Nat32

@calias("ptrdiff_t")
public type PtrDiffT = Ptr

@calias("off_t")
public type OffT = Int32


@calias("useconds_t")
public type USecondsT = Nat32

@calias("pid_t")
public type PIDT = Int32

@calias("uid_t")
public type UIDT = Nat32

@calias("gid_t")
public type GIDT = Nat32




target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [24 x i8] [i8 110, i8 117, i8 109, i8 101, i8 114, i8 105, i8 99, i8 32, i8 98, i8 111, i8 117, i8 110, i8 100, i8 97, i8 114, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 115, i8 10, i8 0]
; -- endstrings --


;const float32Max       = Float32 3.4028234663852886e+38
;const float32MinNormal = Float32 1.1754943508222875e-38
;const float32MinSub    = Float32 1.401298464324817e-45
;const float32Epsilon   = Float32 1.1920928955078125e-7
;
;const float32PosInf    = Float32 (1.0 / 0.0)
;const float32NaN       = Float32 (0.0 / 0.0)
;const float32NegInf    = Float32 (-1.0 / 0.0)

;
;
;func assert(cond: Bool, msg: *Str8) {
;    if not cond {
;        printf("ASSERT FAILED: %s\n", msg)
;        abort()
;    }
;}
;
;
;// ------------------------------------------------------------
;// Signed integers
;// ------------------------------------------------------------
;
;func test_Int8 () -> Unit {
;    let min = Int8 -128
;    let max = Int8 127
;
;    assert(min < Int8 0, "Int8 min < 0")
;    assert(max > Int8 0, "Int8 max > 0")
;
;    assert(Int8 -1 < Int8 0, "Int8 sign")
;    assert(Int8 1 > Int8 0, "Int8 positive")
;
;    // wrap tests (если у тебя defined wrap semantics)
;//	printf("?? = %lld\n", Int64 (max + Int8 1))
;    assert(Int8 (max + Int8 1) == min, "Int8 overflow up")
;    assert(Int8 (min - Int8 1) == max, "Int8 overflow down")
;}
;
;
;func test_Int16 () -> Unit {
;    let min = Int16 -32768
;    let max = Int16 32767
;
;    assert(Int16 (max + Int16 1) == min, "Int16 overflow up")
;    assert(Int16 (min - Int16 1) == max, "Int16 overflow down")
;}
;
;
;func test_Int32 () -> Unit {
;    let min = Int32 -2147483648
;    let max = Int32 2147483647
;
;    assert(Int32 (max + Int32 1) == min, "Int32 overflow up")
;    assert(Int32 (min - Int32 1) == max, "Int32 overflow down")
;}
;
;
;func test_Int64 () -> Unit {
;    let min = Int64 -9223372036854775808
;    let max = Int64 9223372036854775807
;
;    assert(Int64 (max + Int64 1) == min, "Int64 overflow up")
;    assert(Int64 (min - Int64 1) == max, "Int64 overflow down")
;}
;
;
;// ------------------------------------------------------------
;// Unsigned integers
;// ------------------------------------------------------------
;
;func test_Nat8 () -> Unit {
;    let max = Nat8 255
;
;    assert(Nat8 0 == Nat8 (max + Nat8 1), "Nat8 overflow up")
;}
;
;func test_Nat16 () -> Unit {
;    let max = Nat16 65535
;
;    assert(Nat16 0 == Nat16 (max + Nat16 1), "Nat16 overflow up")
;}
;
;func test_Nat32 () -> Unit {
;    let max = Nat32 4294967295
;
;    assert(Nat32 0 == Nat32 (max + Nat32 1), "Nat32 overflow up")
;}
;
;func test_Nat64 () -> Unit {
;    let max = Nat64 18446744073709551615
;
;    assert(Nat64 0 == Nat64 (max + Nat64 1), "Nat64 overflow up")
;}
;
;
;// ------------------------------------------------------------
;// Float32
;// ------------------------------------------------------------
;
;func test_Float32 () -> Unit {
;
;    let zero = Float32 0.0
;    let one = Float32 1.0
;    let minus_one = Float32 -1.0
;
;    assert(one > zero, "Float32 positive")
;    assert(minus_one < zero, "Float32 negative")
;
;    // Проверка деления
;    assert(one / one == one, "Float32 division")
;
;    // Infinity
;//    let inf = one / zero
;//    assert(inf > one, "Float32 +inf")
;//
;//    // NaN
;//    let nan = zero / zero
;//    assert(not(nan == nan), "Float32 NaN")
;}
;
;
;// ------------------------------------------------------------
;// Float64
;// ------------------------------------------------------------
;
;func test_Float64 () -> Unit {
;
;    let zero = Float64 0.0
;    let one = Float64 1.0
;
;//    let inf = one / zero
;//    assert(inf > one, "Float64 +inf")
;//
;//    let nan = zero / zero
;//    assert(not(nan == nan), "Float64 NaN")
;}
;
;

; ------------------------------------------------------------
; Entry
; ------------------------------------------------------------
define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str1 to [0 x i8]*))
	%2 = alloca %Float32, align 4
	store %Float32 3.1415927410125732, %Float32* %2
	%3 = alloca %Float64, align 8
	store %Float64 3.1415926535897931, %Float64* %3

	;	let n8 = Nat8 (_nat8Max + 1)
	;	printf("n8 = %i\n", Word32 n8)
	;
	;	let n16 = Nat16 (_nat16Max + 1)
	;	printf("n16 = %u\n", Word32 n16)
	;
	;	let n32 = Nat32 (_nat32Max + 1)
	;	printf("n32 = %u\n", Word32 n32)
	;
	;	let n64 = Nat64 (_nat64Max + 1)
	;	printf("n64 = %llu\n", Word64 n64)


	;	let i8 = Nat8 (127 + 1)
	;	printf("i8 = %i\n", i8)

	;    test_Int8()
	;    test_Int16()
	;    test_Int32()
	;    test_Int64()
	;
	;    test_Nat8()
	;    test_Nat16()
	;    test_Nat32()
	;    test_Nat64()
	;
	;    test_Float32()
	;    test_Float64()
	;
	;    printf("OK\n")
	ret %Int32 0
}



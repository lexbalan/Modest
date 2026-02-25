
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Fixed32 = type i32
%Fixed64 = type i64
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
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
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
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [6 x i8] [i8 37, i8 100, i8 46, i8 37, i8 100, i8 0]
@str2 = private constant [6 x i8] [i8 102, i8 120, i8 32, i8 61, i8 32, i8 0]
@str3 = private constant [2 x i8] [i8 10, i8 0]
@str4 = private constant [6 x i8] [i8 102, i8 50, i8 32, i8 61, i8 32, i8 0]
@str5 = private constant [2 x i8] [i8 10, i8 0]
@str6 = private constant [12 x i8] [i8 82, i8 97, i8 119, i8 32, i8 102, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [12 x i8] [i8 82, i8 97, i8 119, i8 32, i8 97, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [12 x i8] [i8 82, i8 97, i8 119, i8 32, i8 98, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [12 x i8] [i8 82, i8 97, i8 119, i8 32, i8 99, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [12 x i8] [i8 82, i8 97, i8 119, i8 32, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 102, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 97, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 98, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str14 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 99, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str15 = private constant [14 x i8] [i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str16 = private constant [16 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 102, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str17 = private constant [16 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 97, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str18 = private constant [16 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 98, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str19 = private constant [16 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 99, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str20 = private constant [16 x i8] [i8 70, i8 108, i8 111, i8 97, i8 116, i8 51, i8 50, i8 32, i8 100, i8 32, i8 61, i8 32, i8 37, i8 102, i8 10, i8 0]
@str21 = private constant [12 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 105, i8 120, i8 101, i8 100, i8 10, i8 0]
@str22 = private constant [6 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 0]
@str23 = private constant [8 x i8] [i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str24 = private constant [8 x i8] [i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
define internal %Fixed32 @packFixed32(%Nat32 %i, %Nat32 %m, %Nat32 %n, %Nat8 %fraction) {
	%1 = zext %Nat32 %m to %Nat64
	%2 = zext i8 1 to %Word32
	%3 = zext %Nat8 %fraction to %Word32
	%4 = shl %Word32 %2, %3
	%5 = zext %Word32 %4 to %Nat64
	%6 = sub %Nat64 %5, 1
	%7 = mul %Nat64 %1, %6
	%8 = zext %Nat32 %n to %Nat64
	%9 = udiv %Nat64 %7, %8
	%10 = bitcast %Nat32 %i to %Word32
	%11 = zext %Nat8 %fraction to %Word32
	%12 = shl %Word32 %10, %11
	%13 = trunc %Nat64 %9 to %Word32
	%14 = or %Word32 %12, %13
	%15 = cast %Word32 %14 to %Fixed32
	ret %Fixed32 %15
}

define internal %Nat32 @headFixed32(%Word32 %f, %Nat8 %fraction) {
	%1 = zext %Nat8 %fraction to %Word32
	%2 = lshr %Word32 %f, %1
	%3 = bitcast %Word32 %2 to %Nat32
	ret %Nat32 %3
}

define internal %Nat32 @tailFixed32(%Word32 %f, %Nat8 %fraction) {
	%1 = zext i8 1 to %Word32
	%2 = zext %Nat8 %fraction to %Word32
	%3 = shl %Word32 %1, %2
	%4 = bitcast %Word32 %3 to %Nat32
	%5 = sub %Nat32 %4, 1
	%6 = bitcast %Nat32 %5 to %Word32
	%7 = and %Word32 %f, %6
	%8 = bitcast %Word32 %7 to %Nat32
	ret %Nat32 %8
}

define internal void @printFixed32(%Word32 %f, %Nat8 %fraction, %Nat32 %precision) {
	%1 = call %Nat32 @headFixed32(%Word32 %f, %Nat8 %fraction)
	%2 = call %Nat32 @tailFixed32(%Word32 %f, %Nat8 %fraction)
	%3 = zext %Nat32 %2 to %Nat64
	%4 = zext %Nat32 %precision to %Nat64
	%5 = mul %Nat64 %3, %4
	%6 = zext i8 1 to %Word32
	%7 = zext %Nat8 %fraction to %Word32
	%8 = shl %Word32 %6, %7
	%9 = zext %Word32 %8 to %Nat64
	%10 = udiv %Nat64 %5, %9
	%11 = trunc %Nat64 %10 to %Nat32
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str1 to [0 x i8]*), %Nat32 %1, %Nat32 %11)
	ret void
}

define internal %Bool @testFixed32Static() {
	%1 = alloca %Nat32, align 4
	%2 = alloca %Fixed32, align 4
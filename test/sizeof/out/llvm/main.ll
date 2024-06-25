
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Float32 = type float
%Float64 = type double
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Socklen_T = type i32
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64
%OffT = type i64
%PtrToConst = type i8*


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %VA_List %arg)
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


; -- SOURCE: src/main.cm

@str1 = private constant [21 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 97, i8 115, i8 116, i8 32, i8 111, i8 112, i8 101, i8 114, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@str2 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str3 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 111, i8 102, i8 102, i8 40, i8 105, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 112, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str7 = private constant [15 x i8] [i8 111, i8 102, i8 102, i8 40, i8 103, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str8 = private constant [22 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str9 = private constant [22 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str10 = private constant [22 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str11 = private constant [23 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 105, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str12 = private constant [22 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 112, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str13 = private constant [22 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 120, i8 46, i8 103, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str14 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str15 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 85, i8 110, i8 105, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str16 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str17 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 66, i8 111, i8 111, i8 108, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str18 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str19 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str20 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str21 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str22 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str23 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str24 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str25 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str26 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str27 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 78, i8 97, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str28 = private constant [21 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str29 = private constant [22 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str30 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str31 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str32 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str33 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str34 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str35 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 54, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str36 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str37 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 73, i8 110, i8 116, i8 49, i8 50, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str38 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str39 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str40 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str41 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 49, i8 54, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str42 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str43 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 67, i8 104, i8 97, i8 114, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str44 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str45 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 42, i8 83, i8 116, i8 114, i8 56, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str46 = private constant [26 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str47 = private constant [27 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 49, i8 48, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str48 = private constant [28 x i8] [i8 62, i8 32, i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 91, i8 51, i8 93, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str49 = private constant [22 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str50 = private constant [23 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str51 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 46, i8 120, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str52 = private constant [26 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 80, i8 111, i8 105, i8 110, i8 116, i8 46, i8 121, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str53 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str54 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 49, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str55 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str56 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str57 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 46, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str58 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 46, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str59 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 46, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str60 = private constant [28 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 46, i8 99, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str61 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 50, i8 46, i8 109, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str62 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str63 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 51, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str64 = private constant [23 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str65 = private constant [24 x i8] [i8 97, i8 108, i8 105, i8 103, i8 110, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str66 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 115, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str67 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 99, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str68 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 105, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str69 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 102, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str70 = private constant [28 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 99, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str71 = private constant [28 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 105, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str72 = private constant [27 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 112, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@str73 = private constant [28 x i8] [i8 111, i8 102, i8 102, i8 115, i8 101, i8 116, i8 111, i8 102, i8 40, i8 77, i8 105, i8 120, i8 101, i8 100, i8 52, i8 46, i8 115, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]



%Point = type {
	i32, 
	i32
}

%Mixed1 = type {
	i8, 
	i32, 
	double
}

%Mixed2 = type {
	i32, 
	i8, 
	double, 
	[3 x i8], 
	%Mixed1
}

%Mixed3 = type {
	i8, 
	i32, 
	double, 
	[9 x i8]
}

%Mixed4 = type {
	%Mixed2, 
	i8, 
	i32, 
	double, 
	[9 x i8], 
	i16, 
	[3 x %Point], 
	%Mixed3
}



@c = global i8 zeroinitializer
@i = global i32 zeroinitializer
@f = global double zeroinitializer
@i2 = global i16 zeroinitializer
@p = global [3 x %Point] zeroinitializer
@g = global i1 zeroinitializer

%X = type {
	i8, 
	i32, 
	double, 
	i16, 
	[3 x %Point], 
	i1
}


@x = global %X zeroinitializer

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
	%2 = ptrtoint i8* @c to i64
	%3 = ptrtoint i8* @c to i64
	%4 = sub i64 %3, %2
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str2 to [0 x i8]*), i64 %4)
	%6 = ptrtoint i32* @i to i64
	%7 = sub i64 %6, %2
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*), i64 %7)
	%9 = ptrtoint double* @f to i64
	%10 = sub i64 %9, %2
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), i64 %10)
	%12 = ptrtoint i16* @i2 to i64
	%13 = sub i64 %12, %2
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), i64 %13)
	%15 = ptrtoint [3 x %Point]* @p to i64
	%16 = sub i64 %15, %2
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), i64 %16)
	%18 = ptrtoint i1* @g to i64
	%19 = sub i64 %18, %2
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), i64 %19)
	; дженерики в с явно не приводятся, но нектороые нужно!
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str8 to [0 x i8]*), i64 0)
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str9 to [0 x i8]*), i64 4)
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str10 to [0 x i8]*), i64 8)
	%24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str11 to [0 x i8]*), i64 16)
	%25 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str12 to [0 x i8]*), i64 20)
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*), i64 44)
	; sizeof(void) in C  == 1
	; sizeof(Unit) in CM == 0
	; TODO: here is a broblem
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str14 to [0 x i8]*), i64 0)
	%28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str15 to [0 x i8]*), i64 0)
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str16 to [0 x i8]*), i64 1)
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str17 to [0 x i8]*), i64 1)
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str18 to [0 x i8]*), i64 1)
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str19 to [0 x i8]*), i64 1)
	%33 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str20 to [0 x i8]*), i64 2)
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str21 to [0 x i8]*), i64 2)
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str22 to [0 x i8]*), i64 4)
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str23 to [0 x i8]*), i64 4)
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str24 to [0 x i8]*), i64 8)
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str25 to [0 x i8]*), i64 8)
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str26 to [0 x i8]*), i64 16)
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str27 to [0 x i8]*), i64 16)
	; type Nat256 not implemented
	;printf("sizeof(Nat256) = %llu\n", Nat64 sizeof(Nat256))
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str28 to [0 x i8]*), i64 1)
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str29 to [0 x i8]*), i64 1)
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str30 to [0 x i8]*), i64 2)
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str31 to [0 x i8]*), i64 2)
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str32 to [0 x i8]*), i64 4)
	%46 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str33 to [0 x i8]*), i64 4)
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str34 to [0 x i8]*), i64 8)
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str35 to [0 x i8]*), i64 8)
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str36 to [0 x i8]*), i64 16)
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str37 to [0 x i8]*), i64 16)
	; type Int256 not implemented
	;printf("sizeof(Int256) = %llu\n", Nat64 sizeof(Int256))
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str38 to [0 x i8]*), i64 1)
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str39 to [0 x i8]*), i64 1)
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str40 to [0 x i8]*), i64 2)
	%54 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str41 to [0 x i8]*), i64 2)
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str42 to [0 x i8]*), i64 4)
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str43 to [0 x i8]*), i64 4)
	; pointer size (for example pointer to []Char8)
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str44 to [0 x i8]*), i64 8)
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str45 to [0 x i8]*), i64 8)
	; array size
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str46 to [0 x i8]*), i64 40)
	%60 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str47 to [0 x i8]*), i64 4)
	%61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str48 to [0 x i8]*), i64 4)
	; record size
	%62 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str49 to [0 x i8]*), i64 8)
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str50 to [0 x i8]*), i64 4)
	%64 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str51 to [0 x i8]*), i64 0)
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str52 to [0 x i8]*), i64 4)
	%66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str53 to [0 x i8]*), i64 16)
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str54 to [0 x i8]*), i64 8)
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str55 to [0 x i8]*), i64 40)
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str56 to [0 x i8]*), i64 8)
	%70 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str57 to [0 x i8]*), i64 0)
	%71 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str58 to [0 x i8]*), i64 4)
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str59 to [0 x i8]*), i64 8)
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str60 to [0 x i8]*), i64 16)
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str61 to [0 x i8]*), i64 24)
	%75 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str62 to [0 x i8]*), i64 32)
	%76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str63 to [0 x i8]*), i64 8)
	%77 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str64 to [0 x i8]*), i64 128)
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str65 to [0 x i8]*), i64 8)
	%79 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str66 to [0 x i8]*), i64 0)
	%80 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str67 to [0 x i8]*), i64 40)
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str68 to [0 x i8]*), i64 44)
	%82 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str69 to [0 x i8]*), i64 48)
	%83 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str70 to [0 x i8]*), i64 56)
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str71 to [0 x i8]*), i64 66)
	%85 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str72 to [0 x i8]*), i64 68)
	%86 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str73 to [0 x i8]*), i64 96)
	ret %Int 0
}



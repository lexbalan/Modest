
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

declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %len)

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




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: src/main.cm

@str1 = private constant [19 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 10, i8 0]
@str2 = private constant [23 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str4 = private constant [25 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 49, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [24 x i8] [i8 108, i8 111, i8 99, i8 97, i8 108, i8 65, i8 114, i8 114, i8 97, i8 121, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]



@globalArray0 = global [10 x i32] [
	i32 0,
	i32 1,
	i32 2,
	i32 3,
	i32 4,
	i32 5,
	i32 6,
	i32 7,
	i32 8,
	i32 9
]
@globalArray1 = global [10 x i32] [
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0,
	i32 0
]

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str1 to [0 x i8]*))
	%2 = bitcast [10 x i32]* @globalArray1 to i8*
	%3 = bitcast [10 x i32]* @globalArray0 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %2, i8* %3, i32 40, i1 0)
	%4 = alloca i32
	store i32 0, i32* %4
	br label %again_1
again_1:
	%5 = load i32, i32* %4
	%6 = icmp slt i32 %5, 10
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i32, i32* %4
	%8 = getelementptr inbounds [10 x i32], [10 x i32]* @globalArray1, i32 0, i32 %7
	%9 = load i32, i32* %8
	%10 = load i32, i32* %4
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([23 x i8]* @str2 to [0 x i8]*), i32 %10, i32 %9)
	%12 = load i32, i32* %4
	%13 = add i32 %12, 1
	store i32 %13, i32* %4
	br label %again_1
break_1:
	%14 = bitcast [10 x i32]* @globalArray0 to i8*
	%15 = bitcast [10 x i32]* @globalArray1 to i8*
	
	%16 = call i32 (i8*, i8*, i64) @memcmp( i8* %14, i8* %15, i64 40)
	%17 = icmp eq i32 %16, 0
	br i1 %17 , label %then_0, label %else_0
then_0:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
else_0:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str4 to [0 x i8]*))
	br label %endif_0
endif_0:
	; local
	%20 = alloca [10 x i32]
	%21 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%22 = insertvalue [10 x i32] %21, i32 1, 1
	%23 = insertvalue [10 x i32] %22, i32 2, 2
	%24 = insertvalue [10 x i32] %23, i32 3, 3
	%25 = insertvalue [10 x i32] %24, i32 4, 4
	%26 = insertvalue [10 x i32] %25, i32 5, 5
	%27 = insertvalue [10 x i32] %26, i32 6, 6
	%28 = insertvalue [10 x i32] %27, i32 7, 7
	%29 = insertvalue [10 x i32] %28, i32 8, 8
	%30 = insertvalue [10 x i32] %29, i32 9, 9
	store [10 x i32] %30, [10 x i32]* %20
	%31 = alloca [10 x i32]
	%32 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%33 = insertvalue [10 x i32] %32, i32 0, 1
	%34 = insertvalue [10 x i32] %33, i32 0, 2
	%35 = insertvalue [10 x i32] %34, i32 0, 3
	%36 = insertvalue [10 x i32] %35, i32 0, 4
	%37 = insertvalue [10 x i32] %36, i32 0, 5
	%38 = insertvalue [10 x i32] %37, i32 0, 6
	%39 = insertvalue [10 x i32] %38, i32 0, 7
	%40 = insertvalue [10 x i32] %39, i32 0, 8
	%41 = insertvalue [10 x i32] %40, i32 0, 9
	store [10 x i32] %41, [10 x i32]* %31
	%42 = bitcast [10 x i32]* %31 to i8*
	%43 = bitcast [10 x i32]* %20 to i8*
	call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %42, i8* %43, i32 40, i1 0)
	store i32 0, i32* %4
	br label %again_2
again_2:
	%44 = load i32, i32* %4
	%45 = icmp slt i32 %44, 10
	br i1 %45 , label %body_2, label %break_2
body_2:
	%46 = load i32, i32* %4
	%47 = getelementptr inbounds [10 x i32], [10 x i32]* %31, i32 0, i32 %46
	%48 = load i32, i32* %47
	%49 = load i32, i32* %4
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str5 to [0 x i8]*), i32 %49, i32 %48)
	%51 = load i32, i32* %4
	%52 = add i32 %51, 1
	store i32 %52, i32* %4
	br label %again_2
break_2:
	%53 = bitcast [10 x i32]* %20 to i8*
	%54 = bitcast [10 x i32]* %31 to i8*
	
	%55 = call i32 (i8*, i8*, i64) @memcmp( i8* %53, i8* %54, i64 40)
	%56 = icmp eq i32 %55, 0
	br i1 %56 , label %then_1, label %else_1
then_1:
	%57 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str6 to [0 x i8]*))
	br label %endif_1
else_1:
	%58 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str7 to [0 x i8]*))
	br label %endif_1
endif_1:
	ret %Int 0
}



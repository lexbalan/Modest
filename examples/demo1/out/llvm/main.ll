
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


declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, ...)


declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, ...)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, ...)
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

@str1 = private constant [37 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 101, i8 100, i8 32, i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 40, i8 37, i8 105, i8 41, i8 32, i8 105, i8 115, i8 32, i8 108, i8 101, i8 115, i8 115, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 10, i8 0]
@str2 = private constant [40 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 101, i8 100, i8 32, i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 40, i8 37, i8 105, i8 41, i8 32, i8 105, i8 115, i8 32, i8 103, i8 114, i8 101, i8 97, i8 116, i8 101, i8 114, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 10, i8 0]
@str3 = private constant [38 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 101, i8 100, i8 32, i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 40, i8 37, i8 105, i8 41, i8 32, i8 105, i8 115, i8 32, i8 101, i8 113, i8 117, i8 97, i8 108, i8 32, i8 119, i8 105, i8 116, i8 104, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [28 x i8] [i8 101, i8 110, i8 116, i8 101, i8 114, i8 32, i8 97, i8 32, i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 40, i8 37, i8 105, i8 32, i8 46, i8 46, i8 32, i8 37, i8 105, i8 41, i8 58, i8 32, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str6 = private constant [43 x i8] [i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 103, i8 114, i8 101, i8 97, i8 116, i8 101, i8 114, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 44, i8 32, i8 116, i8 114, i8 121, i8 32, i8 97, i8 103, i8 97, i8 105, i8 110, i8 10, i8 0]
@str7 = private constant [40 x i8] [i8 110, i8 117, i8 109, i8 98, i8 101, i8 114, i8 32, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 108, i8 101, i8 115, i8 115, i8 32, i8 116, i8 104, i8 97, i8 110, i8 32, i8 37, i8 105, i8 44, i8 32, i8 116, i8 114, i8 121, i8 32, i8 97, i8 103, i8 97, i8 105, i8 110, i8 10, i8 0]




define i32 @main() {
	%1 = call i32 @get_number(i32 0, i32 10)
	%2 = icmp slt i32 %1, 5
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str1 to [0 x i8]*), i32 %1, i32 5)
	br label %endif_0
else_0:
	%4 = icmp sgt i32 %1, 5
	br i1 %4 , label %then_1, label %else_1
then_1:
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @str2 to [0 x i8]*), i32 %1, i32 5)
	br label %endif_1
else_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str3 to [0 x i8]*), i32 %1, i32 5)
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret i32 0
}

define i32 @get_number(i32 %min, i32 %max) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str4 to [0 x i8]*), i32 %min, i32 %max)
	%3 = call %Int (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), i32* %1)
	%4 = load i32, i32* %1
	%5 = icmp slt i32 %4, %min
	br i1 %5 , label %then_0, label %else_0
then_0:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([43 x i8]* @str6 to [0 x i8]*), i32 %min)
	br label %again_1
	br label %endif_0
else_0:
	%8 = load i32, i32* %1
	%9 = icmp sgt i32 %8, %max
	br i1 %9 , label %then_1, label %else_1
then_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([40 x i8]* @str7 to [0 x i8]*), i32 %max)
	br label %again_1
	br label %endif_1
else_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%13 = load i32, i32* %1
	ret i32 %13
}



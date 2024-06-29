
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



%Str = type %Str8;
%Char = type i8;
%ConstChar = type i8;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;
%SizeT = type i64;
%SSizeT = type i64;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/string.hm



declare i8* @memset(i8* %mem, i32 %c, i64 %n)
declare i8* @memcpy(i8* %dst, i8* %src, i64 %len)
declare i8* @memmove(i8* %dst, i8* %src, i64 %n)
declare i32 @memcmp(i8* %p0, i8* %p1, i64 %num)
declare i32 @strncmp([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare i32 @strcmp([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strcpy([0 x i8]* %dst, [0 x i8]* %src)
declare i64 @strlen([0 x i8]* %s)
declare [0 x i8]* @strcat([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strncat([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare [0 x i8]* @strerror(i32 %error)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare i32 @fclose(%File* %f)
declare i32 @feof(%File* %f)
declare i32 @ferror(%File* %f)
declare i32 @fflush(%File* %f)
declare i32 @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %File* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare i32 @fseek(%File* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%File* %f, %FposT* %pos)
declare i64 @ftell(%File* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare i32 @setvbuf(%File* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%File* %stream, %Str* %format, ...)
declare i32 @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare i32 @vprintf(%ConstCharStr* %format, i8* %args)
declare i32 @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare i32 @vsnprintf(%CharStr* %str, i64 %n, %ConstCharStr* %format, i8* %args)
declare i32 @__vsnprintf_chk(%CharStr* %dest, i64 %len, i32 %flags, i64 %dstlen, %ConstCharStr* %format, i8* %arg)
declare i32 @fgetc(%File* %f)
declare i32 @fputc(i32 %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %File* %f)
declare i32 @fputs(%ConstCharStr* %str, %File* %f)
declare i32 @getc(%File* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %File* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %File* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: src/main.cm

@str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 98, i8 105, i8 110, i8 0]
@str2 = private constant [19 x i8] [i8 114, i8 117, i8 110, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str3 = private constant [3 x i8] [i8 119, i8 98, i8 0]
@str4 = private constant [31 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str5 = private constant [3 x i8] [i8 105, i8 100, i8 0]
@str6 = private constant [5 x i8] [i8 100, i8 97, i8 116, i8 97, i8 0]
@str7 = private constant [18 x i8] [i8 114, i8 117, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 95, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str8 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str9 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str10 = private constant [21 x i8] [i8 102, i8 105, i8 108, i8 101, i8 32, i8 34, i8 37, i8 115, i8 34, i8 32, i8 99, i8 111, i8 110, i8 116, i8 97, i8 105, i8 110, i8 115, i8 58, i8 10, i8 0]
@str11 = private constant [16 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 105, i8 100, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str12 = private constant [18 x i8] [i8 99, i8 104, i8 117, i8 110, i8 107, i8 46, i8 100, i8 97, i8 116, i8 97, i8 58, i8 32, i8 34, i8 37, i8 115, i8 34, i8 10, i8 0]
@str13 = private constant [21 x i8] [i8 98, i8 105, i8 110, i8 97, i8 114, i8 121, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]






%Chunk = type {
	[100 x i8], 
	[1024 x i8]
};


define void @write_example() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
	%2 = call %File* @fopen(%Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str4 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	; pointers casting requires -funsafe translator option
	; (see Makefile)
	%7 = getelementptr inbounds %Chunk, %Chunk* %6, i32 0, i32 0
	%8 = bitcast [100 x i8]* %7 to [0 x i8]*
	%9 = call [0 x i8]* @strcpy([0 x i8]* %8, [0 x i8]* bitcast ([3 x i8]* @str5 to [0 x i8]*))
	%10 = getelementptr inbounds %Chunk, %Chunk* %6, i32 0, i32 1
	%11 = bitcast [1024 x i8]* %10 to [0 x i8]*
	%12 = call [0 x i8]* @strcpy([0 x i8]* %11, [0 x i8]* bitcast ([5 x i8]* @str6 to [0 x i8]*))
	; write chunk to file
	%13 = bitcast %Chunk* %6 to i8*
	%14 = call i64 @fwrite(i8* %13, i64 1124, i64 1, %File* %2)
	%15 = call i32 @fclose(%File* %2)
	ret void
}

define void @read_example() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str7 to [0 x i8]*))
	%2 = call %File* @fopen(%Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([3 x i8]* @str8 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	%4 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str9 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	ret void
	br label %endif_0
endif_0:
	%6 = alloca %Chunk, align 1
	%7 = bitcast %Chunk* %6 to i8*
	%8 = call i64 @fread(i8* %7, i64 1124, i64 1, %File* %2)
	%9 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*), %Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*))
	%10 = getelementptr inbounds %Chunk, %Chunk* %6, i32 0, i32 0
	%11 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), [100 x i8]* %10)
	%12 = getelementptr inbounds %Chunk, %Chunk* %6, i32 0, i32 1
	%13 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str12 to [0 x i8]*), [1024 x i8]* %12)
	%14 = call i32 @fclose(%File* %2)
	ret void
}

define i32 @main() {
	%1 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str13 to [0 x i8]*))
	call void @write_example()
	call void @read_example()
	ret i32 0
}



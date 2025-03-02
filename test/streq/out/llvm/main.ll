
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare %Int @vprintf(%ConstCharStr* %format, i8* %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, i8* %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, i8* %arg)
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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [3 x i8] [i8 37, i8 115, i8 0]
@str2 = private constant [2 x i8] [i8 10, i8 0]
@str3 = private constant [5 x i8] [i8 83, i8 69, i8 84, i8 10, i8 0]
@str4 = private constant [5 x i8] [i8 71, i8 69, i8 84, i8 10, i8 0]
@str5 = private constant [21 x i8] [i8 117, i8 110, i8 107, i8 110, i8 111, i8 119, i8 110, i8 32, i8 99, i8 111, i8 109, i8 109, i8 97, i8 110, i8 100, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
; -- endstrings --
@prompt = internal global [32 x %Char8] [
	%Char8 35,
	%Char8 32,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0
]
define %Int32 @main() {
	%1 = alloca [32 x %Char8], align 1
	%2 = mul i8 4, 1
	%3 = mul i8 4, 1
	%4 = bitcast [32 x %Char8]* %1 to %Str8*
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%5 = bitcast [32 x %Char8]* @prompt to %Str8*
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str1 to [0 x i8]*), %Str8* %5)
	%7 = bitcast [32 x %Char8]* %1 to %CharStr*
	%8 = load %File*, %File** @stdin
	%9 = call %CharStr* @fgets(%CharStr* %7, %Int 32, %File* %8)
	; convert first '\n' -> '\0'
	%10 = call %SizeT @strcspn(%Str8* %4, %Str8* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%11 = trunc %SizeT %10 to %Int32
	%12 = getelementptr [32 x %Char8], [32 x %Char8]* %1, %Int32 0, %Int32 %11
	store %Char8 0, %Char8* %12
	%13 = insertvalue %Str8 zeroinitializer, %Char8 101, 0
	%14 = insertvalue %Str8 %13, %Char8 120, 1
	%15 = insertvalue %Str8 %14, %Char8 105, 2
	%16 = insertvalue %Str8 %15, %Char8 116, 3
	%17 = alloca %Str8
	%18 = zext i8 4 to %Int32
	store %Str8 %16, %Str8* %17
	%19 = bitcast %Str8* %4 to i8*
	%20 = bitcast %Str8* %17 to i8*
	%21 = call i1 (i8*, i8*, i64) @memeq(i8* %19, i8* %20, %Int64 4)
	%22 = icmp ne %Bool %21, 0
	br %Bool %22 , label %then_0, label %else_0
then_0:
	br label %break_1
	br label %endif_0
else_0:
	%24 = zext i8 0 to %Int32
	%25 = getelementptr %Str8, %Str8* %4, %Int32 0, %Int32 %24
;
	%26 = bitcast %Char8* %25 to [3 x %Char8]*
	%27 = insertvalue [3 x %Char8] zeroinitializer, %Char8 115, 0
	%28 = insertvalue [3 x %Char8] %27, %Char8 101, 1
	%29 = insertvalue [3 x %Char8] %28, %Char8 116, 2
	%30 = alloca [3 x %Char8]
	%31 = zext i8 3 to %Int32
	store [3 x %Char8] %29, [3 x %Char8]* %30
	%32 = bitcast [3 x %Char8]* %26 to i8*
	%33 = bitcast [3 x %Char8]* %30 to i8*
	%34 = call i1 (i8*, i8*, i64) @memeq(i8* %32, i8* %33, %Int64 3)
	%35 = icmp ne %Bool %34, 0
	br %Bool %35 , label %then_1, label %else_1
then_1:
	%36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*))
	br label %endif_1
else_1:
	%37 = zext i8 0 to %Int32
	%38 = getelementptr %Str8, %Str8* %4, %Int32 0, %Int32 %37
;
	%39 = bitcast %Char8* %38 to [3 x %Char8]*
	%40 = insertvalue [3 x %Char8] zeroinitializer, %Char8 103, 0
	%41 = insertvalue [3 x %Char8] %40, %Char8 101, 1
	%42 = insertvalue [3 x %Char8] %41, %Char8 116, 2
	%43 = alloca [3 x %Char8]
	%44 = zext i8 3 to %Int32
	store [3 x %Char8] %42, [3 x %Char8]* %43
	%45 = bitcast [3 x %Char8]* %39 to i8*
	%46 = bitcast [3 x %Char8]* %43 to i8*
	%47 = call i1 (i8*, i8*, i64) @memeq(i8* %45, i8* %46, %Int64 3)
	%48 = icmp ne %Bool %47, 0
	br %Bool %48 , label %then_2, label %else_2
then_2:
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str4 to [0 x i8]*))
	br label %endif_2
else_2:
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*), %Str8* %4)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	ret %Int32 0
}



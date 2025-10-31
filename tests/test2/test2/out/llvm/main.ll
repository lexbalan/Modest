
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
@str1 = private constant [13 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 0]
@str2 = private constant [7 x i8] [i8 116, i8 101, i8 115, i8 116, i8 50, i8 10, i8 0]
@str3 = private constant [11 x i8] [i8 115, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [11 x i8] [i8 115, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --; test2
@a0 = internal global [4 x %Int32] [
	%Int32 10,
	%Int32 20,
	%Int32 30,
	%Int32 40
]
@a1 = internal global [4 x %Int32] [
	%Int32 10,
	%Int32 20,
	%Int32 30,
	%Int32 40
]
@ss = internal global [12 x %Char8] [
	%Char8 72,
	%Char8 101,
	%Char8 108,
	%Char8 108,
	%Char8 111,
	%Char8 32,
	%Char8 87,
	%Char8 111,
	%Char8 114,
	%Char8 108,
	%Char8 100,
	%Char8 33
]
@s = internal global %Str8* bitcast ([13 x i8]* @str1 to [0 x i8]*)
%Point = type {
	%Int32,
	%Int32
};

@points = internal global [2 x %Point] [
	%Point {
		%Int32 0,
		%Int32 0
	},
	%Point {
		%Int32 1,
		%Int32 1
	}
]
define internal void @swap([2 x %Int32]* %0, [2 x %Int32] %__a) {
	%a = alloca [2 x %Int32]
	%2 = zext i8 2 to %Nat32
	store [2 x %Int32] %__a, [2 x %Int32]* %a
	%3 = getelementptr [2 x %Int32], [2 x %Int32]* %a, %Int32 0, %Int32 1
	%4 = load %Int32, %Int32* %3
	%5 = getelementptr [2 x %Int32], [2 x %Int32]* %a, %Int32 0, %Int32 0
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr [2 x %Int32], [2 x %Int32]* %a, %Int32 0, %Int32 1
	%8 = load %Int32, %Int32* %7
	%9 = insertvalue [2 x %Int32] zeroinitializer, %Int32 %8, 0
	%10 = getelementptr [2 x %Int32], [2 x %Int32]* %a, %Int32 0, %Int32 0
	%11 = load %Int32, %Int32* %10
	%12 = insertvalue [2 x %Int32] %9, %Int32 %11, 1
; -- cons_composite_from_composite_by_value --
	%13 = alloca [2 x %Int32]
	%14 = zext i8 2 to %Nat32
	store [2 x %Int32] %12, [2 x %Int32]* %13
	%15 = bitcast [2 x %Int32]* %13 to [2 x %Int32]*
; -- end cons_composite_from_composite_by_value --
	%16 = load [2 x %Int32], [2 x %Int32]* %15
	%17 = zext i8 2 to %Nat32
	store [2 x %Int32] %16, [2 x %Int32]* %0
	ret void
}

define internal void @sstr([3 x %Char16] %__s) {
	%s = alloca [3 x %Char16]
	%1 = zext i8 3 to %Nat32
	store [3 x %Char16] %__s, [3 x %Char16]* %s
	;
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str2 to [0 x i8]*))
	%2 = alloca %Int32, align 4
	store %Int32 10, %Int32* %2
	%3 = alloca [5 x %Int32], align 1
	%4 = load %Int32, %Int32* %2
	%5 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%6 = insertvalue [5 x %Int32] %5, %Int32 20, 1
	%7 = insertvalue [5 x %Int32] %6, %Int32 30, 2
	%8 = insertvalue [5 x %Int32] %7, %Int32 40, 3
	%9 = load %Int32, %Int32* %2
	%10 = insertvalue [5 x %Int32] %8, %Int32 %9, 4
; -- cons_composite_from_composite_by_value --
	%11 = alloca [5 x %Int32]
	%12 = zext i8 5 to %Nat32
	store [5 x %Int32] %10, [5 x %Int32]* %11
	%13 = bitcast [5 x %Int32]* %11 to [5 x %Int32]*
; -- end cons_composite_from_composite_by_value --
	%14 = load [5 x %Int32], [5 x %Int32]* %13
	%15 = zext i8 5 to %Nat32
	store [5 x %Int32] %14, [5 x %Int32]* %3
	%16 = alloca [5 x %Int32], align 1
	%17 = load %Int32, %Int32* %2
	%18 = insertvalue [5 x %Int32] zeroinitializer, %Int32 10, 0
	%19 = insertvalue [5 x %Int32] %18, %Int32 20, 1
	%20 = insertvalue [5 x %Int32] %19, %Int32 30, 2
	%21 = insertvalue [5 x %Int32] %20, %Int32 40, 3
	%22 = load %Int32, %Int32* %2
	%23 = insertvalue [5 x %Int32] %21, %Int32 %22, 4
; -- cons_composite_from_composite_by_value --
	%24 = alloca [5 x %Int32]
	%25 = zext i8 5 to %Nat32
	store [5 x %Int32] %23, [5 x %Int32]* %24
	%26 = bitcast [5 x %Int32]* %24 to [5 x %Int32]*
; -- end cons_composite_from_composite_by_value --
	%27 = load [5 x %Int32], [5 x %Int32]* %26
	%28 = zext i8 5 to %Nat32
	store [5 x %Int32] %27, [5 x %Int32]* %16
	%29 = insertvalue [2 x %Int32] zeroinitializer, %Int32 1, 0
	%30 = insertvalue [2 x %Int32] %29, %Int32 2, 1; alloca memory for return value
	%31 = alloca [2 x %Int32]
	call void @swap([2 x %Int32]* %31, [2 x %Int32] %30)
	%32 = getelementptr [2 x %Int32], [2 x %Int32]* %31, %Int32 0, %Int32 0
	%33 = load %Int32, %Int32* %32
	%34 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str3 to [0 x i8]*), %Int32 %33)
	%35 = getelementptr [2 x %Int32], [2 x %Int32]* %31, %Int32 0, %Int32 1
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str4 to [0 x i8]*), %Int32 %36)
	%38 = insertvalue [3 x %Char16] zeroinitializer, %Char16 65, 0
	%39 = insertvalue [3 x %Char16] %38, %Char16 66, 1
	%40 = insertvalue [3 x %Char16] %39, %Char16 67, 2
	call void @sstr([3 x %Char16] %40)
	ret %Int32 0
}




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
declare i8* @malloc(i32)
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
%PtrDiffT = type %Int64;
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
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; -- end print includes --
; -- print imports 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports 'main' --
; -- strings --
@.str1 = private constant [12 x i8] [i8 112, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@.str2 = private constant [12 x i8] [i8 112, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 117, i8 10, i8 0]
@.str3 = private constant [2 x i8] [i8 65, i8 0]
@.str4 = private constant [2 x i16] [i16 65, i16 0]
@.str5 = private constant [2 x i32] [i32 65, i32 0]
@.str6 = private constant [2 x i8] [i8 66, i8 0]
@.str7 = private constant [2 x i16] [i16 66, i16 0]
@.str8 = private constant [2 x i32] [i32 66, i32 0]
@.str9 = private constant [10 x i8] [i8 119, i8 32, i8 61, i8 32, i8 37, i8 108, i8 108, i8 120, i8 10, i8 0]
@.str10 = private constant [9 x i8] [i8 120, i8 50, i8 32, i8 61, i8 32, i8 37, i8 120, i8 10, i8 0]
@.str11 = private constant [14 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 10, i8 0]
; -- endstrings --
%MyInt = type %Int32;
%Point = type {
	%Word64,
	%Word64
};

@points = internal global [3 x %Point] [
	%Point {
		%Word64 0,
		%Word64 10
	},
	%Point {
		%Word64 10,
		%Word64 20
	},
	%Point {
		%Word64 30,
		%Word64 40
	}
]
@arrays = internal global [4 x [4 x %Int32]] [
	[4 x %Int32] [
		%Int32 0,
		%Int32 1,
		%Int32 2,
		%Int32 3
	],
	[4 x %Int32] [
		%Int32 4,
		%Int32 5,
		%Int32 6,
		%Int32 7
	],
	[4 x %Int32] [
		%Int32 8,
		%Int32 9,
		%Int32 10,
		%Int32 11
	],
	[4 x %Int32] [
		%Int32 12,
		%Int32 13,
		%Int32 14,
		%Int32 15
	]
]
%OpenPoint = type {
	%Word64,
	%Word64
};

%ListHeader = type {
	%ListHeader*,
	%ListHeader*
};

define internal void @foo(%Int32 %a, %Int64 %b) {
	%1 = alloca %ListHeader, align 8
	%2 = getelementptr %ListHeader, %ListHeader* %1, %Int32 0, %Int32 0
	%3 = load %ListHeader*, %ListHeader** %2
	%4 = getelementptr %ListHeader, %ListHeader* %3, %Int32 0, %Int32 0
	ret void
	ret void
}

%String8 = type {
	%Nat64,
	[0 x %Char8]*
};

define internal %String8 @createString8([0 x %Char8]* %cstr) {
	%1 = call %SizeT @strlen([0 x %Char8]* %cstr)
	%2 = insertvalue %String8 zeroinitializer, %SizeT %1, 0
	%3 = insertvalue %String8 %2, [0 x %Char8]* %cstr, 1
	ret %String8 %3
}

@k = internal global [3 x %Word32] [
	%Word32 1,
	%Word32 2,
	%Word32 3
]
@p0 = internal global %Point {
	%Word64 1,
	%Word64 2
}
define internal void @farr([3 x %Int32]* %0, [3 x %Int32] %__x) {
	%x = alloca [3 x %Int32]
	%2 = zext i8 3 to %Nat32
	store [3 x %Int32] %__x, [3 x %Int32]* %x
	%3 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 0
	%4 = load %Int32, %Int32* %3
	%5 = add %Int32 %4, 1
	%6 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 1
	%7 = load %Int32, %Int32* %6
	%8 = add %Int32 %7, 2
	%9 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 2
	%10 = load %Int32, %Int32* %9
	%11 = add %Int32 %10, 3
	%12 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 0
	%13 = load %Int32, %Int32* %12
	%14 = add %Int32 %13, 1
	%15 = insertvalue [3 x %Int32] zeroinitializer, %Int32 %14, 0
	%16 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 1
	%17 = load %Int32, %Int32* %16
	%18 = add %Int32 %17, 2
	%19 = insertvalue [3 x %Int32] %15, %Int32 %18, 1
	%20 = getelementptr [3 x %Int32], [3 x %Int32]* %x, %Int32 0, %Int32 2
	%21 = load %Int32, %Int32* %20
	%22 = add %Int32 %21, 3
	%23 = insertvalue [3 x %Int32] %19, %Int32 %22, 2
	%24 = zext i8 3 to %Nat32
	store [3 x %Int32] %23, [3 x %Int32]* %0
	ret void
}

%main.LocalInt = type %Int32;
define %Int @main(%Int %argc, [0 x [0 x %Char8]*]* %argv) {
	%1 = call %Point* @malloc(%Int32 16)
	%2 = zext i8 10 to %Word64
	%3 = insertvalue %Point zeroinitializer, %Word64 %2, 0
	%4 = zext i8 10 to %Word64
	%5 = insertvalue %Point %3, %Word64 %4, 1
	store %Point %5, %Point* %1
	%6 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 0
	%7 = load %Word64, %Word64* %6
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str1 to [0 x i8]*), %Word64 %7)
	%9 = getelementptr %Point, %Point* %1, %Int32 0, %Int32 1
	%10 = load %Word64, %Word64* %9
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @.str2 to [0 x i8]*), %Word64 %10)
	%12 = insertvalue [1 x %Char8] zeroinitializer, %Char8 65, 0
	%13 = alloca [1 x %Char8]
	%14 = zext i8 1 to %Nat32
	store [1 x %Char8] %12, [1 x %Char8]* %13
	%15 = insertvalue [1 x %Char16] zeroinitializer, %Char16 65, 0
	%16 = alloca [1 x %Char16]
	%17 = zext i8 1 to %Nat32
	store [1 x %Char16] %15, [1 x %Char16]* %16
	%18 = insertvalue [1 x %Char32] zeroinitializer, %Char32 65, 0
	%19 = alloca [1 x %Char32]
	%20 = zext i8 1 to %Nat32
	store [1 x %Char32] %18, [1 x %Char32]* %19
	%21 = alloca %main.LocalInt, align 4
	store %main.LocalInt 10, %main.LocalInt* %21
	%22 = alloca %Char8, align 1
	store %Char8 66, %Char8* %22
	%23 = alloca %Char16, align 2
	store %Char16 66, %Char16* %23
	%24 = alloca %Char32, align 4
	store %Char32 66, %Char32* %24
	%25 = alloca [1 x %Char8], align 1
	%26 = insertvalue [1 x %Char8] zeroinitializer, %Char8 66, 0
	%27 = zext i8 1 to %Nat32
	store [1 x %Char8] %26, [1 x %Char8]* %25
	%28 = alloca [1 x %Char16], align 2
	%29 = insertvalue [1 x %Char16] zeroinitializer, %Char16 66, 0
	%30 = zext i8 1 to %Nat32
	store [1 x %Char16] %29, [1 x %Char16]* %28
	%31 = alloca [1 x %Char32], align 4
	%32 = insertvalue [1 x %Char32] zeroinitializer, %Char32 66, 0
	%33 = zext i8 1 to %Nat32
	store [1 x %Char32] %32, [1 x %Char32]* %31
	%34 = alloca %Str8*, align 8
	store %Str8* bitcast ([2 x i8]* @.str6 to [0 x i8]*), %Str8** %34
	%35 = alloca %Str16*, align 8
	store %Str16* bitcast ([2 x i16]* @.str7 to [0 x i16]*), %Str16** %35
	%36 = alloca %Str32*, align 8
	store %Str32* bitcast ([2 x i32]* @.str8 to [0 x i32]*), %Str32** %36
	%37 = alloca %Word64, align 8
	store %Word64 9223372036854775808, %Word64* %37
	%38 = load %Word64, %Word64* %37
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @.str9 to [0 x i8]*), %Word64 %38)
	%40 = alloca %Int16, align 2
	store %Int16 -1, %Int16* %40
	%41 = alloca %Word32, align 4
	%42 = load %Int16, %Int16* %40
	%43 = zext %Int16 %42 to %Word32
	store %Word32 %43, %Word32* %41
	%44 = load %Word32, %Word32* %41
	%45 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @.str10 to [0 x i8]*), %Word32 %44)
; if_0
	%46 = zext i16 65535 to %Word32
	%47 = load %Word32, %Word32* %41
	%48 = icmp ne %Word32 %47, %46
	br %Bool %48 , label %then_0, label %endif_0
then_0:
	br label %endif_0
endif_0:
	%49 = alloca [3 x %Int32], align 4
	%50 = insertvalue [3 x %Int32] zeroinitializer, %Int32 1, 0
	%51 = insertvalue [3 x %Int32] %50, %Int32 2, 1
	%52 = insertvalue [3 x %Int32] %51, %Int32 3, 2
	%53 = zext i8 3 to %Nat32
	store [3 x %Int32] %52, [3 x %Int32]* %49
	%54 = alloca [3 x %Int32], align 4
	%55 = load [3 x %Int32], [3 x %Int32]* %49
	%56 = zext i8 3 to %Nat32
	store [3 x %Int32] %55, [3 x %Int32]* %54
	%57 = load [3 x %Int32], [3 x %Int32]* %49
	%58 = alloca [3 x %Int32]
	%59 = zext i8 3 to %Nat32
	store [3 x %Int32] %57, [3 x %Int32]* %58
	%60 = alloca [3 x %Int32], align 4
	%61 = load [3 x %Int32], [3 x %Int32]* %49; alloca memory for return value
	%62 = alloca [3 x %Int32]
	call void @farr([3 x %Int32]* %62, [3 x %Int32] %61)
	%63 = load [3 x %Int32], [3 x %Int32]* %62
	%64 = zext i8 3 to %Nat32
	store [3 x %Int32] %63, [3 x %Int32]* %54
	%65 = zext i8 3 to %Nat32
	%66 = mul %Nat32 %65, 4
	%67 = bitcast [3 x %Int32]* %54 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %67, i8 0, %Nat32 %66, i1 0)
	%68 = load [3 x %Int32], [3 x %Int32]* %49
	%69 = zext i8 3 to %Nat32
	store [3 x %Int32] %68, [3 x %Int32]* %54
	%70 = alloca {i8,i8}
	store {i8,i8} zeroinitializer, {i8,i8}* %70
	%71 = alloca %Point, align 8
	store %Point zeroinitializer, %Point* %71
	%72 = alloca %Point, align 8
	store %Point zeroinitializer, %Point* %72
	%73 = load %Point, %Point* %71
	store %Point %73, %Point* %72
	%74 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str11 to [0 x i8]*))
	%75 = alloca %Int32, align 4
	store %Int32 0, %Int32* %75
	%76 = alloca %Int64, align 8
	store %Int64 1, %Int64* %76
	%77 = load %Int32, %Int32* %75
	%78 = add %Int32 %77, 2
	%79 = load %Int32, %Int32* %75
	%80 = sub %Int32 %79, 2
	%81 = load %Int32, %Int32* %75
	%82 = mul %Int32 %81, 2
	%83 = load %Int32, %Int32* %75
	%84 = sdiv %Int32 %83, 2
	%85 = load %Int32, %Int32* %75
	%86 = srem %Int32 %85, 2
	call void @foo(%Int32 1, %Int64 2)
	%87 = load %Int32, %Int32* %75
	%88 = add %Int32 %87, 1
	%89 = load %Int64, %Int64* %76
	%90 = sub %Int64 %89, 15
	call void @foo(%Int32 %88, %Int64 %90)
	%91 = alloca %Nat32, align 4
	%92 = load %Int32, %Int32* %75
	%93 = bitcast %Int32 %92 to %Nat32
	store %Nat32 %93, %Nat32* %91
	%94 = alloca %Nat64, align 8
	%95 = load %Int64, %Int64* %76
	%96 = bitcast %Int64 %95 to %Nat64
	store %Nat64 %96, %Nat64* %94
	%97 = load %Int32, %Int32* %75
	%98 = load %Int32, %Int32* %75
	%99 = mul %Int32 %97, %98
	%100 = load %Int32, %Int32* %75
	%101 = add %Int32 %99, %100
	%102 = getelementptr [3 x %Int32], [3 x %Int32]* %49, %Int32 0, %Int32 1
	%103 = alloca %Point, align 8
	store %Point zeroinitializer, %Point* %103
	%104 = getelementptr %Point, %Point* %103, %Int32 0, %Int32 0
	%105 = getelementptr %Point, %Point* %103, %Int32 0, %Int32 1
; if_1
	%106 = load %Int32, %Int32* %75
	%107 = icmp slt %Int32 %106, 1
	%108 = load %Int64, %Int64* %76
	%109 = icmp sgt %Int64 %108, 12
	%110 = and %Bool %107, %109
	%111 = or %Bool %110, 0
	br %Bool %111 , label %then_1, label %endif_1
then_1:
	%112 = alloca %Word32, align 4
	%113 = zext i8 10 to %Word32
	store %Word32 %113, %Word32* %112
	%114 = alloca %Word32, align 4
	%115 = zext i8 20 to %Word32
	store %Word32 %115, %Word32* %114
	%116 = load %Word32, %Word32* %114
	%117 = xor %Word32 %116, -1
	%118 = load %Word32, %Word32* %112
	%119 = and %Word32 %118, %117
	%120 = load %Word32, %Word32* %114
	%121 = and %Word32 %120, %119
	%122 = load %Word32, %Word32* %114
	%123 = or %Word32 %121, %122
	%124 = load %Word32, %Word32* %112
	%125 = or %Word32 %124, %123
	%126 = load %Word32, %Word32* %114
	%127 = load %Word32, %Word32* %112
	%128 = and %Word32 %126, %127
	%129 = load %Word32, %Word32* %112
	%130 = or %Word32 %129, %128
	%131 = load %Word32, %Word32* %114
	%132 = xor %Word32 %131, -1
	%133 = load %Word32, %Word32* %114
	%134 = or %Word32 %132, %133
	%135 = icmp ne %Word32 %130, %134
	%136 = load %Word32, %Word32* %112
	%137 = zext i8 10 to %Word32
	%138 = shl %Word32 %136, %137
	%139 = load %Word32, %Word32* %114
	%140 = zext i8 20 to %Word32
	%141 = lshr %Word32 %139, %140
	%142 = load %Int32, %Int32* %75
	%143 = sext %Int32 %142 to %Int64
	%144 = load %Int64, %Int64* %76
	%145 = add %Int64 %143, %144
	%146 = load %Int32, %Int32* %75
	%147 = load %Int32, %Int32* %75
	%148 = sub %Int32 0, %147
	%149 = load %Int32, %Int32* %75
	%150 = add %Int32 %149, 1
	store %Int32 %150, %Int32* %75
	%151 = load %Int32, %Int32* %75
	%152 = sub %Int32 %151, 1
	store %Int32 %152, %Int32* %75
	br label %endif_1
endif_1:
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	br label %break_1
	br label %again_1
break_1:
; if_2
	br %Bool 1 , label %then_2, label %else_2
then_2:
	br label %endif_2
else_2:
; if_3
	br %Bool 0 , label %then_3, label %else_3
then_3:
	br label %endif_3
else_3:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	%154 = alloca %Float32, align 4
	store %Float32 3.1414999961853027, %Float32* %154
	ret %Int 0
}



;func sum64 (a: Int64, b: Int64) -> Int64 {
;	var sum: Int64
;	__asm("add %0, %1, %2", [["=r", sum]], [["r", a]["r", b]], ["cc"])
;	return sum
;}
define void @main_print(%Str8* %form, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = alloca %__VA_List, align 1
	%3 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %3)
	%4 = bitcast %__VA_List* %2 to i8*
	%5 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_copy(i8* %4, i8* %5)
	%6 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %6)
	ret void
}



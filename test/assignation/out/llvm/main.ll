
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
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [18 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 97, i8 115, i8 115, i8 105, i8 103, i8 110, i8 97, i8 116, i8 105, i8 111, i8 110, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 103, i8 108, i8 98, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str3 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 103, i8 108, i8 98, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [15 x i8] [i8 103, i8 108, i8 98, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str8 = private constant [13 x i8] [i8 108, i8 111, i8 99, i8 95, i8 105, i8 48, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 48, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 49, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [16 x i8] [i8 108, i8 111, i8 99, i8 95, i8 97, i8 48, i8 91, i8 50, i8 93, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str12 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [15 x i8] [i8 108, i8 111, i8 99, i8 95, i8 114, i8 48, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
; -- endstrings --


; Simply record for records assignation test
%Point = type {
	%Int32,
	%Int32
};

@glb_i0 = internal global %Int32 0
@glb_i1 = internal global %Int32 321
@glb_r0 = internal global %Point {
	%Int32 0,
	%Int32 0
}
@glb_r1 = internal global %Point {
	%Int32 20,
	%Int32 10
}
@glb_a0 = internal global [10 x %Int32] zeroinitializer
@glb_a1 = internal global [10 x %Int32] [
	%Int32 64,
	%Int32 53,
	%Int32 42,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0,
	%Int32 0
]
define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([18 x i8]* @str1 to [0 x i8]*))

	; -----------------------------------
	; Global

	; copy integers by value
	%2 = load %Int32, %Int32* @glb_i1
	store %Int32 %2, %Int32* @glb_i0
	%3 = load %Int32, %Int32* @glb_i0
	%4 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), %Int32 %3)


	; copy arrays by value
	%5 = load [10 x %Int32], [10 x %Int32]* @glb_a1
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%6 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %5, [10 x %Int32]* @glb_a0
	%7 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 0
	%8 = load %Int32, %Int32* %7
	%9 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str3 to [0 x i8]*), %Int32 %8)
	%10 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 1
	%11 = load %Int32, %Int32* %10
	%12 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*), %Int32 %11)
	%13 = getelementptr [10 x %Int32], [10 x %Int32]* @glb_a0, %Int32 0, %Int32 2
	%14 = load %Int32, %Int32* %13
	%15 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), %Int32 %14)


	; copy records by value
	%16 = load %Point, %Point* @glb_r1
	store %Point %16, %Point* @glb_r0
	%17 = getelementptr %Point, %Point* @glb_r0, %Int32 0, %Int32 0
	%18 = load %Int32, %Int32* %17
	%19 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), %Int32 %18)
	%20 = getelementptr %Point, %Point* @glb_r0, %Int32 0, %Int32 1
	%21 = load %Int32, %Int32* %20
	%22 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str7 to [0 x i8]*), %Int32 %21)


	; -----------------------------------
	; Local

	; copy integers by value
	%23 = alloca %Int32, align 4
	store %Int32 0, %Int32* %23
	%24 = alloca %Int32, align 4
	store %Int32 123, %Int32* %24
	%25 = load %Int32, %Int32* %24
	store %Int32 %25, %Int32* %23
	%26 = load %Int32, %Int32* %23
	%27 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), %Int32 %26)

	; copy arrays by value
	; C backend will be use memcpy()
	%28 = alloca [10 x %Int32], align 1
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%29 = zext i8 10 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%30 = mul %Int32 %29, 4
	%31 = bitcast [10 x %Int32]* %28 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %31, i8 0, %Int32 %30, i1 0)
	%32 = alloca [10 x %Int32], align 1
	%33 = insertvalue [10 x %Int32] zeroinitializer, %Int32 42, 0
	%34 = insertvalue [10 x %Int32] %33, %Int32 53, 1
	%35 = insertvalue [10 x %Int32] %34, %Int32 64, 2
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%36 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %35, [10 x %Int32]* %32
	%37 = load [10 x %Int32], [10 x %Int32]* %32
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	%38 = zext i8 10 to %Int32
	; -- end vol eval --
	store [10 x %Int32] %37, [10 x %Int32]* %28
	%39 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 0
	%40 = load %Int32, %Int32* %39
	%41 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str9 to [0 x i8]*), %Int32 %40)
	%42 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 1
	%43 = load %Int32, %Int32* %42
	%44 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str10 to [0 x i8]*), %Int32 %43)
	%45 = getelementptr [10 x %Int32], [10 x %Int32]* %28, %Int32 0, %Int32 2
	%46 = load %Int32, %Int32* %45
	%47 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([16 x i8]* @str11 to [0 x i8]*), %Int32 %46)


	; copy records by value
	; C backend will be use memcpy()
	%48 = alloca %Point, align 8
	store %Point zeroinitializer, %Point* %48
	%49 = alloca %Point, align 8
	%50 = insertvalue %Point zeroinitializer, %Int32 10, 0
	%51 = insertvalue %Point %50, %Int32 20, 1
	store %Point %51, %Point* %49
	%52 = load %Point, %Point* %49
	store %Point %52, %Point* %48
	%53 = getelementptr %Point, %Point* %48, %Int32 0, %Int32 0
	%54 = load %Int32, %Int32* %53
	%55 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), %Int32 %54)
	%56 = getelementptr %Point, %Point* %48, %Int32 0, %Int32 1
	%57 = load %Int32, %Int32* %56
	%58 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([15 x i8]* @str13 to [0 x i8]*), %Int32 %57)


	; error: closed arrays of closed arrays are denied
;let dim1 = 15
;	let dim2 = 16
;
;	var aa: [dim1][dim2]Int32
;
;	var i = 0
;	while i < 16 {
;		var j = 0
;		while j < 16 {
;			aa[i][j] = i * j
;			j = j + 1
;		}
;		i = i + 1
;	}
;
;	i = 0
;	while i < 16 {
;		var k = 0
;		while k < 16 {
;			printf("aa[%i][%i] = %i\n", i, k, aa[i][k])
;			k = k + 1
;		}
;		i = i + 1
;	}
;
;
;	let xa = aa[3]
;
;	i = 0
;	while i < dim2 {
;		printf("xa[%i] = %i\n", i, xa[i])
;		i = i + 1
;	}
	ret %ctypes64_Int 0
}



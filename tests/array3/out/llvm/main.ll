
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
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [8 x i8] [i8 116, i8 101, i8 115, i8 116, i8 48, i8 58, i8 10, i8 0]
@str2 = private constant [16 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 97, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [20 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 116, i8 101, i8 115, i8 116, i8 49, i8 58, i8 10, i8 0]
@str5 = private constant [18 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [19 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [22 x i8] [i8 112, i8 97, i8 50, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [8 x i8] [i8 116, i8 101, i8 115, i8 116, i8 50, i8 58, i8 10, i8 0]
@str9 = private constant [18 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [19 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [30 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 91, i8 109, i8 93, i8 91, i8 110, i8 93, i8 42, i8 91, i8 112, i8 93, i8 73, i8 110, i8 116, i8 51, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [22 x i8] [i8 112, i8 97, i8 50, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [20 x i8] [i8 120, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 32, i8 0]
@str14 = private constant [4 x i8] [i8 79, i8 75, i8 10, i8 0]
@str15 = private constant [7 x i8] [i8 69, i8 82, i8 82, i8 79, i8 82, i8 10, i8 0]
; -- endstrings --
@a = internal global [3 x [3 x [3 x %Int32]]] [
	[3 x [3 x %Int32]] [
		[3 x %Int32] [
			%Int32 1,
			%Int32 2,
			%Int32 3
		],
		[3 x %Int32] [
			%Int32 4,
			%Int32 5,
			%Int32 6
		],
		[3 x %Int32] [
			%Int32 7,
			%Int32 8,
			%Int32 9
		]
	],
	[3 x [3 x %Int32]] [
		[3 x %Int32] [
			%Int32 11,
			%Int32 12,
			%Int32 13
		],
		[3 x %Int32] [
			%Int32 14,
			%Int32 15,
			%Int32 16
		],
		[3 x %Int32] [
			%Int32 17,
			%Int32 18,
			%Int32 19
		]
	],
	[3 x [3 x %Int32]] [
		[3 x %Int32] [
			%Int32 21,
			%Int32 22,
			%Int32 23
		],
		[3 x %Int32] [
			%Int32 24,
			%Int32 25,
			%Int32 26
		],
		[3 x %Int32] [
			%Int32 27,
			%Int32 28,
			%Int32 29
		]
	]
]
@b = internal global [3 x [3 x [3 x %Int32]*]] [
	[3 x [3 x %Int32]*] [
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 0, %Int32 0),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 0, %Int32 1),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 0, %Int32 2)
	],
	[3 x [3 x %Int32]*] [
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 1, %Int32 0),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 1, %Int32 1),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 1, %Int32 2)
	],
	[3 x [3 x %Int32]*] [
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 2, %Int32 0),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 2, %Int32 1),
		[3 x %Int32]* getelementptr ([3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 2, %Int32 2)
	]
]
define internal void @test0() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*))
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str2 to [0 x i8]*), %Int32 108)
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %3
	%5 = icmp slt %Int32 %4, 3
	br %Bool %5 , label %body_1, label %break_1
body_1:
	%6 = alloca %Int32, align 4
	store %Int32 0, %Int32* %6
	br label %again_2
again_2:
	%7 = load %Int32, %Int32* %6
	%8 = icmp slt %Int32 %7, 3
	br %Bool %8 , label %body_2, label %break_2
body_2:
	%9 = alloca %Int32, align 4
	store %Int32 0, %Int32* %9
	br label %again_3
again_3:
	%10 = load %Int32, %Int32* %9
	%11 = icmp slt %Int32 %10, 3
	br %Bool %11 , label %body_3, label %break_3
body_3:
	%12 = load %Int32, %Int32* %9
	%13 = load %Int32, %Int32* %6
	%14 = load %Int32, %Int32* %3
	%15 = getelementptr [3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 %14, %Int32 %13, %Int32 %12
	%16 = load %Int32, %Int32* %15
	%17 = load %Int32, %Int32* %3
	%18 = load %Int32, %Int32* %6
	%19 = load %Int32, %Int32* %9
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str3 to [0 x i8]*), %Int32 %17, %Int32 %18, %Int32 %19, %Int32 %16)
	%21 = load %Int32, %Int32* %9
	%22 = add %Int32 %21, 1
	store %Int32 %22, %Int32* %9
	br label %again_3
break_3:
	%23 = load %Int32, %Int32* %6
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %6
	br label %again_2
break_2:
	%25 = load %Int32, %Int32* %3
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %3
	br label %again_1
break_1:
	ret void
}

define internal void @test1([0 x [0 x [0 x %Int32]]]* %pa, %Int32 %m, %Int32 %n, %Int32 %p) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*))
	%4 = mul %Int32 %p, 1  ; calc VLA item size
	%5 = mul %Int32 %n, %4  ; calc VLA item size
	%6 = mul %Int32 %m, %5  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%7 = bitcast [0 x [0 x [0 x %Int32]]]* %pa to [0 x [0 x [0 x %Int32]]]*
	%8 = mul %Int32 %p, 1  ; calc VLA item size
	%9 = mul %Int32 %n, %8  ; calc VLA item size
	%10 = mul %Int32 %m, %9  ; calc VLA item size

	;var local = *pa2
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str5 to [0 x i8]*), %Int32 8)
	%12 = mul %Int32 %p, 1  ; calc VLA item size
	%13 = mul %Int32 %n, %12  ; calc VLA item size
	%14 = mul %Int32 %m, %13  ; calc VLA item size
	%15 = mul %Int32 %14, 4
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str6 to [0 x i8]*), %Int32 %15)
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_1
again_1:
	%18 = load %Int32, %Int32* %17
	%19 = icmp slt %Int32 %18, %m
	br %Bool %19 , label %body_1, label %break_1
body_1:
	%20 = alloca %Int32, align 4
	store %Int32 0, %Int32* %20
	br label %again_2
again_2:
	%21 = load %Int32, %Int32* %20
	%22 = icmp slt %Int32 %21, %n
	br %Bool %22 , label %body_2, label %break_2
body_2:
	%23 = alloca %Int32, align 4
	store %Int32 0, %Int32* %23
	br label %again_3
again_3:
	%24 = load %Int32, %Int32* %23
	%25 = icmp slt %Int32 %24, %p
	br %Bool %25 , label %body_3, label %break_3
body_3:
	%26 = load %Int32, %Int32* %23
	%27 = load %Int32, %Int32* %20
	%28 = load %Int32, %Int32* %17
; -- INDEX VLA --
	%29 = mul %Int32 %28, %13
	%30 = add %Int32 0, %29
	%31 = mul %Int32 %27, %12
	%32 = add %Int32 %30, %31
	%33 = mul %Int32 %26, 1
	%34 = add %Int32 %32, %33
	%35 = getelementptr %Int32, [0 x [0 x [0 x %Int32]]]* %7, %Int32 %34
; -- END INDEX VLA --
	%36 = load %Int32, %Int32* %35
	%37 = load %Int32, %Int32* %17
	%38 = load %Int32, %Int32* %20
	%39 = load %Int32, %Int32* %23
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str7 to [0 x i8]*), %Int32 %37, %Int32 %38, %Int32 %39, %Int32 %36)
	%41 = load %Int32, %Int32* %23
	%42 = add %Int32 %41, 1
	store %Int32 %42, %Int32* %23
	br label %again_3
break_3:
	%43 = load %Int32, %Int32* %20
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %20
	br label %again_2
break_2:
	%45 = load %Int32, %Int32* %17
	%46 = add %Int32 %45, 1
	store %Int32 %46, %Int32* %17
	br label %again_1
break_1:
	%47 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %47)
	ret void
}

define internal void @test2([0 x [0 x [0 x %Int32]*]]* %pb, %Int32 %m, %Int32 %n, %Int32 %p) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str8 to [0 x i8]*))
	%4 = mul %Int32 %p, 1  ; calc VLA item size
	%5 = mul %Int32 %n, 1  ; calc VLA item size
	%6 = mul %Int32 %m, %5  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%7 = bitcast [0 x [0 x [0 x %Int32]*]]* %pb to [0 x [0 x [0 x %Int32]*]]*
	%8 = mul %Int32 %p, 1  ; calc VLA item size
	%9 = mul %Int32 %n, 1  ; calc VLA item size
	%10 = mul %Int32 %m, %9  ; calc VLA item size
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str9 to [0 x i8]*), %Int32 8)
	%12 = mul %Int32 %p, 1  ; calc VLA item size
	%13 = mul %Int32 %n, 1  ; calc VLA item size
	%14 = mul %Int32 %m, %13  ; calc VLA item size
	%15 = mul %Int32 %14, 8
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str10 to [0 x i8]*), %Int32 %15)
	%17 = mul %Int32 %p, 1  ; calc VLA item size
	%18 = mul %Int32 %n, 1  ; calc VLA item size
	%19 = mul %Int32 %m, %18  ; calc VLA item size
	%20 = mul %Int32 %19, 8
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str11 to [0 x i8]*), %Int32 %20)
	%22 = alloca %Int32, align 4
	store %Int32 0, %Int32* %22
	br label %again_1
again_1:
	%23 = load %Int32, %Int32* %22
	%24 = icmp slt %Int32 %23, %m
	br %Bool %24 , label %body_1, label %break_1
body_1:
	%25 = alloca %Int32, align 4
	store %Int32 0, %Int32* %25
	br label %again_2
again_2:
	%26 = load %Int32, %Int32* %25
	%27 = icmp slt %Int32 %26, %n
	br %Bool %27 , label %body_2, label %break_2
body_2:
	%28 = alloca %Int32, align 4
	store %Int32 0, %Int32* %28
	br label %again_3
again_3:
	%29 = load %Int32, %Int32* %28
	%30 = icmp slt %Int32 %29, %p
	br %Bool %30 , label %body_3, label %break_3
body_3:
	%31 = load %Int32, %Int32* %28
	%32 = load %Int32, %Int32* %25
	%33 = load %Int32, %Int32* %22
; -- INDEX VLA --
	%34 = mul %Int32 %33, %13
	%35 = add %Int32 0, %34
	%36 = mul %Int32 %32, 1
	%37 = add %Int32 %35, %36
	%38 = getelementptr [0 x %Int32]*, [0 x [0 x [0 x %Int32]*]]* %7, %Int32 %37
; -- END INDEX VLA --
	%39 = load [0 x %Int32]*, [0 x %Int32]** %38
; -- INDEX VLA --
	%40 = mul %Int32 %31, 1
	%41 = add %Int32 0, %40
	%42 = getelementptr %Int32, [0 x %Int32]* %39, %Int32 %41
; -- END INDEX VLA --
	%43 = load %Int32, %Int32* %42
	%44 = load %Int32, %Int32* %22
	%45 = load %Int32, %Int32* %25
	%46 = load %Int32, %Int32* %28
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str12 to [0 x i8]*), %Int32 %44, %Int32 %45, %Int32 %46, %Int32 %43)
	%48 = load %Int32, %Int32* %28
	%49 = add %Int32 %48, 1
	store %Int32 %49, %Int32* %28
	br label %again_3
break_3:
	%50 = load %Int32, %Int32* %25
	%51 = add %Int32 %50, 1
	store %Int32 %51, %Int32* %25
	br label %again_2
break_2:
	%52 = load %Int32, %Int32* %22
	%53 = add %Int32 %52, 1
	store %Int32 %53, %Int32* %22
	br label %again_1
break_1:
	%54 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %54)
	ret void
}

define internal void @checkLocal3DArray() {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = alloca %Int32, align 4
	store %Int32 10, %Int32* %3
	%4 = alloca %Int32, align 4
	store %Int32 10, %Int32* %4
	%5 = alloca %Int32, align 4
	store %Int32 10, %Int32* %5

	; create VLA
	%6 = load %Int32, %Int32* %5
	%7 = mul %Int32 %6, 1  ; calc VLA item size
	%8 = load %Int32, %Int32* %4
	%9 = mul %Int32 %8, %7  ; calc VLA item size
	%10 = load %Int32, %Int32* %3
	%11 = mul %Int32 %10, %9  ; calc VLA item size
	%12 = alloca %Int32, %Int32 %11, align 4

	; Write
	%13 = alloca %Int32, align 4
	store %Int32 0, %Int32* %13
	br label %again_1
again_1:
	%14 = load %Int32, %Int32* %13
	%15 = load %Int32, %Int32* %3
	%16 = icmp slt %Int32 %14, %15
	br %Bool %16 , label %body_1, label %break_1
body_1:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %17
	%19 = load %Int32, %Int32* %4
	%20 = icmp slt %Int32 %18, %19
	br %Bool %20 , label %body_2, label %break_2
body_2:
	%21 = alloca %Int32, align 4
	store %Int32 0, %Int32* %21
	br label %again_3
again_3:
	%22 = load %Int32, %Int32* %21
	%23 = load %Int32, %Int32* %5
	%24 = icmp slt %Int32 %22, %23
	br %Bool %24 , label %body_3, label %break_3
body_3:
	%25 = load %Int32, %Int32* %21
	%26 = load %Int32, %Int32* %17
	%27 = load %Int32, %Int32* %13
; -- INDEX VLA --
	%28 = mul %Int32 %27, %9
	%29 = add %Int32 0, %28
	%30 = mul %Int32 %26, %7
	%31 = add %Int32 %29, %30
	%32 = mul %Int32 %25, 1
	%33 = add %Int32 %31, %32
	%34 = getelementptr %Int32, [0 x [0 x [0 x %Int32]]]* %12, %Int32 %33
; -- END INDEX VLA --
	%35 = load %Int32, %Int32* %13
	%36 = load %Int32, %Int32* %17
	%37 = mul %Int32 %35, %36
	%38 = load %Int32, %Int32* %21
	%39 = mul %Int32 %37, %38
	store %Int32 %39, %Int32* %34
	%40 = load %Int32, %Int32* %21
	%41 = add %Int32 %40, 1
	store %Int32 %41, %Int32* %21
	br label %again_3
break_3:
	%42 = load %Int32, %Int32* %17
	%43 = add %Int32 %42, 1
	store %Int32 %43, %Int32* %17
	br label %again_2
break_2:
	%44 = load %Int32, %Int32* %13
	%45 = add %Int32 %44, 1
	store %Int32 %45, %Int32* %13
	br label %again_1
break_1:

	; Read
	store %Int32 0, %Int32* %13
	br label %again_4
again_4:
	%46 = load %Int32, %Int32* %13
	%47 = load %Int32, %Int32* %3
	%48 = icmp slt %Int32 %46, %47
	br %Bool %48 , label %body_4, label %break_4
body_4:
	%49 = alloca %Int32, align 4
	store %Int32 0, %Int32* %49
	br label %again_5
again_5:
	%50 = load %Int32, %Int32* %49
	%51 = load %Int32, %Int32* %4
	%52 = icmp slt %Int32 %50, %51
	br %Bool %52 , label %body_5, label %break_5
body_5:
	%53 = alloca %Int32, align 4
	store %Int32 0, %Int32* %53
	br label %again_6
again_6:
	%54 = load %Int32, %Int32* %53
	%55 = load %Int32, %Int32* %5
	%56 = icmp slt %Int32 %54, %55
	br %Bool %56 , label %body_6, label %break_6
body_6:
	%57 = load %Int32, %Int32* %53
	%58 = load %Int32, %Int32* %49
	%59 = load %Int32, %Int32* %13
; -- INDEX VLA --
	%60 = mul %Int32 %59, %9
	%61 = add %Int32 0, %60
	%62 = mul %Int32 %58, %7
	%63 = add %Int32 %61, %62
	%64 = mul %Int32 %57, 1
	%65 = add %Int32 %63, %64
	%66 = getelementptr %Int32, [0 x [0 x [0 x %Int32]]]* %12, %Int32 %65
; -- END INDEX VLA --
	%67 = load %Int32, %Int32* %66
	%68 = load %Int32, %Int32* %13
	%69 = load %Int32, %Int32* %49
	%70 = load %Int32, %Int32* %53
	%71 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str13 to [0 x i8]*), %Int32 %68, %Int32 %69, %Int32 %70, %Int32 %67)
	%72 = load %Int32, %Int32* %13
	%73 = load %Int32, %Int32* %49
	%74 = mul %Int32 %72, %73
	%75 = load %Int32, %Int32* %53
	%76 = mul %Int32 %74, %75
	%77 = icmp eq %Int32 %67, %76
	br %Bool %77 , label %then_0, label %else_0
then_0:
	%78 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str14 to [0 x i8]*))
	br label %endif_0
else_0:
	%79 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([7 x i8]* @str15 to [0 x i8]*))
	br label %endif_0
endif_0:
	%80 = load %Int32, %Int32* %53
	%81 = add %Int32 %80, 1
	store %Int32 %81, %Int32* %53
	br label %again_6
break_6:
	%82 = load %Int32, %Int32* %49
	%83 = add %Int32 %82, 1
	store %Int32 %83, %Int32* %49
	br label %again_5
break_5:
	%84 = load %Int32, %Int32* %13
	%85 = add %Int32 %84, 1
	store %Int32 %85, %Int32* %13
	br label %again_4
break_4:
	%86 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %86)
	ret void
}

define %Int32 @main() {
	call void @test0()
	call void @test1([0 x [0 x [0 x %Int32]]]* bitcast ([3 x [3 x [3 x %Int32]]]* @a to [0 x [0 x [0 x %Int32]]]*), %Int32 3, %Int32 3, %Int32 3)
	call void @test2([0 x [0 x [0 x %Int32]*]]* bitcast ([3 x [3 x [3 x %Int32]*]]* @b to [0 x [0 x [0 x %Int32]*]]*), %Int32 3, %Int32 3, %Int32 3)

	;checkLocal3DArray()
	ret %Int32 0
}




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
@str1 = private constant [8 x i8] [i8 116, i8 101, i8 115, i8 116, i8 50, i8 58, i8 10, i8 0]
@str2 = private constant [18 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [19 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 42, i8 112, i8 97, i8 50, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [22 x i8] [i8 112, i8 97, i8 50, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [16 x i8] [i8 115, i8 105, i8 122, i8 101, i8 111, i8 102, i8 40, i8 97, i8 41, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [20 x i8] [i8 97, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
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

;
;func test() {
;	printf("test:\n")
;
;	var i = 0
;	while i < m {
;		var j = 0
;		while j < n {
;			var k = 0
;			while k < p {
;				let pa = unsafe *[]Int32 &a
;				//let v = a[i][j][k]
;				// не умножаем на sizeof(Int32), тк здесь все идет в sizeof(Int32)
;				let pk = 1  // здесь за единицу принят sizeof(Int32)
;				let pj = m * pk
;				let pi = n * pj
;				let v = pa[i*pi + j*pj + k*pk]
;				printf("a[%d][%d][%d] = %d\n", i, j, k, v)
;				++k
;			}
;			++j
;		}
;		++i
;	}
;}
define internal void @test2([0 x [0 x [0 x %Int32]]]* %pa, %Int32 %m, %Int32 %n, %Int32 %p) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str1 to [0 x i8]*))
	%4 = mul %Int32 %p, 1  ; calc VLA item size
	%5 = mul %Int32 %n, %4  ; calc VLA item size
	%6 = mul %Int32 %m, %5  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%7 = bitcast [0 x [0 x [0 x %Int32]]]* %pa to [0 x [0 x [0 x %Int32]]]*
	%8 = mul %Int32 %p, 1  ; calc VLA item size
	%9 = mul %Int32 %n, %8  ; calc VLA item size
	%10 = mul %Int32 %m, %9  ; calc VLA item size
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str2 to [0 x i8]*), %Int32 8)
	%12 = mul %Int32 %10, 4
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str3 to [0 x i8]*), %Int32 %12)
	%14 = alloca %Int32, align 4
	store %Int32 0, %Int32* %14
	br label %again_1
again_1:
	%15 = load %Int32, %Int32* %14
	%16 = icmp slt %Int32 %15, %m
	br %Bool %16 , label %body_1, label %break_1
body_1:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %17
	%19 = icmp slt %Int32 %18, %n
	br %Bool %19 , label %body_2, label %break_2
body_2:
	%20 = alloca %Int32, align 4
	store %Int32 0, %Int32* %20
	br label %again_3
again_3:
	%21 = load %Int32, %Int32* %20
	%22 = icmp slt %Int32 %21, %p
	br %Bool %22 , label %body_3, label %break_3
body_3:
	%23 = load %Int32, %Int32* %20
	%24 = load %Int32, %Int32* %17
	%25 = load %Int32, %Int32* %14
; -- INDEX VLA --
	%26 = mul %Int32 %25, %9
	%27 = add %Int32 0, %26
	%28 = mul %Int32 %24, %8
	%29 = add %Int32 %27, %28
	%30 = mul %Int32 %23, 1
	%31 = add %Int32 %29, %30
	%32 = getelementptr %Int32, [0 x [0 x [0 x %Int32]]]* %7, %Int32 %31
; -- END INDEX VLA --
	%33 = load %Int32, %Int32* %32
	%34 = load %Int32, %Int32* %14
	%35 = load %Int32, %Int32* %17
	%36 = load %Int32, %Int32* %20
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str4 to [0 x i8]*), %Int32 %34, %Int32 %35, %Int32 %36, %Int32 %33)
	%38 = load %Int32, %Int32* %20
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %20
	br label %again_3
break_3:
	%40 = load %Int32, %Int32* %17
	%41 = add %Int32 %40, 1
	store %Int32 %41, %Int32* %17
	br label %again_2
break_2:
	%42 = load %Int32, %Int32* %14
	%43 = add %Int32 %42, 1
	store %Int32 %43, %Int32* %14
	br label %again_1
break_1:
	%44 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %44)
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str5 to [0 x i8]*), %Int32 108)
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	br label %again_1
again_1:
	%3 = load %Int32, %Int32* %2
	%4 = icmp slt %Int32 %3, 3
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %5
	%7 = icmp slt %Int32 %6, 3
	br %Bool %7 , label %body_2, label %break_2
body_2:
	%8 = alloca %Int32, align 4
	store %Int32 0, %Int32* %8
	br label %again_3
again_3:
	%9 = load %Int32, %Int32* %8
	%10 = icmp slt %Int32 %9, 3
	br %Bool %10 , label %body_3, label %break_3
body_3:
	%11 = load %Int32, %Int32* %8
	%12 = load %Int32, %Int32* %5
	%13 = load %Int32, %Int32* %2
	%14 = getelementptr [3 x [3 x [3 x %Int32]]], [3 x [3 x [3 x %Int32]]]* @a, %Int32 0, %Int32 %13, %Int32 %12, %Int32 %11
	%15 = load %Int32, %Int32* %14
	%16 = load %Int32, %Int32* %2
	%17 = load %Int32, %Int32* %5
	%18 = load %Int32, %Int32* %8
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str6 to [0 x i8]*), %Int32 %16, %Int32 %17, %Int32 %18, %Int32 %15)
	%20 = load %Int32, %Int32* %8
	%21 = add %Int32 %20, 1
	store %Int32 %21, %Int32* %8
	br label %again_3
break_3:
	%22 = load %Int32, %Int32* %5
	%23 = add %Int32 %22, 1
	store %Int32 %23, %Int32* %5
	br label %again_2
break_2:
	%24 = load %Int32, %Int32* %2
	%25 = add %Int32 %24, 1
	store %Int32 %25, %Int32* %2
	br label %again_1
break_1:

	;test()
	call void @test2([0 x [0 x [0 x %Int32]]]* bitcast ([3 x [3 x [3 x %Int32]]]* @a to [0 x [0 x [0 x %Int32]]]*), %Int32 3, %Int32 3, %Int32 3)
	ret %Int32 0
}



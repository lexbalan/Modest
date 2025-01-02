
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
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [21 x i8] [i8 97, i8 51, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [17 x i8] [i8 97, i8 51, i8 91, i8 37, i8 100, i8 93, i8 91, i8 37, i8 100, i8 93, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [8 x i8] [i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [8 x i8] [i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --

@a0 = internal global [2 x [2 x [5 x %Int32]]] [
	[2 x [5 x %Int32]] [
		[5 x %Int32] [
			%Int32 0,
			%Int32 1,
			%Int32 2,
			%Int32 3,
			%Int32 4
		],
		[5 x %Int32] [
			%Int32 5,
			%Int32 6,
			%Int32 7,
			%Int32 8,
			%Int32 9
		]
	],
	[2 x [5 x %Int32]] [
		[5 x %Int32] [
			%Int32 10,
			%Int32 11,
			%Int32 12,
			%Int32 13,
			%Int32 14
		],
		[5 x %Int32] [
			%Int32 15,
			%Int32 16,
			%Int32 17,
			%Int32 18,
			%Int32 19
		]
	]
]
@a1 = internal global [5 x %Int32] [
	%Int32 0,
	%Int32 1,
	%Int32 2,
	%Int32 3,
	%Int32 4
]
@a2 = internal global [5 x %Int32] [
	%Int32 5,
	%Int32 6,
	%Int32 7,
	%Int32 8,
	%Int32 9
]
@a3 = internal global [2 x [5 x %Int32]*] [
	[5 x %Int32]* @a1,
	[5 x %Int32]* @a2
]

define %Int32 @main() {
	%1 = alloca %Int32, align 4
	%2 = alloca %Int32, align 4
	%3 = alloca %Int32, align 4
	;printf("x = %d ", a0[i][j])
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %1
	%5 = icmp slt %Int32 %4, 2
	br %Bool %5 , label %body_1, label %break_1
body_1:
	store %Int32 0, %Int32* %2
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %2
	%7 = icmp slt %Int32 %6, 2
	br %Bool %7 , label %body_2, label %break_2
body_2:
	store %Int32 0, %Int32* %3
	br label %again_3
again_3:
	%8 = load %Int32, %Int32* %3
	%9 = icmp slt %Int32 %8, 5
	br %Bool %9 , label %body_3, label %break_3
body_3:
	%10 = load %Int32, %Int32* %1
	%11 = load %Int32, %Int32* %2
	%12 = load %Int32, %Int32* %3
	%13 = load %Int32, %Int32* %3
	%14 = load %Int32, %Int32* %2
	%15 = load %Int32, %Int32* %1
	%16 = getelementptr [2 x [5 x %Int32]], [2 x [2 x [5 x %Int32]]]* @a0, %Int32 %15, %Int32 %14, %Int32 %13
	%17 = load %Int32, %Int32* %16
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*), %Int32 %10, %Int32 %11, %Int32 %12, %Int32 %17)
	%19 = load %Int32, %Int32* %3
	%20 = add %Int32 %19, 1
	store %Int32 %20, %Int32* %3
	br label %again_3
break_3:
	%21 = load %Int32, %Int32* %2
	%22 = add %Int32 %21, 1
	store %Int32 %22, %Int32* %2
	br label %again_2
break_2:
	%23 = load %Int32, %Int32* %1
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %1
	br label %again_1
break_1:
	;
	;
	store %Int32 0, %Int32* %1
	br label %again_4
again_4:
	%25 = load %Int32, %Int32* %1
	%26 = icmp slt %Int32 %25, 2
	br %Bool %26 , label %body_4, label %break_4
body_4:
	store %Int32 0, %Int32* %2
	br label %again_5
again_5:
	%27 = load %Int32, %Int32* %2
	%28 = icmp slt %Int32 %27, 5
	br %Bool %28 , label %body_5, label %break_5
body_5:
	%29 = load %Int32, %Int32* %1
	%30 = load %Int32, %Int32* %2
	%31 = load %Int32, %Int32* %2
	%32 = load %Int32, %Int32* %1
	%33 = getelementptr [5 x %Int32]*, [2 x [5 x %Int32]*]* @a3, %Int32 %32
	%34 = load [5 x %Int32]*, [5 x %Int32]** %33
	%35 = getelementptr %Int32, [5 x %Int32]* %34, %Int32 %31
	%36 = load %Int32, %Int32* %35
	%37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str2 to [0 x i8]*), %Int32 %29, %Int32 %30, %Int32 %36)
	%38 = load %Int32, %Int32* %2
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %2
	br label %again_5
break_5:
	%40 = load %Int32, %Int32* %1
	%41 = add %Int32 %40, 1
	store %Int32 %41, %Int32* %1
	br label %again_4
break_4:
	%42 = getelementptr [2 x [5 x %Int32]], [2 x [2 x [5 x %Int32]]]* @a0, %Int32 0, %Int32 1, %Int32 2
	%43 = load %Int32, %Int32* %42
	%44 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str3 to [0 x i8]*), %Int32 %43)
	%45 = getelementptr [5 x %Int32]*, [2 x [5 x %Int32]*]* @a3, %Int32 1
	%46 = load [5 x %Int32]*, [5 x %Int32]** %45
	%47 = getelementptr %Int32, [5 x %Int32]* %46, %Int32 4
	%48 = load %Int32, %Int32* %47
	%49 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str4 to [0 x i8]*), %Int32 %48)
	ret %Int32 0
}



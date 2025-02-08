
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
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [2 x i8] [i8 35, i8 0]
@str2 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 48, i8 0]
@str3 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 49, i8 0]
@str4 = private constant [2 x i8] [i8 48, i8 0]
@str5 = private constant [5 x i8] [i8 65, i8 108, i8 101, i8 102, i8 0]
@str6 = private constant [6 x i8] [i8 66, i8 101, i8 116, i8 104, i8 97, i8 0]
@str7 = private constant [2 x i8] [i8 49, i8 0]
@str8 = private constant [6 x i8] [i8 67, i8 108, i8 111, i8 99, i8 107, i8 0]
@str9 = private constant [6 x i8] [i8 68, i8 101, i8 112, i8 116, i8 104, i8 0]
@str10 = private constant [2 x i8] [i8 35, i8 0]
@str11 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 48, i8 0]
@str12 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 49, i8 0]
@str13 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 50, i8 0]
@str14 = private constant [2 x i8] [i8 48, i8 0]
@str15 = private constant [5 x i8] [i8 65, i8 108, i8 101, i8 102, i8 0]
@str16 = private constant [6 x i8] [i8 66, i8 101, i8 116, i8 104, i8 97, i8 0]
@str17 = private constant [5 x i8] [i8 69, i8 109, i8 109, i8 97, i8 0]
@str18 = private constant [2 x i8] [i8 49, i8 0]
@str19 = private constant [6 x i8] [i8 67, i8 108, i8 111, i8 99, i8 107, i8 0]
@str20 = private constant [6 x i8] [i8 68, i8 101, i8 112, i8 116, i8 104, i8 0]
@str21 = private constant [5 x i8] [i8 70, i8 114, i8 101, i8 101, i8 0]
@str22 = private constant [2 x i8] [i8 50, i8 0]
@str23 = private constant [4 x i8] [i8 73, i8 110, i8 107, i8 0]
@str24 = private constant [6 x i8] [i8 74, i8 117, i8 108, i8 105, i8 97, i8 0]
@str25 = private constant [8 x i8] [i8 75, i8 101, i8 121, i8 119, i8 111, i8 114, i8 100, i8 0]
@str26 = private constant [2 x i8] [i8 51, i8 0]
@str27 = private constant [6 x i8] [i8 85, i8 108, i8 116, i8 114, i8 97, i8 0]
@str28 = private constant [6 x i8] [i8 86, i8 105, i8 100, i8 101, i8 111, i8 0]
@str29 = private constant [5 x i8] [i8 87, i8 111, i8 114, i8 100, i8 0]
@str30 = private constant [2 x i8] [i8 124, i8 0]
@str31 = private constant [4 x i8] [i8 32, i8 37, i8 115, i8 0]
@str32 = private constant [2 x i8] [i8 32, i8 0]
@str33 = private constant [3 x i8] [i8 124, i8 10, i8 0]
@str34 = private constant [2 x i8] [i8 43, i8 0]
@str35 = private constant [2 x i8] [i8 45, i8 0]
@str36 = private constant [3 x i8] [i8 43, i8 10, i8 0]
@str37 = private constant [2 x i8] [i8 10, i8 0]
; -- endstrings --
%main_Table = type {
	[0 x [0 x %Str8*]]*,
	%Int32,
	%Int32,
	%Bool,
	%Bool
};

@main_table_data0 = internal global [3 x [3 x [0 x %Char8]*]] [
	[3 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str1 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str2 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str3 to [0 x i8]*)
	],
	[3 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str4 to [0 x i8]*),
		[0 x %Char8]* bitcast ([5 x i8]* @str5 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str6 to [0 x i8]*)
	],
	[3 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str7 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str8 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str9 to [0 x i8]*)
	]
]
@main_table_data1 = internal global [5 x [4 x [0 x %Char8]*]] [
	[4 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str10 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str11 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str12 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str13 to [0 x i8]*)
	],
	[4 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str14 to [0 x i8]*),
		[0 x %Char8]* bitcast ([5 x i8]* @str15 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str16 to [0 x i8]*),
		[0 x %Char8]* bitcast ([5 x i8]* @str17 to [0 x i8]*)
	],
	[4 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str18 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str19 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str20 to [0 x i8]*),
		[0 x %Char8]* bitcast ([5 x i8]* @str21 to [0 x i8]*)
	],
	[4 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str22 to [0 x i8]*),
		[0 x %Char8]* bitcast ([4 x i8]* @str23 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str24 to [0 x i8]*),
		[0 x %Char8]* bitcast ([8 x i8]* @str25 to [0 x i8]*)
	],
	[4 x [0 x %Char8]*] [
		[0 x %Char8]* bitcast ([2 x i8]* @str26 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str27 to [0 x i8]*),
		[0 x %Char8]* bitcast ([6 x i8]* @str28 to [0 x i8]*),
		[0 x %Char8]* bitcast ([5 x i8]* @str29 to [0 x i8]*)
	]
]
@main_table00 = internal global %main_Table {
	[0 x [0 x %Str8*]]* @main_table_data0,
	%Int32 3,
	%Int32 3,
	%Bool 0,
	%Bool 0
}
@main_table01 = internal global %main_Table {
	[0 x [0 x %Str8*]]* @main_table_data0,
	%Int32 3,
	%Int32 3,
	%Bool 1,
	%Bool 0
}
@main_table02 = internal global %main_Table {
	[0 x [0 x %Str8*]]* @main_table_data0,
	%Int32 3,
	%Int32 3,
	%Bool 0,
	%Bool 1
}
@main_table03 = internal global %main_Table {
	[0 x [0 x %Str8*]]* @main_table_data0,
	%Int32 3,
	%Int32 3,
	%Bool 1,
	%Bool 1
}

; we cannot receive VLA by value,
; but we can receive pointer to open array
; and after construct pointer to closed array with required dimensions
define internal void @main_tablePrint(%main_Table* %table) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = alloca %Int32, align 4
	%4 = alloca %Int32, align 4

	; construct pointer to closed array
	%5 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 1
	%6 = load %Int32, %Int32* %5
	%7 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%8 = load %Int32, %Int32* %7
	%9 = mul %Int32 %8, 1  ; calc VLA item size
	%10 = mul %Int32 %6, %9  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%11 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 0
	%12 = load [0 x [0 x %Str8*]]*, [0 x [0 x %Str8*]]** %11
	%13 = bitcast [0 x [0 x %Str8*]]* %12 to [0 x [0 x %Str8*]]*
	%14 = mul %Int32 %8, 1  ; calc VLA item size
	%15 = mul %Int32 %6, %14  ; calc VLA item size

	; array of size of columns (in characters)
	%16 = mul %Int32 %8, 1  ; calc VLA item size
	%17 = alloca %Int32, %Int32 %16, align 4
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	; -- end vol eval --
	; -- zero fill rest of array
	%18 = mul %Int32 %8, 4
	%19 = bitcast %Int32* %17 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %19, i8 0, %Int32 %18, i1 0)

	; calculate max length (in chars) of column
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%20 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 1
	%21 = load %Int32, %Int32* %3
	%22 = load %Int32, %Int32* %20
	%23 = icmp ult %Int32 %21, %22
	br %Bool %23 , label %body_1, label %break_1
body_1:
	store %Int32 0, %Int32* %4
	br label %again_2
again_2:
	%24 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%25 = load %Int32, %Int32* %4
	%26 = load %Int32, %Int32* %24
	%27 = icmp ult %Int32 %25, %26
	br %Bool %27 , label %body_2, label %break_2
body_2:
	%28 = load %Int32, %Int32* %4
	%29 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%30 = mul %Int32 %29, %14
	%31 = add %Int32 0, %30
	%32 = mul %Int32 %28, 1
	%33 = add %Int32 %31, %32
	%34 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %13, %Int32 %33
; -- END INDEX VLA --
	%35 = load %Str8*, %Str8** %34
	%36 = call %SizeT @strlen(%Str8* %35)
	%37 = trunc %SizeT %36 to %Int32
	%38 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%39 = mul %Int32 %38, 1
	%40 = add %Int32 0, %39
	%41 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %40
; -- END INDEX VLA --
	%42 = load %Int32, %Int32* %41
	%43 = icmp ugt %Int32 %37, %42
	br %Bool %43 , label %then_0, label %endif_0
then_0:
	%44 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%45 = mul %Int32 %44, 1
	%46 = add %Int32 0, %45
	%47 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %46
; -- END INDEX VLA --
	store %Int32 %37, %Int32* %47
	br label %endif_0
endif_0:
	%48 = load %Int32, %Int32* %4
	%49 = add %Int32 %48, 1
	store %Int32 %49, %Int32* %4
	br label %again_2
break_2:
	%50 = load %Int32, %Int32* %3
	%51 = add %Int32 %50, 1
	store %Int32 %51, %Int32* %3
	br label %again_1
break_1:
	store %Int32 0, %Int32* %3
	br label %again_3
again_3:
	%52 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%53 = load %Int32, %Int32* %3
	%54 = load %Int32, %Int32* %52
	%55 = icmp ult %Int32 %53, %54
	br %Bool %55 , label %body_3, label %break_3
body_3:
	; добавляем по пробелу слева и справа
	; (для красивого отступа)
	%56 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%57 = mul %Int32 %56, 1
	%58 = add %Int32 0, %57
	%59 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %58
; -- END INDEX VLA --
	%60 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%61 = mul %Int32 %60, 1
	%62 = add %Int32 0, %61
	%63 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %62
; -- END INDEX VLA --
	%64 = load %Int32, %Int32* %63
	%65 = add %Int32 %64, 2
	store %Int32 %65, %Int32* %59
	%66 = load %Int32, %Int32* %3
	%67 = add %Int32 %66, 1
	store %Int32 %67, %Int32* %3
	br label %again_3
break_3:

	; begin border
	%68 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%69 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%70 = load %Int32, %Int32* %69
	call void @main_printTableSep([0 x %Int32]* %68, %Int32 %70)
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%71 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 1
	%72 = load %Int32, %Int32* %3
	%73 = load %Int32, %Int32* %71
	%74 = icmp ult %Int32 %72, %73
	br %Bool %74 , label %body_4, label %break_4
body_4:
	store %Int32 0, %Int32* %4
	br label %again_5
again_5:
	%75 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%76 = load %Int32, %Int32* %4
	%77 = load %Int32, %Int32* %75
	%78 = icmp ult %Int32 %76, %77
	br %Bool %78 , label %body_5, label %break_5
body_5:
	%79 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str30 to [0 x i8]*))
	%80 = load %Int32, %Int32* %4
	%81 = load %Int32, %Int32* %3
; -- INDEX VLA --
	%82 = mul %Int32 %81, %14
	%83 = add %Int32 0, %82
	%84 = mul %Int32 %80, 1
	%85 = add %Int32 %83, %84
	%86 = getelementptr %Str8*, [0 x [0 x %Str8*]]* %13, %Int32 %85
; -- END INDEX VLA --
	%87 = load %Str8*, %Str8** %86
	%88 = alloca %Int32, align 4
	%89 = call %SizeT @strlen(%Str8* %87)
	%90 = trunc %SizeT %89 to %Int32
	store %Int32 %90, %Int32* %88
	%91 = getelementptr %Str8, %Str8* %87, %Int32 0, %Int32 0
	%92 = load %Char8, %Char8* %91
	%93 = icmp ne %Char8 %92, 0
	br %Bool %93 , label %then_1, label %endif_1
then_1:
	%94 = load %Int32, %Int32* %88
	%95 = add %Int32 %94, 1
	store %Int32 %95, %Int32* %88
	%96 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str31 to [0 x i8]*), %Str8* %87)
	br label %endif_1
endif_1:
	%97 = alloca %Int32, align 4
	store %Int32 0, %Int32* %97
	br label %again_6
again_6:
	%98 = load %Int32, %Int32* %4
; -- INDEX VLA --
	%99 = mul %Int32 %98, 1
	%100 = add %Int32 0, %99
	%101 = getelementptr %Int32, [0 x %Int32]* %17, %Int32 %100
; -- END INDEX VLA --
	%102 = load %Int32, %Int32* %101
	%103 = load %Int32, %Int32* %88
	%104 = sub %Int32 %102, %103
	%105 = load %Int32, %Int32* %97
	%106 = icmp ult %Int32 %105, %104
	br %Bool %106 , label %body_6, label %break_6
body_6:
	%107 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str32 to [0 x i8]*))
	%108 = load %Int32, %Int32* %97
	%109 = add %Int32 %108, 1
	store %Int32 %109, %Int32* %97
	br label %again_6
break_6:
	%110 = load %Int32, %Int32* %4
	%111 = add %Int32 %110, 1
	store %Int32 %111, %Int32* %4
	br label %again_5
break_5:
	%112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str33 to [0 x i8]*))
	%113 = load %Int32, %Int32* %3
	%114 = add %Int32 %113, 1
	store %Int32 %114, %Int32* %3

	; print `+--+--+` separator line
	%115 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 4
	%116 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 1
	%117 = load %Int32, %Int32* %3
	%118 = load %Int32, %Int32* %116
	%119 = icmp ult %Int32 %117, %118
	%120 = load %Bool, %Bool* %115
	%121 = and %Bool %120, %119
	%122 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 3
	%123 = load %Int32, %Int32* %3
	%124 = icmp ule %Int32 %123, 1
	%125 = load %Bool, %Bool* %122
	%126 = and %Bool %125, %124
	%127 = or %Bool %121, %126
	br %Bool %127 , label %then_2, label %endif_2
then_2:
	%128 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%129 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%130 = load %Int32, %Int32* %129
	call void @main_printTableSep([0 x %Int32]* %128, %Int32 %130)
	br label %endif_2
endif_2:
	br label %again_4
break_4:

	; end border
	%131 = bitcast [0 x %Int32]* %17 to [0 x %Int32]*
	%132 = getelementptr %main_Table, %main_Table* %table, %Int32 0, %Int32 2
	%133 = load %Int32, %Int32* %132
	call void @main_printTableSep([0 x %Int32]* %131, %Int32 %133)
	%134 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %134)
	ret void
}



; печатает строку отделяющую записи таблицы
; получает указатель на массив с размерами колонок
; и количество элементов в ней
define internal void @main_printTableSep([0 x %Int32]* %sz, %Int32 %m) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* %1
	%3 = icmp ult %Int32 %2, %m
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str34 to [0 x i8]*))
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %1
	%7 = bitcast %Int32 %6 to %Int32
	%8 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %7
	%9 = load %Int32, %Int32* %5
	%10 = load %Int32, %Int32* %8
	%11 = icmp ult %Int32 %9, %10
	br %Bool %11 , label %body_2, label %break_2
body_2:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str35 to [0 x i8]*))
	%13 = load %Int32, %Int32* %5
	%14 = add %Int32 %13, 1
	store %Int32 %14, %Int32* %5
	br label %again_2
break_2:
	%15 = load %Int32, %Int32* %1
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %1
	br label %again_1
break_1:
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str36 to [0 x i8]*))
	ret void
}

define %Int32 @main() {
	;printf("sizeof(table0) = %d\n", Nat32 sizeof(table0))
	;printf("sizeof(table1) = %d\n", Nat32 sizeof(table1))
	call void @main_tablePrint(%main_Table* bitcast (%main_Table* @main_table00 to %main_Table*))
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str37 to [0 x i8]*))
	ret %Int32 0
}



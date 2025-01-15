
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
@str1 = private constant [2 x i8] [i8 35, i8 0]
@str2 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 48, i8 0]
@str3 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 49, i8 0]
@str4 = private constant [8 x i8] [i8 72, i8 101, i8 97, i8 100, i8 101, i8 114, i8 50, i8 0]
@str5 = private constant [2 x i8] [i8 48, i8 0]
@str6 = private constant [5 x i8] [i8 65, i8 108, i8 101, i8 102, i8 0]
@str7 = private constant [6 x i8] [i8 66, i8 101, i8 116, i8 104, i8 97, i8 0]
@str8 = private constant [5 x i8] [i8 69, i8 109, i8 109, i8 97, i8 0]
@str9 = private constant [2 x i8] [i8 49, i8 0]
@str10 = private constant [6 x i8] [i8 67, i8 108, i8 111, i8 99, i8 107, i8 0]
@str11 = private constant [6 x i8] [i8 68, i8 101, i8 112, i8 116, i8 104, i8 0]
@str12 = private constant [5 x i8] [i8 70, i8 114, i8 101, i8 101, i8 0]
@str13 = private constant [2 x i8] [i8 50, i8 0]
@str14 = private constant [4 x i8] [i8 73, i8 110, i8 107, i8 0]
@str15 = private constant [6 x i8] [i8 74, i8 117, i8 108, i8 105, i8 97, i8 0]
@str16 = private constant [8 x i8] [i8 75, i8 101, i8 121, i8 119, i8 111, i8 114, i8 100, i8 0]
@str17 = private constant [2 x i8] [i8 51, i8 0]
@str18 = private constant [6 x i8] [i8 85, i8 108, i8 116, i8 114, i8 97, i8 0]
@str19 = private constant [6 x i8] [i8 86, i8 105, i8 100, i8 101, i8 111, i8 0]
@str20 = private constant [5 x i8] [i8 87, i8 111, i8 114, i8 100, i8 0]
@str21 = private constant [2 x i8] [i8 43, i8 0]
@str22 = private constant [2 x i8] [i8 45, i8 0]
@str23 = private constant [2 x i8] [i8 43, i8 0]
@str24 = private constant [3 x i8] [i8 10, i8 124, i8 0]
@str25 = private constant [2 x i8] [i8 124, i8 0]
@str26 = private constant [4 x i8] [i8 32, i8 37, i8 115, i8 0]
@str27 = private constant [2 x i8] [i8 32, i8 0]
@str28 = private constant [2 x i8] [i8 124, i8 0]
@str29 = private constant [2 x i8] [i8 10, i8 0]
@str30 = private constant [2 x i8] [i8 10, i8 0]
; -- endstrings --


; [row, col]
@table = internal global [5 x [4 x %Str8*]] [
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @str1 to [0 x i8]*),
		%Str8* bitcast ([8 x i8]* @str2 to [0 x i8]*),
		%Str8* bitcast ([8 x i8]* @str3 to [0 x i8]*),
		%Str8* bitcast ([8 x i8]* @str4 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @str5 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @str6 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str7 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @str8 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @str9 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str10 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str11 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @str12 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @str13 to [0 x i8]*),
		%Str8* bitcast ([4 x i8]* @str14 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str15 to [0 x i8]*),
		%Str8* bitcast ([8 x i8]* @str16 to [0 x i8]*)
	],
	[4 x %Str8*] [
		%Str8* bitcast ([2 x i8]* @str17 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str18 to [0 x i8]*),
		%Str8* bitcast ([6 x i8]* @str19 to [0 x i8]*),
		%Str8* bitcast ([5 x i8]* @str20 to [0 x i8]*)
	]
]
define internal %Int32 @max(%Int32 %a, %Int32 %b) {
	%1 = icmp ugt %Int32 %b, %a
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret %Int32 %b
	br label %endif_0
endif_0:
	ret %Int32 %a
}

define internal void @tableSepPrint([0 x %Int32]* %sz, %Int32 %m) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str21 to [0 x i8]*))
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	br label %again_1
again_1:
	%3 = load %Int32, %Int32* %2
	%4 = icmp slt %Int32 %3, %m
	br %Bool %4 , label %body_1, label %break_1
body_1:
	%5 = alloca %Int32, align 4
	store %Int32 0, %Int32* %5
	br label %again_2
again_2:
	%6 = load %Int32, %Int32* %2
	%7 = getelementptr [0 x %Int32], [0 x %Int32]* %sz, %Int32 0, %Int32 %6
	%8 = load %Int32, %Int32* %5
	%9 = load %Int32, %Int32* %7
	%10 = icmp ult %Int32 %8, %9
	br %Bool %10 , label %body_2, label %break_2
body_2:
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str22 to [0 x i8]*))
	%12 = load %Int32, %Int32* %5
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %5
	br label %again_2
break_2:
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str23 to [0 x i8]*))
	%15 = load %Int32, %Int32* %2
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %2
	br label %again_1
break_1:
	ret void
}

define internal void @tablePrint([0 x [0 x %Str8*]]* %tablex, %Int32 %n, %Int32 %m, %Bool %headline) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = alloca %Int32, align 4
	%4 = alloca %Int32, align 4
	%5 = alloca %Int32, %Int32 %m, align 4
	%6 = bitcast %Int32* %5 to [0 x %Int32]*
	; -- ASSIGN ARRAY --
	; -- start vol eval --
	; -- end vol eval --
	; -- zero fill rest of array
	%7 = mul %Int32 %m, 4
	%8 = bitcast [0 x %Int32]* %6 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %8, i8 0, %Int32 %7, i1 0)
	%9 = alloca [0 x %Str8*]*, align 8
	%10 = bitcast [0 x [0 x %Str8*]]* %tablex to [0 x %Str8*]*
	store [0 x %Str8*]* %10, [0 x %Str8*]** %9

	; calculate max length of col
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	%11 = load %Int32, %Int32* %3
	%12 = icmp slt %Int32 %11, %n
	br %Bool %12 , label %body_1, label %break_1
body_1:
	store %Int32 0, %Int32* %4
	br label %again_2
again_2:
	%13 = load %Int32, %Int32* %4
	%14 = icmp slt %Int32 %13, %m
	br %Bool %14 , label %body_2, label %break_2
body_2:
	%15 = sub %Int32 %n, 1
	%16 = load %Int32, %Int32* %3
	%17 = mul %Int32 %16, %15
	%18 = load %Int32, %Int32* %4
	%19 = add %Int32 %17, %18
	%20 = load [0 x %Str8*]*, [0 x %Str8*]** %9
	%21 = getelementptr [0 x %Str8*], [0 x %Str8*]* %20, %Int32 0, %Int32 %19
	%22 = load %Str8*, %Str8** %21
	%23 = call %SizeT @strlen(%Str8* %22)
	%24 = trunc %SizeT %23 to %Int32
	%25 = load %Int32, %Int32* %4
	%26 = getelementptr [0 x %Int32], [0 x %Int32]* %6, %Int32 0, %Int32 %25
	%27 = load %Int32, %Int32* %4
	%28 = getelementptr [0 x %Int32], [0 x %Int32]* %6, %Int32 0, %Int32 %27
	%29 = load %Int32, %Int32* %28
	%30 = call %Int32 @max(%Int32 %24, %Int32 %29)
	store %Int32 %30, %Int32* %26
	%31 = load %Int32, %Int32* %4
	%32 = add %Int32 %31, 1
	store %Int32 %32, %Int32* %4
	br label %again_2
break_2:
	%33 = load %Int32, %Int32* %3
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %3
	br label %again_1
break_1:
	store %Int32 0, %Int32* %3
	br label %again_3
again_3:
	%35 = load %Int32, %Int32* %3
	%36 = icmp slt %Int32 %35, %m
	br %Bool %36 , label %body_3, label %break_3
body_3:
	; добавляем 1 пробел слева и один справа
	; для красивого отступа
	%37 = load %Int32, %Int32* %3
	%38 = getelementptr [0 x %Int32], [0 x %Int32]* %6, %Int32 0, %Int32 %37
	%39 = load %Int32, %Int32* %3
	%40 = getelementptr [0 x %Int32], [0 x %Int32]* %6, %Int32 0, %Int32 %39
	%41 = load %Int32, %Int32* %40
	%42 = add %Int32 %41, 2
	store %Int32 %42, %Int32* %38
	%43 = load %Int32, %Int32* %3
	%44 = add %Int32 %43, 1
	store %Int32 %44, %Int32* %3
	br label %again_3
break_3:
	store %Int32 0, %Int32* %3
	br label %again_4
again_4:
	%45 = load %Int32, %Int32* %3
	%46 = icmp slt %Int32 %45, %n
	br %Bool %46 , label %body_4, label %break_4
body_4:
	; pirint `+----+` separator
	%47 = load %Int32, %Int32* %3
	%48 = icmp slt %Int32 %47, 2
	%49 = xor %Bool %headline, 1
	%50 = or %Bool %48, %49
	br %Bool %50 , label %then_0, label %else_0
then_0:
	%51 = bitcast [0 x %Int32]* %6 to [0 x %Int32]*
	call void @tableSepPrint([0 x %Int32]* %51, %Int32 %m)
	%52 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str24 to [0 x i8]*))
	br label %endif_0
else_0:
	%53 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str25 to [0 x i8]*))
	br label %endif_0
endif_0:
	store %Int32 0, %Int32* %4
	br label %again_5
again_5:
	%54 = load %Int32, %Int32* %4
	%55 = icmp slt %Int32 %54, %m
	br %Bool %55 , label %body_5, label %break_5
body_5:
	%56 = sub %Int32 %n, 1
	%57 = load %Int32, %Int32* %3
	%58 = mul %Int32 %57, %56
	%59 = load %Int32, %Int32* %4
	%60 = add %Int32 %58, %59
	%61 = load [0 x %Str8*]*, [0 x %Str8*]** %9
	%62 = getelementptr [0 x %Str8*], [0 x %Str8*]* %61, %Int32 0, %Int32 %60
	%63 = load %Str8*, %Str8** %62
	%64 = alloca %Int32, align 4
	%65 = call %SizeT @strlen(%Str8* %63)
	%66 = trunc %SizeT %65 to %Int32
	store %Int32 %66, %Int32* %64
	%67 = getelementptr %Str8, %Str8* %63, %Int32 0, %Int32 0
	%68 = load %Char8, %Char8* %67
	%69 = icmp ne %Char8 %68, 0
	br %Bool %69 , label %then_1, label %endif_1
then_1:
	%70 = load %Int32, %Int32* %64
	%71 = add %Int32 %70, 1
	store %Int32 %71, %Int32* %64
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str26 to [0 x i8]*), %Str8* %63)
	br label %endif_1
endif_1:
	%73 = alloca %Int32, align 4
	store %Int32 0, %Int32* %73
	br label %again_6
again_6:
	%74 = load %Int32, %Int32* %4
	%75 = getelementptr [0 x %Int32], [0 x %Int32]* %6, %Int32 0, %Int32 %74
	%76 = load %Int32, %Int32* %75
	%77 = load %Int32, %Int32* %64
	%78 = sub %Int32 %76, %77
	%79 = load %Int32, %Int32* %73
	%80 = icmp ult %Int32 %79, %78
	br %Bool %80 , label %body_6, label %break_6
body_6:
	%81 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str27 to [0 x i8]*))
	%82 = load %Int32, %Int32* %73
	%83 = add %Int32 %82, 1
	store %Int32 %83, %Int32* %73
	br label %again_6
break_6:
	%84 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str28 to [0 x i8]*))
	%85 = load %Int32, %Int32* %4
	%86 = add %Int32 %85, 1
	store %Int32 %86, %Int32* %4
	br label %again_5
break_5:
	%87 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str29 to [0 x i8]*))
	%88 = load %Int32, %Int32* %3
	%89 = add %Int32 %88, 1
	store %Int32 %89, %Int32* %3
	br label %again_4
break_4:
	%90 = bitcast [0 x %Int32]* %6 to [0 x %Int32]*
	call void @tableSepPrint([0 x %Int32]* %90, %Int32 %m)
	%91 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str30 to [0 x i8]*))
	%92 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %92)
	ret void
}

define %Int32 @main() {
	;
; -- ARRAY OF ARRAY CONS --
	call void @tablePrint([0 x [0 x %Str8*]]* bitcast ([5 x [4 x %Str8*]]* @table to [0 x [0 x %Str8*]]*), %Int32 5, %Int32 4, %Bool 1)
	ret %Int32 0
}



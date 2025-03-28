
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
@str1 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
@str2 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str3 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str5 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str6 = private constant [35 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 40, i8 45, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str8 = private constant [34 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 40, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str9 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str10 = private constant [38 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 40, i8 48, i8 120, i8 102, i8 102, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str11 = private constant [31 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --
%main_Point = type {
	%Int32,
	%Int32
};

@main_v0 = global %Int32 zeroinitializer


;@attribute("value:nodecorate")
define void @main_f0() {
	ret void
}

@i32 = internal global %Int32 zeroinitializer
@u32 = internal global %Int32 zeroinitializer
define %Int32 @main() {
	%1 = alloca %main_Point, align 8
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str1 to [0 x i8]*), %Str8* bitcast ([4 x i8]* @str2 to [0 x i8]*))
	%3 = load %Int32, %Int32* @main_v0
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), %Int32 %3)
	call void @main_f0()
	%5 = alloca %Int32, align 4
	store %Int32 5, %Int32* %5
	%6 = alloca %Int32, align 4
	store %Int32 15, %Int32* %6
	%7 = alloca [10 x %Int32], align 1
	%8 = zext i8 10 to %Int32
	%9 = mul %Int32 %8, 4
	%10 = bitcast [10 x %Int32]* %7 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %10, i8 0, %Int32 %9, i1 0)
	;
	%11 = alloca [5 x %Int32], align 1
	%12 = zext i8 2 to %Int32
	%13 = getelementptr [10 x %Int32], [10 x %Int32]* %7, %Int32 0, %Int32 %12
	%14 = bitcast %Int32* %13 to [5 x %Int32]*
	%15 = load [5 x %Int32], [5 x %Int32]* %14
	%16 = zext i8 5 to %Int32
	store [5 x %Int32] %15, [5 x %Int32]* %11
	;
	%17 = alloca [20 x %Int32], align 1
	%18 = zext i8 5 to %Int32
	%19 = getelementptr [20 x %Int32], [20 x %Int32]* %17, %Int32 0, %Int32 %18
	%20 = bitcast %Int32* %19 to [10 x %Int32]*
	%21 = load [10 x %Int32], [10 x %Int32]* %7
	%22 = zext i8 10 to %Int32
	store [10 x %Int32] %21, [10 x %Int32]* %20
	;
	%23 = alloca [20 x %Int32], align 1
	%24 = load %Int32, %Int32* %5
	%25 = getelementptr [20 x %Int32], [20 x %Int32]* %23, %Int32 0, %Int32 %24
	%26 = bitcast %Int32* %25 to [0 x %Int32]*
	%27 = load [10 x %Int32], [10 x %Int32]* %7
	%28 = zext i8 10 to %Int32
	store [10 x %Int32] %27, [0 x %Int32]* %26
	;
	%29 = zext i8 3 to %Int32
	%30 = getelementptr [20 x %Int32], [20 x %Int32]* %23, %Int32 0, %Int32 %29
	%31 = bitcast %Int32* %30 to [9 x %Int32]*
	%32 = zext i8 4 to %Int32
	%33 = getelementptr [20 x %Int32], [20 x %Int32]* %17, %Int32 0, %Int32 %32
	%34 = bitcast %Int32* %33 to [9 x %Int32]*
	%35 = load [9 x %Int32], [9 x %Int32]* %34
	%36 = zext i8 9 to %Int32
	store [9 x %Int32] %35, [9 x %Int32]* %31
	;
	%37 = zext i8 3 to %Int32
	%38 = getelementptr [20 x %Int32], [20 x %Int32]* %23, %Int32 0, %Int32 %37
	%39 = bitcast %Int32* %38 to [10 x %Int32]*
	%40 = load [10 x %Int32], [10 x %Int32]* %39
	%41 = zext i8 10 to %Int32
	store [10 x %Int32] %40, [10 x %Int32]* %7
	;
	%42 = zext i8 3 to %Int32
	%43 = getelementptr [20 x %Int32], [20 x %Int32]* %23, %Int32 0, %Int32 %42
	%44 = bitcast %Int32* %43 to [10 x %Int32]*
	%45 = zext i8 10 to %Int32
	%46 = mul %Int32 %45, 4
	%47 = bitcast [10 x %Int32]* %44 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %47, i8 0, %Int32 %46, i1 0)
	%48 = mul i8 10, 1
	%49 = mul i8 10, 4
	%50 = bitcast [20 x %Int32]* %17 to [10 x %Int]*
; if_0
	%51 = bitcast [10 x %Int]* %50 to i8*
	%52 = bitcast [10 x %Int32]* %7 to i8*
	%53 = call i1 (i8*, i8*, i64) @memeq(i8* %51, i8* %52, %Int64 40)
	%54 = icmp ne %Bool %53, 0
	br %Bool %54 , label %then_0, label %else_0
then_0:
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str4 to [0 x i8]*))
	br label %endif_0
else_0:
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str5 to [0 x i8]*))
	br label %endif_0
endif_0:



	;	let x = Int8 -1
	;
	;	i32 = Int32 x
	;	u32 = Nat32 x

	; не проверяет дубликаты имен!
	%57 = alloca %Int32, align 4
	store %Int32 1, %Int32* %57
	;var y: Int32 = 0x1  // error!
	%58 = alloca %Word32, align 4
	%59 = zext i8 1 to %Word32
	store %Word32 %59, %Word32* %58
	%60 = alloca %Word32, align 4
	store %Word32 1, %Word32* %60
	%61 = sub i8 0, 1
	%62 = zext %Int8 %61 to %Word32
; if_1
	br %Bool 1 , label %then_1, label %else_1
then_1:
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str6 to [0 x i8]*))
	br label %endif_1
else_1:
	%64 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str7 to [0 x i8]*))
	br label %endif_1
endif_1:
; if_2
	br %Bool 1 , label %then_2, label %else_2
then_2:
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str8 to [0 x i8]*))
	br label %endif_2
else_2:
	%66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str9 to [0 x i8]*))
	br label %endif_2
endif_2:
; if_3
	br %Bool 1 , label %then_3, label %else_3
then_3:
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str10 to [0 x i8]*))
	br label %endif_3
else_3:
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str11 to [0 x i8]*))
	br label %endif_3
endif_3:

	;printf("i32 = 0x%08x (%d)\n", i32, i32)
	;printf("u32 = 0x%08x (%d)\n", u32, u32)
	ret %Int32 0
}




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
%File = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
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
@str1 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
@str2 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str3 = private constant [9 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [11 x i8] [i8 112, i8 48, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str6 = private constant [5 x i8] [i8 101, i8 113, i8 33, i8 10, i8 0]
@str7 = private constant [35 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 40, i8 45, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str8 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 73, i8 110, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str9 = private constant [34 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 40, i8 49, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str10 = private constant [30 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 78, i8 97, i8 116, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str11 = private constant [38 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 40, i8 48, i8 120, i8 102, i8 102, i8 41, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str12 = private constant [31 x i8] [i8 73, i8 110, i8 116, i8 56, i8 32, i8 45, i8 49, i8 32, i8 45, i8 62, i8 32, i8 87, i8 111, i8 114, i8 100, i8 51, i8 50, i8 32, i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
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
@u32 = internal global %Nat32 zeroinitializer
@prev_p = internal global [10 x %Word8] zeroinitializer
define internal void @xxx([0 x %Word8]* %p) {
	%1 = bitcast [0 x %Word8]* %p to [10 x %Word8]*
; if_0
	%2 = bitcast [10 x %Word8]* @prev_p to i8*
	%3 = bitcast [10 x %Word8]* %1 to i8*
	%4 = call i1 (i8*, i8*, i64) @memeq(i8* %2, i8* %3, %Int64 10)
	%5 = icmp eq %Bool %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = load [10 x %Word8], [10 x %Word8]* %1
	%7 = zext i8 10 to %Nat32
	store [10 x %Word8] %6, [10 x %Word8]* @prev_p
	br label %endif_0
endif_0:
	ret void
}

define internal void @mzero(i8* %p, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %p to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = mul %Nat32 %size, 1
	%7 = bitcast [0 x %Word8]* %3 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %7, i8 0, %Nat32 %6, i1 0)
	%8 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %8)
	ret void
}

define internal void @mcopy(i8* %dst, i8* %src, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %dst to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = bitcast i8* %src to [0 x %Word8]*
	%7 = mul %Nat32 %size, 1
	%8 = mul %Nat32 %size, 1
	%9 = load [0 x %Word8], [0 x %Word8]* %6
	store [0 x %Word8] %9, [0 x %Word8]* %3
	%10 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %10)
	ret void
}

define internal %Bool @mcmp(i8* %a, i8* %b, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %a to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = bitcast i8* %b to [0 x %Word8]*
	%7 = mul %Nat32 %size, 1
	%8 = mul %Nat32 %size, 1
	%9 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %9)
	%10 = bitcast [0 x %Word8]* %3 to i8*
	%11 = bitcast [0 x %Word8]* %6 to i8*
	%12 = call i1 (i8*, i8*, i64) @memeq(i8* %10, i8* %11, %Int64 0)
	%13 = icmp ne %Bool %12, 0
	ret %Bool %13
}

define internal void @sbuf(i8* %p, %Nat32 %size) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
	%3 = bitcast i8* %p to [0 x %Word8]*
	%4 = mul %Nat32 %size, 1
	%5 = mul %Nat32 %size, 1
	%6 = mul %Nat32 %size, 1
	%7 = mul %Nat32 %size, 1
	%8 = alloca %Word8, %Nat32 %6, align 1
	%9 = load [0 x %Word8], [0 x %Word8]* %3
	store [0 x %Word8] %9, %Word8* %8
	%10 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %10
; while_1
	br label %again_1
again_1:
	%11 = load %Nat32, %Nat32* %10
	%12 = icmp ult %Nat32 %11, %size
	br %Bool %12 , label %body_1, label %break_1
body_1:
	%13 = load %Nat32, %Nat32* %10
	%14 = mul %Nat32 %13, 1
	%15 = add %Int32 0, %14
	%16 = getelementptr %Word8, [0 x %Word8]* %8, %Int32 %15
	%17 = load %Word8, %Word8* %16
	%18 = load %Nat32, %Nat32* %10
	%19 = add %Nat32 %18, 1
	store %Nat32 %19, %Nat32* %10
	br label %again_1
break_1:
	%20 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %20)
	ret void
}



;@attribute("value.type:c_restrict")
;@attribute("value.type:c_volatile")
@xx = internal global [0 x [10 x %Int]*]* zeroinitializer
@yy = internal global [10 x %Int] zeroinitializer
@va = internal global %Int32 4
@p = internal global {
	i8,
	i8
} {
	i8 1,
	i8 2
}
@ini = constant [10 x i8] [
	i8 0,
	i8 1,
	i8 2,
	i8 3,
	i8 4,
	i8 5,
	i8 6,
	i8 7,
	i8 8,
	i8 9
]
define %Int32 @main() {
	%1 = alloca %main_Point, align 8
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str1 to [0 x i8]*), %Str8* bitcast ([4 x i8]* @str2 to [0 x i8]*))
	%3 = load %Int32, %Int32* @main_v0
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str3 to [0 x i8]*), %Int32 %3)
	call void @main_f0()
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str4 to [0 x i8]*), %Int32 1)
	%6 = alloca %Int32, align 4
	store %Int32 5, %Int32* %6
	%7 = alloca %Int32, align 4
	store %Int32 15, %Int32* %7
	%8 = alloca [10 x %Word8], align 1
	%9 = bitcast i8 0 to %Word8
	%10 = bitcast i8 1 to %Word8
	%11 = bitcast i8 2 to %Word8
	%12 = bitcast i8 3 to %Word8
	%13 = bitcast i8 4 to %Word8
	%14 = bitcast i8 5 to %Word8
	%15 = bitcast i8 6 to %Word8
	%16 = bitcast i8 7 to %Word8
	%17 = bitcast i8 8 to %Word8
	%18 = bitcast i8 9 to %Word8
	%19 = bitcast i8 1 to %Word8
	%20 = insertvalue [10 x %Word8] zeroinitializer, %Word8 %19, 1
	%21 = bitcast i8 2 to %Word8
	%22 = insertvalue [10 x %Word8] %20, %Word8 %21, 2
	%23 = bitcast i8 3 to %Word8
	%24 = insertvalue [10 x %Word8] %22, %Word8 %23, 3
	%25 = bitcast i8 4 to %Word8
	%26 = insertvalue [10 x %Word8] %24, %Word8 %25, 4
	%27 = bitcast i8 5 to %Word8
	%28 = insertvalue [10 x %Word8] %26, %Word8 %27, 5
	%29 = bitcast i8 6 to %Word8
	%30 = insertvalue [10 x %Word8] %28, %Word8 %29, 6
	%31 = bitcast i8 7 to %Word8
	%32 = insertvalue [10 x %Word8] %30, %Word8 %31, 7
	%33 = bitcast i8 8 to %Word8
	%34 = insertvalue [10 x %Word8] %32, %Word8 %33, 8
	%35 = bitcast i8 9 to %Word8
	%36 = insertvalue [10 x %Word8] %34, %Word8 %35, 9
	%37 = zext i8 10 to %Nat32
	store [10 x %Word8] %36, [10 x %Word8]* %8
	%38 = alloca [10 x %Int32], align 1
	%39 = insertvalue [10 x %Int32] zeroinitializer, %Int32 1, 1
	%40 = insertvalue [10 x %Int32] %39, %Int32 2, 2
	%41 = insertvalue [10 x %Int32] %40, %Int32 3, 3
	%42 = insertvalue [10 x %Int32] %41, %Int32 4, 4
	%43 = insertvalue [10 x %Int32] %42, %Int32 5, 5
	%44 = insertvalue [10 x %Int32] %43, %Int32 6, 6
	%45 = insertvalue [10 x %Int32] %44, %Int32 7, 7
	%46 = insertvalue [10 x %Int32] %45, %Int32 8, 8
	%47 = insertvalue [10 x %Int32] %46, %Int32 9, 9
	%48 = zext i8 10 to %Nat32
	store [10 x %Int32] %47, [10 x %Int32]* %38
	;
	%49 = alloca [5 x %Int32], align 1
	%50 = zext i8 2 to %Nat32
	%51 = getelementptr [10 x %Int32], [10 x %Int32]* %38, %Int32 0, %Nat32 %50
	%52 = bitcast %Int32* %51 to [5 x %Int32]*
	%53 = load [5 x %Int32], [5 x %Int32]* %52
	%54 = zext i8 5 to %Nat32
	store [5 x %Int32] %53, [5 x %Int32]* %49
	;
	%55 = alloca [20 x %Int32], align 1
	%56 = zext i8 5 to %Nat32
	%57 = getelementptr [20 x %Int32], [20 x %Int32]* %55, %Int32 0, %Nat32 %56
	%58 = bitcast %Int32* %57 to [10 x %Int32]*
	%59 = load [10 x %Int32], [10 x %Int32]* %38
	%60 = zext i8 10 to %Nat32
	store [10 x %Int32] %59, [10 x %Int32]* %58
	;
	%61 = alloca [20 x %Int32], align 1
	%62 = load %Int32, %Int32* %6
	%63 = getelementptr [20 x %Int32], [20 x %Int32]* %61, %Int32 0, %Int32 %62
	%64 = bitcast %Int32* %63 to [0 x %Int32]*
	%65 = load [10 x %Int32], [10 x %Int32]* %38
	%66 = zext i8 10 to %Nat32
	store [10 x %Int32] %65, [0 x %Int32]* %64
	;
	%67 = zext i8 3 to %Nat32
	%68 = getelementptr [20 x %Int32], [20 x %Int32]* %61, %Int32 0, %Nat32 %67
	%69 = bitcast %Int32* %68 to [9 x %Int32]*
	%70 = zext i8 4 to %Nat32
	%71 = getelementptr [20 x %Int32], [20 x %Int32]* %55, %Int32 0, %Nat32 %70
	%72 = bitcast %Int32* %71 to [9 x %Int32]*
	%73 = load [9 x %Int32], [9 x %Int32]* %72
	%74 = zext i8 9 to %Nat32
	store [9 x %Int32] %73, [9 x %Int32]* %69
	;
	%75 = zext i8 3 to %Nat32
	%76 = getelementptr [20 x %Int32], [20 x %Int32]* %61, %Int32 0, %Nat32 %75
	%77 = bitcast %Int32* %76 to [10 x %Int32]*
	%78 = load [10 x %Int32], [10 x %Int32]* %77
	%79 = zext i8 10 to %Nat32
	store [10 x %Int32] %78, [10 x %Int32]* %38
	;
	%80 = zext i8 3 to %Nat32
	%81 = getelementptr [20 x %Int32], [20 x %Int32]* %61, %Int32 0, %Nat32 %80
	%82 = bitcast %Int32* %81 to [10 x %Int32]*
	%83 = zext i8 10 to %Nat32
	%84 = mul %Nat32 %83, 4
	%85 = bitcast [10 x %Int32]* %82 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %85, i8 0, %Nat32 %84, i1 0)
	%86 = alloca [10 x %Int32], align 1
	%87 = zext i8 10 to %Nat32
	%88 = mul %Nat32 %87, 4
	%89 = bitcast [10 x %Int32]* %86 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %89, i8 0, %Nat32 %88, i1 0)
	%90 = bitcast [10 x %Word8]* %8 to [0 x %Word8]*
	call void @xxx([0 x %Word8]* %90)
	%91 = alloca %Word8, align 1
	%92 = bitcast i8 1 to %Word8
	store %Word8 %92, %Word8* %91
	%93 = alloca %Word8, align 1
	%94 = load %Word8, %Word8* %91
	%95 = bitcast %Word8 %94 to %Nat8
	%96 = bitcast %Nat8 %95 to %Word8
	store %Word8 %96, %Word8* %93
	%97 = bitcast [20 x %Int32]* %55 to [10 x %Int]*
; if_0
	%98 = bitcast [10 x %Int]* %97 to i8*
	%99 = bitcast [10 x %Int32]* %38 to i8*
	%100 = call i1 (i8*, i8*, i64) @memeq(i8* %98, i8* %99, %Int64 40)
	%101 = icmp ne %Bool %100, 0
	br %Bool %101 , label %then_0, label %else_0
then_0:
	%102 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str5 to [0 x i8]*))
	br label %endif_0
else_0:
	%103 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str6 to [0 x i8]*))
	br label %endif_0
endif_0:

	;	let x = Int8 -1
	;
	;	i32 = Int32 x
	;	u32 = Nat32 x

	; не проверяет дубликаты имен!
	%104 = alloca %Int32, align 4
	store %Int32 1, %Int32* %104
	;var y: Int32 = 0x1  // error!
	%105 = alloca %Word32, align 4
	%106 = zext i8 1 to %Word32
	store %Word32 %106, %Word32* %105
	%107 = alloca %Word32, align 4
	store %Word32 1, %Word32* %107
	%108 = sub i8 0, 1
	%109 = zext %Int8 %108 to %Word32
; if_1
	br %Bool 1 , label %then_1, label %else_1
then_1:
	%110 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str7 to [0 x i8]*))
	br label %endif_1
else_1:
	%111 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str8 to [0 x i8]*))
	br label %endif_1
endif_1:
; if_2
	br %Bool 1 , label %then_2, label %else_2
then_2:
	%112 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str9 to [0 x i8]*))
	br label %endif_2
else_2:
	%113 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([30 x i8]* @str10 to [0 x i8]*))
	br label %endif_2
endif_2:
; if_3
	br %Bool 1 , label %then_3, label %else_3
then_3:
	%114 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str11 to [0 x i8]*))
	br label %endif_3
else_3:
	%115 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([31 x i8]* @str12 to [0 x i8]*))
	br label %endif_3
endif_3:

	;printf("i32 = 0x%08x (%d)\n", i32, i32)
	;printf("u32 = 0x%08x (%d)\n", u32, u32)
	ret %Int32 0
}



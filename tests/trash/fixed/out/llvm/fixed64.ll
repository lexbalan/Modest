
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

; MODULE: fixed64

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
; -- end print includes --
; -- print imports 'fixed64' --
; -- 0
; -- end print imports 'fixed64' --
; -- strings --
@str1 = private constant [15 x i8] [i8 37, i8 108, i8 108, i8 100, i8 43, i8 37, i8 108, i8 108, i8 100, i8 47, i8 37, i8 108, i8 108, i8 100, i8 0]
@str2 = private constant [12 x i8] [i8 32, i8 61, i8 32, i8 37, i8 100, i8 46, i8 37, i8 108, i8 108, i8 100, i8 10, i8 0]
; -- endstrings --
%fixed64_Fixed64 = type %Word64;


; FIXIT! (Word64 Int64 1)
define %fixed64_Fixed64 @fixed64_add(%fixed64_Fixed64 %a, %fixed64_Fixed64 %b) {
	%1 = bitcast %fixed64_Fixed64 %a to %Int64
	%2 = bitcast %fixed64_Fixed64 %b to %Int64
	%3 = add %Int64 %1, %2
	%4 = bitcast %Int64 %3 to %fixed64_Fixed64
	ret %fixed64_Fixed64 %4
}

define %fixed64_Fixed64 @fixed64_sub(%fixed64_Fixed64 %a, %fixed64_Fixed64 %b) {
	%1 = bitcast %fixed64_Fixed64 %a to %Int64
	%2 = bitcast %fixed64_Fixed64 %b to %Int64
	%3 = sub %Int64 %1, %2
	%4 = bitcast %Int64 %3 to %fixed64_Fixed64
	ret %fixed64_Fixed64 %4
}

define %fixed64_Fixed64 @fixed64_mul(%fixed64_Fixed64 %a, %fixed64_Fixed64 %b) {
	%1 = sext %fixed64_Fixed64 %a to %Int128
	%2 = sext %fixed64_Fixed64 %b to %Int128
	%3 = mul %Int128 %1, %2
	%4 = sdiv %Int128 %3, 4294967296
	%5 = trunc %Int128 %4 to %fixed64_Fixed64
	ret %fixed64_Fixed64 %5
}

define %fixed64_Fixed64 @fixed64_div(%fixed64_Fixed64 %a, %fixed64_Fixed64 %b) {
	%1 = sext %fixed64_Fixed64 %a to %Int128
	%2 = sext %fixed64_Fixed64 %b to %Int128
	%3 = mul %Int128 %1, 4294967296
	%4 = sdiv %Int128 %3, %2
	%5 = trunc %Int128 %4 to %fixed64_Fixed64
	ret %fixed64_Fixed64 %5
}

define %fixed64_Fixed64 @fixed64_fromInt32(%Int32 %x) {
	%1 = sext %Int32 %x to %Int64
	%2 = mul %Int64 %1, 4294967296
	%3 = bitcast %Int64 %2 to %fixed64_Fixed64
	ret %fixed64_Fixed64 %3
}

define %Int32 @fixed64_toInt32(%fixed64_Fixed64 %x) {
	%1 = bitcast %fixed64_Fixed64 %x to %Int64
	%2 = sdiv %Int64 %1, 4294967296
	%3 = trunc %Int64 %2 to %Int32
	ret %Int32 %3
}

define %fixed64_Fixed64 @fixed64_head(%fixed64_Fixed64 %x) {
	%1 = call %Int32 @fixed64_toInt32(%fixed64_Fixed64 %x)
	%2 = call %fixed64_Fixed64 @fixed64_fromInt32(%Int32 %1)
	ret %fixed64_Fixed64 %2
}

define %fixed64_Fixed64 @fixed64_tail(%fixed64_Fixed64 %x) {
	%1 = call %fixed64_Fixed64 @fixed64_head(%fixed64_Fixed64 %x)
	%2 = call %fixed64_Fixed64 @fixed64_sub(%fixed64_Fixed64 %x, %fixed64_Fixed64 %1)
	ret %fixed64_Fixed64 %2
}

define %fixed64_Fixed64 @fixed64_create(%Int32 %a, %Int32 %b, %Int32 %c) {
	%1 = call %fixed64_Fixed64 @fixed64_fromInt32(%Int32 %b)
	%2 = call %fixed64_Fixed64 @fixed64_fromInt32(%Int32 %c)
	%3 = call %fixed64_Fixed64 @fixed64_div(%fixed64_Fixed64 %1, %fixed64_Fixed64 %2)
	%4 = call %fixed64_Fixed64 @fixed64_fromInt32(%Int32 %a)
	%5 = call %fixed64_Fixed64 @fixed64_add(%fixed64_Fixed64 %4, %fixed64_Fixed64 %3)
	ret %fixed64_Fixed64 %5
}

define void @fixed64_print(%fixed64_Fixed64 %x) {
	%1 = bitcast %fixed64_Fixed64 %x to %Int64
	%2 = sdiv %Int64 %1, 4294967296
	%3 = alloca %Int64, align 8
	%4 = bitcast %fixed64_Fixed64 %x to %Int64
	%5 = srem %Int64 %4, 4294967296
	store %Int64 %5, %Int64* %3
	%6 = alloca %Int64, align 8
	store %Int64 4294967296, %Int64* %6

	; сокращаем дробную часть
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
; if_0
	%7 = load %Int64, %Int64* %3
	%8 = srem %Int64 %7, 2
	%9 = icmp eq %Int64 %8, 0
	%10 = load %Int64, %Int64* %6
	%11 = srem %Int64 %10, 2
	%12 = icmp eq %Int64 %11, 0
	%13 = and %Bool %9, %12
	br %Bool %13 , label %then_0, label %else_0
then_0:
	%14 = load %Int64, %Int64* %3
	%15 = sdiv %Int64 %14, 2
	store %Int64 %15, %Int64* %3
	%16 = load %Int64, %Int64* %6
	%17 = sdiv %Int64 %16, 2
	store %Int64 %17, %Int64* %6
	br label %endif_0
else_0:
; if_1
	%18 = load %Int64, %Int64* %3
	%19 = srem %Int64 %18, 3
	%20 = icmp eq %Int64 %19, 0
	%21 = load %Int64, %Int64* %6
	%22 = srem %Int64 %21, 3
	%23 = icmp eq %Int64 %22, 0
	%24 = and %Bool %20, %23
	br %Bool %24 , label %then_1, label %else_1
then_1:
	%25 = load %Int64, %Int64* %3
	%26 = sdiv %Int64 %25, 3
	store %Int64 %26, %Int64* %3
	%27 = load %Int64, %Int64* %6
	%28 = sdiv %Int64 %27, 3
	store %Int64 %28, %Int64* %6
	br label %endif_1
else_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%30 = load %Int64, %Int64* %3
	%31 = load %Int64, %Int64* %6
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*), %Int64 %2, %Int64 %30, %Int64 %31)
	%33 = call %Int32 @fixed64_toInt32(%fixed64_Fixed64 %x)
	%34 = call %fixed64_Fixed64 @fixed64_tail(%fixed64_Fixed64 %x)
	%35 = bitcast %fixed64_Fixed64 %34 to %Int64
	%36 = mul %Int64 %35, 1000000
	%37 = sdiv %Int64 %36, 4294967296
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str2 to [0 x i8]*), %Int32 %33, %Int64 %37)
	ret void
}




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

; MODULE: fixed32

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
; -- print imports 'fixed32' --
; -- 0
; -- end print imports 'fixed32' --
; -- strings --
@str1 = private constant [10 x i8] [i8 37, i8 100, i8 43, i8 37, i8 100, i8 47, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --
%fixed32_Fixed32 = type %Word32;
define %fixed32_Fixed32 @fixed32_add(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b) {
	%1 = bitcast %fixed32_Fixed32 %a to %Int32
	%2 = bitcast %fixed32_Fixed32 %b to %Int32
	%3 = add %Int32 %1, %2
	%4 = bitcast %Int32 %3 to %fixed32_Fixed32
	ret %fixed32_Fixed32 %4
}

define %fixed32_Fixed32 @fixed32_sub(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b) {
	%1 = bitcast %fixed32_Fixed32 %a to %Int32
	%2 = bitcast %fixed32_Fixed32 %b to %Int32
	%3 = sub %Int32 %1, %2
	%4 = bitcast %Int32 %3 to %fixed32_Fixed32
	ret %fixed32_Fixed32 %4
}

define %fixed32_Fixed32 @fixed32_mul(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b) {
	%1 = sext %fixed32_Fixed32 %a to %Int64
	%2 = sext %fixed32_Fixed32 %b to %Int64
	%3 = mul %Int64 %1, %2
	%4 = sdiv %Int64 %3, 65536
	%5 = trunc %Int64 %4 to %fixed32_Fixed32
	ret %fixed32_Fixed32 %5
}

define %fixed32_Fixed32 @fixed32_div(%fixed32_Fixed32 %a, %fixed32_Fixed32 %b) {
	%1 = sext %fixed32_Fixed32 %a to %Int64
	%2 = sext %fixed32_Fixed32 %b to %Int64
	%3 = mul %Int64 %1, 65536
	%4 = sdiv %Int64 %3, %2
	%5 = trunc %Int64 %4 to %fixed32_Fixed32
	ret %fixed32_Fixed32 %5
}

define %fixed32_Fixed32 @fixed32_fromInt16(%Int16 %x) {
	%1 = sext %Int16 %x to %Int32
	%2 = mul %Int32 %1, 65536
	%3 = bitcast %Int32 %2 to %fixed32_Fixed32
	ret %fixed32_Fixed32 %3
}

define %Int16 @fixed32_toInt16(%fixed32_Fixed32 %x) {
	%1 = bitcast %fixed32_Fixed32 %x to %Int32
	%2 = sdiv %Int32 %1, 65536
	%3 = trunc %Int32 %2 to %Int16
	ret %Int16 %3
}

define %fixed32_Fixed32 @fixed32_create(%Int16 %a, %Int16 %b, %Int16 %c) {
	%1 = call %fixed32_Fixed32 @fixed32_fromInt16(%Int16 %b)
	%2 = call %fixed32_Fixed32 @fixed32_fromInt16(%Int16 %c)
	%3 = call %fixed32_Fixed32 @fixed32_div(%fixed32_Fixed32 %1, %fixed32_Fixed32 %2)
	%4 = call %fixed32_Fixed32 @fixed32_fromInt16(%Int16 %a)
	%5 = call %fixed32_Fixed32 @fixed32_add(%fixed32_Fixed32 %4, %fixed32_Fixed32 %3)
	ret %fixed32_Fixed32 %5
}

define void @fixed32_print(%fixed32_Fixed32 %x) {
	%1 = bitcast %fixed32_Fixed32 %x to %Int32
	%2 = sdiv %Int32 %1, 65536
	%3 = alloca %Int32, align 4
	%4 = bitcast %fixed32_Fixed32 %x to %Int32
	%5 = srem %Int32 %4, 65536
	store %Int32 %5, %Int32* %3
	%6 = alloca %Int32, align 4
	store %Int32 65536, %Int32* %6

	; сокращаем дробную часть
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
; if_0
	%7 = load %Int32, %Int32* %3
	%8 = srem %Int32 %7, 2
	%9 = icmp eq %Int32 %8, 0
	%10 = load %Int32, %Int32* %6
	%11 = srem %Int32 %10, 2
	%12 = icmp eq %Int32 %11, 0
	%13 = and %Bool %9, %12
	br %Bool %13 , label %then_0, label %else_0
then_0:
	%14 = load %Int32, %Int32* %3
	%15 = sdiv %Int32 %14, 2
	store %Int32 %15, %Int32* %3
	%16 = load %Int32, %Int32* %6
	%17 = sdiv %Int32 %16, 2
	store %Int32 %17, %Int32* %6
	br label %endif_0
else_0:
; if_1
	%18 = load %Int32, %Int32* %3
	%19 = srem %Int32 %18, 3
	%20 = icmp eq %Int32 %19, 0
	%21 = load %Int32, %Int32* %6
	%22 = srem %Int32 %21, 3
	%23 = icmp eq %Int32 %22, 0
	%24 = and %Bool %20, %23
	br %Bool %24 , label %then_1, label %else_1
then_1:
	%25 = load %Int32, %Int32* %3
	%26 = sdiv %Int32 %25, 3
	store %Int32 %26, %Int32* %3
	%27 = load %Int32, %Int32* %6
	%28 = sdiv %Int32 %27, 3
	store %Int32 %28, %Int32* %6
	br label %endif_1
else_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%30 = load %Int32, %Int32* %3
	%31 = load %Int32, %Int32* %6
	%32 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %Int32 %2, %Int32 %30, %Int32 %31)
	ret void
}



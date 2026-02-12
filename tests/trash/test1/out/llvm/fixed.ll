
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

; MODULE: fixed

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
; -- print imports 'fixed' --
; -- 0
; -- end print imports 'fixed' --
; -- strings --
@str1 = private constant [10 x i8] [i8 37, i8 100, i8 43, i8 37, i8 100, i8 47, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --
%fixed_Fixed32 = type %Word32;
define %fixed_Fixed32 @fixed_create(%Int16 %a, %Nat16 %b, %Nat16 %c) {
	%1 = zext %Nat16 %b to %Nat32
	%2 = mul %Nat32 %1, 65536
	%3 = zext %Nat16 %c to %Nat32
	%4 = udiv %Nat32 %2, %3
	%5 = sext %Int16 %a to %Int32
	%6 = mul %Int32 %5, 65536
	%7 = bitcast %Int32 %6 to %Word32
	%8 = bitcast %Nat32 %4 to %Word32
	%9 = or %Word32 %7, %8
	%10 = bitcast %Word32 %9 to %fixed_Fixed32
	ret %fixed_Fixed32 %10
}

define internal %Int16 @head(%fixed_Fixed32 %x) {
	%1 = zext i8 16 to %fixed_Fixed32
	%2 = lshr %fixed_Fixed32 %x, %1
	%3 = trunc %fixed_Fixed32 %2 to %Int16
	ret %Int16 %3
}

define internal %Nat16 @tail(%fixed_Fixed32 %x) {
	%1 = bitcast %fixed_Fixed32 %x to %Word32
	%2 = zext i16 65535 to %Word32
	%3 = and %Word32 %1, %2
	%4 = trunc %Word32 %3 to %Nat16
	ret %Nat16 %4
}

define void @fixed_print(%fixed_Fixed32 %x) {
	%1 = call %Int16 @head(%fixed_Fixed32 %x)
	%2 = alloca %Nat32, align 4
	%3 = call %Nat16 @tail(%fixed_Fixed32 %x)
	%4 = zext %Nat16 %3 to %Nat32
	store %Nat32 %4, %Nat32* %2
	%5 = alloca %Nat32, align 4
	store %Nat32 65536, %Nat32* %5

	; сокращаем дробную часть
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
; if_0
	%6 = load %Nat32, %Nat32* %2
	%7 = urem %Nat32 %6, 2
	%8 = icmp eq %Nat32 %7, 0
	%9 = load %Nat32, %Nat32* %5
	%10 = urem %Nat32 %9, 2
	%11 = icmp eq %Nat32 %10, 0
	%12 = and %Bool %8, %11
	br %Bool %12 , label %then_0, label %else_0
then_0:
	%13 = load %Nat32, %Nat32* %2
	%14 = udiv %Nat32 %13, 2
	store %Nat32 %14, %Nat32* %2
	%15 = load %Nat32, %Nat32* %5
	%16 = udiv %Nat32 %15, 2
	store %Nat32 %16, %Nat32* %5
	br label %endif_0
else_0:
; if_1
	%17 = load %Nat32, %Nat32* %2
	%18 = urem %Nat32 %17, 3
	%19 = icmp eq %Nat32 %18, 0
	%20 = load %Nat32, %Nat32* %5
	%21 = urem %Nat32 %20, 3
	%22 = icmp eq %Nat32 %21, 0
	%23 = and %Bool %19, %22
	br %Bool %23 , label %then_1, label %else_1
then_1:
	%24 = load %Nat32, %Nat32* %2
	%25 = udiv %Nat32 %24, 3
	store %Nat32 %25, %Nat32* %2
	%26 = load %Nat32, %Nat32* %5
	%27 = udiv %Nat32 %26, 3
	store %Nat32 %27, %Nat32* %5
	br label %endif_1
else_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%29 = load %Nat32, %Nat32* %2
	%30 = load %Nat32, %Nat32* %5
	%31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %Int16 %1, %Nat32 %29, %Nat32 %30)
	ret void
}

define %fixed_Fixed32 @fixed_add(%fixed_Fixed32 %a, %fixed_Fixed32 %b) {
	%1 = bitcast %fixed_Fixed32 %a to %Int32
	%2 = bitcast %fixed_Fixed32 %b to %Int32
	%3 = add %Int32 %1, %2
	%4 = bitcast %Int32 %3 to %fixed_Fixed32
	ret %fixed_Fixed32 %4
}

define %fixed_Fixed32 @fixed_sub(%fixed_Fixed32 %a, %fixed_Fixed32 %b) {
	%1 = bitcast %fixed_Fixed32 %a to %Int32
	%2 = bitcast %fixed_Fixed32 %b to %Int32
	%3 = sub %Int32 %1, %2
	%4 = bitcast %Int32 %3 to %fixed_Fixed32
	ret %fixed_Fixed32 %4
}

define %fixed_Fixed32 @fixed_mul(%fixed_Fixed32 %a, %fixed_Fixed32 %b) {
	%1 = sext %fixed_Fixed32 %a to %Int64
	%2 = sext %fixed_Fixed32 %b to %Int64
	%3 = mul %Int64 %1, %2
	%4 = sdiv %Int64 %3, 65536
	%5 = trunc %Int64 %4 to %fixed_Fixed32
	ret %fixed_Fixed32 %5
}

define %fixed_Fixed32 @fixed_div(%fixed_Fixed32 %a, %fixed_Fixed32 %b) {
	%1 = sext %fixed_Fixed32 %a to %Int64
	%2 = sext %fixed_Fixed32 %b to %Int64
	%3 = mul %Int64 %1, 65536
	%4 = sdiv %Int64 %3, %2
	%5 = trunc %Int64 %4 to %fixed_Fixed32
	ret %fixed_Fixed32 %5
}

define %fixed_Fixed32 @fixed_trunc(%fixed_Fixed32 %x) {
	%1 = bitcast %fixed_Fixed32 %x to %Word32
	%2 = and %Word32 %1, 4294901760
	%3 = bitcast %Word32 %2 to %fixed_Fixed32
	ret %fixed_Fixed32 %3
}

define %fixed_Fixed32 @fixed_fract(%fixed_Fixed32 %x) {
	%1 = bitcast %fixed_Fixed32 %x to %Word32
	%2 = and %Word32 %1, 65535
	%3 = bitcast %Word32 %2 to %fixed_Fixed32
	ret %fixed_Fixed32 %3
}



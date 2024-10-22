
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%VA_List = type i8*
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
%Char = type i8;
%ConstChar = type %Char;
%SignedChar = type i8;
%UnsignedChar = type i8;
%Short = type i16;
%UnsignedShort = type i16;
%Int = type i32;
%UnsignedInt = type i32;
%LongInt = type i64;
%UnsignedLongInt = type i64;
%Long = type i64;
%UnsignedLong = type i64;
%LongLong = type i64;
%UnsignedLongLong = type i64;
%LongLongInt = type i64;
%UnsignedLongLongInt = type i64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;
; from included stdio
%File = type i8;
%FposT = type i8;
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
@str1 = private constant [13 x i8] [i8 102, i8 48, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 102, i8 48, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]

%main_Type1 = type {
	i32
};

%main_Type2 = type {
	i32
};

%main_Type3 = type {
	i32
};


@a = global %main_Type1 {
	i32 1
}
@b = global %main_Type2 {
	i32 2
}
@c = global %main_Type3 {
	i32 3
}

define internal void @f0_val(%main_Type1 %x) {
	%1 = extractvalue %main_Type1 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), i32 %1)
	ret void
}

define internal void @f1_val(%main_Type2 %x) {
	%1 = extractvalue %main_Type2 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), i32 %1)
	ret void
}

define internal void @f2_val(%main_Type3 %x) {
	%1 = extractvalue %main_Type3 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), i32 %1)
	ret void
}

define internal void @f3_val({i32} %x) {
	%1 = extractvalue {i32} %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*), i32 %1)
	ret void
}

define internal void @f0_ptr(%main_Type1* %x) {
	%1 = getelementptr inbounds %main_Type1, %main_Type1* %x, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), i32 %2)
	ret void
}

define internal void @f1_ptr(%main_Type2* %x) {
	%1 = getelementptr inbounds %main_Type2, %main_Type2* %x, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), i32 %2)
	ret void
}

define internal void @f2_ptr(%main_Type3* %x) {
	%1 = getelementptr inbounds %main_Type3, %main_Type3* %x, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), i32 %2)
	ret void
}

define internal void @f3_ptr({i32}* %x) {
	%1 = getelementptr inbounds {i32}, {i32}* %x, i32 0, i32 0
	%2 = load i32, i32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), i32 %2)
	ret void
}

define internal void @test_by_value() {
	%1 = load %main_Type1, %main_Type1* @a
	call void @f0_val(%main_Type1 %1)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%2 = bitcast %main_Type1* @a to %main_Type2*
	%3 = load %main_Type2, %main_Type2* %2
	call void @f1_val(%main_Type2 %3)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%4 = bitcast %main_Type1* @a to %main_Type3*
	%5 = load %main_Type3, %main_Type3* %4
	call void @f2_val(%main_Type3 %5)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%6 = bitcast %main_Type1* @a to {i32}*
	%7 = load {i32}, {i32}* %6
	call void @f3_val({i32} %7)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%8 = bitcast %main_Type2* @b to %main_Type1*
	%9 = load %main_Type1, %main_Type1* %8
	call void @f0_val(%main_Type1 %9)
	%10 = load %main_Type2, %main_Type2* @b
	call void @f1_val(%main_Type2 %10)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%11 = bitcast %main_Type2* @b to %main_Type3*
	%12 = load %main_Type3, %main_Type3* %11
	call void @f2_val(%main_Type3 %12)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%13 = bitcast %main_Type2* @b to {i32}*
	%14 = load {i32}, {i32}* %13
	call void @f3_val({i32} %14)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%15 = bitcast %main_Type3* @c to %main_Type1*
	%16 = load %main_Type1, %main_Type1* %15
	call void @f0_val(%main_Type1 %16)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%17 = bitcast %main_Type3* @c to %main_Type2*
	%18 = load %main_Type2, %main_Type2* %17
	call void @f1_val(%main_Type2 %18)
	%19 = load %main_Type3, %main_Type3* @c
	call void @f2_val(%main_Type3 %19)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%20 = bitcast %main_Type3* @c to {i32}*
	%21 = load {i32}, {i32}* %20
	call void @f3_val({i32} %21)
	ret void
}

define internal void @test_by_pointer() {
	%1 = bitcast %main_Type1* @a to %main_Type1*
	call void @f0_ptr(%main_Type1* %1)
	%2 = bitcast %main_Type1* @a to %main_Type2*
	call void @f1_ptr(%main_Type2* %2)
	%3 = bitcast %main_Type1* @a to %main_Type3*
	call void @f2_ptr(%main_Type3* %3)
	%4 = bitcast %main_Type1* @a to {i32}*
	call void @f3_ptr({i32}* %4)
	%5 = bitcast %main_Type2* @b to %main_Type1*
	call void @f0_ptr(%main_Type1* %5)
	%6 = bitcast %main_Type2* @b to %main_Type2*
	call void @f1_ptr(%main_Type2* %6)
	%7 = bitcast %main_Type2* @b to %main_Type3*
	call void @f2_ptr(%main_Type3* %7)
	%8 = bitcast %main_Type2* @b to {i32}*
	call void @f3_ptr({i32}* %8)
	%9 = bitcast %main_Type3* @c to %main_Type1*
	call void @f0_ptr(%main_Type1* %9)
	%10 = bitcast %main_Type3* @c to %main_Type2*
	call void @f1_ptr(%main_Type2* %10)
	%11 = bitcast %main_Type3* @c to %main_Type3*
	call void @f2_ptr(%main_Type3* %11)
	%12 = bitcast %main_Type3* @c to {i32}*
	call void @f3_ptr({i32}* %12)
	ret void
}


define %Int @main() {
	call void @test_by_value()
	call void @test_by_pointer()
	ret %Int 0
}




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
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [13 x i8] [i8 102, i8 48, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 102, i8 48, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --; tests/12.structural_type_system/src/main.m
%Type1 = type {
	%Int32
};

%Type2 = type {
	%Int32
};

%Type3 = type {
	%Int32
};

define internal void @f0_val(%Type1 %x) {
	%1 = extractvalue %Type1 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f1_val(%Type2 %x) {
	%1 = extractvalue %Type2 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f2_val(%Type3 %x) {
	%1 = extractvalue %Type3 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str3 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f3_val({%Int32} %x) {
	%1 = extractvalue {%Int32} %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str4 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @f0_ptr(%Type1* %x) {
	%1 = getelementptr %Type1, %Type1* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f1_ptr(%Type2* %x) {
	%1 = getelementptr %Type2, %Type2* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f2_ptr(%Type3* %x) {
	%1 = getelementptr %Type3, %Type3* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @f3_ptr({%Int32}* %x) {
	%1 = getelementptr {%Int32}, {%Int32}* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), %Int32 %2)
	ret void
}

@a = internal global %Type1 {
	%Int32 1
}
@b = internal global %Type2 {
	%Int32 2
}
@c = internal global %Type3 {
	%Int32 3
}
define internal void @test_by_value() {
; -- cons_composite_from_composite_by_adr --
	%1 = bitcast %Type1* @a to %Type1*
	%2 = load %Type1, %Type1* %1
; -- end cons_composite_from_composite_by_adr --
	call void @f0_val(%Type1 %2)
; -- cons_composite_from_composite_by_adr --
	%3 = bitcast %Type1* @a to %Type2*
	%4 = load %Type2, %Type2* %3
; -- end cons_composite_from_composite_by_adr --
	call void @f1_val(%Type2 %4)
; -- cons_composite_from_composite_by_adr --
	%5 = bitcast %Type1* @a to %Type3*
	%6 = load %Type3, %Type3* %5
; -- end cons_composite_from_composite_by_adr --
	call void @f2_val(%Type3 %6)
; -- cons_composite_from_composite_by_adr --
	%7 = bitcast %Type1* @a to {%Int32}*
	%8 = load {%Int32}, {%Int32}* %7
; -- end cons_composite_from_composite_by_adr --
	call void @f3_val({%Int32} %8)
; -- cons_composite_from_composite_by_adr --
	%9 = bitcast %Type2* @b to %Type1*
	%10 = load %Type1, %Type1* %9
; -- end cons_composite_from_composite_by_adr --
	call void @f0_val(%Type1 %10)
; -- cons_composite_from_composite_by_adr --
	%11 = bitcast %Type2* @b to %Type2*
	%12 = load %Type2, %Type2* %11
; -- end cons_composite_from_composite_by_adr --
	call void @f1_val(%Type2 %12)
; -- cons_composite_from_composite_by_adr --
	%13 = bitcast %Type2* @b to %Type3*
	%14 = load %Type3, %Type3* %13
; -- end cons_composite_from_composite_by_adr --
	call void @f2_val(%Type3 %14)
; -- cons_composite_from_composite_by_adr --
	%15 = bitcast %Type2* @b to {%Int32}*
	%16 = load {%Int32}, {%Int32}* %15
; -- end cons_composite_from_composite_by_adr --
	call void @f3_val({%Int32} %16)
; -- cons_composite_from_composite_by_adr --
	%17 = bitcast %Type3* @c to %Type1*
	%18 = load %Type1, %Type1* %17
; -- end cons_composite_from_composite_by_adr --
	call void @f0_val(%Type1 %18)
; -- cons_composite_from_composite_by_adr --
	%19 = bitcast %Type3* @c to %Type2*
	%20 = load %Type2, %Type2* %19
; -- end cons_composite_from_composite_by_adr --
	call void @f1_val(%Type2 %20)
; -- cons_composite_from_composite_by_adr --
	%21 = bitcast %Type3* @c to %Type3*
	%22 = load %Type3, %Type3* %21
; -- end cons_composite_from_composite_by_adr --
	call void @f2_val(%Type3 %22)
; -- cons_composite_from_composite_by_adr --
	%23 = bitcast %Type3* @c to {%Int32}*
	%24 = load {%Int32}, {%Int32}* %23
; -- end cons_composite_from_composite_by_adr --
	call void @f3_val({%Int32} %24)
	ret void
}

define internal void @test_by_pointer() {
	call void @f0_ptr(%Type1* bitcast (%Type1* @a to %Type1*))
	call void @f1_ptr(%Type2* bitcast (%Type1* @a to %Type2*))
	call void @f2_ptr(%Type3* bitcast (%Type1* @a to %Type3*))
	call void @f3_ptr({%Int32}* bitcast (%Type1* @a to {%Int32}*))
	call void @f0_ptr(%Type1* bitcast (%Type2* @b to %Type1*))
	call void @f1_ptr(%Type2* bitcast (%Type2* @b to %Type2*))
	call void @f2_ptr(%Type3* bitcast (%Type2* @b to %Type3*))
	call void @f3_ptr({%Int32}* bitcast (%Type2* @b to {%Int32}*))
	call void @f0_ptr(%Type1* bitcast (%Type3* @c to %Type1*))
	call void @f1_ptr(%Type2* bitcast (%Type3* @c to %Type2*))
	call void @f2_ptr(%Type3* bitcast (%Type3* @c to %Type3*))
	call void @f3_ptr({%Int32}* bitcast (%Type3* @c to {%Int32}*))
	ret void
}

define %Int @main() {
	call void @test_by_value()
	call void @test_by_pointer()
	ret %Int 0
}



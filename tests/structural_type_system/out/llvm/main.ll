
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Fixed32 = type i32
%Fixed64 = type i64
%Size = type i64
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
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@.str1 = private constant [13 x i8] [i8 102, i8 49, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str2 = private constant [13 x i8] [i8 102, i8 50, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str3 = private constant [13 x i8] [i8 102, i8 51, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str4 = private constant [13 x i8] [i8 102, i8 52, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str5 = private constant [14 x i8] [i8 102, i8 49, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str6 = private constant [14 x i8] [i8 102, i8 50, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str7 = private constant [14 x i8] [i8 102, i8 51, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@.str8 = private constant [14 x i8] [i8 102, i8 52, i8 112, i8 32, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
; -- endstrings --
%main_Type1 = type {
	%Int32
};

%main_Type2 = type {
	%Int32
};

%main_Type3 = type {
	%Int32
};



; Check by value
define internal void @main_f1_val(%main_Type1 %x) {
	%1 = extractvalue %main_Type1 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str1 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @main_f2_val(%main_Type2 %x) {
	%1 = extractvalue %main_Type2 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str2 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @main_f3_val(%main_Type3 %x) {
	%1 = extractvalue %main_Type3 %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str3 to [0 x i8]*), %Int32 %1)
	ret void
}

define internal void @main_f4_val({%Int32} %x) {
	%1 = extractvalue {%Int32} %x, 0
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @.str4 to [0 x i8]*), %Int32 %1)
	ret void
}



; Check by pointer
define internal void @main_f1_ptr(%main_Type1* %x) {
	%1 = getelementptr %main_Type1, %main_Type1* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str5 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @main_f2_ptr(%main_Type2* %x) {
	%1 = getelementptr %main_Type2, %main_Type2* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str6 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @main_f3_ptr(%main_Type3* %x) {
	%1 = getelementptr %main_Type3, %main_Type3* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str7 to [0 x i8]*), %Int32 %2)
	ret void
}

define internal void @main_f4_ptr({%Int32}* %x) {
	%1 = getelementptr {%Int32}, {%Int32}* %x, %Int32 0, %Int32 0
	%2 = load %Int32, %Int32* %1
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @.str8 to [0 x i8]*), %Int32 %2)
	ret void
}

@main_a = internal global %main_Type1 {
	%Int32 1
}
@main_b = internal global %main_Type2 {
	%Int32 2
}
@main_c = internal global %main_Type3 {
	%Int32 3
}
define internal void @main_test_by_value() {
	call void @main_f1_val(%main_Type1 zeroinitializer)
	call void @main_f2_val(%main_Type2 zeroinitializer)
	call void @main_f3_val(%main_Type3 zeroinitializer)
	call void @main_f4_val({%Int32} zeroinitializer)
	call void @main_f1_val(%main_Type1 zeroinitializer)
	call void @main_f2_val(%main_Type2 zeroinitializer)
	call void @main_f3_val(%main_Type3 zeroinitializer)
	call void @main_f4_val({%Int32} zeroinitializer)
	%1 = load %main_Type1, %main_Type1* @main_a
	call void @main_f1_val(%main_Type1 %1)
; -- cons_composite_from_composite_by_adr --
	%2 = bitcast %main_Type1* @main_a to %main_Type2*
	%3 = load %main_Type2, %main_Type2* %2
; -- end cons_composite_from_composite_by_adr --
	call void @main_f2_val(%main_Type2 %3)
; -- cons_composite_from_composite_by_adr --
	%4 = bitcast %main_Type1* @main_a to %main_Type3*
	%5 = load %main_Type3, %main_Type3* %4
; -- end cons_composite_from_composite_by_adr --
	call void @main_f3_val(%main_Type3 %5)
; -- cons_composite_from_composite_by_adr --
	%6 = bitcast %main_Type1* @main_a to {%Int32}*
	%7 = load {%Int32}, {%Int32}* %6
; -- end cons_composite_from_composite_by_adr --
	call void @main_f4_val({%Int32} %7)
; -- cons_composite_from_composite_by_adr --
	%8 = bitcast %main_Type2* @main_b to %main_Type1*
	%9 = load %main_Type1, %main_Type1* %8
; -- end cons_composite_from_composite_by_adr --
	call void @main_f1_val(%main_Type1 %9)
	%10 = load %main_Type2, %main_Type2* @main_b
	call void @main_f2_val(%main_Type2 %10)
; -- cons_composite_from_composite_by_adr --
	%11 = bitcast %main_Type2* @main_b to %main_Type3*
	%12 = load %main_Type3, %main_Type3* %11
; -- end cons_composite_from_composite_by_adr --
	call void @main_f3_val(%main_Type3 %12)
; -- cons_composite_from_composite_by_adr --
	%13 = bitcast %main_Type2* @main_b to {%Int32}*
	%14 = load {%Int32}, {%Int32}* %13
; -- end cons_composite_from_composite_by_adr --
	call void @main_f4_val({%Int32} %14)
; -- cons_composite_from_composite_by_adr --
	%15 = bitcast %main_Type3* @main_c to %main_Type1*
	%16 = load %main_Type1, %main_Type1* %15
; -- end cons_composite_from_composite_by_adr --
	call void @main_f1_val(%main_Type1 %16)
; -- cons_composite_from_composite_by_adr --
	%17 = bitcast %main_Type3* @main_c to %main_Type2*
	%18 = load %main_Type2, %main_Type2* %17
; -- end cons_composite_from_composite_by_adr --
	call void @main_f2_val(%main_Type2 %18)
	%19 = load %main_Type3, %main_Type3* @main_c
	call void @main_f3_val(%main_Type3 %19)
; -- cons_composite_from_composite_by_adr --
	%20 = bitcast %main_Type3* @main_c to {%Int32}*
	%21 = load {%Int32}, {%Int32}* %20
; -- end cons_composite_from_composite_by_adr --
	call void @main_f4_val({%Int32} %21)
	ret void
}

define internal void @main_test_by_pointer() {
	call void @main_f1_ptr(%main_Type1* @main_a)
	%1 = bitcast %main_Type1* @main_a to %main_Type2*
	call void @main_f2_ptr(%main_Type2* %1)
	%2 = bitcast %main_Type1* @main_a to %main_Type3*
	call void @main_f3_ptr(%main_Type3* %2)
	%3 = bitcast %main_Type1* @main_a to {%Int32}*
	call void @main_f4_ptr({%Int32}* %3)
	%4 = bitcast %main_Type2* @main_b to %main_Type1*
	call void @main_f1_ptr(%main_Type1* %4)
	call void @main_f2_ptr(%main_Type2* @main_b)
	%5 = bitcast %main_Type2* @main_b to %main_Type3*
	call void @main_f3_ptr(%main_Type3* %5)
	%6 = bitcast %main_Type2* @main_b to {%Int32}*
	call void @main_f4_ptr({%Int32}* %6)
	%7 = bitcast %main_Type3* @main_c to %main_Type1*
	call void @main_f1_ptr(%main_Type1* %7)
	%8 = bitcast %main_Type3* @main_c to %main_Type2*
	call void @main_f2_ptr(%main_Type2* %8)
	call void @main_f3_ptr(%main_Type3* @main_c)
	%9 = bitcast %main_Type3* @main_c to {%Int32}*
	call void @main_f4_ptr({%Int32}* %9)
	ret void
}

define %Int @main() {
	call void @main_test_by_value()
	call void @main_test_by_pointer()
	ret %Int 0
}



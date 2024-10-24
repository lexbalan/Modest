
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
@str1 = private constant [14 x i8] [i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str9 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str10 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str11 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str12 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str13 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]

%main_Point2D = type {
	i32, 
	i32
};

%main_Point3D = type {
	i32, 
	i32, 
	i32
};



define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*))
	; compare two Point2D records
	%2 = alloca %main_Point2D, align 4
	%3 = insertvalue %main_Point2D zeroinitializer, i32 1, 0
	%4 = insertvalue %main_Point2D %3, i32 2, 1
	store %main_Point2D %4, %main_Point2D* %2
	%5 = alloca %main_Point2D, align 4
	%6 = insertvalue %main_Point2D zeroinitializer, i32 10, 0
	%7 = insertvalue %main_Point2D %6, i32 20, 1
	store %main_Point2D %7, %main_Point2D* %5
	%8 = bitcast %main_Point2D* %2 to i8*
	%9 = bitcast %main_Point2D* %5 to i8*
	
	%10 = call i1 (i8*, i8*, i64) @memeq( i8* %8, i8* %9, i64 8)
	%11 = icmp ne i1 %10, 0
	br i1 %11 , label %then_0, label %else_0
then_0:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	; compare Point2D with anonymous record
	%14 = alloca %main_Point2D, align 4
	%15 = load %main_Point2D, %main_Point2D* %2
	store %main_Point2D %15, %main_Point2D* %14
	%16 = alloca {i32, i32}, align 4
	%17 = insertvalue {i32, i32} zeroinitializer, i32 1, 0
	%18 = insertvalue {i32, i32} %17, i32 2, 1
	store {i32, i32} %18, {i32, i32}* %16
	; cast_composite_to_composite
	; JUST
	; as ptr
	%19 = bitcast %main_Point2D* %14 to {i32, i32}*
	%20 = load {i32, i32}, {i32, i32}* %19
	%21 = alloca {i32, i32}
	store {i32, i32} %20, {i32, i32}* %21
	%22 = bitcast {i32, i32}* %21 to i8*
	%23 = bitcast {i32, i32}* %16 to i8*
	
	%24 = call i1 (i8*, i8*, i64) @memeq( i8* %22, i8* %23, i64 8)
	%25 = icmp ne i1 %24, 0
	br i1 %25 , label %then_1, label %else_1
then_1:
	%26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	; comparison between two anonymous record
	%28 = alloca {i32, i32}, align 4
	%29 = insertvalue {i32, i32} zeroinitializer, i32 1, 0
	%30 = insertvalue {i32, i32} %29, i32 2, 1
	store {i32, i32} %30, {i32, i32}* %28
	; cast_composite_to_composite
	; JUST
	; as ptr
	%31 = bitcast {i32, i32}* %16 to {i32, i32}*
	%32 = load {i32, i32}, {i32, i32}* %31
	%33 = alloca {i32, i32}
	store {i32, i32} %32, {i32, i32}* %33
	%34 = bitcast {i32, i32}* %33 to i8*
	%35 = bitcast {i32, i32}* %28 to i8*
	
	%36 = call i1 (i8*, i8*, i64) @memeq( i8* %34, i8* %35, i64 8)
	%37 = icmp ne i1 %36, 0
	br i1 %37 , label %then_2, label %else_2
then_2:
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	; comparison between two record (by pointer)
	; cast_composite_to_composite
	; JUST
	; as ptr
	%40 = bitcast %main_Point2D* %14 to {i32, i32}*
	%41 = load {i32, i32}, {i32, i32}* %40
	%42 = alloca {i32, i32}
	store {i32, i32} %41, {i32, i32}* %42
	%43 = bitcast {i32, i32}* %42 to i8*
	%44 = bitcast {i32, i32}* %16 to i8*
	
	%45 = call i1 (i8*, i8*, i64) @memeq( i8* %43, i8* %44, i64 8)
	%46 = icmp ne i1 %45, 0
	br i1 %46 , label %then_3, label %else_3
then_3:
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%48 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	; assign record by pointer
	%49 = insertvalue %main_Point2D zeroinitializer, i32 100, 0
	%50 = insertvalue %main_Point2D %49, i32 200, 1
	store %main_Point2D %50, %main_Point2D* %14
	store {i32, i32} zeroinitializer, {i32, i32}* %16
	; cons Point3D from Point2D (record extension)
	; (it is possible if dst record contained all fields from src record
	; and their types are equal)
	%51 = alloca %main_Point3D, align 4
	; cast_composite_to_composite
	; JUST
	; as ptr
	%52 = bitcast %main_Point2D* %14 to %main_Point3D*
	%53 = load %main_Point3D, %main_Point3D* %52
	store %main_Point3D %53, %main_Point3D* %51
	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%54 = alloca i32, align 4
	store i32 10, i32* %54
	%55 = alloca i32, align 4
	store i32 20, i32* %55
	%56 = load i32, i32* %54
	%57 = insertvalue {i32, i32} zeroinitializer, i32 %56, 0
	%58 = load i32, i32* %55
	%59 = insertvalue {i32, i32} %57, i32 %58, 1
	store i32 111, i32* %54
	store i32 222, i32* %55
	%60 = extractvalue {i32, i32} %59, 0
	%61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str10 to [0 x i8]*), i32 %60)
	%62 = extractvalue {i32, i32} %59, 1
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str11 to [0 x i8]*), i32 %62)
	%64 = insertvalue {i32, i32} zeroinitializer, i32 10, 0
	%65 = insertvalue {i32, i32} %64, i32 20, 1
	%66 = alloca {i32, i32}
	store {i32, i32} %59, {i32, i32}* %66
	%67 = alloca {i32, i32}
	store {i32, i32} %65, {i32, i32}* %67
	%68 = bitcast {i32, i32}* %66 to i8*
	%69 = bitcast {i32, i32}* %67 to i8*
	
	%70 = call i1 (i8*, i8*, i64) @memeq( i8* %68, i8* %69, i64 8)
	%71 = icmp ne i1 %70, 0
	br i1 %71 , label %then_4, label %else_4
then_4:
	%72 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str12 to [0 x i8]*))
	br label %endif_4
else_4:
	%73 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str13 to [0 x i8]*))
	br label %endif_4
endif_4:
	ret %Int 0
}



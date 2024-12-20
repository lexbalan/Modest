
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
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
@str1 = private constant [14 x i8] [i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [13 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@str3 = private constant [17 x i8] [i8 118, i8 101, i8 114, i8 115, i8 105, i8 111, i8 110, i8 32, i8 110, i8 111, i8 116, i8 32, i8 48, i8 46, i8 55, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str9 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str10 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 61, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 42, i8 112, i8 114, i8 50, i8 32, i8 33, i8 61, i8 32, i8 42, i8 112, i8 114, i8 51, i8 10, i8 0]
@str12 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 120, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 49, i8 48, i8 41, i8 10, i8 0]
@str13 = private constant [24 x i8] [i8 112, i8 120, i8 46, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 32, i8 40, i8 109, i8 117, i8 115, i8 116, i8 32, i8 98, i8 101, i8 32, i8 50, i8 48, i8 41, i8 10, i8 0]
@str14 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str15 = private constant [13 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
; -- endstrings --

%Point2D = type {
	%Int32,
	%Int32
};

%Point3D = type {
	%Int32,
	%Int32,
	%Int32
};



define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*))
	; check value_record_eq for immediate values
	%2 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 7, 1
	br %Bool 1 , label %then_0, label %else_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	; compare two Point2D records
	%5 = alloca %Point2D, align 4
	%6 = insertvalue %Point2D zeroinitializer, %Int32 1, 0
	%7 = insertvalue %Point2D %6, %Int32 2, 1
	store %Point2D %7, %Point2D* %5
	%8 = alloca %Point2D, align 4
	%9 = insertvalue %Point2D zeroinitializer, %Int32 10, 0
	%10 = insertvalue %Point2D %9, %Int32 20, 1
	store %Point2D %10, %Point2D* %8
	%11 = bitcast %Point2D* %5 to i8*
	%12 = bitcast %Point2D* %8 to i8*
	
	%13 = call i1 (i8*, i8*, i64) @memeq( i8* %11, i8* %12, %Int64 8)
	%14 = icmp eq %Bool %13, 0
	br %Bool %14 , label %then_1, label %else_1
then_1:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	; compare Point2D with anonymous record
	%17 = alloca %Point2D, align 4
	%18 = load %Point2D, %Point2D* %5
	store %Point2D %18, %Point2D* %17
	%19 = alloca {%Int32,%Int32}, align 4
	%20 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 1, 0
	%21 = insertvalue {%Int32,%Int32} %20, %Int32 2, 1
	store {%Int32,%Int32} %21, {%Int32,%Int32}* %19
; -- cons_composite_from_composite_by_adr --
	%22 = bitcast {%Int32,%Int32}* %19 to %Point2D*
	%23 = load %Point2D, %Point2D* %22
; -- end cons_composite_from_composite_by_adr --
	%24 = alloca %Point2D
	store %Point2D %23, %Point2D* %24
	%25 = bitcast %Point2D* %17 to i8*
	%26 = bitcast %Point2D* %24 to i8*
	
	%27 = call i1 (i8*, i8*, i64) @memeq( i8* %25, i8* %26, %Int64 8)
	%28 = icmp eq %Bool %27, 0
	br %Bool %28 , label %then_2, label %else_2
then_2:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	; comparison between two anonymous record
	%31 = alloca {%Int32,%Int32}, align 4
	%32 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 1, 0
	%33 = insertvalue {%Int32,%Int32} %32, %Int32 2, 1
	store {%Int32,%Int32} %33, {%Int32,%Int32}* %31
; -- cons_composite_from_composite_by_adr --
	%34 = bitcast {%Int32,%Int32}* %31 to {%Int32,%Int32}*
	%35 = load {%Int32,%Int32}, {%Int32,%Int32}* %34
; -- end cons_composite_from_composite_by_adr --
	%36 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %35, {%Int32,%Int32}* %36
	%37 = bitcast {%Int32,%Int32}* %19 to i8*
	%38 = bitcast {%Int32,%Int32}* %36 to i8*
	
	%39 = call i1 (i8*, i8*, i64) @memeq( i8* %37, i8* %38, %Int64 8)
	%40 = icmp eq %Bool %39, 0
	br %Bool %40 , label %then_3, label %else_3
then_3:
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%42 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	; comparison between two record (by pointer)
; -- cons_composite_from_composite_by_adr --
	%43 = bitcast {%Int32,%Int32}* %19 to %Point2D*
	%44 = load %Point2D, %Point2D* %43
; -- end cons_composite_from_composite_by_adr --
	%45 = alloca %Point2D
	store %Point2D %44, %Point2D* %45
	%46 = bitcast %Point2D* %17 to i8*
	%47 = bitcast %Point2D* %45 to i8*
	
	%48 = call i1 (i8*, i8*, i64) @memeq( i8* %46, i8* %47, %Int64 8)
	%49 = icmp eq %Bool %48, 0
	br %Bool %49 , label %then_4, label %else_4
then_4:
	%50 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str10 to [0 x i8]*))
	br label %endif_4
else_4:
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str11 to [0 x i8]*))
	br label %endif_4
endif_4:
	; assign record by pointer
	%52 = insertvalue %Point2D zeroinitializer, %Int32 100, 0
	%53 = insertvalue %Point2D %52, %Int32 200, 1
	store %Point2D %53, %Point2D* %17
	store {%Int32,%Int32} zeroinitializer, {%Int32,%Int32}* %19
	; cons Point3D from Point2D (record extension)
	; (it is possible if dst record contained all fields from src record
	; and their types are equal)
	%54 = alloca %Point3D, align 4
; -- cons_composite_from_composite_by_adr --
	%55 = bitcast %Point2D* %17 to %Point3D*
	%56 = load %Point3D, %Point3D* %55
; -- end cons_composite_from_composite_by_adr --
	store %Point3D %56, %Point3D* %54
	; проверка того как локальная константа-массив
	; "замораживает" свои элементы
	%57 = alloca %Int32, align 4
	store %Int32 10, %Int32* %57
	%58 = alloca %Int32, align 4
	store %Int32 20, %Int32* %58
	%59 = load %Int32, %Int32* %57
	%60 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 %59, 0
	%61 = load %Int32, %Int32* %58
	%62 = insertvalue {%Int32,%Int32} %60, %Int32 %61, 1
	store %Int32 111, %Int32* %57
	store %Int32 222, %Int32* %58
	%63 = extractvalue {%Int32,%Int32} %62, 0
	%64 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str12 to [0 x i8]*), %Int32 %63)
	%65 = extractvalue {%Int32,%Int32} %62, 1
	%66 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([24 x i8]* @str13 to [0 x i8]*), %Int32 %65)
	%67 = insertvalue {%Int32,%Int32} zeroinitializer, %Int32 10, 0
	%68 = insertvalue {%Int32,%Int32} %67, %Int32 20, 1
	%69 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %62, {%Int32,%Int32}* %69
	%70 = alloca {%Int32,%Int32}
	store {%Int32,%Int32} %68, {%Int32,%Int32}* %70
	%71 = bitcast {%Int32,%Int32}* %69 to i8*
	%72 = bitcast {%Int32,%Int32}* %70 to i8*
	
	%73 = call i1 (i8*, i8*, i64) @memeq( i8* %71, i8* %72, %Int64 8)
	%74 = icmp eq %Bool %73, 0
	br %Bool %74 , label %then_5, label %else_5
then_5:
	%75 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str14 to [0 x i8]*))
	br label %endif_5
else_5:
	%76 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str15 to [0 x i8]*))
	br label %endif_5
endif_5:
	ret %Int 0
}



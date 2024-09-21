
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

; print includes

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


%SocklenT = type i32;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


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
; end print includes
; -- strings --
@str1 = private constant [20 x i8] [i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 32, i8 116, i8 121, i8 112, i8 101, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str3 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str4 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str5 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 102, i8 108, i8 111, i8 97, i8 116, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str6 = private constant [26 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 99, i8 104, i8 97, i8 114, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [26 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 99, i8 104, i8 97, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str8 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str9 = private constant [27 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 97, i8 114, i8 114, i8 97, i8 121, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str10 = private constant [28 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 32, i8 112, i8 97, i8 115, i8 115, i8 101, i8 100, i8 10, i8 0]
@str11 = private constant [29 x i8] [i8 116, i8 101, i8 115, i8 116, i8 95, i8 103, i8 101, i8 110, i8 101, i8 114, i8 105, i8 99, i8 95, i8 105, i8 110, i8 116, i8 101, i8 103, i8 101, i8 114, i8 32, i8 102, i8 97, i8 105, i8 108, i8 101, i8 100, i8 10, i8 0]
@str12 = private constant [26 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 97, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 98, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str14 = private constant [19 x i8] [i8 99, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str15 = private constant [37 x i8] [i8 100, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 93, i8 10, i8 0]


%Point2D = type {
	i32, 
	i32
};

%Point3D = type {
	i32, 
	i32, 
	i32
};


define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str1 to [0 x i8]*))
	%2 = call i1 @test_generic_integer()
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
	br label %endif_0
else_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*))
	br label %endif_0
endif_0:
	%5 = call i1 @test_generic_float()
	br i1 %5 , label %then_1, label %else_1
then_1:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
	br label %endif_1
else_1:
	%7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
	br label %endif_1
endif_1:
	%8 = call i1 @test_generic_char()
	br i1 %8 , label %then_2, label %else_2
then_2:
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
	br label %endif_2
else_2:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str7 to [0 x i8]*))
	br label %endif_2
endif_2:
	%11 = call i1 @test_generic_array()
	br i1 %11 , label %then_3, label %else_3
then_3:
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str8 to [0 x i8]*))
	br label %endif_3
else_3:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str9 to [0 x i8]*))
	br label %endif_3
endif_3:
	%14 = call i1 @test_generic_record()
	br i1 %14 , label %then_4, label %else_4
then_4:
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str10 to [0 x i8]*))
	br label %endif_4
else_4:
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str11 to [0 x i8]*))
	br label %endif_4
endif_4:
	ret %Int 0
}

define i1 @test_generic_integer() {
	; Any integer literal have GenericInteger type
	; result of such expressions also have generic type
	; GenericInteger value can be implicitly casted to any Integer type
	%1 = alloca i32, align 4
	store i32 1, i32* %1
	%2 = alloca i64, align 8
	store i64 1, i64* %2
	; to Float
	%3 = alloca float, align 4
	store float 1.0000000000000000, float* %3
	%4 = alloca double, align 8
	store double 1.0000000000000000, double* %4
	; and to Byte
	%5 = alloca %Byte, align 1
	store %Byte 1, %Byte* %5
	; explicit cast GenericInteger value
	%6 = alloca i8, align 1
	store i8 1, i8* %6
	%7 = alloca i16, align 2
	store i16 1, i16* %7
	%8 = alloca i32, align 4
	store i32 1, i32* %8
	%9 = alloca i1, align 1
	store i1 1, i1* %9
	ret i1 1
}

define i1 @test_generic_float() {
	; Any float literal have GenericFloat type
	; value with GenericFloat type
	; can be implicit casted to any Float type
	; (in this case value may lose precision)
	%1 = alloca float, align 4
	store float 3.1415927410125732, float* %1
	%2 = alloca double, align 8
	store double 3.1415926535897931, double* %2
	; explicit cast GenericFloat value to Int32
	%3 = alloca i32, align 4
	store i32 3, i32* %3
	ret i1 1
}

define i1 @test_generic_char() {
	; Any char value expression have GenericChar type
	; (you can pick GenericChar value by index of GenericString value)
	; value with GenericChar type
	; can be implicit casted to any Char type
	%1 = alloca i8, align 1
	store i8 65, i8* %1
	%2 = alloca i16, align 2
	store i16 65, i16* %2
	%3 = alloca i32, align 4
	store i32 65, i32* %3
	; explicit cast GenericChar value to Int32
	%4 = alloca i32, align 4
	store i32 65, i32* %4
	ret i1 1
}

define i1 @test_generic_array() {
	; Any array expression have GenericArray type
	; this array expression (GenericArray of four GenericInteger items)
	%1 = insertvalue [4 x i2] zeroinitializer, i2 0, 0
	%2 = insertvalue [4 x i2] %1, i2 1, 1
	%3 = insertvalue [4 x i2] %2, i2 2, 2
	%4 = insertvalue [4 x i2] %3, i2 3, 3
	%5 = alloca [4 x i2]
	store [4 x i2] %4, [4 x i2]* %5
	br i1 0 , label %then_0, label %endif_0
then_0:
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str12 to [0 x i8]*))
	ret i1 0
	br label %endif_0
endif_0:
	; value with GenericArray type
	; can be implicit casted to Array with compatible type and same size
	; implicit cast Generic([4]GenericInteger) value to [4]Int32
	%8 = alloca [4 x i32], align 4
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%9 = zext i3 4 to i32
	; -- end vol eval --
	%10 = insertvalue [4 x i32] zeroinitializer, i32 0, 0
	%11 = insertvalue [4 x i32] %10, i32 1, 1
	%12 = insertvalue [4 x i32] %11, i32 2, 2
	%13 = insertvalue [4 x i32] %12, i32 3, 3
	store [4 x i32] %13, [4 x i32]* %8
	%14 = insertvalue [4 x i32] zeroinitializer, i32 0, 0
	%15 = insertvalue [4 x i32] %14, i32 1, 1
	%16 = insertvalue [4 x i32] %15, i32 2, 2
	%17 = insertvalue [4 x i32] %16, i32 3, 3
	%18 = alloca [4 x i32]
	store [4 x i32] %17, [4 x i32]* %18
	%19 = bitcast [4 x i32]* %8 to i8*
	%20 = bitcast [4 x i32]* %18 to i8*
	
	%21 = call i1 (i8*, i8*, i64) @memeq( i8* %19, i8* %20, i64 16)
	%22 = icmp eq i1 %21, 0
	br i1 %22 , label %then_1, label %endif_1
then_1:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*))
	ret i1 0
	br label %endif_1
endif_1:
	; implicit cast Generic([4]GenericInteger) value to [4]Nat64
	%25 = alloca [4 x i64], align 8
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%26 = zext i3 4 to i32
	; -- end vol eval --
	%27 = insertvalue [4 x i64] zeroinitializer, i64 0, 0
	%28 = insertvalue [4 x i64] %27, i64 1, 1
	%29 = insertvalue [4 x i64] %28, i64 2, 2
	%30 = insertvalue [4 x i64] %29, i64 3, 3
	store [4 x i64] %30, [4 x i64]* %25
	%31 = insertvalue [4 x i64] zeroinitializer, i64 0, 0
	%32 = insertvalue [4 x i64] %31, i64 1, 1
	%33 = insertvalue [4 x i64] %32, i64 2, 2
	%34 = insertvalue [4 x i64] %33, i64 3, 3
	%35 = alloca [4 x i64]
	store [4 x i64] %34, [4 x i64]* %35
	%36 = bitcast [4 x i64]* %25 to i8*
	%37 = bitcast [4 x i64]* %35 to i8*
	
	%38 = call i1 (i8*, i8*, i64) @memeq( i8* %36, i8* %37, i64 32)
	%39 = icmp eq i1 %38, 0
	br i1 %39 , label %then_2, label %endif_2
then_2:
	%40 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str14 to [0 x i8]*))
	ret i1 0
	br label %endif_2
endif_2:
	; explicit cast Generic([4]GenericInteger) value to [10]Int32
	%42 = alloca [10 x i32], align 4
	%43 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%44 = insertvalue [10 x i32] %43, i32 1, 1
	%45 = insertvalue [10 x i32] %44, i32 2, 2
	%46 = insertvalue [10 x i32] %45, i32 3, 3
	%47 = insertvalue [10 x i32] %46, i32 0, 4
	%48 = insertvalue [10 x i32] %47, i32 0, 5
	%49 = insertvalue [10 x i32] %48, i32 0, 6
	%50 = insertvalue [10 x i32] %49, i32 0, 7
	%51 = insertvalue [10 x i32] %50, i32 0, 8
	%52 = insertvalue [10 x i32] %51, i32 0, 9
	store [10 x i32] %52, [10 x i32]* %42
	%53 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
	%54 = insertvalue [10 x i32] %53, i32 1, 1
	%55 = insertvalue [10 x i32] %54, i32 2, 2
	%56 = insertvalue [10 x i32] %55, i32 3, 3
	%57 = insertvalue [10 x i32] %56, i32 0, 4
	%58 = insertvalue [10 x i32] %57, i32 0, 5
	%59 = insertvalue [10 x i32] %58, i32 0, 6
	%60 = insertvalue [10 x i32] %59, i32 0, 7
	%61 = insertvalue [10 x i32] %60, i32 0, 8
	%62 = insertvalue [10 x i32] %61, i32 0, 9
	%63 = alloca [10 x i32]
	store [10 x i32] %62, [10 x i32]* %63
	%64 = bitcast [10 x i32]* %42 to i8*
	%65 = bitcast [10 x i32]* %63 to i8*
	
	%66 = call i1 (i8*, i8*, i64) @memeq( i8* %64, i8* %65, i64 40)
	%67 = icmp eq i1 %66, 0
	br i1 %67 , label %then_3, label %endif_3
then_3:
	%68 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str15 to [0 x i8]*))
	ret i1 0
	br label %endif_3
endif_3:
	ret i1 1
}

define i1 @test_generic_record() {
	; Any record expression have GenericRecord type
	; this record expression have type:
	; Generic(record {x: GenericInteger, y: GenericInteger})
	%1 = insertvalue {i4, i5} zeroinitializer, i4 10, 0
	%2 = insertvalue {i4, i5} %1, i5 20, 1
	; value with GenericRecord type
	; can be implicit casted to Record with same fields.
	; implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32}
	%3 = alloca %Point2D, align 4
	%4 = insertvalue %Point2D zeroinitializer, i32 10, 0
	%5 = insertvalue %Point2D %4, i32 20, 1
	store %Point2D %5, %Point2D* %3
	; explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
	; to record {x: Int32, y: Int32, z: Int32}
	%6 = alloca %Point3D, align 4
	%7 = insertvalue %Point3D zeroinitializer, i32 10, 0
	%8 = insertvalue %Point3D %7, i32 20, 1
	%9 = insertvalue %Point3D %8, i32 0, 2
	store %Point3D %9, %Point3D* %6
	ret i1 1
}



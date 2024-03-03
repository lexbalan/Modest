
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

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8
%Char = type i8
%ConstChar = type %Char
%SignedChar = type i8
%UnsignedChar = type i8
%Short = type i16
%UnsignedShort = type i16
%Int = type i32
%UnsignedInt = type i32
%LongInt = type i64
%UnsignedLongInt = type i64
%Long = type i64
%UnsignedLong = type i64
%LongLong = type i64
%UnsignedLongLong = type i64
%LongLongInt = type i64
%UnsignedLongLongInt = type i64
%Float = type double
%Double = type double
%LongDouble = type double
%SizeT = type i64
%SSizeT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FILE = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%FILE* %f)
declare %Int @feof(%FILE* %f)
declare %Int @ferror(%FILE* %f)
declare %Int @fflush(%FILE* %f)
declare %Int @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare %Int @fseek(%FILE* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%FILE* %f, %FposT* %pos)
declare %LongInt @ftell(%FILE* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare %Int @setvbuf(%FILE* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%FILE* %stream, %Str* %format, ...)
declare %Int @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @fgetc(%FILE* %f)
declare %Int @fputc(%Int %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %FILE* %f)
declare %Int @fputs(%ConstCharStr* %str, %FILE* %f)
declare %Int @getc(%FILE* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %FILE* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: src/main.cm

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
@str12 = private constant [19 x i8] [i8 97, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 98, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str14 = private constant [19 x i8] [i8 99, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 93, i8 10, i8 0]
@str15 = private constant [37 x i8] [i8 100, i8 32, i8 33, i8 61, i8 32, i8 91, i8 48, i8 44, i8 32, i8 49, i8 44, i8 32, i8 50, i8 44, i8 32, i8 51, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 44, i8 32, i8 48, i8 93, i8 10, i8 0]



define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([20 x i8]* @str1 to [0 x i8]*))
    %2 = call i1 () @test_generic_integer()
    br i1 %2 , label %then_0, label %else_0
then_0:
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str2 to [0 x i8]*))
    br label %endif_0
else_0:
    %4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str3 to [0 x i8]*))
    br label %endif_0
endif_0:
    %5 = call i1 () @test_generic_float()
    br i1 %5 , label %then_1, label %else_1
then_1:
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str4 to [0 x i8]*))
    br label %endif_1
else_1:
    %7 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str5 to [0 x i8]*))
    br label %endif_1
endif_1:
    %8 = call i1 () @test_generic_char()
    br i1 %8 , label %then_2, label %else_2
then_2:
    %9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str6 to [0 x i8]*))
    br label %endif_2
else_2:
    %10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str7 to [0 x i8]*))
    br label %endif_2
endif_2:
    %11 = call i1 () @test_generic_array()
    br i1 %11 , label %then_3, label %else_3
then_3:
    %12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str8 to [0 x i8]*))
    br label %endif_3
else_3:
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str9 to [0 x i8]*))
    br label %endif_3
endif_3:
    %14 = call i1 () @test_generic_record()
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
    %1 = alloca i32
    store i32 1, i32* %1
    %2 = alloca i64
    store i64 1, i64* %2
    ; to Float
    %3 = alloca float
    store float 1.0, float* %3
    %4 = alloca double
    store double 1.0, double* %4
    ; and to Byte
    %5 = alloca i8
    store i8 1, i8* %5
    ; explicit cast GenericInteger value
    %6 = alloca i8
    store i8 1, i8* %6
    %7 = alloca i16
    store i16 1, i16* %7
    %8 = alloca i32
    store i32 1, i32* %8
    %9 = alloca i1
    store i1 1, i1* %9
    ret i1 1
}

define i1 @test_generic_float() {
    ; Any float literal have GenericFloat type
    ; value with GenericFloat type
    ; can be implicit casted to any Float type
    ; (in this case value may lose precision)
    %1 = alloca float
    store float 3.1415927410125732, float* %1
    %2 = alloca double
    store double 3.141592653589793, double* %2
    ; explicit cast GenericFloat value to Int32
    %3 = alloca i32
    store i32 3, i32* %3
    ret i1 1
}

define i1 @test_generic_char() {
    ; Any char value expression have GenericChar type
    ; (you can pick GenericChar value by index of GenericString value)
    ; value with GenericChar type
    ; can be implicit casted to any Char type
    %1 = alloca i8
    store i8 65, i8* %1
    %2 = alloca i16
    store i16 65, i16* %2
    %3 = alloca i32
    store i32 65, i32* %3
    ; explicit cast GenericChar value to Int32
    %4 = alloca i32
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
    br i1 1 , label %then_0, label %endif_0
then_0:
    %6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str12 to [0 x i8]*))
    ret i1 0
    br label %endif_0
endif_0:
    ; value with GenericArray type
    ; can be implicit casted to Array with compatible type and same size
    ; implicit cast Generic([4]GenericInteger) value to [4]Int32
    %8 = alloca [4 x i32]
    %9 = insertvalue [4 x i32] zeroinitializer, i32 0, 0
    %10 = insertvalue [4 x i32] %9, i32 1, 1
    %11 = insertvalue [4 x i32] %10, i32 2, 2
    %12 = insertvalue [4 x i32] %11, i32 3, 3
    store [4 x i32] %12, [4 x i32]* %8
    %13 = insertvalue [4 x i32] zeroinitializer, i32 0, 0
    %14 = insertvalue [4 x i32] %13, i32 1, 1
    %15 = insertvalue [4 x i32] %14, i32 2, 2
    %16 = insertvalue [4 x i32] %15, i32 3, 3
    %17 = bitcast [4 x i32]* %8 to i8*
    %18 = bitcast [4 x i32] %16 to i8*
    
    %19 = call i32 (i8*, i8*, i64) @memcmp( i8* %17, i8* %18, i64 16)
    %20 = icmp eq i32 %19, 0
    br i1 %20 , label %then_1, label %endif_1
then_1:
    %21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str13 to [0 x i8]*))
    ret i1 0
    br label %endif_1
endif_1:
    ; implicit cast Generic([4]GenericInteger) value to [4]Nat64
    %23 = alloca [4 x i64]
    %24 = insertvalue [4 x i64] zeroinitializer, i64 0, 0
    %25 = insertvalue [4 x i64] %24, i64 1, 1
    %26 = insertvalue [4 x i64] %25, i64 2, 2
    %27 = insertvalue [4 x i64] %26, i64 3, 3
    store [4 x i64] %27, [4 x i64]* %23
    %28 = insertvalue [4 x i64] zeroinitializer, i64 0, 0
    %29 = insertvalue [4 x i64] %28, i64 1, 1
    %30 = insertvalue [4 x i64] %29, i64 2, 2
    %31 = insertvalue [4 x i64] %30, i64 3, 3
    %32 = bitcast [4 x i64]* %23 to i8*
    %33 = bitcast [4 x i64] %31 to i8*
    
    %34 = call i32 (i8*, i8*, i64) @memcmp( i8* %32, i8* %33, i64 32)
    %35 = icmp eq i32 %34, 0
    br i1 %35 , label %then_2, label %endif_2
then_2:
    %36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str14 to [0 x i8]*))
    ret i1 0
    br label %endif_2
endif_2:
    ; explicit cast Generic([4]GenericInteger) value to [10]Int32
    %38 = alloca [10 x i32]
    %39 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %40 = insertvalue [10 x i32] %39, i32 1, 1
    %41 = insertvalue [10 x i32] %40, i32 2, 2
    %42 = insertvalue [10 x i32] %41, i32 3, 3
    %43 = insertvalue [10 x i32] %42, i32 0, 4
    %44 = insertvalue [10 x i32] %43, i32 0, 5
    %45 = insertvalue [10 x i32] %44, i32 0, 6
    %46 = insertvalue [10 x i32] %45, i32 0, 7
    %47 = insertvalue [10 x i32] %46, i32 0, 8
    %48 = insertvalue [10 x i32] %47, i32 0, 9
    store [10 x i32] %48, [10 x i32]* %38
    %49 = insertvalue [10 x i32] zeroinitializer, i32 0, 0
    %50 = insertvalue [10 x i32] %49, i32 1, 1
    %51 = insertvalue [10 x i32] %50, i32 2, 2
    %52 = insertvalue [10 x i32] %51, i32 3, 3
    %53 = insertvalue [10 x i32] %52, i32 0, 4
    %54 = insertvalue [10 x i32] %53, i32 0, 5
    %55 = insertvalue [10 x i32] %54, i32 0, 6
    %56 = insertvalue [10 x i32] %55, i32 0, 7
    %57 = insertvalue [10 x i32] %56, i32 0, 8
    %58 = insertvalue [10 x i32] %57, i32 0, 9
    %59 = bitcast [10 x i32]* %38 to i8*
    %60 = bitcast [10 x i32] %58 to i8*
    
    %61 = call i32 (i8*, i8*, i64) @memcmp( i8* %59, i8* %60, i64 40)
    %62 = icmp eq i32 %61, 0
    br i1 %62 , label %then_3, label %endif_3
then_3:
    %63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([37 x i8]* @str15 to [0 x i8]*))
    ret i1 0
    br label %endif_3
endif_3:
    ret i1 1
}


%Point2D = type {
	i32,
	i32
}

%Point3D = type {
	i32,
	i32,
	i32
}


define i1 @test_generic_record() {
    ; Any record expression have GenericRecord type
    ; this record expression have type:
    ; Generic(record {x: GenericInteger, y: GenericInteger})
    %1 = insertvalue { i4, i5} zeroinitializer, i4 10, 0
    %2 = insertvalue { i4, i5} %1, i5 20, 1
    ; value with GenericRecord type
    ; can be implicit casted to Record with same fields.
    ; implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
    ; to record {x: Int32, y: Int32}
    %3 = alloca %Point2D
    %4 = insertvalue { i4, i5} zeroinitializer, i4 10, 0
    %5 = insertvalue { i4, i5} %4, i5 20, 1
    %6 = alloca { i4, i5}
    store { i4, i5} %5, { i4, i5}* %6
    %7 = bitcast { i4, i5}* %6 to %Point2D*
    %8 = bitcast %Point2D* %3 to i8*
    %9 = bitcast %Point2D* %7 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %8, i8* %9, i32 8, i1 0)
    ; explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
    ; to record {x: Int32, y: Int32, z: Int32}
    %10 = alloca %Point3D
    %11 = insertvalue { i4, i5} zeroinitializer, i4 10, 0
    %12 = insertvalue { i4, i5} %11, i5 20, 1
    %13 = alloca { i4, i5}
    store { i4, i5} %12, { i4, i5}* %13
    %14 = bitcast { i4, i5}* %13 to %Point3D*
    %15 = bitcast %Point3D* %10 to i8*
    %16 = bitcast %Point3D* %14 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %15, i8* %16, i32 12, i1 0)
    ret i1 1
}



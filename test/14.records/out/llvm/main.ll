
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%NlinkT = type i16


%ModeT = type i32


%UIDT = type i16


%GIDT = type i8


%BlkSizeT = type i16


%TimeT = type i32


%DIR = type opaque


declare i64 @clock()
declare i8* @malloc(%SizeT %size)
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare %Int @memcmp(i8* %ptr1, i8* %ptr2, %SizeT %num)
declare void @free(i8* %ptr)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)


declare %Int @ftruncate(%Int %fd, %OffT %size)
















declare %Int @creat(%Str* %path, %ModeT %mode)
declare %Int @open(%Str* %path, %Int %oflags)
declare %Int @read(%Int %fd, i8* %buf, i32 %len)
declare %Int @write(%Int %fd, i8* %buf, i32 %len)
declare %OffT @lseek(%Int %fd, %OffT %offset, %Int %whence)
declare %Int @close(%Int %fd)
declare void @exit(%Int %rc)


declare %DIR* @opendir(%Str* %name)
declare %Int @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, %SizeT %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, %SizeT %n)


declare void @bcopy(i8* %src, i8* %dst, %SizeT %n)


; -- SOURCE: src/main.cm

@str1 = private constant [14 x i8] [i8 114, i8 101, i8 99, i8 111, i8 114, i8 100, i8 115, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 48, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 49, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 50, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 51, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 61, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 112, i8 50, i8 100, i8 51, i8 32, i8 33, i8 61, i8 32, i8 112, i8 50, i8 100, i8 52, i8 10, i8 0]





%Point2D = type {
	i32,
	i32
}

%Point3D = type {
	i32,
	i32,
	i32
}


define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str1 to [0 x i8]*))
    ; compare two Point2D records
    %2 = alloca %Point2D
    %3 = insertvalue %Point2D zeroinitializer, i32 1, 0
    %4 = insertvalue %Point2D %3, i32 2, 1
    store %Point2D %4, %Point2D* %2
    %5 = alloca %Point2D
    %6 = insertvalue %Point2D zeroinitializer, i32 10, 0
    %7 = insertvalue %Point2D %6, i32 20, 1
    store %Point2D %7, %Point2D* %5
    %8 = bitcast %Point2D* %2 to i8*
    %9 = bitcast %Point2D* %5 to i8*
    
    %10 = call i32 (i8*, i8*, i64) @memcmp( i8* %8, i8* %9, i64 8)
    %11 = icmp eq i32 %10, 0
    br i1 %11 , label %then_0, label %else_0
then_0:
    %12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str2 to [0 x i8]*))
    br label %endif_0
else_0:
    %13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*))
    br label %endif_0
endif_0:
    ; compare Point2D with anonymous record
    %14 = alloca %Point2D
    %15 = bitcast %Point2D* %14 to i8*
    %16 = bitcast %Point2D* %2 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %15, i8* %16, i32 8, i1 0)
    %17 = alloca { i32, i32}
    %18 = insertvalue { i32, i32} zeroinitializer, i32 1, 0
    %19 = insertvalue { i32, i32} %18, i32 2, 1
    store { i32, i32} %19, { i32, i32}* %17
    %20 = load { i32, i32}, { i32, i32}* %17
    %21 = alloca { i32, i32}
    store { i32, i32} %20, { i32, i32}* %21
    %22 = bitcast { i32, i32}* %21 to %Point2D*
    %23 = bitcast %Point2D* %14 to i8*
    %24 = bitcast %Point2D* %22 to i8*
    
    %25 = call i32 (i8*, i8*, i64) @memcmp( i8* %23, i8* %24, i64 8)
    %26 = icmp eq i32 %25, 0
    br i1 %26 , label %then_1, label %else_1
then_1:
    %27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*))
    br label %endif_1
else_1:
    %28 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*))
    br label %endif_1
endif_1:
    ; comparison between two anonymous record
    %29 = alloca { i32, i32}
    %30 = insertvalue { i32, i32} zeroinitializer, i32 1, 0
    %31 = insertvalue { i32, i32} %30, i32 2, 1
    store { i32, i32} %31, { i32, i32}* %29
    %32 = bitcast { i32, i32}* %17 to i8*
    %33 = bitcast { i32, i32}* %29 to i8*
    
    %34 = call i32 (i8*, i8*, i64) @memcmp( i8* %32, i8* %33, i64 8)
    %35 = icmp eq i32 %34, 0
    br i1 %35 , label %then_2, label %else_2
then_2:
    %36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*))
    br label %endif_2
else_2:
    %37 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*))
    br label %endif_2
endif_2:
    ; cons Point3D from Point2D (record extension)
    ; (it is possible if dst record contained all fields from src record
    ; and their types are equal)
    %38 = alloca %Point3D
    %39 = load %Point2D, %Point2D* %14
    %40 = alloca %Point2D
    store %Point2D %39, %Point2D* %40
    %41 = bitcast %Point2D* %40 to %Point3D*
    %42 = bitcast %Point3D* %38 to i8*
    %43 = bitcast %Point3D* %41 to i8*
    call void (i8*, i8*, i32, i1) @llvm.memcpy.p0.p0.i32(i8* %42, i8* %43, i32 12, i1 0)
    ret %Int 0
}



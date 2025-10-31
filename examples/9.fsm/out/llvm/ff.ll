
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
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





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/libc.hm




%DevT = type i16


%InoT = type i32


%BlkCntT = type i32


%OffT = type i32


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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/lightfood/main.cm







%ArchInt = type i64
%ArchNat = type i64

define void @memzero(i8* %mem, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %mem to [0 x %ArchNat]*
    %3 = alloca i64
    store i64 0, i64* %3
    br label %again_1
again_1:
    %4 = load i64, i64* %3
    %5 = icmp ult i64 %4, %1
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load i64, i64* %3
    %7 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %2, i32 0, i64 %6
    store %ArchNat 0, %ArchNat* %7
    %8 = load i64, i64* %3
    %9 = add i64 %8, 1
    store i64 %9, i64* %3
    br label %again_1
break_1:
    %10 = urem i64 %len, 8
    %11 = load i64, i64* %3
    %12 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %2, i32 0, i64 %11
    %13 = bitcast %ArchNat* %12 to [0 x i8]*
    store i64 0, i64* %3
    br label %again_2
again_2:
    %14 = load i64, i64* %3
    %15 = icmp ult i64 %14, %10
    br i1 %15 , label %body_2, label %break_2
body_2:
    %16 = load i64, i64* %3
    %17 = getelementptr inbounds [0 x i8], [0 x i8]* %13, i32 0, i64 %16
    store i8 0, i8* %17
    %18 = load i64, i64* %3
    %19 = add i64 %18, 1
    store i64 %19, i64* %3
    br label %again_2
break_2:
    ret void
}

define void @memcopy(i8* %dst, i8* %src, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %src to [0 x %ArchNat]*
    %3 = bitcast i8* %dst to [0 x %ArchNat]*
    %4 = alloca i64
    store i64 0, i64* %4
    br label %again_1
again_1:
    %5 = load i64, i64* %4
    %6 = icmp ult i64 %5, %1
    br i1 %6 , label %body_1, label %break_1
body_1:
    %7 = load i64, i64* %4
    %8 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %2, i32 0, i64 %7
    %9 = load %ArchNat, %ArchNat* %8
    %10 = load i64, i64* %4
    %11 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %3, i32 0, i64 %10
    store %ArchNat %9, %ArchNat* %11
    %12 = load i64, i64* %4
    %13 = add i64 %12, 1
    store i64 %13, i64* %4
    br label %again_1
break_1:
    %14 = urem i64 %len, 8
    %15 = load i64, i64* %4
    %16 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %2, i32 0, i64 %15
    %17 = bitcast %ArchNat* %16 to [0 x i8]*
    %18 = load i64, i64* %4
    %19 = getelementptr inbounds [0 x %ArchNat], [0 x %ArchNat]* %3, i32 0, i64 %18
    %20 = bitcast %ArchNat* %19 to [0 x i8]*
    store i64 0, i64* %4
    br label %again_2
again_2:
    %21 = load i64, i64* %4
    %22 = icmp ult i64 %21, %14
    br i1 %22 , label %body_2, label %break_2
body_2:
    %23 = load i64, i64* %4
    %24 = getelementptr inbounds [0 x i8], [0 x i8]* %17, i32 0, i64 %23
    %25 = load i8, i8* %24
    %26 = load i64, i64* %4
    %27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
    store i8 %25, i8* %27
    %28 = load i64, i64* %4
    %29 = add i64 %28, 1
    store i64 %29, i64* %4
    br label %again_2
break_2:
    ret void
}

define i64 @cstrlen(%Str8* %cstr) {
    %1 = alloca i64
    store i64 0, i64* %1
    br label %again_1
again_1:
    %2 = load i64, i64* %1
    %3 = getelementptr inbounds %Str8, %Str8* %cstr, i32 0, i64 %2
    %4 = load i8, i8* %3
    %5 = icmp ne i8 %4, 0
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load i64, i64* %1
    %7 = add i64 %6, 1
    store i64 %7, i64* %1
    br label %again_1
break_1:
    %8 = load i64, i64* %1
    ret i64 %8
}



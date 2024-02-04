
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm



; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes32.hm


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]
%Char = type i8
%ConstChar = type i8
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
declare i8* @malloc(i64 %size)
declare i8* @memset(i8* %mem, i32 %c, i64 %n)
declare i8* @memcpy(i8* %dst, i8* %src, i64 %len)
declare i32 @memcmp(i8* %ptr1, i8* %ptr2, i64 %num)
declare void @free(i8* %ptr)
declare i32 @strncmp([0 x i8]* %s1, [0 x i8]* %s2, i64 %n)
declare i32 @strcmp([0 x i8]* %s1, [0 x i8]* %s2)
declare [0 x i8]* @strcpy([0 x i8]* %dst, [0 x i8]* %src)
declare i64 @strlen([0 x i8]* %s)


declare i32 @ftruncate(i32 %fd, i32 %size)
















declare i32 @creat(%Str* %path, i32 %mode)
declare i32 @open(%Str* %path, i32 %oflags)
declare i32 @read(i32 %fd, i8* %buf, i32 %len)
declare i32 @write(i32 %fd, i8* %buf, i32 %len)
declare i32 @lseek(i32 %fd, i32 %offset, i32 %whence)
declare i32 @close(i32 %fd)
declare void @exit(i32 %rc)


declare %DIR* @opendir(%Str* %name)
declare i32 @closedir(%DIR* %dir)


declare %Str* @getcwd(%Str* %buf, i64 %size)
declare %Str* @getenv(%Str* %name)


declare void @bzero(i8* %s, i64 %n)


declare void @bcopy(i8* %src, i8* %dst, i64 %n)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE* %f)
declare i32 @feof(%FILE* %f)
declare i32 @ferror(%FILE* %f)
declare i32 @fflush(%FILE* %f)
declare i32 @fgetpos(%FILE* %f, %FposT* %pos)
declare %FILE* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %FILE* %f)
declare %FILE* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %FILE* %f)
declare i32 @fseek(%FILE* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%FILE* %f, %FposT* %pos)
declare i64 @ftell(%FILE* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%FILE* %f)
declare void @setbuf(%FILE* %f, %CharStr* %buffer)


declare i32 @setvbuf(%FILE* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%FILE* %stream, %Str* %format, ...)
declare i32 @fscanf(%FILE* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare i32 @fgetc(%FILE* %f)
declare i32 @fputc(i32 %char, %FILE* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %FILE* %f)
declare i32 @fputs(%ConstCharStr* %str, %FILE* %f)
declare i32 @getc(%FILE* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %FILE* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %FILE* %f)
declare void @perror(%ConstCharStr* %str)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/fastfood/main.cm






%ArchInt = type i64
%ArchNat = type i64

define void @ff_memzero(i8* %mem, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %mem to [0 x i64]*
    %3 = alloca i64
    store i64 0, i64* %3
    br label %again_1
again_1:
    %4 = load i64, i64* %3
    %5 = icmp ult i64 %4, %1
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load i64, i64* %3
    %7 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %6
    store i64 0, i64* %7
    %8 = load i64, i64* %3
    %9 = add i64 %8, 1
    store i64 %9, i64* %3
    br label %again_1
break_1:
    %10 = urem i64 %len, 8
    %11 = load i64, i64* %3
    %12 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %11
    %13 = bitcast i64* %12 to [0 x i8]*
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

define void @ff_memcpy(i8* %dst, i8* %src, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %src to [0 x i64]*
    %3 = bitcast i8* %dst to [0 x i64]*
    %4 = alloca i64
    store i64 0, i64* %4
    br label %again_1
again_1:
    %5 = load i64, i64* %4
    %6 = icmp ult i64 %5, %1
    br i1 %6 , label %body_1, label %break_1
body_1:
    %7 = load i64, i64* %4
    %8 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %7
    %9 = load i64, i64* %8
    %10 = load i64, i64* %4
    %11 = getelementptr inbounds [0 x i64], [0 x i64]* %3, i32 0, i64 %10
    store i64 %9, i64* %11
    %12 = load i64, i64* %4
    %13 = add i64 %12, 1
    store i64 %13, i64* %4
    br label %again_1
break_1:
    %14 = urem i64 %len, 8
    %15 = load i64, i64* %4
    %16 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %15
    %17 = bitcast i64* %16 to [0 x i8]*
    %18 = load i64, i64* %4
    %19 = getelementptr inbounds [0 x i64], [0 x i64]* %3, i32 0, i64 %18
    %20 = bitcast i64* %19 to [0 x i8]*
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

define i64 @ff_cstrlen([0 x i8]* %cstr) {
    %1 = alloca i64
    store i64 0, i64* %1
    br label %again_1
again_1:
    %2 = load i64, i64* %1
    %3 = getelementptr inbounds [0 x i8], [0 x i8]* %cstr, i32 0, i64 %2
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

define void @delay_us(i64 %us) {
    %1 = call i64 () @clock()
    br label %again_1
again_1:
    %2 = call i64 () @clock()
    %3 = add i64 %1, %us
    %4 = icmp ult i64 %2, %3
    br i1 %4 , label %body_1, label %break_1
body_1:
    ; waiting
    br label %again_1
break_1:
    ret void
}

define void @delay(i64 %us) {
    call void (i64) @delay_us(i64 %us)
    ret void
}

define void @delay_ms(i64 %ms) {
    %1 = mul i64 %ms, 1000
    call void (i64) @delay_us(i64 %1)
    ret void
}

define void @delay_s(i64 %s) {
    %1 = mul i64 %s, 1000
    call void (i64) @delay_ms(i64 %1)
    ret void
}



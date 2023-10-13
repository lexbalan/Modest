
target triple = "arm64-apple-darwin21.6.0"

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type [0 x i8]*
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
declare i8* @malloc(i64)
declare i8* @memset(i8*, i32, i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @memcmp(i8*, i8*, i64)
declare void @free(i8*)
declare i32 @strncmp(i8*, i8*, i64)
declare i32 @strcmp(i8*, i8*)
declare i8* @strcpy(i8*, i8*)
declare i64 @strlen(i8*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat(%Str, i32)
declare i32 @open(%Str, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str)
declare i32 @closedir(%DIR*)


declare %Str @getcwd(%Str, i64)
declare %Str @getenv(%Str)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]*
%ConstCharStr = type [0 x i8]*


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr, %ConstCharStr)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr, %ConstCharStr, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr)
declare i32 @rename(%ConstCharStr, %ConstCharStr)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr)


declare i32 @setvbuf(%FILE*, %CharStr, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr @tmpnam(%CharStr)
declare i32 @printf(%ConstCharStr, ...)
declare i32 @scanf(%ConstCharStr, ...)
declare i32 @fprintf(%FILE*, %Str, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr, ...)
declare i32 @sscanf(%ConstCharStr, %ConstCharStr, ...)
declare i32 @sprintf(%CharStr, %ConstCharStr, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr @fgets(%CharStr, i32, %FILE*)
declare i32 @fputs(%ConstCharStr, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr @gets(%CharStr)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/fastfood/main.cm






%ArchInt = type i64
%ArchNat = type i64

define void @ff_memzero(i8* %mem, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %mem to [0 x i64]*
    %i = alloca i64
    store i64 0, i64* %i
    br label %again_1
again_1:
    %3 = load i64, i64* %i
    %4 = icmp ult i64 %3, %1
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i64, i64* %i
    %6 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %5
    store i64 0, i64* %6
    %7 = load i64, i64* %i
    %8 = add i64 %7, 1
    store i64 %8, i64* %i
    br label %again_1
break_1:
    %9 = urem i64 %len, 8
    %10 = load i64, i64* %i
    %11 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %10
    %12 = bitcast i64* %11 to [0 x i8]*
    store i64 0, i64* %i
    br label %again_2
again_2:
    %13 = load i64, i64* %i
    %14 = icmp ult i64 %13, %9
    br i1 %14 , label %body_2, label %break_2
body_2:
    %15 = load i64, i64* %i
    %16 = getelementptr inbounds [0 x i8], [0 x i8]* %12, i32 0, i64 %15
    store i8 0, i8* %16
    %17 = load i64, i64* %i
    %18 = add i64 %17, 1
    store i64 %18, i64* %i
    br label %again_2
break_2:
    ret void
}

define void @ff_memcpy(i8* %dst, i8* %src, i64 %len) {
    %1 = udiv i64 %len, 8
    %2 = bitcast i8* %src to [0 x i64]*
    %3 = bitcast i8* %dst to [0 x i64]*
    %i = alloca i64
    store i64 0, i64* %i
    br label %again_1
again_1:
    %4 = load i64, i64* %i
    %5 = icmp ult i64 %4, %1
    br i1 %5 , label %body_1, label %break_1
body_1:
    %6 = load i64, i64* %i
    %7 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %6
    %8 = load i64, i64* %7
    %9 = load i64, i64* %i
    %10 = getelementptr inbounds [0 x i64], [0 x i64]* %3, i32 0, i64 %9
    store i64 %8, i64* %10
    %11 = load i64, i64* %i
    %12 = add i64 %11, 1
    store i64 %12, i64* %i
    br label %again_1
break_1:
    %13 = urem i64 %len, 8
    %14 = load i64, i64* %i
    %15 = getelementptr inbounds [0 x i64], [0 x i64]* %2, i32 0, i64 %14
    %16 = bitcast i64* %15 to [0 x i8]*
    %17 = load i64, i64* %i
    %18 = getelementptr inbounds [0 x i64], [0 x i64]* %3, i32 0, i64 %17
    %19 = bitcast i64* %18 to [0 x i8]*
    store i64 0, i64* %i
    br label %again_2
again_2:
    %20 = load i64, i64* %i
    %21 = icmp ult i64 %20, %13
    br i1 %21 , label %body_2, label %break_2
body_2:
    %22 = load i64, i64* %i
    %23 = getelementptr inbounds [0 x i8], [0 x i8]* %16, i32 0, i64 %22
    %24 = load i8, i8* %23
    %25 = load i64, i64* %i
    %26 = getelementptr inbounds [0 x i8], [0 x i8]* %19, i32 0, i64 %25
    store i8 %24, i8* %26
    %27 = load i64, i64* %i
    %28 = add i64 %27, 1
    store i64 %28, i64* %i
    br label %again_2
break_2:
    ret void
}

define i64 @ff_cstrlen([0 x i8]* %cstr) {
    %i = alloca i64
    store i64 0, i64* %i
    br label %again_1
again_1:
    %1 = load i64, i64* %i
    %2 = getelementptr inbounds [0 x i8], [0 x i8]* %cstr, i32 0, i64 %1
    %3 = load i8, i8* %2
    %4 = icmp ne i8 %3, 0
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = load i64, i64* %i
    %6 = add i64 %5, 1
    store i64 %6, i64* %i
    br label %again_1
break_1:
    %7 = load i64, i64* %i
    ret i64 %7
}

define void @delay_us(i64 %us) {
    %1 = call i64() @clock ()
    br label %again_1
again_1:
    %2 = call i64() @clock ()
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
    call void(i64) @delay_us (i64 %us)
    ret void
}

define void @delay_ms(i64 %ms) {
    %1 = mul i64 %ms, 1000
    call void(i64) @delay_us (i64 %1)
    ret void
}

define void @delay_s(i64 %s) {
    %1 = mul i64 %s, 1000
    call void(i64) @delay_ms (i64 %1)
    ret void
}




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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm




%In_addr_t = type i32
%In_port_t = type i16
%Socklen_t = type i32
%Struct_sockaddr = type {
	%UnsignedShort,
	[14 x i8]
}

%Struct_in_addr = type {
	%In_addr_t
}

%Struct_sockaddr_in = type {
	i8,
	i8,
	%UnsignedShort,
	%Struct_in_addr,
	[8 x i8]
}





















































































declare %In_addr_t @inet_addr([0 x %ConstChar]* %cp)


declare %Int @socket(%Int %domain, %Int %type, %Int %protocol)
declare %Int @bind(%Int %sockfd, %Struct_sockaddr* %addr, %Socklen_t %addrlen)
declare %Int @listen(%Int %sockfd, %Int %backlog)
declare %Int @connect(%Int %sockfd, %Struct_sockaddr* %addr, %Socklen_t %addrlen)
declare %SSizeT @send(%Int %socket, i8* %buffer, %SizeT %length, %Int %flags)
declare %SSizeT @recv(%Int %sockfd, i8* %buf, %SizeT %len, %Int %flags)


declare %Int @accept(%Int %s, %Struct_sockaddr* %addr, %Socklen_t* %addrlen)


; -- SOURCE: src/server.cm

@str1 = private constant [10 x i8] [i8 102, i8 105, i8 108, i8 101, i8 50, i8 46, i8 116, i8 120, i8 116, i8 0]
@str2 = private constant [2 x i8] [i8 119, i8 0]
@str3 = private constant [27 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 105, i8 110, i8 103, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]
@str4 = private constant [3 x i8] [i8 37, i8 115, i8 0]
@str5 = private constant [20 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str6 = private constant [27 x i8] [i8 91, i8 43, i8 93, i8 32, i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 100, i8 10, i8 0]
@str7 = private constant [10 x i8] [i8 49, i8 50, i8 55, i8 46, i8 48, i8 46, i8 48, i8 46, i8 49, i8 0]
@str8 = private constant [21 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 0]
@str9 = private constant [25 x i8] [i8 91, i8 43, i8 93, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 32, i8 83, i8 117, i8 99, i8 99, i8 101, i8 115, i8 115, i8 102, i8 117, i8 108, i8 108, i8 10, i8 0]
@str10 = private constant [18 x i8] [i8 91, i8 43, i8 93, i8 32, i8 76, i8 105, i8 115, i8 116, i8 101, i8 110, i8 105, i8 110, i8 103, i8 46, i8 46, i8 46, i8 10, i8 0]
@str11 = private constant [21 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 0]
@str12 = private constant [34 x i8] [i8 91, i8 43, i8 93, i8 32, i8 68, i8 97, i8 116, i8 97, i8 32, i8 119, i8 114, i8 105, i8 116, i8 116, i8 101, i8 110, i8 32, i8 105, i8 110, i8 32, i8 116, i8 104, i8 101, i8 32, i8 116, i8 101, i8 120, i8 116, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]




define void @write_file(%Int %sockfd) {
    %1 = alloca [1024 x i8]
    %2 = call %FILE* (%ConstCharStr*, %ConstCharStr*) @fopen(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
    %3 = icmp eq %FILE* %2, null
    br i1 %3 , label %then_0, label %endif_0
then_0:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_0
endif_0:
    br label %again_1
again_1:
    br i1 1 , label %body_1, label %break_1
body_1:
    %4 = bitcast [1024 x i8]* %1 to i8*
    %5 = call %SSizeT (%Int, i8*, %SizeT, %Int) @recv(%Int %sockfd, i8* %4, %SizeT 1024, %Int 0)
    %6 = icmp sle %SSizeT %5, 0
    br i1 %6 , label %then_1, label %endif_1
then_1:
    br label %break_1
    br label %endif_1
endif_1:
    %8 = call %Int (%FILE*, %Str*, ...) @fprintf(%FILE* %2, %Str* bitcast ([3 x i8]* @str4 to [0 x i8]*), [1024 x i8]* %1)
    %9 = bitcast [1024 x i8]* %1 to i8*
    call void (i8*, %SizeT) @bzero(i8* %9, %SizeT 1024)
    br label %again_1
break_1:
    ret void
}

define %Int @main() {
    %1 = call %Int (%Int, %Int, %Int) @socket(%Int 2, %Int 1, %Int 0)
    %2 = icmp slt %Int %1, 0
    br i1 %2 , label %then_0, label %endif_0
then_0:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_0
endif_0:
    %3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str6 to [0 x i8]*))
    %4 = alloca %Struct_sockaddr_in
    %5 = insertvalue %Struct_sockaddr_in zeroinitializer, i8 0, 0
    %6 = insertvalue %Struct_sockaddr_in %5, i8 2, 1
    %7 = insertvalue %Struct_sockaddr_in %6, %UnsignedShort 8080, 2
    %8 = call %In_addr_t ([0 x %ConstChar]*) @inet_addr([0 x %ConstChar]* bitcast ([10 x i8]* @str7 to [0 x i8]*))
    %9 = insertvalue %Struct_in_addr zeroinitializer, %In_addr_t %8, 0
    %10 = insertvalue %Struct_sockaddr_in %7, %Struct_in_addr %9, 3
    %11 = insertvalue [8 x i8] zeroinitializer, i8 0, 0
    %12 = insertvalue [8 x i8] %11, i8 0, 1
    %13 = insertvalue [8 x i8] %12, i8 0, 2
    %14 = insertvalue [8 x i8] %13, i8 0, 3
    %15 = insertvalue [8 x i8] %14, i8 0, 4
    %16 = insertvalue [8 x i8] %15, i8 0, 5
    %17 = insertvalue [8 x i8] %16, i8 0, 6
    %18 = insertvalue [8 x i8] %17, i8 0, 7
    %19 = insertvalue %Struct_sockaddr_in %10, [8 x i8] %18, 4
    store %Struct_sockaddr_in %19, %Struct_sockaddr_in* %4
    %20 = bitcast %Struct_sockaddr_in* %4 to i8*
    %21 = bitcast i8* %20 to %Struct_sockaddr*
    %22 = alloca %Int
    %23 = call %Int (%Int, %Struct_sockaddr*, %Socklen_t) @bind(%Int %1, %Struct_sockaddr* %21, %Socklen_t 16)
    store %Int %23, %Int* %22
    %24 = load %Int, %Int* %22
    %25 = icmp slt %Int %24, 0
    br i1 %25 , label %then_1, label %endif_1
then_1:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_1
endif_1:
    %26 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
    %27 = call %Int (%Int, %Int) @listen(%Int %1, %Int 10)
    store %Int %27, %Int* %22
    %28 = load %Int, %Int* %22
    %29 = icmp eq %Int %28, 0
    br i1 %29 , label %then_2, label %else_2
then_2:
    %30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str10 to [0 x i8]*))
    br label %endif_2
else_2:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([21 x i8]* @str11 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_2
endif_2:
    %31 = alloca %Socklen_t
    store %Socklen_t 16, %Socklen_t* %31
    %32 = alloca %Struct_sockaddr_in
    %33 = bitcast %Struct_sockaddr_in* %32 to i8*
    %34 = bitcast i8* %33 to %Struct_sockaddr*
    %35 = call %Int (%Int, %Struct_sockaddr*, %Socklen_t*) @accept(%Int %1, %Struct_sockaddr* %34, %Socklen_t* %31)
    call void (%Int) @write_file(%Int %35)
    %36 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
    ret %Int 0
}



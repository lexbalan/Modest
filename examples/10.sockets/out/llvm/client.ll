
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm





%Struct_sockaddr = type {
	%UnsignedShort,
	[14 x i8]
}

%Struct_in_addr = type {
	%UnsignedLong
}

%Struct_sockaddr_in = type {
	%Short,
	%UnsignedShort,
	%Struct_in_addr
}





















































































%in_addr_t = type i32
%in_port_t = type i16
%socklen_t = type i32

declare %in_addr_t @inet_addr([0 x %ConstChar]* %cp)


declare %Int @socket(%Int %domain, %Int %type, %Int %protocol)
declare %Int @bind(%Int %sockfd, %Struct_sockaddr* %addr, %socklen_t %addrlen)
declare %Int @listen(%Int %sockfd, %Int %backlog)
declare %Int @connect(%Int %sockfd, %Struct_sockaddr* %addr, %socklen_t %addrlen)
declare %SSizeT @send(%Int %socket, i8* %buffer, %SizeT %length, %Int %flags)
declare %SSizeT @recv(%Int %sockfd, i8* %buf, %SizeT %len, %Int %flags)


declare %Int @accept(%Int %s, %Struct_sockaddr* %addr, %socklen_t* %addrlen)


; -- SOURCE: src/client.cm

@str1 = private constant [26 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 101, i8 110, i8 100, i8 117, i8 110, i8 103, i8 32, i8 100, i8 97, i8 116, i8 97, i8 0]
@str2 = private constant [10 x i8] [i8 49, i8 50, i8 55, i8 46, i8 48, i8 46, i8 48, i8 46, i8 49, i8 0]
@str3 = private constant [15 x i8] [i8 114, i8 111, i8 108, i8 101, i8 32, i8 45, i8 32, i8 67, i8 76, i8 73, i8 69, i8 78, i8 84, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 114, i8 111, i8 108, i8 101, i8 32, i8 45, i8 32, i8 83, i8 69, i8 82, i8 86, i8 69, i8 82, i8 10, i8 0]
@str5 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 116, i8 120, i8 116, i8 0]
@str6 = private constant [20 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str7 = private constant [29 x i8] [i8 91, i8 43, i8 93, i8 32, i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 100, i8 46, i8 32, i8 10, i8 0]
@str8 = private constant [24 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 67, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 105, i8 110, i8 103, i8 0]
@str9 = private constant [26 x i8] [i8 91, i8 43, i8 93, i8 32, i8 67, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 116, i8 111, i8 32, i8 115, i8 101, i8 114, i8 118, i8 101, i8 114, i8 46, i8 10, i8 0]
@str10 = private constant [2 x i8] [i8 114, i8 0]
@str11 = private constant [27 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 105, i8 110, i8 103, i8 32, i8 102, i8 105, i8 108, i8 101, i8 46, i8 0]
@str12 = private constant [34 x i8] [i8 91, i8 43, i8 93, i8 32, i8 70, i8 105, i8 108, i8 101, i8 32, i8 100, i8 97, i8 116, i8 97, i8 32, i8 115, i8 101, i8 110, i8 100, i8 32, i8 115, i8 117, i8 99, i8 99, i8 101, i8 115, i8 115, i8 102, i8 117, i8 108, i8 108, i8 121, i8 46, i8 10, i8 0]
@str13 = private constant [35 x i8] [i8 91, i8 43, i8 93, i8 32, i8 68, i8 105, i8 115, i8 99, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 116, i8 104, i8 101, i8 32, i8 115, i8 101, i8 114, i8 118, i8 101, i8 114, i8 46, i8 10, i8 0]




define void @send_file(%FILE* %fp, %Int %sockfd) {
    %1 = alloca [1024 x i8]
    br label %again_1
again_1:
    %2 = bitcast [1024 x i8]* %1 to %CharStr*
    %3 = call %CharStr* (%CharStr*, %Int, %FILE*) @fgets(%CharStr* %2, %Int 1024, %FILE* %fp)
    %4 = icmp ne %CharStr* %3, null
    br i1 %4 , label %body_1, label %break_1
body_1:
    %5 = bitcast [1024 x i8]* %1 to i8*
    %6 = call %SSizeT (%Int, i8*, %SizeT, %Int) @send(%Int %sockfd, i8* %5, %SizeT 1024, %Int 0)
    %7 = icmp eq %SSizeT %6, -1
    br i1 %7 , label %then_0, label %endif_0
then_0:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([26 x i8]* @str1 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_0
endif_0:
    %8 = bitcast [1024 x i8]* %1 to i8*
    call void (i8*, %SizeT) @bzero(i8* %8, %SizeT 1024)
    br label %again_1
break_1:
    ret void
}



define %Int @main() {
    br i1 1 , label %then_0, label %endif_0
then_0:
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str3 to [0 x i8]*))
    br label %endif_0
endif_0:
    br i1 0 , label %then_1, label %endif_1
then_1:
    %2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*))
    br label %endif_1
endif_1:
    %3 = call %Int (%Int, %Int, %Int) @socket(%Int 2, %Int 1, %Int 0)
    %4 = icmp slt %Int %3, 0
    br i1 %4 , label %then_2, label %endif_2
then_2:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([20 x i8]* @str6 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_2
endif_2:
    %5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str7 to [0 x i8]*))
    %6 = insertvalue %Struct_sockaddr_in zeroinitializer, %Short 2, 0
    %7 = insertvalue %Struct_sockaddr_in %6, %UnsignedShort 8080, 1
    %8 = call %in_addr_t ([0 x %ConstChar]*) @inet_addr(%Str8* bitcast ([10 x i8]* @str2 to [0 x i8]*))
    %9 = zext %in_addr_t %8 to %UnsignedLong
    %10 = insertvalue %Struct_in_addr zeroinitializer, %UnsignedLong %9, 0
    %11 = insertvalue %Struct_sockaddr_in %7, %Struct_in_addr %10, 2
    %12 = alloca %Struct_sockaddr_in
    store %Struct_sockaddr_in %11, %Struct_sockaddr_in* %12
    %13 = bitcast %Struct_sockaddr_in* %12 to i8*
    %14 = bitcast i8* %13 to %Struct_sockaddr*
    %15 = call %Int (%Int, %Struct_sockaddr*, %socklen_t) @connect(%Int %3, %Struct_sockaddr* %14, %socklen_t 16)
    %16 = alloca %Int
    store %Int %15, %Int* %16
    %17 = load %Int, %Int* %16
    %18 = icmp eq %Int %17, -1
    br i1 %18 , label %then_3, label %endif_3
then_3:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([24 x i8]* @str8 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_3
endif_3:
    %19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([26 x i8]* @str9 to [0 x i8]*))
    %20 = call %FILE* (%ConstCharStr*, %ConstCharStr*) @fopen(%Str8* bitcast ([9 x i8]* @str5 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str10 to [0 x i8]*))
    %21 = icmp eq %FILE* %20, null
    br i1 %21 , label %then_4, label %endif_4
then_4:
    call void (%ConstCharStr*) @perror(%ConstCharStr* bitcast ([27 x i8]* @str11 to [0 x i8]*))
    call void (%Int) @exit(%Int 1)
    br label %endif_4
endif_4:
    call void (%FILE*, %Int) @send_file(%FILE* %20, %Int %3)
    %22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
    %23 = call %Int (%Int) @close(%Int %3)
    %24 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str13 to [0 x i8]*))
    ret %Int 0
}



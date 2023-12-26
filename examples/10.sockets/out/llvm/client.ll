
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*); -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



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





; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FposT = type opaque
%FILE = type opaque

%CharStr = type [0 x i8]
%ConstCharStr = type [0 x i8]


declare i32 @fclose(%FILE*)
declare i32 @feof(%FILE*)
declare i32 @ferror(%FILE*)
declare i32 @fflush(%FILE*)
declare i32 @fgetpos(%FILE*, %FposT*)
declare %FILE* @fopen(%ConstCharStr*, %ConstCharStr*)
declare i64 @fread(i8*, i64, i64, %FILE*)
declare i64 @fwrite(i8*, i64, i64, %FILE*)
declare %FILE* @freopen(%ConstCharStr*, %ConstCharStr*, %FILE*)
declare i32 @fseek(%FILE*, i64, i32)
declare i32 @fsetpos(%FILE*, %FposT*)
declare i64 @ftell(%FILE*)
declare i32 @remove(%ConstCharStr*)
declare i32 @rename(%ConstCharStr*, %ConstCharStr*)
declare void @rewind(%FILE*)
declare void @setbuf(%FILE*, %CharStr*)


declare i32 @setvbuf(%FILE*, %CharStr*, i32, i64)
declare %FILE* @tmpfile()
declare %CharStr* @tmpnam(%CharStr*)
declare i32 @printf(%ConstCharStr*, ...)
declare i32 @scanf(%ConstCharStr*, ...)
declare i32 @fprintf(%FILE*, %Str*, ...)
declare i32 @fscanf(%FILE*, %ConstCharStr*, ...)
declare i32 @sscanf(%ConstCharStr*, %ConstCharStr*, ...)
declare i32 @sprintf(%CharStr*, %ConstCharStr*, ...)


declare i32 @fgetc(%FILE*)
declare i32 @fputc(i32, %FILE*)
declare %CharStr* @fgets(%CharStr*, i32, %FILE*)
declare i32 @fputs(%ConstCharStr*, %FILE*)
declare i32 @getc(%FILE*)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr*)
declare i32 @putc(i32, %FILE*)
declare i32 @putchar(i32)
declare i32 @puts(%ConstCharStr*)
declare i32 @ungetc(i32, %FILE*)
declare void @perror(%ConstCharStr*)

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
declare i32 @strncmp([0 x i8]*, [0 x i8]*, i64)
declare i32 @strcmp([0 x i8]*, [0 x i8]*)
declare [0 x i8]* @strcpy([0 x i8]*, [0 x i8]*)
declare i64 @strlen([0 x i8]*)


declare i32 @ftruncate(i32, i32)
















declare i32 @creat(%Str*, i32)
declare i32 @open(%Str*, i32)
declare i32 @read(i32, i8*, i32)
declare i32 @write(i32, i8*, i32)
declare i32 @lseek(i32, i32, i32)
declare i32 @close(i32)
declare void @exit(i32)


declare %DIR* @opendir(%Str*)
declare i32 @closedir(%DIR*)


declare %Str* @getcwd(%Str*, i64)
declare %Str* @getenv(%Str*)


declare void @bzero(i8*, i64)


declare void @bcopy(i8*, i8*, i64)

; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm





%Struct_sockaddr = type {
	i16,
	[14 x i8]
}

%Struct_in_addr = type {
	i64
}

%Struct_sockaddr_in = type {
	i16,
	i16,
	%Struct_in_addr
}





















































































%in_addr_t = type i32
%in_port_t = type i16
%socklen_t = type i32

declare i32 @inet_addr([0 x i8]*)


declare i32 @socket(i32, i32, i32)
declare i32 @bind(i32, %Struct_sockaddr*, i32)
declare i32 @listen(i32, i32)
declare i32 @connect(i32, %Struct_sockaddr*, i32)
declare i64 @send(i32, i8*, i64, i32)
declare i64 @recv(i32, i8*, i64, i32)


declare i32 @accept(i32, %Struct_sockaddr*, i32*)

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




define void @send_file(%FILE* %fp, i32 %sockfd) {
    %data = alloca [1024 x i8]
    br label %again_1
again_1:
    %1 = bitcast [1024 x i8]* %data to %CharStr*
    %2 = call %CharStr*(%CharStr*, i32, %FILE*) @fgets (%CharStr* %1, i32 1024, %FILE* %fp)
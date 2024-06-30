
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/system.hm




; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes64.hm



%Str = type %Str8;
%Char = type i8;
%ConstChar = type i8;
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;
%SizeT = type i64;
%SSizeT = type i64;
%IntptrT = type i64;
%PtrdiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PidT = type i32;
%UidT = type i32;
%GidT = type i32;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;
%ConstCharStr = type %CharStr;


declare i32 @fclose(%File* %f)
declare i32 @feof(%File* %f)
declare i32 @ferror(%File* %f)
declare i32 @fflush(%File* %f)
declare i32 @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare i64 @fread(i8* %buf, i64 %size, i64 %count, %File* %f)
declare i64 @fwrite(i8* %buf, i64 %size, i64 %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare i32 @fseek(%File* %stream, i64 %offset, i32 %whence)
declare i32 @fsetpos(%File* %f, %FposT* %pos)
declare i64 @ftell(%File* %f)
declare i32 @remove(%ConstCharStr* %filename)
declare i32 @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare i32 @setvbuf(%File* %f, %CharStr* %buffer, i32 %mode, i64 %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare i32 @printf(%ConstCharStr* %s, ...)
declare i32 @scanf(%ConstCharStr* %s, ...)
declare i32 @fprintf(%File* %stream, %Str* %format, ...)
declare i32 @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare i32 @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare i32 @vfprintf(%File* %f, %ConstCharStr* %format, i8* %args)
declare i32 @vprintf(%ConstCharStr* %format, i8* %args)
declare i32 @vsprintf(%CharStr* %str, %ConstCharStr* %format, i8* %args)
declare i32 @vsnprintf(%CharStr* %str, i64 %n, %ConstCharStr* %format, i8* %args)
declare i32 @__vsnprintf_chk(%CharStr* %dest, i64 %len, i32 %flags, i64 %dstlen, %ConstCharStr* %format, i8* %arg)
declare i32 @fgetc(%File* %f)
declare i32 @fputc(i32 %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, i32 %n, %File* %f)
declare i32 @fputs(%ConstCharStr* %str, %File* %f)
declare i32 @getc(%File* %f)
declare i32 @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare i32 @putc(i32 %char, %File* %f)
declare i32 @putchar(i32 %char)
declare i32 @puts(%ConstCharStr* %str)
declare i32 @ungetc(i32 %char, %File* %f)
declare void @perror(%ConstCharStr* %str)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdlib.hm



declare void @abort()
declare i32 @abs(i32 %x)
declare i32 @atexit(void ()* %x)
declare double @atof([0 x i8]* %nptr)
declare i32 @atoi([0 x i8]* %nptr)
declare i64 @atol([0 x i8]* %nptr)
declare i8* @calloc(i64 %num, i64 %size)
declare void @exit(i32 %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare i64 @labs(i64 %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(i64 %size)
declare i32 @system([0 x i8]* %string)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm




%In_addr_t = type i32;
%In_port_t = type i16;
%Socklen_t = type i32;
%Struct_sockaddr = type {
	i16, 
	[14 x i8]
};

%Struct_in_addr = type {
	i32
};

%Struct_sockaddr_in = type {
	i8, 
	i8, 
	i16, 
	%Struct_in_addr, 
	[8 x i8]
};





















































































declare i32 @inet_addr([0 x i8]* %cp)


declare i32 @socket(i32 %domain, i32 %type, i32 %protocol)
declare i32 @bind(i32 %sockfd, %Struct_sockaddr* %addr, i32 %addrlen)
declare i32 @listen(i32 %sockfd, i32 %backlog)
declare i32 @connect(i32 %sockfd, %Struct_sockaddr* %addr, i32 %addrlen)
declare i64 @send(i32 %socket, i8* %buffer, i64 %length, i32 %flags)
declare i64 @recv(i32 %sockfd, i8* %buf, i64 %len, i32 %flags)


declare i32 @accept(i32 %s, %Struct_sockaddr* %addr, i32* %addrlen)


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
@str10 = private constant [21 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 66, i8 105, i8 110, i8 100, i8 105, i8 110, i8 103, i8 0]
@str11 = private constant [18 x i8] [i8 91, i8 43, i8 93, i8 32, i8 76, i8 105, i8 115, i8 116, i8 101, i8 110, i8 105, i8 110, i8 103, i8 46, i8 46, i8 46, i8 10, i8 0]
@str12 = private constant [34 x i8] [i8 91, i8 43, i8 93, i8 32, i8 68, i8 97, i8 116, i8 97, i8 32, i8 119, i8 114, i8 105, i8 116, i8 116, i8 101, i8 110, i8 32, i8 105, i8 110, i8 32, i8 116, i8 104, i8 101, i8 32, i8 116, i8 101, i8 120, i8 116, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]
@str13 = private constant [22 x i8] [i8 91, i8 45, i8 93, i8 32, i8 67, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 119, i8 114, i8 105, i8 116, i8 101, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]




define i1 @write_file(i32 %sockfd) {
	%1 = alloca [1024 x i8], align 1
	%2 = call %File* @fopen(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br i1 %3 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
	ret i1 0
	br label %endif_0
endif_0:
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%5 = bitcast [1024 x i8]* %1 to i8*
	%6 = call i64 @recv(i32 %sockfd, i8* %5, i64 1024, i32 0)
	%7 = icmp sle i64 %6, 0
	br i1 %7 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%9 = call i32 (%File*, %Str*, ...) @fprintf(%File* %2, %Str* bitcast ([3 x i8]* @str4 to [0 x i8]*), [1024 x i8]* %1)
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%10 = zext i11 1024 to i32
	; -- end vol eval --
	; -- ZERO
	%11 = mul i32 %10, 1
	%12 = bitcast [1024 x i8]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %12, i8 0, i32 %11, i1 0)
	br label %again_1
break_1:
	ret i1 1
}

define i32 @main() {
	%1 = call i32 @socket(i32 2, i32 1, i32 0)
	%2 = icmp slt i32 %1, 0
	br i1 %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_0
endif_0:
	%3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str6 to [0 x i8]*))
	%4 = alloca %Struct_sockaddr_in, align 4
	%5 = insertvalue %Struct_sockaddr_in zeroinitializer, i8 0, 0
	%6 = insertvalue %Struct_sockaddr_in %5, i8 2, 1
	%7 = insertvalue %Struct_sockaddr_in %6, i16 8080, 2
	%8 = call i32 @inet_addr([0 x i8]* bitcast ([10 x i8]* @str7 to [0 x i8]*))
	%9 = insertvalue %Struct_in_addr zeroinitializer, i32 %8, 0
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
	%22 = alloca i32, align 4
	%23 = bitcast %Struct_sockaddr* %21 to %Struct_sockaddr*
	%24 = call i32 @bind(i32 %1, %Struct_sockaddr* %23, i32 16)
	store i32 %24, i32* %22
	%25 = load i32, i32* %22
	%26 = icmp slt i32 %25, 0
	br i1 %26 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_1
endif_1:
	%27 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
	%28 = call i32 @listen(i32 %1, i32 10)
	store i32 %28, i32* %22
	%29 = load i32, i32* %22
	%30 = icmp ne i32 %29, 0
	br i1 %30 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_2
endif_2:
	%31 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str11 to [0 x i8]*))
	%32 = alloca i32, align 4
	store i32 16, i32* %32
	%33 = alloca %Struct_sockaddr_in, align 4
	%34 = bitcast %Struct_sockaddr_in* %33 to i8*
	%35 = bitcast i8* %34 to %Struct_sockaddr*
	%36 = bitcast %Struct_sockaddr* %35 to %Struct_sockaddr*
	%37 = call i32 @accept(i32 %1, %Struct_sockaddr* %36, i32* %32)
	%38 = call i1 @write_file(i32 %37)
	br i1 %38 , label %then_3, label %else_3
then_3:
	%39 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
	br label %endif_3
else_3:
	call void @perror(%ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*))
	br label %endif_3
endif_3:
	ret i32 0
}



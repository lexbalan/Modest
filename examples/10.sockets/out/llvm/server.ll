
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
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

; MODULE: server

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; from included socket
%InAddrT = type %Int32;
%InPortT = type %Int16;
%SocklenT = type %Int32;
%Struct_sockaddr = type {
	%UnsignedShort,
	[14 x %Char8]
};

%Struct_in_addr = type {
	%InAddrT
};

%Struct_sockaddr_in = type {
	%Int8,
	%Int8,
	%UnsignedShort,
	%Struct_in_addr,
	[8 x %Int8]
};

declare %InAddrT @inet_addr([0 x %ConstChar]* %cp)
declare %Int @socket(%Int %domain, %Int %_type, %Int %protocol)
declare %Int @bind(%Int %socket, %Struct_sockaddr* %addr, %SocklenT %addrlen)
declare %Int @listen(%Int %socket, %Int %backlog)
declare %Int @connect(%Int %socket, %Struct_sockaddr* %addr, %SocklenT %addrlen)
declare %SSizeT @send(%Int %socket, i8* %buf, %SizeT %len, %Int %flags)
declare %SSizeT @recv(%Int %socket, i8* %buf, %SizeT %len, %Int %flags)
declare %Int @accept(%Int %socket, %Struct_sockaddr* %addr, %SocklenT* %addrlen)
; -- end print includes --
; -- print imports --
; -- end print imports --
; -- strings --
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
; -- endstrings --
define internal %Bool @write_file(%Int %sockfd) {
	%1 = alloca [1024 x %Char8], align 1
	%2 = call %File* @fopen(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%3 = icmp eq %File* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%5 = bitcast [1024 x %Char8]* %1 to i8*
	%6 = call %SSizeT @recv(%Int %sockfd, i8* %5, %SizeT 1024, %Int 0)
	%7 = icmp sle %SSizeT %6, 0
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%9 = call %Int (%File*, %Str*, ...) @fprintf(%File* %2, %Str* bitcast ([3 x i8]* @str4 to [0 x i8]*), [1024 x %Char8]* %1)
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%10 = zext i16 1024 to %Int32
	; -- end vol eval --
	; -- zero fill rest of array
	%11 = mul %Int32 %10, 1
	%12 = bitcast [1024 x %Char8]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %12, i8 0, %Int32 %11, i1 0)
	br label %again_1
break_1:
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int @socket(%Int 2, %Int 1, %Int 0)
	%2 = icmp slt %Int %1, 0
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str6 to [0 x i8]*))
	%4 = alloca %Struct_sockaddr_in, align 16
	%5 = insertvalue %Struct_sockaddr_in zeroinitializer, %Int8 0, 0
	%6 = insertvalue %Struct_sockaddr_in %5, %Int8 2, 1
	%7 = insertvalue %Struct_sockaddr_in %6, %UnsignedShort 8080, 2
	%8 = call %InAddrT @inet_addr([0 x %ConstChar]* bitcast ([10 x i8]* @str7 to [0 x i8]*))
	%9 = insertvalue %Struct_in_addr zeroinitializer, %InAddrT %8, 0
	%10 = insertvalue %Struct_sockaddr_in %7, %Struct_in_addr %9, 3
	%11 = insertvalue %Struct_sockaddr_in %10, [8 x %Int8] zeroinitializer, 4
	store %Struct_sockaddr_in %11, %Struct_sockaddr_in* %4
	%12 = bitcast %Struct_sockaddr_in* %4 to i8*
	%13 = bitcast i8* %12 to %Struct_sockaddr*
	%14 = alloca %Int, align 4
	%15 = call %Int @bind(%Int %1, %Struct_sockaddr* %13, %SocklenT 16)
	store %Int %15, %Int* %14
	%16 = load %Int, %Int* %14
	%17 = icmp slt %Int %16, 0
	br %Bool %17 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_1
endif_1:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
	%19 = call %Int @listen(%Int %1, %Int 10)
	store %Int %19, %Int* %14
	%20 = load %Int, %Int* %14
	%21 = icmp ne %Int %20, 0
	br %Bool %21 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_2
endif_2:
	%22 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([18 x i8]* @str11 to [0 x i8]*))
	%23 = alloca %SocklenT, align 4
	store %SocklenT 16, %SocklenT* %23
	%24 = alloca %Struct_sockaddr_in, align 16
	%25 = bitcast %Struct_sockaddr_in* %24 to i8*
	%26 = bitcast i8* %25 to %Struct_sockaddr*
	%27 = call %Int @accept(%Int %1, %Struct_sockaddr* %26, %SocklenT* %23)
	%28 = call %Bool @write_file(%Int %27)
	br %Bool %28 , label %then_3, label %else_3
then_3:
	%29 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
	br label %endif_3
else_3:
	call void @perror(%ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*))
	br label %endif_3
endif_3:
	ret %Int 0
}



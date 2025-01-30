
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
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; from included stdlib
declare void @abort()
declare %ctypes64_Int @abs(%ctypes64_Int %x)
declare %ctypes64_Int @atexit(void ()* %x)
declare %ctypes64_Double @atof([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_Int @atoi([0 x %ctypes64_ConstChar]* %nptr)
declare %ctypes64_LongInt @atol([0 x %ctypes64_ConstChar]* %nptr)
declare i8* @calloc(%ctypes64_SizeT %num, %ctypes64_SizeT %size)
declare void @exit(%ctypes64_Int %x)
declare void @free(i8* %ptr)
declare %ctypes64_Str* @getenv(%ctypes64_Str* %name)
declare %ctypes64_LongInt @labs(%ctypes64_LongInt %x)
declare %ctypes64_Str* @secure_getenv(%ctypes64_Str* %name)
declare i8* @malloc(%ctypes64_SizeT %size)
declare %ctypes64_Int @system([0 x %ctypes64_ConstChar]* %string)
; from included socket
%socket_InAddrT = type %Int32;
%socket_InPortT = type %Int16;
%socket_SocklenT = type %Int32;
%socket_Struct_sockaddr = type {
	%ctypes64_UnsignedShort,
	[14 x %Char8]
};

%socket_Struct_in_addr = type {
	%socket_InAddrT
};

%socket_Struct_sockaddr_in = type {
	%Int8,
	%Int8,
	%ctypes64_UnsignedShort,
	%socket_Struct_in_addr,
	[8 x %Int8]
};

declare %socket_InAddrT @inet_addr([0 x %ctypes64_ConstChar]* %cp)
declare %ctypes64_Int @socket(%ctypes64_Int %domain, %ctypes64_Int %_type, %ctypes64_Int %protocol)
declare %ctypes64_Int @bind(%ctypes64_Int %socket, %socket_Struct_sockaddr* %addr, %socket_SocklenT %addrlen)
declare %ctypes64_Int @listen(%ctypes64_Int %socket, %ctypes64_Int %backlog)
declare %ctypes64_Int @connect(%ctypes64_Int %socket, %socket_Struct_sockaddr* %addr, %socket_SocklenT %addrlen)
declare %ctypes64_SSizeT @send(%ctypes64_Int %socket, i8* %buf, %ctypes64_SizeT %len, %ctypes64_Int %flags)
declare %ctypes64_SSizeT @recv(%ctypes64_Int %socket, i8* %buf, %ctypes64_SizeT %len, %ctypes64_Int %flags)
declare %ctypes64_Int @accept(%ctypes64_Int %socket, %socket_Struct_sockaddr* %addr, %socket_SocklenT* %addrlen)
; -- end print includes --
; -- print imports 'server' --
; -- 0
; -- end print imports 'server' --
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
define internal %Bool @write_file(%ctypes64_Int %sockfd) {
	%1 = alloca [1024 x %Char8], align 1
	%2 = call %stdio_File* @fopen(%stdio_ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %stdio_ConstCharStr* bitcast ([2 x i8]* @str2 to [0 x i8]*))
	%3 = icmp eq %stdio_File* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @perror(%stdio_ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
	ret %Bool 0
	br label %endif_0
endif_0:
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%5 = bitcast [1024 x %Char8]* %1 to i8*
	%6 = call %ctypes64_SSizeT @recv(%ctypes64_Int %sockfd, i8* %5, %ctypes64_SizeT 1024, %ctypes64_Int 0)
	%7 = icmp sle %ctypes64_SSizeT %6, 0
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%9 = call %ctypes64_Int (%stdio_File*, %ctypes64_Str*, ...) @fprintf(%stdio_File* %2, %ctypes64_Str* bitcast ([3 x i8]* @str4 to [0 x i8]*), [1024 x %Char8]* %1)
	; -- ASSIGN ARRAY --
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

define %ctypes64_Int @main() {
	%1 = call %ctypes64_Int @socket(%ctypes64_Int 2, %ctypes64_Int 1, %ctypes64_Int 0)
	%2 = icmp slt %ctypes64_Int %1, 0
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%stdio_ConstCharStr* bitcast ([20 x i8]* @str5 to [0 x i8]*))
	call void @exit(%ctypes64_Int 1)
	br label %endif_0
endif_0:
	%3 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([27 x i8]* @str6 to [0 x i8]*))
	%4 = alloca %socket_Struct_sockaddr_in, align 16
	%5 = insertvalue %socket_Struct_sockaddr_in zeroinitializer, %Int8 2, 1
	%6 = insertvalue %socket_Struct_sockaddr_in %5, %ctypes64_UnsignedShort 8080, 2
	%7 = call %socket_InAddrT @inet_addr([0 x %ctypes64_ConstChar]* bitcast ([10 x i8]* @str7 to [0 x i8]*))
	%8 = insertvalue %socket_Struct_in_addr zeroinitializer, %socket_InAddrT %7, 0
	%9 = insertvalue %socket_Struct_sockaddr_in %6, %socket_Struct_in_addr %8, 3
	store %socket_Struct_sockaddr_in %9, %socket_Struct_sockaddr_in* %4
	%10 = bitcast %socket_Struct_sockaddr_in* %4 to i8*
	%11 = bitcast i8* %10 to %socket_Struct_sockaddr*
	%12 = alloca %ctypes64_Int, align 4
	%13 = call %ctypes64_Int @bind(%ctypes64_Int %1, %socket_Struct_sockaddr* %11, %socket_SocklenT 16)
	store %ctypes64_Int %13, %ctypes64_Int* %12
	%14 = load %ctypes64_Int, %ctypes64_Int* %12
	%15 = icmp slt %ctypes64_Int %14, 0
	br %Bool %15 , label %then_1, label %endif_1
then_1:
	call void @perror(%stdio_ConstCharStr* bitcast ([21 x i8]* @str8 to [0 x i8]*))
	call void @exit(%ctypes64_Int 1)
	br label %endif_1
endif_1:
	%16 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
	%17 = call %ctypes64_Int @listen(%ctypes64_Int %1, %ctypes64_Int 10)
	store %ctypes64_Int %17, %ctypes64_Int* %12
	%18 = load %ctypes64_Int, %ctypes64_Int* %12
	%19 = icmp ne %ctypes64_Int %18, 0
	br %Bool %19 , label %then_2, label %endif_2
then_2:
	call void @perror(%stdio_ConstCharStr* bitcast ([21 x i8]* @str10 to [0 x i8]*))
	call void @exit(%ctypes64_Int 1)
	br label %endif_2
endif_2:
	%20 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([18 x i8]* @str11 to [0 x i8]*))
	%21 = alloca %socket_SocklenT, align 4
	store %socket_SocklenT 16, %socket_SocklenT* %21
	%22 = alloca %socket_Struct_sockaddr_in, align 16
	%23 = bitcast %socket_Struct_sockaddr_in* %22 to i8*
	%24 = bitcast i8* %23 to %socket_Struct_sockaddr*
	%25 = call %ctypes64_Int @accept(%ctypes64_Int %1, %socket_Struct_sockaddr* %24, %socket_SocklenT* %21)
	%26 = call %Bool @write_file(%ctypes64_Int %25)
	br %Bool %26 , label %then_3, label %else_3
then_3:
	%27 = call %ctypes64_Int (%stdio_ConstCharStr*, ...) @printf(%stdio_ConstCharStr* bitcast ([34 x i8]* @str12 to [0 x i8]*))
	br label %endif_3
else_3:
	call void @perror(%stdio_ConstCharStr* bitcast ([22 x i8]* @str13 to [0 x i8]*))
	br label %endif_3
endif_3:
	ret %ctypes64_Int 0
}



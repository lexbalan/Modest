
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Size = type i64
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

; MODULE: main

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare [0 x %Char]* @strncpy([0 x %Char]* %dst, [0 x %ConstChar]* %src, %SizeT %n)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
; from included unistd
declare %Int @access([0 x %ConstChar]* %path, %Int %amode)
declare %UnsignedInt @alarm(%UnsignedInt %seconds)
declare %Int @brk(i8* %end_data_segment)
declare %Int @chdir([0 x %ConstChar]* %path)
declare %Int @chroot([0 x %ConstChar]* %path)
declare %Int @chown([0 x %ConstChar]* %pathname, %UIDT %owner, %GIDT %group)
declare %Int @close(%Int %fildes)
declare %SizeT @confstr(%Int %name, [0 x %Char]* %buf, %SizeT %len)
declare [0 x %Char]* @crypt([0 x %ConstChar]* %key, [0 x %ConstChar]* %salt)
declare [0 x %Char]* @ctermid([0 x %Char]* %s)
declare [0 x %Char]* @cuserid([0 x %Char]* %s)
declare %Int @dup(%Int %fildes)
declare %Int @dup2(%Int %fildes, %Int %fildes2)
declare void @encrypt([64 x %Char]* %block, %Int %edflag)
declare %Int @execl([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execle([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execlp([0 x %ConstChar]* %file, [0 x %ConstChar]* %arg0, ...)
declare %Int @execv([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv)
declare %Int @execve([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %envp)
declare %Int @execvp([0 x %ConstChar]* %file, [0 x %ConstChar]* %argv)
declare void @_exit(%Int %status)
declare %Int @fchown(%Int %fildes, %UIDT %owner, %GIDT %group)
declare %Int @fchdir(%Int %fildes)
declare %Int @fdatasync(%Int %fildes)
declare %PIDT @fork()
declare %LongInt @fpathconf(%Int %fildes, %Int %name)
declare %Int @fsync(%Int %fildes)
declare %Int @ftruncate(%Int %fildes, %OffT %length)
declare [0 x %Char]* @getcwd([0 x %Char]* %buf, %SizeT %size)
declare %Int @getdtablesize()
declare %GIDT @getegid()
declare %UIDT @geteuid()
declare %GIDT @getgid()
declare %Int @getgroups(%Int %gidsetsize, [0 x %GIDT]* %grouplist)
declare %Long @gethostid()
declare [0 x %Char]* @getlogin()
declare %Int @getlogin_r([0 x %Char]* %name, %SizeT %namesize)
declare %Int @getopt(%Int %argc, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %optstring)
declare %Int @getpagesize()
declare [0 x %Char]* @getpass([0 x %ConstChar]* %prompt)
declare %PIDT @getpgid(%PIDT %pid)
declare %PIDT @getpgrp()
declare %PIDT @getpid()
declare %PIDT @getppid()
declare %PIDT @getsid(%PIDT %pid)
declare %UIDT @getuid()
declare [0 x %Char]* @getwd([0 x %Char]* %path_name)
declare %Int @isatty(%Int %fildes)
declare %Int @lchown([0 x %ConstChar]* %path, %UIDT %owner, %GIDT %group)
declare %Int @link([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare %Int @lockf(%Int %fildes, %Int %function, %OffT %size)
declare %OffT @lseek(%Int %fildes, %OffT %offset, %Int %whence)
declare %Int @nice(%Int %incr)
declare %LongInt @pathconf([0 x %ConstChar]* %path, %Int %name)
declare %Int @pause()
declare %Int @pipe([2 x %Int]* %fildes)
declare %SSizeT @pread(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @pwrite(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @read(%Int %fildes, i8* %buf, %SizeT %nbyte)
declare %Int @readlink([0 x %ConstChar]* %path, [0 x %Char]* %buf, %SizeT %bufsize)
declare %Int @rmdir([0 x %ConstChar]* %path)
declare i8* @sbrk(%IntPtrT %incr)
declare %Int @setgid(%GIDT %gid)
declare %Int @setpgid(%PIDT %pid, %PIDT %pgid)
declare %PIDT @setpgrp()
declare %Int @setregid(%GIDT %rgid, %GIDT %egid)
declare %Int @setreuid(%UIDT %ruid, %UIDT %euid)
declare %PIDT @setsid()
declare %Int @setuid(%UIDT %uid)
declare %UnsignedInt @sleep(%UnsignedInt %seconds)
declare void @swab(i8* %src, i8* %dst, %SSizeT %nbytes)
declare %Int @symlink([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare void @sync()
declare %LongInt @sysconf(%Int %name)
declare %PIDT @tcgetpgrp(%Int %fildes)
declare %Int @tcsetpgrp(%Int %fildes, %PIDT %pgid_id)
declare %Int @truncate([0 x %ConstChar]* %path, %OffT %length)
declare [0 x %Char]* @ttyname(%Int %fildes)
declare %Int @ttyname_r(%Int %fildes, [0 x %Char]* %name, %SizeT %namesize)
declare %USecondsT @ualarm(%USecondsT %useconds, %USecondsT %interval)
declare %Int @unlink([0 x %ConstChar]* %path)
declare %Int @usleep(%USecondsT %useconds)
declare %PIDT @vfork()
declare %SSizeT @write(%Int %fildes, i8* %buf, %SizeT %nbyte)
; from included socket
%InAddrT = type %Nat32;
%InPortT = type %Nat16;
%SocklenT = type %Nat32;
%SockAddr = type {
	%UnsignedShort,
	[14 x %Char8]
};

%Struct_in_addr = type {
	%InAddrT
};

%SockAddrIn = type {
	%Nat8,
	%Nat8,
	%UnsignedShort,
	%Struct_in_addr,
	[8 x %Nat8]
};

declare %Int @setsockopt(%Int %socket, %Int %level, %Int %option_name, i8* %option_value, %SocklenT %option_len)
declare %InAddrT @inet_addr([0 x %ConstChar]* %cp)
declare %Int @socket(%Int %domain, %Int %_type, %Int %protocol)
declare %Int @bind(%Int %socket, %SockAddr* %addr, %SocklenT %addrlen)
declare %Int @listen(%Int %socket, %Int %backlog)
declare %Int @connect(%Int %socket, %SockAddr* %addr, %SocklenT %addrlen)
declare %SSizeT @send(%Int %socket, i8* %buf, %SizeT %len, %Int %flags)
declare %SSizeT @recv(%Int %socket, i8* %buf, %SizeT %len, %Int %flags)
declare %Int @accept(%Int %socket, %SockAddr* %addr, %SocklenT* %addrlen)
; from included inet
declare %Word32 @htonl(%Word32 %host32)
declare %Word32 @ntohl(%Word32 %net32)
declare %Word16 @ntohs(%Word16 %net16)
declare %Word16 @htons(%Word16 %x)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [64 x i8] [i8 72, i8 84, i8 84, i8 80, i8 47, i8 49, i8 46, i8 49, i8 32, i8 50, i8 48, i8 48, i8 32, i8 79, i8 75, i8 13, i8 10, i8 67, i8 111, i8 110, i8 116, i8 101, i8 110, i8 116, i8 45, i8 84, i8 121, i8 112, i8 101, i8 58, i8 32, i8 116, i8 101, i8 120, i8 116, i8 47, i8 104, i8 116, i8 109, i8 108, i8 13, i8 10, i8 67, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 105, i8 111, i8 110, i8 58, i8 32, i8 99, i8 108, i8 111, i8 115, i8 101, i8 13, i8 10, i8 13, i8 10, i8 0]
@str2 = private constant [19 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 114, i8 101, i8 97, i8 100, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str3 = private constant [22 x i8] [i8 82, i8 101, i8 99, i8 101, i8 105, i8 118, i8 101, i8 100, i8 32, i8 114, i8 101, i8 113, i8 117, i8 101, i8 115, i8 116, i8 58, i8 10, i8 37, i8 115, i8 10, i8 0]
@str4 = private constant [56 x i8] [i8 37, i8 115, i8 60, i8 104, i8 116, i8 109, i8 108, i8 62, i8 60, i8 98, i8 111, i8 100, i8 121, i8 62, i8 60, i8 104, i8 49, i8 62, i8 72, i8 101, i8 108, i8 108, i8 111, i8 44, i8 32, i8 87, i8 111, i8 114, i8 108, i8 100, i8 33, i8 32, i8 40, i8 37, i8 100, i8 41, i8 60, i8 47, i8 104, i8 49, i8 62, i8 60, i8 47, i8 98, i8 111, i8 100, i8 121, i8 62, i8 60, i8 47, i8 104, i8 116, i8 109, i8 108, i8 62, i8 0]
@str5 = private constant [21 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str6 = private constant [19 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 98, i8 105, i8 110, i8 100, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str7 = private constant [21 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 108, i8 105, i8 115, i8 116, i8 101, i8 110, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str8 = private constant [32 x i8] [i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 108, i8 105, i8 115, i8 116, i8 101, i8 110, i8 105, i8 110, i8 103, i8 32, i8 111, i8 110, i8 32, i8 112, i8 111, i8 114, i8 116, i8 32, i8 37, i8 100, i8 46, i8 46, i8 46, i8 10, i8 0]
@str9 = private constant [25 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 97, i8 99, i8 99, i8 101, i8 112, i8 116, i8 32, i8 99, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 105, i8 111, i8 110, i8 0]
; -- endstrings --
@pageCounter = internal global %Nat32 zeroinitializer
define internal void @handleRequest(%Int32 %clientSocket) {
	%1 = alloca [1024 x %Word8], align 1
	%2 = bitcast [1024 x %Word8]* %1 to i8*
	%3 = call %SSizeT @read(%Int32 %clientSocket, i8* %2, %SizeT 1023)
; if_0
	%4 = icmp slt %SSizeT %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
	%5 = call %Int @close(%Int32 %clientSocket)
	ret void
	br label %endif_0
endif_0:
	%7 = trunc %SSizeT %3 to %Nat32
	%8 = getelementptr [1024 x %Word8], [1024 x %Word8]* %1, %Int32 0, %Nat32 %7
	%9 = bitcast i8 0 to %Word8
	store %Word8 %9, %Word8* %8
	%10 = bitcast [1024 x %Word8]* %1 to %Str8*
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str3 to [0 x i8]*), %Str8* %10)
	%12 = alloca [1024 x %Char8], align 1
	%13 = bitcast [1024 x %Char8]* %12 to %CharStr*
	%14 = load %Nat32, %Nat32* @pageCounter
	%15 = call %Int (%CharStr*, %ConstCharStr*, ...) @sprintf(%CharStr* %13, %ConstCharStr* bitcast ([56 x i8]* @str4 to [0 x i8]*), %Str8* bitcast ([64 x i8]* @str1 to [0 x i8]*), %Nat32 %14)
	%16 = bitcast [1024 x %Char8]* %12 to i8*
	%17 = bitcast [1024 x %Char8]* %12 to [0 x %ConstChar]*
	%18 = call %SizeT @strlen([0 x %ConstChar]* %17)
	%19 = call %SSizeT @write(%Int32 %clientSocket, i8* %16, %SizeT %18)
	%20 = call %Int @close(%Int32 %clientSocket)
	ret void
}

define %Int32 @main() {
	%1 = call %Int @socket(%Int 2, %Int 1, %Int 0)
; if_0
	%2 = icmp slt %Int %1, 0
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str5 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%3 = alloca %SockAddrIn, align 16
	%4 = insertvalue %SockAddrIn zeroinitializer, %Nat8 2, 1
	%5 = bitcast i16 8080 to %Word16
	%6 = call %Word16 @htons(%Word16 %5)
	%7 = bitcast %Word16 %6 to %UnsignedShort
	%8 = insertvalue %SockAddrIn %4, %UnsignedShort %7, 2
	store %SockAddrIn %8, %SockAddrIn* %3

	; Bind socket to address
	%9 = bitcast %SockAddrIn* %3 to %SockAddr*
	%10 = alloca %Int, align 4
	%11 = call %Int @bind(%Int %1, %SockAddr* %9, %SocklenT 16)
	store %Int %11, %Int* %10
; if_1
	%12 = load %Int, %Int* %10
	%13 = icmp slt %Int %12, 0
	br %Bool %13 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([19 x i8]* @str6 to [0 x i8]*))
	%14 = call %Int @close(%Int %1)
	call void @exit(%Int 1)
	br label %endif_1
endif_1:

	; Starting listen to connection
	%15 = call %Int @listen(%Int %1, %Int 5)
	store %Int %15, %Int* %10
; if_2
	%16 = load %Int, %Int* %10
	%17 = icmp slt %Int %16, 0
	br %Bool %17 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([21 x i8]* @str7 to [0 x i8]*))
	%18 = call %Int @close(%Int %1)
	call void @exit(%Int 1)
	br label %endif_2
endif_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str8 to [0 x i8]*), %Nat32 8080)

	; Handle input connections
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%20 = alloca %SockAddrIn, align 16
	%21 = bitcast %SockAddrIn* %20 to %SockAddr*
	%22 = alloca %SocklenT, align 4
	store %SocklenT 16, %SocklenT* %22
	%23 = call %Int @accept(%Int %1, %SockAddr* %21, %SocklenT* %22)
; if_3
	%24 = icmp slt %Int %23, 0
	br %Bool %24 , label %then_3, label %endif_3
then_3:
	call void @perror(%ConstCharStr* bitcast ([25 x i8]* @str9 to [0 x i8]*))
	br label %again_1
	br label %endif_3
endif_3:
	call void @handleRequest(%Int %23)
	%26 = load %Nat32, %Nat32* @pageCounter
	%27 = add %Nat32 %26, 1
	store %Nat32 %27, %Nat32* @pageCounter
	br label %again_1
break_1:
	%28 = call %Int @close(%Int %1)
	ret %Int32 0
}



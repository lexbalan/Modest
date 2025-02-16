
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

; MODULE: main

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
; from included string
declare i8* @memset(i8* %mem, %Int %c, %SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %SizeT %n)
declare %Int @memcmp(i8* %p0, i8* %p1, %SizeT %num)
declare %Int @strncmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare %Int @strcmp([0 x %ConstChar]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strcpy([0 x %Char]* %dst, [0 x %ConstChar]* %src)
declare %SizeT @strlen([0 x %ConstChar]* %s)
declare [0 x %Char]* @strcat([0 x %Char]* %s1, [0 x %ConstChar]* %s2)
declare [0 x %Char]* @strncat([0 x %Char]* %s1, [0 x %ConstChar]* %s2, %SizeT %n)
declare [0 x %Char]* @strerror(%Int %error)
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
declare %Int @pthread_atfork(void ()* %prepare, void ()* %parent, void ()* %child)
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
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [5 x i8] [i8 114, i8 101, i8 97, i8 100, i8 0]
@str2 = private constant [22 x i8] [i8 82, i8 101, i8 99, i8 101, i8 105, i8 118, i8 101, i8 100, i8 32, i8 114, i8 101, i8 113, i8 117, i8 101, i8 115, i8 116, i8 58, i8 10, i8 37, i8 115, i8 10, i8 0]
@str3 = private constant [7 x i8] [i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str4 = private constant [5 x i8] [i8 98, i8 105, i8 110, i8 100, i8 0]
@str5 = private constant [7 x i8] [i8 108, i8 105, i8 115, i8 116, i8 101, i8 110, i8 0]
@str6 = private constant [32 x i8] [i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 108, i8 105, i8 115, i8 116, i8 101, i8 110, i8 105, i8 110, i8 103, i8 32, i8 111, i8 110, i8 32, i8 112, i8 111, i8 114, i8 116, i8 32, i8 37, i8 100, i8 46, i8 46, i8 46, i8 10, i8 0]
@str7 = private constant [7 x i8] [i8 97, i8 99, i8 99, i8 101, i8 112, i8 116, i8 0]
; -- endstrings --
define internal %Word16 @main_htons(%Word16 %x) {
	%1 = zext i8 8 to %Word16
	%2 = shl %Word16 %x, %1
	%3 = zext i8 8 to %Word16
	%4 = lshr %Word16 %x, %3
	%5 = or %Word16 %2, %4
	ret %Word16 %5
}

define internal void @main_handle_request(%Int32 %client_socket) {
	%1 = alloca [4096 x %Word8], align 1
	%2 = bitcast [4096 x %Word8]* %1 to i8*
	%3 = call %SSizeT @read(%Int32 %client_socket, i8* %2, %SizeT 4095)
	%4 = icmp slt %SSizeT %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([5 x i8]* @str1 to [0 x i8]*))
	%5 = call %Int @close(%Int32 %client_socket)
	ret void
	br label %endif_0
endif_0:
	%7 = trunc %SSizeT %3 to %Int32
	%8 = getelementptr [4096 x %Word8], [4096 x %Word8]* %1, %Int32 0, %Int32 %7
	store %Word8 0, %Word8* %8
	%9 = bitcast [4096 x %Word8]* %1 to %Str8*
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str2 to [0 x i8]*), %Str8* %9)
	%11 = alloca [112 x %Char8], align 1
	%12 = insertvalue [112 x %Char8] zeroinitializer, %Char8 72, 0
	%13 = insertvalue [112 x %Char8] %12, %Char8 84, 1
	%14 = insertvalue [112 x %Char8] %13, %Char8 84, 2
	%15 = insertvalue [112 x %Char8] %14, %Char8 80, 3
	%16 = insertvalue [112 x %Char8] %15, %Char8 47, 4
	%17 = insertvalue [112 x %Char8] %16, %Char8 49, 5
	%18 = insertvalue [112 x %Char8] %17, %Char8 46, 6
	%19 = insertvalue [112 x %Char8] %18, %Char8 49, 7
	%20 = insertvalue [112 x %Char8] %19, %Char8 32, 8
	%21 = insertvalue [112 x %Char8] %20, %Char8 50, 9
	%22 = insertvalue [112 x %Char8] %21, %Char8 48, 10
	%23 = insertvalue [112 x %Char8] %22, %Char8 48, 11
	%24 = insertvalue [112 x %Char8] %23, %Char8 32, 12
	%25 = insertvalue [112 x %Char8] %24, %Char8 79, 13
	%26 = insertvalue [112 x %Char8] %25, %Char8 75, 14
	%27 = insertvalue [112 x %Char8] %26, %Char8 13, 15
	%28 = insertvalue [112 x %Char8] %27, %Char8 10, 16
	%29 = insertvalue [112 x %Char8] %28, %Char8 67, 17
	%30 = insertvalue [112 x %Char8] %29, %Char8 111, 18
	%31 = insertvalue [112 x %Char8] %30, %Char8 110, 19
	%32 = insertvalue [112 x %Char8] %31, %Char8 116, 20
	%33 = insertvalue [112 x %Char8] %32, %Char8 101, 21
	%34 = insertvalue [112 x %Char8] %33, %Char8 110, 22
	%35 = insertvalue [112 x %Char8] %34, %Char8 116, 23
	%36 = insertvalue [112 x %Char8] %35, %Char8 45, 24
	%37 = insertvalue [112 x %Char8] %36, %Char8 84, 25
	%38 = insertvalue [112 x %Char8] %37, %Char8 121, 26
	%39 = insertvalue [112 x %Char8] %38, %Char8 112, 27
	%40 = insertvalue [112 x %Char8] %39, %Char8 101, 28
	%41 = insertvalue [112 x %Char8] %40, %Char8 58, 29
	%42 = insertvalue [112 x %Char8] %41, %Char8 32, 30
	%43 = insertvalue [112 x %Char8] %42, %Char8 116, 31
	%44 = insertvalue [112 x %Char8] %43, %Char8 101, 32
	%45 = insertvalue [112 x %Char8] %44, %Char8 120, 33
	%46 = insertvalue [112 x %Char8] %45, %Char8 116, 34
	%47 = insertvalue [112 x %Char8] %46, %Char8 47, 35
	%48 = insertvalue [112 x %Char8] %47, %Char8 104, 36
	%49 = insertvalue [112 x %Char8] %48, %Char8 116, 37
	%50 = insertvalue [112 x %Char8] %49, %Char8 109, 38
	%51 = insertvalue [112 x %Char8] %50, %Char8 108, 39
	%52 = insertvalue [112 x %Char8] %51, %Char8 13, 40
	%53 = insertvalue [112 x %Char8] %52, %Char8 10, 41
	%54 = insertvalue [112 x %Char8] %53, %Char8 67, 42
	%55 = insertvalue [112 x %Char8] %54, %Char8 111, 43
	%56 = insertvalue [112 x %Char8] %55, %Char8 110, 44
	%57 = insertvalue [112 x %Char8] %56, %Char8 110, 45
	%58 = insertvalue [112 x %Char8] %57, %Char8 101, 46
	%59 = insertvalue [112 x %Char8] %58, %Char8 99, 47
	%60 = insertvalue [112 x %Char8] %59, %Char8 116, 48
	%61 = insertvalue [112 x %Char8] %60, %Char8 105, 49
	%62 = insertvalue [112 x %Char8] %61, %Char8 111, 50
	%63 = insertvalue [112 x %Char8] %62, %Char8 110, 51
	%64 = insertvalue [112 x %Char8] %63, %Char8 58, 52
	%65 = insertvalue [112 x %Char8] %64, %Char8 32, 53
	%66 = insertvalue [112 x %Char8] %65, %Char8 99, 54
	%67 = insertvalue [112 x %Char8] %66, %Char8 108, 55
	%68 = insertvalue [112 x %Char8] %67, %Char8 111, 56
	%69 = insertvalue [112 x %Char8] %68, %Char8 115, 57
	%70 = insertvalue [112 x %Char8] %69, %Char8 101, 58
	%71 = insertvalue [112 x %Char8] %70, %Char8 13, 59
	%72 = insertvalue [112 x %Char8] %71, %Char8 10, 60
	%73 = insertvalue [112 x %Char8] %72, %Char8 13, 61
	%74 = insertvalue [112 x %Char8] %73, %Char8 10, 62
	%75 = insertvalue [112 x %Char8] %74, %Char8 60, 63
	%76 = insertvalue [112 x %Char8] %75, %Char8 104, 64
	%77 = insertvalue [112 x %Char8] %76, %Char8 116, 65
	%78 = insertvalue [112 x %Char8] %77, %Char8 109, 66
	%79 = insertvalue [112 x %Char8] %78, %Char8 108, 67
	%80 = insertvalue [112 x %Char8] %79, %Char8 62, 68
	%81 = insertvalue [112 x %Char8] %80, %Char8 60, 69
	%82 = insertvalue [112 x %Char8] %81, %Char8 98, 70
	%83 = insertvalue [112 x %Char8] %82, %Char8 111, 71
	%84 = insertvalue [112 x %Char8] %83, %Char8 100, 72
	%85 = insertvalue [112 x %Char8] %84, %Char8 121, 73
	%86 = insertvalue [112 x %Char8] %85, %Char8 62, 74
	%87 = insertvalue [112 x %Char8] %86, %Char8 60, 75
	%88 = insertvalue [112 x %Char8] %87, %Char8 104, 76
	%89 = insertvalue [112 x %Char8] %88, %Char8 49, 77
	%90 = insertvalue [112 x %Char8] %89, %Char8 62, 78
	%91 = insertvalue [112 x %Char8] %90, %Char8 72, 79
	%92 = insertvalue [112 x %Char8] %91, %Char8 101, 80
	%93 = insertvalue [112 x %Char8] %92, %Char8 108, 81
	%94 = insertvalue [112 x %Char8] %93, %Char8 108, 82
	%95 = insertvalue [112 x %Char8] %94, %Char8 111, 83
	%96 = insertvalue [112 x %Char8] %95, %Char8 44, 84
	%97 = insertvalue [112 x %Char8] %96, %Char8 32, 85
	%98 = insertvalue [112 x %Char8] %97, %Char8 87, 86
	%99 = insertvalue [112 x %Char8] %98, %Char8 111, 87
	%100 = insertvalue [112 x %Char8] %99, %Char8 114, 88
	%101 = insertvalue [112 x %Char8] %100, %Char8 108, 89
	%102 = insertvalue [112 x %Char8] %101, %Char8 100, 90
	%103 = insertvalue [112 x %Char8] %102, %Char8 33, 91
	%104 = insertvalue [112 x %Char8] %103, %Char8 60, 92
	%105 = insertvalue [112 x %Char8] %104, %Char8 47, 93
	%106 = insertvalue [112 x %Char8] %105, %Char8 104, 94
	%107 = insertvalue [112 x %Char8] %106, %Char8 49, 95
	%108 = insertvalue [112 x %Char8] %107, %Char8 62, 96
	%109 = insertvalue [112 x %Char8] %108, %Char8 60, 97
	%110 = insertvalue [112 x %Char8] %109, %Char8 47, 98
	%111 = insertvalue [112 x %Char8] %110, %Char8 98, 99
	%112 = insertvalue [112 x %Char8] %111, %Char8 111, 100
	%113 = insertvalue [112 x %Char8] %112, %Char8 100, 101
	%114 = insertvalue [112 x %Char8] %113, %Char8 121, 102
	%115 = insertvalue [112 x %Char8] %114, %Char8 62, 103
	%116 = insertvalue [112 x %Char8] %115, %Char8 60, 104
	%117 = insertvalue [112 x %Char8] %116, %Char8 47, 105
	%118 = insertvalue [112 x %Char8] %117, %Char8 104, 106
	%119 = insertvalue [112 x %Char8] %118, %Char8 116, 107
	%120 = insertvalue [112 x %Char8] %119, %Char8 109, 108
	%121 = insertvalue [112 x %Char8] %120, %Char8 108, 109
	%122 = insertvalue [112 x %Char8] %121, %Char8 62, 110
	%123 = insertvalue [112 x %Char8] %122, %Char8 0, 111
	%124 = zext i8 112 to %Int32
	store [112 x %Char8] %123, [112 x %Char8]* %11
	%125 = bitcast [112 x %Char8]* %11 to i8*
	%126 = bitcast [112 x %Char8]* %11 to [0 x %ConstChar]*
	%127 = call %SizeT @strlen([0 x %ConstChar]* %126)
	%128 = call %SSizeT @write(%Int32 %client_socket, i8* %125, %SizeT %127)
	%129 = call %Int @close(%Int32 %client_socket)
	ret void
}

define %Int32 @main() {
	%1 = call %Int @socket(%Int 2, %Int 1, %Int 0)
	%2 = icmp slt %Int %1, 0
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([7 x i8]* @str3 to [0 x i8]*))
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%3 = alloca %Struct_sockaddr_in, align 16
	%4 = insertvalue %Struct_sockaddr_in zeroinitializer, %Int8 2, 1
	%5 = call %Word16 @main_htons(%Word16 8080)
	%6 = bitcast %Word16 %5 to %UnsignedShort
	%7 = insertvalue %Struct_sockaddr_in %4, %UnsignedShort %6, 2
	store %Struct_sockaddr_in %7, %Struct_sockaddr_in* %3

	; Bind socket to address
	%8 = bitcast %Struct_sockaddr_in* %3 to %Struct_sockaddr*
	%9 = alloca %Int, align 4
	%10 = call %Int @bind(%Int %1, %Struct_sockaddr* %8, %SocklenT 16)
	store %Int %10, %Int* %9
	%11 = load %Int, %Int* %9
	%12 = icmp slt %Int %11, 0
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([5 x i8]* @str4 to [0 x i8]*))
	%13 = call %Int @close(%Int %1)
	call void @exit(%Int 1)
	br label %endif_1
endif_1:

	; Starting listen to connection
	%14 = call %Int @listen(%Int %1, %Int 5)
	store %Int %14, %Int* %9
	%15 = load %Int, %Int* %9
	%16 = icmp slt %Int %15, 0
	br %Bool %16 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([7 x i8]* @str5 to [0 x i8]*))
	%17 = call %Int @close(%Int %1)
	call void @exit(%Int 1)
	br label %endif_2
endif_2:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([32 x i8]* @str6 to [0 x i8]*), %Int32 8080)

	; Handle input connections
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%19 = alloca %Struct_sockaddr_in, align 16
	%20 = bitcast %Struct_sockaddr_in* %19 to %Struct_sockaddr*
	%21 = alloca %SocklenT, align 4
	store %SocklenT 16, %SocklenT* %21
	%22 = call %Int @accept(%Int %1, %Struct_sockaddr* %20, %SocklenT* %21)
	%23 = icmp slt %Int %22, 0
	br %Bool %23 , label %then_3, label %endif_3
then_3:
	call void @perror(%ConstCharStr* bitcast ([7 x i8]* @str7 to [0 x i8]*))
	br label %again_1
	br label %endif_3
endif_3:
	call void @main_handle_request(%Int %22)
	br label %again_1
break_1:
	%25 = call %Int @close(%Int %1)
	ret %Int32 0
}



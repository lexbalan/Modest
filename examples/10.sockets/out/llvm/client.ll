
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



%Str = type %Str8;;
%Char = type i8;;
%ConstChar = type i8;;
%SignedChar = type i8;;
%UnsignedChar = type i8;;
%Short = type i16;;
%UnsignedShort = type i16;;
%Int = type i32;;
%UnsignedInt = type i32;;
%LongInt = type i64;;
%UnsignedLongInt = type i64;;
%Long = type i64;;
%UnsignedLong = type i64;;
%LongLong = type i64;;
%UnsignedLongLong = type i64;;
%LongLongInt = type i64;;
%UnsignedLongLongInt = type i64;;
%Float = type double;;
%Double = type double;;
%LongDouble = type double;;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%SocklenT = type i32;;
%SizeT = type i64;;
%SSizeT = type i64;;
%IntptrT = type i64;;
%PtrdiffT = type i8*;;
%OffT = type i64;;
%USecondsT = type i32;;
%PidT = type i32;;
%UidT = type i32;;
%GidT = type i32;;


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str;;
%ConstCharStr = type %CharStr;;


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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/unistd.hm

































declare i32 @access([0 x i8]* %path, i32 %amode)


declare i32 @alarm(i32 %seconds)


declare i32 @brk(i8* %end_data_segment)


declare i32 @chdir([0 x i8]* %path)


declare i32 @chroot([0 x i8]* %path)


declare i32 @chown([0 x i8]* %pathname, i32 %owner, i32 %group)


declare i32 @close(i32 %fildes)


declare i64 @confstr(i32 %name, [0 x i8]* %buf, i64 %len)


declare [0 x i8]* @crypt([0 x i8]* %key, [0 x i8]* %salt)


declare [0 x i8]* @ctermid([0 x i8]* %s)


declare [0 x i8]* @cuserid([0 x i8]* %s)


declare i32 @dup(i32 %fildes)


declare i32 @dup2(i32 %fildes, i32 %fildes2)


declare void @encrypt([64 x i8]* %block, i32 %edflag)


declare i32 @execl([0 x i8]* %path, [0 x i8]* %arg0, ...)
declare i32 @execle([0 x i8]* %path, [0 x i8]* %arg0, ...)
declare i32 @execlp([0 x i8]* %file, [0 x i8]* %arg0, ...)
declare i32 @execv([0 x i8]* %path, [0 x i8]* %argv)
declare i32 @execve([0 x i8]* %path, [0 x i8]* %argv, [0 x i8]* %envp)
declare i32 @execvp([0 x i8]* %file, [0 x i8]* %argv)


declare void @_exit(i32 %status)


declare i32 @fchown(i32 %fildes, i32 %owner, i32 %group)


declare i32 @fchdir(i32 %fildes)


declare i32 @fdatasync(i32 %fildes)


declare i32 @fork()


declare i64 @fpathconf(i32 %fildes, i32 %name)


declare i32 @fsync(i32 %fildes)


declare i32 @ftruncate(i32 %fildes, i64 %length)


declare [0 x i8]* @getcwd([0 x i8]* %buf, i64 %size)


declare i32 @getdtablesize()


declare i32 @getegid()


declare i32 @geteuid()


declare i32 @getgid()


declare i32 @getgroups(i32 %gidsetsize, [0 x i32]* %grouplist)


declare i64 @gethostid()


declare [0 x i8]* @getlogin()


declare i32 @getlogin_r([0 x i8]* %name, i64 %namesize)


declare i32 @getopt(i32 %argc, [0 x i8]* %argv, [0 x i8]* %optstring)


declare i32 @getpagesize()


declare [0 x i8]* @getpass([0 x i8]* %prompt)


declare i32 @getpgid(i32 %pid)


declare i32 @getpgrp()


declare i32 @getpid()


declare i32 @getppid()


declare i32 @getsid(i32 %pid)


declare i32 @getuid()


declare [0 x i8]* @getwd([0 x i8]* %path_name)


declare i32 @isatty(i32 %fildes)


declare i32 @lchown([0 x i8]* %path, i32 %owner, i32 %group)


declare i32 @link([0 x i8]* %path1, [0 x i8]* %path2)


declare i32 @lockf(i32 %fildes, i32 %function, i64 %size)


declare i64 @lseek(i32 %fildes, i64 %offset, i32 %whence)


declare i32 @nice(i32 %incr)


declare i64 @pathconf([0 x i8]* %path, i32 %name)


declare i32 @pause()


declare i32 @pipe([2 x i32]* %fildes)


declare i64 @pread(i32 %fildes, i8* %buf, i64 %nbyte, i64 %offset)


declare i32 @pthread_atfork(void ()* %prepare, void ()* %parent, void ()* %child)


declare i64 @pwrite(i32 %fildes, i8* %buf, i64 %nbyte, i64 %offset)


declare i64 @read(i32 %fildes, i8* %buf, i64 %nbyte)


declare i32 @readlink([0 x i8]* %path, [0 x i8]* %buf, i64 %bufsize)


declare i32 @rmdir([0 x i8]* %path)


declare i8* @sbrk(i64 %incr)


declare i32 @setgid(i32 %gid)


declare i32 @setpgid(i32 %pid, i32 %pgid)


declare i32 @setpgrp()


declare i32 @setregid(i32 %rgid, i32 %egid)


declare i32 @setreuid(i32 %ruid, i32 %euid)


declare i32 @setsid()


declare i32 @setuid(i32 %uid)


declare i32 @sleep(i32 %seconds)


declare void @swab(i8* %src, i8* %dst, i64 %nbytes)


declare i32 @symlink([0 x i8]* %path1, [0 x i8]* %path2)


declare void @sync()


declare i64 @sysconf(i32 %name)


declare i32 @tcgetpgrp(i32 %fildes)


declare i32 @tcsetpgrp(i32 %fildes, i32 %pgid_id)


declare i32 @truncate([0 x i8]* %path, i64 %length)


declare [0 x i8]* @ttyname(i32 %fildes)


declare i32 @ttyname_r(i32 %fildes, [0 x i8]* %name, i64 %namesize)


declare i32 @ualarm(i32 %useconds, i32 %interval)


declare i32 @unlink([0 x i8]* %path)


declare i32 @usleep(i32 %useconds)


declare i32 @vfork()


declare i64 @write(i32 %fildes, i8* %buf, i64 %nbyte)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/socket.hm




%In_addr_t = type i32;;
%In_port_t = type i16;;
%Socklen_t = type i32;;
%Struct_sockaddr = type {
	i16, 
	[14 x i8]
};;

%Struct_in_addr = type {
	i32
};;

%Struct_sockaddr_in = type {
	i8, 
	i8, 
	i16, 
	%Struct_in_addr, 
	[8 x i8]
};;





















































































declare i32 @inet_addr([0 x i8]* %cp)


declare i32 @socket(i32 %domain, i32 %type, i32 %protocol)
declare i32 @bind(i32 %sockfd, %Struct_sockaddr* %addr, i32 %addrlen)
declare i32 @listen(i32 %sockfd, i32 %backlog)
declare i32 @connect(i32 %sockfd, %Struct_sockaddr* %addr, i32 %addrlen)
declare i64 @send(i32 %socket, i8* %buffer, i64 %length, i32 %flags)
declare i64 @recv(i32 %sockfd, i8* %buf, i64 %len, i32 %flags)


declare i32 @accept(i32 %s, %Struct_sockaddr* %addr, i32* %addrlen)


; -- SOURCE: src/client.cm

@str1 = private constant [26 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 101, i8 110, i8 100, i8 117, i8 110, i8 103, i8 32, i8 100, i8 97, i8 116, i8 97, i8 0]
@str2 = private constant [20 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 0]
@str3 = private constant [27 x i8] [i8 91, i8 43, i8 93, i8 32, i8 83, i8 101, i8 114, i8 118, i8 101, i8 114, i8 32, i8 115, i8 111, i8 99, i8 107, i8 101, i8 116, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 100, i8 10, i8 0]
@str4 = private constant [10 x i8] [i8 49, i8 50, i8 55, i8 46, i8 48, i8 46, i8 48, i8 46, i8 49, i8 0]
@str5 = private constant [24 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 67, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 105, i8 110, i8 103, i8 0]
@str6 = private constant [25 x i8] [i8 91, i8 43, i8 93, i8 32, i8 67, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 116, i8 111, i8 32, i8 115, i8 101, i8 114, i8 118, i8 101, i8 114, i8 10, i8 0]
@str7 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 116, i8 120, i8 116, i8 0]
@str8 = private constant [2 x i8] [i8 114, i8 0]
@str9 = private constant [26 x i8] [i8 91, i8 45, i8 93, i8 32, i8 69, i8 114, i8 114, i8 111, i8 114, i8 32, i8 105, i8 110, i8 32, i8 114, i8 101, i8 97, i8 100, i8 105, i8 110, i8 103, i8 32, i8 102, i8 105, i8 108, i8 101, i8 0]
@str10 = private constant [33 x i8] [i8 91, i8 43, i8 93, i8 32, i8 70, i8 105, i8 108, i8 101, i8 32, i8 100, i8 97, i8 116, i8 97, i8 32, i8 115, i8 101, i8 110, i8 100, i8 32, i8 115, i8 117, i8 99, i8 99, i8 101, i8 115, i8 115, i8 102, i8 117, i8 108, i8 108, i8 121, i8 10, i8 0]
@str11 = private constant [34 x i8] [i8 91, i8 43, i8 93, i8 32, i8 68, i8 105, i8 115, i8 99, i8 111, i8 110, i8 110, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 116, i8 104, i8 101, i8 32, i8 115, i8 101, i8 114, i8 118, i8 101, i8 114, i8 10, i8 0]




define void @send_file(%File* %fp, i32 %sockfd) {
	%1 = alloca [1024 x i8], align 1
	br label %again_1
again_1:
	%2 = bitcast [1024 x i8]* %1 to %CharStr*
	%3 = call %CharStr* @fgets(%CharStr* %2, i32 1024, %File* %fp)
	%4 = icmp ne %CharStr* %3, null
	br i1 %4 , label %body_1, label %break_1
body_1:
	%5 = bitcast [1024 x i8]* %1 to i8*
	%6 = call i64 @send(i32 %sockfd, i8* %5, i64 1024, i32 0)
	%7 = icmp eq i64 %6, -1
	br i1 %7 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([26 x i8]* @str1 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_0
endif_0:
	; -- STMT ASSIGN ARRAY --
	; -- start vol eval --
	%8 = zext i11 1024 to i32
	; -- end vol eval --
	; -- ZERO
	%9 = mul i32 %8, 1
	%10 = bitcast [1024 x i8]* %1 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %10, i8 0, i32 %9, i1 0)
	br label %again_1
break_1:
	ret void
}

define i32 @main() {
	%1 = call i32 @socket(i32 2, i32 1, i32 0)
	%2 = icmp slt i32 %1, 0
	br i1 %2 , label %then_0, label %endif_0
then_0:
	call void @perror(%ConstCharStr* bitcast ([20 x i8]* @str2 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_0
endif_0:
	%3 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([27 x i8]* @str3 to [0 x i8]*))
	%4 = alloca %Struct_sockaddr_in, align 4
	%5 = insertvalue %Struct_sockaddr_in zeroinitializer, i8 0, 0
	%6 = insertvalue %Struct_sockaddr_in %5, i8 2, 1
	%7 = insertvalue %Struct_sockaddr_in %6, i16 8080, 2
	%8 = call i32 @inet_addr([0 x i8]* bitcast ([10 x i8]* @str4 to [0 x i8]*))
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
	%23 = call i32 @connect(i32 %1, %Struct_sockaddr* %21, i32 16)
	store i32 %23, i32* %22
	%24 = load i32, i32* %22
	%25 = icmp slt i32 %24, 0
	br i1 %25 , label %then_1, label %endif_1
then_1:
	call void @perror(%ConstCharStr* bitcast ([24 x i8]* @str5 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_1
endif_1:
	%26 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([25 x i8]* @str6 to [0 x i8]*))
	%27 = call %File* @fopen(%ConstCharStr* bitcast ([9 x i8]* @str7 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str8 to [0 x i8]*))
	%28 = icmp eq %File* %27, null
	br i1 %28 , label %then_2, label %endif_2
then_2:
	call void @perror(%ConstCharStr* bitcast ([26 x i8]* @str9 to [0 x i8]*))
	call void @exit(i32 1)
	br label %endif_2
endif_2:
	call void @send_file(%File* %27, i32 %1)
	%29 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str10 to [0 x i8]*))
	%30 = call i32 @close(i32 %1)
	%31 = call i32 (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str11 to [0 x i8]*))
	ret i32 0
}



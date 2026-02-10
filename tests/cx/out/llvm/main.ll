
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
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)
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
; from included ctypes
; from included time
%TimeT = type %Int32;
%ClockT = type %UnsignedLong;
%StructTM = type {
	%Int,
	%Int,
	%Int,
	%Int,
	%Int,
	%Int,
	%Int,
	%Int,
	%Int,
	%LongInt,
	%ConstChar*
};

declare %ClockT @clock()
declare %Double @difftime(%TimeT %end, %TimeT %beginning)
declare %TimeT @mktime(%StructTM* %timeptr)
declare %TimeT @time(%TimeT* %timer)
declare %Char* @asctime(%StructTM* %timeptr)
declare %Char* @ctime(%TimeT* %timer)
declare %StructTM* @gmtime(%TimeT* %timer)
declare %StructTM* @localtime(%TimeT* %timer)
declare %SizeT @strftime(%Char* %ptr, %SizeT %maxsize, %ConstChar* %format, %StructTM* %timeptr)
declare %StructTM* @localtime_s(%TimeT* %timer, %StructTM* %tmptr)
declare %StructTM* @localtime_r(%TimeT* %timer, %StructTM* %tmptr)
; from included stat
%DevT = type %Nat32;
%InoT = type %Nat64;
%ModeT = type %Word16;
%NLinkT = type %Nat16;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
%BlkSizeT = type %Nat32;
%BlkCntT = type %Nat64;
%DarwinIno64T = type %Nat64;
%DarwinTimeT = type %Nat64;
%Timespec = type {
	%DarwinTimeT,
	%Long
};

%Stat = type {
	%DevT,
	%ModeT,
	%NLinkT,
	%DarwinIno64T,
	%UIDT,
	%GIDT,
	%DevT,
	%Timespec,
	%Timespec,
	%Timespec,
	%Timespec,
	%OffT,
	%BlkCntT,
	%BlkSizeT,
	%Nat32,
	%Nat32,
	%Int32,
	[2 x %Int64]
};

declare %Int @\01_stat([0 x %ConstChar]* %path, %Stat* %stat)
declare %Bool @c_S_ISDIR(%ModeT %m)
declare %Bool @c_S_ISCHR(%ModeT %m)
declare %Bool @c_S_ISBLK(%ModeT %m)
declare %Bool @c_S_ISREG(%ModeT %m)
declare %Bool @c_S_ISFIFO(%ModeT %m)
declare %Bool @c_S_ISLNK(%ModeT %m)
declare %Bool @c_S_ISSOCK(%ModeT %m)
declare %Bool @c_S_ISWHT(%ModeT %m)
; from included fcntl
declare %Int @open([0 x %ConstChar]* %fname, %Word32 %opt, ...)
declare %Int @creat([0 x %ConstChar]* %fname, %ModeT %mode)
declare %Int @fcntl(%Int %fd, %Int %op, ...)
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [22 x i8] [i8 37, i8 100, i8 32, i8 58, i8 32, i8 27, i8 91, i8 51, i8 49, i8 109, i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 27, i8 91, i8 48, i8 109, i8 0]
@str2 = private constant [1 x i8] [i8 0]
@str3 = private constant [15 x i8] [i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str4 = private constant [3 x i8] [i8 37, i8 105, i8 0]
@str5 = private constant [3 x i8] [i8 37, i8 100, i8 0]
@str6 = private constant [12 x i8] [i8 60, i8 60, i8 32, i8 39, i8 37, i8 115, i8 39, i8 32, i8 62, i8 62, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 101, i8 120, i8 112, i8 114, i8 46, i8 105, i8 100, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str8 = private constant [3 x i8] [i8 37, i8 105, i8 0]
@str9 = private constant [15 x i8] [i8 101, i8 120, i8 112, i8 114, i8 46, i8 110, i8 117, i8 109, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [11 x i8] [i8 116, i8 121, i8 112, i8 101, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str11 = private constant [6 x i8] [i8 99, i8 111, i8 110, i8 115, i8 116, i8 0]
@str12 = private constant [10 x i8] [i8 99, i8 111, i8 110, i8 115, i8 116, i8 32, i8 37, i8 115, i8 10, i8 0]
@str13 = private constant [10 x i8] [i8 46, i8 101, i8 113, i8 117, i8 32, i8 37, i8 115, i8 44, i8 32, i8 0]
@str14 = private constant [2 x i8] [i8 58, i8 0]
@str15 = private constant [2 x i8] [i8 61, i8 0]
@str16 = private constant [4 x i8] [i8 37, i8 115, i8 10, i8 0]
@str17 = private constant [7 x i8] [i8 46, i8 100, i8 97, i8 116, i8 97, i8 10, i8 0]
@str18 = private constant [4 x i8] [i8 118, i8 97, i8 114, i8 0]
@str19 = private constant [8 x i8] [i8 118, i8 97, i8 114, i8 32, i8 37, i8 115, i8 10, i8 0]
@str20 = private constant [12 x i8] [i8 37, i8 115, i8 58, i8 32, i8 119, i8 111, i8 114, i8 100, i8 32, i8 48, i8 10, i8 0]
@str21 = private constant [2 x i8] [i8 58, i8 0]
@str22 = private constant [2 x i8] [i8 61, i8 0]
@str23 = private constant [2 x i8] [i8 123, i8 0]
@str24 = private constant [2 x i8] [i8 125, i8 0]
@str25 = private constant [2 x i8] [i8 125, i8 0]
@str26 = private constant [7 x i8] [i8 114, i8 101, i8 116, i8 117, i8 114, i8 110, i8 0]
@str27 = private constant [5 x i8] [i8 114, i8 101, i8 116, i8 10, i8 0]
@str28 = private constant [3 x i8] [i8 105, i8 102, i8 0]
@str29 = private constant [4 x i8] [i8 105, i8 102, i8 10, i8 0]
@str30 = private constant [5 x i8] [i8 101, i8 108, i8 115, i8 101, i8 0]
@str31 = private constant [3 x i8] [i8 105, i8 102, i8 0]
@str32 = private constant [2 x i8] [i8 123, i8 0]
@str33 = private constant [3 x i8] [i8 105, i8 102, i8 0]
@str34 = private constant [7 x i8] [i8 114, i8 101, i8 116, i8 117, i8 114, i8 110, i8 0]
@str35 = private constant [5 x i8] [i8 102, i8 117, i8 110, i8 99, i8 0]
@str36 = private constant [7 x i8] [i8 46, i8 116, i8 101, i8 120, i8 116, i8 10, i8 0]
@str37 = private constant [9 x i8] [i8 102, i8 117, i8 110, i8 99, i8 32, i8 37, i8 115, i8 32, i8 0]
@str38 = private constant [5 x i8] [i8 37, i8 115, i8 58, i8 10, i8 0]
@str39 = private constant [2 x i8] [i8 40, i8 0]
@str40 = private constant [2 x i8] [i8 41, i8 0]
@str41 = private constant [4 x i8] [i8 37, i8 115, i8 44, i8 0]
@str42 = private constant [2 x i8] [i8 44, i8 0]
@str43 = private constant [2 x i8] [i8 10, i8 0]
@str44 = private constant [2 x i8] [i8 41, i8 0]
@str45 = private constant [2 x i8] [i8 10, i8 0]
@str46 = private constant [2 x i8] [i8 114, i8 0]
@str47 = private constant [28 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 105, i8 110, i8 112, i8 117, i8 116, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str48 = private constant [29 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 111, i8 117, i8 116, i8 112, i8 117, i8 116, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str49 = private constant [5 x i8] [i8 102, i8 117, i8 110, i8 99, i8 0]
@str50 = private constant [6 x i8] [i8 99, i8 111, i8 110, i8 115, i8 116, i8 0]
@str51 = private constant [4 x i8] [i8 118, i8 97, i8 114, i8 0]
@str52 = private constant [22 x i8] [i8 117, i8 110, i8 101, i8 120, i8 112, i8 101, i8 99, i8 116, i8 101, i8 100, i8 32, i8 116, i8 111, i8 107, i8 101, i8 110, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str53 = private constant [7 x i8] [i8 109, i8 97, i8 105, i8 110, i8 46, i8 120, i8 0]
@str54 = private constant [6 x i8] [i8 111, i8 117, i8 116, i8 46, i8 115, i8 0]
@str55 = private constant [9 x i8] [i8 112, i8 114, i8 111, i8 108, i8 111, i8 103, i8 59, i8 10, i8 0]
@str56 = private constant [9 x i8] [i8 101, i8 112, i8 105, i8 108, i8 111, i8 103, i8 59, i8 10, i8 0]
; -- endstrings --
@errcnt = internal global %Nat32 zeroinitializer
@fsrc = internal global %File* zeroinitializer
@fout = internal global %Int zeroinitializer
@eof = internal global %Bool zeroinitializer
@ch = internal global %Char8 zeroinitializer
@lineno = internal global %Nat32 zeroinitializer
@token = internal global [128 x %Char8] zeroinitializer
%TokenType = type %Word8;
@tokenType = internal global %TokenType zeroinitializer
@tokenLen = internal global %Nat32 zeroinitializer
%TypeKind = type %Word8;
%Type = type {
	%TypeKind
};

define internal void @error(%Str8* %format, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = load %Nat32, %Nat32* @lineno
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([22 x i8]* @str1 to [0 x i8]*), %Nat32 %2)
	%4 = call %Int @fflush(%File* undef)
	%5 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %5)
	%6 = alloca [256 x %Char8], align 1
	%7 = bitcast [256 x %Char8]* %6 to %CharStr*
	%8 = load %__VA_List, %__VA_List* %1
	%9 = call %Int @vsnprintf(%CharStr* %7, %SizeT 255, %Str8* %format, %__VA_List %8)
	%10 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %10)
	%11 = bitcast [256 x %Char8]* %6 to i8*
	%12 = zext %Int %9 to %SizeT
	%13 = call %SSizeT @write(%Int 1, i8* %11, %SizeT %12)
	%14 = call %Int @puts(%ConstCharStr* bitcast ([1 x i8]* @str2 to [0 x i8]*))
	%15 = load %Nat32, %Nat32* @errcnt
	%16 = add %Nat32 %15, 1
	store %Nat32 %16, %Nat32* @errcnt
; if_0
	%17 = load %Nat32, %Nat32* @errcnt
	%18 = icmp ugt %Nat32 %17, 10
	br %Bool %18 , label %then_0, label %endif_0
then_0:
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	ret void
}

define internal void @gen(%Str8* %format, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = alloca [513 x %Char8], align 1
	%4 = bitcast [513 x %Char8]* %3 to %CharStr*
	%5 = load %__VA_List, %__VA_List* %1
	%6 = call %Int @vsnprintf(%CharStr* %4, %SizeT 512, %Str8* %format, %__VA_List %5)
	%7 = load %Int, %Int* @fout
	%8 = bitcast [513 x %Char8]* %3 to i8*
	%9 = zext %Int %6 to %SizeT
	%10 = call %SSizeT @write(%Int %7, i8* %8, %SizeT %9)
	%11 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %11)
	ret void
}

define internal void @op(%Str8* %format, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = alloca [513 x %Char8], align 1
	%4 = insertvalue [513 x %Char8] zeroinitializer, %Char8 9, 0
	%5 = zext i16 513 to %Nat32
	store [513 x %Char8] %4, [513 x %Char8]* %3
	%6 = zext i8 1 to %Nat32
	%7 = getelementptr [513 x %Char8], [513 x %Char8]* %3, %Int32 0, %Nat32 %6
	%8 = bitcast %Char8* %7 to [0 x %Char8]*
	%9 = load %__VA_List, %__VA_List* %1
	%10 = call %Int @vsnprintf([0 x %Char8]* %8, %SizeT 511, %Str8* %format, %__VA_List %9)
	%11 = load %Int, %Int* @fout
	%12 = bitcast [513 x %Char8]* %3 to i8*
	%13 = zext %Int %10 to %SizeT
	%14 = add %SizeT %13, 1
	%15 = call %SSizeT @write(%Int %11, i8* %12, %SizeT %14)
	%16 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %16)
	ret void
}

define internal %Nat8 @ord(%Char8 %x) {
	%1 = bitcast %Char8 %x to %Word8
	%2 = bitcast %Word8 %1 to %Nat8
	ret %Nat8 %2
}

define internal %Bool @islower(%Char8 %x) {
	%1 = call %Nat8 @ord(%Char8 %x)
	%2 = call %Nat8 @ord(%Char8 97)
	%3 = icmp uge %Nat8 %1, %2
	%4 = call %Nat8 @ord(%Char8 %x)
	%5 = call %Nat8 @ord(%Char8 122)
	%6 = icmp ule %Nat8 %4, %5
	%7 = and %Bool %3, %6
	ret %Bool %7
}

define internal %Bool @isupper(%Char8 %x) {
	%1 = call %Nat8 @ord(%Char8 %x)
	%2 = call %Nat8 @ord(%Char8 65)
	%3 = icmp uge %Nat8 %1, %2
	%4 = call %Nat8 @ord(%Char8 %x)
	%5 = call %Nat8 @ord(%Char8 90)
	%6 = icmp ule %Nat8 %4, %5
	%7 = and %Bool %3, %6
	ret %Bool %7
}

define internal %Bool @isalpha(%Char8 %x) {
	%1 = call %Bool @islower(%Char8 %x)
	%2 = call %Bool @isupper(%Char8 %x)
	%3 = or %Bool %1, %2
	ret %Bool %3
}

define internal %Bool @isdigit(%Char8 %x) {
	%1 = call %Nat8 @ord(%Char8 %x)
	%2 = call %Nat8 @ord(%Char8 48)
	%3 = icmp uge %Nat8 %1, %2
	%4 = call %Nat8 @ord(%Char8 %x)
	%5 = call %Nat8 @ord(%Char8 57)
	%6 = icmp ule %Nat8 %4, %5
	%7 = and %Bool %3, %6
	ret %Bool %7
}

define internal void @nexch() {
	%1 = load %File*, %File** @fsrc
	%2 = call %Int @fgetc(%File* %1)
; if_0
	%3 = icmp eq %Int %2, -1
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	store %Bool 1, %Bool* @eof
	br label %endif_0
endif_0:
	%4 = trunc %Int %2 to %Char8
	store %Char8 %4, %Char8* @ch
	ret void
}

define internal void @skipBlanks() {
; while_1
	br label %again_1
again_1:
	%1 = load %Char8, %Char8* @ch
	%2 = icmp eq %Char8 %1, 10
	%3 = load %Char8, %Char8* @ch
	%4 = icmp eq %Char8 %3, 32
	%5 = load %Char8, %Char8* @ch
	%6 = icmp eq %Char8 %5, 9
	%7 = or %Bool %4, %6
	%8 = or %Bool %2, %7
	br %Bool %8 , label %body_1, label %break_1
body_1:
; if_0
	%9 = load %Char8, %Char8* @ch
	%10 = icmp eq %Char8 %9, 10
	br %Bool %10 , label %then_0, label %endif_0
then_0:
	%11 = load %Nat32, %Nat32* @lineno
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* @lineno
	br label %endif_0
endif_0:
	call void @nexch()
	br label %again_1
break_1:
	ret void
}

define internal %Nat32 @sweep() {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Char8, %Char8* @ch
	%3 = call %Bool @isalpha(%Char8 %2)
	%4 = load %Char8, %Char8* @ch
	%5 = call %Bool @isdigit(%Char8 %4)
	%6 = load %Char8, %Char8* @ch
	%7 = icmp eq %Char8 %6, 95
	%8 = or %Bool %5, %7
	%9 = or %Bool %3, %8
	br %Bool %9 , label %body_1, label %break_1
body_1:
	%10 = load %Nat32, %Nat32* %1
	%11 = bitcast %Nat32 %10 to %Nat32
	%12 = getelementptr [128 x %Char8], [128 x %Char8]* @token, %Int32 0, %Nat32 %11
	%13 = load %Char8, %Char8* @ch
	store %Char8 %13, %Char8* %12
	call void @nexch()
	%14 = load %Nat32, %Nat32* %1
	%15 = add %Nat32 %14, 1
	store %Nat32 %15, %Nat32* %1
	br label %again_1
break_1:
	%16 = load %Nat32, %Nat32* %1
	ret %Nat32 %16
}

define internal void @next() {
	call void @skipBlanks()
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; if_0
	%2 = load %Char8, %Char8* @ch
	%3 = call %Bool @isalpha(%Char8 %2)
	%4 = load %Char8, %Char8* @ch
	%5 = icmp eq %Char8 %4, 95
	%6 = or %Bool %3, %5
	br %Bool %6 , label %then_0, label %else_0
then_0:
	%7 = bitcast i8 1 to %TokenType
	store %TokenType %7, %TokenType* @tokenType
	%8 = call %Nat32 @sweep()
	store %Nat32 %8, %Nat32* %1
	br label %endif_0
else_0:
; if_1
	%9 = load %Char8, %Char8* @ch
	%10 = call %Bool @isdigit(%Char8 %9)
	br %Bool %10 , label %then_1, label %else_1
then_1:
	%11 = bitcast i8 2 to %TokenType
	store %TokenType %11, %TokenType* @tokenType
	%12 = call %Nat32 @sweep()
	store %Nat32 %12, %Nat32* %1
	br label %endif_1
else_1:
; if_2
	%13 = load %Bool, %Bool* @eof
	%14 = xor %Bool %13, 1
	br %Bool %14 , label %then_2, label %else_2
then_2:
	%15 = bitcast i8 3 to %TokenType
	store %TokenType %15, %TokenType* @tokenType
	%16 = getelementptr [128 x %Char8], [128 x %Char8]* @token, %Int32 0, %Int32 0
	%17 = load %Char8, %Char8* @ch
	store %Char8 %17, %Char8* %16
	store %Nat32 1, %Nat32* %1
	call void @nexch()
	br label %endif_2
else_2:
	%18 = bitcast i8 0 to %TokenType
	store %TokenType %18, %TokenType* @tokenType
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%19 = load %Nat32, %Nat32* %1
	%20 = bitcast %Nat32 %19 to %Nat32
	%21 = getelementptr [128 x %Char8], [128 x %Char8]* @token, %Int32 0, %Nat32 %20
	store %Char8 0, %Char8* %21
	%22 = load %Nat32, %Nat32* %1
	store %Nat32 %22, %Nat32* @tokenLen
	ret void
}

define internal void @skip() {
	call void @next()
	ret void
}

define internal %Bool @looks(%Str8* %s) {
; if_0
	%1 = call %SizeT @strlen(%Str8* %s)
	%2 = trunc %SizeT %1 to %Nat32
	%3 = load %Nat32, %Nat32* @tokenLen
	%4 = icmp ne %Nat32 %2, %3
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%6 = zext i8 0 to %Nat32
	%7 = getelementptr [128 x %Char8], [128 x %Char8]* @token, %Int32 0, %Nat32 %6
	%8 = bitcast %Char8* %7 to [0 x %Char8]*
	%9 = zext i8 0 to %Nat32
	%10 = getelementptr %Str8, %Str8* %s, %Int32 0, %Nat32 %9
;
	%11 = bitcast %Char8* %10 to [0 x %Char8]*
	%12 = bitcast [0 x %Char8]* %8 to i8*
	%13 = bitcast [0 x %Char8]* %11 to i8*
	%14 = call i1 (i8*, i8*, i64) @memeq(i8* %12, i8* %13, %Int64 0)
	%15 = icmp ne %Bool %14, 0
	ret %Bool %15
}

define internal %Bool @need(%Str8* %s) {
; if_0
	%1 = call %Bool @looks(%Str8* %s)
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	call void @skip()
	ret %Bool 1
	br label %endif_0
endif_0:
	call void (%Str8*, ...) @error(%Str8* bitcast ([15 x i8]* @str3 to [0 x i8]*), %Str8* %s)
	ret %Bool 0
}

define internal %Bool @checkId(%Str8* %s) {
; if_0
	%1 = bitcast i8 1 to %TokenType
	%2 = load %TokenType, %TokenType* @tokenType
	%3 = icmp ne %TokenType %2, %1
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	ret %Bool 0
	br label %endif_0
endif_0:
	%5 = call %Bool @looks(%Str8* %s)
	ret %Bool %5
}

define internal %Bool @matchId(%Str8* %s) {
; if_0
	%1 = call %Bool @checkId(%Str8* %s)
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	call void @skip()
	ret %Bool 1
	br label %endif_0
endif_0:
	ret %Bool 0
}

define internal %Bool @match(%Str8* %s) {
; if_0
	%1 = call %Bool @looks(%Str8* %s)
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	call void @skip()
	ret %Bool 1
	br label %endif_0
endif_0:
	ret %Bool 0
}

define internal %Nat32 @scan_num() {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
	%2 = bitcast [128 x %Char8]* @token to %ConstCharStr*
	%3 = call %Int (%ConstCharStr*, %ConstCharStr*, ...) @sscanf(%ConstCharStr* %2, %ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*), %Nat32* %1)
	call void @skip()
	%4 = load %Nat32, %Nat32* %1
	ret %Nat32 %4
}

define internal %Nat8 @scan_reg() {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
	%2 = zext i8 1 to %Nat32
	%3 = getelementptr [128 x %Char8], [128 x %Char8]* @token, %Int32 0, %Nat32 %2
	%4 = bitcast %Char8* %3 to [0 x %Char8]*
	%5 = call %Int (%ConstCharStr*, %ConstCharStr*, ...) @sscanf([0 x %Char8]* %4, %ConstCharStr* bitcast ([3 x i8]* @str5 to [0 x i8]*), %Nat32* %1)
	call void @skip()
	%6 = load %Nat32, %Nat32* %1
	%7 = trunc %Nat32 %6 to %Nat8
	ret %Nat8 %7
}

define internal void @show() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str6 to [0 x i8]*), [128 x %Char8]* @token)
	ret void
}

define internal void @do_value() {
	call void @h1()
	ret void
}

define internal void @h1() {
	call void @h0()
	ret void
}

define internal void @h0() {
; if_0
	%1 = bitcast i8 1 to %TokenType
	%2 = load %TokenType, %TokenType* @tokenType
	%3 = icmp eq %TokenType %2, %1
	br %Bool %3 , label %then_0, label %else_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), [128 x %Char8]* @token)
	call void @skip()
	br label %endif_0
else_0:
; if_1
	%5 = bitcast i8 2 to %TokenType
	%6 = load %TokenType, %TokenType* @tokenType
	%7 = icmp eq %TokenType %6, %5
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	%8 = alloca %Int, align 4
	%9 = bitcast [128 x %Char8]* @token to %ConstCharStr*
	%10 = call %Int (%ConstCharStr*, %ConstCharStr*, ...) @sscanf(%ConstCharStr* %9, %ConstCharStr* bitcast ([3 x i8]* @str8 to [0 x i8]*), %Int* %8)
	%11 = load %Int, %Int* %8
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str9 to [0 x i8]*), %Int %11)
	call void @skip()
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @do_type() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([11 x i8]* @str10 to [0 x i8]*), [128 x %Char8]* @token)
	call void @skip()
	ret void
}

define internal void @do_const() {
	%1 = call %Bool @need(%Str8* bitcast ([6 x i8]* @str11 to [0 x i8]*))
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str12 to [0 x i8]*), [128 x %Char8]* @token)
	call void (%Str8*, ...) @gen(%Str8* bitcast ([10 x i8]* @str13 to [0 x i8]*), [128 x %Char8]* @token)
	call void @skip()
; if_0
	%3 = call %Bool @match(%Str8* bitcast ([2 x i8]* @str14 to [0 x i8]*))
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @do_type()
	br label %endif_0
endif_0:
; if_1
	%4 = call %Bool @match(%Str8* bitcast ([2 x i8]* @str15 to [0 x i8]*))
	br %Bool %4 , label %then_1, label %endif_1
then_1:
	call void (%Str8*, ...) @gen(%Str8* bitcast ([4 x i8]* @str16 to [0 x i8]*), [128 x %Char8]* @token)
	call void @do_value()
	br label %endif_1
endif_1:
	ret void
}

define internal void @do_var() {
	call void (%Str8*, ...) @gen(%Str8* bitcast ([7 x i8]* @str17 to [0 x i8]*))
	%1 = call %Bool @need(%Str8* bitcast ([4 x i8]* @str18 to [0 x i8]*))
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str19 to [0 x i8]*), [128 x %Char8]* @token)
	call void (%Str8*, ...) @gen(%Str8* bitcast ([12 x i8]* @str20 to [0 x i8]*), [128 x %Char8]* @token)
	call void @skip()
; if_0
	%3 = call %Bool @match(%Str8* bitcast ([2 x i8]* @str21 to [0 x i8]*))
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @do_type()
	br label %endif_0
endif_0:
; if_1
	%4 = call %Bool @match(%Str8* bitcast ([2 x i8]* @str22 to [0 x i8]*))
	br %Bool %4 , label %then_1, label %endif_1
then_1:
	call void @do_value()
	br label %endif_1
endif_1:
	ret void
}

define internal void @do_stmt_block() {
	%1 = call %Bool @need(%Str8* bitcast ([2 x i8]* @str23 to [0 x i8]*))
; while_1
	br label %again_1
again_1:
	%2 = call %Bool @looks(%Str8* bitcast ([2 x i8]* @str24 to [0 x i8]*))
	%3 = load %Bool, %Bool* @eof
	%4 = or %Bool %2, %3
	%5 = xor %Bool %4, 1
	br %Bool %5 , label %body_1, label %break_1
body_1:
	call void @do_stmt()
	br label %again_1
break_1:
	%6 = call %Bool @need(%Str8* bitcast ([2 x i8]* @str25 to [0 x i8]*))
	ret void
}

define internal void @do_stmt_return() {
	%1 = call %Bool @need(%Str8* bitcast ([7 x i8]* @str26 to [0 x i8]*))
	call void (%Str8*, ...) @op(%Str8* bitcast ([5 x i8]* @str27 to [0 x i8]*))
	ret void
}

define internal void @do_stmt_if() {
	%1 = call %Bool @need(%Str8* bitcast ([3 x i8]* @str28 to [0 x i8]*))
	call void (%Str8*, ...) @op(%Str8* bitcast ([4 x i8]* @str29 to [0 x i8]*))
	call void @do_value()
	call void @do_stmt_block()
; if_0
	%2 = call %Bool @match(%Str8* bitcast ([5 x i8]* @str30 to [0 x i8]*))
	br %Bool %2 , label %then_0, label %endif_0
then_0:
; if_1
	%3 = call %Bool @looks(%Str8* bitcast ([3 x i8]* @str31 to [0 x i8]*))
	br %Bool %3 , label %then_1, label %else_1
then_1:
	call void @do_stmt_if()
	br label %endif_1
else_1:
	call void @do_stmt_block()
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @do_stmt() {
; if_0
	%1 = call %Bool @looks(%Str8* bitcast ([2 x i8]* @str32 to [0 x i8]*))
	br %Bool %1 , label %then_0, label %else_0
then_0:
	call void @do_stmt_block()
	br label %endif_0
else_0:
; if_1
	%2 = call %Bool @looks(%Str8* bitcast ([3 x i8]* @str33 to [0 x i8]*))
	br %Bool %2 , label %then_1, label %else_1
then_1:
	call void @do_stmt_if()
	br label %endif_1
else_1:
; if_2
	%3 = call %Bool @looks(%Str8* bitcast ([7 x i8]* @str34 to [0 x i8]*))
	br %Bool %3 , label %then_2, label %endif_2
then_2:
	call void @do_stmt_return()
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

declare internal void @do_arg()
define internal void @do_func() {
	%1 = call %Bool @need(%Str8* bitcast ([5 x i8]* @str35 to [0 x i8]*))
	call void (%Str8*, ...) @gen(%Str8* bitcast ([7 x i8]* @str36 to [0 x i8]*))
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str37 to [0 x i8]*), [128 x %Char8]* @token)
	call void (%Str8*, ...) @gen(%Str8* bitcast ([5 x i8]* @str38 to [0 x i8]*), [128 x %Char8]* @token)
	call void @prolog()
	call void @next()
	%3 = call %Bool @need(%Str8* bitcast ([2 x i8]* @str39 to [0 x i8]*))
; while_1
	br label %again_1
again_1:
	%4 = call %Bool @looks(%Str8* bitcast ([2 x i8]* @str40 to [0 x i8]*))
	%5 = load %Bool, %Bool* @eof
	%6 = or %Bool %4, %5
	%7 = xor %Bool %6, 1
	br %Bool %7 , label %body_1, label %break_1
body_1:
	%8 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([4 x i8]* @str41 to [0 x i8]*), [128 x %Char8]* @token)
	call void @next()
	%9 = call %Bool @match(%Str8* bitcast ([2 x i8]* @str42 to [0 x i8]*))
	br label %again_1
break_1:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str43 to [0 x i8]*))
	%11 = call %Bool @need(%Str8* bitcast ([2 x i8]* @str44 to [0 x i8]*))
	call void @do_stmt_block()
	call void @epilog()
	%12 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str45 to [0 x i8]*))
	ret void
}

define internal void @cc(%Str* %input, %Str* %output) {
	%1 = call %File* @fopen(%Str* %input, %ConstCharStr* bitcast ([2 x i8]* @str46 to [0 x i8]*))
	store %File* %1, %File** @fsrc
; if_0
	%2 = load %File*, %File** @fsrc
	%3 = icmp eq %File* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void (%Str8*, ...) @error(%Str8* bitcast ([28 x i8]* @str47 to [0 x i8]*), %Str* %input)
	ret void
	br label %endif_0
endif_0:

	;fout = creat(output, 0x1BC)
	%5 = call %Int ([0 x %ConstChar]*, %Word32, ...) @open(%Str* %output, %Word32 1)
	store %Int %5, %Int* @fout
; if_1
	%6 = load %Int, %Int* @fout
	%7 = icmp slt %Int %6, 0
	br %Bool %7 , label %then_1, label %endif_1
then_1:
	call void (%Str8*, ...) @error(%Str8* bitcast ([29 x i8]* @str48 to [0 x i8]*), %Str* %output)
	ret void
	br label %endif_1
endif_1:
	call void @nexch()	; загружаем первый символ в ch буфер
	call void @next()	; загружаем первый токен в token буфер
; while_1
	br label %again_1
again_1:
	%9 = load %Bool, %Bool* @eof
	%10 = xor %Bool %9, 1
	br %Bool %10 , label %body_1, label %break_1
body_1:
; if_2
	%11 = call %Bool @looks(%Str8* bitcast ([5 x i8]* @str49 to [0 x i8]*))
	br %Bool %11 , label %then_2, label %else_2
then_2:
	call void @do_func()
	br label %endif_2
else_2:
; if_3
	%12 = call %Bool @looks(%Str8* bitcast ([6 x i8]* @str50 to [0 x i8]*))
	br %Bool %12 , label %then_3, label %else_3
then_3:
	call void @do_const()
	br label %endif_3
else_3:
; if_4
	%13 = call %Bool @looks(%Str8* bitcast ([4 x i8]* @str51 to [0 x i8]*))
	br %Bool %13 , label %then_4, label %else_4
then_4:
	call void @do_var()
	br label %endif_4
else_4:
	call void (%Str8*, ...) @error(%Str8* bitcast ([22 x i8]* @str52 to [0 x i8]*), [128 x %Char8]* @token)
	call void @skip()
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %again_1
break_1:
	%14 = load %File*, %File** @fsrc
	%15 = call %Int @fclose(%File* %14)
	%16 = load %Int, %Int* @fout
	%17 = call %Int @close(%Int %16)
	ret void
}

define %Int @main() {
	call void @cc(%Str* bitcast ([7 x i8]* @str53 to [0 x i8]*), %Str* bitcast ([6 x i8]* @str54 to [0 x i8]*))
	%1 = load %Nat32, %Nat32* @errcnt
	%2 = icmp ugt %Nat32 %1, 0
	%3 = zext %Bool %2 to %Word8
	%4 = sext %Word8 %3 to %Int
	ret %Int %4
}

define internal void @prolog() {
	call void (%Str8*, ...) @op(%Str8* bitcast ([9 x i8]* @str55 to [0 x i8]*))
	ret void
}

define internal void @epilog() {
	call void (%Str8*, ...) @op(%Str8* bitcast ([9 x i8]* @str56 to [0 x i8]*))
	ret void
}



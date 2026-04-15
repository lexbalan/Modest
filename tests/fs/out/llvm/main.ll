
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Fixed32 = type i32
%Fixed64 = type i64
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
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
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

declare %Int @stat([0 x %ConstChar]* %path, %Stat* %stat)
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
; from included ctype
declare %Bool @isascii(%Int %x)
declare %Bool @iscntrl(%Int %x)
declare %Bool @isblank(%Int %x)
declare %Bool @isdigit(%Int %x)
declare %Bool @isxdigit(%Int %x)
declare %Bool @isalpha(%Int %x)
declare %Bool @isalnum(%Int %x)
declare %Bool @isgraph(%Int %x)
declare %Bool @isprint(%Int %x)
declare %Bool @ispunct(%Int %x)
declare %Bool @isspace(%Int %x)
declare %Bool @isupper(%Int %x)
declare %Bool @islower(%Int %x)
declare %Int @toascii(%Int %x)
declare %Int @toupper(%Int %x)
declare %Int @tolower(%Int %x)
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
; -- end print includes --
; -- print imports private 'main' --

; from import "builtin"

; end from import "builtin"

; from import "sys"
%sys_Char = type %Char8;
%sys_Int = type %Int32;
%sys_Word = type %Word32;
%sys_Nat = type %Nat32;
%sys_Long = type %Int64;
%sys_Size = type %sys_Long;
declare %sys_Int @sys_init()
declare %sys_Int @sys_deinit()
declare %sys_Int @sys_chdir([0 x %sys_Char]* %path)
declare %sys_Int @sys_mkdir([0 x %sys_Char]* %path)
declare %sys_Int @sys_open([0 x %sys_Char]* %path, %Word32 %oflag)
declare %sys_Int @sys_stat([0 x %sys_Char]* %path, %Stat* %stat)
declare %sys_Int @sys_fstat(%sys_Int %fd, %Stat* %stat)
declare %sys_Int @sys_unlink([0 x %sys_Char]* %path)
declare %sys_Int @sys_write(%sys_Int %fd, [0 x %Byte]* %buf, %sys_Size %len)
declare %sys_Int @sys_read(%sys_Int %fd, [0 x %Byte]* %buf, %sys_Size %len)
declare %sys_Long @sys_lseek(%sys_Int %fd, %sys_Long %offset, %sys_Int %origin)
declare %sys_Long @sys_tell(%sys_Int %fd)
declare %sys_Int @sys_close(%sys_Int %fd)

; end from import "sys"
; -- end print imports private 'main' --
; -- print imports public 'main' --
; -- end print imports public 'main' --
; -- strings --
@str1 = private constant [10 x i8] [i8 37, i8 115, i8 32, i8 40, i8 110, i8 61, i8 37, i8 100, i8 41, i8 0]
@str2 = private constant [3 x i8] [i8 32, i8 91, i8 0]
@str3 = private constant [5 x i8] [i8 39, i8 37, i8 115, i8 39, i8 0]
@str4 = private constant [3 x i8] [i8 93, i8 10, i8 0]
@str5 = private constant [22 x i8] [i8 117, i8 110, i8 107, i8 110, i8 111, i8 119, i8 110, i8 32, i8 99, i8 111, i8 109, i8 109, i8 97, i8 110, i8 100, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 72, i8 65, i8 82, i8 83, i8 72, i8 32, i8 58, i8 41, i8 32, i8 118, i8 48, i8 46, i8 49, i8 10, i8 0]
@str7 = private constant [4 x i8] [i8 37, i8 115, i8 32, i8 0]
@str8 = private constant [20 x i8] [i8 99, i8 97, i8 108, i8 108, i8 101, i8 100, i8 32, i8 99, i8 114, i8 101, i8 97, i8 116, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
@str9 = private constant [31 x i8] [i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 40, i8 101, i8 114, i8 114, i8 111, i8 114, i8 32, i8 61, i8 32, i8 37, i8 100, i8 41, i8 10, i8 0]
@str10 = private constant [14 x i8] [i8 99, i8 97, i8 108, i8 108, i8 101, i8 100, i8 32, i8 99, i8 109, i8 100, i8 76, i8 115, i8 10, i8 0]
@str11 = private constant [14 x i8] [i8 99, i8 97, i8 108, i8 108, i8 101, i8 100, i8 32, i8 99, i8 109, i8 100, i8 67, i8 100, i8 10, i8 0]
@str12 = private constant [16 x i8] [i8 99, i8 97, i8 108, i8 108, i8 101, i8 100, i8 32, i8 99, i8 109, i8 100, i8 69, i8 120, i8 105, i8 116, i8 10, i8 0]
; -- endstrings --
@prompt = internal global [33 x %Char8] [
	%Char8 35,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0,
	%Char8 0
]
%Tokenizer = type {
	[0 x %Char8]*,
	%Nat32,
	%Nat16,
	[0 x [0 x %Char8]*]*
};

define internal %Bool @is_blank(%Char8 %c) {
	%1 = icmp eq %Char8 %c, 32
	%2 = icmp eq %Char8 %c, 10
	%3 = or %Bool %1, %2
	ret %Bool %3
}

define internal %Nat16 @gettok(%Tokenizer* %t, [0 x %Char8]* %output, %Nat16 %lim) {
	%1 = alloca %Char8, align 1
	%2 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%3 = load %Nat32, %Nat32* %2
	%4 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 0
	%5 = load [0 x %Char8]*, [0 x %Char8]** %4
	%6 = bitcast %Nat32 %3 to %Nat32
	%7 = getelementptr [0 x %Char8], [0 x %Char8]* %5, %Int32 0, %Nat32 %6
	%8 = load %Char8, %Char8* %7
	store %Char8 %8, %Char8* %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%9 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 0
	%12 = load [0 x %Char8]*, [0 x %Char8]** %11
	%13 = bitcast %Nat32 %10 to %Nat32
	%14 = getelementptr [0 x %Char8], [0 x %Char8]* %12, %Int32 0, %Nat32 %13
	%15 = load %Char8, %Char8* %14
	store %Char8 %15, %Char8* %1
; if_0
	%16 = load %Char8, %Char8* %1
	%17 = icmp ne %Char8 %16, 32
	%18 = load %Char8, %Char8* %1
	%19 = icmp ne %Char8 %18, 9
	%20 = and %Bool %17, %19
	br %Bool %20 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%22 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%23 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%24 = load %Nat32, %Nat32* %23
	%25 = add %Nat32 %24, 1
	store %Nat32 %25, %Nat32* %22
	br label %again_1
break_1:
; if_1
	%26 = load %Char8, %Char8* %1
	%27 = icmp eq %Char8 %26, 10
	%28 = load %Char8, %Char8* %1
	%29 = icmp eq %Char8 %28, 0
	%30 = or %Bool %27, %29
	br %Bool %30 , label %then_1, label %endif_1
then_1:
	ret %Nat16 0
	br label %endif_1
endif_1:
	%32 = alloca %Nat16, align 2
	store %Nat16 0, %Nat16* %32
	%33 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%34 = load %Nat32, %Nat32* %33
	%35 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 0
	%36 = load [0 x %Char8]*, [0 x %Char8]** %35
	%37 = bitcast %Nat32 %34 to %Nat32
	%38 = getelementptr [0 x %Char8], [0 x %Char8]* %36, %Int32 0, %Nat32 %37
	%39 = load %Char8, %Char8* %38
	store %Char8 %39, %Char8* %1
; if_2
	%40 = load %Char8, %Char8* %1
	%41 = call %Bool @is_blank(%Char8 %40)
	%42 = xor %Bool %41, 1
	br %Bool %42 , label %then_2, label %else_2
then_2:
; while_2
	br label %again_2
again_2:
	%43 = load %Char8, %Char8* %1
	%44 = call %Bool @is_blank(%Char8 %43)
	%45 = xor %Bool %44, 1
	br %Bool %45 , label %body_2, label %break_2
body_2:
	%46 = load %Nat16, %Nat16* %32
	%47 = zext %Nat16 %46 to %Nat32
	%48 = getelementptr [0 x %Char8], [0 x %Char8]* %output, %Int32 0, %Nat32 %47
	%49 = load %Char8, %Char8* %1
	store %Char8 %49, %Char8* %48
	%50 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%51 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%52 = load %Nat32, %Nat32* %51
	%53 = add %Nat32 %52, 1
	store %Nat32 %53, %Nat32* %50
	%54 = load %Nat16, %Nat16* %32
	%55 = add %Nat16 %54, 1
	store %Nat16 %55, %Nat16* %32
	%56 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%57 = load %Nat32, %Nat32* %56
	%58 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 0
	%59 = load [0 x %Char8]*, [0 x %Char8]** %58
	%60 = bitcast %Nat32 %57 to %Nat32
	%61 = getelementptr [0 x %Char8], [0 x %Char8]* %59, %Int32 0, %Nat32 %60
	%62 = load %Char8, %Char8* %61
	store %Char8 %62, %Char8* %1
	br label %again_2
break_2:
	%63 = load %Nat16, %Nat16* %32
	%64 = zext %Nat16 %63 to %Nat32
	%65 = getelementptr [0 x %Char8], [0 x %Char8]* %output, %Int32 0, %Nat32 %64
	store %Char8 0, %Char8* %65
	br label %endif_2
else_2:
	%66 = load %Nat16, %Nat16* %32
	%67 = zext %Nat16 %66 to %Nat32
	%68 = getelementptr [0 x %Char8], [0 x %Char8]* %output, %Int32 0, %Nat32 %67
	%69 = load %Char8, %Char8* %1
	store %Char8 %69, %Char8* %68
	%70 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%71 = getelementptr %Tokenizer, %Tokenizer* %t, %Int32 0, %Int32 1
	%72 = load %Nat32, %Nat32* %71
	%73 = add %Nat32 %72, 1
	store %Nat32 %73, %Nat32* %70
	%74 = load %Nat16, %Nat16* %32
	%75 = add %Nat16 %74, 1
	store %Nat16 %75, %Nat16* %32
	br label %endif_2
endif_2:
	%76 = load %Nat16, %Nat16* %32
	ret %Nat16 %76
}

define internal void @tokenize(%Tokenizer* %tokenizer) {
	%1 = alloca i8*
	%2 = call i8* @llvm.stacksave() 
	store i8* %2, i8** %1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%3 = alloca [128 x %Char8], align 1
	%4 = bitcast [128 x %Char8]* %3 to [0 x %Char8]*
	%5 = call %Nat16 @gettok(%Tokenizer* %tokenizer, [0 x %Char8]* %4, %Nat16 128)
; if_0
	%6 = icmp eq %Nat16 %5, 0
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%8 = add %Nat16 %5, 1
	%9 = mul %Nat16 %8, 1
	%10 = mul %Nat16 %8, 1
	%11 = alloca [0 x %Char8]*, %Int32 1, align 8
	%12 = zext %Nat16 %5 to %SizeT
	%13 = add %SizeT %12, 1
	%14 = call i8* @malloc(%SizeT %13)
	%15 = bitcast i8* %14 to [0 x %Char8]*
	store [0 x %Char8]* %15, [0 x %Char8]** %11
	%16 = load [0 x %Char8]*, [0 x %Char8]** %11
	%17 = zext i8 0 to %Nat32
	%18 = getelementptr [128 x %Char8], [128 x %Char8]* %3, %Int32 0, %Nat32 %17
	%19 = bitcast %Char8* %18 to [0 x %Char8]*
	%20 = load [0 x %Char8], [0 x %Char8]* %19
	%21 = sub %Nat16 %5, 0
	%22 = zext %Nat16 %21 to %Nat32
	store [0 x %Char8] %20, [0 x %Char8]* %16
	%23 = load [0 x %Char8]*, [0 x %Char8]** %11
	%24 = mul %Nat16 %5, 1
	%25 = add %Int32 0, %24
	%26 = getelementptr %Char8, [0 x %Char8]* %23, %Int32 %25
	store %Char8 0, %Char8* %26
	%27 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%28 = load %Nat16, %Nat16* %27
	%29 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 3
	%30 = load [0 x [0 x %Char8]*]*, [0 x [0 x %Char8]*]** %29
	%31 = zext %Nat16 %28 to %Nat32
	%32 = getelementptr [0 x [0 x %Char8]*], [0 x [0 x %Char8]*]* %30, %Int32 0, %Nat32 %31
	%33 = load [0 x %Char8]*, [0 x %Char8]** %11
	%34 = bitcast [0 x %Char8]* %33 to [0 x %Char8]*
	store [0 x %Char8]* %34, [0 x %Char8]** %32
	%35 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%36 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%37 = load %Nat16, %Nat16* %36
	%38 = add %Nat16 %37, 1
	store %Nat16 %38, %Nat16* %35
	br label %again_1
break_1:
	%39 = load i8*, i8** %1
	call void @llvm.stackrestore(i8* %39)
	ret void
}

%CmdHandler = type %Int32 (%Nat16, [0 x %Str8*]*);
%CmdDescriptor = type {
	%Str8*,
	%CmdHandler*
};

@commandHandlers = internal global [5 x %CmdDescriptor] 
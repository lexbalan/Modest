
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/ctypes.hm




%Clock_T = type %UnsignedLong
%Socklen_T = type i32
%Time_T = type %LongInt
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64


%OffT = type i64


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%FILE = type opaque
%FposT = type opaque

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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/time.hm



%Struct_tm = type {
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
}



declare %Clock_T @clock()


declare %Double @difftime(%Time_T %end, %Time_T %beginning)


declare %Time_T @mktime(%Struct_tm* %timeptr)


declare %Time_T @time(%Time_T* %timer)


declare %Char* @asctime(%Struct_tm* %timeptr)


declare %Char* @ctime(%Time_T* %timer)


declare %Struct_tm* @gmtime(%Time_T* %timer)


declare %Struct_tm* @localtime(%Time_T* %timer)


declare %SizeT @strftime(%Char* %ptr, %SizeT %maxsize, %ConstChar* %format, %Struct_tm* %timeptr)


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/unistd.hm

































declare %Int @access([0 x %ConstChar]* %path, %Int %amode)


declare %UnsignedInt @alarm(%UnsignedInt %seconds)


declare %Int @brk(i8* %end_data_segment)


declare %Int @chdir([0 x %ConstChar]* %path)


declare %Int @chroot([0 x %ConstChar]* %path)


declare %Int @chown([0 x %ConstChar]* %pathname, %UidT %owner, %GidT %group)


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


declare %Int @fchown(%Int %fildes, %UidT %owner, %GidT %group)


declare %Int @fchdir(%Int %fildes)


declare %Int @fdatasync(%Int %fildes)


declare %PidT @fork()


declare %LongInt @fpathconf(%Int %fildes, %Int %name)


declare %Int @fsync(%Int %fildes)


declare %Int @ftruncate(%Int %fildes, %OffT %length)


declare [0 x %Char]* @getcwd([0 x %Char]* %buf, %SizeT %size)


declare %Int @getdtablesize()


declare %GidT @getegid()


declare %UidT @geteuid()


declare %GidT @getgid()


declare %Int @getgroups(%Int %gidsetsize, [0 x %GidT]* %grouplist)


declare %Long @gethostid()


declare [0 x %Char]* @getlogin()


declare %Int @getlogin_r([0 x %Char]* %name, %SizeT %namesize)


declare %Int @getopt(%Int %argc, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %optstring)


declare %Int @getpagesize()


declare [0 x %Char]* @getpass([0 x %ConstChar]* %prompt)


declare %PidT @getpgid(%PidT %pid)


declare %PidT @getpgrp()


declare %PidT @getpid()


declare %PidT @getppid()


declare %PidT @getsid(%PidT %pid)


declare %UidT @getuid()


declare [0 x %Char]* @getwd([0 x %Char]* %path_name)


declare %Int @isatty(%Int %fildes)


declare %Int @lchown([0 x %ConstChar]* %path, %UidT %owner, %GidT %group)


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


declare i8* @sbrk(%IntptrT %incr)


declare %Int @setgid(%GidT %gid)


declare %Int @setpgid(%PidT %pid, %PidT %pgid)


declare %PidT @setpgrp()


declare %Int @setregid(%GidT %rgid, %GidT %egid)


declare %Int @setreuid(%UidT %ruid, %UidT %euid)


declare %PidT @setsid()


declare %Int @setuid(%UidT %uid)


declare %UnsignedInt @sleep(%UnsignedInt %seconds)


declare void @swab(i8* %src, i8* %dst, %SSizeT %nbytes)


declare %Int @symlink([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)


declare void @sync()


declare %LongInt @sysconf(%Int %name)


declare %PidT @tcgetpgrp(%Int %fildes)


declare %Int @tcsetpgrp(%Int %fildes, %PidT %pgid_id)


declare %Int @truncate([0 x %ConstChar]* %path, %OffT %length)


declare [0 x %Char]* @ttyname(%Int %fildes)


declare %Int @ttyname_r(%Int %fildes, [0 x %Char]* %name, %SizeT %namesize)


declare %USecondsT @ualarm(%USecondsT %useconds, %USecondsT %interval)


declare %Int @unlink([0 x %ConstChar]* %path)


declare %Int @usleep(%USecondsT %useconds)


declare %PidT @vfork()


declare %SSizeT @write(%Int %fildes, i8* %buf, %SizeT %nbyte)


; -- SOURCE: src/main.cm

@str1 = private constant [12 x i8] [i8 99, i8 116, i8 105, i8 109, i8 101, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [59 x i8] [i8 37, i8 46, i8 102, i8 32, i8 115, i8 101, i8 99, i8 111, i8 110, i8 100, i8 115, i8 32, i8 115, i8 105, i8 110, i8 99, i8 101, i8 32, i8 74, i8 97, i8 110, i8 117, i8 97, i8 114, i8 121, i8 32, i8 49, i8 44, i8 32, i8 50, i8 48, i8 48, i8 48, i8 32, i8 105, i8 110, i8 32, i8 116, i8 104, i8 101, i8 32, i8 99, i8 117, i8 114, i8 114, i8 101, i8 110, i8 116, i8 32, i8 116, i8 105, i8 109, i8 101, i8 122, i8 111, i8 110, i8 101, i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 121, i8 101, i8 97, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str4 = private constant [15 x i8] [i8 116, i8 109, i8 46, i8 109, i8 111, i8 110, i8 116, i8 104, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 109, i8 100, i8 97, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 119, i8 100, i8 97, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 104, i8 111, i8 117, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str8 = private constant [13 x i8] [i8 116, i8 109, i8 46, i8 109, i8 105, i8 110, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [13 x i8] [i8 116, i8 109, i8 46, i8 115, i8 101, i8 99, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]



define %Int @main() {
    %1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*))
    %2 = alloca %Time_T
    %3 = alloca %Struct_tm
    %4 = alloca %Struct_tm*
    %5 = alloca %Double
    %6 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 2
    store %Int 0, %Int* %6
    %7 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 1
    store %Int 0, %Int* %7
    %8 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 0
    store %Int 0, %Int* %8
    %9 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 5
    store %Int 100, %Int* %9
    %10 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 4
    store %Int 0, %Int* %10
    %11 = getelementptr inbounds %Struct_tm, %Struct_tm* %3, i32 0, i32 3
    store %Int 1, %Int* %11
    ;timer = clock()
    %12 = call %Time_T (%Time_T*) @time(%Time_T* %2)
    %13 = load %Time_T, %Time_T* %2
    %14 = call %Time_T (%Struct_tm*) @mktime(%Struct_tm* %3)
    %15 = call %Double (%Time_T, %Time_T) @difftime(%Time_T %13, %Time_T %14)
    store %Double %15, %Double* %5
    %16 = load %Double, %Double* %5
    %17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([59 x i8]* @str2 to [0 x i8]*), %Double %16)
    %18 = call %Struct_tm* (%Time_T*) @gmtime(%Time_T* %2)
    store %Struct_tm* %18, %Struct_tm** %4
    %19 = load %Struct_tm*, %Struct_tm** %4
    %20 = getelementptr inbounds %Struct_tm, %Struct_tm* %19, i32 0, i32 5
    %21 = load %Int, %Int* %20
    %22 = add %Int %21, 1900
    %23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*), %Int %22)
    %24 = load %Struct_tm*, %Struct_tm** %4
    %25 = getelementptr inbounds %Struct_tm, %Struct_tm* %24, i32 0, i32 4
    %26 = load %Int, %Int* %25
    %27 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str4 to [0 x i8]*), %Int %26)
    %28 = load %Struct_tm*, %Struct_tm** %4
    %29 = getelementptr inbounds %Struct_tm, %Struct_tm* %28, i32 0, i32 3
    %30 = load %Int, %Int* %29
    %31 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), %Int %30)
    %32 = load %Struct_tm*, %Struct_tm** %4
    %33 = getelementptr inbounds %Struct_tm, %Struct_tm* %32, i32 0, i32 6
    %34 = load %Int, %Int* %33
    %35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), %Int %34)
    %36 = load %Struct_tm*, %Struct_tm** %4
    %37 = getelementptr inbounds %Struct_tm, %Struct_tm* %36, i32 0, i32 2
    %38 = load %Int, %Int* %37
    %39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), %Int %38)
    %40 = load %Struct_tm*, %Struct_tm** %4
    %41 = getelementptr inbounds %Struct_tm, %Struct_tm* %40, i32 0, i32 1
    %42 = load %Int, %Int* %41
    %43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str8 to [0 x i8]*), %Int %42)
    %44 = load %Struct_tm*, %Struct_tm** %4
    %45 = getelementptr inbounds %Struct_tm, %Struct_tm* %44, i32 0, i32 0
    %46 = load %Int, %Int* %45
    %47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str9 to [0 x i8]*), %Int %46)
    ret %Int 0
}



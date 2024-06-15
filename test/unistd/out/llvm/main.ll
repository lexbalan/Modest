
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




%Socklen_T = type i32
%SizeT = type %UnsignedLongInt
%SSizeT = type %LongInt
%PidT = type i32
%UidT = type i32
%GidT = type i32
%USecondsT = type i32
%IntptrT = type i64
%OffT = type i64
%PtrToConst = type i8*


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/stdio.hm




%File = type opaque
%FposT = type opaque

%CharStr = type %Str
%ConstCharStr = type %CharStr


declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %filename, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %stream, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %filename)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buffer)


declare %Int @setvbuf(%File* %f, %CharStr* %buffer, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %stream, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)


declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, ...)


declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, ...)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, ...)
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


; -- SOURCE: /Users/alexbalan/p/Modest/lib/libc/time.hm




%TimeT = type i32
%ClockT = type %UnsignedLong
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



declare %ClockT @clock()


declare %Double @difftime(%TimeT %end, %TimeT %beginning)


declare %TimeT @mktime(%Struct_tm* %timeptr)


declare %TimeT @time(%TimeT* %timer)


declare %Char* @asctime(%Struct_tm* %timeptr)


declare %Char* @ctime(%TimeT* %timer)


declare %Struct_tm* @gmtime(%TimeT* %timer)


declare %Struct_tm* @localtime(%TimeT* %timer)


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

@str1 = private constant [13 x i8] [i8 117, i8 110, i8 105, i8 115, i8 116, i8 100, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 112, i8 105, i8 100, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str3 = private constant [14 x i8] [i8 104, i8 111, i8 115, i8 116, i8 105, i8 100, i8 32, i8 61, i8 32, i8 37, i8 108, i8 100, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 99, i8 116, i8 101, i8 114, i8 109, i8 105, i8 100, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str5 = private constant [10 x i8] [i8 99, i8 119, i8 100, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 116, i8 116, i8 121, i8 110, i8 97, i8 109, i8 101, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str7 = private constant [5 x i8] [i8 80, i8 65, i8 84, i8 72, i8 0]
@str8 = private constant [8 x i8] [i8 115, i8 32, i8 61, i8 32, i8 37, i8 115, i8 10, i8 0]
@str9 = private constant [6 x i8] [i8 45, i8 32, i8 104, i8 105, i8 10, i8 0]




declare %Str* @getenv(%Str* %name)

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str1 to [0 x i8]*))
	%2 = call %PidT @getpid()
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), %PidT %2)
	%4 = call %Long @gethostid()
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str3 to [0 x i8]*), %Long %4)
	; current control terminal
	%6 = alloca [128 x i8], align 1
	%7 = bitcast [128 x i8]* %6 to [0 x %Char]*
	%8 = call [0 x %Char]* @ctermid([0 x %Char]* %7)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*), [128 x i8]* %6)
	; current working directory
	%10 = alloca [128 x i8], align 1
	%11 = bitcast [128 x i8]* %10 to [0 x %Char]*
	%12 = call [0 x %Char]* @getcwd([0 x %Char]* %11, %SizeT 128)
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str5 to [0 x i8]*), [128 x i8]* %10)
	%14 = call [0 x %Char]* @ttyname(%Int 0)
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), [0 x %Char]* %14)
	%16 = call %Str* @getenv(%Str* bitcast ([5 x i8]* @str7 to [0 x i8]*))
	%17 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str8 to [0 x i8]*), %Str* %16)
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%18 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str9 to [0 x i8]*))
	%19 = call %UnsignedInt @sleep(%UnsignedInt 1)
	br label %again_1
break_1:
	ret %Int 0
}



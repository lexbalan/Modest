
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

%Str = type %Str8;
%Char = type i8;
%ConstChar = type %Char;
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
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type i64;
%PtrDiffT = type i8*;
%OffT = type i64;
%USecondsT = type i32;
%PIDT = type i32;
%UIDT = type i32;
%GIDT = type i32;

%File = type i8;
%FposT = type i8;
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

%TimeT = type i32;
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
; -- end print includes --
; -- print imports --

declare %StructTM* @localTimeNow()

%Date = type {
	i32, 
	i8, 
	i8
};

%Time = type {
	i8, 
	i8, 
	i8
};

%DateTime = type {
	i32, 
	i8, 
	i8, 
	i8, 
	i8, 
	i8
};


declare %Time @datetime_timeNow()
declare %Date @datetime_dateNow()
declare %DateTime @datetime_dateTimeNow()
; -- end print imports --
; -- strings --
@str1 = private constant [12 x i8] [i8 99, i8 116, i8 105, i8 109, i8 101, i8 32, i8 116, i8 101, i8 115, i8 116, i8 10, i8 0]
@str2 = private constant [35 x i8] [i8 72, i8 111, i8 117, i8 114, i8 115, i8 32, i8 115, i8 105, i8 110, i8 99, i8 101, i8 32, i8 74, i8 97, i8 110, i8 117, i8 97, i8 114, i8 121, i8 32, i8 49, i8 44, i8 32, i8 49, i8 57, i8 55, i8 48, i8 32, i8 61, i8 32, i8 37, i8 108, i8 100, i8 10, i8 0]
@str3 = private constant [59 x i8] [i8 37, i8 46, i8 102, i8 32, i8 115, i8 101, i8 99, i8 111, i8 110, i8 100, i8 115, i8 32, i8 115, i8 105, i8 110, i8 99, i8 101, i8 32, i8 74, i8 97, i8 110, i8 117, i8 97, i8 114, i8 121, i8 32, i8 49, i8 44, i8 32, i8 50, i8 48, i8 48, i8 48, i8 32, i8 105, i8 110, i8 32, i8 116, i8 104, i8 101, i8 32, i8 99, i8 117, i8 114, i8 114, i8 101, i8 110, i8 116, i8 32, i8 116, i8 105, i8 109, i8 101, i8 122, i8 111, i8 110, i8 101, i8 10, i8 0]
@str4 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 121, i8 101, i8 97, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str5 = private constant [15 x i8] [i8 116, i8 109, i8 46, i8 109, i8 111, i8 110, i8 116, i8 104, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str6 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 109, i8 100, i8 97, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str7 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 119, i8 100, i8 97, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str8 = private constant [14 x i8] [i8 116, i8 109, i8 46, i8 104, i8 111, i8 117, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str9 = private constant [13 x i8] [i8 116, i8 109, i8 46, i8 109, i8 105, i8 110, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str10 = private constant [13 x i8] [i8 116, i8 109, i8 46, i8 115, i8 101, i8 99, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str11 = private constant [1 x i8] [i8 0]
@str12 = private constant [15 x i8] [i8 110, i8 111, i8 119, i8 46, i8 121, i8 101, i8 97, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str13 = private constant [16 x i8] [i8 110, i8 111, i8 119, i8 46, i8 109, i8 111, i8 110, i8 116, i8 104, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str14 = private constant [14 x i8] [i8 110, i8 111, i8 119, i8 46, i8 100, i8 97, i8 121, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str15 = private constant [15 x i8] [i8 110, i8 111, i8 119, i8 46, i8 104, i8 111, i8 117, i8 114, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str16 = private constant [17 x i8] [i8 110, i8 111, i8 119, i8 46, i8 109, i8 105, i8 110, i8 117, i8 116, i8 101, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]
@str17 = private constant [17 x i8] [i8 110, i8 111, i8 119, i8 46, i8 115, i8 101, i8 99, i8 111, i8 110, i8 100, i8 32, i8 61, i8 32, i8 37, i8 105, i8 10, i8 0]

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str1 to [0 x i8]*))
	%2 = call %TimeT @time(%TimeT* null)
	%3 = sdiv %TimeT %2, 3600
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str2 to [0 x i8]*), %TimeT %3)
	%5 = alloca %StructTM, align 8
	%6 = alloca %StructTM*, align 8
	%7 = alloca %Double, align 8
	%8 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 2
	store %Int 0, %Int* %8
	%9 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 1
	store %Int 0, %Int* %9
	%10 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 0
	store %Int 0, %Int* %10
	%11 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 5
	store %Int 100, %Int* %11
	%12 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 4
	store %Int 0, %Int* %12
	%13 = getelementptr inbounds %StructTM, %StructTM* %5, i32 0, i32 3
	store %Int 1, %Int* %13
	;timer = clock()
	%14 = alloca %TimeT, align 4
	%15 = call %TimeT @time(%TimeT* %14)
	%16 = load %TimeT, %TimeT* %14
	%17 = bitcast %StructTM* %5 to %StructTM*
	%18 = call %TimeT @mktime(%StructTM* %17)
	%19 = call %Double @difftime(%TimeT %16, %TimeT %18)
	store %Double %19, %Double* %7
	%20 = load %Double, %Double* %7
	%21 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([59 x i8]* @str3 to [0 x i8]*), %Double %20)
	%22 = alloca %TimeT, align 4
	%23 = call %TimeT @time(%TimeT* %22)
	;time2 = time(nil)   // segfail
	%24 = call %StructTM* @localtime(%TimeT* %22)
	%25 = bitcast %StructTM* %24 to %StructTM*
	store %StructTM* %25, %StructTM** %6
	;tm = gmtime(&time2)
	%26 = load %StructTM*, %StructTM** %6
	%27 = getelementptr inbounds %StructTM, %StructTM* %26, i32 0, i32 5
	%28 = load %Int, %Int* %27
	%29 = add %Int %28, 1900
	%30 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str4 to [0 x i8]*), %Int %29)
	%31 = load %StructTM*, %StructTM** %6
	%32 = getelementptr inbounds %StructTM, %StructTM* %31, i32 0, i32 4
	%33 = load %Int, %Int* %32
	%34 = add %Int %33, 1
	%35 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str5 to [0 x i8]*), %Int %34)
	%36 = load %StructTM*, %StructTM** %6
	%37 = getelementptr inbounds %StructTM, %StructTM* %36, i32 0, i32 3
	%38 = load %Int, %Int* %37
	%39 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str6 to [0 x i8]*), %Int %38)
	%40 = load %StructTM*, %StructTM** %6
	%41 = getelementptr inbounds %StructTM, %StructTM* %40, i32 0, i32 6
	%42 = load %Int, %Int* %41
	%43 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str7 to [0 x i8]*), %Int %42)
	%44 = load %StructTM*, %StructTM** %6
	%45 = getelementptr inbounds %StructTM, %StructTM* %44, i32 0, i32 2
	%46 = load %Int, %Int* %45
	%47 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str8 to [0 x i8]*), %Int %46)
	%48 = load %StructTM*, %StructTM** %6
	%49 = getelementptr inbounds %StructTM, %StructTM* %48, i32 0, i32 1
	%50 = load %Int, %Int* %49
	%51 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str9 to [0 x i8]*), %Int %50)
	%52 = load %StructTM*, %StructTM** %6
	%53 = getelementptr inbounds %StructTM, %StructTM* %52, i32 0, i32 0
	%54 = load %Int, %Int* %53
	%55 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str10 to [0 x i8]*), %Int %54)
	%56 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([1 x i8]* @str11 to [0 x i8]*))
	%57 = call %DateTime @datetime_dateTimeNow()
	%58 = extractvalue %DateTime %57, 0
	%59 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str12 to [0 x i8]*), i32 %58)
	%60 = extractvalue %DateTime %57, 1
	%61 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str13 to [0 x i8]*), i8 %60)
	%62 = extractvalue %DateTime %57, 2
	%63 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str14 to [0 x i8]*), i8 %62)
	%64 = extractvalue %DateTime %57, 3
	%65 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str15 to [0 x i8]*), i8 %64)
	%66 = extractvalue %DateTime %57, 4
	%67 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str16 to [0 x i8]*), i8 %66)
	%68 = extractvalue %DateTime %57, 5
	%69 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str17 to [0 x i8]*), i8 %68)
	ret %Int 0
}



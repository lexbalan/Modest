
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
%File = type %Nat8;
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
declare %Int @printf(%ConstCharStr* %s, ...)
declare %Int @scanf(%ConstCharStr* %s, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
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
declare %SizeT @strcspn(%Str8* %str1, %Str8* %str2)
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
; from included math
declare %Double @acos(%Double %x)
declare %Double @asin(%Double %x)
declare %Double @atan(%Double %x)
declare %Double @atan2(%Double %a, %Double %b)
declare %Double @cos(%Double %x)
declare %Double @sin(%Double %x)
declare %Double @tan(%Double %x)
declare %Double @cosh(%Double %x)
declare %Double @sinh(%Double %x)
declare %Double @tanh(%Double %x)
declare %Double @exp(%Double %x)
declare %Double @frexp(%Double %a, %Int* %i)
declare %Double @ldexp(%Double %a, %Int %i)
declare %Double @log(%Double %x)
declare %Double @log10(%Double %x)
declare %Double @modf(%Double %a, %Double* %b)
declare %Double @pow(%Double %a, %Double %b)
declare %Double @sqrt(%Double %x)
declare %Double @ceil(%Double %x)
declare %Double @fabs(%Double %x)
declare %Double @floor(%Double %x)
declare %Double @fmod(%Double %a, %Double %b)
declare %LongDouble @acosl(%LongDouble %x)
declare %LongDouble @asinl(%LongDouble %x)
declare %LongDouble @atanl(%LongDouble %x)
declare %LongDouble @atan2l(%LongDouble %a, %LongDouble %b)
declare %LongDouble @cosl(%LongDouble %x)
declare %LongDouble @sinl(%LongDouble %x)
declare %LongDouble @tanl(%LongDouble %x)
declare %LongDouble @acoshl(%LongDouble %x)
declare %LongDouble @asinhl(%LongDouble %x)
declare %LongDouble @atanhl(%LongDouble %x)
declare %LongDouble @coshl(%LongDouble %x)
declare %LongDouble @sinhl(%LongDouble %x)
declare %LongDouble @tanhl(%LongDouble %x)
declare %LongDouble @expl(%LongDouble %x)
declare %LongDouble @exp2l(%LongDouble %x)
declare %LongDouble @expm1l(%LongDouble %x)
declare %LongDouble @frexpl(%LongDouble %a, %Int* %i)
declare %Int @ilogbl(%LongDouble %x)
declare %LongDouble @ldexpl(%LongDouble %a, %Int %i)
declare %LongDouble @logl(%LongDouble %x)
declare %LongDouble @log10l(%LongDouble %x)
declare %LongDouble @log1pl(%LongDouble %x)
declare %LongDouble @log2l(%LongDouble %x)
declare %LongDouble @logbl(%LongDouble %x)
declare %LongDouble @modfl(%LongDouble %a, %LongDouble* %b)
declare %LongDouble @scalbnl(%LongDouble %a, %Int %i)
declare %LongDouble @scalblnl(%LongDouble %a, %LongInt %i)
declare %LongDouble @cbrtl(%LongDouble %x)
declare %LongDouble @fabsl(%LongDouble %x)
declare %LongDouble @hypotl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @powl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @sqrtl(%LongDouble %x)
declare %LongDouble @erfl(%LongDouble %x)
declare %LongDouble @erfcl(%LongDouble %x)
declare %LongDouble @lgammal(%LongDouble %x)
declare %LongDouble @tgammal(%LongDouble %x)
declare %LongDouble @ceill(%LongDouble %x)
declare %LongDouble @floorl(%LongDouble %x)
declare %LongDouble @nearbyintl(%LongDouble %x)
declare %LongDouble @rintl(%LongDouble %x)
declare %LongInt @lrintl(%LongDouble %x)
declare %LongLongInt @llrintl(%LongDouble %x)
declare %LongDouble @roundl(%LongDouble %x)
declare %LongInt @lroundl(%LongDouble %x)
declare %LongLongInt @llroundl(%LongDouble %x)
declare %LongDouble @truncl(%LongDouble %x)
declare %LongDouble @fmodl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remainderl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @remquol(%LongDouble %a, %LongDouble %b, %Int* %i)
declare %LongDouble @copysignl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nanl(%ConstChar* %x)
declare %LongDouble @nextafterl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @nexttowardl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fdiml(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmaxl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fminl(%LongDouble %a, %LongDouble %b)
declare %LongDouble @fmal(%LongDouble %a, %LongDouble %b, %LongDouble %c)
; from included libc
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [9 x i8] [i8 102, i8 105, i8 108, i8 101, i8 46, i8 116, i8 120, i8 116, i8 0]
@str2 = private constant [19 x i8] [i8 116, i8 101, i8 120, i8 116, i8 95, i8 102, i8 105, i8 108, i8 101, i8 32, i8 101, i8 120, i8 97, i8 109, i8 112, i8 108, i8 101, i8 10, i8 0]
@str3 = private constant [2 x i8] [i8 114, i8 0]
@str4 = private constant [9 x i8] [i8 62, i8 62, i8 32, i8 69, i8 78, i8 68, i8 46, i8 10, i8 0]
@str5 = private constant [14 x i8] [i8 84, i8 79, i8 75, i8 69, i8 78, i8 32, i8 61, i8 32, i8 39, i8 37, i8 115, i8 39, i8 10, i8 0]
; -- endstrings --
%Lexer = type {
	%File*,
	[2 x %Char8],
	%Nat8,
	%Nat16,
	[256 x %Char8],
	%Nat16
};

@lex = internal global %Lexer zeroinitializer
define internal {%Int32} @init(%Lexer* %object) {
	%1 = getelementptr %Lexer, %Lexer* %object, %Int32 0, %Int32 5
	store %Nat16 0, %Nat16* %1
	ret {%Int32} zeroinitializer
}

define internal %Bool @is_alpha(%Char8 %c) {
	%1 = zext %Char8 %c to %Word32
	%2 = bitcast %Word32 %1 to %Int
	%3 = call %Bool @isalpha(%Int %2)
	ret %Bool %3
}

define internal %Bool @is_digit(%Char8 %c) {
	%1 = zext %Char8 %c to %Word32
	%2 = bitcast %Word32 %1 to %Int
	%3 = call %Bool @isdigit(%Int %2)
	ret %Bool %3
}

define internal %Char8 @getcc(%Lexer* %lex) {
	%1 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 0
	%2 = load %File*, %File** %1
	%3 = call %Int @fgetc(%File* %2)
	%4 = bitcast %Int %3 to %Word32
	%5 = trunc %Word32 %4 to %Word8
	%6 = bitcast %Word8 %5 to %Char8
	ret %Char8 %6
}

define internal void @putcc(%Lexer* %lex, %Char8 %c) {
	%1 = bitcast %Char8 %c to %Word8
	%2 = zext %Word8 %1 to %Word32
	%3 = bitcast %Word32 %2 to %Int
	%4 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 0
	%5 = load %File*, %File** %4
	%6 = call %Int @ungetc(%Int %3, %File* %5)
	ret void
}

define internal %Bool @gettok(%Lexer* %lex) {
	%1 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	store %Nat16 0, %Nat16* %1
	%2 = alloca %Char8, align 1
	%3 = bitcast %Lexer* %lex to %Lexer*
	%4 = call %Char8 @getcc(%Lexer* %3)
	store %Char8 %4, %Char8* %2

	; skip blanks
; while_1
	br label %again_1
again_1:
	%5 = load %Char8, %Char8* %2
	%6 = icmp eq %Char8 %5, 32
	%7 = load %Char8, %Char8* %2
	%8 = icmp eq %Char8 %7, 9
	%9 = or %Bool %6, %8
	br %Bool %9 , label %body_1, label %break_1
body_1:
	%10 = bitcast %Lexer* %lex to %Lexer*
	%11 = call %Char8 @getcc(%Lexer* %10)
	store %Char8 %11, %Char8* %2
	br label %again_1
break_1:
; if_0
	%12 = load %Char8, %Char8* %2
	%13 = call %Bool @is_alpha(%Char8 %12)
	%14 = load %Char8, %Char8* %2
	%15 = icmp eq %Char8 %14, 95
	%16 = or %Bool %13, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:
	%17 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 3
	store %Nat16 1, %Nat16* %17
; while_2
	br label %again_2
again_2:
	%18 = load %Char8, %Char8* %2
	%19 = call %Bool @is_alpha(%Char8 %18)
	%20 = load %Char8, %Char8* %2
	%21 = call %Bool @is_digit(%Char8 %20)
	%22 = load %Char8, %Char8* %2
	%23 = icmp eq %Char8 %22, 95
	%24 = or %Bool %21, %23
	%25 = or %Bool %19, %24
	br %Bool %25 , label %body_2, label %break_2
body_2:
	%26 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%27 = load %Nat16, %Nat16* %26
	%28 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%29 = zext %Nat16 %27 to %Nat32
	%30 = getelementptr [256 x %Char8], [256 x %Char8]* %28, %Int32 0, %Nat32 %29
	%31 = load %Char8, %Char8* %2
	store %Char8 %31, %Char8* %30
	%32 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%33 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%34 = load %Nat16, %Nat16* %33
	%35 = add %Nat16 %34, 1
	store %Nat16 %35, %Nat16* %32
	%36 = bitcast %Lexer* %lex to %Lexer*
	%37 = call %Char8 @getcc(%Lexer* %36)
	store %Char8 %37, %Char8* %2
	br label %again_2
break_2:
	br label %endif_0
else_0:
; if_1
	%38 = load %Char8, %Char8* %2
	%39 = call %Bool @is_digit(%Char8 %38)
	br %Bool %39 , label %then_1, label %else_1
then_1:
	%40 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 3
	store %Nat16 2, %Nat16* %40
; while_3
	br label %again_3
again_3:
	%41 = load %Char8, %Char8* %2
	%42 = call %Bool @is_alpha(%Char8 %41)
	%43 = load %Char8, %Char8* %2
	%44 = call %Bool @is_digit(%Char8 %43)
	%45 = load %Char8, %Char8* %2
	%46 = icmp eq %Char8 %45, 95
	%47 = or %Bool %44, %46
	%48 = or %Bool %42, %47
	br %Bool %48 , label %body_3, label %break_3
body_3:
	%49 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%50 = load %Nat16, %Nat16* %49
	%51 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%52 = zext %Nat16 %50 to %Nat32
	%53 = getelementptr [256 x %Char8], [256 x %Char8]* %51, %Int32 0, %Nat32 %52
	%54 = load %Char8, %Char8* %2
	store %Char8 %54, %Char8* %53
	%55 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%56 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%57 = load %Nat16, %Nat16* %56
	%58 = add %Nat16 %57, 1
	store %Nat16 %58, %Nat16* %55
	%59 = bitcast %Lexer* %lex to %Lexer*
	%60 = call %Char8 @getcc(%Lexer* %59)
	store %Char8 %60, %Char8* %2
	br label %again_3
break_3:
	br label %endif_1
else_1:
	%61 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 3
	store %Nat16 3, %Nat16* %61
; if_2
	%62 = load %Char8, %Char8* %2
	%63 = icmp eq %Char8 %62, 45
	br %Bool %63 , label %then_2, label %else_2
then_2:
	%64 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%65 = load %Nat16, %Nat16* %64
	%66 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%67 = zext %Nat16 %65 to %Nat32
	%68 = getelementptr [256 x %Char8], [256 x %Char8]* %66, %Int32 0, %Nat32 %67
	%69 = load %Char8, %Char8* %2
	store %Char8 %69, %Char8* %68
	%70 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%71 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%72 = load %Nat16, %Nat16* %71
	%73 = add %Nat16 %72, 1
	store %Nat16 %73, %Nat16* %70
	%74 = bitcast %Lexer* %lex to %Lexer*
	%75 = call %Char8 @getcc(%Lexer* %74)
	store %Char8 %75, %Char8* %2
; if_3
	%76 = load %Char8, %Char8* %2
	%77 = icmp eq %Char8 %76, 62
	br %Bool %77 , label %then_3, label %else_3
then_3:
	%78 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%79 = load %Nat16, %Nat16* %78
	%80 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%81 = zext %Nat16 %79 to %Nat32
	%82 = getelementptr [256 x %Char8], [256 x %Char8]* %80, %Int32 0, %Nat32 %81
	%83 = load %Char8, %Char8* %2
	store %Char8 %83, %Char8* %82
	%84 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%85 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%86 = load %Nat16, %Nat16* %85
	%87 = add %Nat16 %86, 1
	store %Nat16 %87, %Nat16* %84
	br label %endif_3
else_3:
	%88 = bitcast %Lexer* %lex to %Lexer*
	%89 = load %Char8, %Char8* %2
	call void @putcc(%Lexer* %88, %Char8 %89)
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
; if_4
	%90 = load %Char8, %Char8* %2
	%91 = icmp eq %Char8 %90, 255
	br %Bool %91 , label %then_4, label %else_4
then_4:
	ret %Bool 0
	br label %endif_4
else_4:
	%93 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%94 = load %Nat16, %Nat16* %93
	%95 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%96 = zext %Nat16 %94 to %Nat32
	%97 = getelementptr [256 x %Char8], [256 x %Char8]* %95, %Int32 0, %Nat32 %96
	%98 = load %Char8, %Char8* %2
	store %Char8 %98, %Char8* %97
	%99 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%100 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%101 = load %Nat16, %Nat16* %100
	%102 = add %Nat16 %101, 1
	store %Nat16 %102, %Nat16* %99
	br label %endif_4
endif_4:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%103 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 5
	%104 = load %Nat16, %Nat16* %103
	%105 = getelementptr %Lexer, %Lexer* %lex, %Int32 0, %Int32 4
	%106 = zext %Nat16 %104 to %Nat32
	%107 = getelementptr [256 x %Char8], [256 x %Char8]* %105, %Int32 0, %Nat32 %106
	store %Char8 0, %Char8* %107
	ret %Bool 1
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str2 to [0 x i8]*))
	%2 = alloca %Lexer, align 512
	%3 = bitcast %Lexer* %2 to %Lexer*
	%4 = call {%Int32} @init(%Lexer* %3)
	%5 = getelementptr %Lexer, %Lexer* %2, %Int32 0, %Int32 0
	%6 = call %File* @fopen(%Str8* bitcast ([9 x i8]* @str1 to [0 x i8]*), %ConstCharStr* bitcast ([2 x i8]* @str3 to [0 x i8]*))
	store %File* %6, %File** %5
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%7 = bitcast %Lexer* %2 to %Lexer*
	%8 = call %Bool @gettok(%Lexer* %7)
; if_0
	%9 = xor %Bool %8, 1
	br %Bool %9 , label %then_0, label %endif_0
then_0:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([9 x i8]* @str4 to [0 x i8]*))
	br label %break_1
	br label %endif_0
endif_0:
	%12 = getelementptr %Lexer, %Lexer* %2, %Int32 0, %Int32 4
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([14 x i8]* @str5 to [0 x i8]*), [256 x %Char8]* %12)
	br label %again_1
break_1:
	%14 = getelementptr %Lexer, %Lexer* %2, %Int32 0, %Int32 0
	%15 = load %File*, %File** %14
	%16 = call %Int @fclose(%File* %15)
	ret %Int 0
}



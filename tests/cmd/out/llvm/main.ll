
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
; -- end print includes --
; -- print imports 'main' --
; -- 0
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [10 x i8] [i8 37, i8 115, i8 32, i8 40, i8 110, i8 61, i8 37, i8 100, i8 41, i8 0]
@str2 = private constant [3 x i8] [i8 32, i8 91, i8 0]
@str3 = private constant [5 x i8] [i8 39, i8 37, i8 115, i8 39, i8 0]
@str4 = private constant [3 x i8] [i8 93, i8 10, i8 0]
@str5 = private constant [12 x i8] [i8 72, i8 65, i8 82, i8 83, i8 72, i8 32, i8 118, i8 48, i8 46, i8 49, i8 10, i8 0]
; -- endstrings --
@tokensBuf = internal global [4096 x %Char8] zeroinitializer
define internal void @showPrompt() {
	%1 = alloca [32 x %Char8], align 1
	%2 = insertvalue [32 x %Char8] zeroinitializer, %Char8 35, 0
	%3 = insertvalue [32 x %Char8] %2, %Char8 32, 1
	%4 = zext i8 32 to %Nat32
	store [32 x %Char8] %3, [32 x %Char8]* %1
	%5 = bitcast [32 x %Char8]* %1 to i8*
	%6 = call %SSizeT @write(%Int 0, i8* %5, %SizeT 2)
	ret void
}

define internal %Int @char8ToInt(%Char8 %c) alwaysinline {
	%1 = bitcast %Char8 %c to %Word8
	%2 = zext %Word8 %1 to %Word32
	%3 = bitcast %Word32 %2 to %Int
	ret %Int %3
}

%Tokenizer = type {
	[0 x %Char8]*,
	%Nat32,
	%Nat16,
	%Nat16,
	[0 x %Char8]*,
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

	; skip blanks
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

	; check if not EOS
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

	; handle token
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
	;if isalnum(char8ToInt(c)) {
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
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%1 = alloca [128 x %Char8], align 1
	%2 = alloca %Char8*, align 8
	%3 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%4 = load %Nat16, %Nat16* %3
	%5 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 4
	%6 = load [0 x %Char8]*, [0 x %Char8]** %5
	%7 = zext %Nat16 %4 to %Nat32
	%8 = getelementptr [0 x %Char8], [0 x %Char8]* %6, %Int32 0, %Nat32 %7
	store %Char8* %8, %Char8** %2
	%9 = bitcast [128 x %Char8]* %1 to [0 x %Char8]*
	%10 = call %Nat16 @gettok(%Tokenizer* %tokenizer, [0 x %Char8]* %9, %Nat16 128)
; if_0
	%11 = icmp eq %Nat16 %10, 0
	br %Bool %11 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:

	; save token in tokens buffer
	%13 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 4
	%14 = load [0 x %Char8]*, [0 x %Char8]** %13
	%15 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%16 = load %Nat16, %Nat16* %15
	%17 = zext %Nat16 %16 to %Nat32
	%18 = getelementptr [0 x %Char8], [0 x %Char8]* %14, %Int32 0, %Nat32 %17
;
	%19 = bitcast %Char8* %18 to [0 x %Char8]*
	%20 = zext i8 0 to %Nat32
	%21 = getelementptr [0 x %Char8], [0 x %Char8]* %19, %Int32 0, %Nat32 %20
;
	%22 = bitcast %Char8* %21 to [0 x %Char8]*
	%23 = zext i8 0 to %Nat32
	%24 = getelementptr [128 x %Char8], [128 x %Char8]* %1, %Int32 0, %Nat32 %23
	%25 = bitcast %Char8* %24 to [0 x %Char8]*
	%26 = load [0 x %Char8], [0 x %Char8]* %25
	%27 = sub %Nat16 %10, 0
	%28 = zext %Nat16 %27 to %Nat32
	store [0 x %Char8] %26, [0 x %Char8]* %22
	%29 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%30 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%31 = load %Nat16, %Nat16* %30
	%32 = add %Nat16 %31, %10
	store %Nat16 %32, %Nat16* %29
	%33 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%34 = load %Nat16, %Nat16* %33
	%35 = zext %Nat16 %34 to %Nat32
	%36 = getelementptr [0 x %Char8], [0 x %Char8]* %19, %Int32 0, %Nat32 %35
	store %Char8 0, %Char8* %36
	%37 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%38 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 2
	%39 = load %Nat16, %Nat16* %38
	%40 = add %Nat16 %39, 1
	store %Nat16 %40, %Nat16* %37
	; save pointer to token
	%41 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 3
	%42 = load %Nat16, %Nat16* %41
	%43 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 5
	%44 = load [0 x [0 x %Char8]*]*, [0 x [0 x %Char8]*]** %43
	%45 = zext %Nat16 %42 to %Nat32
	%46 = getelementptr [0 x [0 x %Char8]*], [0 x [0 x %Char8]*]* %44, %Int32 0, %Nat32 %45
	store [0 x %Char8]* %19, [0 x %Char8]** %46
	%47 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 3
	%48 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 3
	%49 = load %Nat16, %Nat16* %48
	%50 = add %Nat16 %49, 1
	store %Nat16 %50, %Nat16* %47
	%51 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 3
	%52 = load %Nat16, %Nat16* %51
	%53 = getelementptr %Tokenizer, %Tokenizer* %tokenizer, %Int32 0, %Int32 5
	%54 = load [0 x [0 x %Char8]*]*, [0 x [0 x %Char8]*]** %53
	%55 = zext %Nat16 %52 to %Nat32
	%56 = getelementptr [0 x [0 x %Char8]*], [0 x [0 x %Char8]*]* %54, %Int32 0, %Nat32 %55
	store [0 x %Char8]* null, [0 x %Char8]** %56
	br label %again_1
break_1:
	ret void
}

define internal void @execute(%Str8* %cmd, %Nat16 %argc, [0 x %Str8*]* %argv) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str1 to [0 x i8]*), %Str8* %cmd, %Nat16 %argc)
	%2 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str2 to [0 x i8]*))
	%3 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %3
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %3
	%5 = bitcast %Nat32 %4 to %Nat32
	%6 = getelementptr [0 x %Str8*], [0 x %Str8*]* %argv, %Int32 0, %Nat32 %5
	%7 = load %Str8*, %Str8** %6
; if_0
	%8 = icmp eq %Str8* %7, null
	br %Bool %8 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str3 to [0 x i8]*), %Str8* %7)
	%11 = load %Nat32, %Nat32* %3
	%12 = add %Nat32 %11, 1
	store %Nat32 %12, %Nat32* %3
	br label %again_1
break_1:
	%13 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([3 x i8]* @str4 to [0 x i8]*))
	ret void
}

define %Int32 @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str5 to [0 x i8]*))
	%2 = alloca [1024 x %Char8], align 1
; while_1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	call void @showPrompt()
	%3 = bitcast [1024 x %Char8]* %2 to %CharStr*
	%4 = call %CharStr* @fgets(%CharStr* %3, %Int 1024, %File* undef)
	%5 = alloca [64 x [0 x %Char8]*], align 1
	%6 = zext i8 64 to %Nat32
	%7 = mul %Nat32 %6, 8
	%8 = bitcast [64 x [0 x %Char8]*]* %5 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %8, i8 0, %Nat32 %7, i1 0)

	; Токенизируем строку
	%9 = alloca %Tokenizer, align 32
	%10 = bitcast [1024 x %Char8]* %2 to [0 x %Char8]*
	%11 = insertvalue %Tokenizer zeroinitializer, [0 x %Char8]* %10, 0
	%12 = bitcast [4096 x %Char8]* @tokensBuf to [0 x %Char8]*
	%13 = insertvalue %Tokenizer %11, [0 x %Char8]* %12, 4
	%14 = bitcast [64 x [0 x %Char8]*]* %5 to [0 x [0 x %Char8]*]*
	%15 = insertvalue %Tokenizer %13, [0 x [0 x %Char8]*]* %14, 5
	store %Tokenizer %15, %Tokenizer* %9
	%16 = bitcast %Tokenizer* %9 to %Tokenizer*
	call void @tokenize(%Tokenizer* %16)

	; "выполняем" команду
	%17 = getelementptr %Tokenizer, %Tokenizer* %9, %Int32 0, %Int32 5
	%18 = load [0 x [0 x %Char8]*]*, [0 x [0 x %Char8]*]** %17
	%19 = getelementptr [0 x [0 x %Char8]*], [0 x [0 x %Char8]*]* %18, %Int32 0, %Int32 0
	%20 = load [0 x %Char8]*, [0 x %Char8]** %19
	%21 = alloca %Nat16, align 2
	%22 = getelementptr %Tokenizer, %Tokenizer* %9, %Int32 0, %Int32 3
	%23 = load %Nat16, %Nat16* %22
	store %Nat16 %23, %Nat16* %21
; if_0
	%24 = load %Nat16, %Nat16* %21
	%25 = icmp ugt %Nat16 %24, 0
	br %Bool %25 , label %then_0, label %endif_0
then_0:
	%26 = load %Nat16, %Nat16* %21
	%27 = sub %Nat16 %26, 1
	store %Nat16 %27, %Nat16* %21
	br label %endif_0
endif_0:
	%28 = getelementptr %Tokenizer, %Tokenizer* %9, %Int32 0, %Int32 5
	%29 = load [0 x [0 x %Char8]*]*, [0 x [0 x %Char8]*]** %28
	%30 = zext i8 1 to %Nat32
	%31 = getelementptr [0 x [0 x %Char8]*], [0 x [0 x %Char8]*]* %29, %Int32 0, %Nat32 %30
;
	%32 = bitcast [0 x %Char8]** %31 to [0 x [0 x %Char8]*]*
	%33 = load %Nat16, %Nat16* %21
	call void @execute([0 x %Char8]* %20, %Nat16 %33, [0 x [0 x %Char8]*]* %32)
	br label %again_1
break_1:
	ret %Int32 0
}



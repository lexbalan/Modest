
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

; MODULE: console

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
; -- end print includes --
; -- print imports --

declare i8 @utf_utf32_to_utf8(i32 %c, [4 x i8]* %buf)
declare i8 @utf_utf16_to_utf32([0 x i16]* %c, i32* %result)
; -- end print imports --
; -- strings --

define i8 @n_to_sym(i8 %n) {
	%1 = alloca i8, align 1
	%2 = icmp ule i8 %n, 9
	br i1 %2 , label %then_0, label %else_0
then_0:
	%3 = add i8 48, %n
	%4 = bitcast i8 %3 to i8
	store i8 %4, i8* %1
	br label %endif_0
else_0:
	%5 = sub i8 %n, 10
	%6 = add i8 65, %5
	%7 = bitcast i8 %6 to i8
	store i8 %7, i8* %1
	br label %endif_0
endif_0:
	%8 = load i8, i8* %1
	ret i8 %8
}

define i32 @sprint_hex_nat32([0 x i8]* %buf, i32 %x) {
	%1 = alloca [8 x i8], align 1
	%2 = alloca i32, align 4
	store i32 %x, i32* %2
	%3 = alloca i32, align 4
	store i32 0, i32* %3
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %2
	%5 = urem i32 %4, 16
	%6 = load i32, i32* %2
	%7 = udiv i32 %6, 16
	store i32 %7, i32* %2
	%8 = load i32, i32* %3
	%9 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %8
	%10 = trunc i32 %5 to i8
	%11 = call i8 @n_to_sym(i8 %10)
	store i8 %11, i8* %9
	%12 = load i32, i32* %3
	%13 = add i32 %12, 1
	store i32 %13, i32* %3
	%14 = load i32, i32* %2
	%15 = icmp eq i32 %14, 0
	br i1 %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	; mirroring into buffer
	%17 = alloca i32, align 4
	store i32 0, i32* %17
	br label %again_2
again_2:
	%18 = load i32, i32* %3
	%19 = icmp sgt i32 %18, 0
	br i1 %19 , label %body_2, label %break_2
body_2:
	%20 = load i32, i32* %3
	%21 = sub i32 %20, 1
	store i32 %21, i32* %3
	%22 = load i32, i32* %17
	%23 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %22
	%24 = load i32, i32* %3
	%25 = getelementptr inbounds [8 x i8], [8 x i8]* %1, i32 0, i32 %24
	%26 = load i8, i8* %25
	store i8 %26, i8* %23
	%27 = load i32, i32* %17
	%28 = add i32 %27, 1
	store i32 %28, i32* %17
	br label %again_2
break_2:
	%29 = load i32, i32* %17
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
	store i8 0, i8* %30
	%31 = load i32, i32* %17
	ret i32 %31
}

define i32 @sprint_dec_int32([0 x i8]* %buf, i32 %x) {
	%1 = alloca [11 x i8], align 1
	%2 = alloca i32, align 4
	store i32 %x, i32* %2
	%3 = load i32, i32* %2
	%4 = icmp slt i32 %3, 0
	br i1 %4 , label %then_0, label %endif_0
then_0:
	%5 = load i32, i32* %2
	%6 = sub i32 0, %5
	store i32 %6, i32* %2
	br label %endif_0
endif_0:
	%7 = alloca i32, align 4
	store i32 0, i32* %7
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%8 = load i32, i32* %2
	%9 = srem i32 %8, 10
	%10 = load i32, i32* %2
	%11 = sdiv i32 %10, 10
	store i32 %11, i32* %2
	%12 = load i32, i32* %7
	%13 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %12
	%14 = trunc i32 %9 to i8
	%15 = call i8 @n_to_sym(i8 %14)
	store i8 %15, i8* %13
	%16 = load i32, i32* %7
	%17 = add i32 %16, 1
	store i32 %17, i32* %7
	%18 = load i32, i32* %2
	%19 = icmp eq i32 %18, 0
	br i1 %19 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %again_1
break_1:
	%21 = alloca i32, align 4
	store i32 0, i32* %21
	br i1 %4 , label %then_2, label %endif_2
then_2:
	%22 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 0
	store i8 45, i8* %22
	%23 = load i32, i32* %21
	%24 = add i32 %23, 1
	store i32 %24, i32* %21
	br label %endif_2
endif_2:
	br label %again_2
again_2:
	%25 = load i32, i32* %7
	%26 = icmp sgt i32 %25, 0
	br i1 %26 , label %body_2, label %break_2
body_2:
	%27 = load i32, i32* %7
	%28 = sub i32 %27, 1
	store i32 %28, i32* %7
	%29 = load i32, i32* %21
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
	%31 = load i32, i32* %7
	%32 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %31
	%33 = load i8, i8* %32
	store i8 %33, i8* %30
	%34 = load i32, i32* %21
	%35 = add i32 %34, 1
	store i32 %35, i32* %21
	br label %again_2
break_2:
	%36 = load i32, i32* %21
	%37 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %36
	store i8 0, i8* %37
	%38 = load i32, i32* %21
	ret i32 %38
}

define i32 @sprint_n32([0 x i8]* %buf, i32 %x) {
	%1 = alloca [11 x i8], align 1
	%2 = alloca i32, align 4
	store i32 %x, i32* %2
	%3 = alloca i32, align 4
	store i32 0, i32* %3
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%4 = load i32, i32* %2
	%5 = urem i32 %4, 10
	%6 = load i32, i32* %2
	%7 = udiv i32 %6, 10
	store i32 %7, i32* %2
	%8 = load i32, i32* %3
	%9 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %8
	%10 = trunc i32 %5 to i8
	%11 = call i8 @n_to_sym(i8 %10)
	store i8 %11, i8* %9
	%12 = load i32, i32* %3
	%13 = add i32 %12, 1
	store i32 %13, i32* %3
	%14 = load i32, i32* %2
	%15 = icmp eq i32 %14, 0
	br i1 %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%17 = alloca i32, align 4
	store i32 0, i32* %17
	br label %again_2
again_2:
	%18 = load i32, i32* %3
	%19 = icmp sgt i32 %18, 0
	br i1 %19 , label %body_2, label %break_2
body_2:
	%20 = load i32, i32* %3
	%21 = sub i32 %20, 1
	store i32 %21, i32* %3
	%22 = load i32, i32* %17
	%23 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %22
	%24 = load i32, i32* %3
	%25 = getelementptr inbounds [11 x i8], [11 x i8]* %1, i32 0, i32 %24
	%26 = load i8, i8* %25
	store i8 %26, i8* %23
	%27 = load i32, i32* %17
	%28 = add i32 %27, 1
	store i32 %28, i32* %17
	br label %again_2
break_2:
	%29 = load i32, i32* %17
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %29
	store i8 0, i8* %30
	%31 = load i32, i32* %17
	ret i32 %31
}


define void @console_putchar8(i8 %c) {
	call void @console_putchar_utf8(i8 %c)
	ret void
}

define void @console_putchar16(i16 %c) {
	call void @console_putchar_utf16(i16 %c)
	ret void
}

define void @console_putchar32(i32 %c) {
	call void @console_putchar_utf32(i32 %c)
	ret void
}

define void @console_putchar_utf8(i8 %c) {
	%1 = sext i8 %c to i32
	%2 = call %Int @putchar(i32 %1)
	ret void
}

define void @console_putchar_utf16(i16 %c) {
	%1 = alloca [2 x i16], align 2
	%2 = getelementptr inbounds [2 x i16], [2 x i16]* %1, i32 0, i32 0
	store i16 %c, i16* %2
	%3 = getelementptr inbounds [2 x i16], [2 x i16]* %1, i32 0, i32 1
	store i16 0, i16* %3
	%4 = alloca i32, align 4
	%5 = bitcast [2 x i16]* %1 to [0 x i16]*
	%6 = call i8 @utf_utf16_to_utf32([0 x i16]* %5, i32* %4)
	%7 = load i32, i32* %4
	call void @console_putchar_utf32(i32 %7)
	ret void
}

define void @console_putchar_utf32(i32 %c) {
	%1 = alloca [4 x i8], align 1
	%2 = call i8 @utf_utf32_to_utf8(i32 %c, [4 x i8]* %1)
	%3 = sext i8 %2 to i32
	%4 = alloca i32, align 4
	store i32 0, i32* %4
	br label %again_1
again_1:
	%5 = load i32, i32* %4
	%6 = icmp slt i32 %5, %3
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i32, i32* %4
	%8 = getelementptr inbounds [4 x i8], [4 x i8]* %1, i32 0, i32 %7
	%9 = load i8, i8* %8
	call void @console_putchar_utf8(i8 %9)
	%10 = load i32, i32* %4
	%11 = add i32 %10, 1
	store i32 %11, i32* %4
	br label %again_1
break_1:
	ret void
}

define void @console_puts8(%Str8* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str8, %Str8* %s, i32 0, i32 %2
	%4 = load i8, i8* %3
	%5 = icmp eq i8 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf8(i8 %4)
	%7 = load i32, i32* %1
	%8 = add i32 %7, 1
	store i32 %8, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts16(%Str16* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	; нельзя просто так взять и вызвать putchar_utf16
	; тк в строке может быть суррогатная пара UTF_16 символов
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str16, %Str16* %s, i32 0, i32 %2
	%4 = load i16, i16* %3
	%5 = icmp eq i16 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%7 = alloca i32, align 4
	%8 = load i32, i32* %1
	%9 = getelementptr inbounds %Str16, %Str16* %s, i32 0, i32 %8
	%10 = bitcast i16* %9 to [0 x i16]*
	%11 = call i8 @utf_utf16_to_utf32([0 x i16]* %10, i32* %7)
	%12 = icmp eq i8 %11, 0
	br i1 %12 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%14 = load i32, i32* %7
	call void @console_putchar_utf32(i32 %14)
	%15 = load i32, i32* %1
	%16 = sext i8 %11 to i32
	%17 = add i32 %15, %16
	store i32 %17, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts32(%Str32* %s) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%2 = load i32, i32* %1
	%3 = getelementptr inbounds %Str32, %Str32* %s, i32 0, i32 %2
	%4 = load i32, i32* %3
	%5 = icmp eq i32 %4, 0
	br i1 %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf32(i32 %4)
	%7 = load i32, i32* %1
	%8 = add i32 %7, 1
	store i32 %8, i32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_print(%Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = load i8*, i8** %1
	call void @console_vfprint(%Int 1, %Str8* %form, i8* %3)
	%4 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %4)
	ret void
}

define void @console_vfprint(%Int %fd, %Str8* %form, i8* %va) {
	%1 = alloca [256 x i8], align 1
	%2 = bitcast [256 x i8]* %1 to [0 x i8]*
	%3 = call i32 @console_vsprint([0 x i8]* %2, %Str8* %form, i8* %va)
	%4 = getelementptr inbounds [256 x i8], [256 x i8]* %1, i32 0, i32 %3
	store i8 0, i8* %4
	%5 = bitcast [256 x i8]* %1 to i8*
	%6 = zext i32 %3 to %SizeT
	%7 = call %SSizeT @write(%Int %fd, i8* %5, %SizeT %6)
	ret void
}

define i32 @console_vsprint([0 x i8]* %buf, %Str8* %form, i8* %va) {
	%1 = alloca i32, align 4
	store i32 0, i32* %1
	%2 = alloca i32, align 4
	store i32 0, i32* %2
	br label %again_1
again_1:
	br i1 1 , label %body_1, label %break_1
body_1:
	%3 = alloca i8, align 1
	%4 = load i32, i32* %1
	%5 = getelementptr inbounds %Str8, %Str8* %form, i32 0, i32 %4
	%6 = load i8, i8* %5
	store i8 %6, i8* %3
	%7 = load i8, i8* %3
	%8 = icmp eq i8 %7, 0
	br i1 %8 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%10 = load i8, i8* %3
	%11 = icmp eq i8 %10, 92
	br i1 %11 , label %then_1, label %endif_1
then_1:
	%12 = load i32, i32* %1
	%13 = add i32 %12, 1
	%14 = getelementptr inbounds %Str8, %Str8* %form, i32 0, i32 %13
	%15 = load i8, i8* %14
	store i8 %15, i8* %3
	%16 = load i8, i8* %3
	%17 = icmp eq i8 %16, 123
	br i1 %17 , label %then_2, label %else_2
then_2:
	; "\{" -> "{"
	%18 = load i32, i32* %2
	%19 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %18
	%20 = load i8, i8* %3
	store i8 %20, i8* %19
	%21 = load i32, i32* %2
	%22 = add i32 %21, 1
	store i32 %22, i32* %2
	%23 = load i32, i32* %1
	%24 = add i32 %23, 2
	store i32 %24, i32* %1
	br label %again_1
	br label %endif_2
else_2:
	%26 = load i8, i8* %3
	%27 = icmp eq i8 %26, 125
	br i1 %27 , label %then_3, label %else_3
then_3:
	; "\}" -> "{"
	%28 = load i32, i32* %2
	%29 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %28
	%30 = load i8, i8* %3
	store i8 %30, i8* %29
	%31 = load i32, i32* %2
	%32 = add i32 %31, 1
	store i32 %32, i32* %2
	%33 = load i32, i32* %1
	%34 = add i32 %33, 2
	store i32 %34, i32* %1
	br label %again_1
	br label %endif_3
else_3:
	%36 = load i8, i8* %3
	%37 = icmp eq i8 %36, 92
	br i1 %37 , label %then_4, label %endif_4
then_4:
	%38 = load i32, i32* %2
	%39 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %38
	%40 = load i8, i8* %3
	store i8 %40, i8* %39
	%41 = load i32, i32* %2
	%42 = add i32 %41, 1
	store i32 %42, i32* %2
	%43 = load i32, i32* %1
	%44 = add i32 %43, 2
	store i32 %44, i32* %1
	br label %again_1
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	%46 = load i8, i8* %3
	%47 = icmp eq i8 %46, 123
	br i1 %47 , label %then_5, label %else_5
then_5:
	%48 = load i32, i32* %1
	%49 = add i32 %48, 1
	store i32 %49, i32* %1
	%50 = load i32, i32* %1
	%51 = getelementptr inbounds %Str8, %Str8* %form, i32 0, i32 %50
	%52 = load i8, i8* %51
	store i8 %52, i8* %3
	%53 = load i32, i32* %1
	%54 = add i32 %53, 1
	store i32 %54, i32* %1
	%55 = load i32, i32* %2
	%56 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %55
;
	%57 = bitcast i8* %56 to [0 x i8]*
	%58 = load i8, i8* %3
	%59 = icmp eq i8 %58, 105
	%60 = load i8, i8* %3
	%61 = icmp eq i8 %60, 100
	%62 = or i1 %59, %61
	br i1 %62 , label %then_6, label %else_6
then_6:
	;
	; %i & %d for signed integer (Int)
	;
	%63 = va_arg i8* %va, i32
	%64 = call i32 @sprint_dec_int32([0 x i8]* %57, i32 %63)
	%65 = load i32, i32* %2
	%66 = add i32 %65, %64
	store i32 %66, i32* %2
	br label %endif_6
else_6:
	%67 = load i8, i8* %3
	%68 = icmp eq i8 %67, 110
	br i1 %68 , label %then_7, label %else_7
then_7:
	;
	; %n for unsigned integer (Nat)
	;
	%69 = va_arg i8* %va, i32
	%70 = call i32 @sprint_n32([0 x i8]* %57, i32 %69)
	%71 = load i32, i32* %2
	%72 = add i32 %71, %70
	store i32 %72, i32* %2
	br label %endif_7
else_7:
	%73 = load i8, i8* %3
	%74 = icmp eq i8 %73, 120
	%75 = load i8, i8* %3
	%76 = icmp eq i8 %75, 112
	%77 = or i1 %74, %76
	br i1 %77 , label %then_8, label %else_8
then_8:
	;
	; %x for unsigned integer (Nat)
	; %p for pointers
	;
	%78 = va_arg i8* %va, i32
	%79 = call i32 @sprint_hex_nat32([0 x i8]* %57, i32 %78)
	%80 = load i32, i32* %2
	%81 = add i32 %80, %79
	store i32 %81, i32* %2
	br label %endif_8
else_8:
	%82 = load i8, i8* %3
	%83 = icmp eq i8 %82, 115
	br i1 %83 , label %then_9, label %else_9
then_9:
	;
	; %s pointer to string
	;
	%84 = va_arg i8* %va, %Str8*
	%85 = call [0 x %Char]* @strcpy([0 x i8]* %57, %Str8* %84)
	%86 = load i32, i32* %2
	%87 = call %SizeT @strlen(%Str8* %84)
	%88 = trunc %SizeT %87 to i32
	%89 = add i32 %86, %88
	store i32 %89, i32* %2
	br label %endif_9
else_9:
	%90 = load i8, i8* %3
	%91 = icmp eq i8 %90, 99
	br i1 %91 , label %then_10, label %endif_10
then_10:
	;
	; %c for char
	;
	%92 = va_arg i8* %va, i32
	%93 = load i32, i32* %2
	%94 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %93
;
	%95 = bitcast i8* %94 to [0 x i8]*
	%96 = bitcast [0 x i8]* %95 to [4 x i8]*
	%97 = call i8 @utf_utf32_to_utf8(i32 %92, [4 x i8]* %96)
	%98 = sext i8 %97 to i32
	%99 = load i32, i32* %2
	%100 = add i32 %99, %98
	store i32 %100, i32* %2
	br label %endif_10
endif_10:
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
else_5:
	%101 = load i32, i32* %2
	%102 = getelementptr inbounds [0 x i8], [0 x i8]* %buf, i32 0, i32 %101
	%103 = load i8, i8* %3
	store i8 %103, i8* %102
	%104 = load i32, i32* %2
	%105 = add i32 %104, 1
	store i32 %105, i32* %2
	br label %endif_5
endif_5:
	%106 = load i32, i32* %1
	%107 = add i32 %106, 1
	store i32 %107, i32* %1
	br label %again_1
break_1:
	%108 = load i32, i32* %2
	ret i32 %108
}



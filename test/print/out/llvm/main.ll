
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
%ctypes64_Str = type %Str8;
%ctypes64_Char = type %Char8;
%ctypes64_ConstChar = type %ctypes64_Char;
%ctypes64_SignedChar = type %Int8;
%ctypes64_UnsignedChar = type %Int8;
%ctypes64_Short = type %Int16;
%ctypes64_UnsignedShort = type %Int16;
%ctypes64_Int = type %Int32;
%ctypes64_UnsignedInt = type %Int32;
%ctypes64_LongInt = type %Int64;
%ctypes64_UnsignedLongInt = type %Int64;
%ctypes64_Long = type %Int64;
%ctypes64_UnsignedLong = type %Int64;
%ctypes64_LongLong = type %Int64;
%ctypes64_UnsignedLongLong = type %Int64;
%ctypes64_LongLongInt = type %Int64;
%ctypes64_UnsignedLongLongInt = type %Int64;
%ctypes64_Float = type double;
%ctypes64_Double = type double;
%ctypes64_LongDouble = type double;
%ctypes64_SizeT = type %ctypes64_UnsignedLongInt;
%ctypes64_SSizeT = type %ctypes64_LongInt;
%ctypes64_IntPtrT = type %Int64;
%ctypes64_PtrDiffT = type i8*;
%ctypes64_OffT = type %Int64;
%ctypes64_USecondsT = type %Int32;
%ctypes64_PIDT = type %Int32;
%ctypes64_UIDT = type %Int32;
%ctypes64_GIDT = type %Int32;
; -- end print includes --
; -- print imports 'main' --
; -- 1
; ?? console ??
; from included unistd
declare %ctypes64_Int @access([0 x %ctypes64_ConstChar]* %path, %ctypes64_Int %amode)
declare %ctypes64_UnsignedInt @alarm(%ctypes64_UnsignedInt %seconds)
declare %ctypes64_Int @brk(i8* %end_data_segment)
declare %ctypes64_Int @chdir([0 x %ctypes64_ConstChar]* %path)
declare %ctypes64_Int @chroot([0 x %ctypes64_ConstChar]* %path)
declare %ctypes64_Int @chown([0 x %ctypes64_ConstChar]* %pathname, %ctypes64_UIDT %owner, %ctypes64_GIDT %group)
declare %ctypes64_Int @close(%ctypes64_Int %fildes)
declare %ctypes64_SizeT @confstr(%ctypes64_Int %name, [0 x %ctypes64_Char]* %buf, %ctypes64_SizeT %len)
declare [0 x %ctypes64_Char]* @crypt([0 x %ctypes64_ConstChar]* %key, [0 x %ctypes64_ConstChar]* %salt)
declare [0 x %ctypes64_Char]* @ctermid([0 x %ctypes64_Char]* %s)
declare [0 x %ctypes64_Char]* @cuserid([0 x %ctypes64_Char]* %s)
declare %ctypes64_Int @dup(%ctypes64_Int %fildes)
declare %ctypes64_Int @dup2(%ctypes64_Int %fildes, %ctypes64_Int %fildes2)
declare void @encrypt([64 x %ctypes64_Char]* %block, %ctypes64_Int %edflag)
declare %ctypes64_Int @execl([0 x %ctypes64_ConstChar]* %path, [0 x %ctypes64_ConstChar]* %arg0, ...)
declare %ctypes64_Int @execle([0 x %ctypes64_ConstChar]* %path, [0 x %ctypes64_ConstChar]* %arg0, ...)
declare %ctypes64_Int @execlp([0 x %ctypes64_ConstChar]* %file, [0 x %ctypes64_ConstChar]* %arg0, ...)
declare %ctypes64_Int @execv([0 x %ctypes64_ConstChar]* %path, [0 x %ctypes64_ConstChar]* %argv)
declare %ctypes64_Int @execve([0 x %ctypes64_ConstChar]* %path, [0 x %ctypes64_ConstChar]* %argv, [0 x %ctypes64_ConstChar]* %envp)
declare %ctypes64_Int @execvp([0 x %ctypes64_ConstChar]* %file, [0 x %ctypes64_ConstChar]* %argv)
declare void @_exit(%ctypes64_Int %status)
declare %ctypes64_Int @fchown(%ctypes64_Int %fildes, %ctypes64_UIDT %owner, %ctypes64_GIDT %group)
declare %ctypes64_Int @fchdir(%ctypes64_Int %fildes)
declare %ctypes64_Int @fdatasync(%ctypes64_Int %fildes)
declare %ctypes64_PIDT @fork()
declare %ctypes64_LongInt @fpathconf(%ctypes64_Int %fildes, %ctypes64_Int %name)
declare %ctypes64_Int @fsync(%ctypes64_Int %fildes)
declare %ctypes64_Int @ftruncate(%ctypes64_Int %fildes, %ctypes64_OffT %length)
declare [0 x %ctypes64_Char]* @getcwd([0 x %ctypes64_Char]* %buf, %ctypes64_SizeT %size)
declare %ctypes64_Int @getdtablesize()
declare %ctypes64_GIDT @getegid()
declare %ctypes64_UIDT @geteuid()
declare %ctypes64_GIDT @getgid()
declare %ctypes64_Int @getgroups(%ctypes64_Int %gidsetsize, [0 x %ctypes64_GIDT]* %grouplist)
declare %ctypes64_Long @gethostid()
declare [0 x %ctypes64_Char]* @getlogin()
declare %ctypes64_Int @getlogin_r([0 x %ctypes64_Char]* %name, %ctypes64_SizeT %namesize)
declare %ctypes64_Int @getopt(%ctypes64_Int %argc, [0 x %ctypes64_ConstChar]* %argv, [0 x %ctypes64_ConstChar]* %optstring)
declare %ctypes64_Int @getpagesize()
declare [0 x %ctypes64_Char]* @getpass([0 x %ctypes64_ConstChar]* %prompt)
declare %ctypes64_PIDT @getpgid(%ctypes64_PIDT %pid)
declare %ctypes64_PIDT @getpgrp()
declare %ctypes64_PIDT @getpid()
declare %ctypes64_PIDT @getppid()
declare %ctypes64_PIDT @getsid(%ctypes64_PIDT %pid)
declare %ctypes64_UIDT @getuid()
declare [0 x %ctypes64_Char]* @getwd([0 x %ctypes64_Char]* %path_name)
declare %ctypes64_Int @isatty(%ctypes64_Int %fildes)
declare %ctypes64_Int @lchown([0 x %ctypes64_ConstChar]* %path, %ctypes64_UIDT %owner, %ctypes64_GIDT %group)
declare %ctypes64_Int @link([0 x %ctypes64_ConstChar]* %path1, [0 x %ctypes64_ConstChar]* %path2)
declare %ctypes64_Int @lockf(%ctypes64_Int %fildes, %ctypes64_Int %function, %ctypes64_OffT %size)
declare %ctypes64_OffT @lseek(%ctypes64_Int %fildes, %ctypes64_OffT %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @nice(%ctypes64_Int %incr)
declare %ctypes64_LongInt @pathconf([0 x %ctypes64_ConstChar]* %path, %ctypes64_Int %name)
declare %ctypes64_Int @pause()
declare %ctypes64_Int @pipe([2 x %ctypes64_Int]* %fildes)
declare %ctypes64_SSizeT @pread(%ctypes64_Int %fildes, i8* %buf, %ctypes64_SizeT %nbyte, %ctypes64_OffT %offset)
declare %ctypes64_Int @pthread_atfork(void ()* %prepare, void ()* %parent, void ()* %child)
declare %ctypes64_SSizeT @pwrite(%ctypes64_Int %fildes, i8* %buf, %ctypes64_SizeT %nbyte, %ctypes64_OffT %offset)
declare %ctypes64_SSizeT @read(%ctypes64_Int %fildes, i8* %buf, %ctypes64_SizeT %nbyte)
declare %ctypes64_Int @readlink([0 x %ctypes64_ConstChar]* %path, [0 x %ctypes64_Char]* %buf, %ctypes64_SizeT %bufsize)
declare %ctypes64_Int @rmdir([0 x %ctypes64_ConstChar]* %path)
declare i8* @sbrk(%ctypes64_IntPtrT %incr)
declare %ctypes64_Int @setgid(%ctypes64_GIDT %gid)
declare %ctypes64_Int @setpgid(%ctypes64_PIDT %pid, %ctypes64_PIDT %pgid)
declare %ctypes64_PIDT @setpgrp()
declare %ctypes64_Int @setregid(%ctypes64_GIDT %rgid, %ctypes64_GIDT %egid)
declare %ctypes64_Int @setreuid(%ctypes64_UIDT %ruid, %ctypes64_UIDT %euid)
declare %ctypes64_PIDT @setsid()
declare %ctypes64_Int @setuid(%ctypes64_UIDT %uid)
declare %ctypes64_UnsignedInt @sleep(%ctypes64_UnsignedInt %seconds)
declare void @swab(i8* %src, i8* %dst, %ctypes64_SSizeT %nbytes)
declare %ctypes64_Int @symlink([0 x %ctypes64_ConstChar]* %path1, [0 x %ctypes64_ConstChar]* %path2)
declare void @sync()
declare %ctypes64_LongInt @sysconf(%ctypes64_Int %name)
declare %ctypes64_PIDT @tcgetpgrp(%ctypes64_Int %fildes)
declare %ctypes64_Int @tcsetpgrp(%ctypes64_Int %fildes, %ctypes64_PIDT %pgid_id)
declare %ctypes64_Int @truncate([0 x %ctypes64_ConstChar]* %path, %ctypes64_OffT %length)
declare [0 x %ctypes64_Char]* @ttyname(%ctypes64_Int %fildes)
declare %ctypes64_Int @ttyname_r(%ctypes64_Int %fildes, [0 x %ctypes64_Char]* %name, %ctypes64_SizeT %namesize)
declare %ctypes64_USecondsT @ualarm(%ctypes64_USecondsT %useconds, %ctypes64_USecondsT %interval)
declare %ctypes64_Int @unlink([0 x %ctypes64_ConstChar]* %path)
declare %ctypes64_Int @usleep(%ctypes64_USecondsT %useconds)
declare %ctypes64_PIDT @vfork()
declare %ctypes64_SSizeT @write(%ctypes64_Int %fildes, i8* %buf, %ctypes64_SizeT %nbyte)
; from included stdio
%stdio_File = type %Int8;
%stdio_FposT = type %Int8;
%stdio_CharStr = type %ctypes64_Str;
%stdio_ConstCharStr = type %stdio_CharStr;
declare %ctypes64_Int @fclose(%stdio_File* %f)
declare %ctypes64_Int @feof(%stdio_File* %f)
declare %ctypes64_Int @ferror(%stdio_File* %f)
declare %ctypes64_Int @fflush(%stdio_File* %f)
declare %ctypes64_Int @fgetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %stdio_File* @fopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode)
declare %ctypes64_SizeT @fread(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %ctypes64_SizeT @fwrite(i8* %buf, %ctypes64_SizeT %size, %ctypes64_SizeT %count, %stdio_File* %f)
declare %stdio_File* @freopen(%stdio_ConstCharStr* %fname, %stdio_ConstCharStr* %mode, %stdio_File* %f)
declare %ctypes64_Int @fseek(%stdio_File* %f, %ctypes64_LongInt %offset, %ctypes64_Int %whence)
declare %ctypes64_Int @fsetpos(%stdio_File* %f, %stdio_FposT* %pos)
declare %ctypes64_LongInt @ftell(%stdio_File* %f)
declare %ctypes64_Int @remove(%stdio_ConstCharStr* %fname)
declare %ctypes64_Int @rename(%stdio_ConstCharStr* %old_filename, %stdio_ConstCharStr* %new_filename)
declare void @rewind(%stdio_File* %f)
declare void @setbuf(%stdio_File* %f, %stdio_CharStr* %buf)
declare %ctypes64_Int @setvbuf(%stdio_File* %f, %stdio_CharStr* %buf, %ctypes64_Int %mode, %ctypes64_SizeT %size)
declare %stdio_File* @tmpfile()
declare %stdio_CharStr* @tmpnam(%stdio_CharStr* %str)
declare %ctypes64_Int @printf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @scanf(%stdio_ConstCharStr* %s, ...)
declare %ctypes64_Int @fprintf(%stdio_File* %f, %ctypes64_Str* %format, ...)
declare %ctypes64_Int @fscanf(%stdio_File* %f, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sscanf(%stdio_ConstCharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @sprintf(%stdio_CharStr* %buf, %stdio_ConstCharStr* %format, ...)
declare %ctypes64_Int @vfprintf(%stdio_File* %f, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vprintf(%stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsprintf(%stdio_CharStr* %str, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @vsnprintf(%stdio_CharStr* %str, %ctypes64_SizeT %n, %stdio_ConstCharStr* %format, i8* %args)
declare %ctypes64_Int @__vsnprintf_chk(%stdio_CharStr* %dest, %ctypes64_SizeT %len, %ctypes64_Int %flags, %ctypes64_SizeT %dstlen, %stdio_ConstCharStr* %format, i8* %arg)
declare %ctypes64_Int @fgetc(%stdio_File* %f)
declare %ctypes64_Int @fputc(%ctypes64_Int %char, %stdio_File* %f)
declare %stdio_CharStr* @fgets(%stdio_CharStr* %str, %ctypes64_Int %n, %stdio_File* %f)
declare %ctypes64_Int @fputs(%stdio_ConstCharStr* %str, %stdio_File* %f)
declare %ctypes64_Int @getc(%stdio_File* %f)
declare %ctypes64_Int @getchar()
declare %stdio_CharStr* @gets(%stdio_CharStr* %str)
declare %ctypes64_Int @putc(%ctypes64_Int %char, %stdio_File* %f)
declare %ctypes64_Int @putchar(%ctypes64_Int %char)
declare %ctypes64_Int @puts(%stdio_ConstCharStr* %str)
declare %ctypes64_Int @ungetc(%ctypes64_Int %char, %stdio_File* %f)
declare void @perror(%stdio_ConstCharStr* %str)
; from included string
declare i8* @memset(i8* %mem, %ctypes64_Int %c, %ctypes64_SizeT %n)
declare i8* @memcpy(i8* %dst, i8* %src, %ctypes64_SizeT %len)
declare i8* @memmove(i8* %dst, i8* %src, %ctypes64_SizeT %n)
declare %ctypes64_Int @memcmp(i8* %p0, i8* %p1, %ctypes64_SizeT %num)
declare %ctypes64_Int @strncmp([0 x %ctypes64_ConstChar]* %s1, [0 x %ctypes64_ConstChar]* %s2, %ctypes64_SizeT %n)
declare %ctypes64_Int @strcmp([0 x %ctypes64_ConstChar]* %s1, [0 x %ctypes64_ConstChar]* %s2)
declare [0 x %ctypes64_Char]* @strcpy([0 x %ctypes64_Char]* %dst, [0 x %ctypes64_ConstChar]* %src)
declare %ctypes64_SizeT @strlen([0 x %ctypes64_ConstChar]* %s)
declare [0 x %ctypes64_Char]* @strcat([0 x %ctypes64_Char]* %s1, [0 x %ctypes64_ConstChar]* %s2)
declare [0 x %ctypes64_Char]* @strncat([0 x %ctypes64_Char]* %s1, [0 x %ctypes64_ConstChar]* %s2, %ctypes64_SizeT %n)
declare [0 x %ctypes64_Char]* @strerror(%ctypes64_Int %error)
; ?? utf ??
; from import
declare %Int8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf)
declare %Int8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result)
; end from import
; from import
declare void @console_putchar8(%Char8 %c)
declare void @console_putchar16(%Char16 %c)
declare void @console_putchar32(%Char32 %c)
declare void @console_putchar_utf8(%Char8 %c)
declare void @console_putchar_utf16(%Char16 %c)
declare void @console_putchar_utf32(%Char32 %c)
declare void @console_puts8(%Str8* %s)
declare void @console_puts16(%Str16* %s)
declare void @console_puts32(%Str32* %s)
declare void @console_print(%Str8* %form, ...)
declare %Int32 @console_vfprint(%Int32 %fd, %Str8* %form, i8* %va)
declare %Int32 @console_vsprint([0 x %Char8]* %buf, %Str8* %form, i8* %va)
; end from import
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [20 x i8] [i8 116, i8 101, i8 115, i8 116, i8 32, i8 99, i8 111, i8 110, i8 115, i8 111, i8 108, i8 101, i8 32, i8 112, i8 114, i8 105, i8 110, i8 116, i8 10, i8 0]
@str2 = private constant [4 x i8] [i8 72, i8 105, i8 33, i8 0]
@str3 = private constant [3 x i8] [i8 92, i8 10, i8 0]
@str4 = private constant [3 x i8] [i8 64, i8 10, i8 0]
@str5 = private constant [6 x i8] [i8 35, i8 65, i8 65, i8 35, i8 10, i8 0]
@str6 = private constant [7 x i8] [i8 240, i8 159, i8 142, i8 137, i8 65, i8 10, i8 0]
@str7 = private constant [64 x i8] [i8 208, i8 173, i8 209, i8 130, i8 208, i8 190, i8 32, i8 209, i8 129, i8 209, i8 130, i8 209, i8 128, i8 208, i8 190, i8 208, i8 186, i8 208, i8 176, i8 32, i8 208, i8 183, i8 208, i8 176, i8 208, i8 191, i8 208, i8 184, i8 209, i8 129, i8 208, i8 176, i8 208, i8 189, i8 208, i8 189, i8 208, i8 176, i8 209, i8 143, i8 32, i8 208, i8 186, i8 208, i8 184, i8 209, i8 128, i8 208, i8 184, i8 208, i8 187, i8 208, i8 187, i8 208, i8 184, i8 209, i8 134, i8 208, i8 181, i8 208, i8 185, i8 46, i8 10, i8 0]
@str8 = private constant [7 x i8] [i8 123, i8 123, i8 99, i8 125, i8 125, i8 10, i8 0]
@str9 = private constant [11 x i8] [i8 99, i8 32, i8 61, i8 32, i8 34, i8 123, i8 99, i8 125, i8 34, i8 10, i8 0]
@str10 = private constant [11 x i8] [i8 115, i8 32, i8 61, i8 32, i8 34, i8 123, i8 115, i8 125, i8 34, i8 10, i8 0]
@str11 = private constant [9 x i8] [i8 105, i8 32, i8 61, i8 32, i8 123, i8 105, i8 125, i8 10, i8 0]
@str12 = private constant [9 x i8] [i8 110, i8 32, i8 61, i8 32, i8 123, i8 110, i8 125, i8 10, i8 0]
@str13 = private constant [11 x i8] [i8 120, i8 32, i8 61, i8 32, i8 48, i8 120, i8 123, i8 120, i8 125, i8 10, i8 0]
; -- endstrings --
define %ctypes64_Int @main() {
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([20 x i8]* @str1 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([3 x i8]* @str3 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([3 x i8]* @str4 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([6 x i8]* @str5 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([7 x i8]* @str6 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([64 x i8]* @str7 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([7 x i8]* @str8 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([11 x i8]* @str9 to [0 x i8]*), %Char32 128000)
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([11 x i8]* @str10 to [0 x i8]*), %Str8* bitcast ([4 x i8]* @str2 to [0 x i8]*))
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([9 x i8]* @str11 to [0 x i8]*), %Int32 -1)
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([9 x i8]* @str12 to [0 x i8]*), %Int32 123)
	call void (%Str8*, ...) @console_print(%Str8* bitcast ([11 x i8]* @str13 to [0 x i8]*), %Int32 305419903)
	ret %ctypes64_Int 0
}



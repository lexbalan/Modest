
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
; -- end print includes --
; -- print imports 'console' --
; -- 1
; ?? utf ??
; from import
declare %Int8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %buf)
declare %Int8 @utf_utf16_to_utf32([0 x %Char16]* %c, %Char32* %result)
; end from import
; -- end print imports 'console' --
; -- strings --
; -- endstrings --

;$pragma do_not_include; for Int; for write(); for putchar(); for strlen, strcpy
define void @console_putchar8(%Char8 %c) {
	call void @console_putchar_utf8(%Char8 %c)
	ret void
}

define void @console_putchar16(%Char16 %c) {
	call void @console_putchar_utf16(%Char16 %c)
	ret void
}

define void @console_putchar32(%Char32 %c) {
	call void @console_putchar_utf32(%Char32 %c)
	ret void
}

define void @console_putchar_utf8(%Char8 %c) {
	%1 = sext %Char8 %c to %Int32
	%2 = call %ctypes64_Int @putchar(%Int32 %1)
	ret void
}

define void @console_putchar_utf16(%Char16 %c) {
	%1 = alloca [2 x %Char16], align 1
	%2 = getelementptr [2 x %Char16], [2 x %Char16]* %1, %Int32 0, %Int32 0
	store %Char16 %c, %Char16* %2
	%3 = getelementptr [2 x %Char16], [2 x %Char16]* %1, %Int32 0, %Int32 1
	store %Char16 0, %Char16* %3
	%4 = alloca %Char32, align 4
	%5 = bitcast [2 x %Char16]* %1 to [0 x %Char16]*
	%6 = call %Int8 @utf_utf16_to_utf32([0 x %Char16]* %5, %Char32* %4)
	%7 = load %Char32, %Char32* %4
	call void @console_putchar_utf32(%Char32 %7)
	ret void
}

define void @console_putchar_utf32(%Char32 %c) {
	%1 = alloca [4 x %Char8], align 1
	%2 = call %Int8 @utf_utf32_to_utf8(%Char32 %c, [4 x %Char8]* %1)
	%3 = sext %Int8 %2 to %Int32
	%4 = alloca %Int32, align 4
	store %Int32 0, %Int32* %4
	br label %again_1
again_1:
	%5 = load %Int32, %Int32* %4
	%6 = icmp slt %Int32 %5, %3
	br %Bool %6 , label %body_1, label %break_1
body_1:
	%7 = load %Int32, %Int32* %4
	%8 = getelementptr [4 x %Char8], [4 x %Char8]* %1, %Int32 0, %Int32 %7
	%9 = load %Char8, %Char8* %8
	call void @console_putchar_utf8(%Char8 %9)
	%10 = load %Int32, %Int32* %4
	%11 = add %Int32 %10, 1
	store %Int32 %11, %Int32* %4
	br label %again_1
break_1:
	ret void
}



;
; puts
;


;
;// проблема тк puts уже определен в include ^^
;public func puts(s: *Str8) -> Unit {
;	puts8(s)
;}
;
define void @console_puts8(%Str8* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str8, %Str8* %s, %Int32 0, %Int32 %2
	%4 = load %Char8, %Char8* %3
	%5 = icmp eq %Char8 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf8(%Char8 %4)
	%7 = load %Int32, %Int32* %1
	%8 = add %Int32 %7, 1
	store %Int32 %8, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts16(%Str16* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	; нельзя просто так взять и вызвать putchar_utf16
	; тк в строке может быть суррогатная пара UTF_16 символов
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str16, %Str16* %s, %Int32 0, %Int32 %2
	%4 = load %Char16, %Char16* %3
	%5 = icmp eq %Char16 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%7 = alloca %Char32, align 4
	%8 = load %Int32, %Int32* %1
	%9 = getelementptr %Str16, %Str16* %s, %Int32 0, %Int32 %8
	%10 = bitcast %Char16* %9 to [0 x %Char16]*
	%11 = call %Int8 @utf_utf16_to_utf32([0 x %Char16]* %10, %Char32* %7)
	%12 = icmp eq %Int8 %11, 0
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	%14 = load %Char32, %Char32* %7
	call void @console_putchar_utf32(%Char32 %14)
	%15 = sext %Int8 %11 to %Int32
	%16 = load %Int32, %Int32* %1
	%17 = add %Int32 %16, %15
	store %Int32 %17, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_puts32(%Str32* %s) {
	%1 = alloca %Int32, align 4
	store %Int32 0, %Int32* %1
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%2 = load %Int32, %Int32* %1
	%3 = getelementptr %Str32, %Str32* %s, %Int32 0, %Int32 %2
	%4 = load %Char32, %Char32* %3
	%5 = icmp eq %Char32 %4, 0
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	call void @console_putchar_utf32(%Char32 %4)
	%7 = load %Int32, %Int32* %1
	%8 = add %Int32 %7, 1
	store %Int32 %8, %Int32* %1
	br label %again_1
break_1:
	ret void
}

define void @console_print(%Str8* %form, ...) {
	%1 = alloca i8*, align 1
	%2 = bitcast i8** %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = load i8*, i8** %1
	%4 = call %Int32 @console_vfprint(%Int32 1, %Str8* %form, i8* %3)
	%5 = bitcast i8** %1 to i8*
	call void @llvm.va_end(i8* %5)
	ret void
}

define %Int32 @console_vfprint(%Int32 %fd, %Str8* %form, i8* %va) {
	%1 = alloca i8*
	store i8* %va, i8** %1
	%2 = alloca [256 x %Char8], align 1
	%3 = bitcast [256 x %Char8]* %2 to [0 x %Char8]*
	%4 = load i8*, i8** %1
	%5 = call %Int32 @console_vsprint([0 x %Char8]* %3, %Str8* %form, i8* %4)
	%6 = getelementptr [256 x %Char8], [256 x %Char8]* %2, %Int32 0, %Int32 %5
	store %Char8 0, %Char8* %6
	%7 = bitcast [256 x %Char8]* %2 to i8*
	%8 = zext %Int32 %5 to %ctypes64_SizeT
	%9 = call %ctypes64_SSizeT @write(%Int32 %fd, i8* %7, %ctypes64_SizeT %8)
	ret %Int32 %5
}

define %Int32 @console_vsprint([0 x %Char8]* %buf, %Str8* %form, i8* %va) {
	%1 = alloca i8*
	store i8* %va, i8** %1
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = alloca %Char8, align 1
	%5 = load %Int32, %Int32* %2
	%6 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %5
	%7 = load %Char8, %Char8* %6
	store %Char8 %7, %Char8* %4
	%8 = load %Char8, %Char8* %4
	%9 = icmp eq %Char8 %8, 0
	br %Bool %9 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	%11 = load %Char8, %Char8* %4
	%12 = icmp ne %Char8 %11, 123
	br %Bool %12 , label %then_1, label %endif_1
then_1:
	%13 = load %Char8, %Char8* %4
	%14 = icmp eq %Char8 %13, 125
	br %Bool %14 , label %then_2, label %endif_2
then_2:
	%15 = load %Int32, %Int32* %2
	%16 = add %Int32 %15, 1
	store %Int32 %16, %Int32* %2
	%17 = load %Int32, %Int32* %2
	%18 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %17
	%19 = load %Char8, %Char8* %18
	store %Char8 %19, %Char8* %4
	%20 = load %Char8, %Char8* %4
	%21 = icmp eq %Char8 %20, 125
	br %Bool %21 , label %then_3, label %endif_3
then_3:
	%22 = load %Int32, %Int32* %3
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Char8, %Char8* %4
	store %Char8 %24, %Char8* %23
	%25 = load %Int32, %Int32* %3
	%26 = add %Int32 %25, 1
	store %Int32 %26, %Int32* %3
	%27 = load %Int32, %Int32* %2
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %2
	br label %endif_3
endif_3:
	br label %again_1
	br label %endif_2
endif_2:
	%30 = load %Int32, %Int32* %3
	%31 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %30
	%32 = load %Char8, %Char8* %4
	store %Char8 %32, %Char8* %31
	%33 = load %Int32, %Int32* %3
	%34 = add %Int32 %33, 1
	store %Int32 %34, %Int32* %3
	%35 = load %Int32, %Int32* %2
	%36 = add %Int32 %35, 1
	store %Int32 %36, %Int32* %2
	br label %again_1
	br label %endif_1
endif_1:

	; c == '{'
	%38 = load %Int32, %Int32* %2
	%39 = add %Int32 %38, 1
	store %Int32 %39, %Int32* %2
	%40 = load %Int32, %Int32* %2
	%41 = getelementptr %Str8, %Str8* %form, %Int32 0, %Int32 %40
	%42 = load %Char8, %Char8* %41
	store %Char8 %42, %Char8* %4
	%43 = load %Char8, %Char8* %4
	%44 = icmp eq %Char8 %43, 123
	br %Bool %44 , label %then_4, label %endif_4
then_4:
	%45 = load %Int32, %Int32* %3
	%46 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %45
	store %Char8 123, %Char8* %46
	%47 = load %Int32, %Int32* %3
	%48 = add %Int32 %47, 1
	store %Int32 %48, %Int32* %3
	%49 = load %Int32, %Int32* %2
	%50 = add %Int32 %49, 1
	store %Int32 %50, %Int32* %2
	br label %again_1
	br label %endif_4
endif_4:
	%52 = load %Int32, %Int32* %2
	%53 = add %Int32 %52, 2
	store %Int32 %53, %Int32* %2
	%54 = load %Int32, %Int32* %3
	%55 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %54
;
	%56 = bitcast %Char8* %55 to [0 x %Char8]*
	%57 = load %Char8, %Char8* %4
	%58 = icmp eq %Char8 %57, 105
	%59 = load %Char8, %Char8* %4
	%60 = icmp eq %Char8 %59, 100
	%61 = or %Bool %58, %60
	br %Bool %61 , label %then_5, label %else_5
then_5:
	;
	; %i & %d for signed integer (Int)
	;
	%62 = va_arg i8** %1, %Int32
	%63 = call %Int32 @sprint_dec_int32([0 x %Char8]* %56, %Int32 %62)
	%64 = load %Int32, %Int32* %3
	%65 = add %Int32 %64, %63
	store %Int32 %65, %Int32* %3
	br label %endif_5
else_5:
	%66 = load %Char8, %Char8* %4
	%67 = icmp eq %Char8 %66, 110
	br %Bool %67 , label %then_6, label %else_6
then_6:
	;
	; %n for unsigned integer (Nat)
	;
	%68 = va_arg i8** %1, %Int32
	%69 = call %Int32 @sprint_dec_n32([0 x %Char8]* %56, %Int32 %68)
	%70 = load %Int32, %Int32* %3
	%71 = add %Int32 %70, %69
	store %Int32 %71, %Int32* %3
	br label %endif_6
else_6:
	%72 = load %Char8, %Char8* %4
	%73 = icmp eq %Char8 %72, 120
	%74 = load %Char8, %Char8* %4
	%75 = icmp eq %Char8 %74, 112
	%76 = or %Bool %73, %75
	br %Bool %76 , label %then_7, label %else_7
then_7:
	;
	; %x for unsigned integer (Nat)
	; %p for pointers
	;
	%77 = va_arg i8** %1, %Int32
	%78 = call %Int32 @sprint_hex_nat32([0 x %Char8]* %56, %Int32 %77)
	%79 = load %Int32, %Int32* %3
	%80 = add %Int32 %79, %78
	store %Int32 %80, %Int32* %3
	br label %endif_7
else_7:
	%81 = load %Char8, %Char8* %4
	%82 = icmp eq %Char8 %81, 115
	br %Bool %82 , label %then_8, label %else_8
then_8:
	;
	; %s pointer to string
	;
	%83 = va_arg i8** %1, %Str8*
	%84 = call [0 x %ctypes64_Char]* @strcpy([0 x %Char8]* %56, %Str8* %83)
	%85 = call %ctypes64_SizeT @strlen(%Str8* %83)
	%86 = trunc %ctypes64_SizeT %85 to %Int32
	%87 = load %Int32, %Int32* %3
	%88 = add %Int32 %87, %86
	store %Int32 %88, %Int32* %3
	br label %endif_8
else_8:
	%89 = load %Char8, %Char8* %4
	%90 = icmp eq %Char8 %89, 99
	br %Bool %90 , label %then_9, label %endif_9
then_9:
	;
	; %c for char
	;
	%91 = va_arg i8** %1, %Char32
	%92 = mul i8 4, 1  ; calc VLA item size
; -- CONS PTR TO ARRAY --
	%93 = bitcast [0 x %Char8]* %56 to [4 x %Char8]*
	%94 = call %Int8 @utf_utf32_to_utf8(%Char32 %91, [4 x %Char8]* %93)
	%95 = sext %Int8 %94 to %Int32
	%96 = load %Int32, %Int32* %3
	%97 = add %Int32 %96, %95
	store %Int32 %97, %Int32* %3
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %again_1
break_1:
	%98 = load %Int32, %Int32* %3
	ret %Int32 %98
}

define internal %Char8 @n_to_dec_sym(%Int8 %n) {
	%1 = add %Int8 48, %n
	%2 = bitcast %Int8 %1 to %Char8
	ret %Char8 %2
}

define internal %Char8 @n_to_hex_sym(%Int8 %n) {
	%1 = icmp ult %Int8 %n, 10
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = call %Char8 @n_to_dec_sym(%Int8 %n)
	ret %Char8 %2
	br label %endif_0
endif_0:
	%4 = sub %Int8 %n, 10
	%5 = add %Int8 65, %4
	%6 = bitcast %Int8 %5 to %Char8
	ret %Char8 %6
}

define internal %Int32 @sprint_hex_nat32([0 x %Char8]* %buf, %Int32 %x) {
	%1 = alloca [8 x %Char8], align 1
	%2 = alloca %Int32, align 4
	store %Int32 %x, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %2
	%5 = urem %Int32 %4, 16
	%6 = load %Int32, %Int32* %2
	%7 = udiv %Int32 %6, 16
	store %Int32 %7, %Int32* %2
	%8 = load %Int32, %Int32* %3
	%9 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Int32 %8
	%10 = trunc %Int32 %5 to %Int8
	%11 = call %Char8 @n_to_hex_sym(%Int8 %10)
	store %Char8 %11, %Char8* %9
	%12 = load %Int32, %Int32* %3
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %3
	%14 = load %Int32, %Int32* %2
	%15 = icmp eq %Int32 %14, 0
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:

	; mirroring into buffer
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %3
	%19 = icmp sgt %Int32 %18, 0
	br %Bool %19 , label %body_2, label %break_2
body_2:
	%20 = load %Int32, %Int32* %3
	%21 = sub %Int32 %20, 1
	store %Int32 %21, %Int32* %3
	%22 = load %Int32, %Int32* %17
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Int32, %Int32* %3
	%25 = getelementptr [8 x %Char8], [8 x %Char8]* %1, %Int32 0, %Int32 %24
	%26 = load %Char8, %Char8* %25
	store %Char8 %26, %Char8* %23
	%27 = load %Int32, %Int32* %17
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %17
	br label %again_2
break_2:
	%29 = load %Int32, %Int32* %17
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	store %Char8 0, %Char8* %30
	%31 = load %Int32, %Int32* %17
	ret %Int32 %31
}

define internal %Int32 @sprint_dec_int32([0 x %Char8]* %buf, %Int32 %x) {
	%1 = alloca [11 x %Char8], align 1
	%2 = alloca %Int32, align 4
	store %Int32 %x, %Int32* %2
	%3 = load %Int32, %Int32* %2
	%4 = icmp slt %Int32 %3, 0
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = load %Int32, %Int32* %2
	%6 = sub %Int32 0, %5
	store %Int32 %6, %Int32* %2
	br label %endif_0
endif_0:
	%7 = alloca %Int32, align 4
	store %Int32 0, %Int32* %7
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%8 = load %Int32, %Int32* %2
	%9 = srem %Int32 %8, 10
	%10 = load %Int32, %Int32* %2
	%11 = sdiv %Int32 %10, 10
	store %Int32 %11, %Int32* %2
	%12 = load %Int32, %Int32* %7
	%13 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %12
	%14 = trunc %Int32 %9 to %Int8
	%15 = call %Char8 @n_to_dec_sym(%Int8 %14)
	store %Char8 %15, %Char8* %13
	%16 = load %Int32, %Int32* %7
	%17 = add %Int32 %16, 1
	store %Int32 %17, %Int32* %7
	%18 = load %Int32, %Int32* %2
	%19 = icmp eq %Int32 %18, 0
	br %Bool %19 , label %then_1, label %endif_1
then_1:
	br label %break_1
	br label %endif_1
endif_1:
	br label %again_1
break_1:
	%21 = alloca %Int32, align 4
	store %Int32 0, %Int32* %21
	br %Bool %4 , label %then_2, label %endif_2
then_2:
	%22 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 0
	store %Char8 45, %Char8* %22
	%23 = load %Int32, %Int32* %21
	%24 = add %Int32 %23, 1
	store %Int32 %24, %Int32* %21
	br label %endif_2
endif_2:
	br label %again_2
again_2:
	%25 = load %Int32, %Int32* %7
	%26 = icmp sgt %Int32 %25, 0
	br %Bool %26 , label %body_2, label %break_2
body_2:
	%27 = load %Int32, %Int32* %7
	%28 = sub %Int32 %27, 1
	store %Int32 %28, %Int32* %7
	%29 = load %Int32, %Int32* %21
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	%31 = load %Int32, %Int32* %7
	%32 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %31
	%33 = load %Char8, %Char8* %32
	store %Char8 %33, %Char8* %30
	%34 = load %Int32, %Int32* %21
	%35 = add %Int32 %34, 1
	store %Int32 %35, %Int32* %21
	br label %again_2
break_2:
	%36 = load %Int32, %Int32* %21
	%37 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %36
	store %Char8 0, %Char8* %37
	%38 = load %Int32, %Int32* %21
	ret %Int32 %38
}

define internal %Int32 @sprint_dec_n32([0 x %Char8]* %buf, %Int32 %x) {
	%1 = alloca [11 x %Char8], align 1
	%2 = alloca %Int32, align 4
	store %Int32 %x, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
	br label %again_1
again_1:
	br %Bool 1 , label %body_1, label %break_1
body_1:
	%4 = load %Int32, %Int32* %2
	%5 = urem %Int32 %4, 10
	%6 = load %Int32, %Int32* %2
	%7 = udiv %Int32 %6, 10
	store %Int32 %7, %Int32* %2
	%8 = load %Int32, %Int32* %3
	%9 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %8
	%10 = trunc %Int32 %5 to %Int8
	%11 = call %Char8 @n_to_dec_sym(%Int8 %10)
	store %Char8 %11, %Char8* %9
	%12 = load %Int32, %Int32* %3
	%13 = add %Int32 %12, 1
	store %Int32 %13, %Int32* %3
	%14 = load %Int32, %Int32* %2
	%15 = icmp eq %Int32 %14, 0
	br %Bool %15 , label %then_0, label %endif_0
then_0:
	br label %break_1
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	%17 = alloca %Int32, align 4
	store %Int32 0, %Int32* %17
	br label %again_2
again_2:
	%18 = load %Int32, %Int32* %3
	%19 = icmp sgt %Int32 %18, 0
	br %Bool %19 , label %body_2, label %break_2
body_2:
	%20 = load %Int32, %Int32* %3
	%21 = sub %Int32 %20, 1
	store %Int32 %21, %Int32* %3
	%22 = load %Int32, %Int32* %17
	%23 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %22
	%24 = load %Int32, %Int32* %3
	%25 = getelementptr [11 x %Char8], [11 x %Char8]* %1, %Int32 0, %Int32 %24
	%26 = load %Char8, %Char8* %25
	store %Char8 %26, %Char8* %23
	%27 = load %Int32, %Int32* %17
	%28 = add %Int32 %27, 1
	store %Int32 %28, %Int32* %17
	br label %again_2
break_2:
	%29 = load %Int32, %Int32* %17
	%30 = getelementptr [0 x %Char8], [0 x %Char8]* %buf, %Int32 0, %Int32 %29
	store %Char8 0, %Char8* %30
	%31 = load %Int32, %Int32* %17
	ret %Int32 %31
}



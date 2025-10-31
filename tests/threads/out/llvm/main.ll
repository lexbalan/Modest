
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
%UnsignedChar = type %Int8;
%Short = type %Int16;
%UnsignedShort = type %Int16;
%Int = type %Int32;
%UnsignedInt = type %Int32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Int64;
%Long = type %Int64;
%UnsignedLong = type %Int64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Int64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Int64;
%Float = type double;
%Double = type double;
%LongDouble = type double;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Int64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Int32;
%PIDT = type %Int32;
%UIDT = type %Int32;
%GIDT = type %Int32;
; from included stdio
%File = type %Int8;
%FposT = type %Int8;
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
; -- end print includes --
; -- print imports 'main' --
; -- 1
; ?? pthread ??
; from import
%PThread = type {
};

%PThreadT = type i8*;
%PThreadMutexT = type i8*;
%PThreadAttr = type i8*;
%PThreadAttrT = type i8*;
%PThreadMutexAttrT = type i8*;
%PThreadCondT = type i8*;
%PThreadCondAttrT = type i8*;
%PThreadKeyT = type %Int;
%PThreadOnceT = type i8*;
%PThreadRWLockT = type i8*;
%PThreadRWLockAttrT = type i8*;
%PThreadBarrierT = type i8*;
%PThreadBarrierAttrT = type i8*;
%PThreadSpinlockT = type i8*;
declare %Int @pthread_atfork(void ()* %prepare, void ()* %parent, void ()* %child)
declare %Int @pthread_attr_destroy(PThreadAttrT* %a)
declare %Int @pthread_attr_getstack(PThreadAttrT* %a, i8** %p, %SizeT* %ps)
declare %Int @pthread_attr_getstacksize(PThreadAttrT* %a, %SizeT* %ps)
declare %Int @pthread_attr_getstackaddr(PThreadAttrT* %a, i8** %p)
declare %Int @pthread_attr_getguardsize(PThreadAttrT* %a, %SizeT* %ps)
declare %Int @pthread_attr_getdetachstate(PThreadAttrT* %a, %Int* %i)
declare %Int @pthread_attr_init(PThreadAttrT* %a)
declare %Int @pthread_attr_setstacksize(PThreadAttrT* %a, %SizeT %s)
declare %Int @pthread_attr_setstack(PThreadAttrT* %a, i8* %p, %SizeT %s)
declare %Int @pthread_attr_setstackaddr(PThreadAttrT* %a, i8* %p)
declare %Int @pthread_attr_setguardsize(PThreadAttrT* %a, %SizeT %s)
declare %Int @pthread_attr_setdetachstate(PThreadAttrT* %a, %Int %i)
declare void @pthread_cleanup_pop(%Int %x)
declare void @pthread_cleanup_push(void (i8*)* %f, i8* %arg)
declare %Int @pthread_condattr_destroy(PThreadCondAttrT* %ca)
declare %Int @pthread_condattr_init(PThreadCondAttrT* %ca)
declare %Int @pthread_cond_broadcast(PThreadCondT* %c)
declare %Int @pthread_cond_destroy(PThreadCondT* %c)
declare %Int @pthread_cond_init(PThreadCondT* %c, PThreadCondAttrT* %ca)
declare %Int @pthread_cond_signal(PThreadCondT* %c)
declare %Int @pthread_cond_timedwait(PThreadCondT* %c, PThreadMutexT* %m, %StructTimespec* %ts)
declare %Int @pthread_cond_wait(PThreadCondT* %c, PThreadMutexT* %m)
declare %Int @pthread_create(PThreadT* %p, PThreadAttrT* %a, i8* (i8*)* %t, i8* %p)
declare %Int @pthread_detach(PThreadT %t)
declare %Int @pthread_equal(PThreadT %t0, PThreadT %t1)
declare void @pthread_exit(i8* %p)
declare i8* @pthread_getspecific(%PThreadKeyT %k)
declare %Int @pthread_join(PThreadT %p, i8** %p)
declare %Int @pthread_key_create(%PThreadKeyT* %k, void (i8*)* %f)
declare %Int @pthread_key_delete(%PThreadKeyT %k)
declare %Int @pthread_kill(PThreadT %p, %Int %i)
declare %Int @pthread_mutexattr_init(PThreadMutexAttrT* %ma)
declare %Int @pthread_mutexattr_destroy(PThreadMutexAttrT* %ma)
declare %Int @pthread_mutexattr_gettype(PThreadMutexAttrT* %ma, %Int* %i)
declare %Int @pthread_mutexattr_settype(PThreadMutexAttrT* %ma, %Int %i)
declare %Int @pthread_mutex_destroy(PThreadMutexT* %m)
declare %Int @pthread_mutex_init(PThreadMutexT* %m, PThreadMutexAttrT* %ma)
declare %Int @pthread_mutex_lock(PThreadMutexT* %m)
declare %Int @pthread_mutex_timedlock(PThreadMutexT* %m, %StructTimespec* %ts)
declare %Int @pthread_mutex_trylock(PThreadMutexT* %m)
declare %Int @pthread_mutex_unlock(PThreadMutexT* %m)
declare %Int @pthread_once(PThreadOnceT* %once, void ()* %f)
declare %Int @pthread_rwlock_destroy(PThreadRWLockT* %lock)
declare %Int @pthread_rwlock_init(PThreadRWLockT* %lock, PThreadRWLockAttrT* %la)
declare %Int @pthread_rwlock_rdlock(PThreadRWLockT* %lock)
declare %Int @pthread_rwlock_timedrdlock(PThreadRWLockT* %lock, %StructTimespec* %ts)
declare %Int @pthread_rwlock_timedwrlock(PThreadRWLockT* %lock, %StructTimespec* %ts)
declare %Int @pthread_rwlock_tryrdlock(PThreadRWLockT* %lock)
declare %Int @pthread_rwlock_trywrlock(PThreadRWLockT* %lock)
declare %Int @pthread_rwlock_unlock(PThreadRWLockT* %lock)
declare %Int @pthread_rwlock_wrlock(PThreadRWLockT* %lock)
declare %Int @pthread_rwlockattr_init(PThreadRWLockAttrT* %la)
declare %Int @pthread_rwlockattr_getpshared(PThreadRWLockAttrT* %la, %Int* %i)
declare %Int @pthread_rwlockattr_setpshared(PThreadRWLockAttrT* %la, %Int %i)
declare %Int @pthread_rwlockattr_destroy(PThreadRWLockAttrT* %la)
declare PThreadT @pthread_self()
declare %Int @pthread_setspecific(%PThreadKeyT %k, i8* %p)
declare %Int @pthread_cancel(PThreadT %p)
declare %Int @pthread_setcancelstate(%Int %a, %Int* %i)
declare %Int @pthread_setcanceltype(%Int %a, %Int* %i)
declare void @pthread_testcancel()
declare %Int @pthread_getprio(PThreadT %p)
declare %Int @pthread_setprio(PThreadT %p, %Int %prio)
declare void @pthread_yield()
declare %Int @pthread_mutexattr_getprioceiling(PThreadMutexAttrT* %ma, %Int* %i)
declare %Int @pthread_mutexattr_setprioceiling(PThreadMutexAttrT* %ma, %Int %i)
declare %Int @pthread_mutex_getprioceiling(PThreadMutexT* %m, %Int* %i)
declare %Int @pthread_mutex_setprioceiling(PThreadMutexT* %m, %Int %i, %Int* %i)
declare %Int @pthread_mutexattr_getprotocol(PThreadMutexAttrT* %ma, %Int* %i)
declare %Int @pthread_mutexattr_setprotocol(PThreadMutexAttrT* %ma, %Int %i)
declare %Int @pthread_condattr_getclock(PThreadCondAttrT* %ca, %ClockIdT* %c)
declare %Int @pthread_condattr_setclock(PThreadCondAttrT* %ca, %ClockIdT %cid)
declare %Int @pthread_attr_getinheritsched(PThreadAttrT* %a, %Int* %i)
declare %Int @pthread_attr_getschedparam(PThreadAttrT* %a, %StructSchedParam* %s)
declare %Int @pthread_attr_getschedpolicy(PThreadAttrT* %a, %Int* %i)
declare %Int @pthread_attr_getscope(PThreadAttrT* %a, %Int* %i)
declare %Int @pthread_attr_setinheritsched(PThreadAttrT* %a, %Int %i)
declare %Int @pthread_attr_setschedparam(PThreadAttrT* %a, %StructSchedParam* %s)
declare %Int @pthread_attr_setschedpolicy(PThreadAttrT* %a, %Int %i)
declare %Int @pthread_attr_setscope(PThreadAttrT* %a, %Int %i)
declare %Int @pthread_getschedparam(PThreadT %p, %Int* %i, %StructSchedParam* %s)
declare %Int @pthread_setschedparam(PThreadT %p, %Int %i, %StructSchedParam* %s)
declare %Int @pthread_getconcurrency()
declare %Int @pthread_setconcurrency(%Int %c)
declare %Int @pthread_barrier_init(PThreadBarrierT* %b, PThreadBarrierAttrT* %ba, %Nat %n)
declare %Int @pthread_barrier_destroy(PThreadBarrierT* %b)
declare %Int @pthread_barrier_wait(PThreadBarrierT* %b)
declare %Int @pthread_barrierattr_init(PThreadBarrierAttrT* %ba)
declare %Int @pthread_barrierattr_destroy(PThreadBarrierAttrT* %ba)
declare %Int @pthread_barrierattr_getpshared(PThreadBarrierAttrT* %ba, %Int* %i)
declare %Int @pthread_barrierattr_setpshared(PThreadBarrierAttrT* %ba, %Int %i)
declare %Int @pthread_spin_init(PThreadSpinlockT* %s, %Int %i)
declare %Int @pthread_spin_destroy(PThreadSpinlockT* %s)
declare %Int @pthread_spin_trylock(PThreadSpinlockT* %s)
declare %Int @pthread_spin_lock(PThreadSpinlockT* %s)
declare %Int @pthread_spin_unlock(PThreadSpinlockT* %s)
declare %Int @pthread_getcpuclockid(PThreadT %p, %ClockIdT* %c)
; end from import
; -- end print imports 'main' --
; -- strings --
@str1 = private constant [21 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 116, i8 104, i8 114, i8 101, i8 97, i8 100, i8 32, i8 48, i8 10, i8 0]
@str2 = private constant [21 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 102, i8 114, i8 111, i8 109, i8 32, i8 116, i8 104, i8 114, i8 101, i8 97, i8 100, i8 32, i8 49, i8 10, i8 0]
@str3 = private constant [21 x i8] [i8 103, i8 108, i8 111, i8 98, i8 97, i8 108, i8 95, i8 99, i8 111, i8 117, i8 110, i8 116, i8 101, i8 114, i8 32, i8 61, i8 32, i8 37, i8 100, i8 10, i8 0]
@str4 = private constant [16 x i8] [i8 72, i8 101, i8 108, i8 108, i8 111, i8 32, i8 116, i8 104, i8 114, i8 101, i8 97, i8 100, i8 115, i8 33, i8 10, i8 0]
; -- endstrings --; tests/threads/src/main.m
; valgrind --leak-check=full ./easy.run
@mutex = internal global PThreadMutexT null
@global_counter = internal global %Int32 zeroinitializer
define internal i8* @thread0(i8* %param) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str1 to [0 x i8]*))
; while_1
	br label %again_1
again_1:
	%2 = load %Int32, %Int32* @global_counter
	%3 = icmp ult %Int32 %2, 32
	br %Bool %3 , label %body_1, label %break_1
body_1:
	; increment global counter
	%4 = call %Int @pthread_mutex_lock(PThreadMutexT* @mutex)
	%5 = load %Int32, %Int32* @global_counter
	%6 = add %Int32 %5, 1
	store %Int32 %6, %Int32* @global_counter
	%7 = call %Int @pthread_mutex_unlock(PThreadMutexT* @mutex)
	%8 = call %Int @usleep(%USecondsT 500000)
	br label %again_1
break_1:
	call void @pthread_exit(i8* null)
	ret i8* null
}

define internal i8* @thread1(i8* %param) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str2 to [0 x i8]*))
	%2 = alloca %Int32, align 4
	store %Int32 0, %Int32* %2
	%3 = alloca %Int32, align 4
	store %Int32 0, %Int32* %3
; while_1
	br label %again_1
again_1:
	%4 = load %Int32, %Int32* %2
	%5 = icmp ult %Int32 %4, 32
	br %Bool %5 , label %body_1, label %break_1
body_1:
	; fast read global counter
	%6 = call %Int @pthread_mutex_lock(PThreadMutexT* @mutex)
	%7 = load %Int32, %Int32* @global_counter
	store %Int32 %7, %Int32* %2
	%8 = call %Int @pthread_mutex_unlock(PThreadMutexT* @mutex)
; if_0
	%9 = load %Int32, %Int32* %3
	%10 = load %Int32, %Int32* %2
	%11 = icmp ne %Int32 %9, %10
	br %Bool %11 , label %then_0, label %endif_0
then_0:
	%12 = load %Int32, %Int32* %2
	store %Int32 %12, %Int32* %3
	%13 = load %Int32, %Int32* %2
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([21 x i8]* @str3 to [0 x i8]*), %Int32 %13)
	br label %endif_0
endif_0:
	br label %again_1
break_1:
	call void @pthread_exit(i8* null)
	ret i8* null
}

define %Int @main() {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str4 to [0 x i8]*))
	%2 = alloca %Int32, align 4
	%3 = alloca PThreadT, align 8
	%4 = alloca PThreadT, align 8
	%5 = call %Int @pthread_create(PThreadT* %3, PThreadAttrT* null, i8* (i8*)* @thread0, i8* null)
	store %Int %5, %Int32* %2
	%6 = call %Int @pthread_create(PThreadT* %4, PThreadAttrT* null, i8* (i8*)* @thread1, i8* null)
	store %Int %6, %Int32* %2

	;pthread.detach(pthread0)
	%7 = alloca i8*, align 8
	%8 = alloca i8*, align 8
	%9 = load PThreadT, PThreadT* %3
	%10 = call %Int @pthread_join(PThreadT %9, i8** %7)
	store %Int %10, %Int32* %2
	%11 = load PThreadT, PThreadT* %4
	%12 = call %Int @pthread_join(PThreadT %11, i8** %8)
	store %Int %12, %Int32* %2
	call void @pthread_exit(i8* null)
	ret %Int 0
}



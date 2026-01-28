// libc/unistd.m
// thx: https://pubs.opengroup.org/onlinepubs/7908799/xsh/unistd.h.html

pragma do_not_include
pragma module_nodecorate
pragma c_include "unistd.h"


include "libc/ctypes64"


//@extern("C)
//var environ: *[]*Char

@alias("c", "SEEK_SET")
public const c_SEEK_SET = 0
@alias("c", "SEEK_CUR")
public const c_SEEK_CUR = 1
@alias("c", "SEEK_END")
public const c_SEEK_END = 2

@alias("c", "STDIN_FILENO")
public const c_STDIN_FILENO = 0
@alias("c", "STDOUT_FILENO")
public const c_STDOUT_FILENO = 1
@alias("c", "STDERR_FILENO")
public const c_STDERR_FILENO = 2


// lockf function - record locking on files
@alias("c", "F_ULOCK")
public const c_F_ULOCK = 0  // unlock locked sections
@alias("c", "F_LOCK")
public const c_F_LOCK = 1   // lock a section for exclusive use
@alias("c", "F_TLOCK")
public const c_F_TLOCK = 2  // test and lock a section for exclusive use
@alias("c", "F_TEST")
public const c_F_TEST = 3

@alias("c", "F_OK")
public const c_F_OK = 0  // Test for existence of file
@alias("c", "R_OK")
public const c_R_OK = 4  // Test for read permission
@alias("c", "W_OK")
public const c_W_OK = 2  // Test for write permission
@alias("c", "X_OK")
public const c_X_OK = 1  // Test for execute (search) permission



/*
	 *  sysconf values per IEEE Std 1003.1, 2008 Edition
	 */
public const _unistd_SC_ARG_MAX = 0
public const _unistd_SC_CHILD_MAX = 1
public const _unistd_SC_CLK_TCK = 2
public const _unistd_SC_NGROUPS_MAX = 3
public const _unistd_SC_OPEN_MAX = 4
public const _unistd_SC_JOB_CONTROL = 5
public const _unistd_SC_SAVED_IDS = 6
public const _unistd_SC_VERSION = 7
public const _unistd_SC_PAGESIZE = 8
public const _unistd_SC_PAGE_SIZE = _unistd_SC_PAGESIZE
/* These are non-POSIX values we accidentally introduced in 2000 without
	   guarding them.  Keeping them unguarded for backward compatibility. */
public const _unistd_SC_NPROCESSORS_CONF = 9
public const _unistd_SC_NPROCESSORS_ONLN = 10
public const _unistd_SC_PHYS_PAGES = 11
public const _unistd_SC_AVPHYS_PAGES = 12
/* End of non-POSIX values. */
public const _unistd_SC_MQ_OPEN_MAX = 13
public const _unistd_SC_MQ_PRIO_MAX = 14
public const _unistd_SC_RTSIG_MAX = 15
public const _unistd_SC_SEM_NSEMS_MAX = 16
public const _unistd_SC_SEM_VALUE_MAX = 17
public const _unistd_SC_SIGQUEUE_MAX = 18
public const _unistd_SC_TIMER_MAX = 19
public const _unistd_SC_TZNAME_MAX = 20
public const _unistd_SC_ASYNCHRONOUS_IO = 21
public const _unistd_SC_FSYNC = 22
public const _unistd_SC_MAPPED_FILES = 23
public const _unistd_SC_MEMLOCK = 24
public const _unistd_SC_MEMLOCK_RANGE = 25
public const _unistd_SC_MEMORY_PROTECTION = 26
public const _unistd_SC_MESSAGE_PASSING = 27
public const _unistd_SC_PRIORITIZED_IO = 28
public const _unistd_SC_REALTIME_SIGNALS = 29
public const _unistd_SC_SEMAPHORES = 30
public const _unistd_SC_SHARED_MEMORY_OBJECTS = 31
public const _unistd_SC_SYNCHRONIZED_IO = 32
public const _unistd_SC_TIMERS = 33
public const _unistd_SC_AIO_LISTIO_MAX = 34
public const _unistd_SC_AIO_MAX = 35
public const _unistd_SC_AIO_PRIO_DELTA_MAX = 36
public const _unistd_SC_DELAYTIMER_MAX = 37
public const _unistd_SC_THREAD_KEYS_MAX = 38
public const _unistd_SC_THREAD_STACK_MIN = 39
public const _unistd_SC_THREAD_THREADS_MAX = 40
public const _unistd_SC_TTY_NAME_MAX = 41
public const _unistd_SC_THREADS = 42
public const _unistd_SC_THREAD_ATTR_STACKADDR = 43
public const _unistd_SC_THREAD_ATTR_STACKSIZE = 44
public const _unistd_SC_THREAD_PRIORITY_SCHEDULING = 45
public const _unistd_SC_THREAD_PRIO_INHERIT = 46
/* _unistd_SC_THREAD_PRIO_PROTECT was _unistd_SC_THREAD_PRIO_CEILING in early drafts */
public const _unistd_SC_THREAD_PRIO_PROTECT = 47
public const _unistd_SC_THREAD_PRIO_CEILING = _unistd_SC_THREAD_PRIO_PROTECT
public const _unistd_SC_THREAD_PROCESS_SHARED = 48
public const _unistd_SC_THREAD_SAFE_FUNCTIONS = 49
public const _unistd_SC_GETGR_R_SIZE_MAX = 50
public const _unistd_SC_GETPW_R_SIZE_MAX = 51
public const _unistd_SC_LOGIN_NAME_MAX = 52
public const _unistd_SC_THREAD_DESTRUCTOR_ITERATIONS = 53
public const _unistd_SC_ADVISORY_INFO = 54
public const _unistd_SC_ATEXIT_MAX = 55
public const _unistd_SC_BARRIERS = 56
public const _unistd_SC_BC_BASE_MAX = 57
public const _unistd_SC_BC_DIM_MAX = 58
public const _unistd_SC_BC_SCALE_MAX = 59
public const _unistd_SC_BC_STRING_MAX = 60
public const _unistd_SC_CLOCK_SELECTION = 61
public const _unistd_SC_COLL_WEIGHTS_MAX = 62
public const _unistd_SC_CPUTIME = 63
public const _unistd_SC_EXPR_NEST_MAX = 64
public const _unistd_SC_HOST_NAME_MAX = 65
public const _unistd_SC_IOV_MAX = 66
public const _unistd_SC_IPV6 = 67
public const _unistd_SC_LINE_MAX = 68
public const _unistd_SC_MONOTONIC_CLOCK = 69
public const _unistd_SC_RAW_SOCKETS = 70
public const _unistd_SC_READER_WRITER_LOCKS = 71
public const _unistd_SC_REGEXP = 72
public const _unistd_SC_RE_DUP_MAX = 73
public const _unistd_SC_SHELL = 74
public const _unistd_SC_SPAWN = 75
public const _unistd_SC_SPIN_LOCKS = 76
public const _unistd_SC_SPORADIC_SERVER = 77
public const _unistd_SC_SS_REPL_MAX = 78
public const _unistd_SC_SYMLOOP_MAX = 79
public const _unistd_SC_THREAD_CPUTIME = 80
public const _unistd_SC_THREAD_SPORADIC_SERVER = 81
public const _unistd_SC_TIMEOUTS = 82
public const _unistd_SC_TRACE = 83
public const _unistd_SC_TRACE_EVENT_FILTER = 84
public const _unistd_SC_TRACE_EVENT_NAME_MAX = 85
public const _unistd_SC_TRACE_INHERIT = 86
public const _unistd_SC_TRACE_LOG = 87
public const _unistd_SC_TRACE_NAME_MAX = 88
public const _unistd_SC_TRACE_SYS_MAX = 89
public const _unistd_SC_TRACE_USER_EVENT_MAX = 90
public const _unistd_SC_TYPED_MEMORY_OBJECTS = 91
public const _unistd_SC_V7_ILP32_OFF32 = 92
public const _unistd_SC_V6_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
public const _unistd_SC_XBS5_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
public const _unistd_SC_V7_ILP32_OFFBIG = 93
public const _unistd_SC_V6_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
public const _unistd_SC_XBS5_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
public const _unistd_SC_V7_LP64_OFF64 = 94
public const _unistd_SC_V6_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
public const _unistd_SC_XBS5_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
public const _unistd_SC_V7_LPBIG_OFFBIG = 95
public const _unistd_SC_V6_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
public const _unistd_SC_XBS5_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
public const _unistd_SC_XOPEN_CRYPT = 96
public const _unistd_SC_XOPEN_ENH_I18N = 97
public const _unistd_SC_XOPEN_LEGACY = 98
public const _unistd_SC_XOPEN_REALTIME = 99
public const _unistd_SC_STREAM_MAX = 100
public const _unistd_SC_PRIORITY_SCHEDULING = 101
public const _unistd_SC_XOPEN_REALTIME_THREADS = 102
public const _unistd_SC_XOPEN_SHM = 103
public const _unistd_SC_XOPEN_STREAMS = 104
public const _unistd_SC_XOPEN_UNIX = 105
public const _unistd_SC_XOPEN_VERSION = 106
public const _unistd_SC_2_CHAR_TERM = 107
public const _unistd_SC_2_C_BIND = 108
public const _unistd_SC_2_C_DEV = 109
public const _unistd_SC_2_FORT_DEV = 110
public const _unistd_SC_2_FORT_RUN = 111
public const _unistd_SC_2_LOCALEDEF = 112
public const _unistd_SC_2_PBS = 113
public const _unistd_SC_2_PBS_ACCOUNTING = 114
public const _unistd_SC_2_PBS_CHECKPOINT = 115
public const _unistd_SC_2_PBS_LOCATE = 116
public const _unistd_SC_2_PBS_MESSAGE = 117
public const _unistd_SC_2_PBS_TRACK = 118
public const _unistd_SC_2_SW_DEV = 119
public const _unistd_SC_2_UPE = 120
public const _unistd_SC_2_VERSION = 121
public const _unistd_SC_THREAD_ROBUST_PRIO_INHERIT = 122
public const _unistd_SC_THREAD_ROBUST_PRIO_PROTECT = 123
public const _unistd_SC_XOPEN_UUCP = 124
public const _unistd_SC_LEVEL1_ICACHE_SIZE = 125
public const _unistd_SC_LEVEL1_ICACHE_ASSOC = 126
public const _unistd_SC_LEVEL1_ICACHE_LINESIZE = 127
public const _unistd_SC_LEVEL1_DCACHE_SIZE = 128
public const _unistd_SC_LEVEL1_DCACHE_ASSOC = 129
public const _unistd_SC_LEVEL1_DCACHE_LINESIZE = 130
public const _unistd_SC_LEVEL2_CACHE_SIZE = 131
public const _unistd_SC_LEVEL2_CACHE_ASSOC = 132
public const _unistd_SC_LEVEL2_CACHE_LINESIZE = 133
public const _unistd_SC_LEVEL3_CACHE_SIZE = 134
public const _unistd_SC_LEVEL3_CACHE_ASSOC = 135
public const _unistd_SC_LEVEL3_CACHE_LINESIZE = 136
public const _unistd_SC_LEVEL4_CACHE_SIZE = 137
public const _unistd_SC_LEVEL4_CACHE_ASSOC = 138
public const _unistd_SC_LEVEL4_CACHE_LINESIZE = 139
public const _unistd_SC_POSIX_26_VERSION = 140

/*
	 *  pathconf values per IEEE Std 1003.1, 2008 Edition
	 */
public const _unistd_PC_LINK_MAX = 0
public const _unistd_PC_MAX_CANON = 1
public const _unistd_PC_MAX_INPUT = 2
public const _unistd_PC_NAME_MAX = 3
public const _unistd_PC_PATH_MAX = 4
public const _unistd_PC_PIPE_BUF = 5
public const _unistd_PC_CHOWN_RESTRICTED = 6
public const _unistd_PC_NO_TRUNC = 7
public const _unistd_PC_VDISABLE = 8
public const _unistd_PC_ASYNC_IO = 9
public const _unistd_PC_PRIO_IO = 10
public const _unistd_PC_SYNC_IO = 11
public const _unistd_PC_FILESIZEBITS = 12
public const _unistd_PC_2_SYMLINKS = 13
public const _unistd_PC_SYMLINK_MAX = 14
public const _unistd_PC_ALLOC_SIZE_MIN = 15
public const _unistd_PC_REC_INCR_XFER_SIZE = 16
public const _unistd_PC_REC_MAX_XFER_SIZE = 17
public const _unistd_PC_REC_MIN_XFER_SIZE = 18
public const _unistd_PC_REC_XFER_ALIGN = 19
public const _unistd_PC_TIMESTAMP_RESOLUTION = 20

//$if defined("__CYGWIN__")
///* Ask for POSIX permission bits support. */
//const _unistd_PC_POSIX_PERMISSIONS = 90
///* Ask for full POSIX permission support including uid/gid settings. */
//const _unistd_PC_POSIX_SECURITY = 91
//const _unistd_PC_CASE_INSENSITIVE = 92
//$endif

/*
	 *  confstr values per IEEE Std 1003.1, 2004 Edition
	 */
/* Only defined on Cygwin for now. */
//$if defined("__CYGWIN__")
public const _unistd_CS_PATH = 0
public const _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1
public const _unistd_CS_POSIX_V6_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
public const _unistd_CS_XBS5_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
public const _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 2
public const _unistd_CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
public const _unistd_CS_XBS5_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
public const _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS = 3
public const _unistd_CS_POSIX_V6_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
public const _unistd_CS_XBS5_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
public const _unistd_CS_XBS5_ILP32_OFF32_LINTFLAGS = 4
public const _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 5
public const _unistd_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
public const _unistd_CS_XBS5_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
public const _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 6
public const _unistd_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
public const _unistd_CS_XBS5_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
public const _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS = 7
public const _unistd_CS_POSIX_V6_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
public const _unistd_CS_XBS5_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
public const _unistd_CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 8
public const _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS = 9
public const _unistd_CS_POSIX_V6_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
public const _unistd_CS_XBS5_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
public const _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS = 10
public const _unistd_CS_POSIX_V6_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
public const _unistd_CS_XBS5_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
public const _unistd_CS_POSIX_V7_LP64_OFF64_LIBS = 11
public const _unistd_CS_POSIX_V6_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
public const _unistd_CS_XBS5_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
public const _unistd_CS_XBS5_LP64_OFF64_LINTFLAGS = 12
public const _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 13
public const _unistd_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
public const _unistd_CS_XBS5_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
public const _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 14
public const _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
public const _unistd_CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
public const _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 15
public const _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
public const _unistd_CS_XBS5_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
public const _unistd_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 16
public const _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = 17
public const _unistd_CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
public const _unistd_CS_XBS5_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
public const _unistd_CS_POSIX_V7_THREADS_CFLAGS = 18
public const _unistd_CS_POSIX_V7_THREADS_LDFLAGS = 19
public const _unistd_CS_V7_ENV = 20
public const _unistd_CS_V6_ENV = _unistd_CS_V7_ENV
public const _unistd_CS_LFS_CFLAGS = 21
public const _unistd_CS_LFS_LDFLAGS = 22
public const _unistd_CS_LFS_LIBS = 23
public const _unistd_CS_LFS_LINTFLAGS = 24
//$endif



// access - determine accessibility of a file
public func access (path: *[]ConstChar, amode: Int) -> Int

// alarm - schedule an alarm signal
public func alarm (seconds: UnsignedInt) -> UnsignedInt

// brk, sbrk - change data segment size
public func brk (end_data_segment: Ptr) -> Int

// chdir - change working directory
public func chdir (path: *[]ConstChar) -> Int

// chroot - change root directory (LEGACY)
public func chroot (path: *[]ConstChar) -> Int

// chown — change the owner or group of a file or directory
public func chown (pathname: *[]ConstChar, owner: UIDT, group: GIDT) -> Int

// close - close a file descriptor
public func close (fildes: Int) -> @unused Int

// confstr - get configurable variables
public func confstr (name: Int, buf: *[]Char, len: SizeT) -> SizeT

// crypt - string encoding function
public func crypt (key: *[]ConstChar, salt: *[]ConstChar) -> *[]Char

// ctermid - generate a pathname for the controlling terminal
public func ctermid (s: @cstring *[]Char) -> @unused *[]Char

// cuserid - character login name of the user (LEGACY)
// not implemented on MacOS!
public func cuserid (s: *[]Char) -> *[]Char

// dup, dup2 - duplicate an open file descriptor
public func dup (fildes: Int) -> Int

// dup, dup2 - duplicate an open file descriptor
public func dup2 (fildes: Int, fildes2: Int) -> Int

// encrypt - encoding function
public func encrypt (block: *[64]Char, edflag: Int) -> Unit

//
public func execl (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
public func execle (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
public func execlp (file: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
public func execv (path: *[]ConstChar, argv: *[]ConstChar) -> Int
public func execve (path: *[]ConstChar, argv: *[]ConstChar, envp: *[]ConstChar) -> Int
public func execvp (file: *[]ConstChar, argv: *[]ConstChar) -> Int

// _exit - terminate a process
public func _exit (status: Int) -> Unit

// fchown - change owner and group of a file
public func fchown (fildes: Int, owner: UIDT, group: GIDT) -> Int

// fchdir - change working directory
public func fchdir (fildes: Int) -> Int

// fdatasync - synchronise the data of a file (REALTIME)
public func fdatasync (fildes: Int) -> Int

// fork - create a new process
public func fork () -> PIDT

// fpathconf, pathconf - get configurable pathname variables
public func fpathconf (fildes: Int, name: Int) -> LongInt

// fsync - synchronise changes to a file
public func fsync (fildes: Int) -> Int

// ftruncate, truncate - truncate a file to a specified length
public func ftruncate (fildes: Int, length: OffT) -> Int

// getcwd - get the pathname of the current working directory
public func getcwd (buf: @cstring *[]Char, size: SizeT) -> @unused *[]Char

// getdtablesize - get the file descriptor table size (LEGACY)
public func getdtablesize () -> Int

// getegid - get the effective group ID
public func getegid () -> GIDT

// geteuid - get the effective user ID
public func geteuid () -> UIDT

// getgid - get the real group ID
public func getgid () -> GIDT

// getgroups - get supplementary group IDs
public func getgroups (gidsetsize: Int, grouplist: *[]GIDT) -> Int

// gethostid - get an identifier for the current host
public func gethostid () -> Long

// getlogin - get login name
public func getlogin () -> *[]Char

// getlogin_r - get login name
public func getlogin_r (name: *[]Char, namesize: SizeT) -> Int

// getopt, optarg, optind, opterr, optopt - command option parsing
public func getopt (argc: Int, argv: *[]ConstChar, optstring: *[]ConstChar) -> Int

// getpagesize - get the current page size (LEGACY)
public func getpagesize () -> Int

// getpass - read a string of characters without echo (LEGACY)
public func getpass (prompt: *[]ConstChar) -> *[]Char

// getpgid - get the process group ID for a process
public func getpgid (pid: PIDT) -> PIDT

// getpgrp - get the process group ID of the calling process
public func getpgrp () -> PIDT

// getpid - get the process ID
public func getpid () -> PIDT

// getppid - get the parent process ID
public func getppid () -> PIDT

// getsid - get the process group ID of session leader
public func getsid (pid: PIDT) -> PIDT

// getuid - get a real user ID
public func getuid () -> UIDT

// getwd - get the current working directory pathname
public func getwd (path_name: *[]Char) -> *[]Char

// isatty - test for a terminal device
public func isatty (fildes: Int) -> Int

// lchown - change the owner and group of a symbolic link
public func lchown (path: *[]ConstChar, owner: UIDT, group: GIDT) -> Int

// link - link to a file
public func link (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

// lockf - record locking on files
public func lockf (fildes: Int, function: Int, size: OffT) -> Int

// lseek - move the read/write file offset
public func lseek (fildes: Int, offset: OffT, whence: Int) -> OffT

// nice - change nice value of a process
public func nice (incr: Int) -> Int

// pathconf - get configurable pathname variables
public func pathconf (path: *[]ConstChar, name: Int) -> LongInt

// pause - suspend the thread until signal is received
public func pause () -> Int

// pipe - create an interprocess channel
public func pipe (fildes: *[2]Int) -> Int

// pread - read from a file
public func pread (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

// pthread_atfork - register fork handlers
//public func pthread_atfork (prepare: *()->Unit, parent: *()->Unit, child: *()->Unit) -> Int

// pwrite - write on a file
public func pwrite (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

// read, readv, pread - read from a file
public func read (fildes: Int, buf: Ptr, nbyte: SizeT) -> SSizeT

// readlink - read the contents of a symbolic link
public func readlink (path: *[]ConstChar, buf: *[]Char, bufsize: SizeT) -> Int

// rmdir - remove a directory
public func rmdir (path: *[]ConstChar) -> Int

// sbrk - change space allocation
public func sbrk (incr: IntPtrT) -> Ptr

// setgid - set-group-ID
public func setgid (gid: GIDT) -> Int

// setpgid - set process group ID for job control
public func setpgid (pid: PIDT, pgid: PIDT) -> Int

// setpgrp - set process group ID
public func setpgrp () -> PIDT

// setregid - set real and effective group IDs
public func setregid (rgid: GIDT, egid: GIDT) -> Int

// setreuid - set real and effective user IDs
public func setreuid (ruid: UIDT, euid: UIDT) -> Int

// setsid - create session and set process group ID
public func setsid () -> PIDT

// setuid - set-user-ID
public func setuid (uid: UIDT) -> Int

// sleep - suspend execution for an interval of time
public func sleep (seconds: UnsignedInt) -> @unused UnsignedInt

// swab - swap bytes
public func swab (src: Ptr, dst: Ptr, nbytes: SSizeT) -> Unit

// symlink - make symbolic link to a file
public func symlink (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

// sync - schedule filesystem updates
public func sync () -> Unit

// sysconf - get configurable system variables
public func sysconf (name: Int) -> LongInt

// tcgetpgrp - get the foreground process group ID
public func tcgetpgrp (fildes: Int) -> PIDT

// tcsetpgrp - set the foreground process group ID
public func tcsetpgrp (fildes: Int, pgid_id: PIDT) -> Int

// truncate - truncate a file to a specified length
public func truncate (path: *[]ConstChar, length: OffT) -> Int

// ttyname - find pathname of a terminal
public func ttyname (fildes: Int) -> *[]Char

// ttyname_r - find pathname of a terminal
public func ttyname_r (fildes: Int, name: *[]Char, namesize: SizeT) -> Int

// ualarm - set the interval timer
public func ualarm (useconds: USecondsT, interval: USecondsT) -> USecondsT

// unlink - remove a directory entry
public func unlink (path: *[]ConstChar) -> Int

// usleep - suspend execution for an interval
public func usleep (useconds: USecondsT) -> @unused Int

// vfork - create new process; share virtual memory
public func vfork () -> PIDT

// write, writev, pwrite - write on a file
public func write (fildes: Int, buf: Ptr, nbyte: SizeT) -> @unused SSizeT



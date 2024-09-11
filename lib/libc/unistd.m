// libc/unistd.hm
// thx: https://pubs.opengroup.org/onlinepubs/7908799/xsh/unistd.h.html

$pragma do_not_include
$pragma module_nodecorate
$pragma c_include "unistd.h"


include "libc/ctypes64"
include "libc/ctypes"


//@attribute("extern")
//var environ: *[]*Char

@property("value.id.c", "SEEK_SET")
export let c_SEEK_SET = 0
@property("value.id.c", "SEEK_CUR")
export let c_SEEK_CUR = 1
@property("value.id.c", "SEEK_END")
export let c_SEEK_END = 2

@property("value.id.c", "STDIN_FILENO")
export let c_STDIN_FILENO = 0
@property("value.id.c", "STDOUT_FILENO")
export let c_STDOUT_FILENO = 1
@property("value.id.c", "STDERR_FILENO")
export let c_STDERR_FILENO = 2


// lockf function - record locking on files
@property("value.id.c", "F_ULOCK")
export let c_F_ULOCK = 0  // unlock locked sections
@property("value.id.c", "F_LOCK")
export let c_F_LOCK = 1   // lock a section for exclusive use
@property("value.id.c", "F_TLOCK")
export let c_F_TLOCK = 2  // test and lock a section for exclusive use
@property("value.id.c", "F_TEST")
export let c_F_TEST = 3

@property("value.id.c", "F_OK")
export let c_F_OK = 0  // Test for existence of file
@property("value.id.c", "R_OK")
export let c_R_OK = 4  // Test for read permission
@property("value.id.c", "W_OK")
export let c_W_OK = 2  // Test for write permission
@property("value.id.c", "X_OK")
export let c_X_OK = 1  // Test for execute (search) permission



/*
 *  sysconf values per IEEE Std 1003.1, 2008 Edition
 */
export let _unistd_SC_ARG_MAX = 0
export let _unistd_SC_CHILD_MAX = 1
export let _unistd_SC_CLK_TCK = 2
export let _unistd_SC_NGROUPS_MAX = 3
export let _unistd_SC_OPEN_MAX = 4
export let _unistd_SC_JOB_CONTROL = 5
export let _unistd_SC_SAVED_IDS = 6
export let _unistd_SC_VERSION = 7
export let _unistd_SC_PAGESIZE = 8
export let _unistd_SC_PAGE_SIZE = _unistd_SC_PAGESIZE
/* These are non-POSIX values we accidentally introduced in 2000 without
   guarding them.  Keeping them unguarded for backward compatibility. */
export let _unistd_SC_NPROCESSORS_CONF = 9
export let _unistd_SC_NPROCESSORS_ONLN = 10
export let _unistd_SC_PHYS_PAGES = 11
export let _unistd_SC_AVPHYS_PAGES = 12
/* End of non-POSIX values. */
export let _unistd_SC_MQ_OPEN_MAX = 13
export let _unistd_SC_MQ_PRIO_MAX = 14
export let _unistd_SC_RTSIG_MAX = 15
export let _unistd_SC_SEM_NSEMS_MAX = 16
export let _unistd_SC_SEM_VALUE_MAX = 17
export let _unistd_SC_SIGQUEUE_MAX = 18
export let _unistd_SC_TIMER_MAX = 19
export let _unistd_SC_TZNAME_MAX = 20
export let _unistd_SC_ASYNCHRONOUS_IO = 21
export let _unistd_SC_FSYNC = 22
export let _unistd_SC_MAPPED_FILES = 23
export let _unistd_SC_MEMLOCK = 24
export let _unistd_SC_MEMLOCK_RANGE = 25
export let _unistd_SC_MEMORY_PROTECTION = 26
export let _unistd_SC_MESSAGE_PASSING = 27
export let _unistd_SC_PRIORITIZED_IO = 28
export let _unistd_SC_REALTIME_SIGNALS = 29
export let _unistd_SC_SEMAPHORES = 30
export let _unistd_SC_SHARED_MEMORY_OBJECTS = 31
export let _unistd_SC_SYNCHRONIZED_IO = 32
export let _unistd_SC_TIMERS = 33
export let _unistd_SC_AIO_LISTIO_MAX = 34
export let _unistd_SC_AIO_MAX = 35
export let _unistd_SC_AIO_PRIO_DELTA_MAX = 36
export let _unistd_SC_DELAYTIMER_MAX = 37
export let _unistd_SC_THREAD_KEYS_MAX = 38
export let _unistd_SC_THREAD_STACK_MIN = 39
export let _unistd_SC_THREAD_THREADS_MAX = 40
export let _unistd_SC_TTY_NAME_MAX = 41
export let _unistd_SC_THREADS = 42
export let _unistd_SC_THREAD_ATTR_STACKADDR = 43
export let _unistd_SC_THREAD_ATTR_STACKSIZE = 44
export let _unistd_SC_THREAD_PRIORITY_SCHEDULING = 45
export let _unistd_SC_THREAD_PRIO_INHERIT = 46
/* _unistd_SC_THREAD_PRIO_PROTECT was _unistd_SC_THREAD_PRIO_CEILING in early drafts */
export let _unistd_SC_THREAD_PRIO_PROTECT = 47
export let _unistd_SC_THREAD_PRIO_CEILING = _unistd_SC_THREAD_PRIO_PROTECT
export let _unistd_SC_THREAD_PROCESS_SHARED = 48
export let _unistd_SC_THREAD_SAFE_FUNCTIONS = 49
export let _unistd_SC_GETGR_R_SIZE_MAX = 50
export let _unistd_SC_GETPW_R_SIZE_MAX = 51
export let _unistd_SC_LOGIN_NAME_MAX = 52
export let _unistd_SC_THREAD_DESTRUCTOR_ITERATIONS = 53
export let _unistd_SC_ADVISORY_INFO = 54
export let _unistd_SC_ATEXIT_MAX = 55
export let _unistd_SC_BARRIERS = 56
export let _unistd_SC_BC_BASE_MAX = 57
export let _unistd_SC_BC_DIM_MAX = 58
export let _unistd_SC_BC_SCALE_MAX = 59
export let _unistd_SC_BC_STRING_MAX = 60
export let _unistd_SC_CLOCK_SELECTION = 61
export let _unistd_SC_COLL_WEIGHTS_MAX = 62
export let _unistd_SC_CPUTIME = 63
export let _unistd_SC_EXPR_NEST_MAX = 64
export let _unistd_SC_HOST_NAME_MAX = 65
export let _unistd_SC_IOV_MAX = 66
export let _unistd_SC_IPV6 = 67
export let _unistd_SC_LINE_MAX = 68
export let _unistd_SC_MONOTONIC_CLOCK = 69
export let _unistd_SC_RAW_SOCKETS = 70
export let _unistd_SC_READER_WRITER_LOCKS = 71
export let _unistd_SC_REGEXP = 72
export let _unistd_SC_RE_DUP_MAX = 73
export let _unistd_SC_SHELL = 74
export let _unistd_SC_SPAWN = 75
export let _unistd_SC_SPIN_LOCKS = 76
export let _unistd_SC_SPORADIC_SERVER = 77
export let _unistd_SC_SS_REPL_MAX = 78
export let _unistd_SC_SYMLOOP_MAX = 79
export let _unistd_SC_THREAD_CPUTIME = 80
export let _unistd_SC_THREAD_SPORADIC_SERVER = 81
export let _unistd_SC_TIMEOUTS = 82
export let _unistd_SC_TRACE = 83
export let _unistd_SC_TRACE_EVENT_FILTER = 84
export let _unistd_SC_TRACE_EVENT_NAME_MAX = 85
export let _unistd_SC_TRACE_INHERIT = 86
export let _unistd_SC_TRACE_LOG = 87
export let _unistd_SC_TRACE_NAME_MAX = 88
export let _unistd_SC_TRACE_SYS_MAX = 89
export let _unistd_SC_TRACE_USER_EVENT_MAX = 90
export let _unistd_SC_TYPED_MEMORY_OBJECTS = 91
export let _unistd_SC_V7_ILP32_OFF32 = 92
export let _unistd_SC_V6_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
export let _unistd_SC_XBS5_ILP32_OFF32 = _unistd_SC_V7_ILP32_OFF32
export let _unistd_SC_V7_ILP32_OFFBIG = 93
export let _unistd_SC_V6_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
export let _unistd_SC_XBS5_ILP32_OFFBIG = _unistd_SC_V7_ILP32_OFFBIG
export let _unistd_SC_V7_LP64_OFF64 = 94
export let _unistd_SC_V6_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
export let _unistd_SC_XBS5_LP64_OFF64 = _unistd_SC_V7_LP64_OFF64
export let _unistd_SC_V7_LPBIG_OFFBIG = 95
export let _unistd_SC_V6_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
export let _unistd_SC_XBS5_LPBIG_OFFBIG = _unistd_SC_V7_LPBIG_OFFBIG
export let _unistd_SC_XOPEN_CRYPT = 96
export let _unistd_SC_XOPEN_ENH_I18N = 97
export let _unistd_SC_XOPEN_LEGACY = 98
export let _unistd_SC_XOPEN_REALTIME = 99
export let _unistd_SC_STREAM_MAX = 100
export let _unistd_SC_PRIORITY_SCHEDULING = 101
export let _unistd_SC_XOPEN_REALTIME_THREADS = 102
export let _unistd_SC_XOPEN_SHM = 103
export let _unistd_SC_XOPEN_STREAMS = 104
export let _unistd_SC_XOPEN_UNIX = 105
export let _unistd_SC_XOPEN_VERSION = 106
export let _unistd_SC_2_CHAR_TERM = 107
export let _unistd_SC_2_C_BIND = 108
export let _unistd_SC_2_C_DEV = 109
export let _unistd_SC_2_FORT_DEV = 110
export let _unistd_SC_2_FORT_RUN = 111
export let _unistd_SC_2_LOCALEDEF = 112
export let _unistd_SC_2_PBS = 113
export let _unistd_SC_2_PBS_ACCOUNTING = 114
export let _unistd_SC_2_PBS_CHECKPOINT = 115
export let _unistd_SC_2_PBS_LOCATE = 116
export let _unistd_SC_2_PBS_MESSAGE = 117
export let _unistd_SC_2_PBS_TRACK = 118
export let _unistd_SC_2_SW_DEV = 119
export let _unistd_SC_2_UPE = 120
export let _unistd_SC_2_VERSION = 121
export let _unistd_SC_THREAD_ROBUST_PRIO_INHERIT = 122
export let _unistd_SC_THREAD_ROBUST_PRIO_PROTECT = 123
export let _unistd_SC_XOPEN_UUCP = 124
export let _unistd_SC_LEVEL1_ICACHE_SIZE = 125
export let _unistd_SC_LEVEL1_ICACHE_ASSOC = 126
export let _unistd_SC_LEVEL1_ICACHE_LINESIZE = 127
export let _unistd_SC_LEVEL1_DCACHE_SIZE = 128
export let _unistd_SC_LEVEL1_DCACHE_ASSOC = 129
export let _unistd_SC_LEVEL1_DCACHE_LINESIZE = 130
export let _unistd_SC_LEVEL2_CACHE_SIZE = 131
export let _unistd_SC_LEVEL2_CACHE_ASSOC = 132
export let _unistd_SC_LEVEL2_CACHE_LINESIZE = 133
export let _unistd_SC_LEVEL3_CACHE_SIZE = 134
export let _unistd_SC_LEVEL3_CACHE_ASSOC = 135
export let _unistd_SC_LEVEL3_CACHE_LINESIZE = 136
export let _unistd_SC_LEVEL4_CACHE_SIZE = 137
export let _unistd_SC_LEVEL4_CACHE_ASSOC = 138
export let _unistd_SC_LEVEL4_CACHE_LINESIZE = 139
export let _unistd_SC_POSIX_26_VERSION = 140

/*
 *  pathconf values per IEEE Std 1003.1, 2008 Edition
 */
export let _unistd_PC_LINK_MAX = 0
export let _unistd_PC_MAX_CANON = 1
export let _unistd_PC_MAX_INPUT = 2
export let _unistd_PC_NAME_MAX = 3
export let _unistd_PC_PATH_MAX = 4
export let _unistd_PC_PIPE_BUF = 5
export let _unistd_PC_CHOWN_RESTRICTED = 6
export let _unistd_PC_NO_TRUNC = 7
export let _unistd_PC_VDISABLE = 8
export let _unistd_PC_ASYNC_IO = 9
export let _unistd_PC_PRIO_IO = 10
export let _unistd_PC_SYNC_IO = 11
export let _unistd_PC_FILESIZEBITS = 12
export let _unistd_PC_2_SYMLINKS = 13
export let _unistd_PC_SYMLINK_MAX = 14
export let _unistd_PC_ALLOC_SIZE_MIN = 15
export let _unistd_PC_REC_INCR_XFER_SIZE = 16
export let _unistd_PC_REC_MAX_XFER_SIZE = 17
export let _unistd_PC_REC_MIN_XFER_SIZE = 18
export let _unistd_PC_REC_XFER_ALIGN = 19
export let _unistd_PC_TIMESTAMP_RESOLUTION = 20

//$if defined("__CYGWIN__")
///* Ask for POSIX permission bits support. */
//export let _unistd_PC_POSIX_PERMISSIONS = 90
///* Ask for full POSIX permission support including uid/gid settings. */
//export let _unistd_PC_POSIX_SECURITY = 91
//export let _unistd_PC_CASE_INSENSITIVE = 92
//$endif

/*
 *  confstr values per IEEE Std 1003.1, 2004 Edition
 */
/* Only defined on Cygwin for now. */
//$if defined("__CYGWIN__")
export let _unistd_CS_PATH = 0
export let _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS = 1
export let _unistd_CS_POSIX_V6_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
export let _unistd_CS_XBS5_ILP32_OFF32_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_CFLAGS
export let _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS = 2
export let _unistd_CS_POSIX_V6_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
export let _unistd_CS_XBS5_ILP32_OFF32_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFF32_LDFLAGS
export let _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS = 3
export let _unistd_CS_POSIX_V6_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
export let _unistd_CS_XBS5_ILP32_OFF32_LIBS = _unistd_CS_POSIX_V7_ILP32_OFF32_LIBS
export let _unistd_CS_XBS5_ILP32_OFF32_LINTFLAGS = 4
export let _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS = 5
export let _unistd_CS_POSIX_V6_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
export let _unistd_CS_XBS5_ILP32_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_CFLAGS
export let _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS = 6
export let _unistd_CS_POSIX_V6_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
export let _unistd_CS_XBS5_ILP32_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LDFLAGS
export let _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS = 7
export let _unistd_CS_POSIX_V6_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
export let _unistd_CS_XBS5_ILP32_OFFBIG_LIBS = _unistd_CS_POSIX_V7_ILP32_OFFBIG_LIBS
export let _unistd_CS_XBS5_ILP32_OFFBIG_LINTFLAGS = 8
export let _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS = 9
export let _unistd_CS_POSIX_V6_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
export let _unistd_CS_XBS5_LP64_OFF64_CFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_CFLAGS
export let _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS = 10
export let _unistd_CS_POSIX_V6_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
export let _unistd_CS_XBS5_LP64_OFF64_LDFLAGS = _unistd_CS_POSIX_V7_LP64_OFF64_LDFLAGS
export let _unistd_CS_POSIX_V7_LP64_OFF64_LIBS = 11
export let _unistd_CS_POSIX_V6_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
export let _unistd_CS_XBS5_LP64_OFF64_LIBS = _unistd_CS_POSIX_V7_LP64_OFF64_LIBS
export let _unistd_CS_XBS5_LP64_OFF64_LINTFLAGS = 12
export let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS = 13
export let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
export let _unistd_CS_XBS5_LPBIG_OFFBIG_CFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_CFLAGS
export let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS = 14
export let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
export let _unistd_CS_XBS5_LPBIG_OFFBIG_LDFLAGS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LDFLAGS
export let _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS = 15
export let _unistd_CS_POSIX_V6_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
export let _unistd_CS_XBS5_LPBIG_OFFBIG_LIBS = _unistd_CS_POSIX_V7_LPBIG_OFFBIG_LIBS
export let _unistd_CS_XBS5_LPBIG_OFFBIG_LINTFLAGS = 16
export let _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS = 17
export let _unistd_CS_POSIX_V6_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
export let _unistd_CS_XBS5_WIDTH_RESTRICTED_ENVS = _unistd_CS_POSIX_V7_WIDTH_RESTRICTED_ENVS
export let _unistd_CS_POSIX_V7_THREADS_CFLAGS = 18
export let _unistd_CS_POSIX_V7_THREADS_LDFLAGS = 19
export let _unistd_CS_V7_ENV = 20
export let _unistd_CS_V6_ENV = _unistd_CS_V7_ENV
export let _unistd_CS_LFS_CFLAGS = 21
export let _unistd_CS_LFS_LDFLAGS = 22
export let _unistd_CS_LFS_LIBS = 23
export let _unistd_CS_LFS_LINTFLAGS = 24
//$endif



// access - determine accessibility of a file
export func access (path: *[]ConstChar, amode: Int) -> Int

// alarm - schedule an alarm signal
export func alarm (seconds: UnsignedInt) -> UnsignedInt

// brk, sbrk - change data segment size
export func brk (end_data_segment: Ptr) -> Int

// chdir - change working directory
export func chdir (path: *[]ConstChar) -> Int

// chroot - change root directory (LEGACY)
export func chroot (path: *[]ConstChar) -> Int

// chown — change the owner or group of a file or directory
export func chown (pathname: *[]ConstChar, owner: UidT, group: GidT) -> Int

// close - close a file descriptor
export func close (fildes: Int) -> Int

// confstr - get configurable variables
export func confstr (name: Int, buf: *[]Char, len: SizeT) -> SizeT

// crypt - string encoding function
export func crypt (key: *[]ConstChar, salt: *[]ConstChar) -> *[]Char

// ctermid - generate a pathname for the controlling terminal
export func ctermid (s: *[]Char) -> *[]Char

// cuserid - character login name of the user (LEGACY)
// not implemented on MacOS!
export func cuserid (s: *[]Char) -> *[]Char

// dup, dup2 - duplicate an open file descriptor
export func dup (fildes: Int) -> Int

// dup, dup2 - duplicate an open file descriptor
export func dup2 (fildes: Int, fildes2: Int) -> Int

// encrypt - encoding function
export func encrypt (block: *[64]Char, edflag: Int) -> Unit

//
export func execl (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
export func execle (path: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
export func execlp (file: *[]ConstChar, arg0: *[]ConstChar, ...) -> Int
export func execv (path: *[]ConstChar, argv: *[]ConstChar) -> Int
export func execve (path: *[]ConstChar, argv: *[]ConstChar, envp: *[]ConstChar) -> Int
export func execvp (file: *[]ConstChar, argv: *[]ConstChar) -> Int

// _exit - terminate a process
export func _exit (status: Int) -> Unit

// fchown - change owner and group of a file
export func fchown (fildes: Int, owner: UidT, group: GidT) -> Int

// fchdir - change working directory
export func fchdir (fildes: Int) -> Int

// fdatasync - synchronise the data of a file (REALTIME)
export func fdatasync (fildes: Int) -> Int

// fork - create a new process
export func fork () -> PidT

// fpathconf, pathconf - get configurable pathname variables
export func fpathconf (fildes: Int, name: Int) -> LongInt

// fsync - synchronise changes to a file
export func fsync (fildes: Int) -> Int

// ftruncate, truncate - truncate a file to a specified length
export func ftruncate (fildes: Int, length: OffT) -> Int

// getcwd - get the pathname of the current working directory
export func getcwd (buf: *[]Char, size: SizeT) -> *[]Char

// getdtablesize - get the file descriptor table size (LEGACY)
export func getdtablesize () -> Int

// getegid - get the effective group ID
export func getegid () -> GidT

// geteuid - get the effective user ID
export func geteuid () -> UidT

// getgid - get the real group ID
export func getgid () -> GidT

// getgroups - get supplementary group IDs
export func getgroups (gidsetsize: Int, grouplist: *[]GidT) -> Int

// gethostid - get an identifier for the current host
export func gethostid () -> Long

// getlogin - get login name
export func getlogin () -> *[]Char

// getlogin_r - get login name
export func getlogin_r (name: *[]Char, namesize: SizeT) -> Int

// getopt, optarg, optind, opterr, optopt - command option parsing
export func getopt (argc: Int, argv: *[]ConstChar, optstring: *[]ConstChar) -> Int

// getpagesize - get the current page size (LEGACY)
export func getpagesize () -> Int

// getpass - read a string of characters without echo (LEGACY)
export func getpass (prompt: *[]ConstChar) -> *[]Char

// getpgid - get the process group ID for a process
export func getpgid (pid: PidT) -> PidT

// getpgrp - get the process group ID of the calling process
export func getpgrp () -> PidT

// getpid - get the process ID
export func getpid () -> PidT

// getppid - get the parent process ID
export func getppid () -> PidT

// getsid - get the process group ID of session leader
export func getsid (pid: PidT) -> PidT

// getuid - get a real user ID
export func getuid () -> UidT

// getwd - get the current working directory pathname
export func getwd (path_name: *[]Char) -> *[]Char

// isatty - test for a terminal device
export func isatty (fildes: Int) -> Int

// lchown - change the owner and group of a symbolic link
export func lchown (path: *[]ConstChar, owner: UidT, group: GidT) -> Int

// link - link to a file
export func link (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

// lockf - record locking on files
export func lockf (fildes: Int, function: Int, size: OffT) -> Int

// lseek - move the read/write file offset
export func lseek (fildes: Int, offset: OffT, whence: Int) -> OffT

// nice - change nice value of a process
export func nice (incr: Int) -> Int

// pathconf - get configurable pathname variables
export func pathconf (path: *[]ConstChar, name: Int) -> LongInt

// pause - suspend the thread until signal is received
export func pause () -> Int

// pipe - create an interprocess channel
export func pipe (fildes: *[2]Int) -> Int

// pread - read from a file
export func pread (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

// pthread_atfork - register fork handlers
export func pthread_atfork (prepare: *()->Unit, parent: *()->Unit, child: *()->Unit) -> Int

// pwrite - write on a file
export func pwrite (fildes: Int, buf: Ptr, nbyte: SizeT, offset: OffT) -> SSizeT

// read, readv, pread - read from a file
export func read (fildes: Int, buf: Ptr, nbyte: SizeT) -> SSizeT

// readlink - read the contents of a symbolic link
export func readlink (path: *[]ConstChar, buf: *[]Char, bufsize: SizeT) -> Int

// rmdir - remove a directory
export func rmdir (path: *[]ConstChar) -> Int

// sbrk - change space allocation
export func sbrk (incr: IntptrT) -> Ptr

// setgid - set-group-ID
export func setgid (gid: GidT) -> Int

// setpgid - set process group ID for job control
export func setpgid (pid: PidT, pgid: PidT) -> Int

// setpgrp - set process group ID
export func setpgrp () -> PidT

// setregid - set real and effective group IDs
export func setregid (rgid: GidT, egid: GidT) -> Int

// setreuid - set real and effective user IDs
export func setreuid (ruid: UidT, euid: UidT) -> Int

// setsid - create session and set process group ID
export func setsid () -> PidT

// setuid - set-user-ID
export func setuid (uid: UidT) -> Int

// sleep - suspend execution for an interval of time
export func sleep (seconds: UnsignedInt) -> UnsignedInt

// swab - swap bytes
export func swab (src: Ptr, dst: Ptr, nbytes: SSizeT) -> Unit

// symlink - make symbolic link to a file
export func symlink (path1: *[]ConstChar, path2: *[]ConstChar) -> Int

// sync - schedule filesystem updates
export func sync () -> Unit

// sysconf - get configurable system variables
export func sysconf (name: Int) -> LongInt

// tcgetpgrp - get the foreground process group ID
export func tcgetpgrp (fildes: Int) -> PidT

// tcsetpgrp - set the foreground process group ID
export func tcsetpgrp (fildes: Int, pgid_id: PidT) -> Int

// truncate - truncate a file to a specified length
export func truncate (path: *[]ConstChar, length: OffT) -> Int

// ttyname - find pathname of a terminal
export func ttyname (fildes: Int) -> *[]Char

// ttyname_r - find pathname of a terminal
export func ttyname_r (fildes: Int, name: *[]Char, namesize: SizeT) -> Int

// ualarm - set the interval timer
export func ualarm (useconds: USecondsT, interval: USecondsT) -> USecondsT

// unlink - remove a directory entry
export func unlink (path: *[]ConstChar) -> Int

// usleep - suspend execution for an interval
export func usleep (useconds: USecondsT) -> Int

// vfork - create new process; share virtual memory
export func vfork () -> PidT

// write, writev, pwrite - write on a file
export func write (fildes: Int, buf: Ptr, nbyte: SizeT) -> SSizeT



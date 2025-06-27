/*
 * libc/errno.m
 */

pragma module_nodecorate


/*
 * Error codes
 */
public const c_EPERM = 1     // Operation not permitted
public const c_ENOENT = 2    // No such file or directory
public const c_ESRCH = 3     // No such process
public const c_EINTR = 4     // Interrupted system call
public const c_EIO = 5       // Input/output error
public const c_ENXIO = 6     // Device not configured
public const c_E2BIG = 7     // Argument list too long
public const c_ENOEXEC = 8   // Exec format error
public const c_EBADF = 9     // Bad file descriptor
public const c_ECHILD = 10   // No child processes
public const c_EDEADLK = 11  // Resource deadlock avoided (11 was EAGAIN)
public const c_ENOMEM = 12   // Cannot allocate memory
public const c_EACCES = 13   // Permission denied
public const c_EFAULT = 14   // Bad address
public const c_ENOTBLK = 15  // Block device required
public const c_EBUSY = 16    // Device / Resource busy
public const c_EEXIST = 17   // File exists
public const c_EXDEV = 18    // Cross-device link
public const c_ENODEV = 19   // Operation not supported by device
public const c_ENOTDIR = 20  // Not a directory
public const c_EISDIR = 21   // Is a directory
public const c_EINVAL = 22   // Invalid argument
public const c_ENFILE = 23   // Too many open files in system
public const c_EMFILE = 24   // Too many open files
public const c_ENOTTY = 25   // Inappropriate ioctl for device
public const c_ETXTBSY = 26  // Text file busy
public const c_EFBIG = 27    // File too large
public const c_ENOSPC = 28   // No space left on device
public const c_ESPIPE = 29   // Illegal seek
public const c_EROFS = 30    // Read-only file system
public const c_EMLINK = 31   // Too many links
public const c_EPIPE = 32    // Broken pipe

/* math software */
public const c_EDOM = 33     // Numerical argument out of domain
public const c_ERANGE = 34   // Result too large

/* non-blocking and interrupt i/o */
public const c_EAGAIN = 35           // Resource temporarily unavailable
public const c_EWOULDBLOCK = eAGAIN  // Operation would block
public const c_EINPROGRESS = 36      // Operation now in progress
public const c_EALREADY = 37         // Operation already in progress

/* ipc/network software -- argument errors */
public const c_ENOTSOCK = 38         // Socket operation on non-socket
public const c_EDESTADDRREQ = 39     // Destination address required
public const c_EMSGSIZE = 40         // Message too long
public const c_EPROTOTYPE = 41       // Protocol wrong type for socket
public const c_ENOPROTOOPT = 42      // Protocol not available
public const c_EPROTONOSUPPORT = 43  // Protocol not supported
public const c_ESOCKTNOSUPPORT = 44  // Socket type not supported
public const c_ENOTSUP = 45          // Operation not supported
public const c_EPFNOSUPPORT = 46     // Protocol family not supported

public const c_EAFNOSUPPORT = 47     // Address family not supported by protocol family
public const c_EADDRINUSE = 48       // Address already in use
public const c_EADDRNOTAVAIL = 49    // Can't assign requested address

/* ipc/network software -- operational errors */
public const c_ENETDOWN = 50         // Network is down
public const c_ENETUNREACH = 51      // Network is unreachable
public const c_ENETRESET = 52        // Network dropped connection on reset
public const c_ECONNABORTED = 53     // Software caused connection abort
public const c_ECONNRESET = 54       // Connection reset by peer
public const c_ENOBUFS = 55          // No buffer space available
public const c_EISCONN = 56          // Socket is already connected
public const c_ENOTCONN = 57         // Socket is not connected
public const c_ESHUTDOWN = 58        // Can't send after socket shutdown
public const c_ETOOMANYREFS = 59     // Too many references: can't splice
public const c_ETIMEDOUT = 60        // Operation timed out
public const c_ECONNREFUSED = 61     // Connection refused

public const c_ELOOP = 62            // Too many levels of symbolic links
public const c_ENAMETOOLONG = 63     // File name too long

/* should be rearranged */
public const c_EHOSTDOWN = 64        // Host is down
public const c_EHOSTUNREACH = 65     // No route to host
public const c_ENOTEMPTY = 66        // Directory not empty

/* quotas & mush */
//public const c_EPROCLIM = 67  // Too many processes
//public const c_EUSERS = 68    // Too many users
public const c_EDQUOT = 69      // Disc quota exceeded

/* Network File System */
public const c_ESTALE = 70  // Stale NFS file handle
//public const c_EREMOTE = 71  // Too many levels of remote in path
//public const c_EBADRPC = 72  // RPC struct is bad
//public const c_ERPCMISMATCH = 73   // RPC version wrong
//public const c_EPROGUNAVAIL = 74   // RPC prog. not avail
//public const c_EPROGMISMATCH = 75  // Program version wrong
//public const c_EPROCUNAVAIL = 76   // Bad procedure for program

public const c_ENOLCK = 77  // No locks available
public const c_ENOSYS = 78  // Function not implemented

//public const c_EFTYPE = 79     // Inappropriate file type or format
//public const c_EAUTH = 80      // Authentication error
//public const c_ENEEDAUTH = 81  // Need authenticator
//
///* Intelligent device errors */
//public const c_EPWROFF = 82  // Device power is off
//public const c_EDEVERR = 83  // Device error, e.g. paper out

public const c_EOVERFLOW = 84  // Value too large to be stored in data type

/* Program loading errors */
//public const c_EBADEXEC = 85    // Bad executable
//public const c_EBADARCH = 86    // Bad CPU type in executable
//public const c_ESHLIBVERS = 87  // Shared library version mismatch
//public const c_EBADMACHO = 88   // Malformed Macho file

public const c_ECANCELED = 89  // Operation canceled

public const c_EIDRM = 90   // Identifier removed
public const c_ENOMSG = 91  // No message of desired type
public const c_EILSEQ = 92  // Illegal byte sequence

//public const c_ENOATTR = 93  // Attribute not found

public const c_EBADMSG = 94    // Bad message
public const c_EMULTIHOP = 95  // Reserved
public const c_ENODATA = 96    // No message available on STREAM
public const c_ENOLINK = 97    // Reserved
public const c_ENOSR = 98      // No STREAM resources
public const c_ENOSTR = 99     // Not a STREAM
public const c_EPROTO = 100    // Protocol error
public const c_ETIME = 101     // STREAM ioctl timeout

/* This value is only discrete when compiling __DARWIN_UNIX03, or KERNEL */
public const c_EOPNOTSUPP = 102  // Operation not supported on socket
public const c_ENOPOLICY = 103   // No such policy registered

/* pseudo-errors returned inside kernel to modify return to process */
public const c_ERESTART = -1     // restart syscall
public const c_EJUSTRETURN = -2  // don't modify regs, just return


// libc/fcntl.m

pragma prefix ""

include "libc/ctypes"
include "libc/stat"

// open-only flags
@extern("C", "O_RDONLY")
public const c_O_RDONLY = Word32 0x00000000    // open for reading only
@extern("C", "O_WRONLY")
public const c_O_WRONLY = Word32 0x00000001    // open for writing only
@extern("C", "O_RDWR")
public const c_O_RDWR = Word32 0x00000002      // open for reading and writing
@extern("C", "O_ACCMODE")
public const c_O_ACCMODE = Word32 0x00000003   // mask for above modes

@extern("C", "O_NONBLOCK")
public const c_O_NONBLOCK = Word32 0x00000004  // no delay
@extern("C", "O_APPEND")
public const c_O_APPEND = Word32 0x00000008    // set append mode

@extern("C", "O_CREAT")
public const c_O_CREAT = Word32 0x00000200     // create if nonexistent
@extern("C", "O_TRUNC")
public const c_O_TRUNC = Word32 0x00000400     // truncate to zero length
@extern("C", "O_EXCL")
public const c_O_EXCL = Word32 0x00000800      // error if already exists


/*
 * Constants used for fcntl()
 */

// command values
@extern("C", "F_DUPFD")
public const c_F_DUPFD = 0           // duplicate file descriptor
@extern("C", "F_GETFD")
public const c_F_GETFD = 1           // get file descriptor flags
@extern("C", "F_SETFD")
public const c_F_SETFD = 2           // set file descriptor flags
@extern("C", "F_GETFL")
public const c_F_GETFL = 3           // get file status flags
@extern("C", "F_SETFL")
public const c_F_SETFL = 4           // set file status flags
@extern("C", "F_GETOWN")
public const c_F_GETOWN = 5          // get SIGIO/SIGURG proc/pgrp
@extern("C", "F_SETOWN")
public const c_F_SETOWN = 6          // set SIGIO/SIGURG proc/pgrp
@extern("C", "F_GETLK")
public const c_F_GETLK = 7           // get record locking information
@extern("C", "F_SETLK")
public const c_F_SETLK = 8           // set record locking information
@extern("C", "F_SETLKW")
public const c_F_SETLKW = 9          // f_SETLK, wait if blocked
@extern("C", "F_CLOSEM")
public const c_F_CLOSEM = 10         // close all fds >= to the one given
@extern("C", "F_MAXFD")
public const c_F_MAXFD = 11          // return the max open fd
@extern("C", "F_DUPFD_CLOEXEC")
public const c_F_DUPFD_CLOEXEC = 12  // close on exec duplicated fd
@extern("C", "F_GETNOSIGPIPE")
public const c_F_GETNOSIGPIPE = 13   // get SIGPIPE disposition
@extern("C", "F_SETNOSIGPIPE")
public const c_F_SETNOSIGPIPE = 14   // set SIGPIPE disposition
@extern("C", "F_GETPATH")
public const c_F_GETPATH = 15        // get pathname associated with fd
@extern("C", "F_ADD_SEALS")
public const c_F_ADD_SEALS = 16      // set seals
@extern("C", "F_GET_SEALS")
public const c_F_GET_SEALS = 17      // get seals

// file descriptor flags (f_GETFD, f_SETFD)
@extern("C", "FD_CLOEXEC")
public const c_FD_CLOEXEC = 1        // close-on-exec flag

// record locking flags (F_GETLK, F_SETLK, F_SETLKW)
@extern("C", "F_RDLCK")
public const c_F_RDLCK = 1  // shared or read lock
@extern("C", "F_UNLCK")
public const c_F_UNLCK = 2  // unlock
@extern("C", "F_WRLCK")
public const c_F_WRLCK = 3  // exclusive or write lock


public func open (fname: *[]ConstChar, opt: Word32, ...) -> Int
public func creat (fname: *[]ConstChar, mode: ModeT) -> Int
public func fcntl (fd: Int, op: Int, ...) -> Int



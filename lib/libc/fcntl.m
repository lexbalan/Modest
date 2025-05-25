// libc/fcntl.m

pragma module_nodecorate

include "libc/ctypes"
include "libc/stat"

// open-only flags
@set("id.c", "O_RDONLY")
public const c_O_RDONLY = Int32 0x00000000    // open for reading only
@set("id.c", "O_WRONLY")
public const c_O_WRONLY = Int32 0x00000001    // open for writing only
@set("id.c", "O_RDWR")
public const c_O_RDWR = Int32 0x00000002      // open for reading and writing
@set("id.c", "O_ACCMODE")
public const c_O_ACCMODE = Int32 0x00000003   // mask for above modes

public const c_O_NONBLOCK = Int32 0x00000004  // no delay
public const c_O_APPEND = Int32 0x00000008    // set append mode

@set("id.c", "O_CREAT")
public const c_O_CREAT = Int32 0x00000200     // create if nonexistent
@set("id.c", "O_TRUNC")
public const c_O_TRUNC = Int32 0x00000400     // truncate to zero length
@set("id.c", "O_EXCL")
public const c_O_EXCL = Int32 0x00000800      // error if already exists


/*
 * Constants used for fcntl()
 */

// command values
public const c_F_DUPFD = 0           // duplicate file descriptor
public const c_F_GETFD = 1           // get file descriptor flags
public const c_F_SETFD = 2           // set file descriptor flags
public const c_F_GETFL = 3           // get file status flags
public const c_F_SETFL = 4           // set file status flags
public const c_F_GETOWN = 5          // get SIGIO/SIGURG proc/pgrp
public const c_F_SETOWN = 6          // set SIGIO/SIGURG proc/pgrp
public const c_F_GETLK = 7           // get record locking information
public const c_F_SETLK = 8           // set record locking information
public const c_F_SETLKW = 9          // f_SETLK, wait if blocked
public const c_F_CLOSEM = 10         // close all fds >= to the one given
public const c_F_MAXFD = 11          // return the max open fd
public const c_F_DUPFD_CLOEXEC = 12  // close on exec duplicated fd
public const c_F_GETNOSIGPIPE = 13   // get SIGPIPE disposition
public const c_F_SETNOSIGPIPE = 14   // set SIGPIPE disposition
public const c_F_GETPATH = 15        // get pathname associated with fd
public const c_F_ADD_SEALS = 16      // set seals
public const c_F_GET_SEALS = 17      // get seals

// file descriptor flags (f_GETFD, f_SETFD)
public const c_FD_CLOEXEC = 1        // close-on-exec flag

// record locking flags (F_GETLK, F_SETLK, F_SETLKW)
public const c_F_RDLCK = 1  // shared or read lock
public const c_F_UNLCK = 2  // unlock
public const c_F_WRLCK = 3  // exclusive or write lock


public func open (fname: *[]ConstChar, opt: Int, ...) -> Int
public func creat (fname: *[]ConstChar, mode: ModeT) -> Int
public func fcntl (fd: Int, op: Int, ...) -> Int



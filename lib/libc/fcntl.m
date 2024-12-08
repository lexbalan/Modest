// libc/fcntl.m

$pragma module_nodecorate

include "libc/ctypes"

// open-only flags
@property("value.id.c", "O_RDONLY")
public const o_RDONLY = 0x00000000    // open for reading only
@property("value.id.c", "O_WRONLY")
public const o_WRONLY = 0x00000001    // open for writing only
@property("value.id.c", "O_RDWR")
public const o_RDWR = 0x00000002      // open for reading and writing
@property("value.id.c", "O_ACCMODE")
public const o_ACCMODE = 0x00000003   // mask for above modes

public const o_NONBLOCK = 0x00000004  // no delay
public const o_APPEND = 0x00000008    // set append mode

@property("value.id.c", "O_CREAT")
public const o_CREAT = 0x00000200     // create if nonexistent
@property("value.id.c", "O_TRUNC")
public const o_TRUNC = 0x00000400     // truncate to zero length
@property("value.id.c", "O_EXCL")
public const o_EXCL = 0x00000800      // error if already exists


/*
 * Constants used for fcntl()
 */

// command values
public const f_DUPFD = 0           // duplicate file descriptor
public const f_GETFD = 1           // get file descriptor flags
public const f_SETFD = 2           // set file descriptor flags
public const f_GETFL = 3           // get file status flags
public const f_SETFL = 4           // set file status flags
public const f_GETOWN = 5          // get SIGIO/SIGURG proc/pgrp
public const f_SETOWN = 6          // set SIGIO/SIGURG proc/pgrp
public const f_GETLK = 7           // get record locking information
public const f_SETLK = 8           // set record locking information
public const f_SETLKW = 9          // f_SETLK, wait if blocked
public const f_CLOSEM = 10         // close all fds >= to the one given
public const f_MAXFD = 11          // return the max open fd
public const f_DUPFD_CLOEXEC = 12  // close on exec duplicated fd
public const f_GETNOSIGPIPE = 13   // get SIGPIPE disposition
public const f_SETNOSIGPIPE = 14   // set SIGPIPE disposition
public const f_GETPATH = 15        // get pathname associated with fd
public const f_ADD_SEALS = 16      // set seals
public const f_GET_SEALS = 17      // get seals

// file descriptor flags (f_GETFD, f_SETFD)
public const fd_CLOEXEC = 1        // close-on-exec flag

// record locking flags (F_GETLK, F_SETLK, F_SETLKW)
public const f_RDLCK = 1  // shared or read lock
public const f_UNLCK = 2  // unlock
public const f_WRLCK = 3  // exclusive or write lock


public func open (fname: *[]ConstChar, opt: Int, ...) -> Int
public func creat (fname: *[]ConstChar, mode: ModeT) -> Int
public func fcntl (fd: Int, op: Int, ...) -> Int



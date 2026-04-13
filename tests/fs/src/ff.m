//
// FatFs Module Application Interface Wrapper
//

include "libc/ctypes"

public type Nat = Nat32
public type Char = Char8
public type FResult = Int
public type FSizeT = Int
public type LBA_t = Nat
public type Word = Word32
public type DWord = Word64

@alias("c", "FIL")
public type Fil = {}
@alias("c", "DIR")
public type Dir = @public {}
public type FilInfo = @public {}
public type FATFS = @public {}
public type MKFS_PARM = @public {}


// Open or create a file
public func f_open (fp: *Fil, path: *[]Char, mode: Word8) -> FResult

// Close an open file object
public func f_close (fp: *Fil) -> FResult

// Read data from the file
public func f_read (fp: *Fil, buff: Ptr, btr: Nat, br: *Nat) -> FResult

// Write data to the file
public func f_write (fp: *Fil, buff: Ptr, btw: Nat, bw: *Nat) -> FResult

// Move file pointer of the file object
public func f_lseek (fp: *Fil, ofs: FSizeT) -> FResult

// Truncate the file
public func f_truncate (fp: *Fil) -> FResult

// Flush cached data of the writing file
public func f_sync (fp: *Fil) -> FResult

// Open a directory
public func f_opendir (dp: *Dir, path: *[]Char) -> FResult

// Close an open directory
public func f_closedir (dp: *Dir) -> FResult

// Read a directory item
public func f_readdir (dp: *Dir, fno: *FilInfo) -> FResult

// Find first file
public func f_findfirst (dp: *Dir, fno: *FilInfo, path: *[]Char, pattern: *[]Char) -> FResult

// Find next file
public func f_findnext (dp: *Dir, fno: *FilInfo) -> FResult

// Create a sub directory
public func f_mkdir (path: *[]Char) -> FResult

// Delete an existing file or directory
public func f_unlink (path: *[]Char) -> FResult

// Rename/Move a file or directory
public func f_rename (path_old: *[]Char, path_new: *[]Char) -> FResult

// Get file status
public func f_stat (path: *[]Char, fno: *FilInfo) -> FResult

// Change attribute of a file/dir
public func f_chmod (path: *[]Char, attr: Word8, mask: Word8) -> FResult

// Change timestamp of a file/dir
public func f_utime (path: *[]Char, fno: *FilInfo) -> FResult

// Change current directory
public func f_chdir (path: *[]Char) -> FResult

// Change current drive
public func f_chdrive (path: *[]Char) -> FResult

// Get current directory
public func f_getcwd (buff: *[]Char, len: Nat) -> FResult

// Get number of free clusters on the drive
public func f_getfree (path: *[]Char, nclst: *DWord, fatfs: **FATFS) -> FResult

// Get volume label
public func f_getlabel (path: *[]Char, label: *[]Char, vsn: *DWord) -> FResult

// Set volume label
public func f_setlabel (label: *[]Char) -> FResult


// Forward data to the stream
public func f_forward (fp: *Fil, f: *(x0: *Word8, x1: Nat) -> Nat, btf: Nat, bf: *Nat) -> FResult

// Allocate a contiguous block to the file
public func f_expand (fp: *Fil, fsz: FSizeT, opt: Word8) -> FResult

// Mount/Unmount a logical drive
public func f_mount (fs: *FATFS, path: *[]Char, opt: Word8) -> FResult

// Create a FAT volume
public func f_mkfs (path: *[]Char, opt: *MKFS_PARM, work: Ptr, len: Nat) -> FResult

// Divide a physical drive into some partitions
public func f_fdisk (pdrv: Word8, ptbl: *[]LBA_t, work: Ptr) -> FResult

// Set current code page
public func f_setcp (cp: Word) -> FResult

// Put a character to the file
public func f_putc (c: Char, fp: *Fil) -> Int

// Put a string to the file
public func f_puts (str: *[]Char, cp: *Fil) -> Int

// Put a formatted string to the file
public func f_printf (fp: *Fil, str: *[]Char, ...) -> Int

// Get a string from the file
public func f_gets (buff: *[]Char, len: Int, fp: *Fil) -> *[]Char


public func f_eof (fp: *Fil) -> Int
public func f_error (fp: *Fil) -> Word8
public func f_tell (fp: *Fil) -> FSizeT
public func f_size (fp: *Fil) -> FSizeT
public func f_rewind (fp: *Fil) -> FResult
public func f_rewinddir (dp: *Dir) -> FResult
public func f_rmdir (path: *[]Char) -> FResult
public func f_unmount (path: *[]Char) -> FResult



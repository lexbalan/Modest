
include "libc/stat"


public type Char = Char8
public type Int = Int32
public type Word = Word32
public type Nat = Nat32
public type Long = Int64
public type Size = Long

@alias('c', 'DIR')
public type Dir = {x: Nat32}


//	FSIZE_t	fsize;			/* File size */
//	WORD	fdate;			/* Modified date */
//	WORD	ftime;			/* Modified time */
//	BYTE	fattrib;		/* File attribute */
//#if FF_USE_LFN
//	TCHAR	altname[FF_SFN_BUF + 1];/* Alternative file name */
//	TCHAR	fname[FF_LFN_BUF + 1];	/* Primary file name */
//#else
//	TCHAR	fname[12 + 1];	/* File name */
//#endif
@alias('c', 'FILINFO')
public type Filinfo = @public {
	fsize: Nat32
	fdate: Word32
	ftime: Word32
	fattrib: Word8
	fname: [255+1]Char8
}

public func init () -> Int
public func deinit () -> Int

//FRESULT f_opendir (DIR* dp, const TCHAR* path);						/* Open a directory */
@alias('c', 'f_opendir')
public func opendir (dir: *Dir, path: *Str8) -> Int
//FRESULT f_readdir (DIR* dp, FILINFO* fno);							/* Read a directory item */
@alias('c', 'f_readdir')
public func readdir (dir: *Dir, finfo: *Filinfo) -> Int

//FRESULT f_unlink (const TCHAR* path);
@alias('c', 'f_unlink')
public func delete (path: *Str8) -> Int

public func chdir (path: *[]Char) -> Int
public func mkdir (path: *[]Char) -> Int
public func open (path: *[]Char, oflag: Word32) -> Int
public func stat (path: *[]Char, stat: *Stat) -> Int
public func fstat (fd: Int, stat: *Stat) -> Int
public func unlink (path: *[]Char) -> Int
public func write (fd: Int, buf: *[]Byte, len: Size) -> Int
public func read (fd: Int, buf: *[]Byte, len: Size) -> Int
public func lseek (fd: Int, offset: Long, origin: Int) -> Long
public func tell (fd: Int) -> Long
public func close (fd: Int) -> Int


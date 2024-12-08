// dirent.m

$pragma module_nodecorate

@property("type.id.c", "DIR")
public type Dir record {}

@property("type.id.c", "int")
type Int Int32
@property("type.id.c", "ino_t")
type InoT Nat32
@property("type.id.c", "off_t")
type OffT Nat32


@property("type.id.c", "struct dirent")
public type Dirent record {
	public d_ino: InoT			/* inode number */
	public d_off: OffT			/* offset to the next dirent */
	public d_reclen: Nat16		/* length of this record */
	public d_type: Nat8		/* type of file; not supported
						   by all file system types */
	public d_name: [256]Char8	/* filename */
}


/* File types for `d_type'.  */
@property("value.id.c", "DT_UNKNOWN")
public const dt_UNKNOWN = 0
@property("value.id.c", "DT_FIFO")
public const dt_FIFO = 1
@property("value.id.c", "DT_CHR")
public const dt_CHR = 2
@property("value.id.c", "DT_DIR")
public const dt_DIR = 4
@property("value.id.c", "DT_BLK")
public const dt_BLK = 6
@property("value.id.c", "DT_REG")
public const dt_REG = 8
@property("value.id.c", "DT_LNK")
public const dt_LNK = 10
@property("value.id.c", "DT_SOCK")
public const dt_SOCK = 12
@property("value.id.c", "DT_WHT")
public const dt_WHT = 14


public func opendir(dirname: *[]Char8) -> *Dir
public func closedir(dirp: *Dir) -> Int

public func readdir(dirp: *Dir) -> *Dirent
public func readdir_r(dirp: *Dir, entry: *Dirent, result: **Dirent) -> Int


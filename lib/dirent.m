// dirent.hm

@property("type.id.c", "DIR")
type Dir

@property("type.id.c", "int")
type Int Int32
@property("type.id.c", "ino_t")
type InoT Nat32
@property("type.id.c", "off_t")
type OffT Nat32


@property("type.id.c", "struct dirent")
type Dirent record {
	d_ino: InoT			/* inode number */
	d_off: OffT			/* offset to the next dirent */
	d_reclen: Nat16		/* length of this record */
	d_type: Nat8		/* type of file; not supported
							by all file system types */
	d_name: [256]Char8	/* filename */
}


/* File types for `d_type'.  */
@property("value.id.c", "DT_UNKNOWN")
const dt_UNKNOWN = 0
@property("value.id.c", "DT_FIFO")
const dt_FIFO = 1
@property("value.id.c", "DT_CHR")
const dt_CHR = 2
@property("value.id.c", "DT_DIR")
const dt_DIR = 4
@property("value.id.c", "DT_BLK")
const dt_BLK = 6
@property("value.id.c", "DT_REG")
const dt_REG = 8
@property("value.id.c", "DT_LNK")
const dt_LNK = 10
@property("value.id.c", "DT_SOCK")
const dt_SOCK = 12
@property("value.id.c", "DT_WHT")
const dt_WHT = 14


func opendir(dirname: *[]Char8) -> *Dir
func closedir(dirp: *Dir) -> Int

func readdir(dirp: *Dir) -> *Dirent
func readdir_r(dirp: *Dir, entry: *Dirent, result: **Dirent) -> Int


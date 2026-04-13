
include "libc/stat"


public type Char = Char8
public type Int = Int32
public type Word = Word32
public type Nat = Nat32
public type Long = Int64
public type Size = Long


public func init () -> Int
public func deinit () -> Int

public func chdir (path: *[]Char) -> Int
public func open (path: *[]Char, opt: Int, ...) -> Int
public func stat (path: *[]Char, stat: *Stat) -> Int
public func fstat (fd: Int, stat: *Stat) -> Int
public func unlink (path: *[]Char) -> Int
public func write (fd: Int, buf: *[]Byte, len: Size) -> Int
public func read (fd: Int, buf: *[]Byte, len: Size) -> Int
public func lseek (fd: Int, offset: Long, origin: Int) -> Long
public func tell (fd: Int) -> Long
public func close (fd: Int) -> Int


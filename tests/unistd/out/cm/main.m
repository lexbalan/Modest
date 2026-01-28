include "ctypes64"
include "stdio"
include "time"
include "unistd"
include "stdlib"
// getenv


public func main () -> Int {
	printf("unistd test\n")

	let pid: PIDT = getpid()
	printf("pid = %d\n", PIDT pid)

	let hid: Long = gethostid()
	printf("hostid = %ld\n", Long hid)

	// current control terminal
	var cterm: [128]Char8
	ctermid(&cterm)
	printf("ctermid = %s\n", *[128]Char8 &cterm)

	// current working directory
	var cwd: [128]Char8
	getcwd(&cwd, SizeT lengthof(cwd))
	printf("cwd = %s\n", *[128]Char8 &cwd)

	let tty: *[]Char = ttyname(0)
	printf("ttyname = %s\n", *[]Char tty)


	let s: *Str = getenv("PATH")
	printf("PATH = %s\n", *Str s)

	while true {
		printf("- hi\n")
		sleep(1)// time in seconds
	}

	return 0
}


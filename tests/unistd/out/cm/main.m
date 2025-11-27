include "ctypes64"
include "stdio"
include "time"
include "unistd"
include "stdlib"
// getenv


public func main () -> Int {
	printf("unistd test\n")

	let pid: PIDT = getpid()
	printf("pid = %d\n", pid)

	let hid: Long = gethostid()
	printf("hostid = %ld\n", hid)

	// current control terminal
	var cterm: [128]Char8
	ctermid(&cterm)
	printf("ctermid = %s\n", &cterm)

	// current working directory
	var cwd: [128]Char8
	getcwd(&cwd, SizeT lengthof(cwd))
	printf("cwd = %s\n", &cwd)

	let tty: *[]Char = ttyname(0)
	printf("ttyname = %s\n", tty)


	let s: *Str = getenv("PATH")
	printf("PATH = %s\n", s)

	while true {
		printf("- hi\n")
		sleep(1)
	}

	return 0
}


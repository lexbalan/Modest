include "ctypes64"
include "stdio"
include "time"
include "unistd"
include "stdlib"
// tests/unistd/src/main.m// getenv


public func main() -> Int {
	printf("unistd test\n")

	let pid = getpid()
	printf("pid = %d\n", pid)

	let hid = gethostid()
	printf("hostid = %ld\n", hid)

	// current control terminal
	var cterm: [128]Char8
	ctermid(&cterm)
	printf("ctermid = %s\n", &cterm)

	// current working directory
	var cwd: [128]Char8
	getcwd(&cwd, lengthof(cwd))
	printf("cwd = %s\n", &cwd)

	let tty = ttyname(0)
	printf("ttyname = %s\n", tty)


	let s = getenv("PATH")
	printf("PATH = %s\n", s)

	while true {
		printf("- hi\n")
		sleep(1)
	}

	return 0
}


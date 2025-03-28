include "ctypes64"
include "stdio"
include "time"
include "unistd"
include "stdlib"
// getenv


public func main() -> Int {
	stdio.printf("unistd test\n")

	let pid = unistd.getpid()
	stdio.printf("pid = %d\n", pid)

	let hid = unistd.gethostid()
	stdio.printf("hostid = %ld\n", hid)

	// current control terminal
	var cterm: [128]Char8
	unistd.ctermid(&cterm)
	stdio.printf("ctermid = %s\n", &cterm)

	// current working directory
	var cwd: [128]Char8
	unistd.getcwd(&cwd, lengthof(cwd))
	stdio.printf("cwd = %s\n", &cwd)

	let tty = unistd.ttyname(0)
	stdio.printf("ttyname = %s\n", tty)


	let s = stdlib.getenv("PATH")
	stdio.printf("PATH = %s\n", s)

	while true {
		stdio.printf("- hi\n")
		unistd.sleep(1)
	}

	return 0
}


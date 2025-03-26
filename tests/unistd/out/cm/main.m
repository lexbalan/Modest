
@c_include "stdio.h"
@c_include "time.h"
@c_include "unistd.h"
@c_include "stdlib.h"// getenv


public func main() -> Int {
	stdio.("unistd test\n")

	let pid = unistd.()
	stdio.("pid = %d\n", pid)

	let hid = unistd.()
	stdio.("hostid = %ld\n", hid)

	// current control terminal
	var cterm: [<str_value>]Char8
	unistd.(&cterm)
	stdio.("ctermid = %s\n", &cterm)

	// current working directory
	var cwd: [<str_value>]Char8
	unistd.(&cwd, lengthof(cwd))
	stdio.("cwd = %s\n", &cwd)

	let tty = unistd.(0)
	stdio.("ttyname = %s\n", tty)


	let s = stdlib.("PATH")
	stdio.("PATH = %s\n", s)

	while true {
		stdio.("- hi\n")
		unistd.(1)
	}

	return 0
}


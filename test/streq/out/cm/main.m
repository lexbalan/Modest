
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


const defaultPrompt = "# "

var prompt: [32]Char8 = [32]Char8 defaultPrompt


public func main() -> Int32 {
	var buffer: [32]Char8
	let s = *Str8 &buffer

	while true {
		stdio.printf("%s", *Str8 &prompt)
		stdio.fgets(&buffer, sizeof buffer, stdio.stdin)
		// convert first '\n' -> '\0'
		buffer[string.strcspn(s, "\n")] = "\x0"

		if *s == "exit" {
			break
		} else if s[0:3] == "set" {
			stdio.printf("SET\n")
		} else if s[0:3] == "get" {
			stdio.printf("GET\n")
		} else {
			stdio.printf("unknown command: %s\n", s)
		}
	}

	return 0
}


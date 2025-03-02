include "libc/stdio"
include "libc/stdlib"
include "libc/string"


const defaultPrompt =  "# "

var prompt: [32]Char8 = [32]Char8 defaultPrompt


public func main() -> Int32 {
	var buffer: [32]Char8
	let s = *Str8 &buffer

	while true {
		printf("%s", *Str8 &prompt)
		fgets(&buffer, sizeof(buffer), stdin)
		// convert first '\n' -> '\0'
		buffer[strcspn(s, "\n")] = '\0'

		if *s == 'exit' {
			break
		} else if s[0:3] == 'set' {
			printf("SET\n")
		} else if s[0:3] == 'get' {
			printf("GET\n")
		} else {
			printf("unknown command: %s\n", s)
		}
	}

	return 0
}


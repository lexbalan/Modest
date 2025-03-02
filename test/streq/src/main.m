include "libc/stdio"
include "libc/stdlib"
include "libc/string"


const defaultPrompt =  "# "

var prompt: [32]Char8 = defaultPrompt


public func main() -> Int32 {
	var input: [32]Char8
	let s = *Str8 &input

	while true {
		printf("%s", *Str8 &prompt)
		scanf("%s", s)

		if *s == 'beep' {
			printf("\a")
		} else if *s == 'exit' {
			break
		} else {
			printf("s = %s\n", s)
		}
	}

	return 0
}


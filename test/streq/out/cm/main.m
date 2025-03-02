
@c_include "stdio.h"
@c_include "stdlib.h"
@c_include "string.h"


const defaultPrompt = "# "

var prompt: [32]Char8 = defaultPrompt


public func main() -> Int32 {
	var input: [32]Char8
	let s = *Str8 &input

	while true {
		stdio.printf("%s", *Str8 &prompt)
		stdio.scanf("%s", s)

		if *s == "beep" {
			stdio.printf("\a")
		} else if *s == "exit" {
			break
		} else {
			stdio.printf("s = %s\n", s)
		}
	}

	return 0
}


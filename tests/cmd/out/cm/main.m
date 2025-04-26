include "stdio"
include "unistd"
include "ctype"

func char8ToInt(c: Char8) -> Int {
	return Int Word32 Word8 c
}



type Tokenizer record {input: *[]Char8, position: Nat32}


func gettok(t: *Tokenizer, output: *[]Char8, lim: Nat16) -> Nat16 {
	var c: Char8 = t.input[t.position]

	// skip blanks
	while true {
		c = t.input[t.position]
		if c != " " and c != "\t" {
			break
		}
		t.position = t.position + 1
	}

	// check if not EOS
	if c == "\n" or c == "\x0" {
		return 0
	}

	// handle token
	var outpos: Nat16 = 0

	c = t.input[t.position]
	if isalnum(char8ToInt(c)) {
		while isalnum(char8ToInt(c)) {
			output[outpos] = c
			t.position = t.position + 1
			outpos = outpos + 1
			c = t.input[t.position]
		}
		output[outpos] = "\x0"
	} else {
	}

	return outpos
}




var prompt: [32]Char8 = "# "
var prompt_len: Nat8 = 2
var inbuf: [1024]Char8

var tokensBuf: [4 * 1024]Char8
var tokensBufPos: Nat16
var tokens: [64]*Str8



func showPrompt() -> Unit {
	write(0, &prompt, SizeT prompt_len)
}

func push(token: *[]Char8, toklen: Nat16) -> Unit {
	printf("PUSH \"%s\"\n", token)
}

func tokenize(inbuf: *[]Char8, tokens: *[]*[]Char8) -> Unit {
	// Токенизируем строку
	var tokenizer: Tokenizer = {
		position = 0
		input = inbuf
	}
	while true {
		let max_toklen: Nat16 = 128
		var token: [max_toklen]Char8

		var p: *Char8 = &tokensBuf[tokensBufPos]
		let toklen: Nat16 = gettok(&tokenizer, &token, max_toklen)
		if toklen == 0 {
			break
		}

		//
		tokensBuf[tokensBufPos:tokensBufPos + toklen] = token[0:toklen]
		push(&token, toklen)
	}
}


public func main() -> Int32 {
	printf("HARSH v0.1\n")

	while true {
		showPrompt()
		fgets(&inbuf, sizeof inbuf, stdin)
		var tokens: [64]*[]Char8
		tokenize(&inbuf, &tokens)
	}
	return 0
}


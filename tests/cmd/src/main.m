
include "libc/stdio"
include "libc/unistd"
include "libc/ctype"


@inline
func char8ToInt(c: Char8) -> Int {
	return Int Word32 Word8 c
}



type Tokenizer record {
	input: *[]Char8
	position: Nat32
	tokensBufPos: Nat16
	tokensPos: Nat16

	tokensBuf: *[]Char8
	tokens: *[]*[]Char8
}


func gettok(t: *Tokenizer, output: *[]Char8, lim: Nat16) -> Nat16 {
	var c = t.input[t.position]

	// skip blanks
	while true {
		c = t.input[t.position]
		if c != ' ' and c != '\t' {
			break
		}
		++t.position
	}

	// check if not EOS
	if c == '\n' or c == '\0' {
		return 0
	}

	// handle token
	var outpos: Nat16 = 0

	c = t.input[t.position]
	if isalnum(char8ToInt(c)) {
		while isalnum(char8ToInt(c)) {
			output[outpos] = c
			++t.position
			++outpos
			c = t.input[t.position]
		}
		output[outpos] = '\0'
	} else {

	}

	return outpos
}




var prompt: [32]Char8 = "# "
var prompt_len: Nat8 = 2


var tokensBuf: [4*1024]Char8




func showPrompt() {
	write(0, &prompt, SizeT prompt_len)
}


func tokenize(tokenizer: *Tokenizer) {
	while true {
		let max_toklen: Nat16 = 128
		var token: [max_toklen]Char8

		var p = &tokenizer.tokensBuf[tokenizer.tokensBufPos]
		let toklen = gettok(tokenizer, &token, max_toklen)
		if toklen == 0 {
			break
		}

		// save token in tokens buffer
		let pbuf = &tokenizer.tokensBuf[tokenizer.tokensBufPos:]
		pbuf[:toklen] = token[:toklen]
		tokenizer.tokensBufPos = tokenizer.tokensBufPos+toklen
		pbuf[tokenizer.tokensBufPos] = '\0'
		++tokenizer.tokensBufPos
		// save pointer to token
		tokenizer.tokens[tokenizer.tokensPos] = pbuf
		++tokenizer.tokensPos
	}
}


public func main() -> Int32 {
	printf("HARSH v0.1\n")

	var inbuf: [1024]Char8

	while true {
		showPrompt()
		fgets(&inbuf, sizeof(inbuf), stdin)
		var tokens: [64]*[]Char8

		// Токенизируем строку
		var tokenizer = Tokenizer {
			input=&inbuf
			tokensBuf=&tokensBuf
			tokens=&tokens
		}
		tokenize(&tokenizer)

		var i = Nat16 0
		while i < tokenizer.tokensPos {
			printf("token: '%s'\n", tokens[i])
			++i
		}
	}
	return 0
}




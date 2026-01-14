
pragma unsafe

include "libc/stdio"
include "libc/unistd"
include "libc/ctype"


const prompt = "# "


var tokensBuf: [4*1024]Char8


func showPrompt() -> Unit {
	var _prompt: [32]Char8 = prompt
	write(0, &_prompt, SizeT lengthof(prompt))
}


@unused
@inline
func char8ToInt (c: Char8) -> Int {
	return Int Word32 Word8 c
}


type Tokenizer = record {
	input: *[]Char8
	position: Nat32
	tokensBufPos: Nat16
	tokensPos: Nat16

	tokensBuf: *[]Char8
	tokens: *[]*[]Char8
}


func is_blank (c: Char8) -> Bool {
	return c == ' ' or c == '\n'
}


func gettok (t: *Tokenizer, output: *[]Char8, lim: Nat16) -> Nat16 {
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
	//if isalnum(char8ToInt(c)) {
	if not is_blank(c) {
		while not is_blank(c) {
			output[outpos] = c
			++t.position
			++outpos
			c = t.input[t.position]
		}
		output[outpos] = '\0'
	} else {
		output[outpos] = c
		++t.position
		++outpos
	}

	return outpos
}


func tokenize (tokenizer: *Tokenizer) -> Unit {
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
		tokenizer.tokens[tokenizer.tokensPos] = nil
	}
}


func execute (cmd: *Str8, argc: Nat16, argv: *[]*Str8) -> Unit {
	printf("%s (n=%d)", cmd, argc)
	printf(" [")
	var i: Nat32 = 0
	while true {
		let ptok = argv[i]
		if ptok == nil {
			break
		}
		printf("'%s'", ptok)
		++i
	}
	printf("]\n")
}


public func main () -> Int32 {
	printf("HARSH v0.1\n")

	var inbuf: [1024]Char8

	while true {
		showPrompt()
		fgets(&inbuf, unsafe Int sizeof(inbuf), stdin)

		var tokens: [64]*[]Char8 = []

		// Токенизируем строку
		var tokenizer = Tokenizer {
			input=&inbuf
			tokensBuf=&tokensBuf
			tokens=&tokens
		}
		tokenize(&tokenizer)

		// "выполняем" команду
		let cmd = tokenizer.tokens[0]
		var argc = tokenizer.tokensPos
		if argc > 0 {
			--argc
		}
		let argv = &tokenizer.tokens[1:]
		execute(cmd, argc, argv)
	}

	return 0
}



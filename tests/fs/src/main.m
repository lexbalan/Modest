// tests/fs/src/main.m

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/fcntl"
include "libc/stat"
include "libc/ctype"
include "libc/unistd"
include "libc/stdlib"
include "libc/string"

import "./sys"


const promptMaxLen = 32
var prompt = [promptMaxLen+1]Char8 "#"


type Tokenizer = {
	input: *[]Char8
	position: Nat32

	ntokens: Nat16
	tokens: *[]*[]Char8
}


func is_blank (c: Char8) -> Bool { return c == ' ' or c == '\n' }


func gettok (t: *Tokenizer, output: *[]Char8, lim: Nat16) -> Nat16 {
	Unit lim
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
		// get next token
		let tokenLenMax: Nat16 = 128
		var token: [tokenLenMax]Char8
		let toklen = gettok(tokenizer, &token, tokenLenMax)

		// there's no tokens
		if toklen == 0 {
			break
		}

		//let token = new token[:toklen] // z?
		var tok = *[toklen+1]Char8 malloc(SizeT toklen+1)
		*tok = token[:toklen]
		tok[toklen] = '\0'
		//printf("TOKEN = '%s'\n", tok)
		tokenizer.tokens[tokenizer.ntokens] = tok
		++tokenizer.ntokens
	}
}


type CmdHandler = (argc: Nat16, argv: *[]*Str8) -> Int32
// с анонимной записью не проканало тк она не задекларировала перед собой свои зависимости!
type CmdDescriptor = {id: *Str8, handler: *CmdHandler}


var commandHandlers: []CmdDescriptor = [
	{id='ls', handler=&cmdLs}
	{id='cd', handler=&cmdCd}
	{id='create', handler=&cmdCreate}
	{id='exit', handler=&cmdExit}
	{id='set_prompt', handler=&cmdSetPrompt}
]


func execute (cmd: *Str8, argc: Nat16, argv: *[]*Str8) -> Int32 {
	if false {
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

	var i: Nat32 = 0
	while i < lengthof(commandHandlers) {
		let h = &commandHandlers[i]
		//if *h.id == *cmd {
		if strcmp(h.id, cmd) == 0 {
			// call command handler
			return h.handler(argc, argv)
		}
		++i
	}

	printf("unknown command '%s'\n", cmd)
	return -1
}


public func main () -> Int32 {
	sys.init()

	printf("HARSH :) v0.1\n")

	var inbuf: [1024]Char8

	while true {
		printf("%s ", &prompt)
		fgets(&inbuf, unsafe Int sizeof(inbuf), stdin)

		var tokens: [64]*[]Char8 = []

		// Токенизируем строку
		var tokenizer = Tokenizer {
			input=&inbuf
			tokens=&tokens
		}
		tokenize(&tokenizer)

		// "выполняем" команду
		let cmd = tokenizer.tokens[0]
		let argc = tokenizer.ntokens
		let argv = &tokenizer.tokens[1:]
		execute(cmd, argc-1, argv)
	}

	sys.deinit()

	return 0
}


func cmdCreate (argc: Nat16, argv: *[]*Str8) -> Int32 {
	// "/A/hello.txt"
	var filename: *Str8
	filename = argv[0]
	printf("called create '%s'\n", filename)

	let fd = sys.open(filename, c_O_CREAT | c_O_RDONLY)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}
	sys.close(fd)

	return 0
}

func cmdLs (argc: Nat16, argv: *[]*Str8) -> Int32 {
	printf("called cmdLs\n")
	return 0
}

func cmdCd (argc: Nat16, argv: *[]*Str8) -> Int32 {
	printf("called cmdCd\n")
	return 0
}

func cmdExit (argc: Nat16, argv: *[]*Str8) -> Int32 {
	printf("called cmdExit\n")
	exit(0)
	return 0
}

func cmdSetPrompt (argc: Nat16, argv: *[]*Str8) -> Int32 {
	let newPrompt = argv[0]
	if strlen(newPrompt) > promptMaxLen {
		return -1
	}
	strncpy(&prompt, newPrompt, 32)
	return 0
}


/*
public func main () -> Int32 {
	var buf1: [32]Char8
	var buf2: [32]Char8

	sys.init()

	var rc: Int
	rc = sys.mkdir("/A/p")
	if rc != 0 {
		printf("cannot create directory %d\n", rc)
	}

	let fd = sys.open("/A/hello.txt", c_O_RDWR)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}

	// write file
	buf1 = "Hello World!"
	sys.write(fd, unsafe *[]Byte &buf1, 32)

	// read file
	sys.lseek(fd, 0, c_SEEK_SET)
	sys.read(fd, unsafe *[]Byte &buf2, 32)

	printf("buf2 = \"%s\"\n", &buf2)

	sys.close(fd)

	sys.deinit()

	return 0
}
*/

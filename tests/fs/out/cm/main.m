private import "builtin"
private import "./sys"
include "ctypes64"
include "stdio"
include "fcntl"
include "stat"
include "ctype"
include "unistd"
include "stdlib"
include "string"

import "./sys" as sys


const promptMaxLen = 32
var prompt = [promptMaxLen + 1]Char8 "#"


type Tokenizer = {
	input: *[]Char8
	position: Nat32

	ntokens: Nat16
	tokens: *[]*[]Char8
}


func is_blank (c: Char8) -> Bool {; return c == " " or c == "\n"
}


func gettok (t: *Tokenizer, output: *[]Char8, lim: Nat16) -> Nat16 {
	Unit lim
	var c: Char8 = t.input[t.position]
	while true {
		c = t.input[t.position]
		if c != " " and c != "\t" {
			break
		}
		t.position = t.position + 1
	}
	if c == "\n" or c == "\x0" {
		return 0
	}
	var outpos: Nat16 = 0

	c = t.input[t.position]
	if not is_blank(c) {
		while not is_blank(c) {
			output[outpos] = c
			t.position = t.position + 1
			outpos = outpos + 1
			c = t.input[t.position]
		}
		output[outpos] = "\x0"
	} else {
		output[outpos] = c
		t.position = t.position + 1
		outpos = outpos + 1
	}

	return outpos
}


func tokenize (tokenizer: *Tokenizer) -> Unit {
	while true {
		let max_toklen: Nat16 = 128
		var token: [max_toklen]Char8
		let toklen: Nat16 = gettok(tokenizer, &token, max_toklen)
		if toklen == 0 {
			break
		}
		var tok = *[toklen + 1]Char8 malloc(SizeT toklen + 1)
		*tok = token[0:toklen]
		tok[toklen] = "\x0"
		tokenizer.tokens[tokenizer.ntokens] = tok
		tokenizer.ntokens = tokenizer.ntokens + 1
	}
}


type CmdHandler = (argc: Nat16, argv: *[]*Str8) -> Int32
// с анонимной записью не проканало тк она не задекларировала перед собой свои зависимости!
type CmdDescriptor = {id: *Str8, handler: *CmdHandler}


var commandHandlers: [5]CmdDescriptor = [
	{id = "ls", handler = &cmdLs}
	{id = "cd", handler = &cmdCd}
	{id = "create", handler = &cmdCreate}
	{id = "exit", handler = &cmdExit}
	{id = "set_prompt", handler = &cmdSetPrompt}
]


func execute (cmd: *Str8, argc: Nat16, argv: *[]*Str8) -> Int32 {
	if false {
		printf("%s (n=%d)", cmd, argc)
		printf(" [")
		var i: Nat32 = 0
		while true {
			let ptok: *Str8 = argv[i]
			if ptok == nil {
				break
			}
			printf("'%s'", ptok)
			i = i + 1
		}
		printf("]\n")
	}

	var i: Nat32 = 0
	while i < lengthof(commandHandlers) {
		let h: *CmdDescriptor = &commandHandlers[i]
		if strcmp(h.id, cmd) == 0 {
			return h.handler(argc, argv)
		}
		i = i + 1
	}

	printf("unknown command '%s'\n", cmd)
	return -1
}


public func main () -> Int32 {
	init()

	printf("HARSH :) v0.1\n")

	var inbuf: [1024]Char8

	while true {
		printf("%s ", &prompt)
		fgets(&inbuf, unsafe Int sizeof inbuf, stdin)

		var tokens: [64]*[]Char8 = []
		var tokenizer: Tokenizer = Tokenizer {
			input = &inbuf
			tokens = &tokens
		}
		tokenize(&tokenizer)
		let cmd: *[]Char8 = tokenizer.tokens[0]
		let argc: Nat16 = tokenizer.ntokens
		let argv: *[]*[]Char8 = &tokenizer.tokens[1:]
		execute(cmd, argc - 1, argv)
	}

	deinit()

	return 0
}


func cmdCreate (argc: Nat16, argv: *[]*Str8) -> Int32 {
	var filename: *Str8
	filename = argv[0]
	printf("called create '%s'\n", filename)

	let fd: Int = open(filename, c_O_CREAT | c_O_RDONLY)
	if fd < 0 {
		printf("cannot open file (error = %d)\n", fd)
		return -1
	}
	close(fd)

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
	let newPrompt: *Str8 = argv[0]
	if strlen(newPrompt) > promptMaxLen {
		return -1
	}
	strncpy(&prompt, newPrompt, 32)
	return 0
}


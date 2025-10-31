// tests/lex/main.m

pragma unsafe

include "libc/stdio"
include "libc/ctype"
include "libc/libc"


const filename = *Str8 "file.txt"

const tokenId = 1
const tokenNum = 2
const tokenSym = 3

type Lexer = record {
	fd: *File
	cc: [2]Char8
	nback: Nat8

	ttype: Nat16
	token: [256]Char8
	toklen: Nat16
}

var lex: Lexer


func init (object: *Lexer) -> Unit {
	object.toklen = 0
}


func is_alpha (c: Char8) -> Bool {
	return isalpha(Int unsafe Word32 c)
}

func is_digit (c: Char8) -> Bool {
	return isdigit(Int unsafe Word32 c)
}

@inline
func getcc (lex: *Lexer) -> Char8 {
	let c = fgetc(lex.fd)
	return Char8 unsafe Word8 Word32 c
}

@inline
func putcc (lex: *Lexer, c: Char8) -> Unit {
	ungetc(Int Word32 Word8 c, lex.fd)
}

const eof = Char8 Word8 0xff

func gettok (lex: *Lexer) -> Bool {
	lex.toklen = 0
	var c = getcc(lex)

	// skip blanks
	while c == ' ' or c == '\t' {
		c = getcc(lex)
	}

	if is_alpha(c) or c == '_' {
		lex.ttype = tokenId
		while is_alpha(c) or is_digit(c) or c == '_' {
			lex.token[lex.toklen] = c
			++lex.toklen
			c = getcc(lex)
		}
	} else if is_digit(c) {
		lex.ttype = tokenNum
		while is_alpha(c) or is_digit(c) or c == '_' {
			lex.token[lex.toklen] = c
			++lex.toklen
			c = getcc(lex)
		}
	} else {
		lex.ttype = tokenSym

		if c == '-' {
			lex.token[lex.toklen] = c
			++lex.toklen

			c = getcc(lex)
			if c == '>' {
				lex.token[lex.toklen] = c
				++lex.toklen
			} else {
				putcc(lex, c)
			}
		} else if c == eof {
			return false
		} else {
			lex.token[lex.toklen] = c
			++lex.toklen
		}
	}

	lex.token[lex.toklen] = '\0'
	return true
}


public func main () -> Int {
	printf("text_file example\n")

	var lexer: Lexer
	init(&lexer)
	lexer.fd = fopen(filename, "r")
	while true {
		let rc = gettok(&lexer)
		if not rc {
			printf(">> END.\n")
			break
		}
		printf("TOKEN = '%s'\n", &lexer.token)
	}

	fclose(lexer.fd)
	return 0
}



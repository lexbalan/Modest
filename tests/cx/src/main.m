// examples/0.endianness/src/main.m

module "endianess/main"

pragma unsafe

include "libc/ctypes64"
include "libc/stdio"
include "libc/stdlib"
include "libc/string"
include "libc/unistd"
include "libc/fcntl"


var errcnt: Nat32
const errcntMax: Nat32 = 10

var fsrc: *File
var fout: Int
var eof: Bool
var ch: Char8
var lineno: Nat32

var token: [128]Char8
type TokenType = @brand Word8
const tokenTypeEof = TokenType 0
const tokenTypeId = TokenType 1
const tokenTypeNumber = TokenType 2
const tokenTypeSymbol = TokenType 3
var tokenType: TokenType
var tokenLen: Nat32


type TypeKind = @brand Word8
const typeUnknown = TypeKind 0
const typeChar = TypeKind 1
const typeInt = TypeKind 2
const typeArray = TypeKind 10
const typePointer = TypeKind 10


type Type = record {
	kind: TypeKind
}


func error (format: *Str8, ...) -> Unit {
	var va: __VA_List

	printf("%d : \x1B[31merror: \x1B[0m", lineno)
	fflush(stdout)

	__va_start(va, format)

	let strMaxLen = 255
	var buf: [strMaxLen+1]Char8
	let n = vsnprintf(&buf, strMaxLen, format, va)

	__va_end(va)

	write(c_STDOUT_FILENO, &buf, SizeT n)
	puts("")

	++errcnt
	if errcnt > errcntMax {
		exit(1)
	}
}


func gen (format: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, format)
	let strMaxLen = 512
	var buf: [strMaxLen+1]Char8
	let n = vsnprintf(&buf, strMaxLen, format, va)
	write(fout, &buf, SizeT n)
	__va_end(va)
}

func op (format: *Str8, ...) -> Unit {
	var va: __VA_List
	__va_start(va, format)
	let strMaxLen = 512
	var buf: [strMaxLen+1]Char8 = ['\t']
	let n = vsnprintf(&buf[1:], strMaxLen-1, format, va)
	write(fout, &buf, SizeT n + 1)
	__va_end(va)
}


func ord (x: Char8) -> Nat8 {
	return Nat8 Word8 x
}

func islower (x: Char8) -> Bool {
	return (ord(x) >= ord('a')) and (ord(x) <= ord('z'))
}

func isupper (x: Char8) -> Bool {
	return (ord(x) >= ord('A')) and (ord(x) <= ord('Z'))
}

func isalpha (x: Char8) -> Bool {
	return islower(x) or isupper(x)
}

func isdigit (x: Char8) -> Bool {
	return (ord(x) >= ord('0')) and (ord(x) <= ord('9'))
}


func nexch () -> Unit {
	let c = fgetc(fsrc)
	if c == c_EOF {
		eof = true
	}
	ch = unsafe Char8 c
}


func skipBlanks () -> Unit {
	while ch == '\n' or ch == ' ' or ch == '\t' {
		if ch == '\n' {
			++lineno
		}
		nexch()
	}
}


func sweep () -> Nat32 {
	var n: Nat32 = 0
	while isalpha(ch) or isdigit(ch) or ch == '_' {
		token[n] = ch
		nexch()
		++n
	}
	return n
}

// give next token
func next () -> Unit {
	skipBlanks()

	var n: Nat32 = 0

	if isalpha(ch) or ch == '_' {
		tokenType = tokenTypeId
		n = sweep()
	} else if isdigit(ch) {
		tokenType = tokenTypeNumber
		n = sweep()
	} else if not eof {
		tokenType = tokenTypeSymbol
		token[0] = ch
		n = 1
		nexch()
	} else {
		tokenType = tokenTypeEof
	}

	token[n] = '\0'
	tokenLen = n
}

func skip() -> Unit {
	next()
}

func looks (s: *Str8) -> @unused Bool {
	if unsafe Nat32 strlen(s) != tokenLen {
		return false
	}
	return token[0:tokenLen] == s[0:tokenLen]
}

func need (s: *Str8) -> @unused Bool {
	if looks(s) {
		skip()
		return true
	}
	error("expected '%s'\n", s)
	return false
}

func checkId (s: *Str8) -> Bool {
	if tokenType != tokenTypeId {
		return false
	}
	return looks(s)
}

func matchId (s: *Str8) -> Bool {
	if checkId(s) {
		skip()
		return true
	}
	return false
}

func match (s: *Str8) -> Bool {
	if looks(s) {
		skip()
		return true
	}
	return false
}



func scan_num () -> Nat32 {
	var x: Nat32 = 0
	sscanf(&token, "%i", &x)
	skip()
	return x
}

func scan_reg () -> Nat8 {
	var x: Nat32 = 0
	sscanf(&token[1:], "%d", &x)
	skip()
	return unsafe Nat8 x
}


func show () -> Unit {
	printf("<< '%s' >>\n", &token)
}


func do_value () -> Unit {
	h1()
}


func h1 () -> Unit {
	h0()
}

func h0 () -> Unit {
	if tokenType == tokenTypeId {
		printf("expr.id = %s\n", &token)
		skip()
	} else if tokenType == tokenTypeNumber {
		var value: Int
		sscanf(&token, "%i", &value)
		printf("expr.num = %d\n", value)
		skip()
	}
}



func do_type () -> Unit {
	printf("type = %s\n", &token)
	skip()
}

func do_const () -> Unit {
	need("const")
	printf("const %s\n", &token)
	gen(".equ %s, ", &token)
	skip()
	if match(":") {
		do_type()
	}
	if match("=") {
		gen("%s\n", &token)
		do_value()
	}
}

func do_var () -> Unit {
	gen(".data\n")

	need("var")
	printf("var %s\n", &token)
	gen("%s: word 0\n", &token)
	skip()
	if match(":") {
		do_type()
	}
	if match("=") {
		do_value()
	}
}




func do_stmt_block () -> Unit {
	need("{")
	while not (looks("}") or eof) {
		do_stmt()
	}
	need("}")
}

func do_stmt_return () -> Unit {
	need("return")
	op("ret\n")
}

func do_stmt_if () -> Unit {
	need("if")
	op("if\n")
	do_value()
	do_stmt_block()
	if match("else") {
		if looks("if") {
			do_stmt_if()
		} else {
			do_stmt_block()
		}
	}
}

func do_stmt () -> Unit {
	if looks("{") {
		do_stmt_block()
	} else if looks("if") {
		do_stmt_if()
	} else if looks("return") {
		do_stmt_return()
	}
}


func do_arg () -> Unit

func do_func () -> Unit {
	need("func")
	gen(".text\n")
	printf("func %s ", &token)
	gen("%s:\n", &token)
	prolog()
	next()
	need("(")
	while not (looks(")") or eof) {
		printf("%s,", &token); next()
		match(",")
	}
	printf("\n")
	need(")")
	do_stmt_block()
	epilog()
	printf("\n")
}


func cc (input: *Str, output: *Str) -> Unit {
	fsrc = fopen(input, "r")

	if fsrc == nil {
		error("cannot open input file '%s'", input)
		return
	}

	//fout = creat(output, 0x1BC)
	fout = open(output, c_O_WRONLY)

	if fout < 0 {
		error("cannot open output file '%s'", output)
		return
	}

	nexch() // загружаем первый символ в ch буфер
	next()  // загружаем первый токен в token буфер

	while not eof {
		if looks("func") {
			do_func()
		} else if looks("const") {
			do_const()
		} else if looks("var") {
			do_var()
		} else {
			error("unexpected token '%s'", &token)
			skip()
		}
	}

	fclose(fsrc)
	close(fout)
}



public func main () -> Int {
	cc("main.x", "out.s")

	return Int Word8(errcnt > 0)
}



func prolog () -> Unit {
	op("prolog;\n")
}

func epilog () -> Unit {
	op("epilog;\n")
}



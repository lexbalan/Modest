include "ctypes64"
include "stdio"
include "stdlib"
include "string"
include "unistd"



var fp: *File
var eof: Bool
var ch: Char8
var lineno: Nat32

var token: [128]Char8
type TokenType = @distinct Word8
const tokenTypeEof = TokenType 0
const tokenTypeId = TokenType 1
const tokenTypeNum = TokenType 2
const tokenTypeSym = TokenType 3
var tokenType: TokenType
var tokenLen: Nat32



func error (format: *Str8, ...) -> Unit {
	var va: va_list

	printf("\x0[31merror:\x0[0m")

	__va_start(va, format)

	let strMaxLen = 255
	var buf: [strMaxLen + 1]Char8
	let n: Int = vsnprintf(&buf, strMaxLen, format, va)

	__va_end(va)

	write(c_STDOUT_FILENO, &buf, SizeT n)
}


func ord (x: Char8) -> Nat8 {
	return Nat8 Word8 x
}

func islower (x: Char8) -> Bool {
	return (ord(x) >= ord("a")) and (ord(x) <= ord("z"))
}

func isupper (x: Char8) -> Bool {
	return (ord(x) >= ord("A")) and (ord(x) <= ord("Z"))
}

func isalpha (x: Char8) -> Bool {
	return islower(x) or isupper(x)
}

func isdigit (x: Char8) -> Bool {
	return (ord(x) >= ord("0")) and (ord(x) <= ord("9"))
}


func nexch () -> Unit {
	let c: Int = fgetc(fp)
	if c == c_EOF {
		eof = true
	}
	ch = unsafe Char8 c
}


func skipBlanks () -> Unit {
	while ch == "\n" or ch == " " or ch == "\t" {
		if ch == "\n" {
			lineno = lineno + 1
		}
		nexch()
	}
}


func sweep () -> Nat32 {
	var n: Nat32 = 0
	while isalpha(ch) or isdigit(ch) or ch == "_" {
		token[n] = ch
		nexch()
		n = n + 1
	}
	return n
}

// give next token
func next () -> Unit {
	skipBlanks()

	var n: Nat32 = 0

	if isalpha(ch) or ch == "_" {
		tokenType = tokenTypeId
		n = sweep()
	} else if isdigit(ch) {
		tokenType = tokenTypeNum
		n = sweep()
	} else if not eof {
		tokenType = tokenTypeSym
		token[0] = ch
		n = 1
		nexch()
	} else {
		tokenType = tokenTypeEof
	}

	token[n] = "\x0"
	tokenLen = n
}

func skip () -> Unit {
	next()
}

func looks (s: *Str8) -> Bool {
	if unsafe Nat32 strlen(s) != tokenLen {
		return false
	}
	return token[0:tokenLen] == s[0:tokenLen]
}

func need (s: *Str8) -> Bool {
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


func scan_imm () -> Nat32 {
	var x: Nat32 = scan_num()
	if x >= Nat32 0x00FFFFFF {
		x = 0
		error("too big immediate value")
	}
	return x
}



func show () -> Unit {
	printf("<< '%s' >>\n", &token)
}



func do_var () -> Unit {
	printf("var %s", &token)
	next()
	need(":")
	printf(", type = %s\n", &token)
	next()
}

func do_func () -> Unit {
	printf("func %s ", &token)
	next()
	need("(")
	while not looks(")") {
		printf("%s", &token)next()
		match(",")
	}
	need(")")
	//printf(", type = %s\n", &token)
	//next()
	printf("\n")
}


func cc (filename: *Str) -> Unit {
	fp = fopen(filename, "r")

	if fp == nil {
		error("cannot open file", filename)
		return
	}

	nexch()// загружаем первый символ в ch буфер
	next()// загружаем первый токен в token буфер

	while tokenType != tokenTypeEof {
		if matchId("func") {
			do_func()
		} else if matchId("var") {
			do_var()
		}
	}

	fclose(fp)
}


func parseAsm (filename: *Str) -> Unit {
	fp = fopen(filename, "r")

	if fp == nil {
		error("cannot open file")
		return
	}

	nexch()// загружаем первый символ в ch буфер
	next()// загружаем первый токен в token буфер

	while tokenType != tokenTypeEof {
		if matchId("text") {
			printf("TEXT\n")
		}

		if matchId("proc") {
			printf("PROC: %s\n", &token)
			next()
		}

		if matchId("li") {
			var reg: Nat8
			var imm: Nat32
			reg = scan_reg()
			need(",")
			imm = scan_imm()
			emit_ri("li", reg, imm)
		} else if matchId("add") {
			var r0: Nat8
			var r1: Nat8
			var r2: Nat8
			r0 = scan_reg()
			need(",")
			r1 = scan_reg()
			need(",")
			r2 = scan_reg()
			emit_rrr("ADD", r0, r1, r2)
		} else if matchId("sub") {
			var r0: Nat8
			var r1: Nat8
			var r2: Nat8
			r0 = scan_reg()
			need(",")
			r1 = scan_reg()
			need(",")
			r2 = scan_reg()
			emit_rrr("SUB", r0, r1, r2)
		} else if matchId("ret") {
			emit_ret()
		}
	}

	fclose(fp)
}


func emit_rrr (op: *Str8, r0: Nat8, r1: Nat8, r2: Nat8) -> Unit {
	printf("%s r%d, r%d, r%d\n", op, Nat32 r0, Nat32 r1, Nat32 r2)
}

func emit_ri (op: *Str8, reg: Nat8, imm: Nat32) -> Unit {
	printf("%s r%d, %d\n", op, Nat32 reg, imm)
}

func emit_ret () -> Unit {
	printf("RET\n")
}


public func main () -> Int {
	//parseAsm("example.s")
	cc("main2.x")

	return 0
}


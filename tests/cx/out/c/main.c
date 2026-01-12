
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

#include <stdarg.h>


static uint32_t errcnt;
#define ERRCNT_MAX  (10)

static FILE *fsrc;
static int fout;
static bool eof;
static char ch;
static uint32_t lineno;

static char token[128];
typedef uint8_t TokenType;
#define TOKEN_TYPE_EOF  ((TokenType)0)
#define TOKEN_TYPE_ID  ((TokenType)1)
#define TOKEN_TYPE_NUMBER  ((TokenType)2)
#define TOKEN_TYPE_SYMBOL  ((TokenType)3)
static TokenType tokenType;
static uint32_t tokenLen;

typedef uint8_t TypeKind;
#define TYPE_UNKNOWN  ((TypeKind)0)
#define TYPE_CHAR  ((TypeKind)1)
#define TYPE_INT  ((TypeKind)2)
#define TYPE_ARRAY  ((TypeKind)10)
#define TYPE_POINTER  ((TypeKind)10)

struct Type {
	TypeKind kind;
};
typedef struct Type Type;

static void error(char *format, ...) {
	va_list va;

	printf("%d : \x1B[31merror: \x1B[0m", lineno);
	fflush(stdout);

	va_start(va, format);

	#define strMaxLen  255
	char buf[strMaxLen + 1];
	const int n = vsnprintf((char *)&buf, strMaxLen, format, va);

	va_end(va);

	write(STDOUT_FILENO, (void *)&buf, (size_t)abs((int)n));
	puts("");

	errcnt = errcnt + 1;
	if (errcnt > ERRCNT_MAX) {
		exit(1);
	}

#undef strMaxLen
}


static void gen(char *format, ...) {
	va_list va;
	va_start(va, format);
	#define strMaxLen  512
	char buf[strMaxLen + 1];
	const int n = vsnprintf((char *)&buf, strMaxLen, format, va);
	write(fout, (void *)&buf, (size_t)abs((int)n));
	va_end(va);

#undef strMaxLen
}


static void op(char *format, ...) {
	va_list va;
	va_start(va, format);
	#define strMaxLen  512
	char buf[strMaxLen + 1] = {"\t"};
	const int n = vsnprintf(&buf[1], strMaxLen - 1, format, va);
	write(fout, (void *)&buf, (size_t)abs((int)n) + 1);
	va_end(va);

#undef strMaxLen
}


static uint8_t ord(char x) {
	return (uint8_t)x;
}


static bool islower(char x) {
	return (ord(x) >= ord('a')) && (ord(x) <= ord('z'));
}


static bool isupper(char x) {
	return (ord(x) >= ord('A')) && (ord(x) <= ord('Z'));
}


static bool isalpha(char x) {
	return islower(x) || isupper(x);
}


static bool isdigit(char x) {
	return (ord(x) >= ord('0')) && (ord(x) <= ord('9'));
}


static void nexch(void) {
	const int c = fgetc(fsrc);
	if (c == EOF) {
		eof = true;
	}
	ch = (char)c;
}


static void skipBlanks(void) {
	while (ch == '\n' || ch == ' ' || ch == '\t') {
		if (ch == '\n') {
			lineno = lineno + 1;
		}
		nexch();
	}
}


static uint32_t sweep(void) {
	uint32_t n = 0;
	while (isalpha(ch) || isdigit(ch) || ch == '_') {
		token[n] = ch;
		nexch();
		n = n + 1;
	}
	return n;
}


// give next token
static void next(void) {
	skipBlanks();

	uint32_t n = 0;

	if (isalpha(ch) || ch == '_') {
		tokenType = TOKEN_TYPE_ID;
		n = sweep();
	} else if (isdigit(ch)) {
		tokenType = TOKEN_TYPE_NUMBER;
		n = sweep();
	} else if (!eof) {
		tokenType = TOKEN_TYPE_SYMBOL;
		token[0] = ch;
		n = 1;
		nexch();
	} else {
		tokenType = TOKEN_TYPE_EOF;
	}

	token[n] = '\x0';
	tokenLen = n;
}


static void skip(void) {
	next();
}


static bool looks(char *s) {
	if ((uint32_t)strlen(s) != tokenLen) {
		return false;
	}
	return memcmp((char(*)[tokenLen - 0])&token[0], (char(*)[tokenLen - 0])&s[0], sizeof(char[tokenLen - 0])) == 0;
}


static bool need(char *s) {
	if (looks(s)) {
		skip();
		return true;
	}
	error("expected '%s'\n", s);
	return false;
}


static bool checkId(char *s) {
	if (tokenType != TOKEN_TYPE_ID) {
		return false;
	}
	return looks(s);
}


static bool matchId(char *s) {
	if (checkId(s)) {
		skip();
		return true;
	}
	return false;
}


static bool match(char *s) {
	if (looks(s)) {
		skip();
		return true;
	}
	return false;
}


static uint32_t scan_num(void) {
	uint32_t x = 0;
	sscanf((char *)&token, "%i", &x);
	skip();
	return x;
}


static uint8_t scan_reg(void) {
	uint32_t x = 0;
	sscanf(&token[1], "%d", &x);
	skip();
	return (uint8_t)x;
}


static uint32_t scan_imm(void) {
	uint32_t x = scan_num();
	if (x >= 0xFFFFFF) {
		x = 0;
		error("too big immediate value");
	}
	return x;
}


static void show(void) {
	printf("<< '%s' >>\n", (char *)&token);
}



static void h1(void);

static void do_value(void) {
	h1();
}



static void h0(void);

static void h1(void) {
	h0();
}


static void h0(void) {
	if (tokenType == TOKEN_TYPE_ID) {
		printf("expr.id = %s\n", (char *)&token);
		skip();
	} else if (tokenType == TOKEN_TYPE_NUMBER) {
		int value;
		sscanf((char *)&token, "%i", &value);
		printf("expr.num = %d\n", value);
		skip();
	}
}


static void do_type(void) {
	printf("type = %s\n", (char *)&token);
	skip();
}


static void do_const(void) {
	need("const");
	printf("const %s\n", (char *)&token);
	gen(".equ %s, ", (char *)&token);
	skip();
	if (match(":")) {
		do_type();
	}
	if (match("=")) {
		gen("%s\n", (char *)&token);
		do_value();
	}
}


static void do_var(void) {
	gen(".data\n");

	need("var");
	printf("var %s\n", (char *)&token);
	gen("%s: word 0\n", (char *)&token);
	skip();
	if (match(":")) {
		do_type();
	}
	if (match("=")) {
		do_value();
	}
}



static void do_stmt(void);

static void do_stmt_block(void) {
	need("{");
	while (!(looks("}") || eof)) {
		do_stmt();
	}
	need("}");
}


static void do_stmt_return(void) {
	need("return");
	op("ret\n");
}


static void do_stmt_if(void) {
	need("if");
	op("if\n");
	do_value();
	do_stmt_block();
	if (match("else")) {
		if (looks("if")) {
			do_stmt_if();
		} else {
			do_stmt_block();
		}
	}
}


static void do_stmt(void) {
	if (looks("{")) {
		do_stmt_block();
	} else if (looks("if")) {
		do_stmt_if();
	} else if (looks("return")) {
		do_stmt_return();
	}
}


static void do_arg(void);


static void prolog(void);
static void epilog(void);

static void do_func(void) {
	need("func");
	gen(".text\n");
	printf("func %s ", (char *)&token);
	gen("%s:\n", (char *)&token);
	prolog();
	next();
	need("(");
	while (!(looks(")") || eof)) {
		printf("%s,", (char *)&token);next();
		match(",");
	}
	printf("\n");
	need(")");
	do_stmt_block();
	epilog();
	printf("\n");
}


static void cc(char *input, char *output) {
	fsrc = fopen(input, "r");

	if (fsrc == NULL) {
		error("cannot open input file '%s'", input);
		return;
	}

	//fout = creat(output, 0x1BC)
	fout = open(output, O_WRONLY);

	if (fout < 0) {
		error("cannot open output file '%s'", output);
		return;
	}

	nexch();// загружаем первый символ в ch буфер
	next();// загружаем первый токен в token буфер

	while (!eof) {
		if (looks("func")) {
			do_func();
		} else if (looks("const")) {
			do_const();
		} else if (looks("var")) {
			do_var();
		} else {
			error("unexpected token '%s'", (char *)&token);
			skip();
		}
	}

	fclose(fsrc);
	close(fout);
}


int main(void) {
	cc("main.x", "out.s");

	return (int)(uint8_t)(errcnt > 0);
}


static void prolog(void) {
	op("prolog;\n");
}


static void epilog(void) {
	op("epilog;\n");
}



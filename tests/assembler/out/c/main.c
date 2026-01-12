
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <stdarg.h>


static FILE *fp;
static bool eof;
static char ch;
static uint32_t lineno;

static char token[128];
typedef uint8_t TokenType;
#define TOKEN_TYPE_EOF  (0x0)
#define TOKEN_TYPE_ID  (0x1)
#define TOKEN_TYPE_NUM  (0x2)
#define TOKEN_TYPE_SYM  (0x3)
static TokenType tokenType;
static uint32_t tokenLen;

//func error (s: *Str, ...) -> Unit {
//	printf("%d : error: %s\n", lineno, s)
//	exit(1)
//}

static ssize_t error(char *format, ...) {
	va_list va;

	va_start(va, format);

	#define strMaxLen  255
	char buf[strMaxLen + 1];
	const int n = vsnprintf((char *)&buf, strMaxLen, format, va);

	va_end(va);

	return write(STDOUT_FILENO, (void *)&buf, (size_t)abs((int)n));

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
	const int c = fgetc(fp);
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
		tokenType = TOKEN_TYPE_NUM;
		n = sweep();
	} else if (!eof) {
		tokenType = TOKEN_TYPE_SYM;
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


static void do_var(void) {
	printf("var %s", (char *)&token);
	next();
	need(":");
	printf(", type = %s\n", (char *)&token);
	next();
}


static void do_func(void) {
	printf("func %s ", (char *)&token);
	next();
	need("(");
	while (!looks(")")) {
		printf("%s", (char *)&token);next();
		match(",");
	}
	need(")");
	//printf(", type = %s\n", &token)
	//next()
	printf("\n");
}


static void cc(char *filename) {
	fp = fopen(filename, "r");

	if (fp == NULL) {
		error("cannot open file", filename);
		return;
	}

	nexch();// загружаем первый символ в ch буфер
	next();// загружаем первый токен в token буфер

	while (tokenType != TOKEN_TYPE_EOF) {
		if (matchId("func")) {
			do_func();
		} else if (matchId("var")) {
			do_var();
		}
	}

	fclose(fp);
}



static void emit_ri(char *op, uint8_t reg, uint32_t imm);
static void emit_rrr(char *op, uint8_t r0, uint8_t r1, uint8_t r2);
static void emit_ret(void);

static void parseAsm(char *filename) {
	fp = fopen(filename, "r");

	if (fp == NULL) {
		error("cannot open file");
		return;
	}

	nexch();// загружаем первый символ в ch буфер
	next();// загружаем первый токен в token буфер

	while (tokenType != TOKEN_TYPE_EOF) {
		if (matchId("text")) {
			printf("TEXT\n");
		}

		if (matchId("proc")) {
			printf("PROC: %s\n", (char *)&token);
			next();
		}

		if (matchId("li")) {
			uint8_t reg;
			uint32_t imm;
			reg = scan_reg();
			need(",");
			imm = scan_imm();
			emit_ri("li", reg, imm);
		} else if (matchId("add")) {
			uint8_t r0;
			uint8_t r1;
			uint8_t r2;
			r0 = scan_reg();
			need(",");
			r1 = scan_reg();
			need(",");
			r2 = scan_reg();
			emit_rrr("ADD", r0, r1, r2);
		} else if (matchId("sub")) {
			uint8_t r0;
			uint8_t r1;
			uint8_t r2;
			r0 = scan_reg();
			need(",");
			r1 = scan_reg();
			need(",");
			r2 = scan_reg();
			emit_rrr("SUB", r0, r1, r2);
		} else if (matchId("ret")) {
			emit_ret();
		}
	}

	fclose(fp);
}


static void emit_rrr(char *op, uint8_t r0, uint8_t r1, uint8_t r2) {
	printf("%s r%d, r%d, r%d\n", op, (uint32_t)r0, (uint32_t)r1, (uint32_t)r2);
}


static void emit_ri(char *op, uint8_t reg, uint32_t imm) {
	printf("%s r%d, %d\n", op, (uint32_t)reg, imm);
}


static void emit_ret(void) {
	printf("RET\n");
}


int main(void) {
	//parseAsm("example.s")
	cc("main.x");

	return 0;
}



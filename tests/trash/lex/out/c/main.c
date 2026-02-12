
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <math.h>

#include "main.h"


/* anonymous records */
struct __anonymous_struct_2 {int32_t ok;
};

#define filename  "file.txt"

#define tokenId  1
#define tokenNum  2
#define tokenSym  3

struct Lexer {
	FILE *fd;
	char cc[2];
	uint8_t nback;

	uint16_t ttype;
	char token[256];
	uint16_t toklen;
};
typedef struct Lexer Lexer;

static Lexer lex;

static struct __anonymous_struct_2 init(Lexer *object)
{
	object->toklen = 0;
	return (struct __anonymous_struct_2){.ok = 0};
}

static bool is_alpha(char c)
{
	return isalpha((int)(uint32_t)c);
}

static bool is_digit(char c)
{
	return isdigit((int)(uint32_t)c);
}

static inline char getcc(Lexer *lex)
{
	const int c = fgetc(lex->fd);
	return (char)(uint8_t)(uint32_t)c;
}

static inline void putcc(Lexer *lex, char c)
{
	ungetc((int)(uint32_t)(uint8_t)c, lex->fd);
}

#define eof  ((char)0xFF)

static bool gettok(Lexer *lex)
{
	lex->toklen = 0;
	char c = getcc(lex);

	// skip blanks
	while (c == ' ' || c == '\t') {
		c = getcc(lex);
	}

	if (is_alpha(c) || c == '_') {
		lex->ttype = tokenId;
		while (is_alpha(c) || is_digit(c) || c == '_') {
			lex->token[lex->toklen] = c;
			lex->toklen = lex->toklen + 1;
			c = getcc(lex);
		}
	} else if (is_digit(c)) {
		lex->ttype = tokenNum;
		while (is_alpha(c) || is_digit(c) || c == '_') {
			lex->token[lex->toklen] = c;
			lex->toklen = lex->toklen + 1;
			c = getcc(lex);
		}
	} else {
		lex->ttype = tokenSym;

		if (c == '-') {
			lex->token[lex->toklen] = c;
			lex->toklen = lex->toklen + 1;

			c = getcc(lex);
			if (c == '>') {
				lex->token[lex->toklen] = c;
				lex->toklen = lex->toklen + 1;
			} else {
				putcc(lex, c);
			}
		} else if (c == eof) {
			return false;
		} else {
			lex->token[lex->toklen] = c;
			lex->toklen = lex->toklen + 1;
		}
	}

	lex->token[lex->toklen] = '\x0';
	return true;
}

int main()
{
	printf("text_file example\n");

	Lexer lexer;
	init(&lexer);
	lexer.fd = fopen(filename, "r");
	while (true) {
		const bool rc = gettok(&lexer);
		if (!rc) {
			printf(">> END.\n");
			break;
		}
		printf("TOKEN = '%s'\n", &lexer.token);
	}

	fclose(lexer.fd);
	return 0;
}


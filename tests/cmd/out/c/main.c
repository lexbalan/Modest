
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>

#include "main.h"

#ifndef __lengthof
#define __lengthof(x) (sizeof(x) / sizeof((x)[0]))
#endif /* __lengthof */

#define ARRCPY(dst, src, len) for (uint32_t i = 0; i < (len); i++) { \
	(*dst)[i] = (*src)[i]; \
}

static inline int char8ToInt(char c)
{
	return (int)(uint32_t)(uint8_t)c;
}

struct Tokenizer {char *input; uint32_t position;
};
typedef struct Tokenizer Tokenizer;

static uint16_t gettok(Tokenizer *t, char *output, uint16_t lim)
{
	char c = t->input[t->position];

	// skip blanks
	while (true) {
		c = t->input[t->position];
		if (c != ' ' && c != '\t') {
			break;
		}
		t->position = t->position + 1;
	}

	// check if not EOS
	if (c == '\n' || c == '\x0') {
		return 0;
	}

	// handle token
	uint16_t outpos = 0;

	c = t->input[t->position];
	if (isalnum(char8ToInt(c))) {
		while (isalnum(char8ToInt(c))) {
			output[outpos] = c;
			t->position = t->position + 1;
			outpos = outpos + 1;
			c = t->input[t->position];
		}
		output[outpos] = '\x0';
	} else {
	}

	return outpos;
}

static char prompt[32] = "# ";
static uint8_t prompt_len = 2;
static char inbuf[1024];

static char tokensBuf[4 * 1024];
static uint16_t tokensBufPos;
static char *tokens[64];
static uint16_t tokensPos;

static void showPrompt()
{
	write(0, (char *)&prompt, (size_t)prompt_len);
}

static void tokenize(char *inbuf, char *(*tokens)[])
{
	// Токенизируем строку
	Tokenizer tokenizer = (Tokenizer){
		.position = 0,
		.input = inbuf
	};
	while (true) {
		const uint16_t max_toklen = 128;
		char token[max_toklen];

		char *p = &tokensBuf[tokensBufPos];
		const uint16_t toklen = gettok(&tokenizer, (char *)&token, max_toklen);
		if (toklen == 0) {
			break;
		}

		// save token in tokens buffer
		char *const pbuf = &tokensBuf[tokensBufPos];
		memcpy((char(*)[toklen - 0])&pbuf[0], (char(*)[toklen - 0])&token[0], sizeof(char[toklen - 0]));
		tokensBufPos = tokensBufPos + toklen;
		pbuf[tokensBufPos] = '\x0';
		tokensBufPos = tokensBufPos + 1;
		// save pointer to token
		(*tokens)[tokensPos] = pbuf;
		tokensPos = tokensPos + 1;
	}
}

int32_t main()
{
	printf("HARSH v0.1\n");

	while (true) {
		showPrompt();
		fgets((char *)&inbuf, sizeof inbuf, stdin);
		char *tokens[64];
		tokenize((char *)&inbuf, &tokens);

		uint16_t i = 0;
		while (i < tokensPos) {
			printf("token: '%s'\n", tokens[i]);
			i = i + 1;
		}
	}
	return 0;
}


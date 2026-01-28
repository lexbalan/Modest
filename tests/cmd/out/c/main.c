
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>

#ifndef LENGTHOF
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif /* LENGTHOF */


#define PROMPT  "# "

static char tokensBuf[4 * 1024];

static void showPrompt(void) {
	char _prompt[32] = {'#', ' '};
	write(0, (void *)&_prompt, (size_t)LENGTHOF(PROMPT));
}


__attribute__((always_inline, unused))
static inline int char8ToInt(char c) {
	return (int)(uint32_t)(uint8_t)c;
}


struct Tokenizer {
	char *input;
	uint32_t position;
	uint16_t tokensBufPos;
	uint16_t tokensPos;

	char *tokensBuf;
	char *(*tokens)[];
};
typedef struct Tokenizer Tokenizer;

static bool is_blank(char c) {
	return c == ' ' || c == '\n';
}


static uint16_t gettok(Tokenizer *t, char *output, uint16_t lim) {
	(void)lim;
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
	//if isalnum(char8ToInt(c)) {
	if (!is_blank(c)) {
		while (!is_blank(c)) {
			output[outpos] = c;
			t->position = t->position + 1;
			outpos = outpos + 1;
			c = t->input[t->position];
		}
		output[outpos] = '\x0';
	} else {
		output[outpos] = c;
		t->position = t->position + 1;
		outpos = outpos + 1;
	}

	return outpos;
}


static void tokenize(Tokenizer *tokenizer) {
	while (true) {
		const uint16_t max_toklen = 128;
		char token[max_toklen];

		char *p = &tokenizer->tokensBuf[tokenizer->tokensBufPos];
		const uint16_t toklen = gettok(tokenizer, &token[0], max_toklen);
		if (toklen == 0) {
			break;
		}

		// save token in tokens buffer
		char *const pbuf = &tokenizer->tokensBuf[tokenizer->tokensBufPos];
		memcpy((char *)&pbuf[0], (char *)&token[0], sizeof(char[toklen - 0]));
		tokenizer->tokensBufPos = tokenizer->tokensBufPos + toklen;
		pbuf[tokenizer->tokensBufPos] = '\x0';
		tokenizer->tokensBufPos = tokenizer->tokensBufPos + 1;
		// save pointer to token
		(*tokenizer->tokens)[tokenizer->tokensPos] = pbuf;
		tokenizer->tokensPos = tokenizer->tokensPos + 1;
		(*tokenizer->tokens)[tokenizer->tokensPos] = NULL;
	}
}


static void execute(char *cmd, uint16_t argc, char *(*argv)[]) {
	printf("%s (n=%d)", (char*)cmd, argc);
	printf(" [");
	uint32_t i = 0;
	while (true) {
		char *const ptok = (*argv)[i];
		if (ptok == NULL) {
			break;
		}
		printf("'%s'", (char*)ptok);
		i = i + 1;
	}
	printf("]\n");
}


int32_t main(void) {
	printf("HARSH v0.1\n");

	char inbuf[1024];

	while (true) {
		showPrompt();
		fgets(&inbuf[0], (int)sizeof inbuf, stdin);

		char *tokens[64] = {0};

		// Токенизируем строку
		Tokenizer tokenizer = (Tokenizer){
			.input = &inbuf[0],
			.tokensBuf = &tokensBuf[0],
			.tokens = &tokens
		};
		tokenize(&tokenizer);

		// "выполняем" команду
		char *const cmd = (*tokenizer.tokens)[0];
		uint16_t argc = tokenizer.tokensPos;
		if (argc > 0) {
			argc = argc - 1;
		}
		char *(*const argv)[] = &(*tokenizer.tokens)[1];
		execute(cmd, argc, /*ParamIsPtr2Arr*/argv);
	}

	return 0;
}



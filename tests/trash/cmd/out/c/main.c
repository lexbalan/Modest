
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define MAIN_PROMPT "# "
static char main_tokensBuf[4 * 1024];

static void main_showPrompt(void) {
	char _prompt[32] = {'#', ' '};
	write(0, _prompt, (size_t)2);
}

__attribute__((unused, always_inline))
static inline int main_char8ToInt(char c) {
	return (uint32_t)(uint8_t)c;
}
struct main_tokenizer {
	char *input;
	uint32_t position;
	uint16_t tokensBufPos;
	uint16_t tokensPos;

	char *tokensBuf;
	char *(*tokens)[];
};

static bool main_is_blank(char c) {
	return c == ' ' || c == '\n';
}

static uint16_t main_gettok(struct main_tokenizer *t, char *output, uint16_t lim) {
	(void)lim;
	char c = t->input[t->position];
	while (true) {
		c = t->input[t->position];
		if (c != ' ' && c != '\t') {
			break;
		}
		t->position = t->position + 1U;
	}
	if (c == '\n' || c == '\x0') {
		return 0;
	}
	uint16_t outpos = 0;
	c = t->input[t->position];
	if (!main_is_blank(c)) {
		while (!main_is_blank(c)) {
			output[outpos] = c;
			t->position = t->position + 1U;
			outpos = outpos + 1;
			c = t->input[t->position];
		}
		output[outpos] = '\x0';
	} else {
		output[outpos] = c;
		t->position = t->position + 1U;
		outpos = outpos + 1;
	}
	return outpos;
}

static void main_tokenize(struct main_tokenizer *tokenizer) {
	while (true) {
		const uint16_t max_toklen = 128;
		char token[max_toklen];
		char *p = &tokenizer->tokensBuf[tokenizer->tokensBufPos];
		const uint16_t toklen = main_gettok(tokenizer, token, max_toklen);
		if (toklen == 0) {
			break;
		}
		char *const pbuf = (char *)&tokenizer->tokensBuf[tokenizer->tokensBufPos];
		__builtin_memcpy((char (*)[toklen - 0])&pbuf[0], (char (*)[toklen - 0])&token[0], sizeof(char [toklen - 0]));
		tokenizer->tokensBufPos = tokenizer->tokensBufPos + toklen;
		pbuf[tokenizer->tokensBufPos] = '\x0';
		tokenizer->tokensBufPos = tokenizer->tokensBufPos + 1;
		(*tokenizer->tokens)[tokenizer->tokensPos] = pbuf;
		tokenizer->tokensPos = tokenizer->tokensPos + 1;
		(*tokenizer->tokens)[tokenizer->tokensPos] = NULL;
	}
}

static void main_execute(char *cmd, uint16_t argc, char *argv[]) {
	printf("%s (n=%d)", cmd, argc);
	printf(" [");
	uint32_t i = 0U;
	while (true) {
		char *const ptok = argv[i];
		if (ptok == NULL) {
			break;
		}
		printf("'%s'", ptok);
		i = i + 1U;
	}
	printf("]\n");
}

int32_t main(void) {
	printf("HARSH v0.1\n");
	char inbuf[1024];
	while (true) {
		main_showPrompt();
		fgets(inbuf, (int)sizeof inbuf, stdin);
		char *tokens[64] = {0};
		struct main_tokenizer tokenizer = (struct main_tokenizer){
			.input = inbuf,
			.tokensBuf = main_tokensBuf,
			.tokens = &tokens
		};
		main_tokenize(&tokenizer);
		char *const cmd = (*tokenizer.tokens)[0];
		uint16_t argc = tokenizer.tokensPos;
		if (argc > 0) {
			argc = argc - 1;
		}
		char *(*const argv)[] = (char *(*)[])&(*tokenizer.tokens)[1];
		main_execute(cmd, argc, (char **)argv);
	}
	return 0;
}



#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <sys/stat.h>
#include <time.h>
#include <ctype.h>
#include <unistd.h>
#include <stdlib.h>
#include "fcntl.h"
#include "sys.h"
#if !defined(LENGTHOF)
#define LENGTHOF(x) (sizeof(x) / sizeof((x)[0]))
#endif
#define PROMPT_MAX_LEN 32
static char prompt[PROMPT_MAX_LEN + 1] = {'#'};
struct tokenizer {
	char *input;
	uint32_t position;

	uint16_t ntokens;
	char *(*tokens)[];
};

static bool is_blank(char c) {
	return c == ' ' || c == '\n';
}

static uint16_t gettok(struct tokenizer *t, char *output, uint16_t lim) {
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
	if (!is_blank(c)) {
		while (!is_blank(c)) {
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

static void tokenize(struct tokenizer *tokenizer) {
	while (true) {
		const uint16_t tokenLenMax = 128;
		char token[tokenLenMax];
		const uint16_t toklen = gettok(tokenizer, token, tokenLenMax);
		if (toklen == 0) {
			break;
		}
		char *tok = (char *)malloc((size_t)toklen + 1ULL);
		__builtin_memcpy(tok, (char (*)[toklen - 0])&token[0], sizeof(char [toklen + 1]));
		tok[toklen] = '\x0';
		(*tokenizer->tokens)[tokenizer->ntokens] = tok;
		tokenizer->ntokens = tokenizer->ntokens + 1;
	}
}
typedef int32_t CmdHandler(uint16_t argc, char *argv[]);
struct cmd_descriptor {char *id; CmdHandler *handler;};
static int32_t cmdLs(uint16_t argc, char *argv[]);
static int32_t cmdCd(uint16_t argc, char *argv[]);
static int32_t cmdCreate(uint16_t argc, char *argv[]);
static int32_t cmdExit(uint16_t argc, char *argv[]);
static int32_t cmdSetPrompt(uint16_t argc, char *argv[]);
static struct cmd_descriptor commandHandlers[5] = {
	{.id = "ls", .handler = &cmdLs},
	{.id = "cd", .handler = &cmdCd},
	{.id = "create", .handler = &cmdCreate},
	{.id = "exit", .handler = &cmdExit},
	{.id = "set_prompt", .handler = &cmdSetPrompt}
};

static int32_t execute(char *cmd, uint16_t argc, char *argv[]) {
	if (false) {
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
	uint32_t i = 0U;
	while (i < LENGTHOF(commandHandlers)) {
		struct cmd_descriptor *const h = &commandHandlers[i];
		if (strcmp(h->id, cmd) == 0) {
			return h->handler(argc, (char **)argv);
		}
		i = i + 1U;
	}
	printf("unknown command '%s'\n", cmd);
	return -1;
}

int32_t main(void) {
	sys_init();
	printf("HARSH :) v0.1\n");
	char inbuf[1024];
	while (true) {
		printf("%s ", prompt);
		fgets(inbuf, (int)sizeof inbuf, stdin);
		char *tokens[64] = {0};
		struct tokenizer tokenizer = (struct tokenizer){
			.input = inbuf,
			.tokens = &tokens
		};
		tokenize(&tokenizer);
		char *const cmd = (*tokenizer.tokens)[0];
		const uint16_t argc = tokenizer.ntokens;
		char *(*const argv)[] = (char *(*)[])&(*tokenizer.tokens)[1];
		execute(cmd, argc - 1, (char **)argv);
	}
	sys_deinit();
	return 0;
}

static int32_t cmdCreate(uint16_t argc, char *argv[]) {
	char *filename;
	filename = argv[0];
	printf("called create '%s'\n", filename);
	const sys_Int fd = sys_open(filename, O_CREAT | O_RDONLY);
	if (fd < 0) {
		printf("cannot open file (error = %d)\n", fd);
		return -1;
	}
	sys_close(fd);
	return 0;
}

static int32_t cmdLs(uint16_t argc, char *argv[]) {
	printf("called cmdLs\n");
	return 0;
}

static int32_t cmdCd(uint16_t argc, char *argv[]) {
	printf("called cmdCd\n");
	return 0;
}

static int32_t cmdExit(uint16_t argc, char *argv[]) {
	printf("called cmdExit\n");
	exit(0);
	return 0;
}

static int32_t cmdSetPrompt(uint16_t argc, char *argv[]) {
	char *const newPrompt = argv[0];
	if (strlen(newPrompt) > PROMPT_MAX_LEN) {
		return -1;
	}
	strncpy(prompt, newPrompt, 32ULL);
	return 0;
}


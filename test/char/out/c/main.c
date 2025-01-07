

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"


#include <stdio.h>




#define utf8Char  "s"
#define utf16Char  u"Я"
#define utf32Char  U"🐀"


int main()
{
	printf("test/char\n");

	char ch08;
	uint16_t ch16;
	uint32_t ch32;

	ch08 = 's';
	ch16 = u'Я';
	ch32 = U'🐀';

	//printf("ch08 = 0x%x (%c)\n", Nat32 ch08, ch08)
	//printf("ch16 = 0x%x (%c)\n", Nat32 ch16, ch16)
	//printf("ch32 = 0x%x (%c)\n", Nat32 ch32, ch32)

	return 0;
}


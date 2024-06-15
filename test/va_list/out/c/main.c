// test/va_list/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdarg.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <unistd.h>





/*@attribute("c-no-print")
import "lightfood/print"
@c_include("./print.h")*/
ssize_t my_printf(char *format, ...)
{
	va_list va_list;
	va_start(va_list, format);
	#define maxstr  (128 + 1)
	char buf[maxstr];
	//let n = vsnprintf(&buf, maxstr, format, va_list)
	const int n = __vsnprintf_chk((char *)&buf, maxstr, 0, maxstr, format, va_list);
	va_end(va_list);
	return write(STDOUT_FILENO, (char *)&buf, ((size_t)(uint32_t)n));
}

#undef maxstr


int main()
{
	//print("Hello World!\n")

	int32_t k;
	k = 10;
	my_printf("My Printf Test %d\n", k);

	/*let c = Char8 "$"
	let s = *Str8 "Hi!"
	let i = Int32 -1
	let n = Nat32 123
	let x = Nat32 0x1234567F

	print("\{\}\n")
	print("c = '{c}'\n", c)
	print("s = \"{s}\"\n", s)
	print("i = {i}\n", i)
	print("n = {n}\n", n)
	print("x = 0x{x}\n", x)*/

	return 0;
}


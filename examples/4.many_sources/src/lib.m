// examples/4.many_sources/lib.cm

include "libc/stdio"


export func foo () -> Unit {
	printf("hello from lib.foo\n")
}


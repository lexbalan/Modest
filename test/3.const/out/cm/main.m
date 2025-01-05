
include "libc/ctypes64"
@c_include "stdio.h"
include "libc/stdio"
// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
// define function main


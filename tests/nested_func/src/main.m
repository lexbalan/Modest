// tests/nested_func/src/main.m

include "libc/ctypes64"
include "libc/stdio"


func main () -> Int {

	type MyInt = Int

	@used
	var x: MyInt = 0
	Unit x


	// вложенные функции включены ради синтаксической симметрии
	// но по факту это обычные функции,
	// имя которых не засоряет глобальное пространство имен модуля
	func local () -> Unit {
		var x: Int32
		x = 1
		Unit x
		printf("hello from 'local' func!\n")
	}

	local()

	return 0
}


include "libc/stdio"


type Node record {
	next: *Node
	data: *DataHolder
}

type DataHolder record {
	data: Int32
}


var funcs: []*()->Unit = [&init, &foo]


var a = &init
var b = &add


type SonrState Int32
func xx(x: *SonrState) -> Unit {

}



public func main() -> Int32 {
	init()
	foo()

	var n: Node

	return 0
}


func init() {
	printf("init()\n")
}


func foo() {
	printf("foo()\n")
}


func add(a: Int32, b: Int32) -> Int32 {
	return a + b
}



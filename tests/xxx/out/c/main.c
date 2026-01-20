
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define UNIT  {0}

/*@deprecated*/
struct Point {
	int32_t x;
	int32_t y;
};
typedef struct Point Point;

#define P00  {.x = 5, .y = 5}
#define P01  {.x = 5}

#define M_Y  5

__attribute__((used))
static Point returnPoint(void) {
	Point p;
	p.x = 10;
	return p;
}


// Двойная инициализация (!) ??
//func main() -> Int32 {
//	return 0
//}

int32_t main(void) {
	printf("Hello World!\n");
	Point p = (Point){
		.x = 32,
		.y = 32
	};
	// Конструируем Point из записи в которой нет ни одного поля
	// 1. implicit cons Point from {} (здесь мы создаем ValueCons Point с default полями)
	p = (Point)P00;
	p = (Point){.x = 5,
		.y = 32
	};

	typedef int32_t MyInt;
	MyInt myInt32;

	//var a: []record {a: Int32}
	int64_t b;
	int32_t c;
	//a = a * b + c
	//offsetof(Point.y)
	//p.z
	//a = (2 + 2)
	//var j: jey.Jey
	return 0;
}


// Unit
//public func xxx () -> record {} {
//	return {}
//}


// test/3.const/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define genericIntConst  42
#define int32Const  ((int32_t)genericIntConst)

#define genericStringConst  "Hello!"
#define string8Const  ((char *)genericStringConst)
#define string16Const  ((uint16_t *)genericStringConst)
#define string32Const  ((uint32_t *)genericStringConst)


typedef struct {
	uint32_t x;
	uint32_t y;
} Point;


#define ps  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}
const struct {int8_t x; int8_t y;} _ps[3] = ps;

#define points  { \
	{.x = 0, .y = 0}, \
	{.x = 1, .y = 1}, \
	{.x = 2, .y = 2} \
}
const Point _points[3] = points;


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
static Point points2[3] = {
	{.x = 0, .y = 0},
	{.x = 1, .y = 1},
	{.x = 2, .y = 2}
};


// define function main
int main()
{
	printf("test const\n");

	printf("genericIntConst = %d\n", (int32_t)genericIntConst);
	printf("int32Const = %d\n", int32Const);

	//	printf("genericStringConst = %s\n", genericStringConst)
	printf("string8Const = %s\n", string8Const);

	return 0;
}


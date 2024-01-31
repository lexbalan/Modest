// test/3.const/main.cm

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#define genericIntConst  42
#define int32Const  ((int32_t)genericIntConst)
#define string8Const  "Hello!"
#define string16Const  u"Hello!"
#define string32Const  U"Hello!"


typedef struct {
    uint32_t x;
    uint32_t y;
} Point;


Point points[3] = {
    {.x = 0, .y = 0},
    {.x = 1, .y = 1},
    {.x = 2, .y = 2}
};


// есть проблема - в C глобальные переменные с модификатором const
// не могут быть так инициализированы, поскольку points является приведением
// непонятно существует ли хорошее решение
//@property("c_prefix", "const")
static Point points2[3] = {
    {.x = 0, .y = 0},
    {.x = 1, .y = 1},
    {.x = 2, .y = 2}
};;


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


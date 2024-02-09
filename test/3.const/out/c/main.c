// test/3.const/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define perfectIntConst  42
#define int32Const  ((int32_t)perfectIntConst)
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

    printf("perfectIntConst = %d\n", (int32_t)perfectIntConst);
    printf("int32Const = %d\n", int32Const);

    //	printf("perfectStringConst = %s\n", perfectStringConst)
    printf("string8Const = %s\n", string8Const);

    return 0;
}


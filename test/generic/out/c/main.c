// test/1.hello_world/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




bool test_generic_integer();
bool test_generic_float();
bool test_generic_char();
bool test_generic_array();
bool test_generic_record();


int main()
{
    printf("generic types test\n");

    test_generic_integer();
    test_generic_float();
    test_generic_char();
    test_generic_array();
    test_generic_record();

    return 0;
}


bool test_generic_integer()
{
    // Any integer literal have GenericInteger type
    #define one  1

    // result of such expressions also have generic type

    // GenericInteger value can be implicitly casted to any Integer type

    // to Float

    // and to Byte


    // explicit cast GenericInteger value

    return true;
#undef one
}


bool test_generic_float()
{
    // Any float literal have GenericFloat type
    #define pi  3.141592653589793

    // value with GenericFloat type
    // can be implicit casted to any Float type
    // (in this case value may lose precision)

    // explicit cast GenericFloat value to Int32

    return true;
#undef pi
}


bool test_generic_char()
{
    // Any char value expression have GenericChar type
    // (you can pick GenericChar value by index of GenericString value)
    #define a  ('A')

    // value with GenericChar type
    // can be implicit casted to any Char type

    // explicit cast GenericChar value to Int32

    return true;
#undef a
}


bool test_generic_array()
{
    // Any array expression have GenericArray type
    // this array expression (GenericArray of four GenericInteger items)
    int8_t a[4];
    memcpy(&a, &(int8_t[4]){0, 1, 2, 3}, 4);

    // value with GenericArray type
    // can be implicit casted to Array with compatible type and same size

    // implicit cast Generic([4]GenericInteger) value to [4]Int32
    int32_t b[4];
    memcpy(&b, &a, 16);

    // implicit cast Generic([4]GenericInteger) value to [4]Nat64
    int64_t c[4];
    memcpy(&c, &a, 32);


    // explicit cast Generic([4]GenericInteger) value to [10]Int32

    return true;
}



typedef struct {
    int32_t x;
    int32_t y;
} Point2D;

typedef struct {
    int32_t x;
    int32_t y;
    int32_t z;
} Point3D;


bool test_generic_record()
{
    // Any record expression have GenericRecord type
    // this record expression have type:
    // Generic(record {x: GenericInteger, y: GenericInteger})
    #define p  (struct {int8_t x; int8_t y;}){.x = 10, .y = 20}

    // value with GenericRecord type
    // can be implicit casted to Record with same fields.

    // implicit cast Generic(record {x: GenericInteger, y: GenericInteger})
    // to record {x: Int32, y: Int32}
    Point2D point_2d;
    point_2d = *(Point2D *)&p;


    // explicit cast Generic(record {x: GenericInteger, y: GenericInteger})
    // to record {x: Int32, y: Int32, z: Int32}
    Point3D point_3d;
    point_3d = *(Point3D *)&p;

    return true;
#undef p
}


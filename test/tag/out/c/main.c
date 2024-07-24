// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>

typedef struct Point2D Point2D;
typedef struct BatteryLevel BatteryLevel;






struct Point2D {
	int32_t x;
	int32_t y;
};

static Point2D points[3] = (Point2D[3]){
	{.x = 1, .y = 2},
	{.x = 3, .y = 4},
	{.x = 7, .y = 8}
};


// запись в таблице описывающая один уровень заряда
struct BatteryLevel {
	uint8_t pc;
	int16_t dn;
	int16_t up;

	// минимальное время (в минутах)
	// необходимое для выхода из этого уровня
	// в следующий (наверх, при зарядке)
	uint8_t time;
};


#define nLevels  11

static BatteryLevel lookup_discharge[nLevels] = (BatteryLevel[nLevels]){
	{.pc = 0, .dn = 0, .up = 3300, .time = 33},
	{.pc = 10, .dn = 3300, .up = 3444, .time = 0},
	{.pc = 20, .dn = 3444, .up = 3544, .time = 0},
	{.pc = 30, .dn = 3544, .up = 3628, .time = 0},
	{.pc = 40, .dn = 3628, .up = 3684, .time = 0},
	{.pc = 50, .dn = 3684, .up = 3700, .time = 0},
	{.pc = 60, .dn = 3700, .up = 3744, .time = 0},
	{.pc = 70, .dn = 3744, .up = 3824, .time = 0},
	{.pc = 80, .dn = 3824, .up = 3904, .time = 0},
	{.pc = 90, .dn = 3904, .up = 3996, .time = 0},
	{.pc = 100, .dn = 3996, .up = 5000, .time = 0}
};

static BatteryLevel lookup_charge[nLevels] = (BatteryLevel[nLevels]){
	{.pc = 0, .dn = 0, .up = 3628, .time = 12},
	{.pc = 10, .dn = 3628, .up = 3764, .time = 12},
	{.pc = 20, .dn = 3764, .up = 3856, .time = 12},
	{.pc = 30, .dn = 3856, .up = 3880, .time = 12},
	{.pc = 40, .dn = 3880, .up = 3912, .time = 12},
	{.pc = 50, .dn = 3912, .up = 3960, .time = 12},
	{.pc = 60, .dn = 3960, .up = 4020, .time = 12},
	{.pc = 70, .dn = 4020, .up = 4088, .time = 12},
	{.pc = 80, .dn = 4088, .up = 4136, .time = 12},
	{.pc = 90, .dn = 4136, .up = 4152, .time = 12},
	{.pc = 100, .dn = 4152, .up = 5000, .time = 0}
};


int main()
{
	printf("tag test\n");

	/*
	var len = Int 5
	var a: [len]Nat32

	a[0] = 100
	a[1] = 200
	a[2] = 300

	printf("a[0] = %d\n", a[0])
	printf("a[1] = %d\n", a[1])
	printf("a[2] = %d\n", a[2])


	len = 22
	let size = sizeof(a)
	printf("sizeof(a) == %lu", size)


	a = [1, 2, 3, 4, 5]

	printf("a[0] = %d\n", a[0])
	printf("a[1] = %d\n", a[1])
	printf("a[2] = %d\n", a[2])
*/

	return 0;
}


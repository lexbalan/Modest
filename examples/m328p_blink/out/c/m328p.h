
#if !defined(M328P_H)
#define M328P_H
#include "avr.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
typedef struct m328p_gpio m328p_GPIO;
struct m328p_gpio {
	avr_IO8 in;
	avr_IO8 dir;
	avr_IO8 out;
};
#define M328P_SFR_OFFSET 32
#define M328P_PORT_B ((volatile m328p_GPIO *)(M328P_SFR_OFFSET + 3))
#define M328P_PORT_C ((volatile m328p_GPIO *)(M328P_SFR_OFFSET + 6))
#define M328P_PORT_D ((volatile m328p_GPIO *)(M328P_SFR_OFFSET + 9))
#endif


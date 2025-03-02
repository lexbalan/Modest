
#ifndef VALUE_H
#define VALUE_H

#include <stdint.h>
#include <stdbool.h>
#include "type.h"




struct value_Value {
	type_Type *type;
};
typedef struct value_Value value_Value;

#endif /* VALUE_H */

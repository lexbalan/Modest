
from hlir.value import hlir_value_cast
from error import error

def value_cons_unit_immediate(v, t, ti):
    return hlir_value_cast_immediate(v, t, ti)


def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        error("cannot implicit cons Unit value", ti)
        return None

    return hlir_value_cast(v, t, ti=ti)



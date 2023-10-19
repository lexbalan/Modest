
from hlir import hlir_value_cast


def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        return None

    return hlir_value_cast(v, t, ti=ti)



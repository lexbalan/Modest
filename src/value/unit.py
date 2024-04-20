
from error import error
from .value import value_cons_node


def value_cons_unit_immediate(v, t, ti):
    return value_cons_immediate(v, t, ti)


def value_cons_unit(v, t, ti, method):
    if method != 'explicit':
        error("cannot implicitly cons Unit value", ti)
        return None

    return value_cons_node(v, t, method, ti=ti)



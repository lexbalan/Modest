
from error import error
from .value import value_cons_node


def value_cons_unit_immediate(t, v, ti):
    return value_cons_immediate(t, v, ti)


def value_cons_unit(t, v, method, ti):
    if method != 'explicit':
        error("cannot implicitly cons Unit value", ti)
        return None

    return value_cons_node(t, v, 'explicit', ti=ti)



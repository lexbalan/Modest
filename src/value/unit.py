
from error import error
from .value import value_cons_node


def value_unit_cons(t, v, method, ti):
    if method != 'explicit':
        error("cannot implicitly cons Unit value", ti)
        return None

    return value_cons_node(t, v, 'explicit', ti=ti)



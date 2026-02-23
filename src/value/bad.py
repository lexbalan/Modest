
from hlir import *
from error import error


def bad_can(to, from_type, method, ti):
	return True


def value_bad_cons(t, v, method, ti):
	return ValueBad(ti)



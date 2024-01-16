
from hlir.type import hlir_type_init



def hlir_init():
    hlir_type_init()



def hlir_decl_type(type, ti):
    return {
        'isa': 'decl_type',
        'type': type,
        'ti': ti
    }


def hlir_def_type(type, already_declared=False, ti=None):
    return {
        'isa': 'def_type',
        'type': type,
        'afterdef': already_declared,
        'ti': ti
    }


def hlir_def_const(value_const, ti):
    return {
        'isa': 'def_const',
        'value': value_const,
        'ti': ti
    }


def hlir_def_var(value_var, ti):
    return {
        'isa': 'def_var',
        'value': value_var,
        'ti': ti
    }


def hlir_decl_func(value_func, ti):
    return {
        'isa': 'decl_func',
        'value': value_func,
        'ti': ti
    }


def hlir_def_func(value_func, ti):
    return {
        'isa': 'def_func',
        'value': value_func,
        'ti': ti
    }




from hlir.type import hlir_type_init



def hlir_init():
    hlir_type_init()



def hlir_decl_type(id, newtype, ti):
    return {
        'isa': 'decl_type',
        'id': id,
        'newtype': newtype,
        'att': [],
        'ti': ti
    }


def hlir_def_type(id, type, newtype, already_declared=False, ti=None):
    return {
        'isa': 'def_type',
        'id': id,
        'type': type,  # original type
        'newtype': newtype,  # defined type
        'afterdef': already_declared,
        'att': [],
        'ti': ti
    }


def hlir_def_const(id, value_const, ti):
    return {
        'isa': 'def_const',
        'id': id,
        'value': value_const,
        'att': [],
        'ti': ti
    }


def hlir_def_var(id, value_var, ti):
    return {
        'isa': 'def_var',
        'id': id,
        'value': value_var,
        'att': [],
        'ti': ti
    }


def hlir_decl_func(id, value_func, ti):
    return {
        'isa': 'decl_func',
        'id': id,
        'value': value_func,
        'att': [],
        'ti': ti
    }


def hlir_def_func(id, value_func, ti):
    return {
        'isa': 'def_func',
        'id': id,
        'value': value_func,
        'att': [],
        'ti': ti
    }



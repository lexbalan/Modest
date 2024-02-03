
from hlir.type import hlir_type_init



def hlir_init():
    hlir_type_init()



def hlir_decl_type(_id, newtype, ti):
    return {
        'isa': 'decl_type',
        'id': _id,
        'newtype': newtype,
        'att': [],
        'ti': ti
    }


def hlir_def_type(_id, _type, newtype, already_declared=False, ti=None):
    return {
        'isa': 'def_type',
        'id': _id,
        'newtype': newtype,  # defined type
        'type': _type,  # original type
        'afterdef': already_declared,
        'att': [],
        'ti': ti
    }


def hlir_def_const(_id, value_const, ti):
    return {
        'isa': 'def_const',
        'id': _id,
        'value': value_const,
        'att': [],
        'ti': ti
    }


def hlir_def_var(_id, value_var, ti):
    return {
        'isa': 'def_var',
        'id': _id,
        'value': value_var,
        'att': [],
        'ti': ti
    }


def hlir_decl_func(_id, value_func, ti):
    return {
        'isa': 'decl_func',
        'id': _id,
        'value': value_func,
        'att': [],
        'ti': ti
    }


def hlir_def_func(_id, value_func, ti):
    return {
        'isa': 'def_func',
        'id': _id,
        'value': value_func,
        'att': [],
        'ti': ti
    }



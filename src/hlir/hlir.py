
from hlir.type import hlir_type_init



def hlir_init():
	hlir_type_init()


def hlir_decl_type(id, newtype, ti):
	newtype_declaration = {
		'isa': 'decl_type',
		'id': id,
		'type': newtype,
		'att': [],
		'ti': ti
	}

	return newtype_declaration


def hlir_def_type(id, newtype, origtype=None, ti=None):
	newtype_definition = {
		'isa': 'def_type',
		'id': id,
		'type': newtype,
		'original_type': origtype,
		'att': [],
		'ti': ti
	}

	return newtype_definition


def hlir_def_const(_id, value_const, init_value, ti):
	return {
		'isa': 'def_const',
		'id': _id,
		'init_value': init_value,  # value of initializer
		'value': value_const,  # value wrapped into 'const'
		'att': [],
		'ti': ti
	}


def hlir_def_var(_id, var_value, init_value, ti):
	return {
		'isa': 'def_var',
		'id': _id,
		'init_value': init_value,
		'value': var_value,
		'att': [],
		'ti': ti
	}


def hlir_decl_func(_id, value_func, ti):
	return {
		'isa': 'decl_func',
		'id': _id,
		'value': value_func,
		'att': [],
		'nl': 1,
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


def hlir_initializer(id, value, ti=None, nl=0):
	return {
		'isa': 'initializer',
		'id': id,
		'value': value,
		'att': [],
		'nl': nl,
		'ti': ti
	}




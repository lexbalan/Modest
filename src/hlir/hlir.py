


class Definition():
	def __init__(self, id, ti=None):
		self.id = id
		self.ti = ti

		self.deps = []
		self.att = []
		self.nl = 1

		self.module = None
		self.access_level = None


class DefType(Definition):
	def __init__(self, id, newType, protoType, ti=None):
		super().__init__(id, ti=ti)
		self.type = newType
		self.original_type = protoType


class DefConst(Definition):
	def __init__(self, id, newValue, initValue, ti=None):
		super().__init__(id, ti=ti)
		self.value = newValue
		self.init_value = initValue


class DefVar(Definition):
	def __init__(self, id, newValue, initValue, ti=None):
		super().__init__(id, ti=ti)
		self.var_value = newValue
		self.init_value = initValue


class DefFunc(Definition):
	def __init__(self, id, funcValue, stmt, ti=None):
		super().__init__(id, ti=ti)
		self.value = funcValue
		self.stmt = stmt




def hlir_initializer(id, value, ti=None, nl=0):
	if isinstance(id, dict):
		print(id)
		1/0
	return {
		'isa': 'initializer',
		'id': id,
		'value': value,
		'att': [],
		'nl': nl,
		'ti': ti
	}





"""
def hlir_def_type(id, type, original_type=None, ti=None):
	newtype_definition = {
		'isa': 'def_type',
		'id': id,
		'type': type,
		'original_type': original_type,
		'deps': [],
		'att': [],
		'nl': 1,
		'ti': ti
	}

	return newtype_definition


def hlir_def_const(_id, value_const, init_value, ti):
	return {
		'isa': 'def_const',
		'id': _id,
		'value': value_const,  # value wrapped into 'const'
		'init_value': init_value,  # value of initializer
		'deps': [],
		'att': [],
		'nl': 1,
		'ti': ti
	}

def hlir_decl_var(_id, var_value, init_value, ti):
	return {
		'isa': 'decl_var',
		'id': _id,
		'init_value': init_value,
		'var_value': var_value,
		'att': [],
		'nl': 1,
		'ti': ti
	}

def hlir_def_var(_id, var_value, init_value, ti):
	return {
		'isa': 'def_var',
		'id': _id,
		'init_value': init_value,
		'var_value': var_value,
		'deps': [],
		'att': [],
		'nl': 1,
		'ti': ti
	}


def hlir_def_func(_id, value_func, stmt, ti):
	return {
		'isa': 'def_func',
		'id': _id,
		'value': value_func,
		'stmt': stmt,
		'deps': [],
		'att': [],
		'nl': 1,
		'ti': ti
	}

"""



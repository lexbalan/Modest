


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



class Initializer():
	def __init__(self, id, value, ti=None, nl=0):
		self.id = id
		self.value = value
		self.ti = ti
		self.nl = nl
		self.att = []



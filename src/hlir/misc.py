
from .entity import Entity


class Id(Entity):
	def __init__(self, x=None):
		super().__init__(None)

		self.prefix = None
		self.str = None

		# Каждый принтер всегда использует только свой алиас (!)
		# Такой алиас может быть переопределен без вреда для фронтенда
		self.c = None
		self.llvm = None
		self.cm = None

		if x != None:
			self.fromStr(x['str'])
			self.ti = x['ti']

	def fromStr(self, id_str):
		self.str = id_str
		self.c = id_str
		self.llvm = id_str
		self.cm = id_str
		return self



class Field(Entity):
	def __init__(self, id, type, init_value=None, ti=None):
		super().__init__(ti)
		self.id = id
		self.type = type
		self.init_value = init_value
		self.field_no = 0
		self.offset = 0
		self.access_level = 'private'
		self.att = []
		self.nl = 0
		self.ti = ti
		self.comments = None



class Initializer(Entity):
	def __init__(self, id, value, ti=None, nl=0):
		super().__init__(ti)
		self.id = id
		self.value = value
		self.ti = ti
		self.nl = nl
		self.att = []




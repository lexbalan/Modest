
from .entity import Entity


class Id(Entity):
	def __init__(self, x=None):
		super().__init__(None)
		self.str = None

		if x != None:
			self.str = x['str']
			self.ti = x['ti']

		self.need_decoration = False

		self.c = None
		self.llvm = None
		self.cm = None


	def fromStr(self, x):
		self.str = x
		return self



class Field(Entity):
	def __init__(self, id, type, ti=None):
		super().__init__(ti)
		self.id = id
		self.type = type
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




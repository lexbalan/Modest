
from .entity import Entity


class Id(Entity):
	def __init__(self, id_str, ti=None):
		super().__init__(None)
		self.prefix = None
		# Каждый принтер всегда использует только свой алиас (!)
		# Такой алиас может быть переопределен без вреда для других принтеров и фронтенда
		self.str = id_str
		self.c = id_str
		self.llvm = id_str
		self.cm = id_str
		self.ti = ti




class Field(Entity):
	def __init__(self, _id, _type, init_value=None, ti=None):
		super().__init__(ti)
		self.id = _id
		self.type = _type
		self.init_value = init_value
		self.field_no = 0
		self.offset = 0
		self.access_level = 'private'
		self.att = []
		self.nl = 0
		self.ti = ti
		self.comments = []
		self.line_comment = None



class Initializer(Entity):
	def __init__(self, _id, value, named=False, ti=None, nl=0):
		super().__init__(ti)
		self.id = _id
		self.value = value
		self.ti = ti
		self.nl = nl
		self.att = []
		# этот инициализатор описывает явно именованную сущность? (аргумент)
		# нужно чтобы принтер знал когда стоит печатать аргумент как "key=value"
		self.named = named




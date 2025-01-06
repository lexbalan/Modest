
from .stmt import *
from .value import *

class Id():
	def __init__(self, x=None):
		self.str = None
		self.ti = None

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



class Field():
	def __init__(self, id, type, ti=None):
		self.id = id
		self.type = type
		self.field_no = 0
		self.offset = 0
		self.access_level = 'private'
		self.att = []
		self.nl = 0
		self.ti = ti
		self.comments = None



class Initializer():
	def __init__(self, id, value, ti=None, nl=0):
		self.id = id
		self.value = value
		self.ti = ti
		self.nl = nl
		self.att = []





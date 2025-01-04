

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


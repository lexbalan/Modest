

class Id():
	def __init__(self, str, ti=None):
		self.str = str
		self.ti = ti

		self.need_decoration = False

		self.c = None
		self.llvm = None
		self.cm = None



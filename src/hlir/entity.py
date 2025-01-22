

class Entity():
	def __init__(self, ti):
		self.ti = ti
		self.att = []
		self.parent = None

	def addAttribute(self, a):
		self.att.append(a)

	def hasAttribute(self, a):
		return a in self.att


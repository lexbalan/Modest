

class Entity():
	def __init__(self, ti):
		self.ti = ti
		self.att = []
		self.parent = None

	def addAttribute(self, a):
		self.att.append(a)

	def hasAttribute(self, a):
		return a in self.att

	# возвращает модуль в котором сущность определена (или None)
	def getModule(self):
		from .hlir import Module
		if self.parent != None:
			if isinstance(self.parent, Module):
				return self.parent
			return self.parent.getModule()
		return None

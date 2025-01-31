

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
		if hasattr(self, 'definition'):
			definition = self.definition
			if hasattr(definition, 'module'):
				return self.definition.module
		return None



class Entity():
	def __init__(self, ti):
		self.ti = ti
		self.att = []
		self.annotations = {}
		self.parent = None
		self.is_global_flag = False


	def addAttribute(self, a):
		self.att.append(a)


	def hasAttribute(self, a):
		return a in self.att


	def getAnnotation(self, annotation):
		if annotation in self.annotations:
			return self.annotations[annotation]
		return None

	def hasAttribute2(self, a):
		a = self.getAnnotation(a)
		return a != None


	def is_global(self):
		return self.is_global_flag


	# возвращает модуль в котором сущность определена (или None)
	def getModule(self):
		if hasattr(self, 'definition'):
			definition = self.definition
			if hasattr(definition, 'module'):
				return self.definition.module
		return None


from hlir.type import Type


class Symtab:
	def __init__(self, parent=None, domain='global'):
		self.parent = parent
		self.types = {}
		self.values = {}
		self.domain = domain

	def type_add(self, id, t):
		self.types[id] = t
		return t


	def value_add(self, id, v):
		#print("LL_VALUE_ADD " + id)
		self.values[id] = v
		return v


	# Вообще этот метод всегда возвращает поверхностную копию типа
	# но в некоторых ситуациях (при определении типа) нам нужен именно оригинал
	# поэтому есть параметр as_copy
	# Но в случае когда тип incompleted мы всегда возвращаем сам тип (!)
	# Это нужно для ситуации когда определяем структуру включающую ссылку на себя
	def type_get(self, id, as_copy=True):
		t = None
		if id in self.types:
			t = self.types[id]

		elif self.parent != None:
			t = self.parent.type_get(id)

		if t != None:
			if as_copy and not t.is_incompleted():
				return t.copy()

		return t


	def value_get(self, id, domain='global', recursive=True):
		if domain == 'local':
			if self.domain != 'local':
				return None

		if id in self.values:
			return self.values[id]

		if recursive:
			if self.parent != None:
				return self.parent.value_get(id, domain)

		return None


	def ValueUndef(self, id):
		if id in self.values:
			del self.values[id]
			return True

		if self.parent != None:
			self.parent.ValueUndef(id)
			return True

		return False


	def type_undef(self, id):
		if id in self.types:
			del self.types[id]
			return True

		if self.parent != None:
			self.parent.type_undef(id)
			return True

		return False





	# creates new symtab where #parent links to this symtab
	def branch(self, domain='global'):
		return Symtab(self, domain=domain)


	# extend this symtab with types & values from another symtab
	def merge(self, symtab):
		self.types.update(symtab.types)
		self.values.update(symtab.values)


	def parent_get(self):
		return self.parent


	def extend(self, symtab):
		self.types.update(symtab.types)
		self.values.update(symtab.values)


	# печатает только указанную таблицу символов
	def show_table(table):
		for symbol in table.types:
			print(" # " + symbol)

		for symbol in table.values:
			print(" * " + symbol)


	# печатает весь стек таблиц символов
	def show_tables(self):
		print()
		self.show_table()
		if self.parent != None:
			self.parent.show_tables()


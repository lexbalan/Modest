
from hlir import *


class Symtab:
	def __init__(self, parent=None):
		self.parent = parent
		self.types = {}
		self.values = {}


	def type_add(self, id, t):
		self.types[id] = t
		return t


	def value_add(self, id, v):
		self.values[id] = v
		return v


	# Вообще этот метод всегда возвращает поверхностную копию типа
	# но в некоторых ситуациях (при определении типа) нам нужен именно оригинал
	# поэтому есть параметр as_copy
	# Но в случае когда тип incompleted мы всегда возвращаем сам тип (!)
	# Это нужно для ситуации когда определяем структуру включающую ссылку на себя
	def type_get(self, id, shallow=False):
		t = None
		if id in self.types:
			t = self.types[id]

		elif not shallow and self.parent != None:
			t = self.parent.type_get(id)

		return t


	def value_get(self, id, shallow=False):
		v = None
		if id in self.values:
			v = self.values[id]

		elif not shallow and self.parent != None:
			v = self.parent.value_get(id)

		return v



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
	def branch(self):
		return Symtab(self)


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


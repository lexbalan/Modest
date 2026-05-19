
from hlir import *


class Symtab:
	def __init__(self, parent=None):
		self.parent = parent
		self.types = {}
		self.values = {}

	def type_add(self, id, t, is_public=False):
		self.types[id] = t

	def value_add(self, id, v, is_public=False):
		self.values[id] = v

	# Вообще этот метод всегда возвращает поверхностную копию типа
	# но в некоторых ситуациях (при определении типа) нам нужен именно оригинал
	# поэтому есть параметр as_copy
	# Но в случае когда тип incompleted мы всегда возвращаем сам тип (!)
	# Это нужно для ситуации когда определяем структуру включающую ссылку на себя
	def type_get(self, id, shallow=False):
		if id in self.types:
			return self.types[id]
		elif not shallow and self.parent != None:
			return self.parent.type_get(id)
		return None

	def value_get(self, id, shallow=False):
		if id in self.values:
			return self.values[id]
		elif not shallow and self.parent != None:
			return self.parent.value_get(id)
		return None

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


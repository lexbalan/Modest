
from .misc import *
from .stmt import *
from .type import *
from .value import *


class Module:
	def __init__(self, idStr, ast, symtab_public, symtab_private, sourcename):
		self.id = idStr
		self.sourcename = sourcename
		self.ast = ast
		self.prefix = idStr
		self.strings = []   # for LLVM backend
		self.anon_recs = [] # anonymous records for C backend
		self.imports = {}   # '<import_id>' => {'isa': 'module'}
		self.included_modules = []
		self.symtab_public = symtab_public
		self.symtab_private = symtab_private
		self.source_abspath = None
		self.defs = []
		self.att = []


	def setPrefix(self, prefixStr):
		self.prefix = prefixStr

	def addAttribute(self, a):
		if not a in self.att:
			self.att.append(a)

	def hasAttribute(self, a):
		return a in self.att


	def type_add(self, id_str, t, is_public=False):
		#print('module_type_add (%s, isPublic=%d)' % (id_str, is_public))
		if is_public:
			self.symtab_public.type_add(id_str, t)
		else:
			self.symtab_private.type_add(id_str, t)


	def value_add(self, id_str, v, is_public=False):
		#print('module_value_add (%s, isPublic=%d)' % (id_str, is_public))
		if is_public:
			self.symtab_public.value_add(id_str, v)
		else:
			self.symtab_private.value_add(id_str, v)


	def value_get_public(self, id_str):
		return self.symtab_public.value_get(id_str)

	def value_get_private(self, id_str):
		return self.symtab_private.value_get(id_str)

	def type_get_public(self, id_str):
		return self.symtab_public.type_get(id_str)

	def type_get_private(self, id_str):
		return self.symtab_private.type_get(id_str)




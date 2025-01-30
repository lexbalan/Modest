
from .misc import *
from .stmt import *
from .type import *
from .value import *


class Module:
	def __init__(self, idStr, ast, symtab_public, symtab_private):
		self.id = idStr
		self.ast = ast
		self.prefix = None
		self.strings = [] # for LLVM backend
		self.records = [] # for C backend
		self.anon_recs = [] # anonymous records for C backend
		self.imports = {} # '<import_id>' => {'isa': 'module'}
		self.included_modules = []
		self.symtab_public = symtab_public
		self.symtab_private = symtab_private
		self.source_abspath = None
		self.lldeps = []
		self.defs = []
		self.att = []

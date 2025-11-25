#####################################################################
#                             PARSER                                #
#####################################################################

import os
import re

from hlir import *
from error import error, warning, info
from util import utf32cc_to_utf8_str

top_level_stoppers = ['type', 'let', 'const', 'var', 'func']
func_stoppers = ['let', 'var', 'if', 'while', 'return', 'type']


def isUpperIdentifierToken(token):
	# skip _ before letters
	while token[0] == '_':
		token = token[1:]
	if len(token) > 0:
		return token[0].isupper()
	return False


class Parser:
	def __init__(self):
		pass

	def is_end(self):
		if self.tokens[self.ctoken][1] == '':
			return True
		return self.ctoken >= (len(self.tokens) - 1)


	#def is_blank(self, c):
	#	return c == ' ' or c == '\t' or c == '\n'

	def is_comment(self):
		c = self.ctok_class()
		return c in ['comment-line', 'comment-block']


	def skip1(self):
		if self.ctoken < (len(self.tokens) - 1):
			self.ctoken = self.ctoken + 1

	def skip(self, token):
		return self.match(token)

	def skipn(self, token):
		while self.skip(token):
			pass


	def ctok_class(self):
		return self.tokens[self.ctoken][0]


	def ctok(self):
		return self.tokens[self.ctoken][1]


	def getpos(self):
		return self.ctoken


	def setpos(self, pos):
		self.ctoken = pos


	def nextok(self):
		if self.ctoken + 1 > len(self.tokens):
			pass # TODO
		return self.tokens[self.ctoken + 1][1]


	def ti(self):
		assert(len(self.tokens[self.ctoken]) == 3)
		ti = self.tokens[self.ctoken][2]
		return ti


	def gettok(self):
		t = self.ctok()
		self.skip1()
		return t


	#skip_tokens_class(['nl'])
	def skip_tokens_class(self, classes):
		while self.ctok_class() in classes:
			self.skip1()


	def skip_tokens(self, tokens):
		while self.ctok() in tokens:
			self.skip1()


	def look(self, token):
		return self.ctok() == token


	def match(self, token):
		if self.token_class_is('str'):
			return False

		yes = self.look(token)
		if yes:
			self.skip1()

		return yes


	def token_class_is(self, clas):
		c = self.ctok_class()
		if c == clas:
			return True
		return False


	def need(self, token):
		ti = self.ti()
		yes = self.match(token)
		if not yes:
			error("expected '%s' token" % token, ti)
		return yes


	def is_assign_operator(self):
		return self.look("=") or self.look("<-") or self.look(":=")

	def is_number(self):
		return self.ctok_class() == 'num'

	def is_identifier(self):
		return self.ctok_class() == 'id'

	def is_Identifier(self):
		return self.ctok_class() == 'Id'

	def is_string(self):
		return self.ctok_class() == 'str'

	def is_operator(self):
		return self.ctok_class() == 'op'

	def is_tag(self):
		return self.ctok_class() == 'tag'


	def parse_identifier(self):
		ti = self.ti()
#		if not self.is_identifier():
#			self.skip1()
#			error("expected identifier", ti)
#			return None
		s = self.gettok()
		if not re.fullmatch(r'[A-Za-z0-9_]+', s):
			error("bad identifier", ti)
		return {'isa': 'ast_id', 'kind': 'id', 'str': s, 'ti': ti} #Id(s, ti=ti) ####


	def need_sep(self, separators=['\n', ';'], stoppers=['}'], eat=True):
		if self.ctok() in separators:
			if eat:
				while self.is_operator() and self.ctok() in separators:
					self.skip1()

		elif self.ctok() in stoppers:
			pass
		elif self.ctok_class() in ['comment-line', 'comment-block']:
			self.skip1()
			pass
		else:
			error("expected separator", self.ti())
			self.restore(top_level_stoppers + func_stoppers)
			return False

		return True

	#
	# Parse Type
	#


	def expr_type_record(self, ti):
		self.need("{")
		fields = []

		while True:
			nl_cnt = 0
			comments = []
			annotations = []

			# Skip blanks, handle comments & annotations
			while True:
				comm = self.parse_if_comment()
				if comm != None:
					comm['nl'] = nl_cnt
					nl_cnt = 0
					comments.append(comm)
				elif self.token_class_is('annotation'):
					x = self.parse_annotation()
					x['nl'] = nl_cnt
					annotations.append(x)
				elif self.match("\n"):
					nl_cnt += 1
				elif self.match(","):
					pass
				elif self.match(";"):
					pass
				else:
					break

			if self.match("}"):
				break

			access_modifier = self.parse_access_modifier()
			f = self.stmt_var()
			for ff in f:
				ff['access_modifier'] = access_modifier

			line_comm = self.parse_if_comment()

			if f != None:
				f[0].update({
					'anno': annotations,
					'comments': comments,
					'line_comment': line_comm,
					'nl': nl_cnt,
				})

				if len(f) > 1:
					for subf in f[1:]:
						subf.update({
							'anno': annotations,
							'line_comment': None,
							'comments': [],
							'nl': 1
						})

				fields.extend(f)

		return {
			'isa': 'ast_type',
			'kind': 'record',
			'fields': fields,
			'ti': ti
		}


	def check_is_field(self):
		self.parse_access_modifier()
		if self.is_identifier():
			self.skip1()
			if not self.match(':'):
				return False

			return True


	def is_annotation(self):
		return self.token_class_is('annotation')


	def check_is_type(self):
		if self.is_Identifier():
			return True

		elif self.is_identifier():
			if self.nextok() == '.':
				self.skip1()
				self.skip1()
				if self.is_Identifier():
					return True
			token = self.gettok()
			return token in ['record', 'enum']

		elif self.is_operator():
			token = self.gettok()
			if token == '*':
				# maybe it is pointer? (or it's 'deref' operation)
				return self.is_type_expr()

			elif token == '[':
				# maybe it is array?
				while not self.match(']'):
					self.skip1()
				return self.is_type_expr()

			elif token == '(':
				self.skip_tokens_class(['nl'])
				#print("ok")
				# is ` ( <#type_expr#> ) ` ?
				if self.is_type_expr():
					return self.match(')')

				if self.match(")"):
					return self.match("->") or self.match("{")

				# maybe it's func?
				if not self.match(")"):
					if self.check_is_field():
						return True

				return False

			return False

		elif self.is_annotation():
			self.parse_annotation()
			return self.check_is_type()

		else:
			return False

		return False


	def check(self, checker):
		pos = self.getpos()
		result = checker()
		self.setpos(pos)
		return result


	def is_type_expr(self):
		return self.check(self.check_is_type)


	def expr_type_func(self):
		ti = self.ti()
		self.skip1()  # "("
		self.skip_tokens_class(['nl'])
		arghack = False
		fields = []
		while not self.match(")"):
			if self.is_identifier():
				f = self.stmt_var()
				if isinstance(f, list):
					fields.extend(f)
				else:
					fields.append(f)
			elif self.match("..."):
				arghack = True
			self.match(",")
			self.skip_tokens_class(['nl'])

		if self.match("->"):
			t = self.expr_type()
			return {
				'isa': 'ast_type',
				'kind': 'func',
				'params': fields,
				'arghack': arghack,
				'to': t,
				'ti': ti
			}
		else:
			return {
				'isa': 'ast_type',
				'kind': 'func',
				'params': fields,
				'to': None,
				'arghack': arghack,
				'size': 0,
				'align': 0,
				'ti': ti
			}
		#return r


	def expr_type(self):
		ti = self.ti()

		if not self.is_type_expr():
			error("expected type expr", ti)
			return None

		# parse all annotations before
		annotations = []
		ca = self.parse_comments_annotations()
		#comments.extend(ca[0])
		annotations.extend(ca[1])

		t = {'isa': 'ast_type', 'kind': 'unknown', 'ti': ti}

		if self.look("("):
			t = self.expr_type_func()

		elif self.match("*"):
			t = self.expr_type()
			t = {'isa': 'ast_type', 'kind': 'pointer', 'to': t, 'ti': ti}

		elif self.match("record"):
			t = self.expr_type_record(ti)

		elif self.match("enum"):
			self.need("{")
			items = []
			while not self.match("}"):
				self.skip_tokens_class(['nl'])
				ti = self.ti()
				id = self.parse_identifier()
				self.need_sep(separators=['\n', ','])
				items.append({'id': id, 'ti': ti})
			t = {'isa': 'ast_type', 'kind': 'enum', 'items': items, 'ti': ti}

		elif self.match("["):
			y = {'isa': 'ast_type', 'kind': 'array', 'size': None, 'ti': ti}
			if self.match("]"):
				y['size'] = self.expr_ValueUndef(ti)
			else:
				y['size'] = self.expr_value()
				self.need("]")
			y['of'] = self.expr_type()
			t = y

		elif self.is_Identifier():
			id = self.parse_identifier()
			t = {
				'isa': 'ast_type',
				'kind': 'named',
				'id': id,
				'ti': ti
			}

		elif self.is_identifier():
			left = self.parse_identifier()
			dot_ti = self.ti()
			self.need(".")
			right = self.parse_identifier()

			t = {
				'isa': 'ast_type',
				'kind': 'named',
				'module': left,
				'id': right,
				'ti': dot_ti
			}

#		for a in annotations:
#			print(a['kind'])

		t['anno'] = annotations
		return t

	#
	# Parse Value
	#

	def expr_ValueUndef(self, ti):
		return {
			'isa': 'ast_value',
			'kind': 'undefined',
			'anno': [],
			'ti': ti
		}


	def expr_value(self):

		#anno = self.parse_annotations()
		ca = self.parse_comments_annotations()
		#comments.extend(ca[0])
		anno = ca[1]
		#spaceline_cnt = ca[2]

		x = self.expr_value_1()
		#x['nl'] = 0
		x['anno'] = anno
		return x


	def expr_value_1(self):
		v = self.expr_value_2()
		ti = self.ti()
		if self.match("or"):
			self.skipn("\n")
			r = self.expr_value()
			ti.start = v['ti']
			ti.end = r['ti']
			return {
				'isa': 'ast_value',
				'kind': 'or',
				'left': v,
				'right': r,
				'anno': [],
				'ti': ti
			}
		else:
			return v


	def expr_value_2(self):
		v = self.expr_value_3()
		ti = self.ti()
		if self.match("xor"):
			self.skipn("\n")
			r = self.expr_value_2()
			ti.start = v['ti']
			ti.end = r['ti']
			return {
				'isa': 'ast_value',
				'kind': 'xor',
				'left': v,
				'right': r,
				'anno': [],
				'ti': ti
			}
		else:
			return v


	def expr_value_3(self):
		v = self.expr_value_4()
		ti = self.ti()
		if self.match("and"):
			self.skipn("\n")
			r = self.expr_value_3()
			ti.start = v['ti']
			ti.end = r['ti']
			return {
				'isa': 'ast_value',
				'kind': 'and',
				'left': v,
				'right': r,
				'anno': [],
				'ti': ti
			}
		else:
			return v


	def expr_value_4(self):
		v = self.expr_value_5()
		while True:
			ti = self.ti()
			if self.match("=="):
				self.skipn("\n")
				r = self.expr_value_5()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'eq',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match("!="):
				self.skipn("\n")
				r = self.expr_value_5()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'ne',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			else:
				break
		return v


	def expr_value_5(self):
		v = self.expr_value_6()
		while True:
			ti = self.ti()
			if self.match("<"):
				self.skipn("\n")
				r = self.expr_value_6()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'lt',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match(">"):
				self.skipn("\n")
				r = self.expr_value_6()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'gt',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			if self.match("<="):
				self.skipn("\n")
				r = self.expr_value_6()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'le',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match(">="):
				self.skipn("\n")
				r = self.expr_value_6()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'ge',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			else:
				break
		return v


	def expr_value_6(self):
		v = self.expr_value_7()
		while True:
			ti = self.ti()
			if self.match("<<"):
				self.skipn("\n")
				l = v
				r = self.expr_value_7()
				ti.start = l['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'shl',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match(">>"):
				self.skipn("\n")
				l = v
				r = self.expr_value_7()
				ti.start = l['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'shr',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			else:
				break
		return v


	def expr_value_7(self):
		v = self.expr_value_8()
		while True:
			ti = self.ti()
			if self.match("+"):
				self.skipn("\n")
				r = self.expr_value_8()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'add',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match("-"):
				self.skipn("\n")
				r = self.expr_value_8()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'sub',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			else:
				break
		return v


	def expr_value_8(self):
		v = self.expr_value_9()
		while True:
			ti = self.ti()
			if self.match("*"):
				self.skipn("\n")
				r = self.expr_value_9()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'mul',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match("/"):
				self.skipn("\n")
				r = self.expr_value_9()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'div',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			elif self.match("%"):
				self.skipn("\n")
				r = self.expr_value_9()
				ti.start = v['ti']
				ti.end = r['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'rem',
					'left': v,
					'right': r,
					'anno': [],
					'ti': ti
				}
			else:
				break
		return v


	# cons
	def expr_value_9(self):
		if self.is_type_expr():
			ti = self.ti()
			t = self.expr_type()
			v = self.expr_value_9()
			return {
				'isa': 'ast_value',
				'kind': 'cons',
				'value': v,
				'type': t,
				'anno': [],
				'ti': ti
			}

		else:
			return self.expr_value_10()



	def expr_value_10(self):
		ti = self.ti()
		if self.match("*"):
			v = self.expr_value_10()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'deref',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("&"):
			v = self.expr_value_11()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'ref',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("not"):
			v = self.expr_value_11()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'not',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("+"):
			v = self.expr_value_11()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'pos',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("-"):
			v = self.expr_value_11()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'neg',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("new"):
			v = self.expr_value()
			return {
				'isa': 'ast_value',
				'kind': 'new',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("unsafe"):
			v = self.expr_value()
			ti.end = v['ti']
			return {
				'isa': 'ast_value',
				'kind': 'unsafe',
				'value': v,
				'anno': [],
				'ti': ti
			}

		elif self.match("sizeof"):
			self.match("(")
			rv = None
			if self.is_type_expr():
				t = self.expr_type()
				rv = {
					'isa': 'ast_value',
					'kind': 'sizeof_type',
					'type': t,
					'anno': [],
					'ti': ti
				}
			else:
				v = self.expr_value()
				rv = {
					'isa': 'ast_value',
					'kind': 'sizeof_value',
					'value': v,
					'anno': [],
					'ti': ti
				}
			self.need(")")
			return rv

		elif self.match("alignof"):
			self.match("(")
			t = self.expr_type()
			self.need(")")
			return {
				'isa': 'ast_value',
				'kind': 'alignof',
				'type': t,
				'anno': [],
				'ti': ti
			}

		elif self.match("offsetof"):
			self.match("(")
			t = self.expr_type()
			self.need('.')
			f = self.parse_identifier()
			self.need(")")
			return {
				'isa': 'ast_value',
				'kind': 'offsetof',
				'type': t,
				'field': f,
				'anno': [],
				'ti': ti
			}

		elif self.match("lengthof"):
			self.match("(")
			v = self.expr_value()
			rv = {
				'isa': 'ast_value',
				'kind': 'lengthof_value',
				'value': v,
				'anno': [],
				'ti': ti
			}
			self.need(")")
			return rv

		elif self.match("__va_start"):
			self.match("(")
			v0 = self.expr_value()
			self.need(",")
			v1 = self.expr_value()
			rv = {
				'isa': 'ast_value',
				'kind': '__va_start',
				'values': [v0, v1],
				'anno': [],
				'ti': ti
			}
			self.need(")")
			return rv

		elif self.match("__va_copy"):
			self.match("(")
			v0 = self.expr_value()
			self.need(",")
			v1 = self.expr_value()
			rv = {
				'isa': 'ast_value',
				'kind': '__va_copy',
				'values': [v0, v1],
				'anno': [],
				'ti': ti
			}
			self.need(")")
			return rv

		elif self.match("__va_end"):
			self.match("(")
			v = self.expr_value()
			rv = {
				'isa': 'ast_value',
				'kind': '__va_end',
				'value': v,
				'anno': [],
				'ti': ti
			}
			self.need(")")
			return rv

		elif self.match("__va_arg"):
			self.match("(")
			v = self.expr_value()
			self.match(",")
			t = self.expr_type()
			self.match(")")
			return {
				'isa': 'ast_value',
				'kind': '__va_arg',
				'va_list': v,
				'type': t,
				'anno': [],
				'ti': ti
			}

		elif self.match("__defined"):
			self.match("(")
			rv = None
			if self.is_type_expr():
				t = self.expr_type()
				rv = {
					'isa': 'ast_value',
					'kind': '__defined_type',
					'type': t,
					'anno': [],
					'ti': ti
				}
			else:
				v = self.expr_value()
				rv = {
					'isa': 'ast_value',
					'kind': '__defined_value',
					'value': v,
					'anno': [],
					'ti': ti
				}
			self.need(")")
			return rv
		else:
			y = self.expr_value_11()
			return y


	def parse_args(self):
		args = []
		self.match("(")
		while not self.match(")"):
			arg = None
			#print(self.ctok())
			#self.skip_tokens_class(['nl'])
			nl_cnt = 0
			while self.token_class_is('nl'):
				self.skip1()
				nl_cnt += 1

			if self.match(")"):
				break

			comm = self.parse_if_comment()
			if comm != None:
				#comm['nl'] = nl_cnt
				#args.append(comm)
				continue

			arg_ti = self.ti()
			arg_value = self.expr_value()
			arg_id = None
			if self.match("="):
				if arg_value['kind'] != 'id':
					error("expected identifier", arg_value['ti'])

				arg_id = arg_value#['id']
				arg_value = self.expr_value()

			arg = {
				'isa': 'ast_kv',
				'key': arg_id,
				'value': arg_value,
				'nl': nl_cnt,
				'ti': arg_ti
			}
			args.append(arg)

			if not self.token_class_is('nl'):
				self.need_sep(separators=[',', '\n'], stoppers=[')'])

		return args


	def expr_value_11(self):
		# CALL
		v = self.expr_value_term()
		while True:
			ti = self.ti()
			if self.look("("):
				args = self.parse_args()

				v = {
					'isa': 'ast_value',
					'kind': 'call',
					'left': v,
					'args': args,
					'anno': [],
					'nl': 0,
					'ti': ti
				}

			elif self.match("."):
				field_id = self.parse_identifier()
				ti.start = v['ti']
				ti.end = field_id['ti']

				v = {
					'isa': 'ast_value',
					'kind': 'access',
					'left': v,
					'right': field_id,
					'anno': [],
					'ti': ti
				}
			elif self.match("["):
				#
				# ARRAY INDEXING OR SLICING
				#

				i = None
				j = None
				is_slicing = False

				if self.match(":"):
					is_slicing = True
					j = self.expr_value()
				else:
					i = self.expr_value()
					if self.match(":"):
						is_slicing = True
						if not self.look("]"):
							j = self.expr_value()
				self.need("]")

				assert not (i == None and j == None)

				ti.start = v['ti']

				if is_slicing:
					v = {
						'isa': 'ast_value',
						'kind': 'slice',
						'left': v,
						'index_from': i,
						'index_to': j,
						'anno': [],
						'ti': ti
					}
					return v

				v = {
					'isa': 'ast_value',
					'kind': 'index',
					'left': v,
					'index': i,
					'anno': [],
					'ti': ti
				}
			else:
				return v


	def parse_if_comment(self):
		if self.token_class_is('comment-block'):
			return self.parse_if_comment_block()
			return x
		elif self.token_class_is('comment-line'):
			return self.parse_if_comment_line()
		return None


	def parse_value_array(self, ti):
		array_ti = self.ti()
		items = []
		nl_cnt = 0
		item_id = 0
		self.need("[")
		while not self.match("]"):
			#self.skip_tokens_class(['nl'])
			nl_cnt = self.skip_blanks()

			comm = self.parse_if_comment()
			if comm != None:
				comm['nl'] = nl_cnt
				items.append(comm)
				continue

			if self.match("]"):
				break

			item_value = self.expr_value()

			if not self.look("\n"):
				self.need_sep(separators=[','], stoppers=[']'])

			item = {
				'isa': 'ast_kv',
				'key': item_id,
				'value': item_value,
				'nl': nl_cnt,
				'ti': item_value['ti']
			}
			items.append(item)

			item_id += 1

		return {
			'isa': 'ast_value',
			'kind': 'array',
			'items': items,
			'anno': [],
			'ti': array_ti
		}


	def parse_value_record(self, ti):
		record_ti = self.ti()
		items = []
		nl_cnt = 0
		self.need("{")
		while not self.match("}"):
			#self.skip_tokens_class(['nl'])
			nl_cnt = self.skip_blanks()

			comm = self.parse_if_comment()
			if comm != None:
				comm['nl'] = nl_cnt
				items.append(comm)
				continue

			if self.match("}"):
				break

			item_ti = self.ti()
			item_id = self.parse_identifier()
			self.need("=")
			item_value = self.expr_value()

			if not self.look("\n"):
				self.need_sep(separators=[',', '\n'], stoppers=['}'])

			item = {
				'isa': 'ast_kv',
				'key': item_id,
				'value': item_value,
				'nl': nl_cnt,
				'ti': item_ti
			}
			items.append(item)

		return {
			'isa': 'ast_value',
			'kind': 'record',
			'items': items,
			'anno': [],
			'ti': record_ti
		}


	def parse_value_string(self, s, ti):
			str_len = 0
			new_s = ''
			i = 0
			while i < len(s):
				sym = s[i]

				if sym == '\\':

					# nexsym
					i += 1
					sym = s[i]

					if sym == '\\':
						new_s = new_s + '\\'
						i += 1
						continue

					elif sym == '"':
						# eat "\""
						new_s = new_s + sym
						str_len = str_len + 1
						i += 1
						continue

					# '\xCODE' ?
					is_hex = sym == 'x'
					is_unicode = sym == 'u'


					def isxdigit(char):
						return char in '0123456789abcdefABCDEF'


					code = 0

					# case \012345678
					if sym.isdigit():
						cod = ""
						while i < len(s):
							sym = s[i]
							if not sym.isdigit():
								break
							cod = cod + sym
							i += 1

						i = i - 1
						code = int(cod, 10) & 0xFF

					# case \xXX | \uXXXXXXXX
					elif is_hex or is_unicode:
						cod = ""
						i += 1 # skip 'x' | 'u' prefix
						while i < len(s):
							sym = s[i]
							if not isxdigit(sym):
								break
							cod = cod + sym
							i += 1
							if is_hex:
								if len(cod) == 2:
									break
							else:
								if len(cod) == 8:
									break
						i -= 1
						code = int(cod, 16)

					elif sym == 'n': code = ord("\n")   # LF
					elif sym == '"': code = ord("\"")   # QUOTE2
					elif sym == "'": code = ord("'")    # QUOTE1
					elif sym == '\\': code = ord("\\")  # BACKSLASH
					elif sym == 'r': code = ord("\r")   # CR
					elif sym == 't': code = ord("\t")   # TAB
					elif sym == 'a': code = ord("\a")   # BELL
					elif sym == 'b': code = ord("\b")   # BACKSPACE
					elif sym == 'v': code = ord("\v")   # VT
					elif sym == 'f': code = ord("\f")   # FF


					if is_unicode:
						sym = utf32cc_to_utf8_str(code)
					else:
						sym = chr(code)

				str_len = str_len + 1
				new_s = new_s + sym
				i += 1

			string = ''.join(new_s)

			return {
				'isa': 'ast_value',
				'kind': 'string',
				'len': str_len,  # in Characters (!)
				'str': string,
				'anno': [],
				'ti': ti
			}

	def expr_value_term(self):
		ti = self.ti()

		if self.match("("):
			self.skipn("\n")
			v = self.expr_value()
			self.skipn("\n")
			self.need(")")
			return {
				'isa': 'ast_value',
				'kind': 'subexpr',
				'value': v,
				'anno': [],
				'ti': ti
			}


		elif self.is_identifier():
			id = self.parse_identifier()
			return {
				'isa': 'ast_value',
				'kind': 'id',
				'str': id['str'],
				'anno': [],
				'ti': id['ti']
			}

		elif self.is_number():
			numstr = self.gettok()
			return {
				'isa': 'ast_value',
				'kind': 'number',
				'str': numstr,
				#'att': [],
				'anno': [],
				'ti': ti
			}

		elif self.is_string():
			s = self.gettok()
			return self.parse_value_string(s, ti)

		elif self.is_tag():
			num = self.gettok()
			return {'isa': 'ast_value', 'kind': 'tag', 'tag': num, 'ti': ti}

		elif self.look("["):
			return self.parse_value_array(ti)

		elif self.look("{"):
			return self.parse_value_record(ti)

		else:
			cl = self.ctok_class()
			tokstr = self.ctok()

			if tokstr == '\n':
				tokstr = 'newline'
			elif tokstr == '':
				tokstr = 'end-of-file'

			error("unexpected token '%s'" % tokstr, self.ti())
			self.skip1()
			return {
				'isa': 'ast_value',
				'kind': 'bad',
				'anno': [],
				'ti': ti
			}



	#
	# Parse Statement
	#

	def stmt_let(self):
		x = self.parse_stmt_xvar(access_modifier='undefined')[0]
		x['isa'] = 'ast_stmt'
		x['kind'] = 'const'
		return x


	def stmt_var(self):
		return self.parse_stmt_xvar(access_modifier='undefined')


	def stmt_if(self):
		c = self.expr_value()
		t = self.stmt_block()
		e = None
		if self.match('else'):
			ti = self.ti()
			if self.match('if'):
				e = self.stmt_if()
			else:
				e = self.stmt_block()
			e['ti'] = ti
		return {
			'isa': 'ast_stmt',
			'kind': 'if',
			'cond': c,
			'then': t,
			'else': e,
			'nl': 0
		}


	def stmt_while(self):
		v = self.expr_value()
		b = self.stmt_block()
		return {
			'isa': 'ast_stmt',
			'kind': 'while',
			'cond': v,
			'stmt': b
		}


	def stmt_return(self):
		self.skip1()	# skip 'return' keyword

		v = None
		if not (self.look("\n") or self.look(";") or self.look("}")):
			v = self.expr_value()

		return {
			'isa': 'ast_stmt',
			'kind': 'return',
			'value': v
		}


	def stmt_again(self):
		return {'isa': 'ast_stmt', 'kind': 'again'}


	def stmt_break(self):
		return {'isa': 'ast_stmt', 'kind': 'break'}


	def stmt_inc(self):
		v = self.expr_value()
		return {'isa': 'ast_stmt', 'kind': 'inc', 'value': v}


	def stmt_dec(self):
		v = self.expr_value()
		return {'isa': 'ast_stmt', 'kind': 'dec', 'value': v}


	def stmt_asm(self):
		v = self.expr_value()
		return {'isa': 'ast_stmt', 'kind': 'asm', 'args': v['args']}


	def stmt_expr_value(self):
		v = self.expr_value()

		# stmt expr
		assign_ti = self.ti()
		if self.is_assign_operator():
			# stmt assign
			self.skip1() # skip assign operator
			self.skipn("\n")
			r = self.expr_value()
			return {'isa': 'ast_stmt', 'kind': 'assign', 'left': v, 'right': r, 'ti': assign_ti}

		# just value expression statement
		return {'isa': 'ast_stmt', 'kind': 'value', 'value': v}


	def stmt_comment_line(self):
		ti = self.ti()
		x = self.gettok()
		return {'isa': 'ast_stmt', 'kind': 'comment-line', 'lines': x, 'ti': ti}


	def stmt_comment_block(self):
		ti = self.ti()
		x = self.gettok()
		return {'isa': 'ast_stmt', 'kind': 'comment-block', 'text': x, 'ti': ti}


	def stmt(self):
		ti = self.ti()

		if self.match('let'):
			s = self.stmt_let()
		elif self.match('if'):
			s = self.stmt_if()
		elif self.match('while'):
			s = self.stmt_while()
		elif self.look('return'):
			s = self.stmt_return()
		elif self.match('var'):
			s = self.stmt_var()
		elif self.match('again'):
			s = self.stmt_again()
		elif self.match('break'):
			s = self.stmt_break()
		elif self.match('type'):
			s = self.parse_def_type()
			s['access_modifier'] = 'undefined'
		elif self.match('const'):
			s = self.stmt_let()
		elif self.match('++'):
			s = self.stmt_inc()
		elif self.match('--'):
			s = self.stmt_dec()
		elif self.look('__asm'):
			s = self.stmt_asm()
		else:
			# comment?
			cl = self.ctok_class()
			if cl == 'comment-line':
				s = self.stmt_comment_line()
			elif cl == 'comment-block':
				s = self.stmt_comment_block()
			else:
				s = self.stmt_expr_value()

		if s == None:
			return s

		# переменные могут быть объявлены списком
		if isinstance(s, list):
			return s

		if not 'ti' in s:
			s['ti'] = ti

		return s


	def skip_blanks(self):
		nl_cnt = 0
		while not self.is_end():
			if not self.look('\n'):
				break

			self.skip1()
			nl_cnt = nl_cnt + 1
			continue

		return nl_cnt



	def stmt_block(self):
		ti = self.ti()
		#print('stmt_block')

		nl_cnt = 0
		self.need("{")
		stmts = []
		while True:
			#self.skip_tokens_class(['nl'])

			nl_cnt = self.skip_blanks()


			if self.match('}'):
				break

			s = self.stmt()

			if s != None:
				sep = self.need_sep(eat=False)

				while self.match(";"):
					pass
				#if sep == False:
				#	break

				if isinstance(s, list):
					s[0]['nl'] = nl_cnt
					stmts.extend(s)
				else:
					s['nl'] = nl_cnt
					stmts.append(s)

				nl_cnt = 0

		return {
			'isa': 'ast_stmt',
			'kind': 'block',
			'stmts': stmts,
			'nl': 0,
			'ti': ti
		}


	def parse_access_modifier(self):
		if self.match('public'): #or self.match('export'):
			return 'public'
		elif self.match('private'):
			return 'private'
		return 'undefined'


	def parse_comments_annotations(self, nl_cnt=0):
		comments = []
		anno = []
		while not self.is_end():
			comm = self.parse_if_comment()
			if comm != None:
				comm['nl'] = nl_cnt
				nl_cnt = 0
				comments.append(comm)
			elif self.token_class_is('annotation'):
				x = self.parse_annotation()
				x['nl'] = nl_cnt
				anno.append(x)
			#elif self.match("\n"):
			#	pass
			else:
				break
			nl_cnt += self.skip_blanks()

		return (comments, anno, nl_cnt)


	def parse_annotations(self, nl_cnt=0):
		anno = []
		while not self.is_end():
			if self.token_class_is('annotation'):
				x = self.parse_annotation()
				x['nl'] = nl_cnt
				anno.append(x)
			#elif self.match("\n"):
			#	pass
			else:
				break
			nl_cnt += self.skip_blanks()

		return (anno, nl_cnt)


	#
	# Top Level Directives
	#

	def parse_include(self):
		ti = self.ti()
		import_expr = self.expr_value()

		return {
			'isa': 'ast_directive',
			'kind': 'include',
			'expr': import_expr,
			'is_include': True,
			'as': None,
			'args': [],
			'ti': ti
		}


	def parse_import(self, include=False):
		ti = self.ti()
		import_expr = self.expr_value()

		_as = None
		if self.match("as"):
			_as = self.parse_identifier()

		return {
			'isa': 'ast_directive',
			'kind': 'import',
			'expr': import_expr,
			'is_include': False,
			'as': _as,
			'args': [],
			'ti': ti
		}



	def parse_def_func(self):
		ti = self.ti()
		id = self.parse_identifier()
		ftyp = self.expr_type()

		if self.is_comment():
			self.skip1()

#		while self.is_comment() or self.look("\n"):
#			if self.is_end():
#				break
#			self.skip1()

		stmt = None
		if self.look("{"):
			stmt = self.stmt_block()

		return {
			'isa': 'ast_definition',
			'kind': 'func',
			'id': id,
			'type': ftyp,
			'stmt': stmt,
			'ti': ti
		}


	def parse_stmt_xvar(self, access_modifier='undefined'):
		ti = self.ti()
		id = self.parse_identifier()

		ids = [id]
		while self.match(","):
			id = self.parse_identifier()
			ids.append(id)

		t = None
		if self.match(":"):
			t = self.expr_type()
		else:
			t = None

		init_value = None
		if self.is_assign_operator():
			self.skip1() # skip assign operator
			self.skipn("\n")
			init_value = self.expr_value()
		else:
			init_value = self.expr_ValueUndef(ti)

		res = []
		for id in ids:
			xx = {
				'isa': 'ast_stmt',
				'kind': 'var',
				'id': id,
				'type': t,
				'init_value': init_value,
				'access_modifier': access_modifier,
				'anno': [],
				'nl': 1,
				'ti': ti
			}
			res.append(xx)

		return res


	def parse_def_const(self):
		x = self.parse_stmt_xvar()[0]
		x['isa'] = 'ast_definition'
		x['kind'] = 'const'
		return x


	def parse_def_var(self):
		xx = self.parse_stmt_xvar()
		for x in xx:
			x['isa'] = 'ast_definition'
		return xx


	def parse_def_type(self):
		ti = self.ti()
		id = self.parse_identifier()

		if self.is_comment():
			self.skip1()

		self.need("=")

		t = None
		if not self.look("\n"):
			t = self.expr_type()

		return {
			'isa': 'ast_definition',
			'kind': 'type',
			'id': id,
			'type': t,
			'ti': ti
		}


	def restore_top_level(self):
		while not self.is_end():
			token_str = self.ctok()
			if token_str in ['func', 'const', 'var', 'type', 'exist', 'extern']:
				break
			self.skip1()


	def parse_if_comment_line(self):
		ti = self.ti()
		x = self.gettok()
		return {
			'isa': 'ast_comment',
			'kind': 'comment-line',
			'lines': x,
			'nl': 0,
			'ti': ti
		}


	def parse_if_comment_block(self):
		ti = self.ti()
		x = self.gettok()
		return {
			'isa': 'ast_comment',
			'kind': 'comment-block',
			'text': x,
			'nl': 0,
			'ti': ti
		}



	def parse_annotation(self):
		ti = self.ti()
		x = self.gettok()

		args = []
		if self.look("("):
			args = self.parse_args()

		att = {
			'isa': 'ast_annotation',
			'kind': x,
			'args': args,
			'ti': ti
		}

		return att


	def parse_directive(self):
		ti = self.ti()
		x = self.gettok()

		args = []
		while not self.match("\n"):
			a = self.gettok()
			args.append(a)

		dir = {
			'isa': 'ast_directive',
			'kind': x,
			'args': args,
			'ti': ti
		}

		return dir


	def skipnl(self):
		n = 0
		if self.match('\n'):
			n = n + 1
		return n


	def parse(self, tokens):
		if len(tokens) == 0:
			return []

		self.tokens = tokens
		self.ctoken = 0

		output = []

		spaceline_cnt = 0

		while self.skipnl():
			spaceline_cnt += 1
		comm = self.parse_if_comment()
		if comm != None:
			comm['nl'] = spaceline_cnt
			spaceline_cnt = 0
			#output.append(comm)
		while self.skipnl():
			spaceline_cnt += 1
		if self.match('module'):
			ti = self.ti()
			s = self.gettok()
			module_str = self.parse_value_string(s, ti)
			module_directive = {
				'isa': 'ast_directive',
				'kind': 'module',
				'line': module_str,
				'ti': ti
			}
			output.append(module_directive)


		annotations = []
		#comments = []
		while not self.is_end():
			ca = self.parse_annotations(nl_cnt=spaceline_cnt)
			#comments.extend(ca[0])
			annotations.extend(ca[0])
			spaceline_cnt = ca[1]

			access_modifier = self.parse_access_modifier()

			ti = self.ti()

			x = None

			if self.match('\n'):
				spaceline_cnt += 1
				continue

			if self.match('func'):
				x = self.parse_def_func()
			elif self.match('const'):
				x = self.parse_def_const()
			elif self.match('var'):
				x = self.parse_def_var()
			elif self.match('type'):
				x = self.parse_def_type()
			elif self.token_class_is('comment-block'):
				x = self.parse_if_comment_block()
			elif self.token_class_is('comment-line'):
				x = self.parse_if_comment_line()
			elif self.look('pragma'):
				x = self.parse_directive()
			elif self.match('import'):
				x = self.parse_import()
			elif self.match('include'):
				x = self.parse_include()
			else:
				error("unexpected token '%s'" % self.ctok(), self.ti())
				self.restore_top_level()
				continue

			if x != None:
				if not isinstance(x, list):
					x['nl'] = spaceline_cnt
					x['ti'] = ti
					x['access_modifier'] = access_modifier
					x['anno'] = annotations
					output.append(x)
				else:
					for xx in x:
						xx['nl'] = 1
						xx['ti'] = ti
						xx['access_modifier'] = access_modifier
						xx['anno'] = annotations
					x[0]['nl'] = spaceline_cnt
					output.extend(x)

			annotations = []
			spaceline_cnt = 0

		return output



	def restore(self, stoppers):
		while not self.ctok() in stoppers:
			if self.ctok() == '':
				return
			self.skip1()


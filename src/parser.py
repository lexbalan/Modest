#####################################################################
#                             PARSER                                #
#####################################################################

import os
from error import error, warning, info
from hlir.hlir import Id
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


	def skip(self):
		if self.ctoken < (len(self.tokens) - 1):
			self.ctoken = self.ctoken + 1


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
		self.skip()
		return t


	#skip_tokens_class(['nl'])
	def skip_tokens_class(self, classes):
		while self.ctok_class() in classes:
			self.skip()


	def skip_tokens(self, tokens):
		while self.ctok() in tokens:
			self.skip()


	def look(self, token):
		return self.ctok() == token


	def match(self, token):
		if self.token_class_is('str'):
			return False

		yes = self.look(token)
		if yes:
			self.skip()

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
		return self.match("<-") or self.match("=") or self.match("=")

	def is_identifier(self):
		return self.ctok_class() == 'id'

	def is_operator(self):
		return self.ctok_class() == 'op'

	def is_tag(self):
		return self.ctok_class() == 'tag'


	def identifier(self):
		ti = self.ti()
		if not self.is_identifier():
			self.skip()
			error("expected identifier", ti)
			return None
		s = self.gettok()
		return {'isa': 'ast_id', 'kind': 'id', 'str': s, 'ti': ti} #Id(s, ti=ti) ####


	def need_sep(self, separators=['\n', ';'], stoppers=['}'], eat=True):
		# random space after

		if self.ctok() in separators:
			if eat:
				while self.ctok() in separators:
					self.skip()

		elif self.ctok() in stoppers:
			pass
		elif self.ctok_class() in ['comment-line', 'comment-block']:
			self.skip()
			pass
		else:
			error("expected separator", self.ti())
			self.restore(top_level_stoppers + func_stoppers)
			return False

		return True

	#
	# Parse Type
	#


	def expr_TypeUndefined(self, ti):
		return {
			'isa': 'ast_type',
			'kind': 'undefined',
			'attributes': [],
			'ti': ti
		}


	def expr_type_record(self, ti):
		self.need("{")
		fields = []

		spaceline_cnt = 0

		while True:
			#self.skip_tokens_class(['nl'])

			comments = []
			attributes = []

			spaceline_cnt = 0

			# skip spaces & comments before
			while True:
				if self.match('\n'):
					spaceline_cnt = spaceline_cnt + 1
					continue
				elif self.token_class_is('comment-block'):
					x = self.parse_comment_block()
					x['nl'] = spaceline_cnt
					spaceline_cnt = 0
					comments.append(x)
				elif self.token_class_is('comment-line'):
					x = self.parse_comment_line()
					x['nl'] = spaceline_cnt
					spaceline_cnt = 0
					comments.append(x)
				elif self.token_class_is('attribute'):
					x = self.parse_attribute()
					x['nl'] = spaceline_cnt
					spaceline_cnt = 0
					attributes.append(x)
				elif self.match(","):
					pass
				elif self.match(";"):
					pass
				else:
					break

			if self.match("}"):
				break

			f = self.parse_field()
			#f = self.stmt_var()

			self.need_sep(separators=['\n', ',', ';'], eat=False)

			if f != None:
				f[0].update({'comments': comments})
				f[0].update({'attributes': attributes})
				f[0]['nl'] = spaceline_cnt
				spaceline_cnt = 0
				fields.extend(f)

		return {
			'isa': 'ast_type',
			'kind': 'record',
			'fields': fields,
			'nl_end': spaceline_cnt,
			'ti': ti
		}


	def check_is_field(self):
		if self.is_identifier():
			token = self.gettok()
			if isUpperIdentifierToken(token):
				return False
			if not self.match(':'):
				return False

			return True


	def is_attribute(self):
		return self.token_class_is('attribute')


	def check_is_type(self):
		if self.is_identifier():
			if self.nextok() == '.':
				self.skip()
				self.skip()
			token = self.gettok()
			if isUpperIdentifierToken(token):
				return True
			return token in ['record', 'enum']

		elif self.is_operator():
			token = self.gettok()
			if token == '*':
				# maybe it is pointer? (or it's 'deref' operation)
				return self.is_type_expr()

			elif token == '[':
				# maybe it is array?
				while not self.match(']'):
					self.skip()
				return self.is_type_expr()

			elif token == '(':
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

		elif self.is_attribute():
			self.parse_attribute()
			return self.check_is_type()

		else:
			return False

		return False


	def is_type_expr(self):
		pos = self.getpos()			# save position
		result = self.check_is_type()  # check
		self.setpos(pos)			   # restore position
		return result


	# TODO: now not used
	def is_value_expr(self):
		pos = self.getpos()				   # save position
		result = not self.check_is_type()  # check

		# TODO!
		#if result == False:
		#	return self.is_value_expr()

		self.setpos(pos)				   # restore position
		return result


	def expr_type_func(self):
		ti = self.ti()
		self.skip()  # "("
		arghack = False
		fields = []
		while not self.match(")"):
			#f = self.parse_field()
			f = self.stmt_var()
			if f == None:
				if self.match("..."):
					arghack = True
			self.match(",")
			if f != None:
				fields.extend(f)

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

		# parse all attributes before
		attributes = []
		while self.token_class_is('attribute'):
			x = self.parse_attribute()
			attributes.append(x)

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
				id = self.identifier()
				self.need_sep(separators=['\n', ','])
				items.append({'id': id, 'ti': ti})
			t = {'isa': 'ast_type', 'kind': 'enum', 'items': items, 'ti': ti}

		elif self.match("["):
			y = {'isa': 'ast_type', 'kind': 'array', 'size': None, 'ti': ti}
			if self.match("]"):
				y['size'] = self.expr_ValueUndefined(ti)
			else:
				y['size'] = self.expr_value()
				self.need("]")
			y['of'] = self.expr_type()
			t = y

		elif self.ctok_class() == 'id':
			id = self.identifier()
			ids = [id]

			while self.match('.'):
				id = self.identifier()
				ids.append(id)

			t = {
				'isa': 'ast_type',
				'kind': 'id',
				'ids': ids,
				'ti': ti
			}

		t['attributes'] = attributes
		return t


	#
	# Parse Value
	#

	def expr_ValueUndefined(self, ti):
		return {
			'isa': 'ast_value',
			'kind': 'undefined',
			'attributes': [],
			'ti': ti
		}


	def expr_value(self):
		x = self.expr_value_1()
		#x['nl'] = 0
		return x


	def expr_value_1(self):
		v = self.expr_value_2()
		ti = self.ti()
		if self.match("or"):
			self.match("\n")
			r = self.expr_value()
			ti['start'] = v['ti']
			ti['end'] = r['ti']
			return {'isa': 'ast_value', 'kind': 'or', 'left': v, 'right': r, 'ti': ti}
		else:
			return v


	def expr_value_2(self):
		v = self.expr_value_3()
		ti = self.ti()
		if self.match("xor"):
			self.match("\n")
			r = self.expr_value_2()
			ti['start'] = v['ti']
			ti['end'] = r['ti']
			return {'isa': 'ast_value', 'kind': 'xor', 'left': v, 'right': r, 'ti': ti}
		else:
			return v


	def expr_value_3(self):
		v = self.expr_value_4()
		ti = self.ti()
		if self.match("and"):
			self.match("\n")
			r = self.expr_value_3()
			ti['start'] = v['ti']
			ti['end'] = r['ti']
			return {'isa': 'ast_value', 'kind': 'and', 'left': v, 'right': r, 'ti': ti}
		else:
			return v


	def expr_value_4(self):
		v = self.expr_value_5()
		while True:
			ti = self.ti()
			if self.match("=="):
				self.match("\n")
				r = self.expr_value_5()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'eq', 'left': v, 'right': r, 'ti': ti}
			elif self.match("!="):
				self.match("\n")
				r = self.expr_value_5()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'ne', 'left': v, 'right': r, 'ti': ti}
			else:
				break
		return v


	def expr_value_5(self):
		v = self.expr_value_6()
		while True:
			ti = self.ti()
			if self.match("<"):
				self.match("\n")
				r = self.expr_value_6()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'lt', 'left': v, 'right': r, 'ti': ti}
			elif self.match(">"):
				self.match("\n")
				r = self.expr_value_6()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'gt', 'left': v, 'right': r, 'ti': ti}
			if self.match("<="):
				self.match("\n")
				r = self.expr_value_6()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'le', 'left': v, 'right': r, 'ti': ti}
			elif self.match(">="):
				self.match("\n")
				r = self.expr_value_6()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'ge', 'left': v, 'right': r, 'ti': ti}
			else:
				break
		return v


	def expr_value_6(self):
		v = self.expr_value_7()
		while True:
			ti = self.ti()
			if self.match("<<"):
				self.match("\n")
				l = v
				r = self.expr_value_7()
				ti['start'] = l['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'shl', 'left': v, 'right': r, 'ti': ti}
			elif self.match(">>"):
				self.match("\n")
				l = v
				r = self.expr_value_7()
				ti['start'] = l['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'shr', 'left': v, 'right': r, 'ti': ti}
			else:
				break
		return v


	def expr_value_7(self):
		v = self.expr_value_8()
		while True:
			ti = self.ti()
			if self.match("+"):
				self.match("\n")
				r = self.expr_value_8()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'add', 'left': v, 'right': r, 'ti': ti}
			elif self.match("-"):
				self.match("\n")
				r = self.expr_value_8()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'sub', 'left': v, 'right': r, 'ti': ti}
			else:
				break
		return v


	def expr_value_8(self):
		v = self.expr_value_9()
		while True:
			ti = self.ti()
			if self.match("*"):
				self.match("\n")
				r = self.expr_value_9()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'mul', 'left': v, 'right': r, 'ti': ti}
			elif self.match("/"):
				self.match("\n")
				r = self.expr_value_9()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'div', 'left': v, 'right': r, 'ti': ti}
			elif self.match("%"):
				self.match("\n")
				r = self.expr_value_9()
				ti['start'] = v['ti']
				ti['end'] = r['ti']
				v = {'isa': 'ast_value', 'kind': 'rem', 'left': v, 'right': r, 'ti': ti}
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
				'ti': ti
			}

		else:
			return self.expr_value_10()



	def expr_value_10(self):
		ti = self.ti()
		if self.match("*"):
			v = self.expr_value_10()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'deref', 'value': v, 'ti': ti}
		elif self.match("&"):
			v = self.expr_value_11()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'ref', 'value': v, 'ti': ti}
		elif self.match("not"):
			v = self.expr_value_11()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'not', 'value': v, 'ti': ti}
		elif self.match("+"):
			v = self.expr_value_11()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'pos', 'value': v, 'ti': ti}
		elif self.match("-"):
			v = self.expr_value_11()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'neg', 'value': v, 'ti': ti}
		elif self.match("unsafe"):
			v = self.expr_value()
			ti['end'] = v['ti']
			return {'isa': 'ast_value', 'kind': 'unsafe', 'value': v, 'ti': ti}
		elif self.match("sizeof"):
			self.match("(")
			rv = None
			if self.is_type_expr():
				t = self.expr_type()
				rv = {'isa': 'ast_value', 'kind': 'sizeof_type', 'type': t, 'ti': ti}
			else:
				v = self.expr_value()
				rv = {'isa': 'ast_value', 'kind': 'sizeof_value', 'value': v, 'ti': ti}
			self.need(")")
			return rv
		elif self.match("alignof"):
			self.match("(")
			t = self.expr_type()
			self.need(")")
			return {'isa': 'ast_value', 'kind': 'alignof', 'type': t, 'ti': ti}
		elif self.match("offsetof"):
			self.match("(")
			t = self.expr_type()
			self.need('.')
			f = self.identifier()
			self.need(")")
			return {'isa': 'ast_value', 'kind': 'offsetof', 'type': t, 'field': f, 'ti': ti}
		elif self.match("lengthof"):
			self.match("(")
			v = self.expr_value()
			rv = {'isa': 'ast_value', 'kind': 'lengthof_value', 'value': v, 'ti': ti}
			self.need(")")
			return rv
		elif self.match("__va_start"):
			self.match("(")
			v0 = self.expr_value()
			self.need(",")
			v1 = self.expr_value()
			rv = {'isa': 'ast_value', 'kind': '__va_start', 'values': [v0, v1], 'ti': ti}
			self.need(")")
			return rv
		elif self.match("__va_copy"):
			self.match("(")
			v0 = self.expr_value()
			self.need(",")
			v1 = self.expr_value()
			rv = {'isa': 'ast_value', 'kind': '__va_copy', 'values': [v0, v1], 'ti': ti}
			self.need(")")
			return rv
		elif self.match("__va_end"):
			self.match("(")
			v = self.expr_value()
			rv = {'isa': 'ast_value', 'kind': '__va_end', 'value': v, 'ti': ti}
			self.need(")")
			return rv

		elif self.match("__defined"):
			self.match("(")
			rv = None
			if self.is_type_expr():
				t = self.expr_type()
				rv = {'isa': 'ast_value', 'kind': '__defined_type', 'type': t, 'ti': ti}
			else:
				v = self.expr_value()
				rv = {'isa': 'ast_value', 'kind': '__defined_value', 'value': v, 'ti': ti}
			self.need(")")
			return rv
		else:
			y = self.expr_value_11()
			return y


	def expr_value_11(self):
		# CALL
		v = self.expr_value_term()
		while True:
			ti = self.ti()
			if self.match("("):
				args = []
				while not self.match(")"):
					arg = None
					self.skip_tokens_class(['nl'])

					arg_ti = self.ti()
					arg_value = self.expr_value()
					nl_cnt = 0
					arg_id = None
					if self.match("="):
						if arg_value['kind'] != 'id':
							error("expected identifier", arg_value['ti'])

						#if not 'id' in arg_value:
							#print("isa = " + arg_value['isa'])
							#print("kind = " + arg_value['kind'])
							#print(arg_value)
							#info("HERE", arg_value['ti'])
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

					self.need_sep(separators=[',', '\n'], stoppers=[')'])

				v = {
					'isa': 'ast_value',
					'kind': 'call',
					'left': v,
					'args': args,
					'ti': ti
				}
			elif self.match("."):
				field_id = self.identifier()
				ti['start'] = v['ti']
				ti['end'] = field_id['ti']

				v = {
					'isa': 'ast_value',
					'kind': 'access',
					'left': v,
					'right': field_id,
					'ti': ti
				}
			#elif self.look("[") and self.is_value_expr():
			elif self.match("["):
				#self.skip()  # "["
				i = self.expr_value()
				if self.match(":"):
					j = None
					if not self.match("]"):
						j = self.expr_value()
						self.need("]")
					ti['start'] = v['ti']
					v = {
						'isa': 'ast_value',
						'kind': 'slice',
						'left': v,
						'index_from': i,
						'index_to': j,
						'ti': ti
					}
					return v

				self.need("]")
				ti['start'] = v['ti']
				v = {
					'isa': 'ast_value',
					'kind': 'index',
					'left': v,
					'index': i,
					'ti': ti
				}
			else:
				return v



	def parse_value_array(self, ti):
		array_ti = self.ti()
		items = []
		nl_cnt = 0
		item_id = 0
		self.need("[")
		while not self.match("]"):
			#self.skip_tokens_class(['nl'])
			nl_cnt = self.skip_blanks()

			if self.token_class_is('comment-block'):
				x = self.parse_comment_block()
				x['nl'] = nl_cnt
				items.append(x)
				continue
			elif self.token_class_is('comment-line'):
				x = self.parse_comment_line()
				x['nl'] = nl_cnt
				items.append(x)
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
			'nl_end': nl_cnt,
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

			if self.token_class_is('comment-block'):
				x = self.parse_comment_block()
				x['nl'] = nl_cnt
				items.append(x)
				continue
			elif self.token_class_is('comment-line'):
				x = self.parse_comment_line()
				x['nl'] = nl_cnt
				items.append(x)
				continue

			if self.match("}"):
				break

			item_ti = self.ti()
			item_id = self.identifier()
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
			'nl_end': nl_cnt,
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
						i = i - 1
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
				'ti': ti
			}




	def expr_value_term(self):
		ti = self.ti()

		if self.match("("):
			v = self.expr_value()
			self.need(")")
			v['ti'] = ti
			return v

		elif self.ctok_class() == 'id':
			id = self.identifier()

			# __va_arg hack
			if id['str'] == '__va_arg':
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
					'ti': ti
				}

			#return id

			return {
				'isa': 'ast_value',
				'kind': 'id',
				'str': id['str'],
				'ti': ti
			}


		elif self.ctok_class() == 'num':
			numstr = self.gettok()
			return {
				'isa': 'ast_value',
				'kind': 'number',
				'str': numstr,
				'att': [],
				'ti': ti
			}

		elif self.ctok_class() == 'str':
			s = self.gettok()
			return self.parse_value_string(s, ti)

		elif self.ctok_class() == 'tag':
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
			self.skip()
			return {'isa': 'ast_value', 'kind': 'bad', 'ti': ti}



	#
	# Parse Statement
	#

	def stmt_let(self):
		ti = self.ti()
		id = self.identifier()

		t = None
		v = None
		if self.match(":"):
			t = self.expr_type()
		#else:
		#	t = self.expr_TypeUndefined(ti)

		if self.is_assign_operator():
			v = self.expr_value()

		return {
			'isa': 'ast_stmt',
			'kind': 'let',
			'id': id,
			'type': t,
			'value': v,
			'ti': ti
		}


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
		self.skip()	# skip 'return' keyword

		v = None
		if not (self.look("\n") or self.look(";") or self.look("}")):
			v = self.expr_value()

		return {
			'isa': 'ast_stmt',
			'kind': 'return',
			'value': v
		}


	def stmt_var(self):
		ti = self.ti()

		if not self.is_identifier():
			return None

		ids = []
		while True:
			id = self.identifier()
			ids.append(id)
			if not self.match(','):
				break

		t = None
		init_value = None
		if self.match(":"):
			t = self.expr_type()
		else:
			t = self.expr_TypeUndefined(ti)

		if self.is_assign_operator():
			init_value = self.expr_value()

		if init_value == None:
			init_value = self.expr_ValueUndefined(ti)

		stmts = []
		for id in ids:
			stmt_var = {
				'isa': 'ast_stmt',
				'kind': 'var',
				'id': id,
				'type': t,
				'init_value': init_value,
				'access_modifier': 'public',
				'attributes': [],
				'nl': 1,
				'ti': id['ti']
			}
			stmts.append(stmt_var)
		return stmts


	def stmt_again(self):
		return {
			'isa': 'ast_stmt',
			'kind': 'again'
		}


	def stmt_break(self):
		return {
			'isa': 'ast_stmt',
			'kind': 'break'
		}


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
		if not (self.is_assign_operator()):
			return {'isa': 'ast_stmt', 'kind': 'value', 'value': v}

		# stmt assign
		r = self.expr_value()
		return {'isa': 'ast_stmt', 'kind': 'assign', 'left': v, 'right': r, 'ti': assign_ti}


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
		elif self.match('++'):
			s = self.stmt_inc()
		elif self.match('--'):
			s = self.stmt_dec()
		elif self.look('__asm'):
			s = self.stmt_asm()
		elif self.look('__va_arg'):
			s = self.stmt_va_arg()
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
		while True:
			#if ctok_class == 'nl':
			#if self.look(" ") or self.look("\t"):
			#	self.skip()
			#	continue

			#el

			if self.look('\n'):
				self.skip()
				nl_cnt = nl_cnt + 1
				continue

			else:
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
			'nl_end': nl_cnt,
			'ti': ti
		}

	def parse_access_modifier(self):
		if self.match('public'):
			return 'public'
		elif self.match('private'):
			return 'private'
		return 'private'

	def parse_field(self):
		ti = self.ti()

		objs = []
		while True:
			nl_cnt = 0

			comments_and_attributes = []
			while True:
				nl_cnt = self.skip_blanks()

				#if self.is_identifier():
				#	break

				x = None
				if self.token_class_is('comment-block'):
					x = self.parse_comment_block()
					x['nl'] = nl_cnt
					comments_and_attributes.append(x)
				elif self.token_class_is('comment-line'):
					x = self.parse_comment_line()
					x['nl'] = nl_cnt
					comments_and_attributes.append(x)
				elif self.token_class_is('attribute'):
					x = self.parse_attribute()
					x['nl'] = nl_cnt
					comments_and_attributes.append(x)
				else:
					break
				#if x != None:
				#	x['nl'] = nl_cnt


			access_modifier = self.parse_access_modifier()

			if not self.is_identifier():
				return None

			id = self.identifier()

			if id == None:
				break

			objs.append({
				'id': id,
				'comments_and_attributes': comments_and_attributes
			})

			if self.match(','):
				self.skip_tokens_class(['nl'])
				continue

			break

		if objs == []:
			self.restore(['\n', ','])
			return None

		if not self.need(":"):
			self.restore(['\n', ','])
			return None

		t = self.expr_type()

		fields = []
		for obj in objs:
			id = obj['id']
			field = {
				'isa': 'field',
				'id': id,
				'type': t,
				'init_value': None,
				'access_modifier': access_modifier,
				'attributes': [],
				'comments_and_attributes': obj['comments_and_attributes'],
				'nl': 1,
				'ti': id['ti']
			}
			fields.append(field)

		return fields


	#
	# Top Level Directives
	#

	def parse_import(self, include=False):
		ti = self.ti()

		if not self.look("{"):
			import_expr = self.expr_value()

			_as = None
			if self.match("as"):
				_as = self.identifier()

			return {
				'isa': 'ast_import',
				'kind': 'ast_import',
				'expr': import_expr,
				'include': include,
				'as': _as,
				'args': [],
				'ti': ti
			}

		else:
			imports = []
			self.skip()  # {
			while True:
				nl_cnt = self.skip_blanks()

				if self.match('}'):
					break

				import_expr = self.expr_value()

				_as = None
				if self.match("as"):
					_as = self.identifier()

				import_dir = {
					'isa': 'ast_attribute',
					'kind': 'import',
					'expr': import_expr,
					'include': include,
					'as': _as,
					'args': [],
					'ti': ti
				}

				imports.append(import_dir)

			return imports



	def parse_def_func(self):
		ti = self.ti()
		id = self.identifier()
		ftyp = self.expr_type()

		if self.is_comment():
			self.skip()

		stmt = None
		if not self.look("\n"):
			stmt = self.stmt_block()

		return {
			'isa': 'ast_definition',
			'kind': 'func',
			'id': id,
			'type': ftyp,
			'stmt': stmt,
			'ti': ti
		}


	def parse_def_const(self):
		ti = self.ti()
		id = self.identifier()

		t = None
		v = None
		if self.match(":"):
			t = self.expr_type()
		else:
			t = self.expr_TypeUndefined(ti)

		if self.is_assign_operator():
			v = self.expr_value()

		return {
			'isa': 'ast_definition',
			'kind': 'const',
			'id': id,
			'type': t,
			'value': v,
			'ti': ti
		}


	def parse_def_var(self):
		vars = self.stmt_var()
		for var in vars:
			var['isa'] = 'ast_definition'
		return vars


	def parse_def_type(self):
		ti = self.ti()
		id = self.identifier()

		if self.is_comment():
			self.skip()

		self.match("=")

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
			self.skip()


	def parse_comment_line(self):
		ti = self.ti()
		x = self.gettok()
		return {'isa': 'ast_comment', 'kind': 'comment-line', 'lines': x, 'ti': ti}


	def parse_comment_block(self):
		ti = self.ti()
		x = self.gettok()
		return {'isa': 'ast_comment', 'kind': 'comment-block', 'text': x, 'ti': ti}




	def parse_arglist(self):
		self.need("(")
		args = []
		while not self.match(")"):
			arg = None
			self.skip_tokens_class(['nl'])
			arg_ti = self.ti()
			arg_value = self.expr_value()
			args.append(arg_value)
			self.need_sep(separators=[',', '\n'], stoppers=[')'])
		return args


	def parse_attribute(self):
		ti = self.ti()
		x = self.gettok()

		args = []
		if self.look("("):
			args = self.parse_arglist()

		att = {
			'isa': 'ast_attribute',
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

		# Head
		if not self.is_end():
			if self.token_class_is('comment-block'):
				x = self.parse_comment_block()
			elif self.token_class_is('comment-line'):
				x = self.parse_comment_line()



		spaceline_cnt = 0

		public_region = False

		attributes = []
		while not self.is_end():

			if self.token_class_is('attribute'):
				a = self.parse_attribute()
				attributes.append(a)
				continue

			access_modifier = 'private'

			#self = parse_access_modifier()
			if self.match('public'):
				access_modifier = 'public'
				if self.match('{'):
					public_region = True
			elif self.match('private'):
				pass


			if public_region:
				access_modifier = 'public'

			ti = self.ti()

			x = None

			if self.match('\n'):
				spaceline_cnt = spaceline_cnt + 1
				continue
			elif self.match('func'):
				x = self.parse_def_func()
			elif self.match('const'):
				x = self.parse_def_const()
			elif self.match('var'):
				x = self.parse_def_var()
			elif self.match('type'):
				x = self.parse_def_type()
			elif self.token_class_is('comment-block'):
				x = self.parse_comment_block()
			elif self.token_class_is('comment-line'):
				x = self.parse_comment_line()
			elif self.token_class_is('directive'):
				x = self.parse_directive()
			elif self.match('import'):
				x = self.parse_import()
			elif self.match('include'):
				x = self.parse_import(include=True)

			elif public_region:
				if self.match('}'):
					public_region = False

			else:
				error("unexpected token '%s'" % self.ctok(), self.ti())
				self.restore_top_level()
				continue

			if x == None:
				continue

			if isinstance(x, list):
				for subx in x:
					subx['nl'] = 1
					subx['ti'] = ti
					subx['access_modifier'] = access_modifier
					subx['attributes'] = attributes

				x[0]['nl'] = spaceline_cnt
				output.extend(x)

			else:
				x['nl'] = spaceline_cnt
				x['ti'] = ti
				x['attributes'] = attributes
				x['access_modifier'] = access_modifier

				output.append(x)

			attributes = []
			spaceline_cnt = 0

		return output



	def restore(self, stoppers):
		while not self.ctok() in stoppers:
			if self.ctok() == '':
				return
			self.skip()


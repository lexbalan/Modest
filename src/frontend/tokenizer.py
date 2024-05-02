
from error import info

EOF_TOKEN = ('eof', '', None)

class Tokenizer:
	def __init__(self, rules):
		self.rules = rules

	def run(self, src):
		tokens = []
		while True:

			# EOF?
			if src.lookup(1) == '':
				return tokens + [EOF_TOKEN]

			pos_before = src.getpos()
			for rule in self.rules:

				result = rule(src)

				if result == False:
					src.setpos(pos_before)
					continue

				if result != None:
					tokens.append(result)

				break

		return None



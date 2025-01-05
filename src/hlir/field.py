

class Field():
	def __init__(self, id, type, ti=None):
		self.id = id
		self.type = type
		self.field_no = 0
		self.offset = 0
		self.access_level = 'private'
		self.att = []
		self.nl = 0
		self.ti = ti
		self.comments = None



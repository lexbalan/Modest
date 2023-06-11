
class Symtab:
  def __init__(self, parent=None):
    self.parent = parent
    self.types = {}
    self.values = {}

  # creates new symtab where #parent links to this symtab
  def branch(self):
    return Symtab(self)

  def parent_get(self):
    return self.parent


  def add_value(self, id, v):
    self.values[id] = v
    return v


  def add_type(self, id, t):
    self.types[id] = t
    return t


  def get_type(self, id):
    if id in self.types:
      return self.types[id]

    if self.parent != None:
      return self.parent.get_type(id)

    return None


  def get_value(self, id):
    if id in self.values:
      return self.values[id]

    if self.parent != None:
      return self.parent.get_value(id)

    return None




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


  def value_add(self, id, v):
    self.values[id] = v
    return v


  def type_add(self, id, t):
    self.types[id] = t
    return t


  def type_get(self, id):
    if id in self.types:
      return self.types[id]

    if self.parent != None:
      return self.parent.type_get(id)

    return None


  def value_get(self, id):
    if id in self.values:
      return self.values[id]

    if self.parent != None:
      return self.parent.value_get(id)

    return None



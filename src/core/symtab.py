
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


  # creates new symtab where #parent links to this symtab
  def branch(self):
    return Symtab(self)

  # extend this symtab with types & values from another symtab
  def merge(self, symtab):
    self.types.update(symtab.types)
    self.values.update(symtab.values)


  def parent_get(self):
    return self.parent


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


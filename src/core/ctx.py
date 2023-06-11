
from error import error
from core.symtab import Symtab


top = Symtab()

def push():
  global top
  top = top.branch()

def pop():
  global top
  top = top.parent_get()


def add_value(id, v):
  global top
  top.add_value(id, v)

def add_type(id, t):
  global top
  top.add_type(id, t)

def get_type(id):
  global top
  return top.get_type(id)

def get_value(id):
  global top
  return top.get_value(id)




from error import error

class ContextStack:

  def __init__(self):
    self.cctx = 0
    self.ctxs_type = [{}]
    self.ctxs_value = [{}]
    pass
  

  def push(self):
    self.ctxs_type.append({})
    self.ctxs_value.append({})
    self.cctx = self.cctx + 1
  

  def pop(self):
    if self.cctx > 0:
      self.ctxs_type.pop()
      self.ctxs_value.pop()
      self.cctx = self.cctx - 1
  

  # добавляет в последний контекст
  def add(self, id, x):
    self.ctxs[self.cctx][id] = x
  

  # ищет во всех контекстах начиная с последнего
  def get(self, id):
    i = self.cctx
    while i >= 0:
      ctx = self.ctxs[i]
      if id in ctx:
        return ctx[id]
      i = i - 1
    return None
  

  def add_type(self, id, t):
    t0 = self.get_type(id)
    if t0 != None:
      error("redefinition of '%s'" % id, t['ti'])

    self.ctxs_type[self.cctx][id] = t
    return t


  def add_value(self, id, v):
    v0 = self.get_value(id)
    if v0 != None:
      if v0['kind'] == 'func':
        if 'undefined' in v0['meta']:
          self.ctxs_value[self.cctx][id] = v
          return
      error("redefinition of '%s'" % id, v['ti'])

    self.ctxs_value[self.cctx][id] = v
    return v


  def get_type(self, id):
    i = self.cctx
    while i >= 0:
      ctx = self.ctxs_type[i]
      if id in ctx:
        return ctx[id]
      i = i - 1
    return None
  

  def get_value(self, id):
    i = self.cctx
    while i >= 0:
      ctx = self.ctxs_value[i]
      if id in ctx:
        return ctx[id]
      i = i - 1
    return None



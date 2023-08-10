
import os

f = None


indent_level = 0

def indent_up():
  global indent_level
  indent_level = indent_level + 1


def indent_down():
  global indent_level
  indent_level = indent_level - 1


def indentation(symbol):
  global indent_level
  return symbol * indent_level


def nl_indentation(symbol):
  global indent_level
  return "\n" + symbol * indent_level


def ind(symbol):
  f.write(indentation(symbol))



def out(s):
  global f
  f.write(s)


def lo(s):
  global f
  f.write('\n')
  f.write(s)


def output_open(fname):
  global f
  dirname = os.path.dirname(fname)
  if dirname != '':
    os.makedirs(dirname, exist_ok=True)
  f = open(fname, "w")


def output_close():
  global f
  f.close()






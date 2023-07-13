
import os

f = None

INDENT_SYMBOL = " " * 4

indent = 0


def indent_up():
  global indent
  indent = indent + 1


def indent_down():
  global indent
  indent = indent - 1


def ind():
  global indent
  f.write(INDENT_SYMBOL * indent)



def o(s):
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






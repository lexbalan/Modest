
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


def o(s):
  global f
  f.write(s)


def lo(s):
  global f
  f.write('\n')
  f.write(s)


def ind():
  global indent
  f.write(INDENT_SYMBOL * indent)


def printer_open(fname):
  global f
  dirname = os.path.dirname(fname)
  if dirname != '':
    os.makedirs(dirname, exist_ok=True)
  f = open(fname, "w")


def printer_close():
  global f
  f.close()

def comma():
  o(", ")

def space():
  o(" ")


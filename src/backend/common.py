
import os

f = None

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
  f.write("\t" * indent)


def printer_open(fname):
  global f
  os.makedirs(os.path.dirname(fname), exist_ok=True)
  f = open(fname, "w")


def printer_close():
  global f
  f.close()

def comma():
  o(", ")

def space():
  o(" ")


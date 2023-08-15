#
# ../mcc -o main -mbackend=printer_c -mopt=speed -funsafe main.cm
#
import os
import argparse
import importlib

from opt import *

DEFAULT_MINT = 32
DEFAULT_MPTR = 64
DEFAULT_MFLT = 64
DEFAULT_MCHAR = 8
DEFAULT_MLIB = ""
DEFAULT_BACKEND = 'llvm'

# right here!
settings_set('int', DEFAULT_MINT)
settings_set('ptr', DEFAULT_MPTR)
settings_set('flt', DEFAULT_MFLT)
settings_set('char', DEFAULT_MCHAR)
settings_set('lib', DEFAULT_MLIB)
settings_set('backend', DEFAULT_BACKEND)

import error
import core.trans as trans


parser = argparse.ArgumentParser(
  prog = 'ProgramName',
  #description = 'What the program does',
  #epilog = 'Text at the bottom of help'
)


parser.add_argument('filename', default='main')
parser.add_argument('-o', '--output')
parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
parser.add_argument('-m', action='append', help='-m<var>=<value>')
parser.add_argument('-d', action='append', help='-d<constant_name>="<value_expression>"')
#parser.add_argument('-v', '--verbose')
args = parser.parse_args()


def main():
  #print(os.getcwd())

  path_lib = os.getenv('MODEST_LIB')
  if path_lib == None:
    fatal("MODEST_LIB required")

  # set default settings
  settings_set('lib', path_lib)


  # parse features (ex. -funsafe)
  if args.feature != None:
    for feature in args.feature:
      features_set(feature)

  # parse modifiers (-mbackend=c)
  # and change default settings
  if args.m != None:
    for mod in args.m:
      k, v = mod.split('=')
      settings_set(k, v)


  if args.d != None:
    for d in args.d:
      print("DEF: " + str(d))

  src_name = args.filename

  # is header?
  splittded_name = src_name.split(".")
  if splittded_name[-1] == 'hm':
    features_set('header')

  src_abspath = os.path.abspath(src_name)
  src_dirname = os.path.dirname(src_abspath)

  settings_set('path', src_dirname)
  
  
  # loading backend
  backend_name = settings_get('backend')
  backend = importlib.import_module("backend." + backend_name)
  
  # трбует ли бэкенд импорта объектов из модуля (LLVM)
  # или ему хватает символов (C, CM)
#  import_objects = backend.IMPORT_OBJECTS
#  settings_set('import_objects', import_objects)
  

  trans.init()

  module = trans.translate(src_name)

  if error.errcnt > 0 or module == None:
    #error.fatal("%d errors occurred" % error.errcnt)
    exit(1)

  backend.init()

  # print output
  if args.output != None:
    outname = args.output
  else:
    outname = splittded_name[0]

  backend.run(module, outname)



if __name__ == '__main__':
  main()


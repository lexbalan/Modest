#
# ../mcc -o main -mbackend=printer_c -mopt=speed -funsafe main.cm
#

import os
import argparse
import importlib
import error
import core.trans as trans


backend = None

src_dirname = ""


parser = argparse.ArgumentParser(
  prog = 'ProgramName',
  #description = 'What the program does',
  #epilog = 'Text at the bottom of help'
)


parser.add_argument('filename', default='main')
parser.add_argument('-o', '--output')
parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
parser.add_argument('-m', action='append', help='-m<var>=<value>')
#parser.add_argument('-v', '--verbose')
args = parser.parse_args()


def main():
  global src_dirname

  print(os.getcwd())

  path_lib = os.getenv('MODEST_LIB')
  #print("path_lib = %s" % path_lib)
  if path_lib == None:
    fatal("MODEST_LIB required")

  # set default settings
  trans.settings_set('library', path_lib)
  trans.settings_set('backend', 'printer_ll')
  trans.settings_set('enum_size', 2)

  # parse modifiers (-mbackend=c)
  # and change default settings
  for mod in args.m:
    k, v = mod.split('=')
    trans.settings_set(k, v)

  # parse features (ex. -funsafe)
  if args.feature != None:
    for feature in args.feature:
      trans.features_set(feature)

  src_name = args.filename

  # is header?
  splittded_name = src_name.split(".")
  if splittded_name[-1] == 'hm':
    trans.features_set('header')

  src_abspath = os.path.abspath(src_name)
  #print("ABS: " + src_abspath)
  src_dirname = os.path.dirname(src_abspath)
  #print("DIR: " + src_dirname)

  trans.settings_set('path', src_dirname)

  trans.init()

  m = trans.translate(src_name)
  text = m['text']
  symtab = m['symtab']

  if error.errcnt > 0:
    #error.fatal("%d errors occurred" % error.errcnt)
    exit(1)

  # loading backend
  backend_name = trans.settings_get('backend')
  backend = importlib.import_module("backend." + backend_name)

  # print output
  if args.output != None:
    outname = args.output
  else:
    outname = splittded_name[0]


  backend.run(text, trans.strpool, outname)



if __name__ == '__main__':
  main()


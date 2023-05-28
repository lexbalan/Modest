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

  # set default settings
  trans.settings_set('backend', 'printer_ll')
  trans.settings_set('enum_size', 2)

  # parse modifiers (-mbackend=c)
  # and change default settings
  for mod in args.m:
    k, v = mod.split('=')
    trans.settings_set(k, v)

  # parse features (-funsafe)
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
  module = trans.translate(src_name)

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


  backend.run(module, trans.strpool, outname)



if __name__ == '__main__':
  main()


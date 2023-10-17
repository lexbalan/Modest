#
# ../mcc -o main -mbackend=printer_c -mopt=speed -funsafe main.cm
#
import os
import argparse
import importlib
import tomllib

CONFIG_PATH = os.path.expandvars("${MODEST_DIR}/config.toml")

toml_dict = None
# Opening a Toml file using tomlib
with open(CONFIG_PATH, "rb") as toml:
        toml_dict = tomllib.load(toml)

#print(toml_dict)


config = toml_dict['Default']

path_lib = os.getenv('MODEST_LIB')

from opt import *

import settings

DEFAULT_MCHAR = config['char_size']#8
DEFAULT_MINT = config['int_size']#32
DEFAULT_MPTR = config['ptr_size']#64
DEFAULT_MFLT = config['flt_size']#64
DEFAULT_MLIB = ""
DEFAULT_BACKEND = 'llvm'

# right here!
settings.set('int', DEFAULT_MINT)
settings.set('ptr', DEFAULT_MPTR)
settings.set('flt', DEFAULT_MFLT)
settings.set('char', DEFAULT_MCHAR)
settings.set('lib', DEFAULT_MLIB)
settings.set('backend', DEFAULT_BACKEND)

import error
import trans


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
    global path_lib
    #path_lib = os.getenv('MODEST_LIB')
    if path_lib == None:
        fatal("MODEST_LIB required")

    # set default settings
#    settings.set('lib', path_lib)
#    path_lib2 = settings.get('lib')
#    print(f"path_lib2 = {path_lib2}")
    #global config
    #config['lib'] = path_lib


    # parse features (ex. -funsafe)
    if args.feature != None:
        for feature in args.feature:
            features_set(feature)

    # parse modifiers (-mbackend=c, -mstyle=legacy)
    # and change default settings
    if args.m != None:
        for mod in args.m:
            k, v = mod.split('=')
            settings.set(k, v)


    if args.d != None:
        for d in args.d:
            print("DEF: " + str(d))

    src_name = os.path.normpath(args.filename)

    #print("CPL: " + src_name)

    # is header?
    if src_name[-2:] == 'hm':
        features_set('header')

    src_abspath = os.path.abspath(src_name)
    src_dirname = os.path.dirname(src_abspath)

    settings.set('path', src_dirname)


    # loading backend
    backend_name = settings.get('backend')
    backend = importlib.import_module("backend." + backend_name)

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


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


import settings


def load_config(setup_name):
    #print("load_setup %s" % setup_name)

    config = toml_dict[setup_name]

    for k in config:
        v = config[k]
        #print("SET %s = %s" % (k, v))
        settings.set(k, v)


#print("WTF?")  # за каким то хером вызываетс два раза, видимо из-за импорта
load_config('Default')


import error
import trans


import features

parser = argparse.ArgumentParser(
    prog = 'ProgramName',
    #description = 'What the program does',
    #epilog = 'Text at the bottom of help'
)


parser.add_argument('filename', default='main')
parser.add_argument('-o', '--output')
parser.add_argument('-s', '--setup', help='-setup=<value>')
parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
parser.add_argument('-m', action='append', help='-m<var>=<value>')
parser.add_argument('-d', action='append', help='-d<constant_name>="<value_expression>"')
#parser.add_argument('-v', '--verbose')
args = parser.parse_args()




def main():
    #print(os.getcwd())

    path_lib = os.getenv('MODEST_LIB')
    if path_lib != None:
        settings.set('lib', path_lib)
    else:
        fatal("MODEST_LIB required")


    # parse features (ex. -funsafe)
    global features
    if args.feature != None:
        for feature in args.feature:
            features.set(feature)


    if args.setup != None:
        setup_name = args.setup
        load_config(setup_name)

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
        features.set('header')

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


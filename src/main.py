#
# ../mcc -o main -mbackend=printer_c -mopt=speed -funsafe main.m
#

import os
import argparse
import importlib
import tomllib
import settings
import error


def load_config(config_name):
	config = {}

	# Opening a Toml file using tomlib
	cfg_path = os.path.expandvars("${MODEST_DIR}/cfg/%s.toml" % config_name)
	with open(cfg_path, "rb") as toml:
		config = tomllib.load(toml)

	for k in config:
		v = config[k]
		settings.set(k, v)


#print("WTF?")  # за каким то хером вызываетс два раза, видимо из-за импорта
load_config('default')


import trans
import features


parser = argparse.ArgumentParser(
	prog = 'ProgramName',
	#description = 'What the program does',
	#epilog = 'Text at the bottom of help'
)


#parser.add_argument('filename', action='append', default=['main'])
parser.add_argument('-i', '--include')
parser.add_argument('-o', '--output')
parser.add_argument('-L', '--lib')
parser.add_argument('-s', '--setup', help='-setup=<value>')
parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
parser.add_argument('-m', action='append', help='-m<var>=<value>')
parser.add_argument('-d', action='append', help='-d<constant_name>="<value_expression>"')
#parser.add_argument('-v', '--verbose')
#args = parser.parse_args()
args, files = parser.parse_known_args()



def do_file(src_name):
	if not os.path.isfile(src_name):
		error.fatal("file %s not found" % src_name)

	file_base_name = os.path.basename(src_name)
	root_name = file_base_name.split(".")[0]
	#print(root_name)
	#print("CPL: " + src_name)

	# is header?
	if src_name[-2:] == 'hm':
		features.set('header')

	src_abspath = os.path.abspath(src_name)
	src_dirname = os.path.dirname(src_abspath)

	settings.set('path', src_dirname)


	trans.init()
	module = trans.translate(src_name)

	if error.errcnt > 0 or module == None:
		exit(1)

	# select & init backend
	backend_name = settings.get('backend')
	backend = importlib.import_module("backend.%s" % backend_name)
	backend.init()

	# print output
	if args.output != None:
		outname = args.output
	else:
		outname = root_name

	if args.include != None:
		include_dir = args.include
	else:
		include_dir = os.path.dirname(outname)

	backend.run(module, outname, {'include_dir': include_dir})



def main():
	#print(os.getcwd())

	path_lib = os.getenv('MODEST_LIB')
	if path_lib != None:
		settings.set('lib', path_lib)


	libb = args.lib
	if libb != None:
		settings.set('lib', libb)

	if path_lib == None and libb == None:
		error.fatal("MODEST_LIB required")


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


	#if args.d != None:
	#	for d in args.d:
	#		print("DEF: " + str(d))


	for src_filename in files:
		#print("=%s" % src_filename)
		src_name = os.path.normpath(src_filename)
		do_file(src_name)



if __name__ == '__main__':
	main()


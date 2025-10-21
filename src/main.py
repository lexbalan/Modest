
import os
import argparse
import importlib
import tomllib
import type

import error
import trans
from common import settings, features



def main():
	cwd = os.getcwd()
	#print(cwd)

	path_lib = os.getenv('MODEST_LIB')
	if path_lib != None:
		settings['lib'] = path_lib

	# Загружаем default config
	cfg_path = os.path.expandvars("${MODEST_DIR}/cfg/%s.toml" % 'default')
	apply_config(cfg_path)

	#print(settings)

	parser = argparse.ArgumentParser(
		prog = 'ProgramName',
		#description = 'What the program does',
		#epilog = 'Text at the bottom of help'
	)

	#parser.add_argument('filename', action='append', default=['main'])
	parser.add_argument('-i', '--include')
	parser.add_argument('-o', '--output')
	parser.add_argument('-L', '--lib')
	parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
	parser.add_argument('-m', action='append', help='-m<var>=<value>')
	parser.add_argument('-d', action='append', help='-d<constant_name>="<value_expression>"')
	parser.add_argument('--config', help='--config=<./main.cfg>')
	#parser.add_argument('-s', '--setup', help='-setup=<value>')
	#parser.add_argument('-v', '--verbose')
	#args = parser.parse_args()
	args, files = parser.parse_known_args()


	fdg = args.config
	if fdg != None:
		apply_config(cwd + '/' + fdg)

	libb = args.lib
	if libb != None:
		settings['lib'] = libb

	if settings['lib'] == None:
		error.fatal("required path to library")

	type.init(settings['pointer_width'])

	# parse features (ex. -funsafe)
	if args.feature != None:
		for feature in args.feature:
			features.append(feature)

	# parse modifiers (like -mbackend=c, -mstyle=legacy)
	# and change default settings
	if args.m != None:
		for mod in args.m:
			k, v = mod.split('=')
			settings[k] = v

	outname = args.output
	if outname == None:
		outname = root_name

	include_dir = args.include
	if args.include == None:
		include_dir = os.path.dirname(outname)
	settings['include_dir'] = include_dir

	# handle source files
	for src_filename in files:
		src_name = os.path.normpath(src_filename)
		do_file(src_name, outname, settings)



def do_file(src_name, outname, settings):
	if not os.path.isfile(src_name):
		error.fatal("file \"%s\" not found" % src_name)

#	file_base_name = os.path.basename(src_name)
#	root_name = file_base_name.split(".")[0]
#	src_abspath = os.path.abspath(src_name)
#	src_dirname = os.path.dirname(src_abspath)

	trans.init()
	module = trans.translate(src_name)

	if error.errcnt > 0 or module == None:
		exit(1)

	# select & run backend
	backend_impline = "backend." + settings['backend']
	backend = importlib.import_module(backend_impline)
	backend.init(settings)
	backend.run(module, outname)



# применяет конфигурационный файл поверх существующей конфигурации
def apply_config(cfg_path):
	from common import settings
	with open(cfg_path, "rb") as toml:
		config = tomllib.load(toml)
		settings.update(config)



if __name__ == '__main__':
	main()


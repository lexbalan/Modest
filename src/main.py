#
# ../mcc -o main -mbackend=printer_c -mopt=speed -funsafe main.m
#

import os
import argparse
import importlib
import tomllib

import error
import trans
from common import settings, features


# 1. Сперва применяется default config
# 2. Затем (опционально) конфиг проекта
# 3. Затем опции командной строки
# 4. И в последнюю очередь - pragma опции


def main():
	cwd = os.getcwd()
	print(cwd)

	# Загружаем default config
	cfg_path = os.path.expandvars("${MODEST_DIR}/cfg/%s.toml" % 'default')
	apply_config(cfg_path)

	parser = argparse.ArgumentParser(
		prog = 'ProgramName',
		#description = 'What the program does',
		#epilog = 'Text at the bottom of help'
	)

	#parser.add_argument('filename', action='append', default=['main'])
	parser.add_argument('-i', '--include')
	parser.add_argument('-o', '--output')
	parser.add_argument('-L', '--lib')
	parser.add_argument('--config', help='--config=<./main.cfg>')
	parser.add_argument('-s', '--setup', help='-setup=<value>')
	parser.add_argument('-f', '--feature', action='append', help='[unsafe]')
	parser.add_argument('-m', action='append', help='-m<var>=<value>')
	parser.add_argument('-d', action='append', help='-d<constant_name>="<value_expression>"')
	#parser.add_argument('-v', '--verbose')
	#args = parser.parse_args()
	args, files = parser.parse_known_args()


	fdg = args.config
	if fdg != None:
		apply_config(cwd + '/' + fdg)

	path_lib = os.getenv('MODEST_LIB')
	if path_lib != None:
		settings['lib'] = path_lib


	libb = args.lib
	if libb != None:
		settings['lib'] = libb

	if path_lib == None and libb == None:
		error.fatal("MODEST_LIB required")


	# parse features (ex. -funsafe)
	global features
	if args.feature != None:
		for feature in args.feature:
			features.append(feature)


	# parse modifiers (-mbackend=c, -mstyle=legacy)
	# and change default settings
	if args.m != None:
		for mod in args.m:
			k, v = mod.split('=')
			settings[k] = v


	for src_filename in files:
		src_name = os.path.normpath(src_filename)
		do_file(src_name, args)




def do_file(src_name, args):
	if not os.path.isfile(src_name):
		error.fatal("file %s not found" % src_name)

	file_base_name = os.path.basename(src_name)
	root_name = file_base_name.split(".")[0]
	#print(root_name)
	#print("CPL: " + src_name)


	src_abspath = os.path.abspath(src_name)
	src_dirname = os.path.dirname(src_abspath)

	settings['path'] = src_dirname


	trans.init()
	module = trans.translate(src_name)

	if error.errcnt > 0 or module == None:
		exit(1)

	# select & init backend
	backend_name = settings['backend']
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



# применяет конфигурационный файл поверх существующей конфигурации
def apply_config(cfg_path):
	from common import settings
	with open(cfg_path, "rb") as toml:
		config = tomllib.load(toml)
		settings.update(config)



if __name__ == '__main__':
	main()


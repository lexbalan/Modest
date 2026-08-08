#!/usr/bin/env python3
"""Modest test runner — positive tests.

A test is a single .m file whose leading comment block declares what is
expected of it.  The runner compiles it with each requested backend, links
the result with clang, runs the binary and checks the outcome.

Everything is built in a temporary directory: the source tree stays clean.

    ./run.py                    run everything
    ./run.py while              run tests whose path contains "while"
    ./run.py -b c11             only the C11 backend
    ./run.py -v                 show the command output of failing tests
    ./run.py --list             list discovered tests and exit

See README.md for the directive reference.
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field


TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT_DIR = os.path.dirname(TESTS_DIR)
MCC = os.path.join(ROOT_DIR, 'mcc')

# A hung compiler must fail the suite, not stall it (see docs/BUGS.md #8).
TIMEOUT_COMPILE = 30
TIMEOUT_LINK = 60
TIMEOUT_RUN = 10

CLANG_C_FLAGS = [
	'-std=c11', '-Wall', '-Wextra', '-pedantic',
	'-Wno-unused-variable', '-Wno-unused-parameter',
]

# Backends that emit source we can hand to clang, and the extension they use.
COMPILABLE = {'c11': '.c', 'llvm': '.ll'}
GENERATE_ONLY = {'modest': '.m'}
ALL_BACKENDS = list(COMPILABLE) + list(GENERATE_ONLY)

DEFAULT_BACKENDS = ['c11', 'llvm']

PASS, FAIL, XFAIL, XPASS, SKIP = 'pass', 'fail', 'xfail', 'xpass', 'skip'



# ---------------------------------------------------------------- test model

@dataclass
class Test:
	path: str                             # absolute path to the .m file
	name: str                             # path relative to tests/, for display
	mode: str = 'run'                     # run | build
	backends: list = field(default_factory=lambda: list(DEFAULT_BACKENDS))
	expect_exit: int = 0
	expect_out: list = field(default_factory=list)
	link: list = field(default_factory=list)   # extra .m sources to link in
	flags: list = field(default_factory=list)  # extra mcc flags
	xfail: dict = field(default_factory=dict)  # backend (or '*') -> reason

	def xfail_reason(self, backend):
		"""Why this test is expected to fail under `backend`, or None."""
		return self.xfail.get(backend) or self.xfail.get('*')


@dataclass
class Result:
	test: Test
	backend: str
	status: str
	reason: str = ''      # one line: what went wrong
	where: list = field(default_factory=list)  # a few lines: where it went wrong
	log: str = ''         # everything, shown under -v



# ------------------------------------------------------------------ directives

# KEY: value, or KEY(backend, ...): value to scope it to some backends.
DIRECTIVE = re.compile(r'^//\s*([A-Z][A-Z-]*)\s*(?:\(([^)]*)\))?\s*:\s*(.*)$')


def parse_test(path):
	"""Read the leading comment block of a .m file into a Test."""
	name = os.path.relpath(path, TESTS_DIR)
	t = Test(path=path, name=name)

	with open(path, encoding='utf-8') as f:
		for line in f:
			line = line.strip()
			if line == '' or line.startswith('//'):
				m = DIRECTIVE.match(line)
				if m:
					scope = [s.strip() for s in (m.group(2) or '').split(',') if s.strip()]
					apply_directive(t, m.group(1), scope, m.group(3).strip(), name)
				continue
			break  # first line of real code ends the header

	return t


def apply_directive(t, key, scope, value, name):
	for b in scope:
		if b not in ALL_BACKENDS:
			fatal("%s: unknown backend '%s' in %s(...)" % (name, b, key))

	if key == 'TEST':
		if value not in ('run', 'build'):
			fatal("%s: unknown TEST mode '%s' (expected run|build)" % (name, value))
		t.mode = value
	elif key == 'BACKENDS':
		t.backends = [b.strip() for b in value.split(',') if b.strip()]
		for b in t.backends:
			if b not in ALL_BACKENDS:
				fatal("%s: unknown backend '%s'" % (name, b))
	elif key == 'EXPECT-EXIT':
		t.expect_exit = int(value)
	elif key == 'EXPECT-OUT':
		t.expect_out.append(value)
	elif key == 'LINK':
		t.link += [s.strip() for s in value.split(',') if s.strip()]
	elif key == 'FLAGS':
		t.flags += value.split()
	elif key == 'EXPECTED-FAIL':
		reason = value or 'no reason given'
		for b in (scope or ['*']):
			t.xfail[b] = reason
	# Unknown ALL-CAPS keys are ignored on purpose: a test file may carry
	# comments of its own, and a typo in a directive is caught by the fact
	# that the expectation it was meant to express simply never fires.



# ------------------------------------------------------- locating the failure

# mcc and clang both colour their output whether or not a terminal is
# listening, so the captured text has to be cleaned before it is read.
ANSI = re.compile(r'\x1b\[[0-9;]*m')

# clang puts the whole diagnostic on one line; mcc puts the location on its
# own line and the message on the next.
CLANG_ERROR = re.compile(r'^(.+?):(\d+):(\d+):\s*(?:fatal\s+)?error:\s*(.*)$')
MCC_LOCATION = re.compile(r'^(.+?):(\d+):(\d+):$')
MCC_MESSAGE = re.compile(r'^(?:fatal\s+)?error:\s*(.*)$')


def first_error(log):
	"""The first compiler diagnostic, as one short `file:line: message`."""
	lines = log.splitlines()
	for i, line in enumerate(lines):
		m = CLANG_ERROR.match(line)
		if m:
			return '%s:%s: %s' % (os.path.basename(m.group(1)), m.group(2), m.group(4))

		m = MCC_LOCATION.match(line)
		if m and i + 1 < len(lines):
			msg = MCC_MESSAGE.match(lines[i + 1])
			if msg:
				return '%s:%s: %s' % (os.path.basename(m.group(1)), m.group(2), msg.group(1))
	return None


def last_output(log, n=3):
	"""The last few non-empty lines a program printed before it failed."""
	return [l for l in log.splitlines() if l.strip()][-n:]



# -------------------------------------------------------------------- running

def run(cmd, cwd, timeout):
	"""Run a command; return (exit_code, combined_output). -1 on timeout."""
	try:
		p = subprocess.run(
			cmd, cwd=cwd, timeout=timeout,
			stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
		return p.returncode, ANSI.sub('', p.stdout)
	except subprocess.TimeoutExpired:
		return -1, 'TIMEOUT after %ds: %s' % (timeout, ' '.join(cmd))


def run_case(t, backend, keep=False):
	"""Compile / link / run one test under one backend."""
	workdir = tempfile.mkdtemp(prefix='modest-test-')
	try:
		return do_case(t, backend, workdir)
	finally:
		if keep:
			print('  kept: %s' % workdir)
		else:
			shutil.rmtree(workdir, ignore_errors=True)


def do_case(t, backend, workdir):
	def result(status, reason='', where=None, log=''):
		return Result(t, backend, status, reason, where or [], log)

	def compiler_failed(what, code, out):
		# The diagnostic itself is what the reader needs, not the exit code.
		err = first_error(out)
		return result(FAIL, '%s failed (exit %d)' % (what, code),
		              [err] if err else last_output(out), out)

	sources = [t.path] + [os.path.join(os.path.dirname(t.path), s) for s in t.link]
	for s in sources:
		if not os.path.isfile(s):
			return result(FAIL, 'missing source %s' % s)

	# 1. Modest -> backend source
	generated = []
	for src in sources:
		prefix = os.path.join(workdir, os.path.splitext(os.path.basename(src))[0])
		cmd = [MCC] + t.flags + ['-o', prefix, '-mbackend=' + backend, src]
		code, out = run(cmd, workdir, TIMEOUT_COMPILE)
		if code != 0:
			return compiler_failed('mcc', code, out)

		ext = COMPILABLE.get(backend) or GENERATE_ONLY[backend]
		if not os.path.isfile(prefix + ext):
			return result(FAIL, 'mcc produced no %s' % ext, last_output(out), out)
		generated.append(prefix + ext)

	if backend in GENERATE_ONLY:
		# Nothing to link or run — reaching here means the backend accepted
		# the module.  (A round-trip check belongs here later.)
		return result(PASS)

	# 2. backend source -> executable
	if shutil.which('clang') is None:
		return result(SKIP, 'clang not found')

	binary = os.path.join(workdir, 'a.out')
	flags = CLANG_C_FLAGS if backend == 'c11' else []
	code, out = run(['clang'] + flags + generated + ['-o', binary],
	                workdir, TIMEOUT_LINK)
	if code != 0:
		return compiler_failed('clang', code, out)

	if t.mode == 'build':
		return result(PASS)

	# 3. run it
	code, out = run([binary], workdir, TIMEOUT_RUN)
	if code == -1:
		return result(FAIL, 'timeout after %ds' % TIMEOUT_RUN, last_output(out), out)
	if code != t.expect_exit:
		# A self-checking test prints why it gave up just before it does.
		return result(FAIL, 'exit %d, expected %d' % (code, t.expect_exit),
		              last_output(out), out)

	rest = out
	for n, want in enumerate(t.expect_out):
		i = rest.find(want)
		if i < 0:
			where = ['matched %d of %d expectations, stopped before this one'
			         % (n, len(t.expect_out))]
			return result(FAIL, 'output missing %r' % want, where + last_output(out), out)
		rest = rest[i + len(want):]

	return result(PASS)



# --------------------------------------------------------------------- report

def color(s, c, enabled):
	return '\033[%dm%s\033[0m' % (c, s) if enabled else s


STATUS_COLOR = {PASS: 32, FAIL: 91, XFAIL: 33, XPASS: 91, SKIP: 90}


def report(results, verbose, tty):
	counts = dict.fromkeys([PASS, FAIL, XFAIL, XPASS, SKIP], 0)

	for r in results:
		counts[r.status] += 1
		if r.status == PASS:
			continue

		tag = color('%-5s' % r.status.upper(), STATUS_COLOR[r.status], tty)
		line = '%s %s [%s]' % (tag, r.test.name, r.backend)
		if r.reason:
			line += ' — ' + r.reason
		print(line)

		# Where it went wrong: the compiler's own diagnostic, or the last
		# thing the program managed to print.  Without this a failure says
		# only that something broke, not what.
		for w in r.where:
			print('      %s' % color(w, 90, tty))

		if r.status == XPASS:
			print('      passes now; drop EXPECTED-FAIL (%s)'
			      % r.test.xfail_reason(r.backend))
		if verbose and r.log:
			print(indent(r.log))

	print()
	summary = '%d passed' % counts[PASS]
	for st in (FAIL, XPASS, XFAIL, SKIP):
		if counts[st]:
			summary += ', %d %s' % (counts[st], st)
	ok = counts[FAIL] == 0 and counts[XPASS] == 0
	print(color(summary, 32 if ok else 91, tty))

	if not ok and not verbose:
		# The generated .c/.ll a diagnostic points at lives in a build
		# directory that is gone by now, unless asked for.
		print(color('  -v for full output, --keep to keep the generated sources',
		            90, tty))
	return ok


def indent(text):
	return '\n'.join('      | ' + l for l in text.rstrip().splitlines())


def fatal(msg):
	print('run.py: %s' % msg, file=sys.stderr)
	sys.exit(2)



# ----------------------------------------------------------------------- main

def discover(filt):
	tests = []
	for dirpath, dirnames, filenames in os.walk(TESTS_DIR):
		dirnames[:] = sorted(d for d in dirnames if not d.startswith(('_', '.')))
		for fn in sorted(filenames):
			if not fn.endswith('.m'):
				continue
			path = os.path.join(dirpath, fn)
			if filt and filt not in os.path.relpath(path, TESTS_DIR):
				continue
			tests.append(parse_test(path))

	# A file pulled in via LINK is part of another test, not a test itself.
	linked = {os.path.join(os.path.dirname(t.path), s)
	          for t in tests for s in t.link}
	return [t for t in tests if t.path not in linked]


def main():
	ap = argparse.ArgumentParser(description='Run the Modest test suite.')
	ap.add_argument('filter', nargs='?', help='only tests whose path contains this')
	ap.add_argument('-b', '--backend', action='append', choices=ALL_BACKENDS,
	                help='restrict to a backend (repeatable)')
	ap.add_argument('-j', '--jobs', type=int, default=os.cpu_count() or 4)
	ap.add_argument('-v', '--verbose', action='store_true',
	                help='show compiler/program output for failures')
	ap.add_argument('--keep', action='store_true', help='keep build directories')
	ap.add_argument('--list', action='store_true', help='list tests and exit')
	args = ap.parse_args()

	if not os.path.isfile(MCC):
		fatal('compiler not found at %s' % MCC)
	os.environ.setdefault('MODEST_DIR', ROOT_DIR)
	os.environ.setdefault('MODEST_LIB', os.path.join(ROOT_DIR, 'lib') + os.sep)

	tests = discover(args.filter)
	if not tests:
		fatal('no tests found' + (' matching %r' % args.filter if args.filter else ''))

	if args.list:
		for t in tests:
			print('%-40s %s [%s]' % (t.name, t.mode, ', '.join(t.backends)))
		return 0

	cases = [(t, b) for t in tests for b in t.backends
	         if not args.backend or b in args.backend]
	if not cases:
		fatal('no cases to run for the selected backends')

	with ThreadPoolExecutor(max_workers=args.jobs) as pool:
		results = list(pool.map(lambda c: run_case(c[0], c[1], args.keep), cases))

	# An expected failure that failed is fine; one that passed is news.
	for r in results:
		if r.test.xfail_reason(r.backend):
			r.status = XFAIL if r.status == FAIL else XPASS if r.status == PASS else r.status

	ok = report(results, args.verbose, sys.stdout.isatty())
	return 0 if ok else 1


if __name__ == '__main__':
	sys.exit(main())

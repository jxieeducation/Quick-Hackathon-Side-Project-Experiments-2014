import os
from os import listdir
from os.path import isfile, join
import re


#get default libraries
def default_libraries(language="Python"):
	if language == "Python":
		defaults = ['*', 'the', 'd'] #add all the bad import statements here
		return default_python_libraries() + defaults
	elif language == "cpp":
		defaults = ['assert.h', 'complex.h', 'ctype.h', 'errno.h', 'fenv.h', 'float.h', 'inttypes.h', 'iso646.h', 'limits.h', 'locale.h', 'math.h', 'setjmp.h', 'signal.h', 'stdalign.h', 'stdarg.h', 'stdatomic.h', 'stdbool.h', 'stddef.h', 'stdint.h', 'stdio.h', 'stdlib.h', 'stdnoreturn.h', 'string.h', 'tgmath.h', 'threads.h', 'time.h', 'uchar.h', 'wchar.h', 'wctype.h']
		return defaults

def default_python_libraries():
	f = open('default_libraries.txt', 'r')
	lines = f.readlines()
	libraries = []
	for line in lines:
		line = line.replace('\n', '')
		line = ' '.join(line.split())
		libraries += line.split()
	return libraries


#returns a list of libraries used in the repo
def import_parses(file_directory, language="Python"):
	if language == "Python":
		return parse_python(file_directory)
	if language == "cpp":
		return parse_cpp(file_directory)

def parse_python(file_directory):
	defaults = default_libraries("Python")
	libraries = []
	f = open(file_directory, 'r')
	lines = f.readlines()
	for line in lines:
		if 'import ' in line:
			line = line.lstrip().lower()
			if 'from' in line:
				line = line[line.index('from') + 5:line.index('import')]
			else:
				line = line[line.index('import') + 7:].replace('\n','')
			if ' as ' in line:
				line = line[:line.index(' as ')]
			if '.' in line:
				line = line.split('.')[0]
			if '#' in line:
				line = line.split('#')[0]
			line = line.replace(' ','')
			if ',' in line:
				lines = line.split(',')
			else:
				lines = [line]
			for line in lines:
				if line in defaults or line == '':
					continue
				libraries += [line]
	return libraries

def parse_cpp(file_directory):
	defaults = default_libraries("cpp")
	libraries = []
	f = open(file_directory, 'r')
	lines = f.readlines()
	for line in lines:
		if '#include ' in line:
			if "<" in line:
				line = line[line.index("<") + 1:line.index(">")]
			elif "'" in line:
				print line
				line = line[line.index("'") + 1:]
				line = line[:line.index("'")]
			elif '"' in line:
				line = line[line.index('"') + 1:]
				line = line[:line.index('"')]
			
			if "/" in line:
				lines = line.split("/")
			else:
				lines = [line]
			for line in lines:
				if line != "..":
					if line not in defaults:
						libraries += [line]
					break
	return libraries

#checks if a file_name is valid for a file
def is_correct_file(file_name, language):
	if language == "Python":
		if file_name.endswith('.py'):
			return True
		return False
	elif language  == "cpp":
		if file_name.endswith('.h') or file_name.endswith('.cpp') or file_name.endswith('.c'):
			return True
		return False

#returns a list of viable python files from a repository
def get_file_names(path, language="Python"):
	return [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser(path)) for f in fn if is_correct_file(f, language)]

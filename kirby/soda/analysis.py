from imports import import_parses, get_file_names
from db import store_pairs, print_all
import os
import time

def analyze_repo(path, language="Python"):
	pathes = get_file_names(path, language)
	for path in pathes:
		libraries = import_parses(path, language)
		if len(libraries) <= 1:
			continue
		for library1 in libraries:
			for library2 in libraries:
				store_pairs(library1, library2)

def get_repo_links():
	return open('repos.txt').readlines()


language = "cpp"
os.system("cd /; sudo mkdir kirby")
finished = []
finished += os.listdir("/kirby/")
repos = get_repo_links()
for repo_url in repos:
	repo = repo_url.rsplit('/', 1)[1].split('.')[0].replace('\n','')
	if repo not in finished:
		os.system("cd /kirby; sudo git clone " + repo_url.replace('\n', '') + " " + repo)
	else:
		continue
	path = "/kirby/" + repo
	time.sleep(0.5)
	analyze_repo(path, language)
	os.system("cd /kirby; sudo rm -rf *") #uncomment this line if u wanna keep the repos
	finished += [repo]

db_lines = print_all()
f = open('results.txt', 'w')
for line in db_lines:
	f.write(str(line) + "\n")

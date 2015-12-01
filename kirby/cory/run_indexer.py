import os, time, requests
from requests.auth import HTTPBasicAuth

auths = []
auths.append(HTTPBasicAuth('nsssssa', 'nsssssa123'))
auth = auths[0]

while True:
	f = open('output.txt')
	lines = f.readlines()
	if len(lines) == 0:
		os.system("python indexer.py")
	else:
		last_link = lines[-1]
		segs = last_link.split('/')
		link = "https://api.github.com/repos/" + segs[-2] + "/" + segs[-1]
		while True:
			try:
				r = requests.get(link, auth= auth)
				break
			except:
				print "run_indexer is requesting to get last repo id"
				time.sleep(60 * 5)
		repo_info = r.json()
		os.system("python indexer.py " + str(repo_info['id']))
	time.sleep(60 * 30)
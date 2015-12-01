import requests, json
from requests.auth import HTTPBasicAuth
import sys, getopt

auths = []
auths.append(HTTPBasicAuth('godzillabitch', 'godzillabitch123'))
auths.append(HTTPBasicAuth('ankitsmarty', 'ankitsmarty123'))
auths.append(HTTPBasicAuth('yasmite', 'yasmite123'))
auths.append(HTTPBasicAuth('qwertybitch', 'qwertybitch123'))
auths.append(HTTPBasicAuth('andrewnoobee', 'andrewnoobee123'))
auths.append(HTTPBasicAuth('threelegged', 'threelegged123'))
auths.append(HTTPBasicAuth('ninewindows', 'ninewindows123'))
auths.append(HTTPBasicAuth('twittch', 'twittch123'))
auths.append(HTTPBasicAuth('phenoixtt', 'phenoixtt123'))
auths.append(HTTPBasicAuth('bootcampee', 'bootcampee123'))
auths.append(HTTPBasicAuth('lolmoob', 'lolmoob123'))
auths.append(HTTPBasicAuth('biggyt', 'biggyt123'))
auths.append(HTTPBasicAuth('tomatodude', 'tomatodude123'))
auths.append(HTTPBasicAuth('potatodude', 'potatodude123'))
auths.append(HTTPBasicAuth('friedricedude', 'friedricedude123'))
auths.append(HTTPBasicAuth('chowmeindude', 'chowmeindude123'))
auths.append(HTTPBasicAuth('goodolddude', 'goodolddude123'))
auths.append(HTTPBasicAuth('cryingdude', 'cryingdude123'))
auths.append(HTTPBasicAuth('sennheiserdude', 'sennheiserdude123'))
auths.append(HTTPBasicAuth('beatsdude', 'beatsdude123'))
auths.append(HTTPBasicAuth('bosedude', 'bosedude123'))
auths.append(HTTPBasicAuth('sonydude', 'sonydude123'))
auths.append(HTTPBasicAuth('bobdylann', 'bobdylann123'))
auths.append(HTTPBasicAuth('godizllll', 'godizllll123'))
auths.append(HTTPBasicAuth('jliiii', 'jliiii123'))
auths.append(HTTPBasicAuth('sssssst', 'sssssst123'))
auths.append(HTTPBasicAuth('wwwtt', 'wwwtt123'))
auths.append(HTTPBasicAuth('uoftttt', 'uoftttt123'))
auths.append(HTTPBasicAuth('vanyee', 'vanyee123'))
auths.append(HTTPBasicAuth('yammmettt', 'yammmettt123'))

auth = auths.pop()

def run(num=0):
    since = num
    scanned_repos = []

    while 1:
        while 1:
            try:
                r = requests.get("https://api.github.com/repositories?since=" + str(since), auth= auth)
                break
            except Exception as e:
                auth = auths.pop()
        repos = r.json()
        for repo in repos:
            # print repo['id']
            if(repo['id'] in scanned_repos):
                continue
            language_checker = repo['url'] + "/languages"
            while 1:
                try:
                    r = requests.get(language_checker, auth=auth)
                    languages = r.json()
                    break
                except Exception as e:
                    auth = auths.pop()
            if "Python" in languages.keys():
            # if "C" in languages.keys() or "C++" in languages.keys():
                r = requests.get(repo['url'], auth= auth)
                repo_info = r.json()
                if repo_info['size'] <= 1500:
                    print repo['html_url']
                    with open("output.txt", "a") as myfile:
                        myfile.write(repo['html_url'] + "\n")
            scanned_repos.append(repo['id'])
        since = repos[len(repos) - 1]['id']

if __name__ == "__main__":
    if len(sys.argv) == 2:
        run(sys.argv[1])
    else:
        run()
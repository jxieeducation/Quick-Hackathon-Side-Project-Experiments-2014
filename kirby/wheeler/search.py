import requests, json

def search(query, language):
    try:
        r = requests.get("https://www.google.com/search?q=" + "github" + "%20" + language + "%20" + query).text
        r = r[r.index("/url?q=https://github.com"):]
        r = r[:r.index("&")+1]
        r = r.replace("&", "")
        r = r.replace("/url?q=", "")
    except Exception as e:
        r = None
    return r
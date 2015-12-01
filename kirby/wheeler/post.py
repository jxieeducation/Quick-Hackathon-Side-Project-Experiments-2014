def postIssue(owner, repo, title, contents, auth):
    r = requests.post("https://api.github.com/repos/" + owner + "/" + repo + "/issues", data=json.dumps({"title": title, "body":contents}), auth=auth)
    return r.json()
#gets vid id
def extract_vid_id(url):
	return url[url.index("?v=") + 3:]

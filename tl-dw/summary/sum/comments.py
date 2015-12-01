import requests

def get_comments(url_id):
	r = requests.get("http://gdata.youtube.com/feeds/api/videos/" + url_id + "/comments?v=2&alt=json&max-results=50")
	text = r.text
	text = ''.join(map(chr,text))
	comments_list = []
	while "content" in text:
		text = text[text.index("content"):]
		my_comment = text[:text.index["link"]]
		comments_list += [my_comment]
	# print comments_list



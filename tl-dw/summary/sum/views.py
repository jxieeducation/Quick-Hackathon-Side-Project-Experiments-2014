from django.shortcuts import render
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
import multiprocessing
import subprocess
from tools import *
from organize import *
from reducer import *
from wiki import *
from keywords import *
from multithread import *
from comments import *

def index(request):
	context = {}
	return render(request, 'index.html', context)

def summarize(request, url = None):
	url_id = url
	# get_comments(url_id)
	url = "https://www.youtube.com/watch?v=" + url
	# vid_id = extract_vid_id(url)
	os_dir = "/root/tl-dw/summary/" 
	subprocess.call("youtube-dl --write-sub --write-auto-sub --sub-lang en --max-filesize 1k " + url, shell=True)
	subprocess.call("mv " + os_dir + "*.srt " + os_dir + "0.srt", shell=True)
	read_data = load_subtitles(os_dir)
	transcript, passage = extract_items(read_data)
	# print passage
	list_of_summaries = summy(passage)
	summary_temp = summy(passage, 600)
	summary = ""
	for sentence in summary_temp:
		summary += sentence
		summary += " "
	# print list_of_summaries
	time_list = get_time(list_of_summaries, transcript)
	subprocess.call("rm " + os_dir + "*.srt", shell=True)
	my_words = list(keywords(summary))
	if len(my_words) > 5:
		my_words = my_words[:5]
	links = []
	# def f(word):
	# 	if isinstance(word, str) and word != "Beleiveing":
	# 		time_sec = get_time_stamp(word, transcript)
	# 		links = [(word, getWiki(word), getSummary(word), getPic(word), time_sec)] + links
	# pool = multiprocessing.Pool(None)
	# r = pool.map_async(f, my_words)
	# r.wait()

	for word in my_words:
		if isinstance(word, str) and word != "Beleiveing":
			time_sec = get_time_stamp(word, transcript)
			links = [(word, getWiki(word), getSummary(word), getPic(word), time_sec)] + links
	if links != []:
		links.sort(key=lambda x: x[2], reverse=True)
	context = {'time_list':time_list, 'url_id':url_id, 'summary':summary, 'links':links}
	return render(request, 'summary.html', context)

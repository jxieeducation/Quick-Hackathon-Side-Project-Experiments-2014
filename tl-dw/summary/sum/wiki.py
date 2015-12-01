import wikipedia
import random

def getWiki(term, choice = 0):
	link = ""
	try:
		link = wikipedia.page(term).url
	except:
		print "link stablizing"
	return link


def getPic(term, choice = 0):
	image = ""
	try:
		image = wikipedia.page(term).images[0]
	except:
		print "image stablizing"
	return image

def getSummary(term):
	summary = ""
	try:
		summary = wikipedia.summary(term, sentences=1)
	except:
		print "summary stablizing"
	return summary
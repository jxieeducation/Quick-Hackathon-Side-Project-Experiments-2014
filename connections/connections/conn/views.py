from django.shortcuts import render
from django.http import HttpResponse
import time

def index(request):
	context = {}
	return render(request, 'ind.html', context)

def signup(request):
	context = {}
	return render(request, 'signup.html', context)

def dashboard(request):
	time.sleep(5)
	context = {}
	return render(request, 'dashboard.html', context)

def login(request):
	context = {}
	return render(request, 'login.html', context)

def message(request):
	context = {}
	return render(request, 'message.html', context)

def upgrade(request):
	time.sleep(2)
	context = {}
	return render(request, 'upgrade.html', context)

def graph(request):
	from splinter import Browser
	with Browser() as browser:
		url = "file:///home/janelle/Desktop/autogenerate.html"
		browser.visit(url)
		time.sleep(20)
		#print browser.html
	return HttpResponse("Now generating graph!")


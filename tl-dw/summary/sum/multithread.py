#!/usr/bin/python

import threading

class summalyThread (threading.Thread):
    def __init__(self, threadID, name, url):
        threading.Thread.__init__(self)
        self.url = url
    
    # def run(self):
    #     #wikipedia call here


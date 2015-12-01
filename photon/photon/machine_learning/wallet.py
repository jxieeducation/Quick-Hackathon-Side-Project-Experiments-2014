import sys 
import os 
import subprocess

def find_between( s, first, last ): 
	try: 
		start = s.index( first ) + len( first ) 
		end = s.index( last, start ) 
		return s[start:end] 
	except ValueError: 
		return "" 

def correction( private ):
	out = subprocess.check_output("bu " + private, shell=True)
	return find_between(out, "uncompressed: ", "public pair x:").strip(" ").strip("\n")
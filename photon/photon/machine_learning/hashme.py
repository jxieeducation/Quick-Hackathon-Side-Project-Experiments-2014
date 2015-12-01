import math
from pybitcointools import *

def hashing(mylist, pin):
	privatekey = ""
	privatekey += get_index(mylist, pin, pin)
	num = pin / 10 + (pin % 10) * 1000
	privatekey += get_index(mylist, num, pin)
	num = num / 10 + (num % 10) * 1000
	privatekey += get_index(mylist, num, pin)
	num = num / 10 + (num % 10) * 1000
	privatekey += get_index(mylist, num, pin)
	privatekey = sha256(str(privatekey))
	publickey = privtopub(privatekey)
	return [privatekey, publickey, pubtoaddr(publickey)]

def get_index(mylist, num, pin):
	number = mylist[num]
	number *= num
	number *= num
	number *= pin
	number *= num
	number *= 10111
	return str(number)
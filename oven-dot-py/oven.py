import base64
import requests
import json
import subprocess
import serial

text_inbox = "" #generated by the AT&T client
access_token = "" #generated by calling bash getauth OR just paste it in
port0 = "light" #device connected to plug0
port1 = "coffee maker" #device connected to plug1

""" 
first call the getauth bash file and retrieve a access_token
then call set_token to grant tomato.py access
NOTE: this function should be called first
"""
def set_token(acc_tk):
	global access_token
	access_token = acc_tk

""" 
set_port sets what device the port number corresponds to
"""
def set_port(number, device):
	global port0, port1
	if number == 0:
		port0 = device
	elif number == 1:
		port1 = device

""" 
set the inbox number in a string format
"""
def set_text_inbox(number):
	global text_inbox
	text_inbox = number

""" 
voice_to_text converts the local audio file to words
"""
def voice_to_text(path):
	user_input = ""
	response = subprocess.check_output("./getauth", shell=True)
	data = json.loads(response)
	access_token = data['access_token']
	headers = {'Authorization': 'Bearer ' + access_token, 'Accept': 'application/json', 'Content-Type': 'audio/x-wav'}
	response = subprocess.check_output("""curl "https://api.att.com/speech/v3/speechToText"     --header "Authorization: Bearer 8llmHesSNQoFgFSDG4zwcsIA2BpzxqEe"     --header "Accept: application/json"     --header "Content-Type: audio/x-wav"     --data-binary @""" + path + """     --request POST""", shell=True)
	data = json.loads(response)
	try:
		user_input = data["Recognition"]["NBest"][0]["Hypothesis"]
		print user_input
	except:
		print "Speech not recognized"
		return False
	process_input(user_input)

""" 
text_get retrieves the user's text
"""
def text_get():
	user_input = ""
	#this is a http rest request to retrieve the texts
	headers = {'Authorization': 'Bearer ' + access_token, 'Accept': 'application/json'}
	response = requests.post("https://api.att.com/sms/v3/messaging/inbox/" + text_inbox, headers = headers)
	json_input = response.content

	try:
		decoded = json.loads(json_input)
		user_input = decoded['InboundSmsMessageList']['InboundSmsMessage'][0]['Message']
	except (ValueError, KeyError, TypeError):
		print "JSON format error"

	process_input(user_input)

""" 
text_get retrieves the user's text along with payment information
"""
def text_get_with_payment():
	user_input = ""
	#this is a http rest request to retrieve the texts
	headers = {'Authorization': 'Bearer ' + access_token, 'Accept': 'application/json'}
	response = requests.post("https://api.att.com/sms/v3/messaging/inbox/" + text_inbox, headers = headers)
	json_input = response.content

	try:
		decoded = json.loads(json_input)
		user_input = decoded['InboundSmsMessageList']['InboundSmsMessage'][0]['Message']
	except (ValueError, KeyError, TypeError):
		print "JSON format error"

	user_input = user_input.split("\n")
	if process_payment(user_input[1]):
		process_input(user_input[0])
	else:
		print "we are having trouble processing the payment"

""" 
process_payment checks to see if the payment goes through
authcode - payment information
"""
def process_payment(authcode):
	#we are simply checking for a transaction id
	headers = {'Authorization': 'Bearer ' + access_token, 'Accept': 'application/json', 'user-agent': 'Test' }
	response = requests.post("https://api.att.com/rest/3/Commerce/Payment/Transactions/TransactionAuthCode/" + authcode, headers = headers)
	json_input = response.content

	try:
		decoded = json.loads(json_input)
		transaction_status = decoded['TransactionStatus']
	except (ValueError, KeyError, TypeError):
		print "JSON format error"

	if transaction_status == "SUCCESSFUL":
		return True
	else:
		return False

""" 
an internal input_check function that parses the input
input - a sentence / words that the user entered
"""
def input_check(input):
	words = input.split()
	prev_word = ""
	device = ""
	state = ""
	for word in words:
		if word == port0 or (prev_word + " " + word) == port0:
			device = port0
		elif word == port1  or (prev_word + " " + word) == port1:
			device = port1
		elif word == "off":
			state = "off"
		elif word == "on":
			state = "on"
		else:
			prev_word = word
	return device, state

""" 
internal helper that receives the hardware level information and starts the processing
"""
def process_input(input):
	device, state = input_check(input)
	if device == "" or state == "":
		print "device or state not recognized"
	elif state == "off":
		text_analysis(device, False)
	else:
		text_analysis(device, True)

""" 
text_analysis calls the actual hardware controls
device - name of the machine to be controlled
state - True(on) and False(off)
"""
def text_analysis(device, state):
	if device == port0:
		hardware(0, state)
	elif device == port1:
		hardware(1, state)

""" 
hardware calls the actual arduino functions
outlet - 0 for the device on port0, 1 for device on port1
on - True means on, False means off
"""
def hardware(outlet, on):
    if outlet == 0:
        if on == "on":
            ser.write("A")
        else:
            ser.write("B")
    if outlet == 1:
        if on == "off":
            ser.write("C")
        else:
            ser.write("D")
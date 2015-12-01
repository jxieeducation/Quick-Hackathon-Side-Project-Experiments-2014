import base64
import requests
import subprocess
import json
import serial
import os.path

access_token = ""
port0 = "m"
port1 = "l"
ser = serial.Serial('/dev/tty.usbmodem411', 115200)

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
hardware calls the actual arduino functions
outlet - 0 for the device on port0, 1 for device on port1
on - True means on, False means off
"""
def hardware(outlet, on):
    if outlet == 0:
        if on == "on":
            print "Turning outlet 1 on"
            ser.write("A")
        else:
            print "Turning outlet 1 off"
            ser.write("B")
    if outlet == 1:
        if on == "on":
            print "Turning outlet 2 on"
            ser.write("C")
        else:
            print "Turning outlet 2 off"
            ser.write("D")

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
an internal input_check function that parses the input
input - a sentence / words that the user entered
"""
def input_check(input):
    device = ""
    state = ""
    if port0 in input.lower():
        device = port0
    elif port1 in input.lower():
        device = port1
    if "off" in input.lower():
        state = "off"
    elif "on" in input.lower():
        state = "on"
    return device, state

""" 
voice_to_text converts the local audio file to words
"""
def voice_to_text():
    while True:
        if os.path.isfile(os.path.expanduser("~/Downloads/input.wav")):
            user_input = ""
            response = subprocess.check_output("./getauth", shell=True)
            data = json.loads(response)
            access_token = data['access_token']
            headers = {'Authorization': 'Bearer ' + access_token, 'Accept': 'application/json', 'Content-Type': 'audio/x-wav'}
            response = subprocess.check_output("""curl "https://api.att.com/speech/v3/speechToText"     --header "Authorization: Bearer 8llmHesSNQoFgFSDG4zwcsIA2BpzxqEe"     --header "Accept: application/json"     --header "Content-Type: audio/x-wav"     --data-binary @/Users/lucasyan/Downloads/input.wav     --request POST""", shell=True)
            data = json.loads(response)
            try:
                user_input = data["Recognition"]["NBest"][0]["Hypothesis"]
            except:
                print "Speech not recognized"
            device, state = input_check(user_input)
            if device == "" or state == "":
                 print "device or state not recognized"
            else:
                 text_analysis(device, state)
            subprocess.call("rm ~/Downloads/input.wav", shell=True)

voice_to_text()
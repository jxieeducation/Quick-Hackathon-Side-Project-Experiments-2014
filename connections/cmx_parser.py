import urllib2, base64

request = urllib2.Request("https://10.10.20.21/api/contextaware/v1/location/clients")
base64string = base64.encodestring('%s:%s' % ("devuser", "devuser")).replace('\n', '')
request.add_header("Authorization", "Basic %s" % base64string)   
result = urllib2.urlopen(request)

from xml.dom.minidom import parse
try:
	dom = parse(result)
except e as Exception:
	print(e)

mac_addr = []
for elem in dom.getElementsByTagName("WirelessClientLocation"):
	mac_addr += [elem.attributes['macAddress'].value]

x = []
for elem in dom.getElementsByTagName("MapCoordinate"):
	x += [elem.attributes['x'].value]

y = []
for elem in dom.getElementsByTagName("MapCoordinate"):
	y += [elem.attributes['y'].value]

f = open('cmx_data.txt','w')
for index in range(len(mac_addr)):
	f.write(str(mac_addr[index]) + " " + str(x[index]) + " " + str(y[index]) + "\n")
f.close() 
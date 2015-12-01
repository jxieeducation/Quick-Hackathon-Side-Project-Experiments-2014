import urllib2, base64

mydata = "<xml>spam</xml>"

r = urllib2.Request("http://example.com", data=mydata,headers={'Content-Type': 'application/xml'})
base64string = base64.encodestring('%s:%s' % ("hacker004", "p@ssw0rd")).replace('\n', '')
r.add_header("Authorization", "Basic %s" % base64string)   
result = urllib2.urlopen(r)
respond = result.read()


# f = open('cmx_data.txt','w')
# for index in range(len(mac_addr)):
# 	f.write(str(mac_addr[index]) + " " + str(x[index]) + " " + str(y[index]) + "\n")
# f.close() 


# r = urllib2.Request("http://example.com", data="<xml>spam</xml>",
#                      headers={'Content-Type': 'application/xml'})
# u = urllib2.urlopen(r)
# response = u.read()
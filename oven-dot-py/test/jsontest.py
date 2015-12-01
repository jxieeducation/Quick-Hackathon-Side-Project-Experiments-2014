import json
 
json_input = '{"Recognition": {"Status": "Ok","ResponseId": "3125ae74122628f44d265c231f8fc926","NBest": [{"Hypothesis": "bookstores in glendale california","LanguageId": "en-us","Confidence": 0.9,"Grade": "accept","ResultText": "bookstores in Glendale, CA","Words": ["bookstores","in","glendale","california"],"WordScores": [0.92,0.73,0.81,0.96]}]}}'

try:
    decoded = json.loads(json_input)
 
    # pretty printing of json-formatted string
    # print json.dumps(decoded, sort_keys=True, indent=4)
    # print decoded['Recognition']['NBest'][0]['ResultText']
except (ValueError, KeyError, TypeError):
    print "JSON format error"
 

json_input = '{"InboundSmsMessageList": {"InboundSmsMessage": [{"MessageId": "msg0","Message": "Hello","SenderAddress": "tel:4257850159"}],"NumberOfMessagesInThisBatch": "1","ResourceUrl": "http://api.att.com/sms/v3/messaging/inbox/22627000","TotalNumberOfPendingMessages": "0"}}'

try:
    decoded = json.loads(json_input)
    # pretty printing of json-formatted string
    print json.dumps(decoded, sort_keys=True, indent=4)
    print decoded['InboundSmsMessageList']['InboundSmsMessage'][0]['Message']
except (ValueError, KeyError, TypeError):
    print "JSON format error"

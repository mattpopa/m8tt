import re
#result = re.search(r'Analytics', 'AV Analytics Vidhya AV')
#print result.group(0)
#
#
#!/usr/bin/python

#str = "username env Line1-abcdef Line2-abc Line4-abcd gigi something ceva";
#str = "username env";
str = "username env comment";
#print str
#print str.split( )

if len(str.split()) > 2:
    comment = str.split(' ', 2 )
    print comment[2]
else:
    comment = "" 
    print comment

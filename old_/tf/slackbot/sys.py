import subprocess, sys, io, os
def lunch():
    menu_grep = 'curl -sSLf http://stradale.ro/locatie/stradale-oregon-park | grep -i "meniul zilei" -A8 | awk \'{gsub("<[^>]*>", "")}1\''
    child = subprocess.Popen(menu_grep, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8", shell=True) 
    out, err = child.communicate()
    #out = out.splitlines()
    return out
    #print(outs)

 
print(lunch())
####################tested version###################
#def lunch():
#    menu_grep = 'curl -sSLf http://stradale.ro/locatie/stradale-oregon-park | grep -i "meniul zilei" -A8 | awk \'{gsub("<[^>]*>", "")}1\''
#    child = subprocess.Popen(menu_grep, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8", shell=True)
#    out, err = child.communicate()
#    out = out.splitlines()
#    return out
#    #print(outs)
#
#
#meniul = lunch()
#
#

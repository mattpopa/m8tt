from __future__ import print_function # Python 2/3 compatibility
import json
import os
import logging
import urllib
import random

def generate_response(request, environment):
    if request == "help":
        response_choice = [
            "Oh you need my help now?\nI manage fit/cmt/dmt environments, try:\n_@fitbot keep {{ environment }}_ to prevent an environment from stopping\n_@fitbot start {{ environment }}_ to start an environment",
            "I can help you manage fit/cmt/dmt environments, try:\n_@fitbot keep {{ environment }}_ to prevent an environment from stopping\n_@fitbot start {{ environment }}_ to start an environment",
            "What do you need? Try:\n_@fitbot keep {{ environment }}_ to prevent an environment from stopping\n_@fitbot start {{ environment }}_ to start an environment"
            ]
    elif request == "keep":
        response_choice = [
            "You again? Fine, I'll keep " + environment + " on overnight",
            "As a favour to you, I'll keep " + environment + " on tonight",
            "Keeping " + environment + " on overnight, no need to thank me"
            ]
    elif request == "start":
        response_choice = [
            "Bringing " + environment + " back to life, did you know, your enivronment starts up when you run a deployment?",
            "Warming that bad boy up, you know, your enivronment will just start if you run a deployment?",
            "Fine, starting " + environment + ", rather than disturbing me next time, try just running a deployment"
            ]
    else:
        response_choice = [
            "No idea what you're on about, try _@fitbot keep {{ environment }}_ or _@fitbot start {{ environment }}_",
            "Not sure what you're asking there, try _@fitbot keep {{ environment }}_ or _@fitbot start {{ environment }}_",
            "Look, the guy that programmed me is a complete noob, so I don't understand much, try _@fitbot keep {{ environment }}_ or _@fitbot start {{ environment }}_"
            ]
    response = random.choice(response_choice)
#    print(response)
#    return response

generate_response('keep', 'gigi')

#response=generate_response('keep', 'gigi')
#print(response)


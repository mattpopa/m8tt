"""
Slack chat-bot Lambda handler.
"""
from __future__ import print_function
import os
import logging
import urllib
import sys
import subprocess import json
import random

BOT_TOKEN = os.environ["BOT_TOKEN"]

SLACK_URL = "https://slack.com/api/chat.postMessage"

def lunch():
    menu_grep = 'curl -sSLf http://stradale.ro/locatie/stradale-oregon-park | grep -i "meniul zilei" -A8 | sed \'s/<[^>]*>//g\''
    child = subprocess.Popen(menu_grep, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8", shell=True)
    out, err = child.communicate()
    out = out.splitlines()
    return out

def stradale_lunch_date():
    date_grep = 'curl -sSLf http://stradale.ro/locatie/stradale-oregon-park | egrep -o "[A-Z][a-z]{0,9}\ [0-9]{2}\.[0-9]{2}\.[0-9]{4}" | head -1'
    child = subprocess.Popen(stradale_lunch_grep, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8", shell=True)
    out, err = child.communicate()
    out = out.splitlines()
    return out    

def generate_response(request):
    if request == "help":
        response_choice = [
            "Oh you need my help mow?\n I know what's for lunch, try _@catbot lunch_ ",
            "_Stuart little_ was better than the book! Try _@catbot lunch_; Or  _@catbot menu_ for stradale's mewnu", 
            "Catbot's my father, please call me Killmouski. Just kidding, try _@catbot lunch_" 
            ]
    elif request == "lunch":
        response_choice = [
            "Today's menu at Stradale ",
            "mice not included in today's ",
            "cut the line, go for "
            ]
    elif request == "books":
        response_choice = [
            "Still catching that mouse; the book section will be up soon",
            "Patience, I can has this; books section should be up by next caturday",
            "I like _Of Mice and Men_, but you'll have to come back soon for this section"
            ]
    else:
        response_choice = [
            "Mew mew mew?! Try _@catbot help_",
            "Okay, but let me ask you this: did you try _@catbot help_?",
            "check _@catbot help_, have a purrrfect day"
            ]
    response = random.choice(response_choice)
    return response
    
    
meniul = lunch()
meniul_str = ': '.join(meniul)

def lambda_handler(data, context):

    logging.info(data)
    if "challenge" in data:
        return data["challenge"]

    slack_event = data['event']


    if "bot_id" in slack_event:
        logging.info("Ignore bot event")
    else:
        text = slack_event["text"]
        channel_id = slack_event["channel"]
        if " help" in text:
            response_text = generate_response("help")
        elif " lunch" in text:
            response_text = generate_response("lunch") + meniul_str
        elif " menu" in text:
            response_text = generate_response("lunch") + meniul_str
        elif " books" in text:
            response_text = generate_response("books")
        else:
            response_text = generate_response("other")

        data = urllib.parse.urlencode(
            (   
                ("token", BOT_TOKEN),
                ("channel", channel_id),
                ("text", response_text)
            )   
        )   
        data = data.encode("ascii")

        request = urllib.request.Request(
            SLACK_URL,
            data=data,
            method="POST"
        )   
        request.add_header(
            "Content-Type",
            "application/x-www-form-urlencoded"
        )   

        # Fire off the request!
        urllib.request.urlopen(request).read()

    # Everything went fine.
    return "200 OK"

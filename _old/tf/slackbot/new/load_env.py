from __future__ import print_function # Python 2/3 compatibility
import boto3
import json
import decimal

dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")

table = dynamodb.Table('Boxes')

with open("env_data.json") as json_file:
    envs = json.load(json_file, parse_float = decimal.Decimal)
    for env in envs:
        num = int(env['num'])
        title = env['title']
        info = env['info']

        print("Adding env:", num, title)

        table.put_item(
           Item={
               'num': num,
               'title': title,
               'info': info,
            }
        )

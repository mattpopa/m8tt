from __future__ import print_function # Python 2/3 compatibility
import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")


table = dynamodb.create_table(
    TableName='Environments',
    KeySchema=[
        {
            'AttributeName': 'env',
            'KeyType': 'HASH'  #Partition key
        },
        {
            'AttributeName': 'who',
            'KeyType': 'RANGE'  #Sort key
        }
    ],
    AttributeDefinitions=[
        {
            'AttributeName': 'env',
            'AttributeType': 'N'
        },
        {
            'AttributeName': 'who',
            'AttributeType': 'S'
        },

    ],
    ProvisionedThroughput={
        'ReadCapacityUnits': 1,
        'WriteCapacityUnits': 1 
    }
)

print("Table status:", table.table_status)


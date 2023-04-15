import json
import boto3

# dynamodb table name
TABLE_NAME = "CloudResume"

# create dynamodb client
dynamodb_client = boto3.client('dynamodb', region_name="us-east-1")

# create dynamodb table
dynamodb_table = boto3.resource('dynamodb', region_name="us-east-1")
table = dynamodb_table.Table(TABLE_NAME)

# function that gets, puts, and updates + returns a json object
def lambda_handler(event, context):
    response = table.get_item(
        TableName=TABLE_NAME,
        Key={
            "stats": 'visitors',
        }
    )
    print(response)

    # starts the view count and makes it equal to 1 (make sure your value starts at 0 when you make your table item)
    if "Item" not in response:
        table.put_item(
            Item={
                "stats": 'visitors',
                "viewcount": 1
            }
        )
        view_count = 1
    else:
        # get the current view count
        item = response['Item']
        view_count = item['viewcount']
        # add to view count
        table.update_item(
            Key={
                "stats": 'visitors',
            },
            UpdateExpression='ADD viewcount :val1',
            ExpressionAttributeValues={
                ':val1': 1
            }
        )
        view_count += 1

    # what is returned to the api as a json object if successful
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        "body": json.dumps({"Visit_Count": str(view_count)})
    }
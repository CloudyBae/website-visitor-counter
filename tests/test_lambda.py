import boto3
import pytest
import json

from moto import mock_dynamodb2
from lambda_api import lambda_handler

class LambdaDynamoDBTest(unittest.TestCase):
@pytest.fixture
def use_moto():
    @mock_dynamodb2
    def dynamodb_client():
        dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

        # Create the table
        dynamodb.create_table(
            TableName=cloudresume,
            KeySchema=[
                {
                    'AttributeName': 'RecordId',
                    'KeyType': 'HASH'
                },
                {
                    'AttributeName': 'RecordCount',
                    'KeyType': 'RANGE'
                },
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'RecordId',
                    'AttributeType': 'S'
                },
                {
                    'AttributeName': 'RecordType',
                    'AttributeType': 'N'
                },
            ],
            BillingMode='PAY_PER_REQUEST'
        )
        return dynamodb
    return dynamodb_client

@mock_dynamodb2
def test_handler_for_failure(use_moto):
    use_moto()
    event = {
        "RecordId": "CatsAreGreat"
    }

    return_data = lambda_handler(event, "")
    assert return_data['statusCode'] == 500
    assert return_data['error'] == 'No Records Found.'


@mock_dynamodb2
def test_handler_for_status_ok(use_moto):
    use_moto()
    table = boto3.resource('dynamodb', region_name='us-east-1').Table(cloudresume)
    table.put_item(
        Item={
            'RecordId': "CatsAreGreat",
            'RecordType': "global",
            'Status': "OK",
            'Notes': "Cats are great, yay unit test"
        }
    )

    event = {
        "RecordId": "CatsAreGreat"
    }

    return_data = lambda_handler(event, "")
    print(return_data)
    body = json.loads(return_data['body'])

    assert return_data['statusCode'] == 200
    assert body['RecordId'] == 'CatsAreGreat'
    assert body['Status'] == 'OK'
    assert body['Notes'] == 'Cats are great, yay unit test'

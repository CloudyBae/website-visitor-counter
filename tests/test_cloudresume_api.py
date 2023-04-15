import requests

ENDPOINT = "https://ifpg97r0z2.execute-api.us-east-1.amazonaws.com/dev/"

def test_can_call_endpoint_successfully():
    response = requests.get(ENDPOINT)
    assert response.status_code == 200



import requests

ENDPOINT = "your api here"

def test_can_call_endpoint_successfully():
    response = requests.get(ENDPOINT)
    assert response.status_code == 200



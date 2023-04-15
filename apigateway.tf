resource "aws_api_gateway_rest_api" "cloudresume" {
  name = "CloudResume"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "cloudresume" {
  rest_api_id = aws_api_gateway_rest_api.cloudresume.id
  parent_id   = aws_api_gateway_rest_api.cloudresume.root_resource_id
  path_part   = "cloudresume"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id      = aws_api_gateway_rest_api.cloudresume.id
  resource_id      = aws_api_gateway_resource.cloudresume.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id          = aws_api_gateway_rest_api.cloudresume.id
  resource_id          = aws_api_gateway_resource.cloudresume.id
  http_method          = aws_api_gateway_method.get.http_method
  type                 = "AWS_PROXY"
  uri                  = aws_lambda_function.incrementViewcount.invoke_arn
}

resource "aws_api_gateway_method_response" "get" {
  rest_api_id = aws_api_gateway_rest_api.cloudresume.id
  resource_id = aws_api_gateway_resource.cloudresume.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_deployment" "cloudresume" {
  rest_api_id = aws_api_gateway_rest_api.cloudresume.id
  stage_name  = "dev"
}


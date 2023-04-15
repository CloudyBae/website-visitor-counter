resource "aws_lambda_function" "incrementViewcount" {
  filename         = "lambda_function_payload.zip"
  function_name    = "incrementViewcount"
  role             = aws_iam_role.cloudresume-lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.incrementViewcount.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_deployment.cloudresume.execution_arn
}
provider "aws" {
    region = "us-west-2"   
}

resource "aws_iam_role" "lambda_exec_role" {
    name = "lambda-execution-role"
    assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
]
}
EOF    
}

resource "aws_lambda_function" "lambda" {
    function_name = "rest_lambda"
    s3_bucket     = "terraform-course-lambda-function-xxxx"
    s3_key        = "lambda.zip"
    runtime       = "python3.7"
    handler       = "lambda.lambda_handler"
    role          = aws_iam_role.lambda_exec_role.arn
}

resource "aws_api_gateway_rest_api" "api" {
    name = "terraform-course-api"
}

resource "aws_api_gateway_resource" "lambda" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "lambda"
}

resource "aws_api_gateway_method" "lambda" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_resource.lambda.id
    http_method   = "GET"
    authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.lambda.id
    http_method = aws_api_gateway_method.lambda.http_method
    type        = "AWS_PROXY"
    uri         = aws_lambda_function.lambda.invoke_arn
    integration_http_method = "POST" // in lambda case, it should be always POST
}

resource "aws_lambda_permission" "apigw_permission" {
    statement_id  = "AllowAPIGWInvocation"
    action        = "lambda:InvokeFunction"
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
    function_name = aws_lambda_function.lambda.function_name
}

resource "aws_api_gateway_deployment" "deployment" {
    stage_name = "Production"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

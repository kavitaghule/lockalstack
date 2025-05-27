resource "aws_api_gateway_rest_api" "local_api" {
  name = "LocalAPI"
}

resource "aws_api_gateway_resource" "hello_resource" {
  rest_api_id = aws_api_gateway_rest_api.local_api.id
  parent_id   = aws_api_gateway_rest_api.local_api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "hello_method" {
  rest_api_id   = aws_api_gateway_rest_api.local_api.id
  resource_id   = aws_api_gateway_resource.hello_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello_integration" {
  rest_api_id             = aws_api_gateway_rest_api.local_api.id
  resource_id             = aws_api_gateway_resource.hello_resource.id
  http_method             = aws_api_gateway_method.hello_method.http_method
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = "http://10.0.9.111:3000/hello"
}

resource "aws_api_gateway_method_response" "hello_200" {
  rest_api_id = aws_api_gateway_rest_api.local_api.id
  resource_id = aws_api_gateway_resource.hello_resource.id
  http_method = aws_api_gateway_method.hello_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "hello_integration_200" {
  rest_api_id = aws_api_gateway_rest_api.local_api.id
  resource_id = aws_api_gateway_resource.hello_resource.id
  http_method = aws_api_gateway_method.hello_method.http_method
  status_code = aws_api_gateway_method_response.hello_200.status_code
}

resource "aws_api_gateway_deployment" "local_api_deployment" {
  depends_on = [
    aws_api_gateway_integration_response.hello_integration_200
  ]

  rest_api_id = aws_api_gateway_rest_api.local_api.id
  stage_name  = "dev"
}

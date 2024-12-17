resource "aws_api_gateway_rest_api" "ApiGateway" {
  name        = "TaskManagerApiGateway"
  description = "Task Manager Api Gateway"
}

resource "aws_api_gateway_resource" "ApiProxyResource" {
  rest_api_id = aws_api_gateway_rest_api.ApiGateway.id
  parent_id   = aws_api_gateway_rest_api.ApiGateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "ApiProxyMethod" {
  rest_api_id   = aws_api_gateway_rest_api.ApiGateway.id
  resource_id   = aws_api_gateway_resource.ApiProxyResource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ApiProxyIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.ApiGateway.id
  resource_id             = aws_api_gateway_resource.ApiProxyResource.id
  http_method             = aws_api_gateway_method.ApiProxyMethod.http_method
  type                    = "HTTP"
  integration_http_method = "ANY"
  uri                     = "http://${aws_elastic_beanstalk_environment.backend_app_env.endpoint_url}/{proxy}"
  depends_on              = [aws_elastic_beanstalk_environment.backend_app_env, aws_api_gateway_rest_api.ApiGateway, aws_api_gateway_resource.ApiProxyResource, aws_api_gateway_method.ApiProxyMethod]
}

resource "aws_api_gateway_deployment" "ApiDeployment" {
  depends_on = [
    aws_api_gateway_rest_api.ApiGateway,
    aws_api_gateway_resource.ApiProxyResource,
    aws_api_gateway_method.ApiProxyMethod
  ]
  rest_api_id = aws_api_gateway_rest_api.ApiGateway.id
}


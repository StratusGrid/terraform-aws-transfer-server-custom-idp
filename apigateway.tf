resource "aws_api_gateway_rest_api" "sftp" {
  name        = "${var.name_prefix}-sftp-transfer-server-custom-idp-api${var.name_suffix}"
  description = "API used for SFTP GetUserConfig requests"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-custom-idp-api${var.name_suffix}"
    },
  )
}

resource "aws_api_gateway_model" "userconfig" {
  rest_api_id  = aws_api_gateway_rest_api.sftp.id
  name         = "UserConfigResponseModel"
  description  = "API response for GetUserConfig"
  content_type = "application/json"
  schema = jsonencode(
    {
      "$schema" = "http://json-schema.org/draft-04/schema#"
      properties = {
        HomeDirectory = {
          type = "string"
        }
        Policy = {
          type = "string"
        }
        PublicKeys = {
          items = {
            type = "string"
          }
          type = "array"
        }
        Role = {
          type = "string"
        }
      }
      title = "UserUserConfig"
      type  = "object"
    }
  )
}


resource "aws_api_gateway_stage" "prod" { #tfsec:ignore:aws-api-gateway-enable-access-logging ignoring it as it's a dynamic block
  stage_name           = "prod"
  rest_api_id          = aws_api_gateway_rest_api.sftp.id
  deployment_id        = aws_api_gateway_deployment.sftp.id
  xray_tracing_enabled = var.xray_enabled #tfsec:ignore:aws-api-gateway-enable-tracing ignoring it as it's a variable


  dynamic "access_log_settings" {
    for_each = var.custom_log_group ? [1] : []
    content {
      destination_arn = aws_cloudwatch_log_group.custom_log_group[0].arn
      format          = "json"
    }
  }


  tags = merge(var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-custom-idp-api-stage${var.name_suffix}"
    },
  )
}

resource "aws_api_gateway_deployment" "sftp" {
  depends_on  = [aws_api_gateway_integration.sftp]
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  stage_name  = "dummystagefordeployment"
}

resource "aws_api_gateway_resource" "servers" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  parent_id   = aws_api_gateway_rest_api.sftp.root_resource_id
  path_part   = "servers"
}

resource "aws_api_gateway_resource" "serverid" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  parent_id   = aws_api_gateway_resource.servers.id
  path_part   = "{serverId}"
}

resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  parent_id   = aws_api_gateway_resource.serverid.id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "username" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{username}"
}

resource "aws_api_gateway_resource" "config" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  parent_id   = aws_api_gateway_resource.username.id
  path_part   = "config"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.sftp.id
  resource_id   = aws_api_gateway_resource.config.id
  http_method   = "GET"
  authorization = "AWS_IAM"
  request_parameters = {
    "method.request.header.Password" = false
  }
}

resource "aws_api_gateway_method_settings" "get" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
    caching_enabled = var.apigw_caching_enable #tfsec:ignore:aws-api-gateway-enable-cache ignoring it as it's a variable
  }
}

resource "aws_api_gateway_account" "sftp" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = "200"
  response_models = {
    "application/json" = aws_api_gateway_model.userconfig.name
  }
}

resource "aws_api_gateway_integration" "sftp" {
  rest_api_id             = aws_api_gateway_rest_api.sftp.id
  resource_id             = aws_api_gateway_resource.config.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.sftp.invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters      = {}
  request_templates = {
    "application/json" = <<EOT
{
  "username": "$input.params('username')",
  "password": "$util.escapeJavaScript($input.params('Password')).replaceAll("\\'","'")",
  "serverId": "$input.params('serverId')"
}
EOT
  }
}

resource "aws_api_gateway_integration_response" "sftp_response" {
  depends_on  = [aws_api_gateway_integration.sftp]
  rest_api_id = aws_api_gateway_rest_api.sftp.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

resource "aws_iam_role" "cloudwatch" {
  name = "tf-sftp-api-logs${var.name_suffix}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-custom-idp-api-logs-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "ApiGatewayLogsPolicy"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:GetLogEvents",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/api-gateway/*:log-stream:*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:FilterLogEvents",
                "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/api-gateway/*"
        }
    ]
}
EOF
}

data "aws_iam_policy" "cloudwatch_log_access" {
  arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
  role       = aws_iam_role.cloudwatch.id
  policy_arn = data.aws_iam_policy.cloudwatch_log_access.arn
}

resource "aws_cloudwatch_log_group" "custom_log_group" {
  count = var.custom_log_group ? 1 : 0
  name  = var.custom_log_group_name

  tags = var.input_tags
}

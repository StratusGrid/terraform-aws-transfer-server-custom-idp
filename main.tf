resource "aws_iam_role" "sftp_transfer_server" {
  name = "${var.name_prefix}-sftp-transfer-server-iam-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server" {
  name = "${var.name_prefix}-sftp-transfer-server-iam-policy${var.name_suffix}"
  role = aws_iam_role.sftp_transfer_server.id

  policy = <<POLICY
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
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/transfer/${aws_transfer_server.sftp_transfer_server.id}:log-stream:*"
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
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/transfer/${aws_transfer_server.sftp_transfer_server.id}"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "sftp_transfer_server_invocation" {
  name = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server-invocation-iam-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server_invocation" {
  name = "${var.name_prefix}-sftp-transfer-server-invocation-iam-policy${var.name_suffix}"
  role = aws_iam_role.sftp_transfer_server_invocation.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "execute-api:Invoke"
            ],
            "Resource": "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.sftp.id}/${aws_api_gateway_stage.prod.stage_name}/${aws_api_gateway_method.get.http_method}/*",
            "Effect": "Allow"
        },
         {
            "Action": [
                "apigateway:GET"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }       
    ]
}
POLICY
}

resource "aws_transfer_server" "sftp_transfer_server" {
  identity_provider_type      = "API_GATEWAY"
  logging_role                = aws_iam_role.sftp_transfer_server.arn
  invocation_role             = aws_iam_role.sftp_transfer_server_invocation.arn
  url                         = aws_api_gateway_stage.prod.invoke_url
  structured_log_destinations = var.server_loggroup_arns

  tags = merge(
    var.input_tags,
    {
      "Name" = "${var.name_prefix}-sftp-transfer-server${var.name_suffix}"
    },
  )
}

# Content of this file was copied from:
# https://github.com/StratusGrid/terraform-aws-transfer-server-custom-idp-user/blob/main/main.tf

resource aws_iam_role default {
  name = "${var.name_prefix}-sftp-transfer-server-user-default-role${var.name_suffix}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect: "Allow",
        Principal: {
          Service: "transfer.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
  tags = merge(
    var.input_tags,
    {
      Name: "${var.name_prefix}-sftp-transfer-server-user-default-role${var.name_suffix}"
    },
  )
}

resource "aws_iam_role_policy" "sftp_transfer_server_user" {
  name = "${var.name_prefix}-sftp-transfer-server-user-default-iam-policy${var.name_suffix}"
  role = aws_iam_role.default.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        Action: [
          "s3:ListBucket",
          "s3:GetBucketLocation",
        ]
        Effect: "Allow"
        Resource: [
          "arn:aws:s3:::${var.s3_bucket_name}",
        ]
        Sid = "AllowListingOfUserFolder"
      },
      {
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject",
          "s3:GetObjectVersion",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}*"
        Sid      = "HomeDirObjectAccess"
      },
    ]
  })
}

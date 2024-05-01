output "rest_api_id" {
  description = "ID of the REST API"
  value       = aws_api_gateway_rest_api.sftp.id
}

output "invoke_url" {
  description = "URL used for REST API invovation"
  value       = aws_api_gateway_stage.prod.invoke_url
}

output "rest_api_stage_name" {
  description = "Name used for the stage of API"
  value       = aws_api_gateway_stage.prod.stage_name
}

output "rest_api_http_method" {
  description = "REST API calling method"
  value       = aws_api_gateway_method.get.http_method
}

output "transfer_server_id" {
  description = "The Server ID of the Transfer Server (e.g., s-12345678)"
  value       = aws_transfer_server.sftp_transfer_server.id
}

output "lambda_role" {
  description = "The name of role the Lambda used to access secrets. Used to add additional permissions as needed."
  value       = aws_iam_role.sftp_lambda_role.name
}

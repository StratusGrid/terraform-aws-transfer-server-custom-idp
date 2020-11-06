output "rest_api_id" {
  value = aws_api_gateway_rest_api.sftp.id
}

output "invoke_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "rest_api_stage_name" {
  value = aws_api_gateway_stage.prod.stage_name
}

output "rest_api_http_method" {
  value = aws_api_gateway_method.get.http_method
}

output "transfer_server_id" {
  value = aws_transfer_server.sftp_transfer_server.id
}

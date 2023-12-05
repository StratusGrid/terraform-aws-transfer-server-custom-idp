<!-- BEGIN_TF_DOCS -->
# terraform-aws-transfer-server-custom-idp

GitHub: [StratusGrid/terraform-aws-transfer-server-custom-idp](https://github.com/StratusGrid/terraform-aws-transfer-server-custom-idp)

This Terraform module will create a custom identity provider based on AWS Secrets (managed by AWS Secret Manager) for the AWS Transfer Familiy.

## Example Usage:
Create a SFTP server with the custom identity provider.
```hcl
module "transfer-server-custom-idp" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp/aws"
  version = "1.1.0"

  region = var.region
}
```
---
To create any user to connect to this AWS Transfer server, use [this other module](https://registry.terraform.io/modules/StratusGrid/transfer-server-custom-idp-user/aws/latest)

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_deployment.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.sftp_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.get](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.response_200](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_settings.get](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_model.userconfig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_model) | resource |
| [aws_api_gateway_resource.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.serverid](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.custom_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sftp_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sftp_transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sftp_transfer_server_invocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sftp_lambda_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sftp_transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.sftp_transfer_server_invocation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.sftp_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.sftp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.apigw_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_transfer_server.sftp_transfer_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/transfer_server) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apigw_caching_enable"></a> [apigw\_caching\_enable](#input\_apigw\_caching\_enable) | String to use as a custom log group name | `bool` | `false` | no |
| <a name="input_custom_log_group"></a> [custom\_log\_group](#input\_custom\_log\_group) | Bool to determine if a customer cloudwatch log group is used | `bool` | `false` | no |
| <a name="input_custom_log_group_name"></a> [custom\_log\_group\_name](#input\_custom\_log\_group\_name) | String to use as a custom log group name | `string` | `""` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | String to use as prefix on object names | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | String to append to object names. This is optional, so start with dash if using | `string` | `""` | no |
| <a name="input_python_runtime"></a> [python\_runtime](#input\_python\_runtime) | Python version used for lambda function | `string` | `"python3.7"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_secrets_prefix"></a> [secrets\_prefix](#input\_secrets\_prefix) | Prefix used to create AWS Secrets | `string` | `"SFTP"` | no |
| <a name="input_xray_enabled"></a> [xray\_enabled](#input\_xray\_enabled) | Bool to determine if Xray tracing is enabled | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_invoke_url"></a> [invoke\_url](#output\_invoke\_url) | URL used for REST API invovation |
| <a name="output_rest_api_http_method"></a> [rest\_api\_http\_method](#output\_rest\_api\_http\_method) | REST API calling method |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | ID of the REST API |
| <a name="output_rest_api_stage_name"></a> [rest\_api\_stage\_name](#output\_rest\_api\_stage\_name) | Name used for the stage of API |
| <a name="output_transfer_server_id"></a> [transfer\_server\_id](#output\_transfer\_server\_id) | The Server ID of the Transfer Server (e.g., s-12345678) |

---

<span style="color:red">Note:</span> Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`
<!-- END_TF_DOCS -->
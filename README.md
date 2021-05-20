# terraform-aws-transfer-server-custom-idp
This Terraform module will create a custom identity provider based on AWS Secrets (managed by AWS Secret Manager) for the AWS Transfer Familiy.

### Example usage
Create a SFTP server with the custom identity provider

```
module "transfer-server-custom-idp" {
  name_prefix = var.name_prefix
  source  = "StratusGrid/transfer-server-custom-idp/aws"
  version = "1.0.2"

  region = var.region
}
```

To create any user to connect to this AWS Transfer server, used [this other module](https://registry.terraform.io/modules/StratusGrid/transfer-server-custom-idp-user/aws/latest)

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "secrets_prefix" {
  description = "Prefix used to create AWS Secrets"
  default     = "SFTP"
  type        = string
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type        = string
}

variable "name_suffix" {
  description = "String to append to object names. This is optional, so start with dash if using"
  type        = string
  default     = ""
}

variable "python_runtime" {
  type        = string
  description = "Python version used for lambda function"
  nullable    = false
  default = "python3.7"

  validation {
    condition     = can(regex("^python", var.python_runtime))
    error_message = "Invalid value for variable: python_runtime it must be a python runtime."
  }
}
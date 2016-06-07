variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_openwhisk_ami" {}
variable "prefix" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "prefix" {
  default = "my"
}

# Variables for openwhisk
variable "aws_openwhisk_instance_type" {
  default = "m4.large"
}

variable "openwhisk_name" {
  default = "openwhisk"
}

variable "openwhisk_security_group" {
  default = "ssh_http_https_only"
}

variable "name" {}
variable "tags" {
  type = "map"
  default = {}
  description = "A map of tags to add to all resources"
}
variable "ami_name_pattern" {
  default = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  description = "The name filter to use in data.aws_ami"
}
variable "ami_publisher" {
  default = "099720109477" # Canonical
  description = "The AWS account ID of the AMI publisher"
}

variable "instance_type" {}
variable "instance_count" {}
variable "az_list" {
  type = "list"
}
variable "public_subnet_ids" {
  type = "list"
}
variable "private_subnet_ids" {
  type = "list"
}
variable "subnets_count" {
  description = "The number of subnets in public_subnet_ids. Requiest because of hashicorp/terraform#1497"
}
variable "vpc_security_group_ids" {
  type = "list"
}
variable "aws_key_name" {}
variable "awsnycast_deb_url" {
  default = "https://github.com/bobtfish/AWSnycast/releases/download/v0.1.2/awsnycast_0.1.2-397_amd64.deb"
}

# common
variable "aws_region" {
  description = "AWS region to deploy in to"
}

variable "name_prefix" {
  description = "Prefix of name for resources created"
  default = "flask-hello-world"
}

# networking
variable "vpc_id" {
  description = "The VPC to utilize"
}

variable "certificate_arn" {
  description = "ARN of the certificate to use"
}

# service
variable "image_name" {
  description = "Name of the image "
  default = "339713176830.dkr.ecr.us-east-2.amazonaws.com/flask-hello-world"
}

variable "image_tag" {
  description = "The version of the service to deploy"
  default = "latest"
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing AWS KeyPair to enable SSH access to the instances. Note: You should have this key present in your AWS account."
  type        = string
  default     = ""
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_pair_name" {
  description = "Key pair name to use for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for subnet selection"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2 instance"
  type        = string
}

variable "user_data" {
  description = "Path to user data script"
  type        = string
}

variable "tags" {
  description = "Tags to assign to EC2 instances"
  type        = map(string)
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
}

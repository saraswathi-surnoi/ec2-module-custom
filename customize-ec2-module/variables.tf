variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
  default     = "vpc-0086f34dccaccfc5c"
}

variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instances"
  type        = string
  default     = "logistics-mot-kp"
}

variable "security_groups" {
  description = "Map of security group configurations"
  type = map(object({
    name        = string
    description = string
    ingress     = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    instance_type        = string
    role                 = string
    user_data            = string
    security_group_ref   = string
  }))
}

variable "security_group_tag" {
  description = "Common tags for all security groups"
  type        = map(string)
  default = {
    Project = "logistics"
    ManagedBy   = "Terraform"
    Owner       = "DevOpsTeam"
  }
}

variable "ec2_tags" {
  description = "Common EC2 instance tags"
  type        = map(string)
  default = {
    Project = "logistics"
    ManagedBy   = "Terraform"
    Owner       = "DevOpsTeam"
  }
}

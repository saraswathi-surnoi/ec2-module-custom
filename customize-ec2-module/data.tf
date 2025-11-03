# Fetch latest Ubuntu AMI from your account
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["361769585646"]  # Your AWS account ID

  filter {
    name   = "name"
    values = ["logistics-mot-ubuntu-base-v1.0.0"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Fetch the selected VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Fetch all subnets in that VPC
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

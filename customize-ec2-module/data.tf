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

# Fetch subnets ONLY from your specific VPC and availability zones
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  # Optional: pick only subnets in your current region (extra safety)
  # filter {
  #   name   = "availability-zone"
  #   values = ["ap-south-1a", "ap-south-1b"]
  # }
}




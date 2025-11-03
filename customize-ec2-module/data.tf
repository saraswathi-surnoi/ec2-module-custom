# Fetch latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["361769585646"]

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

# Get the specific VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Get subnets ONLY from that VPC and region
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  # Ensure only "available" subnets
  filter {
    name   = "state"
    values = ["available"]
  }
}

# Fetch detailed subnet info
data "aws_subnet" "first" {
  id = element(data.aws_subnets.selected.ids, 0)
}

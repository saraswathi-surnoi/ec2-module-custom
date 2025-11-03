# Fetch latest Ubuntu AMI (from your custom AMI owner/account)
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

# Get only public subnets from that VPC (by tag or name)
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  # Optional filter: if your subnets are tagged like "public-subnet-1a"
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Get the first public subnet
data "aws_subnet" "first_public" {
  id = element(data.aws_subnets.public.ids, 0)
}

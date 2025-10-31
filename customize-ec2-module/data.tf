data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["794383793382"] 

  filter {
    name   = "name"
    values = ["ubuntu-saru"]
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

data "aws_vpc" "default" {
  default = true
}
resource "aws_instance" "ec2-instances" {
  ami                    = var.ec2.ami
  instance_type          = var.ec2.instance_type
  key_name               = var.ec2.key_name
  vpc_security_group_ids = var.ec2.vpc_security_group_ids
  tags = var.ec2.tags
}


resource "aws_instance" "ec2-instances" {
  ami                    = data.aws_ami.ubuntu.id    # ✅ using AMI from data.tf
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.selected.ids, 0)
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_name
  user_data              = file(var.user_data)        # ✅ taking path from variable map

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}


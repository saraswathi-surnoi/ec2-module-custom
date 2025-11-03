
resource "aws_instance" "ec2-instances" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.first_public.id  # ✅ public subnet
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  user_data                   = file(var.user_data)
  associate_public_ip_address = true  # ✅ ensures public access

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}




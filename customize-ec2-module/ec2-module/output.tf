output "public_ip" {
  value = aws_instance.ec2-instances.public_ip
}

output "private_ip" {
  value = aws_instance.ec2-instances.private_ip
}

output "id" {
  value = aws_instance.ec2-instances.id
}

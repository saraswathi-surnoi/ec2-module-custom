# ==========================
# EC2 MODULE OUTPUTS
# ==========================

output "instance_id" {
  description = "Instance ID of the EC2 instance"
  value       = aws_instance.ec2-instances.id
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.ec2-instances.private_ip
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2-instances.public_ip
}

output "instance_name" {
  description = "Name tag of the EC2 instance"
  value       = aws_instance.ec2-instances.tags["Name"]
}



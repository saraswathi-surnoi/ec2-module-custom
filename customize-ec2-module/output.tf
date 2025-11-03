
# Key Pair
output "key_name" {
  description = "Key pair name used for EC2 instances"
  value       = var.key_pair_name
}

# Public IPs
output "public_ips" {
  description = "Public IPs of all EC2 instances"
  value       = [for instance in module.ec2_instances : instance.public_ip]
}

# Private IPs
output "private_ips" {
  description = "Private IPs of all EC2 instances"
  value       = [for instance in module.ec2_instances : instance.private_ip]
}


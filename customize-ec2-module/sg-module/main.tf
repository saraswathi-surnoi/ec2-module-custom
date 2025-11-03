###############################################
# ✅ Security Group Module (Fixed Version)
###############################################

# Use existing VPC (from root module)
variable "vpc_id" {
  description = "VPC ID to associate security groups with"
  type        = string
}

# ✅ Security Group Resource
resource "aws_security_group" "security_group" {
  name        = "${var.security_group.name}-${substr(uuid(), 0, 4)}"
  description = var.security_group.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.security_group.tags,
    {
      CreatedBy = "Terraform"
      Name      = var.security_group.name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ✅ Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  for_each = var.security_group_ingress

  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = try(each.value.from_port, null)
  to_port           = try(each.value.to_port, null)
}

# ✅ Egress Rules
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each = var.security_group_egress

  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
}

###############################################
# ✅ Outputs
###############################################
output "security_group_id" {
  value = aws_security_group.security_group.id
}

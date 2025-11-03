resource "aws_security_group" "security_group" {
  name        = var.security_group.name
  description = var.security_group.description
  vpc_id      = var.vpc_id
  tags        = var.security_group.tags
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  for_each = {
    for idx, rule in var.security_group_ingress : idx => rule
  }

  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_blocks[0]
  ip_protocol       = each.value.protocol
  from_port         = try(each.value.from_port, null)
  to_port           = try(each.value.to_port, null)
}

# ✅ FIXED — Egress rules (no port range when protocol = -1)
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each = {
    for idx, rule in var.security_group_egress : idx => rule
  }

  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_blocks[0]
  ip_protocol       = each.value.protocol

  # AWS requires: either all protocols (no ports) OR protocol-specific with ports
  from_port         = each.value.protocol != "-1" ? try(each.value.from_port, null) : null
  to_port           = each.value.protocol != "-1" ? try(each.value.to_port, null) : null
}

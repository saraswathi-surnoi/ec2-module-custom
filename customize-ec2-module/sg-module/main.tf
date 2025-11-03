resource "aws_security_group" "security_group" {
  name        = var.security_group.name
  description = var.security_group.description
  vpc_id      = var.vpc_id    
  tags        = var.security_group.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  for_each          = var.security_group_ingress
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
  from_port         = try(each.value.from_port, null)
  to_port           = try(each.value.to_port, null)
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each          = var.security_group_egress
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol
}


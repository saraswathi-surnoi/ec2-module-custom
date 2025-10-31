variable "security_group" {
  type = object({
    name = string
    description = string
    tags = map(string)
  })
}

variable "security_group_ingress" {
  type = map(object({
    cidr_ipv4 = string
    from_port = optional(number) 
    ip_protocol = string
    to_port = optional(number) 
  }))
}

variable "security_group_egress" {
  type = map(object({
    cidr_ipv4   = string
    ip_protocol = string
  }))
  default = {
    allow_all = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "-1"
    }
  }
}

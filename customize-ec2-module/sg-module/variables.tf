variable "vpc_id" {
  description = "VPC ID where SG will be created"
  type        = string
}

variable "security_group" {
  description = "Security group basic info"
  type = object({
    name        = string
    description = string
    tags        = map(string)
  })
}

variable "security_group_ingress" {
  description = "Ingress rules for SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "security_group_egress" {
  description = "Egress rules for SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

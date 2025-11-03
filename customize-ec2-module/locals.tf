locals {
  # Pick the first subnet from the correct VPC
  selected_subnet_id = element(data.aws_subnets.selected.ids, 0)
}



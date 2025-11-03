locals {
  selected_subnet_id = element(data.aws_subnets.selected.ids, 0)
}


locals {
  selected_subnet_id = data.aws_subnets.selected.ids[0]
}
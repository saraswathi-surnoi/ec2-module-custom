locals {
  # Automatically select the first subnet in the target VPC
  selected_subnet_id = data.aws_subnets.selected.ids[0]
}

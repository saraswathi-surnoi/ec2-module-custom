module "security_groups" {
  source   = "./sg-module"
  for_each = var.security_groups

  vpc_id = var.vpc_id 
  security_group = {
    name        = each.value.name
    description = each.value.description
    tags        = var.security_group_tag
  }

  security_group_ingress = each.value.ingress
  security_group_egress  = each.value.egress
}

module "ec2_instances" {
  source = "./ec2-module"
  for_each = var.instances

  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = each.value.instance_type
  key_pair_name      = var.key_pair_name
  vpc_id             = var.vpc_id
  security_group_id  = module.security_groups[each.value.security_group_ref].security_group_id
  user_data          = each.value.user_data
  tags               = var.ec2_tags
  instance_name      = each.key
}


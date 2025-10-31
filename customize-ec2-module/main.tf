

module "key_pair" {
  source        = "./key-pair-module"
  key_pair_name = "${var.ec2_tags.Name}.pem"
}


module "security_groups" {
  source   = "./sg-module"
  for_each = var.security_groups

  security_group = {
    name        = each.value.name
    description = each.value.description
    tags        = var.security_group_tag
  }

  security_group_ingress = each.value.ingress
  security_group_egress  = each.value.egress
}


module "ec2_instances" {
  source   = "./ec2-module"
  for_each = var.instances

  ec2 = {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = each.value.instance_type
    key_name               = module.key_pair.key_name
    user_data              = file("${path.module}/${each.value.user_data}")
    vpc_security_group_ids = [
      module.security_groups[each.value.security_group_ref].security_group_id
    ]
    tags = merge(var.ec2_tags, {
      Name = each.key
      Role = each.value.role
    })
  }
}

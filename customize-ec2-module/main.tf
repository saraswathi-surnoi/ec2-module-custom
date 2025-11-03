module "security_groups" {
  source   = "./sg-module"
  for_each = var.security_groups

  vpc_id = var.vpc_id  # ✅ MUST be here

  security_group = {
    name        = each.value.name
    description = each.value.description
    tags        = var.security_group_tag
  }

  security_group_ingress = each.value.ingress
  security_group_egress  = each.value.egress
}


###############################################
# ✅ EC2 Instances Module
###############################################
module "ec2_instances" {
  source   = "./ec2-module"
  for_each = var.instances

  ec2 = {
    ami           = data.aws_ami.ubuntu.id
    instance_type = each.value.instance_type
    key_name      = var.key_pair_name

    # ✅ User data (startup script)
    user_data = file("${path.module}/${each.value.user_data}")

    # ✅ Attach security groups dynamically from SG module
    vpc_security_group_ids = [
      module.security_groups[each.value.security_group_ref].security_group_id
    ]

    # ✅ Optional: You can map to a specific subnet in your VPC (or leave null)
    subnet_id = null

    # ✅ Add consistent tags
    tags = merge(var.ec2_tags, {
      Name = each.key
      Role = each.value.role
    })
  }
}

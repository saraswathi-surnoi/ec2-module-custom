# locals {
#   ec2_instances = {
#     for idx, name in var.instance_names :
#     name => {
#       instance_type = idx == 0 ? var.instance_types[0] : var.instance_types[1]
#       role          = idx == 0 ? "JenkinsMaster" : "Backend"
#     }
#   }
# }
# 
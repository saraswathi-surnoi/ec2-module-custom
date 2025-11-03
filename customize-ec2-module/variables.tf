variable "key_pair_name" {
  description = "Existing EC2 key pair name to use"
  type        = string
  default     = "logistics-mot-kp" # Your existing key pair
}


variable "ec2_tags" {
  description = "Common tags for all EC2 instances"
  type = map(any)
  default = {
    Project     = "logistics"
    ManagedBy   = "Terraform"
    Owner       = "DevOpsTeam"
  }
}


variable "instance_types" {
  description = "List of instance types: first is for Jenkins, others for backend servers"
  type        = list(string)
  default     = ["t3.small", "t3.micro"]
}


variable "instances" {
  description = "Map defining all EC2 instances to be created dynamically"
  type = map(object({
    instance_type      = string
    user_data          = string
    security_group_ref = string
    role               = string
  }))

  default = {
    jenkins-master = {
      instance_type      = "t3.small"
      user_data          = "user_data/user_data.jenkins.sh"
      security_group_ref = "jenkins_sg"
      role               = "JenkinsMaster"
    }

    backend-1 = {
      instance_type      = "t3.micro"
      user_data          = "user_data/user_data.backend.sh"
      security_group_ref = "backend_sg"
      role               = "Backend"
    }

    backend-2 = {
      instance_type      = "t3.micro"
      user_data          = "user_data/user_data.backend.sh"
      security_group_ref = "backend_sg"
      role               = "Backend"
    }
  }
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
  default     = "vpc-0086f34dccaccfc5c"
}


variable "security_groups" {
  description = "Map defining all security groups dynamically"
  type = map(object({
    name        = string
    description = string
    ingress     = map(any)
    egress      = map(any)
  }))

  default = {
    # Jenkins Security Group
    jenkins_sg = {
      name        = "jenkins-sg"
      description = "Allow SSH and Jenkins ports"
      ingress = {
        ssh = {
          cidr_ipv4   = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
        }
        jenkins = {
          cidr_ipv4   = "0.0.0.0/0"
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
        }
      }
      egress = {
        allow_all = {
          cidr_ipv4   = "0.0.0.0/0"
          ip_protocol = "-1"
        }
      }
    }

    # Backend Security Group (Restricted to ports 22 & 8080)
    backend_sg = {
      name        = "backend-sg"
      description = "Allow SSH and backend port 8080 only"
      ingress = {
        ssh = {
          cidr_ipv4   = "0.0.0.0/0"
          from_port   = 22
          to_port     = 22
          ip_protocol = "tcp"
        }
        backend_8080 = {
          cidr_ipv4   = "0.0.0.0/0"
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
        }
      }
      egress = {
        allow_all = {
          cidr_ipv4   = "0.0.0.0/0"
          ip_protocol = "-1"
        }
      }
    }
  }
}


variable "security_group_tag" {
  description = "Common tags for all Security Groups"
  type        = map(any)
  default = {
    Project     = "logistics"
    ManagedBy   = "Terraform"
    Owner       = "DevOpsTeam"
    Terraform   = true
  }
}

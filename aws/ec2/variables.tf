variable "system_manager_param_store_name" {
  type        = string
  default     = "/nimbus/gold/linux/centos-7"
  description = "Check details here"
}
variable "Patch_Group" {
  type    = string

  validation {
    condition = contains(["analytics-dev-centos", "analytics-dev-amazon-linux-2"], var.Patch_Group)
    error_message = "Invalid patch group, valid Patch_Group are (analytics-dev-centos , analytics-dev-amazon-linux-2)."
  }
}
variable "team" {
  type    = string

  validation {
    condition = length(var.team) > 2
    error_message = "Team name is missing- Please provide team name."
  }
}
variable "project" {
  type    = string
  
  validation {
    condition = length(var.project) > 2
    error_message = "Project name is missing- Please provide project name."
  }
}
variable "technology" {
  type    = string

  validation {
    condition = length(var.technology) > 1
    error_message = "Technology name is missing- Please provide technology name."
  }
}
variable "env" {
  type    = string

  validation {
    condition = contains(["Dev", "QA"], var.env)
    error_message = "Invalid environment, valid environments are (Dev, QA)."
  }
}
variable "cost_center" {
  type        = string
  description = "Enter Cost Center code. "

 validation {
    condition = length(var.cost_center) > 3
    error_message = "Invalid cost_center_id, cost_center_id should be 4 digit number."
  }
}
variable "app_id" {
  type        = string
  description = "Enter app_id Get one here"
  
  validation {
    condition = length(var.app_id) > 3
    error_message = "Invalid app_id, app_id should be 4 digit number."
  }
}
variable "purpose" {
  type    = string
  default = "test"
}
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "instance_type" {
  type    = string
  default = "t2.medium"
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "public_ip" {
  type    = bool
  default = false
}
variable "termination_protection" {
  type    = bool
  default = false
}
variable "iam_role" {
  type    = string
  default = "Analytics-Instance"
}
variable "security_groups" {
  type    = list(string)
  default = ["sg-XXXX"]
}
variable "subnet_id" {
  type    = string
  default = "subnet-XXX"
}
variable "key_name" {
  type        = string
  description = "Enter the keypair name"
}
#Root Volume Details #EBS
variable "root_volume_size" {
  type    = number
  default = 20
}
variable "root_volume_type" {
  type    = string
  default = "gp2"
}
variable "root_volume_termination_protection" {
  type    = bool
  default = false
}
#Data Volume Details #EBS
variable "create_data_volume" {
  type    = bool
  default = false
}
variable "data_volume_size" {
  type    = number
  default = 0
}
variable "data_volume_type" {
  type    = string
  default = "gp2"
}
#Log Volume Details #EBS
variable "create_log_volume" {
  type    = bool
  default = false
}
variable "log_volume_size" {
  type    = number
  default = 0
}
variable "log_volume_type" {
  type    = string
  default = "gp2"
}

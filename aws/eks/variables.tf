variable "region" {
  type = string
  default = "us-east-1"
}
variable "cluster_name" {
  type        = string
}
variable "eks_version" {
  type        = string
  default     = "1.19"
}
variable "cluster_subnet_ids" {
  type    = list(string)
  default = ["subnet-XXXX", "subnet-XXXX"]
}
variable "node_subnet_ids" {
  type    = list(string)
  default = ["subnet-XXXX"]
}
variable "security_groups" {
  type    = list(string)
  default = ["sg-XXXX"]
}
variable "cluster_role_arn" {
  type    = string
  default = "arn:aws:iam::XXXX:role/Dev-Eks"
}
variable "node_role_arn" {
  type    = string
  default = "arn:aws:iam::XXXX:role/Dev-EKSNode"
}
variable "launch_template_name" {
  type    = string
  default = "AnalyticsAPP"
}
variable "launch_template_version" {
  type    = number
  default = 1
}
variable "storage_size" {
  type    = number
  default = 20
}
variable "instance_type" {
  type    = string
  default = "r5.large"
}
variable "key_pair" {
  type    = string
  default = "anrathore"
}
variable "ssm_param_name" {
  type    = string
  default = "amazon-2-eks"
}
variable "desired_cluster_size" {
  type    = number
  default = 2
}
variable "max_cluster_size" {
  type    = number
  default = 2
}
variable "min_cluster_size" {
  type    = number
  default = 2
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
  description = "Enter Cost Center code. Get one here "

 validation {
    condition = length(var.cost_center) > 3
    error_message = "Invalid cost_center_id, cost_center_id should be 4 digit number."
  }
}
variable "app_id" {
  type        = string
  description = "Enter app_id Get one here "
  
  validation {
    condition = length(var.app_id) > 3
    error_message = "Invalid app_id, app_id should be 4 digit number."
  }
}
variable "patch_group" {
  type    = string

  validation {
    condition = contains(["centos", "amazon-linux-2"], var.patch_group)
    error_message = "Invalid patch group, valid Patch_Group are (centos , amazon-linux-2)."
  }
}

provider "aws" {
  region = var.region
}

data "template_file" "ec2_user_data" {
  template = file("user_data.sh")
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "ssm-param" {
  name = var.system_manager_param_store_name
}

data "aws_subnet" "current_subnet" {
  id = var.subnet_id
}
//Users are restricted to create security groups. hence commented
/* 
resource "aws_security_group" "ssh_security_group" {
  #count = var.create_new_security_group ? 1 : 0
  name        = format("%s-%s-%s-%s", "analytics", var.env, var.purpose, "sg-tf")
  description = "Security Group for SSH"
  vpc_id      = data.aws_subnet.current_subnet.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    COST_CENTER = var.cost_center
    Name        = format("%s-%s-%s-%s-%s", "analytics", var.env, var.purpose, split("/", data.aws_caller_identity.current.arn)[1], "sg-tf")
  }
}
*/
resource "aws_instance" "analytics-ec2-instance" {
  count                       = var.instance_count
  ami                         = data.aws_ssm_parameter.ssm-param.value
  instance_type               = var.instance_type
  associate_public_ip_address = var.public_ip
  //availability_zone           = "us-east-1a"
  disable_api_termination = var.termination_protection
  iam_instance_profile    = var.iam_role
  key_name                = var.key_name //split("/", data.aws_caller_identity.current.arn)[1]
  user_data               = data.template_file.ec2_user_data.template
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = var.root_volume_termination_protection
    tags = {
      COST_CENTER = var.cost_center
      Name        = format("%s-%s-%s-%s",var.env, var.team, var.project, split("/", data.aws_caller_identity.current.arn)[1])
    }
  }
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  tags = {
      COST_CENTER = var.cost_center
      APP_ID  = var.app_id
      Name        = format("%s-%s-%s-%s",var.env, var.team, var.project, split("/", data.aws_caller_identity.current.arn)[1])
      "Patch Group" = var.Patch_Group
    }
  }
resource "aws_ebs_volume" "data-ebs-volume" {
  count             = var.create_data_volume ? var.instance_count : 0
  availability_zone = data.aws_subnet.current_subnet.availability_zone
  size              = var.data_volume_size
  type              = var.data_volume_type
  tags = {
      COST_CENTER = var.cost_center
      Name        = format("%s-%s-%s-%s",var.env, var.team, var.project, split("/", data.aws_caller_identity.current.arn)[1])
    }
}

resource "aws_ebs_volume" "log-ebs-volume" {
  count             = var.create_log_volume ? var.instance_count : 0
  availability_zone = data.aws_subnet.current_subnet.availability_zone
  size              = var.log_volume_size
  type              = var.log_volume_type
  tags = {
      COST_CENTER = var.cost_center
      Name        = format("%s-%s-%s-%s",var.env, var.team, var.project, split("/", data.aws_caller_identity.current.arn)[1])
    }
}

resource "aws_volume_attachment" "data-ebs-volume-attachment" {
  count        = var.create_data_volume ? var.instance_count : 0
  device_name  = "/dev/xvdb"
  force_detach = true
  volume_id    = element(aws_ebs_volume.data-ebs-volume.*.id, count.index)
  instance_id  = element(aws_instance.analytics-ec2-instance.*.id, count.index)
}

resource "aws_volume_attachment" "log-ebs-volume-attachment" {
  count        = var.create_log_volume ? var.instance_count : 0
  device_name  = "/dev/xvdc"
  force_detach = true
  volume_id    = element(aws_ebs_volume.log-ebs-volume.*.id, count.index)
  instance_id  = element(aws_instance.analytics-ec2-instance.*.id, count.index)
}

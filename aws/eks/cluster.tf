provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_eks_cluster" "EKS-Cluster" {
  name     = format("%s-%s", var.env, var.cluster_name)
  role_arn = var.cluster_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.cluster_subnet_ids
    security_group_ids = var.security_groups
  }
}

resource "aws_eks_addon" "EKS-Addon-vpc-cni" {
  cluster_name = aws_eks_cluster.EKS-Cluster.name
  addon_name   = "vpc-cni"
}
resource "aws_eks_addon" "EKS-Addon-core-dns" {
  cluster_name = aws_eks_cluster.EKS-Cluster.name
  addon_name   = "coredns"
  depends_on = [
    aws_eks_node_group.EKS-Cluster-NG
  ]
}
resource "aws_eks_addon" "EKS-Addon-kube-proxy" {
  cluster_name = aws_eks_cluster.EKS-Cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_node_group" "EKS-Cluster-NG" {
  cluster_name    = aws_eks_cluster.EKS-Cluster.name
  node_group_name = format("%s-%s", aws_eks_cluster.EKS-Cluster.name, "NG")
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.node_subnet_ids

  launch_template {
    name = format("%s-%s", aws_eks_cluster.EKS-Cluster.name, "LT")
    version = 1
  }

  tags = {
    APP_ID = var.app_id
    COST_CENTER  = var.cost_center
    "Patch Group"  = var.patch_group
  }

  scaling_config {
    desired_size = var.desired_cluster_size
    max_size     = var.max_cluster_size
    min_size     = var.min_cluster_size
  }
  depends_on = [
   aws_launch_template.data-advocate-launch-template
  ]
}

data "aws_ssm_parameter" "ssm-param" {
  name = var.ssm_param_name
}

data "template_file" "user_data" {
  template = <<EOF
    #!/bin/bash
    set -ex
    /etc/eks/bootstrap.sh ${aws_eks_cluster.EKS-Cluster.name} --b64-cluster-ca ${aws_eks_cluster.EKS-Cluster.certificate_authority[0].data} --apiserver-endpoint ${aws_eks_cluster.EKS-Cluster.endpoint}
  EOF
}

resource "aws_launch_template" "data-advocate-launch-template" {
  name = format("%s-%s", aws_eks_cluster.EKS-Cluster.name, "LT")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.storage_size
    }
  }

  image_id = data.aws_ssm_parameter.ssm-param.value

  instance_type = var.instance_type

  key_name = var.key_pair

  vpc_security_group_ids = var.security_groups

  tag_specifications {
    resource_type = "instance"

    tags = {
    APP_ID = var.app_id
    COST_CENTER  = var.cost_center
    "Patch Group"  = var.patch_group
    Name =  format("%s-%s-%s", "EKS", aws_eks_cluster.EKS-Cluster.name, split("/", data.aws_caller_identity.current.arn)[1])

    }
  }
  user_data = base64encode(data.template_file.user_data.rendered)
  depends_on = [
    aws_eks_cluster.EKS-Cluster
  ]
}

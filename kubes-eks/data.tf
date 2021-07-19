data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${aws_eks_cluster.m8tt.version}-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI Account ID
  # https://aws.amazon.com/blogs/opensource/improvements-eks-worker-node-provisioning/
}

data "null_data_source" "null_resource_override_instance_types" {
  count = "${length(var.override_instance_types)}"

  inputs = "${map(
    "instance_type", trimspace(element(var.override_instance_types, count.index))
  )}"
}

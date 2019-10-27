################################################################################
#   Master
################################################################################

resource "aws_iam_role" "m8tt-cluster" {
  name = "terraform-eks-m8tt-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "m8tt-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.m8tt-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "m8tt-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.m8tt-cluster.name}"
}

################################################################################
#   Node Pools
################################################################################

resource "aws_iam_role" "m8tt-node" {
  name = "terraform-eks-m8tt-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "m8tt-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.m8tt-node.name}"
}

resource "aws_iam_role_policy_attachment" "m8tt-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.m8tt-node.name}"
}

resource "aws_iam_role_policy_attachment" "m8tt-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.m8tt-node.name}"
}

resource "aws_iam_instance_profile" "m8tt-node" {
  name = "terraform-eks-m8tt-node"
  role = "${aws_iam_role.m8tt-node.name}"
}

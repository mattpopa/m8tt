resource "aws_placement_group" "placement_group" {
  name     = "${terraform.workspace}"
  strategy = "${var.placement_stategy}"
}

resource "aws_eks_cluster" "m8tt" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.m8tt-cluster.arn}"
  version  = "${var.version}"

  vpc_config {
    security_group_ids = ["${aws_security_group.m8tt-cluster.id}"]
    subnet_ids         = ["${aws_subnet.m8tt.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.m8tt-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.m8tt-cluster-AmazonEKSServicePolicy",
  ]
}

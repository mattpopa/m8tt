resource "aws_security_group" "m8tt-cluster" {
  name        = "${terraform.workspace}-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.m8tt.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name        = "${terraform.workspace}-eks-cluster"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes.
resource "aws_security_group_rule" "m8tt-cluster-ingress-workstation-https" {
  cidr_blocks       = ["78.96.101.50/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.m8tt-cluster.id}"
  to_port           = 443
  type              = "ingress"
}

################################################################################
# Nodes
################################################################################

resource "aws_security_group" "m8tt-node" {
  name        = "${terraform.workspace}-eks-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${aws_vpc.m8tt.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "terraform-eks-m8tt-node",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "m8tt-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${aws_security_group.m8tt-node.id}"
  source_security_group_id = "${aws_security_group.m8tt-node.id}"
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "m8tt-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.m8tt-node.id}"
  source_security_group_id = "${aws_security_group.m8tt-cluster.id}"
  to_port                  = 65535
  type                     = "ingress"
}

################################################################################
#   Nodes to EKS Master
################################################################################

resource "aws_security_group_rule" "m8tt-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.m8tt-cluster.id}"
  source_security_group_id = "${aws_security_group.m8tt-node.id}"
  to_port                  = 443
  type                     = "ingress"
}


output "cluster_name" {
  value = "m8tt.ddigital.org"
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-m8tt-ddigital-org.id}"]
}

output "masters_role_arn" {
  value = "${aws_iam_role.masters-m8tt-ddigital-org.arn}"
}

output "masters_role_name" {
  value = "${aws_iam_role.masters-m8tt-ddigital-org.name}"
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-m8tt-ddigital-org.id}"]
}

output "node_subnet_ids" {
  value = ["${aws_subnet.eu-central-1a-m8tt-ddigital-org.id}", "${aws_subnet.eu-central-1b-m8tt-ddigital-org.id}"]
}

output "nodes_role_arn" {
  value = "${aws_iam_role.nodes-m8tt-ddigital-org.arn}"
}

output "nodes_role_name" {
  value = "${aws_iam_role.nodes-m8tt-ddigital-org.name}"
}

output "region" {
  value = "eu-central-1"
}

output "vpc_id" {
  value = "${aws_vpc.m8tt-ddigital-org.id}"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_autoscaling_group" "master-eu-central-1a-masters-m8tt-ddigital-org" {
  name                 = "master-eu-central-1a.masters.m8tt.ddigital.org"
  launch_configuration = "${aws_launch_configuration.master-eu-central-1a-masters-m8tt-ddigital-org.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-m8tt-ddigital-org.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "m8tt.ddigital.org"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-eu-central-1a.masters.m8tt.ddigital.org"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-eu-central-1a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "nodes-m8tt-ddigital-org" {
  name                 = "nodes.m8tt.ddigital.org"
  launch_configuration = "${aws_launch_configuration.nodes-m8tt-ddigital-org.id}"
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = ["${aws_subnet.eu-central-1a-m8tt-ddigital-org.id}", "${aws_subnet.eu-central-1b-m8tt-ddigital-org.id}"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "m8tt.ddigital.org"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes.m8tt.ddigital.org"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }
}

resource "aws_ebs_volume" "a-etcd-events-m8tt-ddigital-org" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "m8tt.ddigital.org"
    Name                 = "a.etcd-events.m8tt.ddigital.org"
    "k8s.io/etcd/events" = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_ebs_volume" "a-etcd-main-m8tt-ddigital-org" {
  availability_zone = "eu-central-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster    = "m8tt.ddigital.org"
    Name                 = "a.etcd-main.m8tt.ddigital.org"
    "k8s.io/etcd/main"   = "a/a"
    "k8s.io/role/master" = "1"
  }
}

resource "aws_iam_instance_profile" "masters-m8tt-ddigital-org" {
  name = "masters.m8tt.ddigital.org"
  role = "${aws_iam_role.masters-m8tt-ddigital-org.name}"
}

resource "aws_iam_instance_profile" "nodes-m8tt-ddigital-org" {
  name = "nodes.m8tt.ddigital.org"
  role = "${aws_iam_role.nodes-m8tt-ddigital-org.name}"
}

resource "aws_iam_role" "masters-m8tt-ddigital-org" {
  name               = "masters.m8tt.ddigital.org"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_masters.m8tt.ddigital.org_policy")}"
}

resource "aws_iam_role" "nodes-m8tt-ddigital-org" {
  name               = "nodes.m8tt.ddigital.org"
  assume_role_policy = "${file("${path.module}/data/aws_iam_role_nodes.m8tt.ddigital.org_policy")}"
}

resource "aws_iam_role_policy" "masters-m8tt-ddigital-org" {
  name   = "masters.m8tt.ddigital.org"
  role   = "${aws_iam_role.masters-m8tt-ddigital-org.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_masters.m8tt.ddigital.org_policy")}"
}

resource "aws_iam_role_policy" "nodes-m8tt-ddigital-org" {
  name   = "nodes.m8tt.ddigital.org"
  role   = "${aws_iam_role.nodes-m8tt-ddigital-org.name}"
  policy = "${file("${path.module}/data/aws_iam_role_policy_nodes.m8tt.ddigital.org_policy")}"
}

resource "aws_internet_gateway" "m8tt-ddigital-org" {
  vpc_id = "${aws_vpc.m8tt-ddigital-org.id}"

  tags = {
    KubernetesCluster = "m8tt.ddigital.org"
    Name              = "m8tt.ddigital.org"
  }
}

resource "aws_key_pair" "kubernetes-m8tt-ddigital-org-c0fbf5acaa94b91ecc24bb8f0223c44a" {
  key_name   = "kubernetes.m8tt.ddigital.org-c0:fb:f5:ac:aa:94:b9:1e:cc:24:bb:8f:02:23:c4:4a"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.m8tt.ddigital.org-c0fbf5acaa94b91ecc24bb8f0223c44a_public_key")}"
}

resource "aws_launch_configuration" "master-eu-central-1a-masters-m8tt-ddigital-org" {
  name_prefix                 = "master-eu-central-1a.masters.m8tt.ddigital.org-"
  image_id                    = "ami-aae67ac5"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-m8tt-ddigital-org-c0fbf5acaa94b91ecc24bb8f0223c44a.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-m8tt-ddigital-org.id}"
  security_groups             = ["${aws_security_group.masters-m8tt-ddigital-org.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-eu-central-1a.masters.m8tt.ddigital.org_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "nodes-m8tt-ddigital-org" {
  name_prefix                 = "nodes.m8tt.ddigital.org-"
  image_id                    = "ami-aae67ac5"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-m8tt-ddigital-org-c0fbf5acaa94b91ecc24bb8f0223c44a.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-m8tt-ddigital-org.id}"
  security_groups             = ["${aws_security_group.nodes-m8tt-ddigital-org.id}"]
  associate_public_ip_address = true
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.m8tt.ddigital.org_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }
}

resource "aws_route" "0-0-0-0--0" {
  route_table_id         = "${aws_route_table.m8tt-ddigital-org.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.m8tt-ddigital-org.id}"
}

resource "aws_route_table" "m8tt-ddigital-org" {
  vpc_id = "${aws_vpc.m8tt-ddigital-org.id}"

  tags = {
    KubernetesCluster = "m8tt.ddigital.org"
    Name              = "m8tt.ddigital.org"
  }
}

resource "aws_route_table_association" "eu-central-1a-m8tt-ddigital-org" {
  subnet_id      = "${aws_subnet.eu-central-1a-m8tt-ddigital-org.id}"
  route_table_id = "${aws_route_table.m8tt-ddigital-org.id}"
}

resource "aws_route_table_association" "eu-central-1b-m8tt-ddigital-org" {
  subnet_id      = "${aws_subnet.eu-central-1b-m8tt-ddigital-org.id}"
  route_table_id = "${aws_route_table.m8tt-ddigital-org.id}"
}

resource "aws_security_group" "masters-m8tt-ddigital-org" {
  name        = "masters.m8tt.ddigital.org"
  vpc_id      = "${aws_vpc.m8tt-ddigital-org.id}"
  description = "Security group for masters"

  tags = {
    KubernetesCluster = "m8tt.ddigital.org"
    Name              = "masters.m8tt.ddigital.org"
  }
}

resource "aws_security_group" "nodes-m8tt-ddigital-org" {
  name        = "nodes.m8tt.ddigital.org"
  vpc_id      = "${aws_vpc.m8tt-ddigital-org.id}"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster = "m8tt.ddigital.org"
    Name              = "nodes.m8tt.ddigital.org"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-109-166-194-99--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["109.166.194.99/32"]
}

resource "aws_security_group_rule" "https-external-to-master-78-96-101-50--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["78.96.101.50/32"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  source_security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-109-166-194-99--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["109.166.194.99/32"]
}

resource "aws_security_group_rule" "ssh-external-to-master-78-96-101-50--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.masters-m8tt-ddigital-org.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["78.96.101.50/32"]
}

resource "aws_security_group_rule" "ssh-external-to-node-109-166-194-99--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["109.166.194.99/32"]
}

resource "aws_security_group_rule" "ssh-external-to-node-78-96-101-50--32" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nodes-m8tt-ddigital-org.id}"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["78.96.101.50/32"]
}

resource "aws_subnet" "eu-central-1a-m8tt-ddigital-org" {
  vpc_id            = "${aws_vpc.m8tt-ddigital-org.id}"
  cidr_block        = "172.20.32.0/19"
  availability_zone = "eu-central-1a"

  tags = {
    KubernetesCluster                         = "m8tt.ddigital.org"
    Name                                      = "eu-central-1a.m8tt.ddigital.org"
    "kubernetes.io/cluster/m8tt.ddigital.org" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_subnet" "eu-central-1b-m8tt-ddigital-org" {
  vpc_id            = "${aws_vpc.m8tt-ddigital-org.id}"
  cidr_block        = "172.20.64.0/19"
  availability_zone = "eu-central-1b"

  tags = {
    KubernetesCluster                         = "m8tt.ddigital.org"
    Name                                      = "eu-central-1b.m8tt.ddigital.org"
    "kubernetes.io/cluster/m8tt.ddigital.org" = "owned"
    "kubernetes.io/role/elb"                  = "1"
  }
}

resource "aws_vpc" "m8tt-ddigital-org" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                         = "m8tt.ddigital.org"
    Name                                      = "m8tt.ddigital.org"
    "kubernetes.io/cluster/m8tt.ddigital.org" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "m8tt-ddigital-org" {
  domain_name         = "eu-central-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster = "m8tt.ddigital.org"
    Name              = "m8tt.ddigital.org"
  }
}

resource "aws_vpc_dhcp_options_association" "m8tt-ddigital-org" {
  vpc_id          = "${aws_vpc.m8tt-ddigital-org.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.m8tt-ddigital-org.id}"
}


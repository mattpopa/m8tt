resource "aws_launch_template" "m8tt" {
  description   = "This is the launch template for EKS worker nodes"
  image_id      = "${data.aws_ami.eks-worker.id}"
  name_prefix   = "m8tt"
  user_data     = "${base64encode(local.node-userdata)}"
  ebs_optimized = true
  instance_type = "${lookup(var.env_instance_types, "eks.service.instance_type.devel")}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      volume_size           = 50
      volume_type           = "gp2"
    }
  }

  iam_instance_profile {
    name = "${aws_iam_role.m8tt-node.name}"
  }

  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      "${aws_security_group.m8tt-node.id}",
    ]

    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "m8tt" {
  name                = "m8tt"
  vpc_zone_identifier = ["${aws_subnet.m8tt.*.id}"]

  max_size         = 2
  min_size         = 1
  desired_capacity = 2

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.m8tt.id}"
        version            = "${aws_launch_template.m8tt.latest_version}"
      }

      override = ["${local.instance_types}"]
    }

    instances_distribution {
      on_demand_percentage_above_base_capacity = 100
      on_demand_allocation_strategy            = "prioritized"
    }
  }

  tag {
    key                 = "Name"
    value               = "eks-${var.cluster-name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

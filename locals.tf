locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.m8tt.endpoint}' --b64-cluster-ca '${aws_eks_cluster.m8tt.certificate_authority.0.data}' '${var.cluster-name}'
USERDATA
}

locals {
  instance_types  = ["${data.null_data_source.null_resource_override_instance_types.*.outputs}"]
}

variable "cluster-name" {
  description = "K8's cluster name"
  type        = "string"
  default     = "m8tt"
}

variable "version" {
  description = "The Kubernetes version"
  default     = "1.13"
}

# deprecated in favor of dynamic filters
#variable "ami_id" {
#  # See https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html for more information.
#  description = "EKS Optimized AMI"
#  type        = "string"
#  default     = "ami-0404d23c7e8188740"
#}

variable "placement_stategy" {
  # See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html for more information.
  description = "Placement strategy cluster|spread"
  default     = "spread"
}

variable "env_instance_types" {
  description = "Instance type per env/app"
  type        = "map"

  default = {
    eks.service.instance_type.devel             = "t3.small"
    eks.service.instance_type.override1-devel   = "t3a.small"
    eks.service.instance_type.staging           = "t3.large"
    eks.service.instance_type.override1-staging = "t3a.large"
  }
}

variable "override_instance_types" {
  description = "The size of instance to launch, minimum 2 types must be specified."
  type        = "list"
  default     = ["t3a.small", "t3.small", "t3a.medium", "t3.medium"]
}

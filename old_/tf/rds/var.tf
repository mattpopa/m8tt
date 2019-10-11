variable "dbs_pass" {
}

variable "dbs_user" {
    default = "sonar"
}

variable "volume_size" {
  default = 10
}

variable "instance_class" {
  default = "db.t2.small"
}

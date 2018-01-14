data "terraform_remote_state" "db_out" {
  backend = "s3"
  config {
    bucket  = "digital-tf-state"
    key     = "m8tt"
    region  = "eu-central-1"
    encrypt = true
    profile = "digit-all"
  }
}

output "m8_vpc_id" {
  value = "${data.terraform_remote_state.db_out.vpc_id}"
}

output "m8_subnets" {
  value = ["${data.terraform_remote_state.db_out.node_subnet_ids}"]
}

output "m8_sgs" {
  value = ["${data.terraform_remote_state.db_out.node_security_group_ids}"]
}

output "m8_name" {
  value = "${data.terraform_remote_state.db_out.cluster_name}"
}

output "db_address" {
  value = "${aws_db_instance.sonarqube_db.address}"
}

output "db_port" {
  value = "${aws_db_instance.sonarqube_db.port}"
}

resource "aws_db_subnet_group" "db_subnet" {
  name        = "${terraform.workspace}-k8-cluster-dbgroup"
  subnet_ids  =  ["${data.terraform_remote_state.db_out.node_security_group_ids}"]
  description = "DB Subnet Group for ${terraform.workspace}-k8-cluster"

  tags {
    Name = "${terraform.workspace}-k8-cluster-dbgroup"
  }
}

resource "aws_db_instance" "sonarqube_db" {
  engine                 = "postgress"
  engine_version         = "9.5.2"
  allocated_storage      = "${var.volume_size}"
  instance_class         = "${var.instance_class}"
  publicly_accessible    = "false"
  storage_encrypted      = "true"
  multi_az               = "false"
  name                   = "SonarqubeDB"
  db_subnet_group_name   = "${terraform.workspace}-k8-cluster-dbgroup"
  vpc_security_group_ids = ["${data.terraform_remote_state.db_out.node_security_group_ids}", "${aws_security_group.sonarqube_db.id}"]
  username               = "${var.dbs_user}"
  password               = "${var.dbs_pass}"
  skip_final_snapshot    = "true"
  depends_on             = ["aws_vpc.m8tt-ddigital-org"]   
}

resource "aws_security_group" "sonarqube_db" {
  name = "SonarqubeDB_SG"
  description = "Postgresql SG, required by Sonarqube"
  vpc_id = "${data.terraform_remote_state.db_out.vpc_id}"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["172.20.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

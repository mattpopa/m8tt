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

output "db_address" {
  value = "${aws_db_instance.sonarqube_db.address}"
}

output "db_port" {
  value = "${aws_db_instance.sonarqube_db.port}"
}

resource "aws_db_subnet_group" "sonar_db_subnet" {
  name        = "sonar-k8"
  subnet_ids  = [ "${data.terraform_remote_state.db_out.node_subnet_ids}" ]
  tags {
    Name = "sonar-k8-dbgroup"
  }
}

resource "aws_db_instance" "sonarqube_db" {
  engine                 = "postgres"
  engine_version         = "9.5.2"
  allocated_storage      = "${var.volume_size}"
  instance_class         = "${var.instance_class}"
  publicly_accessible    = "false"
  storage_encrypted      = "true"
  multi_az               = "false"
  name                   = "SonarqubeDB"
  db_subnet_group_name   = "sonar-k8"
  vpc_security_group_ids = ["${aws_security_group.sonarqube_db.id}", "${data.terraform_remote_state.db_out.node_security_group_ids}"]
  username               = "${var.dbs_user}"
  password               = "${var.dbs_pass}"
  skip_final_snapshot    = "true"
  lifecycle {
    ignore_changes = ["password", "storage_encrypted"]
    prevent_destroy = false
  }
  depends_on = ["aws_db_subnet_group.sonar_db_subnet"]
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

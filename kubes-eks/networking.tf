resource "aws_vpc" "m8tt" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "m8tt-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "m8tt" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.m8tt.id}"

  tags = "${
    map(
     "Name", "m8tt-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "m8tt" {
  vpc_id = "${aws_vpc.m8tt.id}"

  tags = {
    Name = "m8tt"
  }
}

resource "aws_route_table" "m8tt" {
  vpc_id = "${aws_vpc.m8tt.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.m8tt.id}"
  }
}

resource "aws_route_table_association" "m8tt" {
  count = 2

  subnet_id      = "${aws_subnet.m8tt.*.id[count.index]}"
  route_table_id = "${aws_route_table.m8tt.id}"
}


## VPC

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "inet_gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet_gw.id
  }
}

## SUBNETS (public)

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public1" {
  cidr_block        = "192.168.0.0/24"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_route_table_association" "rt-asoc-public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "public2" {
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_route_table_association" "rt-asoc-public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

## nat gateway


resource "aws_eip" "elastic_ip_nat" {
  # see https://www.terraform.io/docs/providers/aws/r/eip.html
  vpc         = true
  depends_on  = [aws_internet_gateway.inet_gw]
}

resource "aws_nat_gateway" "nat_gw" {
  subnet_id = aws_subnet.public1.id
  allocation_id = aws_eip.elastic_ip_nat.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

## SUBNETS (private)

resource "aws_subnet" "private1" {
  cidr_block = "192.168.2.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_route_table_association" "rt-asoc-private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_subnet" "private2" {
  cidr_block = "192.168.3.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_route_table_association" "rt-asoc-private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

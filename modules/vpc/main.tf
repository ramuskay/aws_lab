provider "aws" {
  region = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.owner}-vpc"
  }
}

resource "aws_subnet" "subnet-public" {
  for_each          = toset(var.availability_zones[var.region])
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, index(var.availability_zones[var.region], each.value))
  availability_zone = each.value
  tags = {
    Name = "${var.owner}-subnet-public-f-${substr(var.region, length(var.region) -1, 1)}${substr(each.value, length(each.value)-1, 1)}"
  }  
}

resource "aws_internet_gateway" "ig" {}

resource "aws_internet_gateway_attachment" "internet_gateway_attachment" {
  internet_gateway_id = aws_internet_gateway.ig.id
  vpc_id              = aws_vpc.vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_internet_gateway.ig.id
    cidr_block = "0.0.0.0/0"
  }
  tags = {
    Name = "${var.owner}-rt"
  }
}
resource "aws_route_table_association" "a" {
  for_each       = toset(var.availability_zones[var.region])
  subnet_id      = aws_subnet.subnet-public[each.value].id
  route_table_id = aws_route_table.rt.id
}
provider "aws" {
  region = var.region
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


data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_key_pair" "adeschamps" {
  key_name   = "key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAeQzIpEE4sB5QMG3KcFpi2Ma9LHps/a0d3FCpKC2+0KVstI23xi57/D2FnpPc6/9yUrlL4hx2LUr0JJyTl661h+z+O9VHVS18lfU3oisvU4KzDKMZoRM3L3jC/ws4RI5Dz4wWOrZmQPQC6EEZYzTyoHPOI44yDrlqhltGmU4eBSF5Gc8qBZOEPf8wZyUJ5OVMgxmsLlrsrGg4EE50oiM5zJKq8BOuRcUNhvmZyY4fV3gGjSKRG3Wk4oMChuzDrGUS2ez+jP8pfZceBr01QiS2kjydl363y235vbF05ojeVUHwTk+X5OgOX3Zcu/gB3xWUEzFv/bOJm1rAAda1su7P2Wdkrx4zxrj0bn60GI3k/vFqC2HsDg5AjDFIOq3sSQx6agR/4EhBPMqj4rlx4M0LGjvywXiOPO7VNAhZM8KrWxpbvan+FN9KlRllpH+Z2ghm893Hljy9yikM64FU8Yeswj2cRDZOrA1BVTdXff64n+9Imblgp4J3wsFrAPPtTCM= aurel@PC-AUREL"
  tags = {
    Name = "${var.owner}-keypair"
  }
}

data "aws_ec2_instance_types" "free_tier_types" {
  filter {
    name   = "instance-type"
    values = ["t2.micro", "t3.micro"]
  }
}
output "free_tier_instance_types" {
  value = data.aws_ec2_instance_types.free_tier_types.instance_types
}

resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.owner}-sg"
  }
}
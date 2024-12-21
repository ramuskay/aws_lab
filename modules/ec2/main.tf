provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = {
      Owner = var.owner
    }
  }
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

resource "aws_security_group" "sg" {
  name   = "sg"
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.owner}-sg"
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = data.aws_ec2_instance_types.free_tier_types.instance_types[0]
  # subnet_id                   = aws_subnet.subnet-public[var.region][lookup(var.availability_zones, "${var.region}${var.az_of_the_ec2}")].id
  key_name = aws_key_pair.adeschamps.key_name
  subnet_id = lookup(
    { for s in var.aws_subnets : s.availability_zone => s.id },
    "${var.region}${var.az_of_the_ec2}",
    null
  )
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  tags = {
    Name = "${var.owner}-ec2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg-ingress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  tags = {
    Name = "${var.owner}-sg-ingress"
  }
}

resource "aws_vpc_security_group_egress_rule" "sg-egress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  tags = {
    Name = "${var.owner}-sg-egress"
  }
}
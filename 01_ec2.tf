resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = data.aws_ec2_instance_types.free_tier_types.instance_types[0]
  # subnet_id                   = aws_subnet.subnet-public[var.region][lookup(var.availability_zones, "${var.region}${var.az_of_the_ec2}")].id
  key_name = aws_key_pair.adeschamps.key_name
  subnet_id = lookup(
    { for s in aws_subnet.subnet-public : s.availability_zone => s.id },
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

output "instance_public_ip" {
  value = aws_instance.ec2.public_ip
}

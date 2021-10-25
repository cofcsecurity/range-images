resource "aws_subnet" "blue_subnet" {
  vpc_id            = aws_vpc.range.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.aws_availability_zone
}

resource "aws_route_table" "blue_routes" {
  vpc_id = aws_vpc.range.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bastion_nat_gateway.id
  }
}

resource "aws_route_table_association" "blue_routes" {
  subnet_id      = aws_subnet.blue_subnet.id
  route_table_id = aws_route_table.blue_routes.id
}

resource "aws_network_acl" "blue_subnet_acl" {
  vpc_id     = aws_vpc.range.id
  subnet_ids = [aws_subnet.blue_subnet.id]

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
  }
}

resource "aws_security_group" "bluenet" {
  name        = "range_bluenet_security_group"
  description = "Range security group for BlueNet"
  vpc_id      = aws_vpc.range.id
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }
}

resource "aws_instance" "bluehost" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = var.aws_availability_zone
  security_groups   = [aws_security_group.bluenet.id]
  subnet_id         = aws_subnet.blue_subnet.id
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  tags = {
    "Name" = "BlueHost"
  }
}

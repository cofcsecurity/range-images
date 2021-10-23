resource "aws_subnet" "bastion_subnet" {
  vpc_id            = aws_vpc.range.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.aws_availability_zone
}

resource "aws_nat_gateway" "bastion_nat_gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.bastion_subnet.id
}

resource "aws_route_table" "bastion_routes" {
  vpc_id = aws_vpc.range.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.range_gateway.id
  }
}

resource "aws_route_table_association" "bastion_routes" {
  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_routes.id
}

resource "aws_network_acl" "bastion_subnet_acl" {
  vpc_id     = aws_vpc.range.id
  subnet_ids = [aws_subnet.bastion_subnet.id]

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
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

resource "aws_security_group" "bastion" {
  name        = "range_bastion_security_group"
  description = "Range security group for Bastion"
  vpc_id      = aws_vpc.range.id
  ingress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
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

resource "aws_instance" "bastion" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = var.aws_availability_zone
  security_groups   = [aws_security_group.bastion.id]
  subnet_id         = aws_subnet.bastion_subnet.id
  key_name = aws_key_pair.range_ssh_public_key.key_name

  tags = {
    "Name" = "Bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
}

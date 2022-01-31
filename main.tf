terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = var.aws_accesskey
  secret_key = var.aws_secretkey
}

resource "aws_vpc" "finditgeek_presentation" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "10.10.10.0/23"
  }
}

resource "aws_subnet" "finditgeek_presentation_public" {
  vpc_id                  = aws_vpc.finditgeek_presentation.id
  cidr_block              = "10.10.10.0/28"
  map_public_ip_on_launch = true

  tags = {
    Name = "finditgeek_presentation_public"
  }
}

resource "aws_subnet" "finditgeek_presentation_private" {
  vpc_id     = aws_vpc.finditgeek_presentation.id
  cidr_block = "10.10.10.16/28"

  tags = {
    Name = "finditgeek_presentation_private"
  }
}

resource "aws_internet_gateway" "finditgeek_presentation" {
  vpc_id = aws_vpc.finditgeek_presentation.id

  tags = {
    Name = "finditgeek_presentation"
  }
}

#SECURITY GROUPS

resource "aws_security_group" "finditgeek_presentation_loadbalancer" {
  vpc_id = aws_vpc.finditgeek_presentation.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "finditgeek_presentation_loadbalancer"
  }
}

resource "aws_security_group" "finditgeek_presentation_webserver" {
  vpc_id = aws_vpc.finditgeek_presentation.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Ping"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "finditgeek_presentation_webserver"
  }
}

#INSTANCES

resource "aws_instance" "finditgeek_presentation_loadbalancer" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.finditgeek_presentation_loadbalancer.id]
  subnet_id              = aws_subnet.finditgeek_presentation_public.id
  private_ip             = "10.10.10.10"

  user_data = file("provisioning_loadbalancer.sh")

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "finditgeek_presentation_loadbalancer"
  }
}


resource "aws_instance" "finditgeek_presentation_webserver" {
  count         = 2
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.finditgeek_presentation_webserver.id]
  subnet_id              = aws_subnet.finditgeek_presentation_private.id
  private_ip             = element(var.webserver_ip_private, count.index)

  user_data = file("provisioning_webserver.sh")

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "finditgeek_presentation_webserver"
  }
}

#ROUTE TABLE

resource "aws_route_table" "finditgeek_presentation_prisub" {
  vpc_id = aws_vpc.finditgeek_presentation.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.finditgeek_presentation_loadbalancer.id
  }

  route {
    cidr_block  = "10.10.10.0/28"
    instance_id = aws_instance.finditgeek_presentation_loadbalancer.id
  }

  tags = {
    Name = "finditgeek_presentation_prisub"
  }
}

resource "aws_route_table_association" "finditgeek_presentation_prisub" {
  subnet_id      = aws_subnet.finditgeek_presentation_private.id
  route_table_id = aws_route_table.finditgeek_presentation_prisub.id
}

resource "aws_route_table" "finditgeek_presentation_pubsub" {
  vpc_id = aws_vpc.finditgeek_presentation.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.finditgeek_presentation.id
  }

  tags = {
    Name = "finditgeek_presentation_prisub"
  }
}

resource "aws_route_table_association" "finditgeek_presentation_pubsub" {
  subnet_id      = aws_subnet.finditgeek_presentation_public.id
  route_table_id = aws_route_table.finditgeek_presentation_pubsub.id
}
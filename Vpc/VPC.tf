
resource "aws_vpc" "vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC-02"
  }
}

resource "aws_subnet" "pub" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "pub-vpc-02"
  }
}

resource "aws_subnet" "pvt" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "pvt-vpc-02"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "elp" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.elp.id
  subnet_id     = aws_subnet.pvt.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
	

    tags = {
      Name = "Route1"
   }
 }


resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.ngw.id
    }
	

    tags = {
      Name = "Route2"
   }
 }


resource "aws_route_table_association" "pub_association" {
  subnet_id      = aws_subnet.pub.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "pvt_association" {
  subnet_id      = aws_subnet.pvt.id
  route_table_id = aws_route_table.rt2.id
}

resource "aws_security_group" "sg" {
  name        = "first-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.vpc.cidr_block]
      
    }
  

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }
  

  tags = {
    Name = "first-sg"
  }
}


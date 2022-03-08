provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIARGA77VBV4HP5NQDZ"
  secret_key = "sNGocGo2qifXt156a0QMJpogTE5XC3goLFX7YuHC"
}


resource "aws_instance" "Sample" {
  ami           = "ami-08ee6644906ff4d6c"
  instance_type = "t2.micro"
  key_name = "pemkey"
  security_groups = ["terraform_sg"]
  
  tags = {
    Name = "Sample"
  }
}


resource "aws_security_group" "terraform_sg" {
  name = "terraform_sg"
  description = "security group"

  ingress {
	from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
	from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_sg"
  }
}
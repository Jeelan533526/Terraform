provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}


resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
	Owner = "Jeelanbasha"
	environment = "${var.environment}"
    }
}


resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
	tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnet-public" {
    count = "${length(var.public-cidrs)}"
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${element(var.public-cidrs, count.index)}"
    availability_zone = "${element(var.azs, count.index)}"

    tags = {
        Name = "${aws_vpc.default.tags.Name}-subnet-public-${count.index + 1}"
    }
}

resource "aws_subnet" "subnet-private" {
    count = "${length(var.private-cidrs)}"
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${element(var.private-cidrs, count.index)}"
    availability_zone = "${element(var.azs, count.index)}"

    tags = {
        Name = "${aws_vpc.default.tags.Name}-subnet-private-${count.index + 1}"
    }
}


resource "aws_route_table" "terraform-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table" "terraform-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.ngw.id}"
    }

    tags = {
        Name = "${var.Private_Routing_Table}"
    }
}

resource "aws_eip" "eipngw" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.eipngw.id}"
  subnet_id     = "${aws_subnet.subnet-public.0.id}"

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table_association" "terraform-public" {
    count = "${length(var.public-cidrs)}"
    subnet_id = "${element(aws_subnet.subnet-public.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform-public.id}"
}

resource "aws_route_table_association" "terraform-privatec" {
    count = "${length(var.private-cidrs)}"
    subnet_id = "${element(aws_subnet.subnet-private.*.id, count.index)}"
    route_table_id = "${aws_route_table.terraform-private.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

# data "aws_ami" "my_ami" {
#      most_recent      = true
#      #name_regex       = "^mavrick"
#      owners           = ["721834156908"]
# }


# resource "aws_instance" "web-1" {
#     ami = var.imagename
#     #ami = "ami-0d857ff0f5fc4e03b"
#     #ami = "${data.aws_ami.my_ami.id}"
#     availability_zone = "ap-south-1a"
#     instance_type = "t2.micro"
#     key_name = "LaptopKey"
#     subnet_id = "${aws_subnet.subnet1-public.id}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "Server-1"
#         Env = "Prod"
#         Owner = "Sree"
# 	CostCenter = "ABCD"
#     }
# }

##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
#packer validate --var-file creds.json packer.json
#packer build --var-file creds.json packer.json
#packer.exe build --var-file creds.json -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
#https://discuss.devopscube.com/t/how-to-get-the-ami-id-after-a-packer-build/36

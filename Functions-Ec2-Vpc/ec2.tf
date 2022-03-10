 resource "aws_instance" "public-servers" {
    count = 2
     #ami = var.imagename
     ami = "ami-0e0ff68cb8e9a188a"
     #ami = "${data.aws_ami.my_ami.id}"
     
#here availability_zone not mentioned bcz i have mentioned in subnet_id

     #availability_zone = "ap-south-1a"
     instance_type = "t2.micro"
     key_name = "pemkey"
     subnet_id = "${element(aws_subnet.subnet-public.*.id, count.index)}"
     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
     associate_public_ip_address = true	
     tags = {
         Name = "Public-server-${count.index+1}"
         
     }
 }

 resource "aws_instance" "private-servers" {
    count = 2
     #ami = var.imagename
     ami = "ami-0e0ff68cb8e9a188a"
     #ami = "${data.aws_ami.my_ami.id}"
     #availability_zone = "ap-south-1a"
     instance_type = "t2.micro"
     key_name = "pemkey"
     subnet_id = "${element(aws_subnet.subnet-private.*.id, count.index)}"
     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
     associate_public_ip_address = true	
     tags = {
         Name = "Private-server-${count.index+1}"
         
     }
 }
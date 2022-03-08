resource "aws_instance" "Docker-Jenkins" {
  ami           = "ami-08ee6644906ff4d6c"
  instance_type = "t2.micro"
  key_name = "pemkey"
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0f88e80871fd81e91"
  instance_type = "t2.micro"
  key_name      = "load"

  tags = {
    Name = "c8.local"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/frontend_ip.txt"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.micro"
  key_name      = "load"

  tags = {
    Name = "u21.local"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/backend_ip.txt"
  }
}

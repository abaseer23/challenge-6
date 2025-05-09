provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0c15e602d3d6c6c4a"
  instance_type = "t2.micro"
  key_name      = "load"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install epel -y
              sudo yum update -y
              sudo yum install python3 -y
              EOF
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
